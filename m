Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C0AC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 00:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B1426135D
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 00:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhD0ACt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Apr 2021 20:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232022AbhD0ACs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Apr 2021 20:02:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9314E6135D;
        Tue, 27 Apr 2021 00:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619481726;
        bh=6HY6R5xBGp5Mj0Ta5d8L0+icB2H4uJrFYTWN6q1ITOQ=;
        h=Date:From:To:Cc:Subject:From;
        b=lU/TUFFuc5mmSTGvNqDH735+ckS1o07dsj5FSb79aQBN8pMxSJ1xVUNQw6W8yM1cT
         QKnECWjwpxB92pLHFmx+/KYbwHhSLTtyI6gHVAkNvNo1IhLVOumauF0F0swiy2/ZTN
         dRKcujLpAiyrvLnOt+D2C7sWu1ESm7vvnz9QI/due1dqEbMBF6DNMkZe9IqlY6yyXx
         unC7AzS7p91Wy8xcMe+N4qdyT9K1x6TQCFAETFlyChkHy6NcBysAGI2bgsVL4i5JVN
         6UrMHbdFlFojpSVVOCEkEpX5DSKbDJDtdSrGOqKvk/hMUtLBC6dIrztou86m3/6YvQ
         VDzySCHKZv8PA==
Date:   Mon, 26 Apr 2021 17:02:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, bfoster@redhat.com,
        zlang@redhat.com
Subject: [PATCH v2] xfs: remove obsolete AGF counter debugging
Message-ID: <20210427000204.GC3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit f8f2835a9cf3 we changed the behavior of XFS to use EFIs to
remove blocks from an overfilled AGFL because there were complaints
about transaction overruns that stemmed from trying to free multiple
blocks in a single transaction.

Unfortunately, that commit missed a subtlety in the debug-mode
transaction accounting when a realtime volume is attached.  If a
realtime file undergoes a data fork mapping change such that realtime
extents are allocated (or freed) in the same transaction that a data
device block is also allocated (or freed), we can trip a debugging
assertion.  This can happen (for example) if a realtime extent is
allocated and it is necessary to reshape the bmbt to hold the new
mapping.

When we go to allocate a bmbt block from an AG, the first thing the data
device block allocator does is ensure that the freelist is the proper
length.  If the freelist is too long, it will trim the freelist to the
proper length.

In debug mode, trimming the freelist calls xfs_trans_agflist_delta() to
record the decrement in the AG free list count.  Prior to f8f28 we would
put the free block back in the free space btrees in the same
transaction, which calls xfs_trans_agblocks_delta() to record the
increment in the AG free block count.  Since AGFL blocks are included in
the global free block count (fdblocks), there is no corresponding
fdblocks update, so the AGFL free satisfies the following condition in
xfs_trans_apply_sb_deltas:

	/*
	 * Check that superblock mods match the mods made to AGF counters.
	 */
	ASSERT((tp->t_fdblocks_delta + tp->t_res_fdblocks_delta) ==
	       (tp->t_ag_freeblks_delta + tp->t_ag_flist_delta +
		tp->t_ag_btree_delta));

The comparison here used to be: (X + 0) == ((X+1) + -1 + 0), where X is
the number blocks that were allocated.

After commit f8f28 we defer the block freeing to the next chained
transaction, which means that the calls to xfs_trans_agflist_delta and
xfs_trans_agblocks_delta occur in separate transactions.  The (first)
transaction that shortens the free list trips on the comparison, which
has now become:

(X + 0) == ((X) + -1 + 0)

because we haven't freed the AGFL block yet; we've only logged an
intention to free it.  When the second transaction (the deferred free)
commits, it will evaluate the expression as:

(0 + 0) == (1 + 0 + 0)

and trip over that in turn.

At this point, the astute reader may note that the two commits tagged by
this patch have been in the kernel for a long time but haven't generated
any bug reports.  How is it that the author became aware of this bug?

This originally surfaced as an intermittent failure when I was testing
realtime rmap, but a different bug report by Zorro Lang reveals the same
assertion occuring on !lazysbcount filesystems.

The common factor to both reports (and why this problem wasn't
previously reported) becomes apparent if we consider when
xfs_trans_apply_sb_deltas is called by __xfs_trans_commit():

	if (tp->t_flags & XFS_TRANS_SB_DIRTY)
		xfs_trans_apply_sb_deltas(tp);

With a modern lazysbcount filesystem, transactions update only the
percpu counters, so they don't need to set XFS_TRANS_SB_DIRTY, hence
xfs_trans_apply_sb_deltas is rarely called.

However, updates to the count of free realtime extents are not part of
lazysbcount, so XFS_TRANS_SB_DIRTY will be set on transactions adding or
removing data fork mappings to realtime files; similarly,
XFS_TRANS_SB_DIRTY is always set on !lazysbcount filesystems.

Dave mentioned in response to an earlier version of this patch:

"IIUC, what you are saying is that this debug code is simply not
exercised in normal testing and hasn't been for the past decade?  And it
still won't be exercised on anything other than realtime device testing?

"...it was debugging code from 1994 that was largely turned into dead
code when lazysbcounters were introduced in 2007. Hence I'm not sure it
holds any value anymore."

This debugging code isn't especially helpful - you can modify the
flcount on one AG and the freeblks of another AG, and it won't trigger.
Add the fact that nobody noticed for a decade, and let's just get rid of
it (and start testing realtime :P).

