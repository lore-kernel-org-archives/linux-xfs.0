Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E53C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 19:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 629AB21BE5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 19:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbhADT6d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 14:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbhADT6c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 14:58:32 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F73AC061794
        for <linux-xfs@vger.kernel.org>; Mon,  4 Jan 2021 11:57:52 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id t16so33374517wra.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Jan 2021 11:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ej0OIFO+0mGGo2YkH0+skzJSTijcTNuOuUrtv7QADVU=;
        b=K/p1TYjhBPrjwYWg42hO8xCm9nV7t1BzsFy+MkG6NZuoSgZ2fd9YUiwhayFIt/hC2m
         At3oo0ImnAeAYRKSwydDWgzPGJlQNfaIiNTO2kIsu1GPjKa1d3em2vZNoBUT6KTRlA6K
         sjLsixuyl2+VWR3WvSpyvoEYwnFG4yt+Hky6IxPRW55KNXIY5AgsvDBd2N3xHfVC1Mmr
         PKU4zOacSu1Ox9gX1BMCgomcfojfwsxRkH3bqM0A7agdpT45UWRMAAvrPN3/t5gkMfPZ
         IM9Oh394lhiv9DcuLFQdnT4oLSIvYEbh+/9ioNVLVO8QYrqB3hJM16MgEUL4MDHH/RbI
         xGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=ej0OIFO+0mGGo2YkH0+skzJSTijcTNuOuUrtv7QADVU=;
        b=ssFTAYJmQt8fCs+aQNxMzJtlAPjxcMZB1OQZtdIqP0K9y3iaEzjtkUCeSjOGpDtH/Y
         SOqdqdWVAVwdwKHX6U3NKyTMPT3B5W43PoDGB/oeTOwVa03rk4wYn9d8GnCTx/uGeK3l
         YkYP0M60/SJQsVyMf8A7HR30PVld6cqurwAU4ez4LP9U20yunZvtkjXDfH5zuzDgbFhe
         mjRzSnIYJa4VoR3lRWP3/WB7smmlMaYV/l2uvXFQgBiewHZEeUGNKGsnougBvmo7lxzr
         TrhIeljyyVpL6KY/7Y3NrWZxHvm+sggaZ0vN+nxFruqwTjnPTO2Gn6h3x4v6jw5v4YYm
         emsg==
X-Gm-Message-State: AOAM532d8Sp6HVbgNdlmuGE8FC3IJoiHVCjQCnbvqGbcjwL63ykCHR6U
        HNfTaJgHjXCQ9wu57K8hLKRlMA==
X-Google-Smtp-Source: ABdhPJxsUWGUoqG2VtgFWV2Mcr6vVTJl4GvEhsqAKeYC1V1AWbKHN0HIvm+W1R4FZYSnruLRDC+JOA==
X-Received: by 2002:adf:e4ca:: with SMTP id v10mr82787551wrm.260.1609790270744;
        Mon, 04 Jan 2021 11:57:50 -0800 (PST)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id u13sm94488427wrw.11.2021.01.04.11.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 11:57:49 -0800 (PST)
Subject: Re: fallocate(FALLOC_FL_ZERO_RANGE_BUT_REALLY) to avoid unwritten
 extents?
To:     Andres Freund <andres@anarazel.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-block@vger.kernel.org
References: <20201230062819.yinrrp6uwfegsqo3@alap3.anarazel.de>
 <20210104181958.GE6908@magnolia>
 <20210104191058.sryksqjnjjnn5raa@alap3.anarazel.de>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
Message-ID: <f6f75f11-5d5b-ae63-d584-4b6f09ff401e@scylladb.com>
Date:   Mon, 4 Jan 2021 21:57:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210104191058.sryksqjnjjnn5raa@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 04/01/2021 21.10, Andres Freund wrote:
> Hi,
>
> On 2021-01-04 10:19:58 -0800, Darrick J. Wong wrote:
>> On Tue, Dec 29, 2020 at 10:28:19PM -0800, Andres Freund wrote:
>>> Would it make sense to add a variant of FALLOC_FL_ZERO_RANGE that
>>> doesn't convert extents into unwritten extents, but instead uses
>>> blkdev_issue_zeroout() if supported?  Mostly interested in xfs/ext4
>>> myself, but ...
>>>
>>> Doing so as a variant of FALLOC_FL_ZERO_RANGE seems to make the most
>>> sense, as that'd work reasonably efficiently to initialize newly
>>> allocated space as well as for zeroing out previously used file space.
>>>
>>>
>>> As blkdev_issue_zeroout() already has a fallback path it seems this
>>> should be doable without too much concern for which devices have write
>>> zeroes, and which do not?
>> Question: do you want the kernel to write zeroes even for devices that
>> don't support accelerated zeroing?
> I don't have a strong opinion on it. A complex userland application can
> do a bit better job managing queue depth etc, but otherwise I suspect
> doing the IO from kernel will win by a small bit. And the queue-depth
> issue presumably would be relevant for write-zeroes as well, making me
> lean towards just using the fallback.
>

The new flag will avoid requiring DMA to transfer the entire file size, 
and perhaps can be implemented in the device by just adjusting metadata. 
So there is potential for the new flag to be much more efficient.


But note it will need to be plumbed down to md and dm to be generally 
useful.



