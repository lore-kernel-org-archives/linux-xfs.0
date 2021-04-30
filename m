Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673A2C433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 22:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2960861288
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 22:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhD3WpK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Apr 2021 18:45:10 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:34176 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230508AbhD3WpJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Apr 2021 18:45:09 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 33311108EDF;
        Sat,  1 May 2021 08:44:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lcbrr-00FPuq-Oq; Sat, 01 May 2021 08:44:15 +1000
Date:   Sat, 1 May 2021 08:44:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for AGFL
Message-ID: <20210430224415.GG63242@dread.disaster.area>
References: <20210428065152.77280-1-chandanrlinux@gmail.com>
 <20210428065152.77280-2-chandanrlinux@gmail.com>
 <20210429011231.GF63242@dread.disaster.area>
 <875z0399gw.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875z0399gw.fsf@garuda>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=eQympWtXb6BsWOhuNBMA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 30, 2021 at 07:10:31PM +0530, Chandan Babu R wrote:
> On 29 Apr 2021 at 06:42, Dave Chinner wrote:
> > On Wed, Apr 28, 2021 at 12:21:52PM +0530, Chandan Babu R wrote:
> >> Executing xfs/538 after disabling injection of bmap_alloc_minlen_extent error
> >> can cause several tasks to trigger hung task timeout. Most of the tasks are
> >> blocked on getting a lock on an AG's AGF buffer. However, The task which has
> >> the lock on the AG's AGF buffer has the following call trace,
> >>
> [..]
> > Hmmm. I don't doubt that this fixes the symptom you are seeing, but
> > the way it is being fixed doesn't seem right to me at all.
> >
> > We're rtying to populate the AGFL here, and the fact is that a
> > multi-block allocation is simply an optimisation to minimise the
> > number of extents we need to allocate to fill the AGFL. The extent
> > that gets allocated gets broken up into single blocks to be inserted
> > into the AGFL, so we don't actually need a continuguous extent to be
> > allocated here.
> >
> > Hence, if the extent we find is busy when allocating for the AGFL,
> > we should just skip it and choose another extent. args->minlen is
> > set to zero for the allocation, so we can actually return any extent
> > that has a length <= args->maxlen. We know this is an AGFL
> > allocation because args->resv == XFS_AG_RESV_AGFL, so if we find a
> > busy extent that would require a log force to be able to use before
> > we can place it in the AGFL, we should just skip it entirely and
> > select another extent to allocate from.
> >
> > Adding another two boolean conditionals to the already complex
> > extent selection for this specific case makes the code much harder
> > to follow and reason about. I'd much prefer that we just do
> > something like:
> >
> > 	if (busy && args->resv == XFS_AG_RESV_AGFL) {
> > 		/*
> > 		 * Extent might have just been freed in this
> > 		 * transaction so we can't use it. Move to the next
> > 		 * best extent candidate and try that instead.
> > 		 */
> > 		<increment/decrement and continue the search loop>
> > 	}
> >
> > IOWs, we should not be issuing a log force to flush busy extents if
> > we can't use the largest candidate free extent for the AGFL - we
> > should just keep searching until we find one we can use....
> 
> IIUC, the following patch implements the solution that has been suggested
> above,
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index aaa19101bb2a..25456dbff767 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1694,6 +1694,7 @@ xfs_alloc_ag_vextent_size(
>  	 * are no smaller extents available.
>  	 */
>  	if (!i) {
> +alloc_small_extent:
>  		error = xfs_alloc_ag_vextent_small(args, cnt_cur,
>  						   &fbno, &flen, &i);
>  		if (error)
> @@ -1707,6 +1708,8 @@ xfs_alloc_ag_vextent_size(
>  		busy = xfs_alloc_compute_aligned(args, fbno, flen, &rbno,
>  				&rlen, &busy_gen);
>  	} else {
> +		xfs_agblock_t	orig_fbno = NULLAGBLOCK;
> +		xfs_extlen_t	orig_flen;
>  		/*
>  		 * Search for a non-busy extent that is large enough.
>  		 */
> @@ -1719,6 +1722,11 @@ xfs_alloc_ag_vextent_size(
>  				goto error0;
>  			}
> 
> +			if (orig_fbno == NULLAGBLOCK) {
> +				orig_fbno = fbno;
> +				orig_flen = flen;
> +			}
> +
>  			busy = xfs_alloc_compute_aligned(args, fbno, flen,
>  					&rbno, &rlen, &busy_gen);
> 
> @@ -1734,6 +1742,14 @@ xfs_alloc_ag_vextent_size(
>  				 * Make it unbusy by forcing the log out and
>  				 * retrying.
>  				 */
> +				if (args->resv == XFS_AG_RESV_AGFL) {
> +					error = xfs_alloc_lookup_eq(cnt_cur,
> +							orig_fbno, orig_flen, &i);
> +					ASSERT(!error && i);
> +
> +					goto alloc_small_extent;
> +				}
> +
>  				xfs_btree_del_cursor(cnt_cur,
>  						     XFS_BTREE_NOERROR);
>  				trace_xfs_alloc_size_busy(args);
> @@ -1819,7 +1835,7 @@ xfs_alloc_ag_vextent_size(
>  	 */
>  	args->len = rlen;
>  	if (rlen < args->minlen) {
> -		if (busy) {
> +		if (busy && args->resv != XFS_AG_RESV_AGFL) {
>  			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>  			trace_xfs_alloc_size_busy(args);
>  			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> 
> i.e.  when we end up at the right most edge of the cntbt during allocation of
> blocks for refilling AGFL, the above patch backtracks and continues search
> towards the left edge of the cntbt instead of flushing the CIL. If the
> leftmost edge is reached without finding any suitable free extent and the
> blocks are being allocated for AGFL, the function returns back to the caller
> instead of flushing the CIL and retrying once again.

At which point, we know that all the free extents in that AG are
either busy or we are truly out of space. Hence if this search
fails, it makes sense to call xfs_extent_busy_flush() to wait for
all the busy extents in the AG to complete their processing before
trying again.

> With the above patch, a workload which consists of,
> 1. Filling up 90% of the free space of the filesystem.
> 2. Punch alternate blocks of files.
> 
> .. would cause failure when inserting records into either cntbt/bnobt due to
> unavailability of AGFL blocks.
> 
> This happens because most of the free blocks resulting from punching out
> alternate blocks would be residing in the CIL's extent busy list. xfs/538
> creates 1G sized scratch filesystem and the "punch alternate blocks" workload
> creates a little more than 8000 entries in the CIL extent busy list.

Seems like you broke the existing handling of this situation by
preventing the AGFL filling code from flushing the busy extents when
all the AG can find is busy extents.

> So, may be there are no other alternatives other than to flush the CIL. To

Sure, I never suggested that we completely elide log forces. What I
said is that we -shouldn't immediately resort to a log force- because
the first maxlen extent match we come across is busy and can't
immediately be reused.

That is, the code still needs to call xfs_extent_busy_flush() and
try the allocation again, it just needs to do it when no candidate
extent can be found instead of after the first candidate is found to
be busy.

> that end, I have tried to slightly simplify the patch that I had originally
> sent (i.e. [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for
> AGFL). The new patch removes one the boolean variables
> (i.e. alloc_small_extent) and also skips redundant searching of extent records
> when backtracking in preparation for searching smaller extents.

I still don't think this is right approach because it tries to
correct a bad decision (use a busy extent instead of trying the next
free extent) with another bad decision (log force might not unbusy
the extent we are trying to allocate). We should not do either of
these things in this situation, nor do we need to mark busy extents
as being in a transaction to avoid deadlocks.

That is, if all free extents are busy and there is nothing we can
allocate in the AG for the AGFL, then flush the busy extents and try
again while we hold the AGF locked. Because we hold the AGF locked,
nobody else can create new busy extents in the AG while we wait.
That means after a busy extent flush any remaining busy extents in
this AG are ones that we hold busy in this transaction and are the
ones we need to avoid allocating from in the first place.

IOWs, we don't need to mark busy extents as being in a transaction
at all - we know that this is the only way we can have a busy extent
in the AG after we flush busy extents while holding the AGF locked.
And that means if we still can't find a free extent after a busy
extent flush, then we're definitely at ENOSPC in that AG as there
are no free extents we can safely allocate from in the AG....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
