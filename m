Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03ADC47082
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 13:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7120961287
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 13:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhEaNH0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 09:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbhEaNHZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 May 2021 09:07:25 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C56C061760
        for <linux-xfs@vger.kernel.org>; Mon, 31 May 2021 06:05:44 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id l10-20020a17090a150ab0290162974722f2so3176076pja.2
        for <linux-xfs@vger.kernel.org>; Mon, 31 May 2021 06:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=USIF345Vi42VSkdTNMe4LZcbXjwqV6EVYsBVqyabky8=;
        b=mME0uY3fvhj1bhyQ3A9UlSXpFP2KMl6piAEzwX/s40UXBg6qj3h3oATel2Ic7ez2bM
         nw7ZcyKW7zDxHEAcgavrvlv44FPzpRZPdvLjSyoIvMZgwZInrT3QLap0s8VUPiYDdTGz
         Ujbx29auNnmbARbwk6fxQzhl6nUVJoXzS5kZp6tdLNzo+LLsa7QZy/Md9EULR12p1c76
         W4Rm94wOihdoMmVEqVRVnb1Ht6JfeZH0rdD+woMsVBwrPIk0SWoLNQErZCumjzQcyrPH
         1UcLKceA2WnQeKaRBDcg95C/UZSEN5dcd1566ELPBhDPc2REdk17LNuYSNqw3N2XiVRt
         Zm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=USIF345Vi42VSkdTNMe4LZcbXjwqV6EVYsBVqyabky8=;
        b=a9SmAWHHCrdPNBlSaKiVCyr/ruKLt/DuhRlNF2LjBOXrSS+cf41AARLBkfM/PAtSLS
         ku+8YoHPbJegTNrDUOykZZmg1fErRGFmNFOk5YftkCZKMu08fH+JYeZ+jLaT4mkrBgbd
         RZEX8SQG5amRwI3hhQCgoespOCP6UdVUX6v/V70AJ7N2Ok9Ai2UhoPpOM8CJOcahwXuQ
         t7mQHD+66MBHfSE8WNa1FsFzyWw71en619JHJOsXsmG1qNEysAgaiooSBQ5DFxeTuZOu
         xo5Yw9VR214JZcc6wi52r3iv91ch8txyAq9foJBLOTaYa9jaX1KTZZoorIHvNME6PiI3
         ANYw==
X-Gm-Message-State: AOAM530XVK1mPAfwmjkreI78fCYW8ZQUE/LZ4EaCROkCXPyksNYYCuvO
        jplcN2t5qQRUGL7hOBAwW/VcAsrPYqQQeQ==
X-Google-Smtp-Source: ABdhPJx1HEkrIY9XyO2Yc3p9R9heRcD54B9kJLZISN916lxouZ3MqaBcBdmYRoxvx7FfUJLKEmBWjw==
X-Received: by 2002:a17:90a:8d82:: with SMTP id d2mr6233611pjo.106.1622466343501;
        Mon, 31 May 2021 06:05:43 -0700 (PDT)
Received: from garuda ([122.171.220.253])
        by smtp.gmail.com with ESMTPSA id b9sm10847236pfo.107.2021.05.31.06.05.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 31 May 2021 06:05:43 -0700 (PDT)
References: <20210527045202.1155628-1-david@fromorbit.com> <20210527045202.1155628-4-david@fromorbit.com> <87eednukpk.fsf@garuda>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: xfs_itruncate_extents has no extent count limitation
In-reply-to: <87eednukpk.fsf@garuda>
Date:   Mon, 31 May 2021 18:35:40 +0530
Message-ID: <87czt7uk7v.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 31 May 2021 at 18:25, Chandan Babu R wrote:
> On 27 May 2021 at 10:21, Dave Chinner wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> Ever since we moved to freeing of extents by deferred operations,
>> we've already freed extents via individual transactions. Hence the
>> only limitation of how many extents we can mark for freeing in a
>> single xfs_bunmapi() call bound only by how many deferrals we want
>> to queue.
>>
>> That is xfs_bunmapi() doesn't actually do any AG based extent
>> freeing, so there's no actually transaction reservation used up by
>> calling bunmapi with a large count of extents to be freed. RT
>> extents have always been freed directly by bunmapi, but that doesn't
>> require modification of large number of blocks as there are no
>> btrees to split.
>>
>> Some callers of xfs_bunmapi assume that the extent count being freed
>> is bound by geometry (e.g. directories) and these can ask bunmapi to
>> free up to 64 extents in a single call. These functions just work as
>> tehy stand, so there's no reason for truncate to have a limit of
>> just two extents per bunmapi call anymore.
>>
>> Increase XFS_ITRUNC_MAX_EXTENTS to 64 to match the number of extents
>> that can be deferred in a single loop to match what the directory
>> code already uses.
>>
>> For realtime inodes, where xfs_bunmapi() directly frees extents,
>> leave the limit at 2 extents per loop as this is all the space that
>> the transaction reservation will cover.
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> ---
>>  fs/xfs/xfs_inode.c | 15 ++++++++++++---
>>  1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 0369eb22c1bb..db220eaa34b8 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -40,9 +40,18 @@ kmem_zone_t *xfs_inode_zone;
>>
>>  /*
>>   * Used in xfs_itruncate_extents().  This is the maximum number of extents
>> - * freed from a file in a single transaction.
>> + * we will unmap and defer for freeing in a single call to xfs_bunmapi().
>> + * Realtime inodes directly free extents in xfs_bunmapi(), so are bound
>> + * by transaction reservation size to 2 extents.
>>   */
>> -#define	XFS_ITRUNC_MAX_EXTENTS	2
>> +static inline int
>> +xfs_itrunc_max_extents(
>> +	struct xfs_inode	*ip)
>> +{
>> +	if (XFS_IS_REALTIME_INODE(ip))
>> +		return 2;
>> +	return 64;
>> +}
>>
>>  STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
>>  STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
>> @@ -1402,7 +1411,7 @@ xfs_itruncate_extents_flags(
>>  	while (unmap_len > 0) {
>>  		ASSERT(tp->t_firstblock == NULLFSBLOCK);
>>  		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
>> -				flags, XFS_ITRUNC_MAX_EXTENTS);
>> +				flags, xfs_itrunc_max_extents(ip));
>>  		if (error)
>>  			goto out;
>
> The list of free extent items at xfs_defer_pending->dfp_work could
> now contain XFS_EFI_MAX_FAST_EXTENTS (i.e. 16) entries in the worst case.
>
> For a single transaction, xfs_calc_itruncate_reservation() reserves space for
> logging only 4 extents (i.e. 4 exts * 2 trees * (2 * max depth - 1) * block
> size).

... Sorry, I meant to say "xfs_calc_itruncate_reservation() reserves log space
required for freeing 4 extents ..."

> But with the above change, a single transaction can now free upto 16
> extents. Wouldn't this overflow the reserved log space?


-- 
chandan
