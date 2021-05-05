Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15570C43461
	for <linux-xfs@archiver.kernel.org>; Wed,  5 May 2021 12:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1084613BC
	for <linux-xfs@archiver.kernel.org>; Wed,  5 May 2021 12:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhEEMnp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 May 2021 08:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbhEEMnn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 May 2021 08:43:43 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAB5C061574
        for <linux-xfs@vger.kernel.org>; Wed,  5 May 2021 05:42:46 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id p4so1927243pfo.3
        for <linux-xfs@vger.kernel.org>; Wed, 05 May 2021 05:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=KcpgyP/pWqdHp4suujr0ZZf6LeX8d5FO9Jj2T/DX0bI=;
        b=IuW0jhCEP8yrXPL2DpU1XOJKUcJ+b/VfN5L2Ix/2gsC3cKvlD2mSn2p0BPUPuEx7yW
         eotgQgUdgEuLGN/qb3v7WROXQXQNjU129TFOKG+7UWG7OQRWoWfMDdbUS3nW/sRiwRIC
         xu6U4CwyfWG3KQgG/TXkLTeYA/tks/CoyuZL3fz6ttSPh+1pyBss+H1T0YH6E0Hae+Me
         27mM3OczWWOxi4mROf/cYlPpFj6tRw99fwScrytFKZuARocdq5rew7gsGF/on3+dSV7y
         ijyn78qdGs5nMnR05/zgixDGxvuXgTu3/BmarsanSMlBQYDlsT2e6xtlaAXJEeDHYLAe
         x9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=KcpgyP/pWqdHp4suujr0ZZf6LeX8d5FO9Jj2T/DX0bI=;
        b=DshXopRpbWMKogO5uuoSvAdGMthU4SRZ9aodo1oKIO8Epti5EeWvtbbET3Tsjky/BA
         P+Kqz76fiTT+tb0OqELLrWBqGHmf78EeqoK21gx6r+xUfvV4k/7XGRMkGHgcadlRQyqQ
         3Cwkjt83diq/tcrOcDksQ5b+/1nHrjVq8fLNLdo39t+kG86OXYVxfmfV3nzaNWHOhGT5
         1VWRKtNJw+of7glRelHe3fYSo4Ur8yJ8B5dOxrOX9WTEnK6XV/uigQRMhaj4zVi3QrbU
         DcNeJ3gajjrk6rgzCuf5vYDWGqUfrc2l5V0TA6a1tPvLzrA2MEkjDWZxeu4DWLsnrOCT
         FfEQ==
X-Gm-Message-State: AOAM5339M2llyu9jJBdLsiuoOQ4S738vK3XAlI8PAAoZsCitjWjO0y6s
        nV+8tnUmNSXNCSxc5kR1gJ6fig/8fZg=
X-Google-Smtp-Source: ABdhPJzFlpvDg/nXLFA45SqW5/2DYUmiX/VW4zyKIbR/5Z6b1wcm/I+IZumRVVVtWZT45Za3W60lig==
X-Received: by 2002:a62:16d2:0:b029:27f:3dbf:a466 with SMTP id 201-20020a6216d20000b029027f3dbfa466mr28207251pfw.11.1620218565399;
        Wed, 05 May 2021 05:42:45 -0700 (PDT)
Received: from garuda ([122.179.106.184])
        by smtp.gmail.com with ESMTPSA id t11sm16612824pji.54.2021.05.05.05.42.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 May 2021 05:42:44 -0700 (PDT)
