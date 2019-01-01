Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43450 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfAACUU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:20:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012GBJb019693
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:19 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2pp0btp79q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:20:19 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012KIUG008126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:18 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012KI46026139
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:20:18 GMT
Subject: [PATCH 12/22] xfs: move xfs_dir_ialloc to libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:20:17 -0800
Message-ID: <154630921721.18437.4971993273804850177.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move xfs_dir_ialloc to libxfs, and make xfs_ialloc static since we only
needed it to be non-static temporarily.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |  108 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    4 +
 fs/xfs/xfs_inode.c             |  106 ---------------------------------------
 fs/xfs/xfs_inode.h             |    4 -
 4 files changed, 109 insertions(+), 113 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 6c548015a882..fa9baea5be6d 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -360,7 +360,7 @@ xfs_inode_init(
  * are not linked into the directory structure - they are attached
  * directly to the superblock - and so have no parent.
  */
-int
+STATIC int
 xfs_ialloc(
 	struct xfs_trans		*tp,
 	const struct xfs_ialloc_args	*args,
@@ -413,3 +413,109 @@ xfs_ialloc(
 	*ipp = ip;
 	return 0;
 }
+
+/*
+ * Allocates a new inode from disk and return a pointer to the
+ * incore copy. This routine will internally commit the current
+ * transaction and allocate a new one if the Space Manager needed
+ * to do an allocation to replenish the inode free-list.
+ *
+ * This routine is designed to be called from xfs_create and
+ * xfs_create_dir.
+ *
+ */
+int
+xfs_dir_ialloc(
+	struct xfs_trans		**tpp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_trans		*tp;
+	struct xfs_inode		*ip;
+	struct xfs_buf			*ialloc_context = NULL;
+	int				error;
+
+	tp = *tpp;
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	/*
+	 * xfs_ialloc will return a pointer to an incore inode if
+	 * the Space Manager has an available inode on the free
+	 * list. Otherwise, it will do an allocation and replenish
+	 * the freelist.  Since we can only do one allocation per
+	 * transaction without deadlocks, we will need to commit the
+	 * current transaction and start a new one.  We will then
+	 * need to call xfs_ialloc again to get the inode.
+	 *
+	 * If xfs_ialloc did an allocation to replenish the freelist,
+	 * it returns the bp containing the head of the freelist as
+	 * ialloc_context. We will hold a lock on it across the
+	 * transaction commit so that no other process can steal
+	 * the inode(s) that we've just allocated.
+	 */
+	error = xfs_ialloc(tp, args, &ialloc_context, &ip);
+
+	/*
+	 * Return an error if we were unable to allocate a new inode.
+	 * This should only happen if we run out of space on disk or
+	 * encounter a disk error.
+	 */
+	if (error) {
+		*ipp = NULL;
+		return error;
+	}
+	if (!ialloc_context && !ip) {
+		*ipp = NULL;
+		return -ENOSPC;
+	}
+
+	/*
+	 * If the AGI buffer is non-NULL, then we were unable to get an
+	 * inode in one operation.  We need to commit the current
+	 * transaction and call xfs_ialloc() again.  It is guaranteed
+	 * to succeed the second time.
+	 */
+	if (ialloc_context) {
+		/*
+		 * Normally, xfs_trans_commit releases all the locks.
+		 * We call bhold to hang on to the ialloc_context across
+		 * the commit.  Holding this buffer prevents any other
+		 * processes from doing any allocations in this
+		 * allocation group.
+		 */
+		xfs_trans_bhold(tp, ialloc_context);
+
+		error = args->ops->ichunk_roll(&tp);
+		if (error) {
+			xfs_buf_relse(ialloc_context);
+			*tpp = tp;
+			*ipp = NULL;
+			return error;
+		}
+		xfs_trans_bjoin(tp, ialloc_context);
+
+		/*
+		 * Call ialloc again. Since we've locked out all
+		 * other allocations in this allocation group,
+		 * this call should always succeed.
+		 */
+		error = xfs_ialloc(tp, args, &ialloc_context, &ip);
+
+		/*
+		 * If we get an error at this point, return to the caller
+		 * so that the current transaction can be aborted.
+		 */
+		if (error) {
+			*tpp = tp;
+			*ipp = NULL;
+			return error;
+		}
+		ASSERT(!ialloc_context && ip);
+
+	}
+
+	*ipp = ip;
+	*tpp = tp;
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index ee274d74b8d4..5e2608f99fad 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -93,7 +93,7 @@ struct xfs_ialloc_ops {
 /* The libxfs client must provide this symbol. */
 extern const struct xfs_ialloc_ops xfs_default_ialloc_ops;
 
-int xfs_ialloc(struct xfs_trans *tp, const struct xfs_ialloc_args *args,
-	       struct xfs_buf **ialloc_context, struct xfs_inode **ipp);
+int xfs_dir_ialloc(struct xfs_trans **tpp, const struct xfs_ialloc_args *args,
+		   struct xfs_inode **ipp);
 
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 82de92bc84b9..167fe4ec48bd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -692,112 +692,6 @@ const struct xfs_ialloc_ops xfs_default_ialloc_ops = {
 	.ichunk_roll	= xfs_dir_ialloc_roll,
 };
 
-/*
- * Allocates a new inode from disk and return a pointer to the
- * incore copy. This routine will internally commit the current
- * transaction and allocate a new one if the Space Manager needed
- * to do an allocation to replenish the inode free-list.
- *
- * This routine is designed to be called from xfs_create and
- * xfs_create_dir.
- *
- */
-int
-xfs_dir_ialloc(
-	struct xfs_trans		**tpp,
-	const struct xfs_ialloc_args	*args,
-	struct xfs_inode		**ipp)
-{
-	struct xfs_trans		*tp;
-	struct xfs_inode		*ip;
-	struct xfs_buf			*ialloc_context = NULL;
-	int				code;
-
-	tp = *tpp;
-	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
-
-	/*
-	 * xfs_ialloc will return a pointer to an incore inode if
-	 * the Space Manager has an available inode on the free
-	 * list. Otherwise, it will do an allocation and replenish
-	 * the freelist.  Since we can only do one allocation per
-	 * transaction without deadlocks, we will need to commit the
-	 * current transaction and start a new one.  We will then
-	 * need to call xfs_ialloc again to get the inode.
-	 *
-	 * If xfs_ialloc did an allocation to replenish the freelist,
-	 * it returns the bp containing the head of the freelist as
-	 * ialloc_context. We will hold a lock on it across the
-	 * transaction commit so that no other process can steal
-	 * the inode(s) that we've just allocated.
-	 */
-	code = xfs_ialloc(tp, args, &ialloc_context, &ip);
-
-	/*
-	 * Return an error if we were unable to allocate a new inode.
-	 * This should only happen if we run out of space on disk or
-	 * encounter a disk error.
-	 */
-	if (code) {
-		*ipp = NULL;
-		return code;
-	}
-	if (!ialloc_context && !ip) {
-		*ipp = NULL;
-		return -ENOSPC;
-	}
-
-	/*
-	 * If the AGI buffer is non-NULL, then we were unable to get an
-	 * inode in one operation.  We need to commit the current
-	 * transaction and call xfs_ialloc() again.  It is guaranteed
-	 * to succeed the second time.
-	 */
-	if (ialloc_context) {
-		/*
-		 * Normally, xfs_trans_commit releases all the locks.
-		 * We call bhold to hang on to the ialloc_context across
-		 * the commit.  Holding this buffer prevents any other
-		 * processes from doing any allocations in this
-		 * allocation group.
-		 */
-		xfs_trans_bhold(tp, ialloc_context);
-
-		code = args->ops->ichunk_roll(&tp);
-		if (code) {
-			xfs_buf_relse(ialloc_context);
-			*tpp = tp;
-			*ipp = NULL;
-			return code;
-		}
-		xfs_trans_bjoin(tp, ialloc_context);
-
-		/*
-		 * Call ialloc again. Since we've locked out all
-		 * other allocations in this allocation group,
-		 * this call should always succeed.
-		 */
-		code = xfs_ialloc(tp, args, &ialloc_context, &ip);
-
-		/*
-		 * If we get an error at this point, return to the caller
-		 * so that the current transaction can be aborted.
-		 */
-		if (code) {
-			*tpp = tp;
-			*ipp = NULL;
-			return code;
-		}
-		ASSERT(!ialloc_context && ip);
-
-	}
-
-	*ipp = ip;
-	*tpp = tp;
-
-	return 0;
-}
-
 /*
  * Decrement the link count on an inode & log the change.  If this causes the
  * link count to go to zero, move the inode to AGI unlinked list so that it can
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 08aa747d07cf..211b7d85bf62 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -421,10 +421,6 @@ int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
-int		xfs_dir_ialloc(struct xfs_trans **,
-			       const struct xfs_ialloc_args *,
-			       struct xfs_inode **);
-
 static inline int
 xfs_itruncate_extents(
 	struct xfs_trans	**tpp,
