Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55EmcHm093247 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 09:48:39 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	AlnS2GKIjaJ6fkFh (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 07:48:36 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Sbv3j-0004zh-U2
	for xfs@oss.sgi.com; Tue, 05 Jun 2012 14:48:35 +0000
Message-Id: <20120605144835.887274634@bombadil.infradead.org>
Date: Tue, 05 Jun 2012 10:46:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/7] xfs: remove the alloc_done argument to xfs_dialloc
References: <20120605144647.051012936@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-xfs_dialloc
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We can simplify check the IO_agbp pointer for being non-NULL instead of
passing another argument through two layers of function calls.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_ialloc.c |    4 ----
 fs/xfs/xfs_ialloc.h |    2 --
 fs/xfs/xfs_inode.c  |    5 ++---
 fs/xfs/xfs_inode.h  |    2 +-
 fs/xfs/xfs_utils.c  |   17 +++++++----------
 5 files changed, 10 insertions(+), 20 deletions(-)

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2012-06-04 12:48:26.004248480 -0400
+++ xfs/fs/xfs/xfs_ialloc.c	2012-06-04 12:49:26.040250019 -0400
@@ -895,8 +895,6 @@ xfs_dialloc(
 	umode_t		mode,		/* mode bits for new inode */
 	int		okalloc,	/* ok to allocate more space */
 	xfs_buf_t	**IO_agbp,	/* in/out ag header's buffer */
-	boolean_t	*alloc_done,	/* true if we needed to replenish
-					   inode freelist */
 	xfs_ino_t	*inop)		/* inode number allocated */
 {
 	xfs_buf_t	*agbp;		/* allocation group header's buffer */
@@ -956,7 +954,6 @@ xfs_dialloc(
 	 * or in which we can allocate some inodes.  Iterate through the
 	 * allocation groups upward, wrapping at the end.
 	 */
-	*alloc_done = B_FALSE;
 	while (!agi->agi_freecount) {
 		/*
 		 * Don't do anything if we're not supposed to allocate
@@ -983,7 +980,6 @@ xfs_dialloc(
 				 * us again where we left off.
 				 */
 				ASSERT(be32_to_cpu(agi->agi_freecount) > 0);
-				*alloc_done = B_TRUE;
 				*IO_agbp = agbp;
 				*inop = NULLFSINO;
 				return 0;
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2012-06-04 12:47:39.368247288 -0400
+++ xfs/fs/xfs/xfs_inode.c	2012-06-04 12:49:26.040250019 -0400
@@ -970,7 +970,6 @@ xfs_ialloc(
 	prid_t		prid,
 	int		okalloc,
 	xfs_buf_t	**ialloc_context,
-	boolean_t	*call_again,
 	xfs_inode_t	**ipp)
 {
 	xfs_ino_t	ino;
@@ -985,10 +984,10 @@ xfs_ialloc(
 	 * the on-disk inode to be allocated.
 	 */
 	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode, okalloc,
-			    ialloc_context, call_again, &ino);
+			    ialloc_context, &ino);
 	if (error)
 		return error;
-	if (*call_again || ino == NULLFSINO) {
+	if (*ialloc_context || ino == NULLFSINO) {
 		*ipp = NULL;
 		return 0;
 	}
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2012-06-04 12:47:39.368247288 -0400
+++ xfs/fs/xfs/xfs_inode.h	2012-06-04 12:49:26.040250019 -0400
@@ -517,7 +517,7 @@ void		xfs_inode_free(struct xfs_inode *i
  */
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, umode_t,
 			   xfs_nlink_t, xfs_dev_t, prid_t, int,
-			   struct xfs_buf **, boolean_t *, xfs_inode_t **);
+			   struct xfs_buf **, xfs_inode_t **);
 
 uint		xfs_ip2xflags(struct xfs_inode *);
 uint		xfs_dic2xflags(struct xfs_dinode *);
Index: xfs/fs/xfs/xfs_utils.c
===================================================================
--- xfs.orig/fs/xfs/xfs_utils.c	2012-06-04 12:47:39.368247288 -0400
+++ xfs/fs/xfs/xfs_utils.c	2012-06-04 12:49:26.040250019 -0400
@@ -65,7 +65,6 @@ xfs_dir_ialloc(
 	xfs_trans_t	*ntp;
 	xfs_inode_t	*ip;
 	xfs_buf_t	*ialloc_context = NULL;
-	boolean_t	call_again = B_FALSE;
 	int		code;
 	uint		log_res;
 	uint		log_count;
@@ -91,7 +90,7 @@ xfs_dir_ialloc(
 	 * the inode(s) that we've just allocated.
 	 */
 	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, okalloc,
-			  &ialloc_context, &call_again, &ip);
+			  &ialloc_context, &ip);
 
 	/*
 	 * Return an error if we were unable to allocate a new inode.
@@ -102,19 +101,18 @@ xfs_dir_ialloc(
 		*ipp = NULL;
 		return code;
 	}
-	if (!call_again && (ip == NULL)) {
+	if (!ialloc_context && !ip) {
 		*ipp = NULL;
 		return XFS_ERROR(ENOSPC);
 	}
 
 	/*
-	 * If call_again is set, then we were unable to get an
+	 * If the AGI buffer is non-NULL, then we were unable to get an
 	 * inode in one operation.  We need to commit the current
 	 * transaction and call xfs_ialloc() again.  It is guaranteed
 	 * to succeed the second time.
 	 */
-	if (call_again) {
-
+	if (ialloc_context) {
 		/*
 		 * Normally, xfs_trans_commit releases all the locks.
 		 * We call bhold to hang on to the ialloc_context across
@@ -195,7 +193,7 @@ xfs_dir_ialloc(
 		 * this call should always succeed.
 		 */
 		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
-				  okalloc, &ialloc_context, &call_again, &ip);
+				  okalloc, &ialloc_context, &ip);
 
 		/*
 		 * If we get an error at this point, return to the caller
@@ -206,12 +204,11 @@ xfs_dir_ialloc(
 			*ipp = NULL;
 			return code;
 		}
-		ASSERT ((!call_again) && (ip != NULL));
+		ASSERT(!ialloc_context && ip);
 
 	} else {
-		if (committed != NULL) {
+		if (committed != NULL)
 			*committed = 0;
-		}
 	}
 
 	*ipp = ip;
Index: xfs/fs/xfs/xfs_ialloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.h	2012-06-04 12:47:39.368247288 -0400
+++ xfs/fs/xfs/xfs_ialloc.h	2012-06-04 12:49:26.040250019 -0400
@@ -75,8 +75,6 @@ xfs_dialloc(
 	umode_t		mode,		/* mode bits for new inode */
 	int		okalloc,	/* ok to allocate more space */
 	struct xfs_buf	**agbp,		/* buf for a.g. inode header */
-	boolean_t	*alloc_done,	/* an allocation was done to replenish
-					   the free inodes */
 	xfs_ino_t	*inop);		/* inode number allocated */
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
