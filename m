Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36084 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727670AbfEJUSn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 16:18:43 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 01/11] libxfs: remove i_transp
Date: Fri, 10 May 2019 15:18:20 -0500
Message-Id: <1557519510-10602-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

i_transp was removed from kernel code back in 2011, but it was left
in userspace.  It's only used in a few asserts in transaction code
(as it was in the kernel) so there doesnt' seem to be a compelling
reason to carry it around anymore.

Source kernel commit: f3ca87389dbff0a3dc1a7cb2fa7c62e25421c66c

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 include/xfs_inode.h |  1 -
 libxfs/trans.c      | 11 -----------
 2 files changed, 12 deletions(-)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 52d79f3..88b58ac 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -41,7 +41,6 @@ typedef struct xfs_inode {
 	struct xfs_ifork	*i_afp;		/* attribute fork pointer */
 	struct xfs_ifork	*i_cowfp;	/* copy on write extents */
 	struct xfs_ifork	i_df;		/* data fork */
-	struct xfs_trans	*i_transp;	/* ptr to owning transaction */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
diff --git a/libxfs/trans.c b/libxfs/trans.c
index db90624..101019b 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -344,7 +344,6 @@ libxfs_trans_ijoin(
 {
 	xfs_inode_log_item_t	*iip;
 
-	ASSERT(ip->i_transp == NULL);
 	if (ip->i_itemp == NULL)
 		xfs_inode_item_init(ip, ip->i_mount);
 	iip = ip->i_itemp;
@@ -356,7 +355,6 @@ libxfs_trans_ijoin(
 
 	xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
 
-	ip->i_transp = tp;
 #ifdef XACT_DEBUG
 	fprintf(stderr, "ijoin'd inode %llu, transaction %p\n", ip->i_ino, tp);
 #endif
@@ -368,7 +366,6 @@ libxfs_trans_ijoin_ref(
 	xfs_inode_t		*ip,
 	int			lock_flags)
 {
-	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_itemp != NULL);
 
 	xfs_trans_ijoin(tp, ip, lock_flags);
@@ -406,7 +403,6 @@ xfs_trans_log_inode(
 	xfs_inode_t		*ip,
 	uint			flags)
 {
-	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_itemp != NULL);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "dirtied inode %llu, transaction %p\n", ip->i_ino, tp);
@@ -817,7 +813,6 @@ inode_item_done(
 	ASSERT(ip != NULL);
 
 	if (!(iip->ili_fields & XFS_ILOG_ALL)) {
-		ip->i_transp = NULL;	/* disassociate from transaction */
 		iip->ili_flags = 0;	/* reset all flags */
 		goto free;
 	}
@@ -838,7 +833,6 @@ inode_item_done(
 	 * we still release the buffer reference we currently hold.
 	 */
 	error = libxfs_iflush_int(ip, bp);
-	ip->i_transp = NULL;	/* disassociate from transaction */
 	bp->b_transp = NULL;	/* remove xact ptr */
 
 	if (error) {
@@ -927,11 +921,6 @@ static void
 inode_item_unlock(
 	xfs_inode_log_item_t	*iip)
 {
-	xfs_inode_t		*ip = iip->ili_inode;
-
-	/* Clear the transaction pointer in the inode. */
-	ip->i_transp = NULL;
-
 	iip->ili_flags = 0;
 	xfs_inode_item_put(iip);
 }
-- 
1.8.3.1
