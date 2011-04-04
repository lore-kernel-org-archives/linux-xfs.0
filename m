Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p34CqUmm167734 for <xfs@oss.sgi.com>; Mon, 4 Apr 2011 07:52:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48EE839DCE1
	for <xfs@oss.sgi.com>; Mon,  4 Apr 2011 05:55:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id C1undx5VkXKfC2t7 for
	<xfs@oss.sgi.com>; Mon, 04 Apr 2011 05:55:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q6jJo-0001O6-BM
	for xfs@oss.sgi.com; Mon, 04 Apr 2011 12:55:44 +0000
Date: Mon, 4 Apr 2011 08:55:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix variable set but not used warnings
Message-ID: <20110404125544.GA726@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

GCC 4.6 now warnings about variables set but not used.  Fix the trivially
fixable warnings of this sort.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2011-04-03 06:47:59.406434458 -0700
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2011-04-03 06:48:16.276433605 -0700
@@ -293,7 +293,6 @@ xfs_buf_allocate_memory(
 	size_t			nbytes, offset;
 	gfp_t			gfp_mask = xb_to_gfp(flags);
 	unsigned short		page_count, i;
-	pgoff_t			first;
 	xfs_off_t		end;
 	int			error;
 
@@ -333,7 +332,6 @@ use_alloc_page:
 		return error;
 
 	offset = bp->b_offset;
-	first = bp->b_file_offset >> PAGE_SHIFT;
 	bp->b_flags |= _XBF_PAGES;
 
 	for (i = 0; i < bp->b_page_count; i++) {
Index: linux-2.6/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6.orig/fs/xfs/quota/xfs_qm.c	2011-04-03 06:43:03.563116104 -0700
+++ linux-2.6/fs/xfs/quota/xfs_qm.c	2011-04-03 06:44:26.459778573 -0700
@@ -461,12 +461,10 @@ xfs_qm_dqflush_all(
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	int			recl;
 	struct xfs_dquot	*dqp;
-	int			niters;
 	int			error;
 
 	if (!q)
 		return 0;
-	niters = 0;
 again:
 	mutex_lock(&q->qi_dqlist_lock);
 	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
@@ -1314,14 +1312,9 @@ xfs_qm_dqiter_bufs(
 {
 	xfs_buf_t	*bp;
 	int		error;
-	int		notcommitted;
-	int		incr;
 	int		type;
 
 	ASSERT(blkcnt > 0);
-	notcommitted = 0;
-	incr = (blkcnt > XFS_QM_MAX_DQCLUSTER_LOGSZ) ?
-		XFS_QM_MAX_DQCLUSTER_LOGSZ : blkcnt;
 	type = flags & XFS_QMOPT_UQUOTA ? XFS_DQ_USER :
 		(flags & XFS_QMOPT_PQUOTA ? XFS_DQ_PROJ : XFS_DQ_GROUP);
 	error = 0;
Index: linux-2.6/fs/xfs/quota/xfs_qm.h
===================================================================
--- linux-2.6.orig/fs/xfs/quota/xfs_qm.h	2011-04-03 06:43:34.569781201 -0700
+++ linux-2.6/fs/xfs/quota/xfs_qm.h	2011-04-03 06:43:41.396447521 -0700
@@ -65,11 +65,6 @@ extern kmem_zone_t	*qm_dqtrxzone;
  * block in the dquot/xqm code.
  */
 #define XFS_DQUOT_CLUSTER_SIZE_FSB	(xfs_filblks_t)1
-/*
- * When doing a quotacheck, we log dquot clusters of this many FSBs at most
- * in a single transaction. We don't want to ask for too huge a log reservation.
- */
-#define XFS_QM_MAX_DQCLUSTER_LOGSZ	3
 
 typedef xfs_dqhash_t	xfs_dqlist_t;
 
Index: linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- linux-2.6.orig/fs/xfs/quota/xfs_qm_syscalls.c	2011-04-03 06:40:45.399789765 -0700
+++ linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c	2011-04-03 06:43:00.219782939 -0700
@@ -313,14 +313,12 @@ xfs_qm_scall_quotaon(
 {
 	int		error;
 	uint		qf;
-	uint		accflags;
 	__int64_t	sbflags;
 
 	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
 	/*
 	 * Switching on quota accounting must be done at mount time.
 	 */
-	accflags = flags & XFS_ALL_QUOTA_ACCT;
 	flags &= ~(XFS_ALL_QUOTA_ACCT);
 
 	sbflags = 0;
Index: linux-2.6/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_itable.c	2011-04-03 06:47:24.483102893 -0700
+++ linux-2.6/fs/xfs/xfs_itable.c	2011-04-03 06:47:47.356435070 -0700
@@ -204,7 +204,6 @@ xfs_bulkstat(
 	xfs_agi_t		*agi;	/* agi header data */
 	xfs_agino_t		agino;	/* inode # in allocation group */
 	xfs_agnumber_t		agno;	/* allocation group number */
-	xfs_daddr_t		bno;	/* inode cluster start daddr */
 	int			chunkidx; /* current index into inode chunk */
 	int			clustidx; /* current index into inode cluster */
 	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
@@ -463,7 +462,6 @@ xfs_bulkstat(
 						 mp->m_sb.sb_inopblog);
 				}
 				ino = XFS_AGINO_TO_INO(mp, agno, agino);
-				bno = XFS_AGB_TO_DADDR(mp, agno, agbno);
 				/*
 				 * Skip if this inode is free.
 				 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
