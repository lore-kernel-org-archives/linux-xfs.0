Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9C8D229DFC
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:27:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8B6388F8035
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:27:13 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 9DQjAKldauHUcZGP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:27:12 -0700 (PDT)
Subject: [PATCH 14/15] xfs_repair: check the rlbt against our observed
	reference counts when -n
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 20:27:09 -0700
Message-ID: <20150630032709.572.61038.stgit@birch.djwong.org>
In-Reply-To: <20150630032538.572.20293.stgit@birch.djwong.org>
References: <20150630032538.572.20293.stgit@birch.djwong.org>
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

Check the observed reference counts against whatever's in the reflink
btree for discrepancies.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase4.c |   20 ++++++++++
 repair/rmap.c   |  113 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.h   |    6 +++
 3 files changed, 139 insertions(+)


diff --git a/repair/phase4.c b/repair/phase4.c
index 64627a5..9577e34 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -188,6 +188,21 @@ _("%s while fixing inode reflink flags.\n"),
 }
 
 static void
+check_reflink_btrees(
+	work_queue_t	*wq,
+	xfs_agnumber_t	agno,
+	void		*arg)
+{
+	int		error;
+
+	error = reflink_check_refcounts(wq->mp, agno);
+	if (error)
+		do_error(
+_("%s while checking reference counts"),
+			 strerror(-error));
+}
+
+static void
 process_rmaps(
 	xfs_mount_t		*mp)
 {
@@ -210,6 +225,11 @@ process_rmaps(
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, process_inode_reflink_flags, i, NULL);
 	destroy_work_queue(&wq);
+
+	create_work_queue(&wq, mp, libxfs_nproc());
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
+		queue_work(&wq, check_reflink_btrees, i, NULL);
+	destroy_work_queue(&wq);
 }
 
 void
diff --git a/repair/rmap.c b/repair/rmap.c
index cc34570..6c6d5ae 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -614,3 +614,116 @@ _("Unable to fix reflink flag on inode %"PRIu64".\n"),
 
 	return error;
 }
+
+/**
+ * reflink_count() -- Return the number of reflink objects for an AG.
+ */
+size_t
+reflink_count(
+	xfs_mount_t		*mp,
+	xfs_agnumber_t		agno)
+{
+	return slab_count(ag_rmaps[agno].ar_reflink_items);
+}
+
+/**
+ * init_reflink_cursor() -- Return a slab cursor that will return reflink
+ *                          objects in order.
+ * @agno: AG number.
+ * @cur: The new cursor.
+ */
+int
+init_reflink_cursor(
+	xfs_agnumber_t		agno,
+	xfs_slab_cursor_t	**cur)
+{
+	return init_slab_cursor(ag_rmaps[agno].ar_reflink_items, NULL, cur);
+}
+
+/**
+ * reflink_check_refcounts() -- Compare the observed reference counts against
+ * 				what's in the ag btree.
+ * @mp: XFS mount object
+ * @agno: AG number
+ */
+int
+reflink_check_refcounts(
+	xfs_mount_t		*mp,
+	xfs_agnumber_t		agno)
+{
+	xfs_slab_cursor_t	*rl_cur;
+	struct xfs_btree_cur	*bt_cur = NULL;
+	int 			error;
+	int			have;
+	int			i;
+	struct xfs_buf		*agbp = NULL;
+	xfs_agblock_t		lbno;
+	xfs_extlen_t		llen;
+	xfs_nlink_t		lnr;
+	xfs_reflink_rec_incore_t	*rl_rec;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return 0;
+
+	/* Create cursors to refcount structures */
+	error = init_reflink_cursor(agno, &rl_cur);
+	if (error)
+		return error;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		goto err;
+
+	bt_cur = xfs_reflinkbt_init_cursor(mp, NULL, agbp, agno);
+	if (!bt_cur) {
+		error = -ENOMEM;
+		goto err;
+	}
+
+	rl_rec = pop_slab_cursor(rl_cur);
+	while (rl_rec) {
+		/* Look for a refcount record in the btree */
+		error = xfs_reflink_lookup_le(bt_cur,
+				rl_rec->rr_startblock, &have);
+		if (error)
+			goto err;
+		if (!have) {
+			do_warn(
+_("Missing reference count record for (%u/%u) len %u count %u\n"),
+				agno, rl_rec->rr_startblock,
+				rl_rec->rr_blockcount, rl_rec->rr_nlinks);
+			goto next_loop;
+		}
+
+		error = xfs_reflink_get_rec(bt_cur, &lbno, &llen, &lnr, &i);
+		if (error)
+			goto err;
+		if (!i) {
+			do_warn(
+_("Missing reference count record for (%u/%u) len %u count %u\n"),
+				agno, rl_rec->rr_startblock,
+				rl_rec->rr_blockcount, rl_rec->rr_nlinks);
+			goto next_loop;
+		}
+
+		/* Compare each refcount observation against the btree's */
+		if (lbno != rl_rec->rr_startblock ||
+		    llen < rl_rec->rr_blockcount ||
+		    lnr < rl_rec->rr_nlinks)
+			do_warn(
+_("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) len %u nlinks %u\n"),
+				agno, lbno, llen, lnr,
+				agno, rl_rec->rr_startblock,
+				rl_rec->rr_blockcount, rl_rec->rr_nlinks);
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
diff --git a/repair/rmap.h b/repair/rmap.h
index 7dc709f..efb24cd 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -35,4 +35,10 @@ extern int reflink_fix_inode_flags(xfs_mount_t *mp, xfs_agnumber_t agno);
 
 extern int rebuild_ag_rlrmap_records(xfs_mount_t *mp, xfs_agnumber_t agno);
 
+extern size_t reflink_count(xfs_mount_t *mp, xfs_agnumber_t agno);
+
+extern int init_reflink_cursor(xfs_agnumber_t agno, xfs_slab_cursor_t **cur);
+
+extern int reflink_check_refcounts(xfs_mount_t *mp, xfs_agnumber_t agno);
+
 #endif /* RMAP_H_ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
