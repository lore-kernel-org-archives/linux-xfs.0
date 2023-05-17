Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A205BC77B7F
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 00:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjEQA7S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 20:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjEQA7R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 20:59:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF9330D2
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 17:59:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55F4063AC5
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 00:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A059AC433EF;
        Wed, 17 May 2023 00:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684285153;
        bh=xm9IczGdzAXiHdfFYElD1z2rsAANSyUX99JfUU678U0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s3OugeaMqp3sTvNLhf/rZFHQj4rWEwxpEOsCExsazR09E0NlXF/CSbyGPfvb31fLc
         xn4e4TuE1+emo40R3H6CpQWsHKsNlGzlwQH97LBJoELZfWloze/E2LithGd6/5vVqJ
         u1cNwjX8GLBAN9tKxbeBZRnBCGT5syjNRS2Ez5NwEv4Usja3hrasFQrrhCMOjJI2u5
         FkoyJj7/TtaIBkjyv+/OV9aBnbd6T390yu7T+nnpe4OQyNFHYgkMTB+uIpQJBURkUl
         mRF1zTWVbQsBeXMaSLoI798ekrsRb/LSb4FoR3eYB4YE/JLzI16NbnZwIrwqSZPpRb
         9x3IB2lGXq+cg==
Date:   Tue, 16 May 2023 17:59:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Message-ID: <20230517005913.GM858799@frogsfrogsfrogs>
References: <20230424225102.23402-1-wen.gang.wang@oracle.com>
 <20230512182455.GJ858799@frogsfrogsfrogs>
 <592C0DE1-F4F5-4C9A-8799-E9E81524CDC0@oracle.com>
 <20230512211326.GK858799@frogsfrogsfrogs>
 <050A91C4-54EC-4EB8-A701-7C9F640B7ADB@oracle.com>
 <11835435-29A1-4F34-9CE5-C9ED84567E98@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11835435-29A1-4F34-9CE5-C9ED84567E98@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 16, 2023 at 04:05:20PM +0000, Wengang Wang wrote:
> Hi Darrick, do you have further comments?

Now I do.  I chatted with Dave earlier about this, since I think it's a
layering violation to have the EFI and the CLI (aka the logging layer)
banging on an atomic counter in the perag structure.

(More later on below)