References: <20210428065152.77280-1-chandanrlinux@gmail.com> <20210428065152.77280-2-chandanrlinux@gmail.com> <20210429011231.GF63242@dread.disaster.area> <875z0399gw.fsf@garuda> <20210430224415.GG63242@dread.disaster.area> <87y2cwnnzp.fsf@garuda> <20210504000306.GJ63242@dread.disaster.area>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for AGFL
In-reply-to: <20210504000306.GJ63242@dread.disaster.area>
Date:   Wed, 05 May 2021 18:12:41 +0530
Message-ID: <874kfh5p32.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04 May 2021 at 05:33, Dave Chinner wrote:
> On Mon, May 03, 2021 at 03:22:10PM +0530, Chandan Babu R wrote:
>> On 01 May 2021 at 04:14, Dave Chinner wrote:
>> >> that end, I have tried to slightly simplify the patch that I had originally
>> >> sent (i.e. [PATCH 2/2] xfs: Prevent deadlock when allocating blocks for
>> >> AGFL). The new patch removes one the boolean variables
>> >> (i.e. alloc_small_extent) and also skips redundant searching of extent records
>> >> when backtracking in preparation for searching smaller extents.
>> >
>> > I still don't think this is right approach because it tries to
>> > correct a bad decision (use a busy extent instead of trying the next
>> > free extent) with another bad decision (log force might not unbusy
>> > the extent we are trying to allocate). We should not do either of
>> > these things in this situation, nor do we need to mark busy extents
>> > as being in a transaction to avoid deadlocks.
>> >
>> > That is, if all free extents are busy and there is nothing we can
>> > allocate in the AG for the AGFL, then flush the busy extents and try
>> > again while we hold the AGF locked. Because we hold the AGF locked,
>> > nobody else can create new busy extents in the AG while we wait.
>> > That means after a busy extent flush any remaining busy extents in
>> > this AG are ones that we hold busy in this transaction and are the
>> > ones we need to avoid allocating from in the first place.
>> >
>> > IOWs, we don't need to mark busy extents as being in a transaction
>> > at all - we know that this is the only way we can have a busy extent
>> > in the AG after we flush busy extents while holding the AGF locked.
>> > And that means if we still can't find a free extent after a busy
>> > extent flush, then we're definitely at ENOSPC in that AG as there
>> > are no free extents we can safely allocate from in the AG....
>>
>> ... Assume that there is one free busy extent in an AG and that it is 1 block
>> in length. Also assume that the free extent is busy in the current
>> transaction.
>
> ISTR that this won't happen during extent allocation because the
> transaction reservation and the AG selection code is supposed to
> ensure there are sufficient free blocks both globally and in the AG
> for the entire operation, not just one part of it.
>
> Also, the extent freeing path is this:
>
> ...
>   __xfs_free_extent()
>     xfs_free_extent_fix_freelist()
>       xfs_alloc_fix_freelist(XFS_ALLOC_FLAG_FREEING)
>
> And that XFS_ALLOC_FLAG_FREEING is special - it means that we:
>
> a) always say there is space available in the AG for the freeing
> operation to take place, and
> b) only perform best effort allocation to fill up the free list.
>
> Case b) triggers this code:
>
>                 /*
>                  * Stop if we run out.  Won't happen if callers are obeying
>                  * the restrictions correctly.  Can happen for free calls
>                  * on a completely full ag.
>                  */
>                 if (targs.agbno == NULLAGBLOCK) {
>                         if (flags & XFS_ALLOC_FLAG_FREEING)
>                                 break;
>                         goto out_agflbp_relse;
>                 }
>
>
> That is, if we fail to fix up the free list, we still go ahead with
> the operation because freeing extents when we are at ENOSPC means
> that, by definition, we don't need to allocate blocks to track the
> new free space because the new free space records will fit inside
> the root btree blocks that are already allocated.
>
> Hence when doing allocation for the free list, we need to fail the
> allocation rather than block on the only remaining free extent in
> the AG. If we are freeing extents, the AGFL not being full is not an
> issue at all. And if we are allocating extents, the transaction
> reservations should have ensured that the AG had sufficient space in
> it to complete the entire operation without deadlocking waiting for
> space.
>
> Either way, I don't see a problem with making sure the AGFL
> allocations just skip busy extents and fail if the only free extents
> are ones this transaction has freed itself.
>

Hmm. In the scenario where *all* free extents in the AG were originally freed
by the current transaction (and hence busy in the transaction), we would need
to be able to recognize this situation and skip invoking
xfs_extent_busy_flush() altogether. Otherwise, xfs_extent_busy_flush() invokes
xfs_log_force() and keeps waiting for busy generation number to change.

Hence, IMHO we would need an extent busy flag (e.g. XFS_EXTENT_BUSY_IN_TRANS)
to correctly determine if all the busy extents are indeed busy in the current
transaction.

--
chandan
