Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC516C433ED
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Apr 2021 15:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A864861288
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Apr 2021 15:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhDYPrO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Apr 2021 11:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230288AbhDYPrO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 25 Apr 2021 11:47:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A00B060FD9;
        Sun, 25 Apr 2021 15:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619365594;
        bh=RSG0gGiBDXZHb1Nn4RvGFG1oNijARjRyaZeuB0Xs2tg=;
        h=Date:From:To:Cc:Subject:From;
        b=muOvgcsXcvKAcm0pF2UvF1yaW8lW2cmGW8RuvmuLCzGMn6hriZ+if1oc4H35b/doF
         v8fNJU3QCxL+Z+W6fnKb4uPmzNl+UvOTMSN3IIOp0lh5tLCFxQNHlCdNr2fHCyMRqR
         GLb41T+nx2AtItZH7qba6n5yw1FMJA5k19HPq7zD9xa2sD/965rtJWLBZUgrskCqoQ
         CNsAcvAFaXrvSK3iT8/3ln6ya+RSrFU/YUhTfbT1M2cuEknqSzymSpCdnoTghZaA1s
         //ZDJnmm8JfrP5i4D07tuHDoZdzfhIortVDhf/pWuNZ64m/R2qPcrcEp7qCfla5kBz
         tCedXPJaWiJUA==
Date:   Sun, 25 Apr 2021 08:46:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     bfoster@redhat.com, zlang@redhat.com
Subject: [PATCH] xfs: fix debug-mode accounting for deferred AGFL freeing
Message-ID: <20210425154634.GZ3122264@magnolia>
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

This bug was found by running generic/051 on either a V4 filesystem
lacking lazysbcount; or a V5 filesystem with a realtime volume.

Fixes: f8f2835a9cf3 ("xfs: defer agfl block frees when dfops is available")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index aaa19101bb2a..66e7edf86a50 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2472,6 +2472,22 @@ xfs_defer_agfl_block(
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
+
+	/*
+	 * Debugging assertions in the transaction accounting code require that
+	 * updates to an AGF freelist count are cancelled out by an update to
+	 * an AGF free block count.  Prior to deferred AGFL freeing, we removed
+	 * a block from the AGFL and freed it in the same transaction, which
+	 * satisfied this invariant.
+	 *
+	 * Now that we defer the actual freeing to a subsequent transaction in
+	 * the chain, this no longer holds true.  Debug delta counters do not
+	 * roll over, so pretend that we updated an AGF free block count
+	 * somewhere.  The EFI for the AGFL block is logged in the same
+	 * transaction as the AGFL change, which is how we maintain integrity
+	 * even if the system goes down.
+	 */
+	xfs_trans_agblocks_delta(tp, 1);
 }
 
 #ifdef DEBUG
