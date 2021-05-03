Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DAE4C433B4
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 09:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD1CD6120D
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 09:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhECJxJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 May 2021 05:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbhECJxI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 May 2021 05:53:08 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D139BC06174A
        for <linux-xfs@vger.kernel.org>; Mon,  3 May 2021 02:52:14 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t2-20020a17090a0242b0290155433387beso9519109pje.1
        for <linux-xfs@vger.kernel.org>; Mon, 03 May 2021 02:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=95PMwuoayd/2hrfF2LkS9lOoN3fUtNWfy74/Hr1CDCg=;
        b=c2XEDC47tNyzL4dlU03BsatnhWVxVBq/nhsmVUNy1N6HQ+aeM0c/MridCFYGZGUjIE
         VGDj/d9JT4CFeAQYC0PONfnBRdLybyjSZkSzcU1FbG4UaOoqa3Susp25Ho4hP8Eno7jT
         kEiU470tHl/KXUeq7iK7DpQXI5+vrE7FUHLluIT4nrckeaOwtXrJhocewjWPj9Wt6xZP
         8KERiPknh0R27pBX1wFRU8aTsj0hLuiGVrdzGRrcIZdSkx3e67TeGSPP6TXJXhWYwA9p
         9yql14Ur5Dz6MHGXUhdGF9dC71SS7b/nSPBa9oBXtp5wx+pLVzRmZs7RwiX0uU3H2OVX
         snZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=95PMwuoayd/2hrfF2LkS9lOoN3fUtNWfy74/Hr1CDCg=;
        b=Hq/0ER4WzO56Q5Pcme6cZ8P3tmilHZLvTfj6djfEshaDFOGfqYVfYgW4OmLJNoptkg
         DIqk/2M+MJc39h0YnuMdTP+J3bUu3+b6ITppSO1YkshDWIlBM6ToqH2njhwPZcMxcXzI
         fRc3krRIQUpnl4jN6pyPrb0MfAc/XwkhFPDSY16OZfl4RFmhatFY0Dy10bODCcTnTHGn
         8zpUyKEG33dm1bjDOiF7FazQBKMt+tq5lfF/zx4wwFxzp2NCaJJoC8LRFX6aKljNQJ1W
         fZRf64cU23Wv7EI/CEd241LD9kjMl3kfIrSBWyw7l8Prs2vAt+wBe3aIzjSDxyFfgaGr
         EMqg==
X-Gm-Message-State: AOAM532TGkCUxrqnPvgAoN5vf97aBvsImkzipAtL3q+g1mcMXQAN6hji
        AHLLMNAQnKKjgk9HS52TNkimTghx1g8=
X-Google-Smtp-Source: ABdhPJy0vUwPKoPHLvnNKmmJwoGxjVY3Fp8VACZjzCfOE7JyWUuTY59nSkALwmg3Dim2fOe/6kLK2Q==
X-Received: by 2002:a17:902:8486:b029:ec:8b6c:f998 with SMTP id c6-20020a1709028486b02900ec8b6cf998mr19265004plo.33.1620035534178;
        Mon, 03 May 2021 02:52:14 -0700 (PDT)
Received: from garuda ([122.179.72.116])
        by smtp.gmail.com with ESMTPSA id md21sm17541527pjb.3.2021.05.03.02.52.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 May 2021 02:52:13 -0700 (PDT)
