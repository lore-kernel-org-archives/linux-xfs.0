Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfBGSzQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Feb 2019 13:55:16 -0500
Date: Thu, 7 Feb 2019 10:55:03 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 0.5/8] xfs: clarify documentation for the function to
 reverify buffers
Message-ID: <20190207185503.GF7991@magnolia>
References: <20190207184105.17064-1-bfoster@redhat.com>
 <20190207184105.17064-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207184105.17064-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Errrr.... here's the patch to clean up the ensure_ops documentation and
rename the function:

--D

From: Brian Foster <bfoster@redhat.com>

Improve the documentation around xfs_buf_ensure_ops, which is the
function that is responsible for cleaning up the b_ops state of buffers
that go through xrep_findroot_block but don't match anything.  Rename
the function to xfs_buf_reverify.

[darrick: this started off as bfoster mods of a previous patch of mine,
but the renaming parts are now a separate patch.]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c       |   35 +++++++++++++++--------------------
 fs/xfs/xfs_buf.h       |    2 +-
 fs/xfs/xfs_trans_buf.c |    2 +-
 3 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4f5f2ff3f70f..d29246ac3721 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -776,29 +776,24 @@ _xfs_buf_read(
 }
 
 /*
- * Set buffer ops on an unchecked buffer and validate it, if possible.
+ * Reverify a buffer found in cache without an attached ->b_ops.
  *
- * If the caller passed in an ops structure and the buffer doesn't have ops
- * assigned, set the ops and use them to verify the contents.  If the contents
- * cannot be verified, we'll clear XBF_DONE.  We assume the buffer has no
- * recorded errors and is already in XBF_DONE state.
+ * If the caller passed an ops structure and the buffer doesn't have ops
+ * assigned, set the ops and use it to verify the contents. If verification
+ * fails, clear XBF_DONE. We assume the buffer has no recorded errors and is
+ * already in XBF_DONE state on entry.
  *
- * Under normal operations, every in-core buffer must have buffer ops assigned
- * to them when the buffer is read in from disk so that we can validate the
- * metadata.
- *
- * However, there are two scenarios where one can encounter in-core buffers
- * that don't have buffer ops.  The first is during log recovery of buffers on
- * a V4 filesystem, though these buffers are purged at the end of recovery.
- *
- * The other is online repair, which tries to match arbitrary metadata blocks
- * with btree types in order to find the root.  If online repair doesn't match
- * the buffer with /any/ btree type, the buffer remains in memory in DONE state
- * with no ops, and a subsequent read_buf call from elsewhere will not set the
- * ops.  This function helps us fix this situation.
+ * Under normal operations, every in-core buffer is verified on read I/O
+ * completion. There are two scenarios that can lead to in-core buffers without
+ * an assigned ->b_ops. The first is during log recovery of buffers on a V4
+ * filesystem, though these buffers are purged at the end of recovery. The
+ * other is online repair, which intentionally reads with a NULL buffer ops to
+ * run several verifiers across an in-core buffer in order to establish buffer
+ * type.  If repair can't establish that, the buffer will be left in memory
+ * with NULL buffer ops.
  */
 int
-xfs_buf_ensure_ops(
+xfs_buf_reverify(
 	struct xfs_buf		*bp,
 	const struct xfs_buf_ops *ops)
 {
@@ -840,7 +835,7 @@ xfs_buf_read_map(
 		return bp;
 	}
 
-	xfs_buf_ensure_ops(bp, ops);
+	xfs_buf_reverify(bp, ops);
 
 	if (flags & XBF_ASYNC) {
 		/*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index b9f5511ea998..1c436a85b71d 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -385,6 +385,6 @@ extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 
-int xfs_buf_ensure_ops(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
+int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 
 #endif	/* __XFS_BUF_H__ */
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 629f1479c9d2..7d65ebf1e847 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -277,7 +277,7 @@ xfs_trans_read_buf_map(
 		 * release this buffer when it kills the tranaction.
 		 */
 		ASSERT(bp->b_ops != NULL);
-		error = xfs_buf_ensure_ops(bp, ops);
+		error = xfs_buf_reverify(bp, ops);
 		if (error) {
 			xfs_buf_ioerror_alert(bp, __func__);
 
