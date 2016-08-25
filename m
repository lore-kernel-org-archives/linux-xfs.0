Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B0DE982B4
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:53:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 82ECA8F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:53:42 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Cma82d5GSoDEB1Uz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:53:40 -0700 (PDT)
Subject: [PATCH 65/71] xfs_repair: check the refcount btree against our
	observed reference counts when -n
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:53:35 -0700
Message-ID: <147216921590.4420.3306219015258022080.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Check the observed reference counts against whatever's in the refcount
btree for discrepancies.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    4 +
 repair/phase4.c          |   20 +++++++
 repair/rmap.c            |  126 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h            |    5 ++
 repair/scan.c            |    3 +
 5 files changed, 158 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index b9eb2cf..28bac11 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -137,4 +137,8 @@
 #define xfs_prealloc_blocks		libxfs_prealloc_blocks
 #define xfs_dinode_good_version		libxfs_dinode_good_version
 
+#define xfs_refcountbt_init_cursor	libxfs_refcountbt_init_cursor
+#define xfs_refcount_lookup_le		libxfs_refcount_lookup_le
+#define xfs_refcount_get_rec		libxfs_refcount_get_rec
+
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/repair/phase4.c b/repair/phase4.c
index 2c2d611..395d373 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -223,6 +223,21 @@ _("%s while fixing inode reflink flags.\n"),
 }
 
 static void
+check_refcount_btrees(
+	work_queue_t	*wq,
+	xfs_agnumber_t	agno,
+	void		*arg)
+{
+	int		error;
+
+	error = check_refcounts(wq->mp, agno);
+	if (error)
+		do_error(
+_("%s while checking reference counts"),
+			 strerror(-error));
+}
+
+static void
 process_rmap_data(
 	struct xfs_mount	*mp)
 {
@@ -249,6 +264,11 @@ process_rmap_data(
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, process_inode_reflink_flags, i, NULL);
 	destroy_work_queue(&wq);
+
+	create_work_queue(&wq, mp, libxfs_nproc());
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+		queue_work(&wq, check_refcount_btrees, i, NULL);
+	destroy_work_queue(&wq);
 }
 
 void
