Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 491B6C7EE25
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 01:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbjEQByh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 21:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbjEQByg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 21:54:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C4B3A90
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 18:54:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC23C633CB
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 01:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455AAC4339B;
        Wed, 17 May 2023 01:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684288474;
        bh=oIgUHZLfWSAWWMOxOteduxUsm5JzIbU8Fx9sqqiYhiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pHCyeReoQAhap6qUoctVjq3KBaw8jHp/ImfMNALvWtmnoAJQAYfVkhWV12YyvjNSF
         F7mVUu1q1Yw4g/aD8Dk1aCfnE8avl3Lf9cjJDIbW8j/YNPUWOljH5LLO31Ukh0E1DX
         cpCODNmTL/3VKcukzSUc+QCGnODg8tLTTBpiiCojf4SfmXZUkk/EYliv91N98bnI+K
         0WU50n5c0OU+cWn659NtjVLnsDQv7Z8X/XWl+ixaY5RMb54NvCaIHNG+ld2+ZnoTgx
         dfQhI3fMeAV86ptskf/vH0oIvLkT05yfjoA5zd3P9SuN9B3RsmtDX67pV2HO6XhYtM
         trJND+K1li86g==
Date:   Tue, 16 May 2023 18:54:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Message-ID: <20230517015433.GQ858815@frogsfrogsfrogs>
References: <20230424225102.23402-1-wen.gang.wang@oracle.com>
 <20230512182455.GJ858799@frogsfrogsfrogs>
 <592C0DE1-F4F5-4C9A-8799-E9E81524CDC0@oracle.com>
 <20230512211326.GK858799@frogsfrogsfrogs>
 <050A91C4-54EC-4EB8-A701-7C9F640B7ADB@oracle.com>
 <11835435-29A1-4F34-9CE5-C9ED84567E98@oracle.com>
 <20230517005913.GM858799@frogsfrogsfrogs>
 <ZGQwdes/DQPXRJgj@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGQwdes/DQPXRJgj@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 17, 2023 at 11:40:05AM +1000, Dave Chinner wrote:
> On Tue, May 16, 2023 at 05:59:13PM -0700, Darrick J. Wong wrote:
> > Since 6.3 we got rid of the _THIS_AG indirection stuff and that becomes:
> > 
> > xfs_alloc_fix_freelist ->
> > xfs_alloc_ag_vextent_size ->
> > (run all the way to the end of the bnobt) ->
> > xfs_extent_busy_flush ->
> > <stall on the busy extent that's in @tp->busy_list>
> > 
> > xfs_extent_busy_flush does this, potentially while we're holding the
> > freed extent in @tp->t_busy_list:
> > 
> > 	error = xfs_log_force(mp, XFS_LOG_SYNC);
> > 	if (error)
> > 		return;
> > 
> > 	do {
> > 		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
> > 		if  (busy_gen != READ_ONCE(pag->pagb_gen))
> > 			break;
> > 		schedule();
> > 	} while (1);
> > 
> > 	finish_wait(&pag->pagb_wait, &wait);
> > 
> > The log force kicks the CIL to process whatever other committed items
> > might be lurking in the log.  *Hopefully* someone else freed an extent
> > in the same AG, so the log force has now caused that *other* extent to
> > get processed so it has now cleared the busy list.  Clearing something
> > from the busy list increments the busy generation (aka pagb_gen).
> 
> *nod*
> 
> > Unfortunately, there aren't any other extents, so the busy_gen does not
> > change, and the loop runs forever.
> > 
> > At this point, Dave writes:
> > 
> > [15:57] <dchinner> so if we enter that function with busy extents on the
> > transaction, and we are doing an extent free operation, we should return
> > after the sync log force and not do the generation number wait
> > 
> > [15:58] <dchinner> if we fail to allocate again after the sync log force
> > and the generation number hasn't changed, then return -EAGAIN because no
> > progress has been made.
> > 
> > [15:59] <dchinner> Then the transaction is rolled, the transaction busy
> > list is cleared, and if the next allocation attempt fails becaues
> > everything is busy, we go to sleep waiting for the generation to change
> > 
> > [16:00] <dchinner> but because the transaction does not hold any busy
> > extents, it cannot deadlock here because it does not pin any extents
> > that are in the busy tree....
> > 
> > [16:05] <dchinner> All the generation number is doing here is telling us
> > whether there was busy extent resolution between the time we last
> > skipped a viable extent because it was busy and when the flush
> > completes.
> > 
> > [16:06] <dchinner> it doesn't mean the next allocation will succeed,
> > just that progress has been made so trying the allocation attempt will
> > at least get a different result to the previous scan.
> > 
> > I think the callsites go from this:
> > 
> > 	if (busy) {
> > 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> > 		trace_xfs_alloc_size_busy(args);
> > 		xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> > 		goto restart;
> > 	}
> 
> I was thinking this code changes to:
> 
> 	flags |= XFS_ALLOC_FLAG_TRY_FLUSH;
> 	....
> 	<attempt allocation>
> 	....
> 	if (busy) {
> 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> 		trace_xfs_alloc_size_busy(args);
> 		error = xfs_extent_busy_flush(args->tp, args->pag,
> 				busy_gen, flags);
> 		if (!error) {
> 			flags &= ~XFS_ALLOC_FLAG_TRY_FLUSH;
> 			goto restart;
> 		}
> 		/* jump to cleanup exit point */
> 		goto out_error;
> 	}
> 
> Note the different first parameter - we pass args->tp, not args->mp
> so that the flush has access to the transaction context...

