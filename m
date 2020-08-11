Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F537C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 01:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 137DC206DC
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 01:15:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="f+oO9GJu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgHKBPe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Aug 2020 21:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgHKBPd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Aug 2020 21:15:33 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95910C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2020 18:15:33 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id c6so1014023pje.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2020 18:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+Ee/MXqeQ5xMQXWH912iGosACl2mM/ZXvvOGKTWrT+U=;
        b=f+oO9GJu9i6FHNtINQGQm+0o7ZrPiU94FJI3XudC49k2A0JoPCrga7DLEE7r3o4/Op
         W9y9dBUFqJhDWeADUOAcEIE+npJO2mK3PH+3v63Kh2/SP+qeA26DHnzdbYkCtyJkCMRU
         AftiWWcrY+zDMEiZqEechgSuf7yT5Tj1pxe1L9HQsqQJtnoFuGnxcuIBM5bXK8lTrkfu
         1QLN4rTKNwSHffPZputCc2GcuvUjwVOhSUh0CX4BYByHd/CJTULStIaIWI4IYuVol7So
         LhtgyLtaHtUU+9W6H9ZrrRknOr3ZzVii31wjUBCU3Wqwzj0HfQ2z85Ni7IMcx65r1Mda
         3z5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Ee/MXqeQ5xMQXWH912iGosACl2mM/ZXvvOGKTWrT+U=;
        b=hSS7WXaoI/VOknKz0PFzZ3smmx/XVBqHLPdyaU/QUj8Lt4vblJBbFJ5QbYP8yvXknI
         YCG8FzxzWtswBH9zIUDGfbfqZv/rYFZeXC2WV5I4XJmB+fS0bWTim/LzPRdMS+e2YxWG
         ZbA4OLJxX/WrYhcco/xXb0zLE8E7a64050Mjop8zzeQEvcohUkt3vuJ2IBlRZm9m/98b
         cQOI0Iv4joLC8tGvq+3Sv/DXdkTsRjfIRrCS2mGuBQxzWxRzMn9ghjHgjS8OEE8wLnaN
         /CqpQZ6+BCWSCrsy389i9lROaDNynQSSzZQ/qnDiDVX32NpQGV4gHnqcOakeFnNPxmBr
         GoTA==
X-Gm-Message-State: AOAM531W1+3WXqcEWSvf8oBRx26jEKLgs3CAdN1+wTBPVdqsSvkbewnS
        ti4Q0zHKg2mkzIILLPrcAWKzU/Xal2A=
X-Google-Smtp-Source: ABdhPJySpJHH0vBVnct/cnbFff0CmAkC852rm6/uawHNX53v5YIEMcNgWtMJTKBOanIqebt7WjOjTw==
X-Received: by 2002:a17:902:246:: with SMTP id 64mr26366195plc.70.1597108532714;
        Mon, 10 Aug 2020 18:15:32 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id mr21sm689414pjb.57.2020.08.10.18.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 18:15:32 -0700 (PDT)
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
To:     Dave Chinner <david@fromorbit.com>,
        bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
 <20200810090859.GK2114@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eeb0524b-3aa7-0f5f-22a6-f7faf2532355@kernel.dk>
