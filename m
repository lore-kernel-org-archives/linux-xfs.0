Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAJFpdcN034526 for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 09:51:40 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1212712CDE6D
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 07:52:01 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Qh4z1v66kchUz15P for
	<xfs@oss.sgi.com>; Thu, 19 Nov 2009 07:52:01 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 65D7AAAE3B8
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 09:52:00 -0600 (CST)
Message-ID: <4B0569A0.10405@sandeen.net>
Date: Thu, 19 Nov 2009 09:52:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs: make several more functions static
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Just minor housekeeping, a lot more functions can be trivially
made static; others could if we reordered things a bit...

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 961df0a..0efac5a 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -343,7 +343,7 @@ xfs_commit_dummy_trans(
 	return error;
 }
 
-int
+STATIC int
 xfs_sync_fsdata(
 	struct xfs_mount	*mp,
 	int			flags)
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 27920eb..2a11e62 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -37,7 +37,6 @@ void xfs_syncd_stop(struct xfs_mount *mp);
 
 int xfs_sync_attr(struct xfs_mount *mp, int flags);
 int xfs_sync_data(struct xfs_mount *mp, int flags);
-int xfs_sync_fsdata(struct xfs_mount *mp, int flags);
 
 int xfs_quiesce_data(struct xfs_mount *mp);
 void xfs_quiesce_attr(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 4ece190..4b06613 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -196,7 +196,7 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-int
+STATIC int
 xfs_attr_calc_size(
 	struct xfs_inode 	*ip,
 	int			namelen,
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index fb3b2a6..8b2d31c 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -129,7 +129,6 @@ typedef struct xfs_attr_list_context {
 /*
  * Overall external interface routines.
  */
-int xfs_attr_calc_size(struct xfs_inode *, int, int, int *);
 int xfs_attr_inactive(struct xfs_inode *dp);
 int xfs_attr_fetch(struct xfs_inode *, struct xfs_name *, char *, int *, int);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index eb7b702..c9e74a5 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -335,7 +335,7 @@ xfs_bmbt_disk_set_allf(
 /*
  * Set all the fields in a bmap extent record from the uncompressed form.
  */
-void
+STATIC void
 xfs_bmbt_disk_set_all(
 	xfs_bmbt_rec_t	*r,
 	xfs_bmbt_irec_t *s)
diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
index 5549d49..320725c 100644
--- a/fs/xfs/xfs_bmap_btree.h
+++ b/fs/xfs/xfs_bmap_btree.h
@@ -231,7 +231,6 @@ extern void xfs_bmbt_set_startblock(xfs_bmbt_rec_host_t *r, xfs_fsblock_t v);
 extern void xfs_bmbt_set_startoff(xfs_bmbt_rec_host_t *r, xfs_fileoff_t v);
 extern void xfs_bmbt_set_state(xfs_bmbt_rec_host_t *r, xfs_exntst_t v);
 
-extern void xfs_bmbt_disk_set_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
 extern void xfs_bmbt_disk_set_allf(xfs_bmbt_rec_t *r, xfs_fileoff_t o,
 			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
 
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 5a81ccd..4cf6592 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -65,7 +65,7 @@ static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
 /*
  * Log entries from a freespace block.
  */
-void
+STATIC void
 xfs_dir2_free_log_bests(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_dabuf_t		*bp,		/* freespace buffer */
diff --git a/fs/xfs/xfs_dir2_node.h b/fs/xfs/xfs_dir2_node.h
index dde72db..82dfe71 100644
--- a/fs/xfs/xfs_dir2_node.h
+++ b/fs/xfs/xfs_dir2_node.h
@@ -75,8 +75,6 @@ xfs_dir2_db_to_fdindex(struct xfs_mount *mp, xfs_dir2_db_t db)
 	return ((db) % XFS_DIR2_MAX_FREE_BESTS(mp));
 }
 
-extern void xfs_dir2_free_log_bests(struct xfs_trans *tp, struct xfs_dabuf *bp,
-				    int first, int last);
 extern int xfs_dir2_leaf_to_node(struct xfs_da_args *args,
 				 struct xfs_dabuf *lbp);
 extern xfs_dahash_t xfs_dir2_leafn_lasthash(struct xfs_dabuf *bp, int *count);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 679c7c4..87f2563 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -445,14 +445,9 @@ typedef struct log {
 
 /* common routines */
 extern xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
-extern int	 xlog_find_tail(xlog_t	*log,
-				xfs_daddr_t *head_blk,
-				xfs_daddr_t *tail_blk);
 extern int	 xlog_recover(xlog_t *log);
 extern int	 xlog_recover_finish(xlog_t *log);
 extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
-extern struct xfs_buf *xlog_get_bp(xlog_t *, int);
-extern void	 xlog_put_bp(struct xfs_buf *);
 
 extern kmem_zone_t	*xfs_log_ticket_zone;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1099395..96ac2ca 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -67,7 +67,7 @@ STATIC void	xlog_recover_check_summary(xlog_t *);
 	((bbs + (log)->l_sectbb_mask + 1) & ~(log)->l_sectbb_mask) : (bbs) )
 #define XLOG_SECTOR_ROUNDDOWN_BLKNO(log, bno)	((bno) & ~(log)->l_sectbb_mask)
 
-xfs_buf_t *
+STATIC xfs_buf_t *
 xlog_get_bp(
 	xlog_t		*log,
 	int		nbblks)
@@ -87,7 +87,7 @@ xlog_get_bp(
 	return xfs_buf_get_noaddr(BBTOB(nbblks), log->l_mp->m_logdev_targp);
 }
 
-void
+STATIC_INLINE void
 xlog_put_bp(
 	xfs_buf_t	*bp)
 {
@@ -810,7 +810,7 @@ xlog_find_head(
  * We could speed up search by using current head_blk buffer, but it is not
  * available.
  */
-int
+STATIC int
 xlog_find_tail(
 	xlog_t			*log,
 	xfs_daddr_t		*head_blk,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
