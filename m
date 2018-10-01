Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33598 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbeJBF2h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 01:28:37 -0400
Subject: [PATCH 2/2] xfs: fix buffer state management in xrep_findroot_block
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 01 Oct 2018 15:48:28 -0700
Message-ID: <153843410841.24414.2317164703479198891.stgit@magnolia>
In-Reply-To: <153843409576.24414.14199833763423874927.stgit@magnolia>
References: <153843409576.24414.14199833763423874927.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

We don't quite handle buffer state properly in online repair's findroot
routine.  If the buffer is already in-core we don't want to trash its
b_ops and state, but we /do/ want to read the contents in from disk if
the buffer wasn't already in memory.

Therefore, introduce the ONESHOT_OPS buffer flag.  If the buffer had to
be read in from disk, the buf_ops supplied to read_buf will be used once
to verify the buffer contents, but they will not be attached to the
buffer itself.

With this change, xrep_findroot_block's buffer handling can be
simplified -- if b_ops is null, we know that it was freshly read (and
verified), we can set b_ops, and proceed.  If b_ops is not null, the
buffer was already in memory and we need to do some more structure
checks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c |   76 ++++++++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_buf.c      |    7 ++++-
 fs/xfs/xfs_buf.h      |    2 +
 3 files changed, 67 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 6eb66b3543ff..8e1dfa5752b4 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -29,6 +29,8 @@
 #include "xfs_ag_resv.h"
 #include "xfs_trans_space.h"
 #include "xfs_quota.h"
+#include "xfs_attr.h"
+#include "xfs_reflink.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -697,9 +699,10 @@ xrep_findroot_block(
 	struct xfs_mount		*mp = ri->sc->mp;
 	struct xfs_buf			*bp;
 	struct xfs_btree_block		*btblock;
+	xfs_failaddr_t			fa;
 	xfs_daddr_t			daddr;
 	int				block_level;
-	int				error;
+	int				error = 0;
 
 	daddr = XFS_AGB_TO_DADDR(mp, ri->sc->sa.agno, agbno);
 
@@ -718,28 +721,67 @@ xrep_findroot_block(
 			return error;
 	}
 
+	/*
+	 * Read the buffer into memory with ONESHOT_OPS.  We can tell if we
+	 * had to go to disk by whether or not b_ops is set.
+	 */
 	error = xfs_trans_read_buf(mp, ri->sc->tp, mp->m_ddev_targp, daddr,
-			mp->m_bsize, 0, &bp, NULL);
+			mp->m_bsize, XBF_ONESHOT_OPS, &bp, fab->buf_ops);
 	if (error)
 		return error;
 
-	/*
-	 * Does this look like a block matching our fs and higher than any
-	 * other block we've found so far?  If so, reattach buffer verifiers
-	 * so the AIL won't complain if the buffer is also dirty.
-	 */
 	btblock = XFS_BUF_TO_BLOCK(bp);
-	if (be32_to_cpu(btblock->bb_magic) != fab->magic)
-		goto out;
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&btblock->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
-		goto out;
-	bp->b_ops = fab->buf_ops;
+	if (bp->b_ops == NULL) {
+		/*
+		 * The buffer came back with NULL b_ops, which means that the
+		 * buffer was not in memory, we had to read it off disk, and
+		 * the verifier has run.
+		 *
+		 * If b_error == 0, the block matches the magic, the uuid, and
+		 * ->verify_struct of the btree type and we can proceed.  Set
+		 * b_ops to the btree type's buf_ops so that we don't have a
+		 * buffer in memory with no verifiers.
+		 *
+		 * Otherwise, the block doesn't match the btree type so we
+		 * mark it oneshot so it doesn't stick around, and move on.
+		 */
+		if (bp->b_error) {
+			xfs_buf_oneshot(bp);
+			goto out;
+		}
+		bp->b_ops = fab->buf_ops;
+	} else {
+		/*
+		 * The buffer came back with b_ops set, which means that the
+		 * buffer was already in memory.  We'll run the magic, uuid,
+		 * and ->verify_struct checks by hand to see if we want to
+		 * examine it further.
+		 */
+		if (be32_to_cpu(btblock->bb_magic) != fab->magic)
+			goto out;
+		if (xfs_sb_version_hascrc(&mp->m_sb) &&
+		    !uuid_equal(&btblock->bb_u.s.bb_uuid,
+				&mp->m_sb.sb_meta_uuid))
+			goto out;
 
-	/* Make sure we pass the verifiers. */
-	bp->b_ops->verify_read(bp);
-	if (bp->b_error)
-		goto out;
+		/*
+		 * If b_ops do not match fab->buf_ops even though the magic
+		 * does, something is seriously wrong here and we'd rather
+		 * abort the entire repair than risk screwing things up.
+		 */
+		if (bp->b_ops != fab->buf_ops)
+			goto out;
+
+		/*
+		 * If the buffer was already incore (on a v5 fs) then it should
+		 * already have had b_ops assigned.  Call ->verify_struct to
+		 * check the structure.  Avoid checking the CRC because we
+		 * don't calculate CRCs until the buffer is written by the log.
+		 */
+		fa = bp->b_ops->verify_struct(bp);
+		if (fa)
+			goto out;
+	}
 
 	/*
 	 * This block passes the magic/uuid and verifier tests for this btree
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e839907e8492..139d35f6da64 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -206,7 +206,8 @@ _xfs_buf_alloc(
 	 * We don't want certain flags to appear in b_flags unless they are
 	 * specifically set by later operations on the buffer.
 	 */
-	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
+	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD |
+		   XBF_ONESHOT_OPS);
 
 	atomic_set(&bp->b_hold, 1);
 	atomic_set(&bp->b_lru_ref, 1);
@@ -758,6 +759,7 @@ xfs_buf_read_map(
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
+	const struct xfs_buf_ops *orig_ops;
 
 	flags |= XBF_READ;
 
@@ -767,8 +769,11 @@ xfs_buf_read_map(
 
 		if (!(bp->b_flags & XBF_DONE)) {
 			XFS_STATS_INC(target->bt_mount, xb_get_read);
+			orig_ops = bp->b_ops;
 			bp->b_ops = ops;
 			_xfs_buf_read(bp, flags);
+			if (flags & XBF_ONESHOT_OPS)
+				bp->b_ops = orig_ops;
 		} else if (flags & XBF_ASYNC) {
 			/*
 			 * Read ahead call which is already satisfied,
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 4e3171acd0f8..62139d3ad349 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -34,6 +34,7 @@ typedef enum {
 #define XBF_ASYNC	 (1 << 4) /* initiator will not wait for completion */
 #define XBF_DONE	 (1 << 5) /* all pages in the buffer uptodate */
 #define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
+#define XBF_ONESHOT_OPS	 (1 << 7) /* only use ops if we read in the buf */
 #define XBF_WRITE_FAIL	 (1 << 24)/* async writes have failed on this buffer */
 
 /* I/O hints for the BIO layer */
@@ -61,6 +62,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_ASYNC,		"ASYNC" }, \
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_STALE,		"STALE" }, \
+	{ XBF_ONESHOT_OPS,	"ONESHOT_OPS" }, /* should never be set */ \
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
 	{ XBF_SYNCIO,		"SYNCIO" }, \
 	{ XBF_FUA,		"FUA" }, \
