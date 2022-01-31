Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF39EC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 20:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350858AbiAaUoQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 15:44:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34257 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378117AbiAaUoL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 15:44:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643661850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jpEy89tf/LMcNapmXaYvmkPjpSc6eNo86g02EFxQuig=;
        b=WydqJcMhL6W2+tzs9zPZ5l3hQ6YUVoYkvBoP94FQebgslIJYOzTx9SaRfeJUqz8Hs4Nqm4
        JdgEDcZVeDcrsooRT0ZCGWJyAqSBRIAl5VY653saCbE/jcNMTpQFXIA02a0clo+geVHc4Z
        qyuDTkBgSBYuoFsMsqiB7Mvi1xgewGc=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-ry45can7NpGh5HcPMI8GAw-1; Mon, 31 Jan 2022 15:44:09 -0500
X-MC-Unique: ry45can7NpGh5HcPMI8GAw-1
Received: by mail-io1-f70.google.com with SMTP id n20-20020a6bed14000000b0060faa0aefd3so10957433iog.20
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jan 2022 12:44:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=jpEy89tf/LMcNapmXaYvmkPjpSc6eNo86g02EFxQuig=;
        b=p+N1Mmws1DElSDNOPGawcMTnigOyh+3/P1niQwc8b2cjhZRGnBqvnBf5FXwwFWMQW4
         gTaYJSNvPrs3WbLjaRm3cBj1tOPeWVZPQ1Pnm2J6CC0SOMPym0kB649eBinsUUGIvKTX
         c+VzHkJFGixtmZ6Zl2iAvbR3qhx42KxQD7uq5ocA+IN57ITSmulM7h1NXii+9hjsgh/u
         12BGZz2l9FY6wLUSTPydoSBD2gSw5LCCq/M6j992sHva0kCfVVCqZPx7XjI/I21sB/uD
         VuHJEKNZ1S1Ja2rjfFj0ph3Tqp2sY8O7JYmVLaeueM+tHt2M3Ukm8B3c3rJmkODYTu52
         KIHA==
X-Gm-Message-State: AOAM532TsV8RXRLvz5RHCUbzSWoP6sHU8jn9YZwQOIYJC/NfCRCsLwrJ
        xqB61JKgcdngOfl1jcMkNU6yogXpmuqvcj34RL0IarvJHLgvTwFpNfvoIH48AFnHUr+/64jPV5F
        GJ6+P2vBixFWAdOGnTbui
X-Received: by 2002:a05:6e02:219b:: with SMTP id j27mr13736971ila.154.1643661848589;
        Mon, 31 Jan 2022 12:44:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxgZ5fXDkzazxcQgyDYKYixqqA+IZfvc7okFZZy2T7RxpaOvAzrITfaV4DSwbFFgIcj137vbw==
X-Received: by 2002:a05:6e02:219b:: with SMTP id j27mr13736966ila.154.1643661848323;
        Mon, 31 Jan 2022 12:44:08 -0800 (PST)
Received: from [10.0.0.147] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id g14sm7610195ilr.12.2022.01.31.12.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 12:44:07 -0800 (PST)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <11bb46f1-171d-d3a6-bb40-390f1b08ab78@redhat.com>
Date:   Mon, 31 Jan 2022 14:44:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH 42/45] libxfs: replace XFS_BUF_SET_ADDR with a function
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263807467.860211.13040036268013928337.stgit@magnolia>
 <217c0998-4795-c85c-54cb-45b47ba99ac8@sandeen.net>
 <20220128230405.GM13540@magnolia>
In-Reply-To: <20220128230405.GM13540@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/28/22 5:04 PM, Darrick J. Wong wrote:
> On Fri, Jan 28, 2022 at 02:53:02PM -0600, Eric Sandeen wrote:
>> On 1/19/22 6:21 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>
>>> Replace XFS_BUF_SET_ADDR with a new function that will set the buffer
>>> block number correctly, then port the two users to it.
>>
>> Ok, this is in preparation for later adding more to the
>> function (saying "set it correctly" confused me a little, because
>> the function looks equivalent to the macro....)
>>
>> ...
>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>> index 63895f28..057b3b09 100644
>>> --- a/mkfs/xfs_mkfs.c
>>> +++ b/mkfs/xfs_mkfs.c
>>> @@ -3505,8 +3505,8 @@ alloc_write_buf(
>>>    				error);
>>>    		exit(1);
>>>    	}
>>> -	bp->b_bn = daddr;
>>> -	bp->b_maps[0].bm_bn = daddr;
>>> +
>>> +	xfs_buf_set_daddr(bp, daddr);
>>
>> This *looks* a little like a functional change, since you dropped
>> setting of the bp->b_maps[0].bm_bn. But since we get here with a
>> single buffer, not a map of buffers, I ... think that at this point,
>> nobody will be looking at b_maps[0].bm_bn anyway?
>>
>> But I'm not quite sure. I also notice xfs_get_aghdr_buf() in the kernel
>> setting both b_bn and b_maps[0].bm_bn upstream, for similar purposes.
>>
>> Can you sanity-check me a little here?
> 
> This whole thing is as twisty as a pretzel driving into the mountains.
> 
> The end game is that b_bn is actually the cache key for the xfs_buf
> structure, so ultimately we don't want anyone accessing it other than
> the cache management functions.  Hence we spend the next two patches
> kicking everybody off of b_bn and then rename it to b_cache_key.  Anyone
> who wants the daddr address of an xfs_buf (cached or uncached) is
> supposed to use bp->b_maps[0].bm_bn (or xfs_buf_daddr/xfs_buf_set_daddr)
> after that point.
> 
> xfs_get_aghdr_buf (in xfs_ag.c) encodes that rather than setting up a
> one-liner helper because that's the only place in the kernel where we
> call xfs_buf_get_uncached.  By contrast, userspace needs to set a
> buffer's daddr(ess) from mkfs and libxlog, so (I guess) that's why the
> helper is still useful.
> 
> *However* at this point in the game, most people still use b_bn
> (incorrectly) so that's probably why alloc_write_buf sets both.
> 
> I guess this patch should have replaced only the "b_bn = daddr" part,
> and in the next patch removed the "bp->b_maps[0].bm_bn = daddr" line.

Ah, that makes sense, sorry for not assimilating the next patch in
my brain before asking.

I'll make that minor change and,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> After all that, b_bn of the uncached buffer will be NULLDADDR, like it's
> supposed to be.
> 
> --D
> 
>> Thanks,
>> -Eric
>>
>>>    	return bp;
>>>    }
>>>
> 
> 