diff --git a/repair/rmap.c b/repair/rmap.c
index 5206206..c53d6b7 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -47,6 +47,7 @@ struct xfs_ag_rmap {
 
 static struct xfs_ag_rmap *ag_rmaps;
 static bool rmapbt_suspect;
+static bool refcbt_suspect;
 
 /*
  * Compare rmap observations for array sorting.
@@ -1235,6 +1236,131 @@ _("Unable to fix reflink flag on inode %"PRIu64".\n"),
 }
 
 /*
+ * Return the number of refcount objects for an AG.
+ */
+size_t
+refcount_record_count(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t		agno)
+{
+	return slab_count(ag_rmaps[agno].ar_refcount_items);
+}
+
+/*
+ * Return a slab cursor that will return refcount objects in order.
+ */
+int
+init_refcount_cursor(
+	xfs_agnumber_t		agno,
+	struct xfs_slab_cursor	**cur)
+{
+	return init_slab_cursor(ag_rmaps[agno].ar_refcount_items, NULL, cur);
+}
+
+/*
+ * Disable the refcount btree check.
+ */
+void
+refcount_avoid_check(void)
+{
+	refcbt_suspect = true;
+}
+
+/*
+ * Compare the observed reference counts against what's in the ag btree.
+ */
+int
+check_refcounts(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_slab_cursor	*rl_cur;
+	struct xfs_btree_cur	*bt_cur = NULL;
+	int			error;
+	int			have;
+	int			i;
+	struct xfs_buf		*agbp = NULL;
+	struct xfs_refcount_irec	*rl_rec;
+	struct xfs_refcount_irec	tmp;
+	struct xfs_perag	*pag;		/* per allocation group data */
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+	if (refcbt_suspect) {
+		if (no_modify && agno == 0)
+			do_warn(_("would rebuild corrupt refcount btrees.\n"));
+		return 0;
+	}
+
+	/* Create cursors to refcount structures */
+	error = init_refcount_cursor(agno, &rl_cur);
+	if (error)
+		return error;
+
+	error = -libxfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		goto err;
+
+	/* Leave the per-ag data "uninitialized" since we rewrite it later */
+	pag = libxfs_perag_get(mp, agno);
+	pag->pagf_init = 0;
+	libxfs_perag_put(pag);
+
+	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
+	if (!bt_cur) {
+		error = -ENOMEM;
+		goto err;
+	}
+
+	rl_rec = pop_slab_cursor(rl_cur);
+	while (rl_rec) {
+		/* Look for a refcount record in the btree */
+		error = -libxfs_refcount_lookup_le(bt_cur,
+				rl_rec->rc_startblock, &have);
+		if (error)
+			goto err;
+		if (!have) {
+			do_warn(
+_("Missing reference count record for (%u/%u) len %u count %u\n"),
+				agno, rl_rec->rc_startblock,
+				rl_rec->rc_blockcount, rl_rec->rc_refcount);
+			goto next_loop;
+		}
+
+		error = -libxfs_refcount_get_rec(bt_cur, &tmp, &i);
+		if (error)
+			goto err;
+		if (!i) {
+			do_warn(
+_("Missing reference count record for (%u/%u) len %u count %u\n"),
+				agno, rl_rec->rc_startblock,
+				rl_rec->rc_blockcount, rl_rec->rc_refcount);
+			goto next_loop;
+		}
+
+		/* Compare each refcount observation against the btree's */
+		if (tmp.rc_startblock != rl_rec->rc_startblock ||
+		    tmp.rc_blockcount < rl_rec->rc_blockcount ||
+		    tmp.rc_refcount < rl_rec->rc_refcount)
+			do_warn(
+_("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) len %u nlinks %u\n"),
+				agno, tmp.rc_startblock, tmp.rc_blockcount,
+				tmp.rc_refcount, agno, rl_rec->rc_startblock,
+				rl_rec->rc_blockcount, rl_rec->rc_refcount);
+next_loop:
+		rl_rec = pop_slab_cursor(rl_cur);
+	}
+
+err:
+	if (bt_cur)
+		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+	if (agbp)
+		libxfs_putbuf(agbp);
+	free_slab_cursor(&rl_cur);
+	return 0;
+}
+
+/*
  * Regenerate the AGFL so that we don't run out of it while rebuilding the
  * rmap btree.  If skip_rmapbt is true, don't update the rmapbt (most probably
  * because we're updating the rmapbt).
diff --git a/repair/rmap.h b/repair/rmap.h
index 266448f..752ece8 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -50,6 +50,11 @@ extern void rmap_high_key_from_rec(struct xfs_rmap_irec *rec,
 		struct xfs_rmap_irec *key);
 
 extern int compute_refcounts(struct xfs_mount *, xfs_agnumber_t);
+extern size_t refcount_record_count(struct xfs_mount *, xfs_agnumber_t);
+extern int init_refcount_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
+extern void refcount_avoid_check(void);
+extern int check_refcounts(struct xfs_mount *, xfs_agnumber_t);
+
 extern void record_inode_reflink_flag(struct xfs_mount *, struct xfs_dinode *,
 	xfs_agnumber_t, xfs_agino_t, xfs_ino_t);
 extern int fix_inode_reflink_flags(struct xfs_mount *, xfs_agnumber_t);
diff --git a/repair/scan.c b/repair/scan.c
index d3a1a82..1c60784 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1370,6 +1370,8 @@ _("%s btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		}
 	}
 out:
+	if (suspect)
+		refcount_avoid_check();
 	return;
 }
 
@@ -2173,6 +2175,7 @@ validate_agf(
 		} else  {
 			do_warn(_("bad agbno %u for refcntbt root, agno %d\n"),
 				bno, agno);
+			refcount_avoid_check();
 		}
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