> thanks,
> wengang
> 
> > On May 12, 2023, at 3:20 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> > 
> > 
> > 
> >> On May 12, 2023, at 2:13 PM, Darrick J. Wong <djwong@kernel.org> wrote:
> >> 
> >> On Fri, May 12, 2023 at 07:55:28PM +0000, Wengang Wang wrote:
> >>> Hi Darrick,
> >>> 
> >>>> On May 12, 2023, at 11:24 AM, Darrick J. Wong <djwong@kernel.org> wrote:
> >>>> 
> >>>> Sorry for the slow response, I thought Dave would've responded by now.
> >>>> 
> >>>> On Mon, Apr 24, 2023 at 03:51:02PM -0700, Wengang Wang wrote:
> >>>>> To avoid possible deadlock when allocating AGFL blocks, change the behaviour.
> >>>>> The orignal hehaviour for freeing extents in an EFI is that the extents in
> >>>>> the EFI were processed one by one in the same transaction. When the second
> >>>>> and subsequent extents are being processed, we have produced busy extents for
> >>>>> previous extents. If the second and subsequent extents are from the same AG
> >>>>> as the busy extents are, we have the risk of deadlock when allocating AGFL
> >>>>> blocks. A typical calltrace for the deadlock is like this:
> >>>> 
> >>>> It's been a few weeks, so let me try to remember what this is all about.
> >>>> You have one EFI containing multiple extents to free:
> >>>> 
> >>>> {agno: 3, agbno: X, ... }
> >>>> {agno: 3, agbno: Y, ... }
> >>>> 
> >>>> AG 3 is nearly full, so we free the first extent (3/X), which adds it to
> >>>> the bnobt, records the newly freed extent in the extentbusylist, and
> >>>> attaches the record to the transaction's busy extent list.
> >>>> 
> >>>> Then we move on to the second record in the EFI item.  We want to free
> >>>> (3/Y), but whoops the AGFL isn't big enough to handle maximal expansion
> >>>> of the bnobt/cntbt btrees.
> >>>> 
> >>>> So we try to fix the AG 3 AGFL to be long enough.  We can find the space
> >>>> in the bnobt, but the only space available is the (3/X) that we put
> >>>> there during the last step.  That space is still(!) busy and still
> >>>> attached to the transaction, so the CIL cannot clear it.  The AGFL fixer
> >>>> sees that the space is busy, so it waits for it... and now we're dead in
> >>>> the water.
> >>>> 
> >>>> The key to this deadlock is a thread waiting on its own uncommitted busy
> >>>> extent, right?
> >>>> 
> >>> 
> >>> Yep, above is all correct.
> >>> 
> >>>>> 
> >>>>> #0 context_switch() kernel/sched/core.c:3881
> >>>>> #1 __schedule() kernel/sched/core.c:5111
> >>>>> #2 schedule() kernel/sched/core.c:5186
> >>>>> #3 xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
> >>>>> #4 xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
> >>>>> #5 xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
> >>>>> #6 xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
> >>>>> #7 xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
> >>>>> #8 __xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
> >>>>> #9 xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
> >>>>> #10 xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
> >>>>> #11 xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
> >>>>> #12 xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
> >>>>> #13 xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
> >>>>> #14 xfs_log_mount_finish() fs/xfs/xfs_log.c:764
> >>>>> #15 xfs_mountfs() fs/xfs/xfs_mount.c:978
> >>>>> #16 xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
> >>>>> #17 mount_bdev() fs/super.c:1417
> >>>>> #18 xfs_fs_mount() fs/xfs/xfs_super.c:1985
> >>>>> #19 legacy_get_tree() fs/fs_context.c:647
> >>>>> #20 vfs_get_tree() fs/super.c:1547
> >>>>> #21 do_new_mount() fs/namespace.c:2843
> >>>>> #22 do_mount() fs/namespace.c:3163
> >>>>> #23 ksys_mount() fs/namespace.c:3372
> >>>>> #24 __do_sys_mount() fs/namespace.c:3386
> >>>>> #25 __se_sys_mount() fs/namespace.c:3383
> >>>>> #26 __x64_sys_mount() fs/namespace.c:3383
> >>>>> #27 do_syscall_64() arch/x86/entry/common.c:296
> >>>>> #28 entry_SYSCALL_64() arch/x86/entry/entry_64.S:180
> >>>>> 
> >>>>> The deadlock could happen at both IO time and log recover time.
> >>>>> 
> >>>>> To avoid above deadlock, this patch changes the extent free procedure.
> >>>>> 1) it always let the first extent from the EFI go (no change).
> >>>>> 2) increase the (new) AG counter when it let a extent go.
> >>>>> 3) for the 2nd+ extents, if the owning AGs ready have pending extents
> >>>>> don't let the extent go with current transaction. Instead, move the
> >>>>> extent in question and subsequent extents to a new EFI and try the new
> >>>>> EFI again with new transaction (by rolling current transaction).
> >>>>> 4) for the EFD to orginal EFI, fill it with all the extents from the original
> >>>>> EFI.
> >>>>> 5) though the new EFI is placed after original EFD, it's safe as they are in
> >>>>> same in-memory transaction.
> >>>>> 6) The new AG counter for pending extent freeings is decremented after the
> >>>>> log items in in-memory transaction is committed to CIL.
> >>>> 
> >>>> So the solution you're proposing is a per-AG counter of however many
> >>>> threads have started an EFI free.  If the second (or subsequent) EFI
> >>>> free encounters an AG with a nonzero counter, it'll return EAGAIN to
> >>>> cycle the transaction.  The cycling is critical to getting the busy
> >>>> extent to the CIL so the log can process it and make it unbusy.  If the
> >>>> AG wasn't contended (pag_nr_pending_extents was 0), it proceeds with the
> >>>> freeing, having bumped the per-AG counter.  Right?
> >>> 
> >>> Right.
> >>> 
> >>>> 
> >>>> Therefore, the above deadlock sequence now becomes:
> >>>> 
> >>>> 1. Free (3/X), placing (3/X) on the transaction's busy list.
> >>>> 
> >>>> 2. Start trying to free (3/Y), notice that AG 3 has elevated
> >>>> pag_nr_pending_extents, return EAGAIN
> >>>> 
> >>>> 3. Roll transaction, which moves (3/X) to the CIL and gets us a fresh
> >>>> transaction
> >>>> 
> >>>> 4. Try to free (3/Y) again
> >>>> 
> >>>> At step 4, if pag_nr_pending_extents is still elevated, does that
> >>>> mean we return EAGAIN and keep rolling the transaction until it's not
> >>>> elevated?  Shouldn't we be able to proceed at step 4, even if we end up
> >>>> waiting on the log to clear (3/X) from the busy list?
> >>> 
> >>> The pag_nr_pending_extents is expected to be decremented in step 3.
> >> 
> >> OH.  I missed (and you pointed out below) the subtlety that step 3 gives
> >> us a fresh transaction /and/ a fresh EFI, so after the roll, (3/Y) is
> >> the "first" EFI and never has to wait.
> > 
> > Yes exactly.
> > 
> >> 
> >>> The changes in xlog_cil_insert_items() is supposed to do so.  So at
> >>> step 4, for this cass {3/x, 3/y}, pag_nr_pending_extents should be
> >>> decremented to zero, thus step 4 can go (after that busy extent 3/x is
> >>> cleared).
> >> 
> >> So even if the log is being slow and the CIL hasn't cleared the busy
> >> extent (3/X) by the time we finish rolling the tx and relogging the EFI,
> >> the relogged EFI will start with (3/Y) and move forward without waiting.
> >> Got it.
> > 
> > Correct. There is no waiting while we start to process the EFI records,
> > The point here is that we process the records in the existing transaction or
> > in new transactions (rolling current one).