References: <20210428065152.77280-1-chandanrlinux@gmail.com> <20210428065152.77280-2-chandanrlinux@gmail.com> <20210429011231.GF63242@dread.disaster.area> <875z0399gw.fsf@garuda> <20210430224415.GG63242@dread.disaster.area>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for AGFL
In-reply-to: <20210430224415.GG63242@dread.disaster.area>
Date:   Mon, 03 May 2021 15:22:10 +0530
Message-ID: <87y2cwnnzp.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 01 May 2021 at 04:14, Dave Chinner wrote:
> On Fri, Apr 30, 2021 at 07:10:31PM +0530, Chandan Babu R wrote:
>> On 29 Apr 2021 at 06:42, Dave Chinner wrote:
>> > On Wed, Apr 28, 2021 at 12:21:52PM +0530, Chandan Babu R wrote:
>> >> Executing xfs/538 after disabling injection of bmap_alloc_minlen_extent error
>> >> can cause several tasks to trigger hung task timeout. Most of the tasks are
>> >> blocked on getting a lock on an AG's AGF buffer. However, The task which has
>> >> the lock on the AG's AGF buffer has the following call trace,
>> >>
>> [..]
>> > Hmmm. I don't doubt that this fixes the symptom you are seeing, but
>> > the way it is being fixed doesn't seem right to me at all.
>> >
>> > We're rtying to populate the AGFL here, and the fact is that a
>> > multi-block allocation is simply an optimisation to minimise the
>> > number of extents we need to allocate to fill the AGFL. The extent
>> > that gets allocated gets broken up into single blocks to be inserted
>> > into the AGFL, so we don't actually need a continuguous extent to be
>> > allocated here.
>> >
>> > Hence, if the extent we find is busy when allocating for the AGFL,
>> > we should just skip it and choose another extent. args->minlen is
>> > set to zero for the allocation, so we can actually return any extent
>> > that has a length <= args->maxlen. We know this is an AGFL
>> > allocation because args->resv == XFS_AG_RESV_AGFL, so if we find a
>> > busy extent that would require a log force to be able to use before
>> > we can place it in the AGFL, we should just skip it entirely and
>> > select another extent to allocate from.
>> >
>> > Adding another two boolean conditionals to the already complex
>> > extent selection for this specific case makes the code much harder
>> > to follow and reason about. I'd much prefer that we just do
>> > something like:
>> >
>> > 	if (busy && args->resv == XFS_AG_RESV_AGFL) {
>> > 		/*
>> > 		 * Extent might have just been freed in this
>> > 		 * transaction so we can't use it. Move to the next
>> > 		 * best extent candidate and try that instead.
>> > 		 */
>> > 		<increment/decrement and continue the search loop>
>> > 	}
>> >
>> > IOWs, we should not be issuing a log force to flush busy extents if
>> > we can't use the largest candidate free extent for the AGFL - we
>> > should just keep searching until we find one we can use....
>>
>> IIUC, the following patch implements the solution that has been suggested
>> above,
>>
>> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
>> index aaa19101bb2a..25456dbff767 100644
>> --- a/fs/xfs/libxfs/xfs_alloc.c
>> +++ b/fs/xfs/libxfs/xfs_alloc.c
>> @@ -1694,6 +1694,7 @@ xfs_alloc_ag_vextent_size(
>>  	 * are no smaller extents available.
>>  	 */
>>  	if (!i) {
>> +alloc_small_extent:
>>  		error = xfs_alloc_ag_vextent_small(args, cnt_cur,
>>  						   &fbno, &flen, &i);
>>  		if (error)
>> @@ -1707,6 +1708,8 @@ xfs_alloc_ag_vextent_size(
>>  		busy = xfs_alloc_compute_aligned(args, fbno, flen, &rbno,
>>  				&rlen, &busy_gen);
>>  	} else {
>> +		xfs_agblock_t	orig_fbno = NULLAGBLOCK;
>> +		xfs_extlen_t	orig_flen;
>>  		/*
>>  		 * Search for a non-busy extent that is large enough.
>>  		 */
>> @@ -1719,6 +1722,11 @@ xfs_alloc_ag_vextent_size(
>>  				goto error0;
>>  			}
>>
>> +			if (orig_fbno == NULLAGBLOCK) {
>> +				orig_fbno = fbno;
>> +				orig_flen = flen;
>> +			}
>> +
>>  			busy = xfs_alloc_compute_aligned(args, fbno, flen,
>>  					&rbno, &rlen, &busy_gen);
>>
>> @@ -1734,6 +1742,14 @@ xfs_alloc_ag_vextent_size(
>>  				 * Make it unbusy by forcing the log out and
>>  				 * retrying.
>>  				 */
>> +				if (args->resv == XFS_AG_RESV_AGFL) {
>> +					error = xfs_alloc_lookup_eq(cnt_cur,
>> +							orig_fbno, orig_flen, &i);
>> +					ASSERT(!error && i);
>> +
>> +					goto alloc_small_extent;
>> +				}
>> +
>>  				xfs_btree_del_cursor(cnt_cur,
>>  						     XFS_BTREE_NOERROR);
>>  				trace_xfs_alloc_size_busy(args);
>> @@ -1819,7 +1835,7 @@ xfs_alloc_ag_vextent_size(
>>  	 */
>>  	args->len = rlen;
>>  	if (rlen < args->minlen) {
>> -		if (busy) {
>> +		if (busy && args->resv != XFS_AG_RESV_AGFL) {
>>  			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>>  			trace_xfs_alloc_size_busy(args);
>>  			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
>>
>> i.e.  when we end up at the right most edge of the cntbt during allocation of
>> blocks for refilling AGFL, the above patch backtracks and continues search
>> towards the left edge of the cntbt instead of flushing the CIL. If the
>> leftmost edge is reached without finding any suitable free extent and the
>> blocks are being allocated for AGFL, the function returns back to the caller
>> instead of flushing the CIL and retrying once again.
>
> At which point, we know that all the free extents in that AG are
> either busy or we are truly out of space. Hence if this search
> fails, it makes sense to call xfs_extent_busy_flush() to wait for
> all the busy extents in the AG to complete their processing before
> trying again.
>
>> With the above patch, a workload which consists of,
>> 1. Filling up 90% of the free space of the filesystem.
>> 2. Punch alternate blocks of files.
>>
>> .. would cause failure when inserting records into either cntbt/bnobt due to
>> unavailability of AGFL blocks.
>>
>> This happens because most of the free blocks resulting from punching out
>> alternate blocks would be residing in the CIL's extent busy list. xfs/538
>> creates 1G sized scratch filesystem and the "punch alternate blocks" workload
>> creates a little more than 8000 entries in the CIL extent busy list.
>
> Seems like you broke the existing handling of this situation by
> preventing the AGFL filling code from flushing the busy extents when
> all the AG can find is busy extents.
>
>> So, may be there are no other alternatives other than to flush the CIL. To
>
> Sure, I never suggested that we completely elide log forces. What I
> said is that we -shouldn't immediately resort to a log force- because
> the first maxlen extent match we come across is busy and can't
> immediately be reused.
>
> That is, the code still needs to call xfs_extent_busy_flush() and
> try the allocation again, it just needs to do it when no candidate
> extent can be found instead of after the first candidate is found to
> be busy.

You are right. When allocating blocks to replenish the AGFL, if searching for
free extents whose length is >= xfs_alloc_args->maxlen yields only busy
extents, we should backtrack and search for extents of smaller length since
AGFL does not need individual blocks to be contiguous. However, If the search
among the smaller length extents again yields only busy extents, we should
invoke xfs_extent_busy_flush() to mark the corresponding extents as
unbusy and restarting the search. However, AFAICT there is one nit ...

>
>> that end, I have tried to slightly simplify the patch that I had originally
>> sent (i.e. [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for
>> AGFL). The new patch removes one the boolean variables
>> (i.e. alloc_small_extent) and also skips redundant searching of extent records
>> when backtracking in preparation for searching smaller extents.
>
> I still don't think this is right approach because it tries to
> correct a bad decision (use a busy extent instead of trying the next
> free extent) with another bad decision (log force might not unbusy
> the extent we are trying to allocate). We should not do either of
> these things in this situation, nor do we need to mark busy extents
> as being in a transaction to avoid deadlocks.
>
> That is, if all free extents are busy and there is nothing we can
> allocate in the AG for the AGFL, then flush the busy extents and try
> again while we hold the AGF locked. Because we hold the AGF locked,
> nobody else can create new busy extents in the AG while we wait.
> That means after a busy extent flush any remaining busy extents in
> this AG are ones that we hold busy in this transaction and are the
> ones we need to avoid allocating from in the first place.
>
> IOWs, we don't need to mark busy extents as being in a transaction
> at all - we know that this is the only way we can have a busy extent
> in the AG after we flush busy extents while holding the AGF locked.
> And that means if we still can't find a free extent after a busy
> extent flush, then we're definitely at ENOSPC in that AG as there
> are no free extents we can safely allocate from in the AG....

... Assume that there is one free busy extent in an AG and that it is 1 block
in length. Also assume that the free extent is busy in the current
transaction.

An extent free operation corresponding to the 2nd xfs_extent_free_item will
invoke xfs_alloc_ag_extent_size() with the following results,

1. Search starts at the only free extent and proceeds towards the left most
   edge of the cntbt.

2. Since there is only one free extent and that it is also busy, we now invoke
   xfs_extent_busy_flush().

3. xfs_extent_busy_flush() flushes the CIL and waits for the "busy generation"
   number to change. This event will never occur since the only free extent is
   busy in the current transaction. Hence the task will now wait indefinitely.

PS: I am not 100% sure if the above mentioned scenario (i.e. having only one
extent free in an AG and also it being marked as busy) is actually
possible. After going through the corresponding source code, I could not find
any evidence to the contrary.

--
chandan