Date:   Mon, 10 Aug 2020 19:15:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810090859.GK2114@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/10/20 3:08 AM, Dave Chinner wrote:
> On Mon, Aug 10, 2020 at 05:08:07PM +1000, Dave Chinner wrote:
>> [cc Jens]
>>
>> [Jens, data corruption w/ io_uring and simple fio reproducer. see
>> the bz link below.]
>>
>> On Mon, Aug 10, 2020 at 01:56:05PM +1000, Dave Chinner wrote:
>>> On Mon, Aug 10, 2020 at 10:09:32AM +1000, Dave Chinner wrote:
>>>> On Fri, Aug 07, 2020 at 03:12:03AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
>>>>> --- Comment #1 from Dave Chinner (david@fromorbit.com) ---
>>>>> On Thu, Aug 06, 2020 at 04:57:58AM +0000, bugzilla-daemon@bugzilla.kernel.org
>>>>> wrote:
>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=208827
>>>>>>
>>>>>>             Bug ID: 208827
>>>>>>            Summary: [fio io_uring] io_uring write data crc32c verify
>>>>>>                     failed
>>>>>>            Product: File System
>>>>>>            Version: 2.5
>>>>>>     Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4
>>>>
>>>> FWIW, I can reproduce this with a vanilla 5.8 release kernel,
>>>> so this isn't related to contents of the XFS dev tree at all...
>>>>
>>>> In fact, this bug isn't a recent regression. AFAICT, it was
>>>> introduced between in 5.4 and 5.5 - 5.4 did not reproduce, 5.5 did
>>>> reproduce. More info once I've finished bisecting it....
>>>
>>> f67676d160c6ee2ed82917fadfed6d29cab8237c is the first bad commit
>>> commit f67676d160c6ee2ed82917fadfed6d29cab8237c
>>> Author: Jens Axboe <axboe@kernel.dk>
>>> Date:   Mon Dec 2 11:03:47 2019 -0700
>>>
>>>     io_uring: ensure async punted read/write requests copy iovec
>>
>> ....
>>
>> Ok, I went back to vanilla 5.8 to continue debugging and adding
>> tracepoints, and it's proving strangely difficult to reproduce now.
> 
> Which turns out to be caused by a tracepoint I inserted to try to
> narrow down if this was an invalidation race. I put this in
> invalidate_complete_page:
> 
> 
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -257,8 +257,11 @@ int invalidate_inode_page(struct page *page)
>         struct address_space *mapping = page_mapping(page);
>         if (!mapping)
>                 return 0;
> -       if (PageDirty(page) || PageWriteback(page))
> +       if (PageDirty(page) || PageWriteback(page)) {
> +               trace_printk("ino 0x%lx page %p, offset 0x%lx\n",
> +                       mapping->host->i_ino, page, page->index * PAGE_SIZE);
>                 return 0;
> +       }
>         if (page_mapped(page))
>                 return 0;
>         return invalidate_complete_page(mapping, page);
> 
> 
> And that alone, without even enabling tracepoints, made the
> corruption go completely away. So I suspect a page state race
> condition and look at POSIX_FADV_DONTNEED, which fio is issuing
> before running it's verification reads. First thing that does:
> 
> 	if (!inode_write_congested(mapping->host))
> 		__filemap_fdatawrite_range(mapping, offset, endbyte,
> 					   WB_SYNC_NONE);
> 
> It starts async writeback of the dirty pages. There's 256MB of dirty
> pages on these inodes, and iomap tracing indicates the entire 256MB
> immediately runs through the trace_iomap_writepage() tracepoint.
> i.e. every page goes Dirty -> Writeback and is submitted for async
> IO.
> 
> Then the POSIX_FADV_DONTNEED code goes and runs
> invalidate_mapping_pages(), which ends up try-locking each page and
> then running invalidate_inode_page() on the page, which is where the
> trace debug I put in on pages under writeback gets hit. So if
> changing the invalidation code for pages under writeback makes the
> problem go away, then stopping invalidate_mapping_pages() from
> racing with page writeback should make the problem go away, too.
> 
> This does indeed make the corruption go away:
> 
> --- a/mm/fadvise.c
> +++ b/mm/fadvise.c
> @@ -109,9 +109,8 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>         case POSIX_FADV_NOREUSE:
>                 break;
>         case POSIX_FADV_DONTNEED:
>                 if (!inode_write_congested(mapping->host))
> -                       __filemap_fdatawrite_range(mapping, offset, endbyte,
> -                                                  WB_SYNC_NONE);
> +                       filemap_write_and_wait_range(mapping, offset, endbyte);
>  
>                 /*
>                  * First and last FULL page! Partial pages are deliberately
> 
> by making the invalidation wait for the pages to go fully to the
> clean state before starting.
> 
> This, however, only fixes the specific symptom being tripped over
> here.  To further test this, I removed this writeback from
> POSIX_FADV_DONTNEED completely so I could trigger writeback via
> controlled background writeback. And, as I expected, whenever
> background writeback ran to write back these dirty files, the
> verification failures triggered again. It is quite reliable.
> 
> So it looks like there is some kind of writeback completion vs page
> invalidation race condition occurring, but more work is needed to
> isolate it further. I don't know what part the async read plays in
> the corruption yet, because I don't know how we are getting pages in
> the cache where page->index != the file offset stamped in the data.
> That smells of leaking PageUptodate flags...

The async read really isn't doing anything that you could not do with
separate threads. Unfortunately it's not that easy to have multiple
threads working on the same region with fio, or we could've reproduced
it with a job file written to use that instead.

I'll dig a bit here...

-- 
Jens Axboe