I think the exact point where the filesystem stalls is the
xfs_extent_busy_flush calls in xfs_alloc_ag_vextent_size, right?

Prior to 6.3, this was:

xfs_alloc_fix_freelist ->
XFS_ALLOCTYPE_THIS_AG ->
xfs_alloc_ag_vextent ->
xfs_alloc_ag_vextent_size ->
(run all the way to the end of the bnobt) ->
xfs_extent_busy_flush ->
<stall on the busy extent that's in @tp->busy_list>

Since 6.3 we got rid of the _THIS_AG indirection stuff and that becomes:

xfs_alloc_fix_freelist ->
xfs_alloc_ag_vextent_size ->
(run all the way to the end of the bnobt) ->
xfs_extent_busy_flush ->
<stall on the busy extent that's in @tp->busy_list>

xfs_extent_busy_flush does this, potentially while we're holding the
freed extent in @tp->t_busy_list:

	error = xfs_log_force(mp, XFS_LOG_SYNC);
	if (error)
		return;

	do {
		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
		if  (busy_gen != READ_ONCE(pag->pagb_gen))
			break;
		schedule();
	} while (1);

	finish_wait(&pag->pagb_wait, &wait);

The log force kicks the CIL to process whatever other committed items
might be lurking in the log.  *Hopefully* someone else freed an extent
in the same AG, so the log force has now caused that *other* extent to
get processed so it has now cleared the busy list.  Clearing something
from the busy list increments the busy generation (aka pagb_gen).

Unfortunately, there aren't any other extents, so the busy_gen does not
change, and the loop runs forever.

At this point, Dave writes:

[15:57] <dchinner> so if we enter that function with busy extents on the
transaction, and we are doing an extent free operation, we should return
after the sync log force and not do the generation number wait

