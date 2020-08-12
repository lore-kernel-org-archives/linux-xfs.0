Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E56C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 15:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D63E52177B
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 15:14:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="sT0Z0+8E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgHLPOI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 11:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgHLPOE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 11:14:04 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BC9C061383
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 08:14:03 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c6so1292600pje.1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 08:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j9NGGzZzSvyjeNBCzqvn69Zw3a2I8W6CMwCC26Npc5A=;
        b=sT0Z0+8EyYMRiGTz8Q7rC7/yVQIizzIhlO1w4+5U20KMsgnfRRtFw/J6tkGqNd48hd
         7qDB5UVk0vx2OD5lPrNHXunP7GIbVyaOiNpUjdvpEoOSzPRmsSrirtPZDhshJoWllg2N
         55hDuKpfKzdFK1rC/eMV1SX0VR3sUKFo3HhxmJfhymQIT9EE/vYlhyrhOvEfgZuy4ZhL
         lotXlhfjVlfBJkTwpT/3mbkijrLTBGerypk9glqW5dzouio1VFF+Zt8lKBo6iAsiBX07
         ksfA5fUBYHKM/aKkA7KVg/CYZITalaK8yLjij91tdZS6G/o6ao0TebpJBkH5f8Lp7KUz
         rpAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j9NGGzZzSvyjeNBCzqvn69Zw3a2I8W6CMwCC26Npc5A=;
        b=Tax5lOMQjGXoYKqmUQ1L9j0GH4ST/atQPO0uiJMHIdIrLs3r/JwY4ecJcQ2KQ3VsMJ
         cIhJ+r4mJLbGaDR1KLnnYP7g19aqneIce3fW8RWEs3ixprNDUAMt0YkYWoMvVn0q8PVS
         pgxwxBLL4Ep7gbVBqrqAbashIoF9cizyJpG638cad1qJjPxAyijeAwOxWi9PqEZHjt4t
         vHFXRpjm3exdWwDOQL+3bCZa01QBVtf+l/C57yKFuuud+QOI/JBJIxW/jW4Upgr6feEq
         7TjsJibIFdc0mx9RH0NIJlj5NGGKUHql3EnEVkWvLims9STkpkAiMTpTHr4I0uofoF3i
         mwzQ==
X-Gm-Message-State: AOAM532ENjJ7kbHBo8p+AjHYVz36aU+VtgYnRAXaitFlUdC/9rdbV0B5
        1h4x1Op7Gos2x63tJowVolEruf6bwu4=
X-Google-Smtp-Source: ABdhPJxGMHE63W2CFDg7P4c34VoyIufLMuXwcEt5GuCWXCXJCt7gOJ/WO5MYH4Ic9SDQO1jvi9WeZg==
X-Received: by 2002:a17:902:bd47:: with SMTP id b7mr5949238plx.144.1597245240438;
        Wed, 12 Aug 2020 08:14:00 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q7sm2801650pfl.156.2020.08.12.08.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 08:13:59 -0700 (PDT)
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
To:     Dave Chinner <david@fromorbit.com>, Jeff Moyer <jmoyer@redhat.com>
Cc:     bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
 <20200810090859.GK2114@dread.disaster.area>
 <eeb0524b-3aa7-0f5f-22a6-f7faf2532355@kernel.dk>
 <1e2d99ff-a893-9100-2684-f0f2c2d1b787@kernel.dk>
 <cd94fcfb-6a8f-b0f4-565e-74733d71d7c3@kernel.dk>
 <x49zh70zyt6.fsf@segfault.boston.devel.redhat.com>
 <20200811220929.GQ2114@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a36fb6bd-ed0b-6eda-83be-83c0e7b377ce@kernel.dk>
Date:   Wed, 12 Aug 2020 09:13:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200811220929.GQ2114@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/11/20 4:09 PM, Dave Chinner wrote:
> On Tue, Aug 11, 2020 at 04:56:37PM -0400, Jeff Moyer wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>>
>>> So it seems to me like the file state is consistent, at least after the
>>> run, and that this seems more likely to be a fio issue with short
>>> read handling.
>>
>> Any idea why there was a short read, though?
> 
> Yes. See:
> 
> https://lore.kernel.org/linux-xfs/20200807024211.GG2114@dread.disaster.area/T/#maf3bd9325fb3ac0773089ca58609a2cea0386ddf
> 
> It's a race between the readahead io completion marking pages
> uptodate and unlocking them, and the io_uring worker function
> getting woken on the first page being unlocked and running the
> buffered read before the entire readahead IO completion has unlocked
> all the pages in the IO.
> 
> Basically, io_uring is re-running the IOCB_NOWAIT|IOCB_WAITQ IO when
> there are still pages locked under IO. This will happen much more
> frequently the larger the buffered read (these are only 64kB) and
> the readahead windows are opened.
> 
> Essentially, the io_uring buffered read needs to wait until _all_
> pages in the IO are marked up to date and unlocked, not just the
> first one. And not just the last one, either - readahead can be
> broken into multiple bios (because it spans extents) and there is no
> guarantee of order of completion of the readahead bios given by the
> readahead code....

Yes, it would ideally wait, or at least trigger on the last one. I'll
see if I can improve that. For any of my testing, the amount of
triggered short reads is minimal. For the verify case that we just ran,
we're talking 8-12 ios out of 820 thousand, or 0.001% of them. So
nothing that makes a performance difference in practical terms, though
it would be nice to not hand back short reads if we can avoid it. Not
for performance reasons, but for usage reasons.

-- 
Jens Axboe

