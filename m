Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161D5C47082
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 23:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D547661287
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 23:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhEaXaH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 19:30:07 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:57061 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231144AbhEaXaE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 May 2021 19:30:04 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id E9CA71AFB5E;
        Tue,  1 Jun 2021 09:28:21 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lnrKW-007VFf-O4; Tue, 01 Jun 2021 09:28:20 +1000
Date:   Tue, 1 Jun 2021 09:28:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: xfs_itruncate_extents has no extent count
 limitation
Message-ID: <20210531232820.GT664593@dread.disaster.area>
References: <20210527045202.1155628-1-david@fromorbit.com>
 <20210527045202.1155628-4-david@fromorbit.com>
 <87eednukpk.fsf@garuda>
 <87czt7uk7v.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87czt7uk7v.fsf@garuda>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=tTmeyR3uGlGdKY-BafoA:9 a=JkIRIRsmVJBFCwkJ:21 a=ThxTGwE4n0tTI7kx:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 31, 2021 at 06:35:40PM +0530, Chandan Babu R wrote:
> On 31 May 2021 at 18:25, Chandan Babu R wrote:
> > On 27 May 2021 at 10:21, Dave Chinner wrote:
> >> From: Dave Chinner <dchinner@redhat.com>
> >>
> >> Ever since we moved to freeing of extents by deferred operations,
> >> we've already freed extents via individual transactions. Hence the
> >> only limitation of how many extents we can mark for freeing in a
> >> single xfs_bunmapi() call bound only by how many deferrals we want
> >> to queue.
> >>
> >> That is xfs_bunmapi() doesn't actually do any AG based extent
> >> freeing, so there's no actually transaction reservation used up by
> >> calling bunmapi with a large count of extents to be freed. RT
> >> extents have always been freed directly by bunmapi, but that doesn't
> >> require modification of large number of blocks as there are no
> >> btrees to split.
> >>
> >> Some callers of xfs_bunmapi assume that the extent count being freed
> >> is bound by geometry (e.g. directories) and these can ask bunmapi to
> >> free up to 64 extents in a single call. These functions just work as
> >> tehy stand, so there's no reason for truncate to have a limit of
> >> just two extents per bunmapi call anymore.
> >>
> >> Increase XFS_ITRUNC_MAX_EXTENTS to 64 to match the number of extents
> >> that can be deferred in a single loop to match what the directory
> >> code already uses.
> >>
> >> For realtime inodes, where xfs_bunmapi() directly frees extents,
> >> leave the limit at 2 extents per loop as this is all the space that
> >> the transaction reservation will cover.
> >>
> >> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> >> ---
> >>  fs/xfs/xfs_inode.c | 15 ++++++++++++---
> >>  1 file changed, 12 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> >> index 0369eb22c1bb..db220eaa34b8 100644
> >> --- a/fs/xfs/xfs_inode.c
> >> +++ b/fs/xfs/xfs_inode.c
> >> @@ -40,9 +40,18 @@ kmem_zone_t *xfs_inode_zone;
> >>
> >>  /*
> >>   * Used in xfs_itruncate_extents().  This is the maximum number of extents
> >> - * freed from a file in a single transaction.
> >> + * we will unmap and defer for freeing in a single call to xfs_bunmapi().
> >> + * Realtime inodes directly free extents in xfs_bunmapi(), so are bound
> >> + * by transaction reservation size to 2 extents.
> >>   */
> >> -#define	XFS_ITRUNC_MAX_EXTENTS	2
> >> +static inline int
> >> +xfs_itrunc_max_extents(
> >> +	struct xfs_inode	*ip)
> >> +{
> >> +	if (XFS_IS_REALTIME_INODE(ip))
> >> +		return 2;
> >> +	return 64;
> >> +}
> >>
> >>  STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
> >>  STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
> >> @@ -1402,7 +1411,7 @@ xfs_itruncate_extents_flags(
> >>  	while (unmap_len > 0) {
> >>  		ASSERT(tp->t_firstblock == NULLFSBLOCK);
> >>  		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
> >> -				flags, XFS_ITRUNC_MAX_EXTENTS);
> >> +				flags, xfs_itrunc_max_extents(ip));
> >>  		if (error)
> >>  			goto out;
> >
> > The list of free extent items at xfs_defer_pending->dfp_work could
> > now contain XFS_EFI_MAX_FAST_EXTENTS (i.e. 16) entries in the worst case.

Yes, but we do exactly this when freeing a large fragmented directly
block. That is, we ask xfs_bunmapi to unmap a 64kB range regardless
of how many extents map that range.

IOWs, the limitation in extent count placed in
xfs_itruncate_extents() doesn't actually address the underlying
problem - it's just a band-aid that has been placed over the easy to
trigger transaction overrun symptom that has always been present in
the underlying extent freeing code.

> > For a single transaction, xfs_calc_itruncate_reservation() reserves space for
> > logging only 4 extents (i.e. 4 exts * 2 trees * (2 * max depth - 1) * block
> > size).
> 
> ... Sorry, I meant to say "xfs_calc_itruncate_reservation() reserves log space
> required for freeing 4 extents ..."

My point exactly - the code has always had a mismatch between
reservations and what we can stuff into an EFI.  EFIs are unbound in
size, so having a fixed "4 extents per EFI" reservation limit has
never made any real sense given that unmaping a 64kB directory block
on a 1kb block size filesystem has a worst case of freeing 64
extents in a single transaction. As I said above, the limitations
placed on xfs_itruncate_extents is largely a hack because it doesn't
address other avenues to the same overruns...

This "4 extents per transaction" reservation makes even less sense
now that extents are freed by defer ops, not by the transaction that
unmaps them. We've completely decoupled extent freeing from the
higher level code that unmaps them, and so now the freeing
transactions are independent of the high level code that runs the
freeing operations.

IOWs, having a reservation big enough to free a single extent is all
we should need now as we can break the extent freeing up into
individual transactions and still have them complete atomically even
after a crash. That's where I'm trying to get to here, but it's
clear that I need to refine the code a bit further such that we only
allow individual EFIs to queue up and free multiple extents within
an AG to be freed in the same transaction....

FWIW, I suspect that the right thing to do here is make use of the
xfs_defer_finish_one() mechanism for relogging the remaining intents
in work list while it is processing that list. All we need is for
xfs_extent_free_finish_item() to return -EAGAIN instead of running
the free transaction, and we will log the completed EFDs and the
remaining EFIs to be run and roll the transaction.

Hence we can control exactly when we roll the extent freeing
transaction (e.g. when the next extent to free is in a different AG
to the one we've just been freeing extents in) and as a result we
can define a fixed transaction reservation for extent freeing that
works in every situation without having to care about arbitrary
"how many extents can we unmap without overrun" concerns.

That's the goal here - fixed, small reservation for extent freeing
that is decoupled from and independent of the number of extents that
need to be freed atomically by the high level operation...

Hence I think that a minor amount of rework will allow the EFI code
to log large numbers of extents to be freed whilst still processing
them within single AG free space tree modification reservation
bounds...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