[15:58] <dchinner> if we fail to allocate again after the sync log force
and the generation number hasn't changed, then return -EAGAIN because no
progress has been made.

[15:59] <dchinner> Then the transaction is rolled, the transaction busy
list is cleared, and if the next allocation attempt fails becaues
everything is busy, we go to sleep waiting for the generation to change

[16:00] <dchinner> but because the transaction does not hold any busy
extents, it cannot deadlock here because it does not pin any extents
that are in the busy tree....

[16:05] <dchinner> All the generation number is doing here is telling us
whether there was busy extent resolution between the time we last
skipped a viable extent because it was busy and when the flush
completes.

[16:06] <dchinner> it doesn't mean the next allocation will succeed,
just that progress has been made so trying the allocation attempt will
at least get a different result to the previous scan.

I think the callsites go from this:

	if (busy) {
		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
		trace_xfs_alloc_size_busy(args);
		xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
		goto restart;
	}

to something like this:

	bool	try_log_flush = true;
	...
restart:
	...

	if (busy) {
		bool	progress;

		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
		trace_xfs_alloc_size_busy(args);

		/*
		 * If the current transaction has an extent on the busy
		 * list, we're allocating space as part of freeing
		 * space, and all the free space is busy, we can't hang
		 * here forever.  Force the log to try to unbusy free
		 * space that could have been freed by other
		 * transactions, and retry the allocation.  If the
		 * allocation fails a second time because all the free
		 * space is busy and nobody made any progress with
		 * clearing busy extents, return EAGAIN so the caller
		 * can roll this transaction.
		 */
		if ((flags & XFS_ALLOC_FLAG_FREEING) &&
		    !list_empty(&tp->t_busy_list)) {
			int log_flushed;

			if (try_log_flush) {
				_xfs_log_force(mp, XFS_LOG_SYNC, &log_flushed);
				try_log_flush = false;
				goto restart;
			}

			if (busy_gen == READ_ONCE(pag->pagb_gen))
				return -EAGAIN;

			/* XXX should we set try_log_flush = true? */
			goto restart;
		}

		xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
		goto restart;
	}

IOWs, I think Dave wants us to keep the changes in the allocator instead
of spreading it around.

--D