This bug was found by running generic/051 on either a V4 filesystem
lacking lazysbcount; or a V5 filesystem with a realtime volume.

Cc: bfoster@redhat.com, zlang@redhat.com
Fixes: f8f2835a9cf3 ("xfs: defer agfl block frees when dfops is available")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c       |    3 ---
 fs/xfs/libxfs/xfs_alloc_btree.c |    2 --
 fs/xfs/libxfs/xfs_rmap_btree.c  |    2 --
 fs/xfs/xfs_fsops.c              |    2 --
 fs/xfs/xfs_trans.c              |    7 -------
 fs/xfs/xfs_trans.h              |   15 ---------------
 6 files changed, 31 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index aaa19101bb2a..f52b9e4a03f9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -718,7 +718,6 @@ xfs_alloc_update_counters(
 	agbp->b_pag->pagf_freeblks += len;
 	be32_add_cpu(&agf->agf_freeblks, len);
 
-	xfs_trans_agblocks_delta(tp, len);
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
 		     be32_to_cpu(agf->agf_length))) {
 		xfs_buf_mark_corrupt(agbp);
@@ -2739,7 +2738,6 @@ xfs_alloc_get_freelist(
 	pag = agbp->b_pag;
 	ASSERT(!pag->pagf_agflreset);
 	be32_add_cpu(&agf->agf_flcount, -1);
-	xfs_trans_agflist_delta(tp, -1);
 	pag->pagf_flcount--;
 
 	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;
@@ -2846,7 +2844,6 @@ xfs_alloc_put_freelist(
 	pag = agbp->b_pag;
 	ASSERT(!pag->pagf_agflreset);
 	be32_add_cpu(&agf->agf_flcount, 1);
-	xfs_trans_agflist_delta(tp, 1);
 	pag->pagf_flcount++;
 
 	logflags = XFS_AGF_FLLAST | XFS_AGF_FLCOUNT;
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 8e01231b308e..dbe302d1cb8d 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -73,7 +73,6 @@ xfs_allocbt_alloc_block(
 
 	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1, false);
 
-	xfs_trans_agbtree_delta(cur->bc_tp, 1);
 	new->s = cpu_to_be32(bno);
 
 	*stat = 1;
@@ -97,7 +96,6 @@ xfs_allocbt_free_block(
 
 	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
-	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index beb81c84a937..9f5bcbd834c3 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -103,7 +103,6 @@ xfs_rmapbt_alloc_block(
 	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1,
 			false);
 
-	xfs_trans_agbtree_delta(cur->bc_tp, 1);
 	new->s = cpu_to_be32(bno);
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
@@ -136,7 +135,6 @@ xfs_rmapbt_free_block(
 
 	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
-	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 
 	pag = cur->bc_ag.agbp->b_pag;
 	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b33c894b6cf3..be9cf88d2ad7 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -69,8 +69,6 @@ xfs_resizefs_init_new_ags(
 	if (error)
 		return error;
 
-	xfs_trans_agblocks_delta(tp, id->nfree);
-
 	if (delta) {
 		*lastag_extended = true;
 		error = xfs_ag_extend_space(mp, tp, id, delta);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bcc978011869..2b46b4f713d1 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -487,13 +487,6 @@ xfs_trans_apply_sb_deltas(
 	bp = xfs_trans_getsb(tp);
 	sbp = bp->b_addr;
 
-	/*
-	 * Check that superblock mods match the mods made to AGF counters.
-	 */
-	ASSERT((tp->t_fdblocks_delta + tp->t_res_fdblocks_delta) ==
-	       (tp->t_ag_freeblks_delta + tp->t_ag_flist_delta +
-		tp->t_ag_btree_delta));
-
 	/*
 	 * Only update the superblock counters if we are logging them
 	 */
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9dd745cf77c9..ee42d98d9011 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -140,11 +140,6 @@ typedef struct xfs_trans {
 	int64_t			t_res_fdblocks_delta; /* on-disk only chg */
 	int64_t			t_frextents_delta;/* superblock freextents chg*/
 	int64_t			t_res_frextents_delta; /* on-disk only chg */
-#if defined(DEBUG) || defined(XFS_WARN)
-	int64_t			t_ag_freeblks_delta; /* debugging counter */
-	int64_t			t_ag_flist_delta; /* debugging counter */
-	int64_t			t_ag_btree_delta; /* debugging counter */
-#endif
 	int64_t			t_dblocks_delta;/* superblock dblocks change */
 	int64_t			t_agcount_delta;/* superblock agcount change */
 	int64_t			t_imaxpct_delta;/* superblock imaxpct change */
@@ -165,16 +160,6 @@ typedef struct xfs_trans {
  */
 #define	xfs_trans_set_sync(tp)		((tp)->t_flags |= XFS_TRANS_SYNC)
 
-#if defined(DEBUG) || defined(XFS_WARN)
-#define	xfs_trans_agblocks_delta(tp, d)	((tp)->t_ag_freeblks_delta += (int64_t)d)
-#define	xfs_trans_agflist_delta(tp, d)	((tp)->t_ag_flist_delta += (int64_t)d)
-#define	xfs_trans_agbtree_delta(tp, d)	((tp)->t_ag_btree_delta += (int64_t)d)
-#else
-#define	xfs_trans_agblocks_delta(tp, d)
-#define	xfs_trans_agflist_delta(tp, d)
-#define	xfs_trans_agbtree_delta(tp, d)
-#endif
-
 /*
  * XFS transaction mechanism exported interfaces.
  */
