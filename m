Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1799529E7C
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:10:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9D596AC004
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:10:31 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id w0CoXJAtAHK0TEa5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:10:29 -0800 (PST)
Subject: [PATCH 49/53] xfs_repair: check the refcount btree against our
	observed reference counts when -n
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:10:25 -0800
Message-ID: <20151219091025.14255.77057.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Check the observed reference counts against whatever's in the refcount
btree for discrepancies.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase4.c |   20 ++++++++
 repair/rmap.c   |  135 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h   |    4 ++
 repair/scan.c   |    2 +
 4 files changed, 161 insertions(+)


diff --git a/repair/phase4.c b/repair/phase4.c
index caa4221..dd03ca4 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -213,6 +213,21 @@ _("%s while fixing inode reflink flags.\n"),
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
@@ -239,6 +254,11 @@ process_rmap_data(
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
index 05e3c98..0fa2c33 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -45,6 +45,7 @@ struct xfs_ag_rmap {
 
 static struct xfs_ag_rmap *ag_rmaps;
 static bool rmapbt_suspect;
+static bool refcbt_suspect;
 
 /*
  * Compare rmap observations for array sorting.
@@ -1170,6 +1171,140 @@ _("Unable to fix reflink flag on inode %"PRIu64".\n"),
 }
 
 /**
+ * refcount_record_count() -- Return the number of refcount objects for an AG.
+ *
+ * @mp: XFS mount object
+ * @agno: AG number
+ */
+size_t
+refcount_record_count(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t		agno)
+{
+	return slab_count(ag_rmaps[agno].ar_refcount_items);
+}
+
+/**
+ * init_refcount_cursor() -- Return a slab cursor that will return refcount
+ *                           objects in order.
+ * @agno: AG number.
+ * @cur: The new cursor.
+ */
+int
+init_refcount_cursor(
+	xfs_agnumber_t		agno,
+	struct xfs_slab_cursor	**cur)
+{
+	return init_slab_cursor(ag_rmaps[agno].ar_refcount_items, NULL, cur);
+}
+
+/**
+ * refcount_avoid_check() -- Disable the refcount btree check.
+ */
+void
+refcount_avoid_check(void)
+{
+	refcbt_suspect = true;
+}
+
+/**
+ * check_refcounts() -- Compare the observed reference counts against
+ *			what's in the ag btree.
+ * @mp: XFS mount object
+ * @agno: AG number
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
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		goto err;
+
+	/* Leave the per-ag data "uninitialized" since we rewrite it later */
+	pag = xfs_perag_get(mp, agno);
+	pag->pagf_init = 0;
+	xfs_perag_put(pag);
+
+	bt_cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
+	if (!bt_cur) {
+		error = -ENOMEM;
+		goto err;
+	}
+
+	rl_rec = pop_slab_cursor(rl_cur);
+	while (rl_rec) {
+		/* Look for a refcount record in the btree */
+		error = xfs_refcountbt_lookup_le(bt_cur,
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
+		error = xfs_refcountbt_get_rec(bt_cur, &tmp, &i);
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
+		xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+	if (agbp)
+		libxfs_putbuf(agbp);
+	free_slab_cursor(&rl_cur);
+	return 0;
+}
+
+/**
  * fix_freelist() - Regenerate the AGFL, so that we don't run out of it while
  *		    rebuilding the rmapbt.
  * @mp: XFS mount object
diff --git a/repair/rmap.h b/repair/rmap.h
index d0bcde1..df7d489 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -40,6 +40,10 @@ extern void rmap_avoid_check(void);
 extern int check_rmaps(struct xfs_mount *, xfs_agnumber_t);
 
 extern int compute_refcounts(struct xfs_mount *, xfs_agnumber_t);
+extern size_t refcount_record_count(struct xfs_mount *, xfs_agnumber_t);
+extern int init_refcount_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
+extern void refcount_avoid_check(void);
+extern int check_refcounts(struct xfs_mount *, xfs_agnumber_t);
 
 extern void record_inode_reflink_flag(struct xfs_mount *, struct xfs_dinode *,
 	xfs_agnumber_t, xfs_agino_t, xfs_ino_t);
diff --git a/repair/scan.c b/repair/scan.c
index 54b9b68..3e8633c 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1257,6 +1257,8 @@ _("%s btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		}
 	}
 out:
+	if (suspect)
+		refcount_avoid_check();
 	return;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
