Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33676 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbeJJCE2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Oct 2018 22:04:28 -0400
Date: Tue, 9 Oct 2018 11:46:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 3/3] xfs: fix buffer state management in
 xrep_findroot_block
Message-ID: <20181009184601.GJ28243@magnolia>
References: <153905876877.10127.12478254551500076698.stgit@magnolia>
 <153905878783.10127.5891089492746914373.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153905878783.10127.5891089492746914373.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

We don't handle buffer state properly in online repair's findroot
routine.  If a buffer already has b_ops set, we don't ever want to touch
that, and we don't want to call the read verifiers on a buffer that
could be dirty (CRCs are only recomputed during log checkpoints).

Therefore, be more careful about what we do with a buffer -- if someone
else already attached ops that are not the ones for this btree type,
just ignore the buffer.  We only attach our btree type's buf ops if it
matches the magic/uuid and structure checks.

We also modify xfs_buf_read_map to allow callers to set buffer ops on a
DONE buffer with NULL ops so that repair doesn't leave behind buffers
which won't have buffers attached to them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/scrub/repair.c  |   71 +++++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_trans.h     |    1 +
 fs/xfs/xfs_trans_buf.c |   13 +++++++++
 3 files changed, 71 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 63786341ac2a..4fc0a5ea7673 100644
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
@@ -699,7 +701,7 @@ xrep_findroot_block(
 	struct xfs_btree_block		*btblock;
 	xfs_daddr_t			daddr;
 	int				block_level;
-	int				error;
+	int				error = 0;
 
 	daddr = XFS_AGB_TO_DADDR(mp, ri->sc->sa.agno, agbno);
 
@@ -718,28 +720,69 @@ xrep_findroot_block(
 			return error;
 	}
 
+	/*
+	 * Read the buffer into memory so that we can see if it's a match for
+	 * our btree type.  We have no clue if it is beforehand, and we want to
+	 * avoid xfs_trans_read_buf's behavior of dumping the DONE state (which
+	 * will cause needless disk reads in subsequent calls to this function)
+	 * and logging metadata verifier failures.
+	 *
+	 * Therefore, pass in NULL buffer ops.  If the buffer was already in
+	 * memory from some other caller it will already have b_ops assigned.
+	 * If it was in memory from a previous unsuccessful findroot_block
+	 * call, the buffer won't have b_ops but it should be clean and ready
+	 * for us to try to verify if the read call succeeds.  The same applies
+	 * if the buffer wasn't in memory at all.
+	 *
+	 * Note: If we never match a btree type with this buffer, it will be
+	 * left in memory with NULL b_ops.  This shouldn't be a problem unless
+	 * the buffer gets written.
+	 */
 	error = xfs_trans_read_buf(mp, ri->sc->tp, mp->m_ddev_targp, daddr,
 			mp->m_bsize, 0, &bp, NULL);
 	if (error)
 		return error;
 
-	/*
-	 * Does this look like a block matching our fs and higher than any
-	 * other block we've found so far?  If so, reattach buffer verifiers
-	 * so the AIL won't complain if the buffer is also dirty.
-	 */
+	/* Ensure the block magic matches the btree type we're looking for. */
 	btblock = XFS_BUF_TO_BLOCK(bp);
 	if (be32_to_cpu(btblock->bb_magic) != fab->magic)
 		goto out;
-	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&btblock->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
-		goto out;
-	bp->b_ops = fab->buf_ops;
 
-	/* Make sure we pass the verifiers. */
-	bp->b_ops->verify_read(bp);
-	if (bp->b_error)
-		goto out;
+	/*
+	 * If the buffer already has ops applied and they're not the ones for
+	 * this btree type, we know this block doesn't match the btree and we
+	 * can bail out.
+	 *
+	 * If the buffer ops match ours, someone else has already validated
+	 * the block for us, so we can move on to checking if this is a root
+	 * block candidate.
+	 *
+	 * If the buffer does not have ops, nobody has successfully validated
+	 * the contents and the buffer cannot be dirty.  If the magic, uuid,
+	 * and structure match this btree type then we'll move on to checking
+	 * if it's a root block candidate.  If there is no match, bail out.
+	 */
+	if (bp->b_ops) {
+		if (bp->b_ops != fab->buf_ops)
+			goto out;
+	} else {
+		ASSERT(!xfs_trans_buf_is_dirty(bp));
+		if (!uuid_equal(&btblock->bb_u.s.bb_uuid,
+				&mp->m_sb.sb_meta_uuid))
+			goto out;
+		fab->buf_ops->verify_read(bp);
+		if (bp->b_error) {
+			bp->b_error = 0;
+			goto out;
+		}
+
+		/*
+		 * Some read verifiers will (re)set b_ops, so we must be
+		 * careful not to blow away any such assignment.
+		 */
+		if (!bp->b_ops)
+			bp->b_ops = fab->buf_ops;
+	}
 
 	/*
 	 * This block passes the magic/uuid and verifier tests for this btree
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index c3d278e96ad1..a0c5dbda18aa 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -220,6 +220,7 @@ void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void		xfs_trans_log_buf(struct xfs_trans *, struct xfs_buf *, uint,
 				  uint);
 void		xfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
+bool		xfs_trans_buf_is_dirty(struct xfs_buf *bp);
 void		xfs_trans_log_inode(xfs_trans_t *, struct xfs_inode *, uint);
 
 void		xfs_extent_free_init_defer_op(void);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index fc40160c1773..629f1479c9d2 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -350,6 +350,19 @@ xfs_trans_read_buf_map(
 
 }
 
+/* Has this buffer been dirtied by anyone? */
+bool
+xfs_trans_buf_is_dirty(
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+
+	if (!bip)
+		return false;
+	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
+	return test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
+}
+
 /*
  * Release a buffer previously joined to the transaction. If the buffer is
  * modified within this transaction, decrement the recursion count but do not
