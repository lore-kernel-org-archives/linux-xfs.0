Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 53A9C7F9D
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 05:55:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49E41304064
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 03:54:58 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id yq1UqzbVnxljElat (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2015 03:54:55 -0700 (PDT)
Received: from [88.128.80.44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z5Azf-0002Ba-1X
	for xfs@oss.sgi.com; Wed, 17 Jun 2015 10:54:55 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] libxfs: switch the remaining xfs_trans_dup user to
	xfs_trans_roll
Date: Wed, 17 Jun 2015 12:52:58 +0200
Message-Id: <1434538381-4847-2-git-send-email-hch@lst.de>
In-Reply-To: <1434538381-4847-1-git-send-email-hch@lst.de>
References: <1434538381-4847-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Match the kernel API change.  Also libxfs_trans_dup can be folded into
the only caller now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trans.h      |  1 -
 libxfs/libxfs_api_defs.h |  1 -
 libxfs/trans.c           | 21 +++++----------------
 libxfs/util.c            | 14 +++-----------
 4 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 302af35..46c2955 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -87,7 +87,6 @@ void	xfs_trans_init(struct xfs_mount *);
 int	xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 
 xfs_trans_t	*libxfs_trans_alloc(struct xfs_mount *, int);
-xfs_trans_t	*libxfs_trans_dup(struct xfs_trans *);
 int	libxfs_trans_reserve(struct xfs_trans *, struct xfs_trans_res *,
 				     uint, uint);
 int	libxfs_trans_commit(struct xfs_trans *, uint);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index f843e7d..e9fd9c8 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -40,7 +40,6 @@
 #define xfs_trans_commit		libxfs_trans_commit
 #define xfs_trans_cancel		libxfs_trans_cancel
 #define xfs_trans_del_item		libxfs_trans_del_item
-#define xfs_trans_dup			libxfs_trans_dup
 #define xfs_trans_get_buf		libxfs_trans_get_buf
 #define xfs_trans_getsb			libxfs_trans_getsb
 #define xfs_trans_iget			libxfs_trans_iget
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 885c5f4..9a44af4 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -109,14 +109,15 @@ libxfs_trans_roll(
 	 * Ensure that the inode is always logged.
 	 */
 	trans = *tpp;
-	xfs_trans_log_inode(trans, dp, XFS_ILOG_CORE);
+	if (dp)
+		xfs_trans_log_inode(trans, dp, XFS_ILOG_CORE);
 
 	/*
 	 * Copy the critical parameters from one trans to the next.
 	 */
 	tres.tr_logres = trans->t_log_res;
 	tres.tr_logcount = trans->t_log_count;
-	*tpp = xfs_trans_dup(trans);
+	*tpp = libxfs_trans_alloc(trans->t_mountp, trans->t_type);
 
 	/*
 	 * Commit the current transaction.
@@ -147,7 +148,8 @@ libxfs_trans_roll(
 	if (error)
 		return error;
 
-	xfs_trans_ijoin(trans, dp, 0);
+	if (dp)
+		xfs_trans_ijoin(trans, dp, 0);
 	return 0;
 }
 
@@ -172,19 +174,6 @@ libxfs_trans_alloc(
 	return ptr;
 }
 
-xfs_trans_t *
-libxfs_trans_dup(
-	xfs_trans_t	*tp)
-{
-	xfs_trans_t	*ptr;
-
-	ptr = libxfs_trans_alloc(tp->t_mountp, tp->t_type);
-#ifdef XACT_DEBUG
-	fprintf(stderr, "duplicated transaction %p (new=%p)\n", tp, ptr);
-#endif
-	return ptr;
-}
-
 int
 libxfs_trans_reserve(
 	struct xfs_trans	*tp,
diff --git a/libxfs/util.c b/libxfs/util.c
index a6b1fd1..daebbe2 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -641,7 +641,6 @@ libxfs_inode_alloc(
 {
 	xfs_buf_t	*ialloc_context;
 	xfs_inode_t	*ip;
-	xfs_trans_t	*ntp;
 	int		error;
 
 	ialloc_context = (xfs_buf_t *)0;
@@ -657,19 +656,12 @@ libxfs_inode_alloc(
 	}
 
 	if (ialloc_context) {
-		struct xfs_trans_res	tres;
 
 		xfs_trans_bhold(*tp, ialloc_context);
-		tres.tr_logres = (*tp)->t_log_res;
-		tres.tr_logcount = (*tp)->t_log_count;
-
-		ntp = xfs_trans_dup(*tp);
-		xfs_trans_commit(*tp, 0);
-		*tp = ntp;
-		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		error = xfs_trans_reserve(*tp, &tres, 0, 0);
+
+		error = xfs_trans_roll(tp, NULL);
 		if (error) {
-			fprintf(stderr, _("%s: cannot reserve space: %s\n"),
+			fprintf(stderr, _("%s: cannot duplicate transaction: %s\n"),
 				progname, strerror(error));
 			exit(1);
 		}
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
