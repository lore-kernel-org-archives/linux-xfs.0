Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9112FC77B75
	for <linux-xfs@archiver.kernel.org>; Wed, 24 May 2023 00:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjEXA1r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 20:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjEXA1r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 20:27:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604ECB5
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E057F62F32
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 00:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460C4C433D2;
        Wed, 24 May 2023 00:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684888064;
        bh=Qbm60PqOlM5w0eqOBfRV8qQXZYpgQk1+vGbJRvcVTP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wtug2N3GHX7gZ7tyVkGTk5s6EMf/L/YUb3uBCoysXyUaI5E6IMT8CVffg7w8fGTy0
         72rrOY+g30pk+OUyjzYvESSP3cGqbljwuAaNBqiJ+epBcT9TIYlTbuln8b82r8LlJ0
         aR57a28wGjffJrxRMPdOt3lOKefOwqxWY6BZ5yv//KALfDUKhiF3y5zGm1zUEBK5EG
         GFj/1wWle3rmavSfAL9SDIZAVW05g3NTG3qMqb0tEVxbNQTq1yF73JJeGw2TIDYpSz
         +Z6wXLCuaj6gdXN9lz+Mf3YRNG0WZf7NuPvWSQC2BiXddTclBLlglC+nnR/fhRZRr6
         gm9UzUvbtAeAw==
Date:   Tue, 23 May 2023 17:27:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: Don't block in xfs_extent_busy_flush
Message-ID: <20230524002743.GF11620@frogsfrogsfrogs>
References: <20230519171829.4108-1-wen.gang.wang@oracle.com>
 <ZGrCpXoEk9achabI@dread.disaster.area>
 <E6E92519-4AD7-4115-903F-00D7633B1B3A@oracle.com>
 <ZGvvZaQWvxf2cqlz@dread.disaster.area>
 <8DD695CE-4965-4B33-8F16-6B907D8A0884@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8DD695CE-4965-4B33-8F16-6B907D8A0884@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:59:40AM +0000, Wengang Wang wrote:
> 
> 
> > On May 22, 2023, at 3:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Mon, May 22, 2023 at 06:20:11PM +0000, Wengang Wang wrote:
> >>> On May 21, 2023, at 6:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>> On Fri, May 19, 2023 at 10:18:29AM -0700, Wengang Wang wrote:
> >>>> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> >>>> index 011b50469301..3c5a9e9952ec 100644
> >>>> --- a/fs/xfs/xfs_extfree_item.c
> >>>> +++ b/fs/xfs/xfs_extfree_item.c
> >>>> @@ -336,6 +336,25 @@ xfs_trans_get_efd(
> >>>> return efdp;
> >>>> }
> >>>> 
> >>>> +/*
> >>>> + * Fill the EFD with all extents from the EFI and set the counter.
> >>>> + * Note: the EFD should comtain at least one extents already.
> >>>> + */
> >>>> +static void xfs_fill_efd_with_efi(struct xfs_efd_log_item *efdp)
> >>>> +{
> >>>> + struct xfs_efi_log_item *efip = efdp->efd_efip;
> >>>> + uint                    i;
> >>>> +
> >>>> + if (efdp->efd_next_extent == efip->efi_format.efi_nextents)
> >>>> + return;
> >>>> +
> >>>> + for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> >>>> +        efdp->efd_format.efd_extents[i] =
> >>>> +        efip->efi_format.efi_extents[i];
> >>>> + }
> >>>> + efdp->efd_next_extent = efip->efi_format.efi_nextents;
> >>>> +}
> >>>> +
> >>> 
> >>> Ok, but it doesn't dirty the transaction or the EFD, which means....
> >> 
> >> Actually EAGAIN shouldn’t happen with the first record in EFIs because
> >> the trans->t_busy is empty in AGFL block allocation for the first record.
> >> So the dirtying work should already done with the first one.
> > 
> > You're assuming that the only thing we are going to want to return
> > -EAGAIN for freeing attamps for is busy extents. Being able to
> > restart btree operations by "commit and retry" opens up a
> > a whole new set of performance optimisations we can make to the
> > btree code.
> > 
> > IOWs, I want this functionality to be generic in nature, not
> > tailored specifically to one situation where an -EAGAIN needs to be
> > returned to trigger a commit an retry.
> 
> Yes, I assumed that because I didn’t see relevant EAGAIN handlers
> in existing code. It’s reasonable to make it generic for existing or planed
> EAGAINs.
> 
> > 
> >>>> @@ -369,6 +388,10 @@ xfs_trans_free_extent(
> >>>> error = __xfs_free_extent(tp, xefi->xefi_startblock,
> >>>> xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
> >>>> xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
> >>>> + if (error == -EAGAIN) {
> >>>> + xfs_fill_efd_with_efi(efdp);
> >>>> + return error;
> >>>> + }
> >>> 
> >>> .... this is incorrectly placed.
> >>> 
> >>> The very next lines say:
> >>> 
> >>>> /*
> >>>> * Mark the transaction dirty, even on error. This ensures the
> >>>> * transaction is aborted, which:
> >>> 
> >>> i.e. we have to make the transaction and EFD log item dirty even if
> >>> we have an error. In this case, the error is not fatal, but we still
> >>> have to ensure that we commit the EFD when we roll the transaction.
> >>> Hence the transaction and EFD still need to be dirtied on -EAGAIN...
> >> 
> >> see above.
> > 
> > See above :)
> > 
> >>>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> >>>> index 322eb2ee6c55..00bfe9683fa8 100644
> >>>> --- a/fs/xfs/xfs_log_recover.c
> >>>> +++ b/fs/xfs/xfs_log_recover.c
> >>>> @@ -2540,30 +2540,27 @@ xlog_recover_process_intents(
> >>>> struct xfs_log_item *lip;
> >>>> struct xfs_ail *ailp;
> >>>> int error = 0;
> >>>> -#if defined(DEBUG) || defined(XFS_WARN)
> >>>> - xfs_lsn_t last_lsn;
> >>>> -#endif
> >>>> + xfs_lsn_t threshold_lsn;
> >>>> 
> >>>> ailp = log->l_ailp;
> >>>> + threshold_lsn = xfs_ail_max_lsn(ailp);
> >>>> spin_lock(&ailp->ail_lock);
> >>>> -#if defined(DEBUG) || defined(XFS_WARN)
> >>>> - last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
> >>> 
> >>> xfs_ail_max_lsn() and l_curr_cycle/l_curr_block are not the same
> >>> thing.  max_lsn points to the lsn of the last entry in the AIL (in
> >>> memory state), whilst curr_cycle/block points to the current
> >>> physical location of the log head in the on-disk journal.
> >>> 
> >> 
> >> Yes, I intended to use the lsn of the last entry in the AIL.
> > 
> > Again, they are not the same thing: using the last entry in the
> > AIL here is incorrect. We want to replay all the items in the AIL
> > that were active in the log, not up to the last item in the AIL. The
> > actively recovered log region ends at last_lsn as per above, whilst
> > xfs_ail_max_lsn() is not guaranteed to be less than last_lsn before
> > we start walking it.
> 
> OK, got it.
> 
> > 
> >> For the problem with xlog_recover_process_intents(), please see my reply to
> >> Darrick. On seeing the problem, my first try was to use “last_lsn” to stop
> >> the iteration but that didn’t help.  last_lsn was found quite bigger than even
> >> the new EFI lsn. While use xfs_ail_max_lsn() it solved the problem.
> > 
> > In what case are we queuing a *new* intent into the AIL that has a
> > LSN less than xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block)?
> > If we are doing that *anywhere*, then we have a likely journal
> > corruption bug in the code because it indicates we committed that
> > item to the journal over something in the log we are currently
> > replaying.
> 
> I made a mistake to say last_lsn is quite bigger than the new EFI lsn,
> it’s actually much bigger than the max_lsn (because cycle increased).
> The lsn of the new EFI is exactly same as last_lsn.
> 
> > 
> >>> In this case, we can't use in-memory state to determine where to
> >>> stop the initial intent replay - recovery of other items may have
> >>> inserted new intents beyond the end of the physical region being
> >>> recovered, in which case using xfs_ail_max_lsn() will result in
> >>> incorrect behaviour here.
> >> 
> >> Yes, this patch is one of those (if some exist) introduce new intents (EFIs here).
> >> We add the new intents to the transaction first (xfs_defer_create_intent()), add
> >> the deferred operations to ‘capture_list’. And finally the deferred options in
> >> ‘capture_list’ is processed after the intent-iteration on the AIL.
> > 
> > The changes made in that transaction, including the newly logged
> > EFI, get committed before the rest of the work gets deferred via
> > xfs_defer_ops_capture_and_commit(). That commits the new efi (along
> > with all the changes that have already been made in the transaction)
> > to the CIL, and eventually the journal checkpoints and the new EFI
> > gets inserted into the AIL at the LSN of the checkpoint.
> > 
> > The LSN of the checkpoint is curr_cycle/block - the log head -
> > because that's where the start record of the checkpoint is
> > physically written.  As each iclog is filled, the log head moves
> > forward - it always points at the location that the next journal
> > write will be written to. At the end of a checkpoint, the LSN of the
> > start record is used for AIL insertion.
> > 
> 
> Thanks for explanation!
> 
> > Hence if a new log item created by recovery has a LSN less than
> > last_lsn, then we have a serious bug somewhere that needs to be
> > found and fixed. The use of last_lsn tells us something has gone
> > badly wrong during recovery, the use of xfs_ail_max_lsn() removes
> > the detection of the issue and now we don't know that something has
> > gone badly wrong...
> > 
> 
> I made a mistake.. the (first) new EFI lsn is the same as last_lsn, sorry
> for confusing.
> 
> >> For existing other cases (if there are) where new intents are added,
> >> they don’t use the capture_list for delayed operations? Do you have example then? 
> >> if so I think we should follow their way instead of adding the defer operations
> >> (but reply on the intents on AIL).
> > 
> > All of the intent recovery stuff uses
> > xfs_defer_ops_capture_and_commit() to commit the intent being
> > replayed and cause all further new intent processing in that chain
> > to be defered until after all the intents recovered from the journal
> > have been iterated. All those new intents end up in the AIL at a LSN
> > index >= last_lsn.
> 
> Yes. So we break the AIL iteration on seeing an intent with lsn equal to
> or bigger than last_lsn and skip the iop_recover() for that item?
> and shall we put this change to another separated patch as it is to fix
> an existing problem (not introduced by my patch)?

Intent replay creates non-intent log items (like buffers or inodes) that
are added to the AIL with an LSN higher than last_lsn.  I suppose it
would be possible to break log recovery if an intent's iop_recover
method immediately logged a new intent and returned EAGAIN to roll the
transaction, but none of them do that; and I think the ASSERT you moved
would detect such a thing.

--D

> thanks,
> wengang
