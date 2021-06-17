Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B328AC2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 04:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98834613CB
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 04:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhFQEvG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 00:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhFQEvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 00:51:06 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B069C061574
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 21:48:53 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e20so3959741pgg.0
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 21:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=zwfVW/ex+0Y2v+3tB9JlX30chwSCYylMaMnNpaqIICU=;
        b=aKyTCRkACUY2yPWF9wOn7fXzHQeqess0bF6zh5C7RgizwUBEO+dzcxFf1OqNDGd+5u
         yK0iAhoEajeelzSOKS0rljEdL/pkMoZCuhekNA3DZ1uqcfgFkGnFUvJaCR26riRZe9MJ
         J7F3EZWb21bl64caM8M3EfVOkudt9WxAxhrBVDugPTB3dpsK1aVektyLmQc4xozCFI5J
         zZrul8C4Apa2KXrCw8OB8Ej3W34z/5+T+yAqVh2ZaeK7RI0UKWUYXGSuB0bk8RFXGdIe
         dp7uuvhwX4GLn+GtoRKISALOFzGhJGYD2982t4MNDmm3lYTvjVDA7TIg1dyTXdlwQiMV
         HLJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=zwfVW/ex+0Y2v+3tB9JlX30chwSCYylMaMnNpaqIICU=;
        b=hBvXyEx+VgP1htk/Ch3Lzrkn5y7VszeAvrGHT/JmFH+ltfJCPnR2DbJ7PmFaGMw0RM
         otkx69zuFV9h6Hv5yKAdl/guJTSIOPg/vpLREMI67xMq1bnBek4R/d/rAcmNdGDtbQIi
         gu5dww5qt3FnG7VWN02mkgGs3HP6+tzM85u2ybXv+zhdmLAhEPt5rOIfnJDcpIN+FVkS
         Nxj/mkkjHUvSZGryAqd1HpNx53MwlNinqx3LjD8Z3iiOdzzcpOiNn+0Z6UIfeOaZntNj
         yGoWuZzBMVqJu4rmpz5xYhxOEd9AeZuiEIZyQnsyew2GGIPlDr1UvVCBIHkBI9Gig0wv
         pc5g==
X-Gm-Message-State: AOAM531kfB5JzC67W5NEBMbMF9or8U+kYmKhm5EXoEzhMeXO2hrBMTKV
        4S02IBE5tjKpGvXjzlJ7GDKgOal52mLOcg==
X-Google-Smtp-Source: ABdhPJz6S0wg8WpvKirnX/mXID5jk6vKU01DbyWYV4BZZkN4Nclay40VE44EgKsNpZ6u6Z4EcowWfg==
X-Received: by 2002:a63:344d:: with SMTP id b74mr3160821pga.266.1623905332355;
        Wed, 16 Jun 2021 21:48:52 -0700 (PDT)
Received: from garuda ([122.167.159.50])
        by smtp.gmail.com with ESMTPSA id v6sm3671483pfi.46.2021.06.16.21.48.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jun 2021 21:48:51 -0700 (PDT)