> > 
> >> 
> >>>> 
> >>>> What happens if the log actually clears (3/X) from the busy list after
> >>>> step 3 but then some other thread starts processing an EFI for (3/Z)?
> >>> 
> >>> There is a rule in the patch that the first record in an EFI can always go (bumping
> >>> the per AG counter). That’s because the freeing the first record never has
> >>> the deadlock issue.
> >>> 
> >>> The 3/Y would go because now the 3/Y is the first record of the new EFI
> >>> containing only record of 3/Y.
> >> 
> >> Oh, ok.  I missed that.
> >> 
> >>> For the other thread for 3/Z,  3/Z can go too because it’s the first record in
> >>> that EFI (bumping the per AG counter, now the counter could be 3 at most).
> >> 
> >> <nod>
> >> 
> >>> 
> >>>> Does that cause this thread to roll repeatedly waiting for another
> >>>> thread's EFI to clear?
> >>> 
> >>> Nope. As I said, the first record can always go. For the 2nd and subsequent
> >>> record, on retry, they would become the first record in the new FEI and it goes.
> >> 
> >> <nod>
> >> 
> >>>> 
> >>>> IOWs, I'm not sure we can always make forward progress with this scheme,
> >>>> and I'd prefer to avoid introducing more global state.
> >>> 
> >>> See above explanation.
> >>> 
> >>>> 
> >>>>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> >>>>> ---
> >>>>> fs/xfs/libxfs/xfs_ag.c    |   1 +
> >>>>> fs/xfs/libxfs/xfs_ag.h    |   5 ++
> >>>>> fs/xfs/xfs_extfree_item.c | 111 +++++++++++++++++++++++++++++++++++++-
> >>>>> fs/xfs/xfs_log_cil.c      |  24 ++++++++-
> >>>>> 4 files changed, 138 insertions(+), 3 deletions(-)
> >>>>> 
> >>>>> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> >>>>> index 86696a1c6891..61ef61e05668 100644
> >>>>> --- a/fs/xfs/libxfs/xfs_ag.c
> >>>>> +++ b/fs/xfs/libxfs/xfs_ag.c
> >>>>> @@ -378,6 +378,7 @@ xfs_initialize_perag(
> >>>>> pag->pagb_tree = RB_ROOT;
> >>>>> #endif /* __KERNEL__ */
> >>>>> 
> >>>>> + atomic_set(&pag->pag_nr_pending_extents, 0);
> >>>>> error = xfs_buf_hash_init(pag);
> >>>>> if (error)
> >>>>> goto out_remove_pag;
> >>>>> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> >>>>> index 5e18536dfdce..5950bc36a32c 100644
> >>>>> --- a/fs/xfs/libxfs/xfs_ag.h
> >>>>> +++ b/fs/xfs/libxfs/xfs_ag.h
> >>>>> @@ -82,6 +82,11 @@ struct xfs_perag {
> >>>>> uint16_t pag_sick;
> >>>>> spinlock_t pag_state_lock;
> >>>>> 
> >>>>> + /*
> >>>>> +  * Number of concurrent extent freeings (not committed to CIL yet)
> >>>>> +  * on this AG.
> >>>>> +  */
> >>>>> + atomic_t pag_nr_pending_extents;
> >>>>> spinlock_t pagb_lock; /* lock for pagb_tree */
> >>>>> struct rb_root pagb_tree; /* ordered tree of busy extents */
> >>>>> unsigned int pagb_gen; /* generation count for pagb_tree */
> >>>>> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> >>>>> index 011b50469301..1dbf36d9c1c9 100644
> >>>>> --- a/fs/xfs/xfs_extfree_item.c
> >>>>> +++ b/fs/xfs/xfs_extfree_item.c
> >>>>> @@ -336,6 +336,75 @@ xfs_trans_get_efd(
> >>>>> return efdp;
> >>>>> }
> >>>>> 
> >>>>> +/*
> >>>>> + * Fill the EFD with all extents from the EFI and set the counter.
> >>>>> + * Note: the EFD should comtain at least one extents already.
> >>>>> + */
> >>>>> +static void xfs_fill_efd_with_efi(struct xfs_efd_log_item *efdp)
> >>>>> +{
> >>>>> + struct xfs_efi_log_item *efip = efdp->efd_efip;
> >>>>> + uint i;
> >>>>> +
> >>>>> + i = efdp->efd_next_extent;
> >>>>> + ASSERT(i > 0);
> >>>>> + for (; i < efip->efi_format.efi_nextents; i++) {
> >>>>> + efdp->efd_format.efd_extents[i] =
> >>>>> + efip->efi_format.efi_extents[i];
> >>>> 
> >>>> Why is it necessary to fill the EFD mapping structures?  Nobody /ever/
> >>>> looks at those; the only part that matters to log recovery is matching
> >>>> efd.efd_efi_id to efi.efi_id.
> >>> 
> >>> Yes, that’s for EFI/EFD matching for log recovery.
> >>> The records to be retried would be in a new EFI.
> >>> 
> >>>> 
> >>>> But, I guess it looks funny to requeue an EFI and have the EFD for the
> >>>> old EFI missing a bunch of fields.
> >>> 
> >>> The EFD to the original EFI is not missing anything, it is expected
> >>> to be exact the same as if all the records are processed.
> >>> By this way we move records to new EFI(s) to avoid the deadlock.
> >>> 
> >>>> 
> >>>>> + }
> >>>>> + efdp->efd_next_extent = i;
> >>>>> +}
> >>>>> +
> >>>>> +/*
> >>>>> + * Check if xefi is the first in the efip.
> >>>>> + * Returns true if so, ad false otherwise
> >>>>> + */
> >>>>> +static bool xfs_is_first_extent_in_efi(struct xfs_efi_log_item *efip,
> >>>>> +   struct xfs_extent_free_item *xefi)
> >>>>> +{
> >>>>> + return efip->efi_format.efi_extents[0].ext_start ==
> >>>>> + xefi->xefi_startblock;
> >>>>> +}
> >>>>> +
> >>>>> +/*
> >>>>> + * Check if the xefi needs to be in a new transaction.
> >>>>> + * efip is the containing EFI of xefi.
> >>>>> + * Return true if so, false otherwise.
> >>>>> + */
> >>>>> +static bool xfs_extent_free_need_new_trans(struct xfs_mount *mp,
> >>>>> +     struct xfs_efi_log_item *efip,
> >>>>> +     struct xfs_extent_free_item *xefi)
> >>>>> +{
> >>>>> + bool ret = true;
> >>>>> + int nr_pre;
> >>>>> + xfs_agnumber_t agno;
> >>>>> + struct xfs_perag *pag;
> >>>>> +
> >>>>> + agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
> >>>>> + pag = xfs_perag_get(mp, agno);
> >>>>> + /* The first extent in EFI is always OK to go */
> >>>>> + if (xfs_is_first_extent_in_efi(efip, xefi)) {
> >>>>> + atomic_inc(&pag->pag_nr_pending_extents);
> >>>>> + ret = false;
> >>>>> + goto out_put;
> >>>>> + }
> >>>>> +
> >>>>> + /*
> >>>>> +  * Now the extent is the 2nd or subsequent in the efip. We need
> >>>>> +  * new transaction if the AG already has busy extents pending.
> >>>>> +  */
> >>>>> + nr_pre = atomic_inc_return(&pag->pag_nr_pending_extents) - 1;
> >>>>> + /* No prevoius pending extent freeing to this AG */
> >>>>> + if (nr_pre == 0) {
> >>>>> + ret = false;
> >>>>> + goto out_put;
> >>>>> + }
> >>>>> +
> >>>>> + atomic_dec(&pag->pag_nr_pending_extents);
> >>>>> +out_put:
> >>>>> + xfs_perag_put(pag);
> >>>>> + return ret;
> >>>>> +}
> >>>>> +
> >>>>> /*
> >>>>> * Free an extent and log it to the EFD. Note that the transaction is marked
> >>>>> * dirty regardless of whether the extent free succeeds or fails to support the
> >>>>> @@ -356,6 +425,28 @@ xfs_trans_free_extent(
> >>>>> xfs_agblock_t agbno = XFS_FSB_TO_AGBNO(mp,
> >>>>> xefi->xefi_startblock);
> >>>>> int error;
> >>>>> + struct xfs_efi_log_item *efip = efdp->efd_efip;
> >>>>> +
> >>>>> + if (xfs_extent_free_need_new_trans(mp, efip, xefi)) {
> >>>>> + /*
> >>>>> +  * This should be the 2nd+ extent, we don't have to mark the
> >>>>> +  * transaction and efd dirty, those are already done with the
> >>>>> +  * first extent.
> >>>>> +  */
> >>>>> + ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
> >>>>> + ASSERT(tp->t_flags & XFS_TRANS_HAS_INTENT_DONE);
> >>>>> + ASSERT(test_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags));
> >>>>> +
> >>>>> + xfs_fill_efd_with_efi(efdp);
> >>>>> +
> >>>>> + /*
> >>>>> +  * A preious extent in same AG is processed with the current
> >>>>> +  * transaction. To avoid possible AGFL allocation deadlock,
> >>>>> +  * we roll the transaction and then restart with this extent
> >>>>> +  * with new transaction.
> >>>>> +  */
> >>>>> + return -EAGAIN;
> >>>>> + }
> >>>>> 
> >>>>> oinfo.oi_owner = xefi->xefi_owner;
> >>>>> if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
> >>>>> @@ -369,6 +460,13 @@ xfs_trans_free_extent(
> >>>>> error = __xfs_free_extent(tp, xefi->xefi_startblock,
> >>>>> xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
> >>>>> xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
> >>>>> + if (error) {
> >>>>> + struct xfs_perag *pag;
> >>>>> +
> >>>>> + pag = xfs_perag_get(mp, agno);
> >>>>> + atomic_dec(&pag->pag_nr_pending_extents);
> >>>>> + xfs_perag_put(pag);
> >>>>> + }
> >>>>> /*
> >>>>> * Mark the transaction dirty, even on error. This ensures the
> >>>>> * transaction is aborted, which:
> >>>>> @@ -476,7 +574,8 @@ xfs_extent_free_finish_item(
> >>>> 
> >>>> This function comes with an unused **state variable:
> >>>> 
> >>> 
> >>> I don’t see why we need to take different action according to
> >>> the ‘state’.  
> >>> 
> >>>> STATIC int
> >>>> xfs_extent_free_finish_item(
> >>>> struct xfs_trans *tp,
> >>>> struct xfs_log_item *done,
> >>>> struct list_head *item,
> >>>> struct xfs_btree_cur **state)
> >>>> 
> >>>> What if, after each xfs_trans_free_extent call, we stuff *state with
> >>>> xefi_startblock's AG?
> >>>> 
> >>> 
> >>> see Above.
> >>> 
> >>>> Then, upon entry to xfs_extent_free_finish_item, we compare *state with
> >>>> the xefi item and return EAGAIN if we're processing an EFI from the same
> >>>> AG as the previous call to xfs_extent_free_finish_item?  Something like
> >>>> this (totally untested):
> >>>> 
> >>>> STATIC int
> >>>> xfs_extent_free_finish_item(
> >>>> struct xfs_trans *tp,
> >>>> struct xfs_log_item *done,
> >>>> struct list_head *item,
> >>>> struct xfs_btree_cur **state)
> >>>> {
> >>>> struct xfs_extent_free_item *xefi;
> >>>> int error;
> >>>> 
> >>>> xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
> >>>> 
> >>>> if (*state) {
> >>>> struct xfs_perag *oldpag = *(struct xfs_perag **)state;
> >>>> 
> >>>> /*
> >>>> * If we're freeing two extents from the same AG, we
> >>>> * must roll the transaction between the two extents to
> >>>> * avoid a livelock resulting from AGFL fixing waiting
> >>>> * on the extent that we just freed to become unbusy.
> >>>> */
> >>>> if (oldpag == xefi->xefi_pag) {
> >>>> xfs_fill_efd_with_efi(EFD_ITEM(done));
> >>>> xfs_perag_put(oldpag);
> >>>> return -EAGAIN;
> >>>> }
> >>> 
> >>> As I said the first record would let go, we don’t care previous AG.
> >>> 
> >>>> xfs_perag_put(oldpag);
> >>>> }
> >>>> 
> >>>> error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
> >>>> if (!error)
> >>>> *state = (void *)xfs_perag_hold(xefi->xefi_pag);
> >>>> 
> >>>> xfs_extent_free_put_group(xefi);
> >>>> kmem_cache_free(xfs_extfree_item_cache, xefi);
> >>>> return error;
> >>>> }
> >>>> 
> >>>> Obviously, you now need a ->finish_cleanup function to drop the perag
> >>>> reference that may be stashed in @state.  This (I think) avoids the
> >>>> livelock by ensuring that xfs_trans_free_extent always starts with a
> >>>> transaction that does not contain any busy extents from the same AG that
> >>>> it's acting on, right?
> >>> 
> >>> Nope, we don’t need to pass perag in state. Still the rule:
> >>> 
> >>> The first record in an EFI (no matter it’s the original EFI or new EFIs) just
> >>> goes (because it won’t hit the deadlock).
> >>> 
> >>> For the 2nd or subsequent records, we need to see if there are any pending
> >>> busy_extent to the same AG as the record belongs to. “pending” means
> >>> those are still in xfs_trans->t_busy (not committed to xlog_cil_pcp->busy_extents
> >>> yet). We know that by checking the newly introduced per AG counter
> >>> pag_nr_pending_extents. If there are, we retry the record in a new EFI
> >>> in a new transaction after committing the original transaction. With in the new
> >>> EFI, the 2nd record in the original EFI become the 1st record, and it just can
> >>> go (because it won’t hit the deadlock).
> >> 
> >> <nod> So in other words, the pag_nr_pending_extents counter buys us the
> >> performance advantage that we don't need to add the extra roll between
> >> (3/X) and (3/Y) if the log is running fast enough to clear the busy
> >> extent before we even start evaluating the relogged EFI (with 3/Y in
> >> it).
> > 
> > I’d think there needs a transaction roll between (3/X) and (3/Y). If we don’t do that
> > we would have a “pending” busy extent in current xfs_trans->t_busy while processing
> > (3/Y). And that busy extent had no chance to be cleared because it’s not committed
> > to xlog_cil_pcp->busy_extents yet and CIL flushing won’t take care of busy extents
> > which are not in busy_extents. So if no transaction roll in (3/X) and (3/Y), we still
> > have the risk to the dead lock when allocating blocks for AGFL.
> > 
> >> 
> >> How often does it happen that we have to roll the transaction and relog
> >> the EFI?
> > 
> > It could depend on the use case. This may happen when truncating files.
> > 
> > 
> >> 
> >>> We are using per AG counter here to know if there are pending busy extents
> >>> rather than comparing with the involved previous AGs in the same EFI to avoid
> >>> also the potential ABBA dead lock:
> >>> thread 1:  {3/X, 4/Y}
> >>> thread 2:  {4/Z, 3/T}
> >>> 
> >>>> 
> >>>> A simpler version of the above would make it so that we always roll
> >>>> between EFI records and don't have to manage perag references:
> >>>> 
> >>>> #define XFS_EFI_STATE_ROLL ((struct xfs_btree_cur *)1)
> >>>> STATIC int
> >>>> xfs_extent_free_finish_item(
> >>>> struct xfs_trans *tp,
> >>>> struct xfs_log_item *done,
> >>>> struct list_head *item,
> >>>> struct xfs_btree_cur **state)
> >>>> {
> >>>> struct xfs_extent_free_item *xefi;
> >>>> int error;
> >>>> 
> >>>> /*
> >>>> * If we're freeing two extents, roll the transaction between
> >>>> * the two extents to avoid a livelock resulting from AGFL
> >>>> * fixing waiting on the extent that we just freed to become
> >>>> * unbusy.  It's not necessary to roll if the previous and
> >>>> * current EFI record point to different AGs, but this
> >>>> * simplifies the state tracking.
> >>>> */
> >>>> if (*state == XFS_EFI_STATE_ROLL) {
> >>>> xfs_fill_efd_with_efi(EFD_ITEM(done));
> >>>> *state = NULL;
> >>>> return -EAGAIN;
> >>>> }
> >>>> 
> >>>> xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
> >>>> 
> >>>> error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
> >>>> if (!error)
> >>>> *state = XFS_EFI_STATE_ROLL;
> >>>> 
> >>>> xfs_extent_free_put_group(xefi);
> >>>> kmem_cache_free(xfs_extfree_item_cache, xefi);
> >>>> return error;
> >>>> }
> >>>> 
> >>> 
> >>> By this way, it looks to me that the original EFI is always splitted into several ones
> >>> each including only records.  It’s the same result as we change 
> >>> XFS_EFI_MAX_FAST_EXTENTS to 1.  Dave doesn’t like that.
> >> 
> >> Yes.
> >> 
> >>> My implantation split them only when necessary as Dave suggested.
> >>> 
> >>>> (Did you and Dave already talk about this?)
> >>> 
> >>> There many discussion in this two threads:
> >>> [PATCH 2/2] xfs: log recovery stage split EFIs with multiple extents
> >>> [PATCH 1/2] xfs: IO time one extent per EFI
> >> 
> >> Ok, I'll go reread all that.
> > 
> > thanks,
> > wengang
> 
> 
