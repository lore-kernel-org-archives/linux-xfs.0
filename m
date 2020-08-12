Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0463C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 15:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F9F4207F7
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 15:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="H3W5OSyC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHLPT6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 11:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgHLPT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 11:19:56 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F46FC061383
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 08:19:56 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id v15so1208047pgh.6
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 08:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FZZ2EOBhSTNr5q4p46pahFK75FARiJdUixXTHPXkO1M=;
        b=H3W5OSyCWAab2n+OJUUJNvmkjhp2tXjDxI+tOYFOMWvy/aayq1ZMGBmwuX7LRyQIC7
         NeKMGzpLwNdliqy3YzGMznYTEoJAXSdc03owu101l4dL24eTt+jH8dYuzVSd9ZmRYuMT
         NP9OYZ0F+1q/9liioIo6enGvha9Gkhm5j4R/3YTmi6f4jyYQ1DRq8WmvXkHzy4opZubd
         oePM+XaMTNyynk+8aLsHM/3ILjcgMeb6pLawwaOFakFvwnR3JGTFnbn9NGX5vqmBsVD3
         OXGLcdOAorzMRjSWztcHc5CM5kfBGW9FCyfrTOotg/XvJZBeIq/9GszI/AROy1z7p3bH
         sLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FZZ2EOBhSTNr5q4p46pahFK75FARiJdUixXTHPXkO1M=;
        b=JgzLE00KY9iKsxubaco2zleCudOQ9ey/xCTpoJk20jHJgNHH6GtST+6A+gvLcCV6iM
         4GypCn/WPOW7DIHQ3mEl3lVySyWjmTRIbYdiHuulAKeyKFI6brVW9Cnhu/X4xax8Zghb
         HoD8b/GbWUDT6E1mkWfwBoIfiwGtyALXP2qS9LR0A6jmC89mxCc8EX3+pW9Mfj++dBB8
         bLrqgYNAyZFTP2tCeA4mZdaTiBH4Eld1wc/VSR6CFnXcklC0Lzr26zv8HxK130HzpOWF
         OY8E2/tDTRhqjF8JsY9Z/sv3uk4yW+565rJFfpNV5zaIjpt9AzWBLOtnP9rD8NrK7TqZ
         EbDw==
X-Gm-Message-State: AOAM532E7w2azGXwWnao9l2Ub2AD9YmrlyeUvrpxzHKjLBFuyt9/2gJ+
        /yUlDY6riG78/sydXxyZHXI/mCs2yPo=
X-Google-Smtp-Source: ABdhPJzihaiHmXefDneBZrTc6Vvr3hgfULs84Jzj3O68YEhwL/09irVcKEyBIUPZRF8MgtHhQj626w==
X-Received: by 2002:a65:47c7:: with SMTP id f7mr5349363pgs.361.1597245593004;
        Wed, 12 Aug 2020 08:19:53 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b23sm2758306pfo.12.2020.08.12.08.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 08:19:52 -0700 (PDT)
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
To:     Dave Chinner <david@fromorbit.com>
Cc:     bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org
References: <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
 <20200810090859.GK2114@dread.disaster.area>
 <20200811020052.GM2114@dread.disaster.area>
 <d7c9ea39-136d-bc1b-7282-097a784e336b@kernel.dk>
 <20200811070505.GO2114@dread.disaster.area>
 <547cde58-26f3-05f1-048c-fa2a94d6e176@kernel.dk>
 <20200811215913.GP2114@dread.disaster.area>
 <20200811230053.GR2114@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2db326ee-cafb-5d9f-0b51-23cfe961e93a@kernel.dk>
Date:   Wed, 12 Aug 2020 09:19:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200811230053.GR2114@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/11/20 5:00 PM, Dave Chinner wrote:
> On Wed, Aug 12, 2020 at 07:59:13AM +1000, Dave Chinner wrote:
>> On Tue, Aug 11, 2020 at 07:10:30AM -0600, Jens Axboe wrote:
>>> What job file are you running? It's not impossible that I broken
>>> something else in fio, the io_u->verify_offset is a bit risky... I'll
>>> get it fleshed out shortly.
>>
>> Details are in the bugzilla I pointed you at. I modified the
>> original config specified to put per-file and offset identifiers
>> into the file data rather than using random data. This is
>> "determining the origin of stale data 101" stuff - the first thing
>> we _always_ do when trying to diagnose data corruption is identify
>> where the bad data came from.
>>
>> Entire config file is below.
> 
> Just as a data point: btrfs fails this test even faster than XFS.
> Both with the old 3.21 fio binary and the new one.

I can't trigger any failures with the fixes I committed, so that's a bit
puzzling. What storage are you running this on? I'll try a few other
things.

> Evidence points to this code being very poorly tested. Both
> filesystems it is enabled on fail validation with the tool is
> supposed to exercise and validate io_uring IO path behaviour.
> 
> Regardless of whether this is a tool failure or a kernel code
> failure, the fact is that nobody ran data validation tests on this
> shiny new code. And for a storage API that is reading and writing
> user data, that's a pretty major process failure....
> 
> Improvements required, Jens.

Let's turn down the condescension and assumptions a notch, please. The
fio io_uring engine was originally written to benchmark it, and I
haven't really been using it for verification purposes (as is evident).
In my experience, I get much better validation from running internal
production. And plenty of that has been done.

That said, the fio side should of course work, since others can't
necessarily run what I'm running, and it does provide ways to exercise
it that aren't necessarily seen in prod. But blankly assuming that
"nobody ran data validation tests on this shiny new code" is blatantly
false.

-- 
Jens Axboe