<nod>

> > to something like this:
> > 
> > 	bool	try_log_flush = true;
> > 	...
> > restart:
> > 	...
> > 
> > 	if (busy) {
> > 		bool	progress;
> > 
> > 		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> > 		trace_xfs_alloc_size_busy(args);
> > 
> > 		/*
> > 		 * If the current transaction has an extent on the busy
> > 		 * list, we're allocating space as part of freeing
> > 		 * space, and all the free space is busy, we can't hang
> > 		 * here forever.  Force the log to try to unbusy free
> > 		 * space that could have been freed by other
> > 		 * transactions, and retry the allocation.  If the
> > 		 * allocation fails a second time because all the free
> > 		 * space is busy and nobody made any progress with
> > 		 * clearing busy extents, return EAGAIN so the caller
> > 		 * can roll this transaction.
> > 		 */
> > 		if ((flags & XFS_ALLOC_FLAG_FREEING) &&
> > 		    !list_empty(&tp->t_busy_list)) {
> > 			int log_flushed;
> > 
> > 			if (try_log_flush) {
> > 				_xfs_log_force(mp, XFS_LOG_SYNC, &log_flushed);
> > 				try_log_flush = false;
> > 				goto restart;
> > 			}
> > 
> > 			if (busy_gen == READ_ONCE(pag->pagb_gen))
> > 				return -EAGAIN;
> > 
> > 			/* XXX should we set try_log_flush = true? */
> > 			goto restart;
> > 		}
> > 
> > 		xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> > 		goto restart;
> > 	}
> > 
> > IOWs, I think Dave wants us to keep the changes in the allocator instead
> > of spreading it around.
> 
> Sort of - I want the busy extent flush code to be isolated inside
> xfs_extent_busy_flush(), not spread around the allocator. :)
> 
> xfs_extent_busy_flush(
> 	struct xfs_trans	*tp,
> 	struct xfs_perag	*pag,
> 	unsigned int		busy_gen,
> 	unsigned int		flags)
> {
> 	error = xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
> 	if (error)
> 		return error;
> 
> 	/*
> 	 * If we are holding busy extents, the caller may not want
> 	 * to block straight away. If we are being told just to try
> 	 * a flush or progress has been made since we last skipped a busy
> 	 * extent, return immediately to allow the caller to try
> 	 * again. If we are freeing extents, we might actually be
> 	 * holding the onyly free extents in the transaction busy

                       only

> 	 * list and the log force won't resolve that situation. In
> 	 * this case, return -EAGAIN in that case to tell the caller
> 	 * it needs to commit the busy extents it holds before
> 	 * retrying the extent free operation.
> 	 */
> 	if (!list_empty(&tp->t_busy_list)) {
> 		if (flags & XFS_ALLOC_FLAG_TRY_FLUSH)
> 			return 0;
> 		if (busy_gen != READ_ONCE(pag->pagb_gen))
> 			return 0;
> 		if (flags & XFS_ALLOC_FLAG_FREEING)
> 			return -EAGAIN;
> 	}

Indeed, that's a lot cleaner.

> 
> 	/* wait for progressing resolving busy extents */
> 	do {
> 		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
> 		if  (busy_gen != READ_ONCE(pag->pagb_gen))
> 			break;
> 		schedule();
> 	} while (1);
> 
> 	finish_wait(&pag->pagb_wait, &wait);
> 	return 0;
> }
> 
> It seems cleaner to me to put this all in xfs_extent_busy_flush()
> rather than having open-coded handling of extent free constraints in
> each potential flush location. We already have retry semantics
> around the flush, let's just extend them slightly....

<nod> Wengang, how does this sound?

--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
