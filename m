Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35788 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751495AbeEDRfl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 13:35:41 -0400
Subject: [PATCH 5/5] xfs: print specific dqblk that failed verifiers
References: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9d126a83-c4ef-00a2-dbb6-510e2c41de73@sandeen.net>
Date: Fri, 4 May 2018 12:35:40 -0500
MIME-Version: 1.0
In-Reply-To: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Rather than printing the top of the buffer that held a corrupted dqblk,
restructure things to print out the specific one that failed by pushing
the calls to the verifier_error function down into the verifier which
iterates over the buffer and detects the error.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c | 41 +++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index d71c0b53536b..fb23d941e799 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -152,7 +152,8 @@ xfs_dqblk_repair(
 STATIC bool
 xfs_dquot_buf_verify_crc(
 	struct xfs_mount	*mp,
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	bool			readahead)
 {
 	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
 	int			ndquots;
@@ -173,8 +174,12 @@ xfs_dquot_buf_verify_crc(
 
 	for (i = 0; i < ndquots; i++, d++) {
 		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
-				 XFS_DQUOT_CRC_OFF))
+				 XFS_DQUOT_CRC_OFF)) {
+			if (!readahead)
+				xfs_buf_verifier_error(bp, -EFSBADCRC, __func__,
+					d, sizeof(*d), __this_address);
 			return false;
+		}
 	}
 	return true;
 }
@@ -182,7 +187,8 @@ xfs_dquot_buf_verify_crc(
 STATIC xfs_failaddr_t
 xfs_dquot_buf_verify(
 	struct xfs_mount	*mp,
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	bool			readahead)
 {
 	struct xfs_dqblk	*dqb = (struct xfs_dqblk *)bp->b_addr;
 	xfs_failaddr_t		fa;
@@ -216,8 +222,13 @@ xfs_dquot_buf_verify(
 			id = be32_to_cpu(ddq->d_id);
 
 		fa = xfs_dqblk_verify(mp, &dqb[i], id + i, 0);
-		if (fa)
+		if (fa) {
+			if (!readahead)
+				xfs_buf_verifier_error(bp, -EFSCORRUPTED,
+					__func__, &dqb[i],
+					sizeof(struct xfs_dqblk), fa);
 			return fa;
+		}
 	}
 
 	return NULL;
@@ -229,7 +240,7 @@ xfs_dquot_buf_verify_struct(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	return xfs_dquot_buf_verify(mp, bp);
+	return xfs_dquot_buf_verify(mp, bp, false);
 }
 
 static void
@@ -237,15 +248,10 @@ xfs_dquot_buf_read_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	xfs_failaddr_t		fa;
 
-	if (!xfs_dquot_buf_verify_crc(mp, bp))
-		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
-	else {
-		fa = xfs_dquot_buf_verify(mp, bp);
-		if (fa)
-			xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
-	}
+	if (!xfs_dquot_buf_verify_crc(mp, bp, false))
+		return;
+	xfs_dquot_buf_verify(mp, bp, false);
 }
 
 /*
@@ -260,8 +266,8 @@ xfs_dquot_buf_readahead_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (!xfs_dquot_buf_verify_crc(mp, bp) ||
-	    xfs_dquot_buf_verify(mp, bp) != NULL) {
+	if (!xfs_dquot_buf_verify_crc(mp, bp, true) ||
+	    xfs_dquot_buf_verify(mp, bp, true) != NULL) {
 		xfs_buf_ioerror(bp, -EIO);
 		bp->b_flags &= ~XBF_DONE;
 	}
@@ -277,11 +283,8 @@ xfs_dquot_buf_write_verify(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	xfs_failaddr_t		fa;
 
-	fa = xfs_dquot_buf_verify(mp, bp);
-	if (fa)
-		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+	xfs_dquot_buf_verify(mp, bp, false);
 }
 
 const struct xfs_buf_ops xfs_dquot_buf_ops = {
-- 
2.17.0