References: <20210428065152.77280-1-chandanrlinux@gmail.com> <20210428065152.77280-2-chandanrlinux@gmail.com> <20210429011231.GF63242@dread.disaster.area> <875z0399gw.fsf@garuda> <20210430224415.GG63242@dread.disaster.area> <87y2cwnnzp.fsf@garuda> <20210504000306.GJ63242@dread.disaster.area> <874kfh5p32.fsf@garuda> <20210506032751.GN63242@dread.disaster.area> <87cztxwkvy.fsf@garuda>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for AGFL
In-reply-to: <87cztxwkvy.fsf@garuda>
Date:   Thu, 17 Jun 2021 10:18:48 +0530
Message-ID: <875yydqeof.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 May 2021 at 17:19, Chandan Babu R wrote:
> On 06 May 2021 at 08:57, Dave Chinner wrote:
>> On Wed, May 05, 2021 at 06:12:41PM +0530, Chandan Babu R wrote:
>>> > Hence when doing allocation for the free list, we need to fail the
>>> > allocation rather than block on the only remaining free extent in
>>> > the AG. If we are freeing extents, the AGFL not being full is not an
>>> > issue at all. And if we are allocating extents, the transaction
>>> > reservations should have ensured that the AG had sufficient space in
>>> > it to complete the entire operation without deadlocking waiting for
>>> > space.
>>> >
>>> > Either way, I don't see a problem with making sure the AGFL
>>> > allocations just skip busy extents and fail if the only free extents
>>> > are ones this transaction has freed itself.
>>> >
>>>
>>> Hmm. In the scenario where *all* free extents in the AG were originally freed
>>> by the current transaction (and hence busy in the transaction),
>>
>> How does that happen?
>
> I tried in vain to arrive at the above mentioned scenario by consuming away as
> many blocks as possible from the filesystem. At best, I could arrive at an AG
> with just one free extent record in the cntbt (NOTE: I had to disable global
> reservation by invoking "xfs_io -x -c 'resblks 0' $mntpnt"):
>
> recs[1] = [startblock,blockcount]
> 1:[32767,1]
>
> For each AG available in an FS instance, we take away 8
> (i.e. XFS_ALLOC_AGFL_RESERVE + 4) blocks from the global free data blocks
> counter. This reservation is applied to the FS as a whole rather than each AG
> individually. Hence we could get to a scenario where an AG could have less
> than 8 free blocks. I could not find any other restriction in the code that
> explicitly prevents an AG from having zero free extents.
>
> However, I could not create such an AG because any fs operation that needs
> extent allocation to be done would try to reserve more than 1 extent causing
> the above cited AG to not be chosen.
>
>>
>>> we would need
>>> to be able to recognize this situation and skip invoking
>>> xfs_extent_busy_flush() altogether.
>>
>> If we are freeing extents (i.e XFS_ALLOC_FLAG_FREEING is set) and
>> we are doing allocation for AGFL and we only found busy extents,
>> then it's OK to fail the allocation.
>
> When freeing an extent, the following patch skips allocation of blocks to AGFL
> if all the free extents found are busy,
>
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index aaa19101bb2a..5310e311d5c6 100644
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
> @@ -1710,6 +1711,9 @@ xfs_alloc_ag_vextent_size(
>  		/*
>  		 * Search for a non-busy extent that is large enough.
>  		 */
> +		xfs_agblock_t	orig_fbno = NULLAGBLOCK;
> +		xfs_extlen_t	orig_flen;
> +
>  		for (;;) {
>  			error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, &i);
>  			if (error)
> @@ -1719,6 +1723,11 @@ xfs_alloc_ag_vextent_size(
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
> @@ -1729,6 +1738,13 @@ xfs_alloc_ag_vextent_size(
>  			if (error)
>  				goto error0;
>  			if (i == 0) {
> +				if (args->freeing_extent) {
> +					error = xfs_alloc_lookup_eq(cnt_cur,
> +							orig_fbno, orig_flen, &i);
> +					ASSERT(!error && i);
> +					goto alloc_small_extent;
> +				}
> +
>  				/*
>  				 * Our only valid extents must have been busy.
>  				 * Make it unbusy by forcing the log out and
> @@ -1819,7 +1835,7 @@ xfs_alloc_ag_vextent_size(
>  	 */
>  	args->len = rlen;
>  	if (rlen < args->minlen) {
> -		if (busy) {
> +		if (busy && !args->freeing_extent) {
>  			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>  			trace_xfs_alloc_size_busy(args);
>  			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> @@ -2641,6 +2657,7 @@ xfs_alloc_fix_freelist(
>  	targs.alignment = targs.minlen = targs.prod = 1;
>  	targs.type = XFS_ALLOCTYPE_THIS_AG;
>  	targs.pag = pag;
> +	targs.freeing_extent = flags & XFS_ALLOC_FLAG_FREEING;
>  	error = xfs_alloc_read_agfl(mp, tp, targs.agno, &agflbp);
>  	if (error)
>  		goto out_agbp_relse;
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index a4427c5775c2..1e0fc28ef87a 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -78,6 +78,7 @@ typedef struct xfs_alloc_arg {
>  #ifdef DEBUG
>  	bool		alloc_minlen_only; /* allocate exact minlen extent */
>  #endif
> +	bool		freeing_extent;
>  } xfs_alloc_arg_t;
>
>  /*
>
> With the above patch, xfs/538 cause the following call trace to be printed,
>
>    XFS (vdc2): Internal error i != 1 at line 3426 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_insert+0x15c/0x1f0
>    CPU: 2 PID: 1284 Comm: punch-alternati Not tainted 5.12.0-rc8-next-20210419-chandan #19
>    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
>    Call Trace:
>     dump_stack+0x64/0x7c
>     xfs_corruption_error+0x85/0x90
>     ? xfs_btree_insert+0x15c/0x1f0
>     xfs_btree_insert+0x18d/0x1f0
>     ? xfs_btree_insert+0x15c/0x1f0
>     ? xfs_allocbt_init_common+0x30/0xf0
>     xfs_free_ag_extent+0x463/0x9d0
>     __xfs_free_extent+0xe5/0x200
>     xfs_trans_free_extent+0x3e/0x100
>     xfs_extent_free_finish_item+0x24/0x40
>     xfs_defer_finish_noroll+0x1f7/0x5c0
>     __xfs_trans_commit+0x12f/0x300
>     xfs_free_file_space+0x1af/0x2c0
>     xfs_file_fallocate+0x1ca/0x430
>     ? __cond_resched+0x16/0x40
>     ? inode_security+0x22/0x60
>     ? selinux_file_permission+0xe2/0x120
>     vfs_fallocate+0x146/0x2e0
>     __x64_sys_fallocate+0x3e/0x70
>     do_syscall_64+0x40/0x80
>     entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> The above call trace occurs during execution of the step #2 listed below,
> 1. Filling up 90% of the free space of the filesystem.
> 2. Punch alternate blocks of files.
>
> Just before the failure, the filesystem had ~9000 busy extents. So I think we
> have to flush busy extents even when refilling AGFL for the purpose of freeing
> an extent.
>
>>
>> We have options here - once we get to the end of the btree and
>> haven't found a candidate that isn't busy, we could fail
>> immediately. Or maybe we try an optimisitic flush which forces the
>> log and waits for as short while (instead of forever) for the
>> generation to change and then fail if we get a timeout response. Or
>> maybe there's a more elegant way of doing this that hasn't yet
>> rattled out of my poor, overloaded brain right now.
>>
>> Just because we currently do a blocking flush doesn't mean we always
>> must do a blocking flush....
>
> I will try to work out a solution.

I believe the following should be taken into consideration to design an
"optimistic flush delay" based solution,
1. Time consumed to perform a discard operation on a filesystem's block.
2. The size of extents that are being discarded.
3. Number of discard operation requests contained in a bio.

AFAICT, The combinations resulting from the above make it impossible to
calculate a time delay during which sufficient number of busy extents are
guaranteed to have been freed so as to fill up the AGFL to the required
levels. In other words, sufficent number of busy extents may not have been
discarded even after the optimistic delay interval elapses.

The other solution that I had thought about was to introduce a new flag for
the second argument of xfs_log_force(). The new flag will cause
xlog_state_do_iclog_callbacks() to wait on completion of all of the CIL ctxs
associated with the iclog that xfs_log_force() would be waiting on. Hence, a
call to xfs_log_force(mp, NEW_SYNC_FLAG) will return only after all the busy
extents associated with the iclog are discarded.

However, this method is also flawed as described below.

----------------------------------------------------------
 Task A                        Task B
----------------------------------------------------------
 Submit a filled up iclog
 for write operation
 (Assume that the iclog
 has non-zero number of CIL
 ctxs associated with it).
 On completion of iclog write
 operation, discard requests
 for busy extents are issued.

 Write log records (including
 commit record) into another
 iclog.

                               A task which is trying
                               to fill AGFL will now
                               invoke xfs_log_force()
                               with the new sync
                               flag.
                               Submit the 2nd iclog which
                               was partially filled by
                               Task A.
                               If there are no
                               discard requests
                               associated this iclog,
                               xfs_log_force() will
                               return. As the discard
                               requests associated with
                               the first iclog are yet
                               to be completed,
                               we end up incorrectly
                               concluding that
                               all busy extents
                               have been processed.
----------------------------------------------------------

The inconsistency indicated above could also occur when discard requests
issued against second iclog get processed before discard requests associated
with the first iclog.

XFS_EXTENT_BUSY_IN_TRANS flag based solution is the only method that I can
think of that can solve this problem correctly. However I do agree with your
earlier observation that we should not flush busy extents unless we have
checked for presence of free extents in the btree records present on the left
side of the btree cursor.

--
chandan
