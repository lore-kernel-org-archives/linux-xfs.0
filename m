Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36090 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbfEJUSn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 16:18:43 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 04/11] libxfs: rename bp_transp to b_transp in ASSERTs
Date: Fri, 10 May 2019 15:18:23 -0500
Message-Id: <1557519510-10602-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_buf no longer has a bp_transp member; it's b_transp now.
These ASSERTs get #defined away, but it's still best to not have
invalid structure members cluttering up the code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/trans.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/libxfs/trans.c b/libxfs/trans.c
index 64131b2..581ece3 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -381,7 +381,7 @@ libxfs_trans_inode_alloc_buf(
 {
 	xfs_buf_log_item_t	*bip = bp->b_log_item;
 
-	ASSERT(bp->bp_transp == tp);
+	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
@@ -446,7 +446,7 @@ libxfs_trans_dirty_buf(
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	ASSERT(bp->bp_transp == tp);
+	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 
 #ifdef XACT_DEBUG
@@ -521,11 +521,11 @@ libxfs_trans_brelse(
 #endif
 
 	if (tp == NULL) {
-		ASSERT(bp->bp_transp == NULL);
+		ASSERT(bp->b_transp == NULL);
 		libxfs_putbuf(bp);
 		return;
 	}
-	ASSERT(bp->bp_transp == tp);
+	ASSERT(bp->b_transp == tp);
 	bip = bp->b_log_item;
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
 	if (bip->bli_recur > 0) {
@@ -555,7 +555,7 @@ libxfs_trans_binval(
 	fprintf(stderr, "binval'd buffer %p, transaction %p\n", bp, tp);
 #endif
 
-	ASSERT(bp->bp_transp == tp);
+	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 
 	if (bip->bli_flags & XFS_BLI_STALE)
@@ -577,7 +577,7 @@ libxfs_trans_bjoin(
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(bp->bp_transp == NULL);
+	ASSERT(bp->b_transp == NULL);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "bjoin'd buffer %p, transaction %p\n", bp, tp);
 #endif
@@ -595,7 +595,7 @@ libxfs_trans_bhold(
 {
 	xfs_buf_log_item_t	*bip = bp->b_log_item;
 
-	ASSERT(bp->bp_transp == tp);
+	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "bhold'd buffer %p, transaction %p\n", bp, tp);
@@ -620,7 +620,7 @@ libxfs_trans_get_buf_map(
 
 	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
 	if (bp != NULL) {
-		ASSERT(bp->bp_transp == tp);
+		ASSERT(bp->b_transp == tp);
 		bip = bp->b_log_item;
 		ASSERT(bip != NULL);
 		bip->bli_recur++;
@@ -656,7 +656,7 @@ libxfs_trans_getsb(
 
 	bp = xfs_trans_buf_item_match(tp, mp->m_dev, &map, 1);
 	if (bp != NULL) {
-		ASSERT(bp->bp_transp == tp);
+		ASSERT(bp->b_transp == tp);
 		bip = bp->b_log_item;
 		ASSERT(bip != NULL);
 		bip->bli_recur++;
@@ -703,7 +703,7 @@ libxfs_trans_read_buf_map(
 
 	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
 	if (bp != NULL) {
-		ASSERT(bp->bp_transp == tp);
+		ASSERT(bp->b_transp == tp);
 		ASSERT(bp->b_log_item != NULL);
 		bip = bp->b_log_item;
 		bip->bli_recur++;
-- 
1.8.3.1
