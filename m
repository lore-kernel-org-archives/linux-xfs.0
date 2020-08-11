Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0C1C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 01:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 304F620716
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 01:50:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="nawnQNx+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgHKBuU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Aug 2020 21:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbgHKBuU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Aug 2020 21:50:20 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFDDC06174A
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2020 18:50:18 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t6so5948208pgq.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2020 18:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=povjCQt46PfJUW6GaxqYMQd6AQhuIvnF4UonczoK1bk=;
        b=nawnQNx+fDH7fdH+M/i5285aX3GxNhntfCPepVRPFj5tAmKfdH9+A3OePVKP4zCe8g
         LZXiLi5Etq93fTBjMM0SSKS9JkpyNjQ87iK65riDvb+uN8UKS/u8PRgK/Py56PlHciWH
         Fs1an9NA0/I+eTWwRwKt9EDjbYKkfbe7EpSRAJHqqgnMC8w1VAqkU0P7Ri59eOO1E45A
         6VCEYk779+HObKIVxKtpxosFW5JAn61XVmopK/+b5mteQGivebAOFB4iQe/Z/fdM0hg/
         si31q0G1um/swqUD4GeoEjGs+ZticiiB3XL+9fsK9bn1tzMSri5bLQW+T+8V1MqTDatU
         guyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=povjCQt46PfJUW6GaxqYMQd6AQhuIvnF4UonczoK1bk=;
        b=aXLhE3Ha/ZexpIp9THuJr/h7GlLKqiUyY919rZZ9xRg3xbhUaT/XRebJEbRv1EMSMZ
         TUItAAuWSMx90iYGJZjGU7s6TlAQZ11qyNJErdIbIlnZgbGdRZTuBDlmh0iGqMDJX1M8
         oW0GVoIHw6LfCLsctab/NB82g3Z6CFv6WXVQLiPl48upXLmPj2m/pV0yQaMaaSCUz5XS
         IWa7E9A7KeA3rjxWOkE0lLlSglYT2kCxlimWZ71LaqxrnKHKJ6l7h0PIthmgJQ1Z9Yke
         4koFKS9EVZtZc2Kk3OWKpCC1Ep2xjmLxwA7IItXsGFjPtAOyxDKUYEu3Wm2GEJoF3ZTb
         GXvw==
X-Gm-Message-State: AOAM532eKjyGSRBcZlOsCHPL2ZYicF+ylvqAKBZ3DobtuLUVeCH8wRWl
        8HUdLATIHq3uXc3tLtZ/upPHMFRzOCM=
X-Google-Smtp-Source: ABdhPJz+3LDs74qGIrDD7q/MaoP2KPeik9P1uqp4xZZbwQBGx4QcETN+QmLc+BpRI0vNFRVusQKClg==
X-Received: by 2002:a63:8943:: with SMTP id v64mr23455925pgd.261.1597110617980;
        Mon, 10 Aug 2020 18:50:17 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s1sm14585396pgh.47.2020.08.10.18.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 18:50:17 -0700 (PDT)
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
From:   Jens Axboe <axboe@kernel.dk>
To:     Dave Chinner <david@fromorbit.com>,
        bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
 <20200810090859.GK2114@dread.disaster.area>
 <eeb0524b-3aa7-0f5f-22a6-f7faf2532355@kernel.dk>
Message-ID: <1e2d99ff-a893-9100-2684-f0f2c2d1b787@kernel.dk>
Date:   Mon, 10 Aug 2020 19:50:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <eeb0524b-3aa7-0f5f-22a6-f7faf2532355@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/10/20 7:15 PM, Jens Axboe wrote:
> On 8/10/20 3:08 AM, Dave Chinner wrote:
>> On Mon, Aug 10, 2020 at 05:08:07PM +1000, Dave Chinner wrote:
>>> [cc Jens]
>>>
>>> [Jens, data corruption w/ io_uring and simple fio reproducer. see
>>> the bz link below.]
>>>
>>> On Mon, Aug 10, 2020 at 01:56:05PM +1000, Dave Chinner wrote:
>>>> On Mon, Aug 10, 2020 at 10:09:32AM +1000, Dave Chinner wrote:
>>>>> On Fri, Aug 07, 2020 at 03:12:03AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
>>>>>> --- Comment #1 from Dave Chinner (david@fromorbit.com) ---
>>>>>> On Thu, Aug 06, 2020 at 04:57:58AM +0000, bugzilla-daemon@bugzilla.kernel.org
>>>>>> wrote:
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=208827
>>>>>>>
>>>>>>>             Bug ID: 208827
>>>>>>>            Summary: [fio io_uring] io_uring write data crc32c verify
>>>>>>>                     failed
>>>>>>>            Product: File System
>>>>>>>            Version: 2.5
>>>>>>>     Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4
>>>>>
>>>>> FWIW, I can reproduce this with a vanilla 5.8 release kernel,
>>>>> so this isn't related to contents of the XFS dev tree at all...
>>>>>
>>>>> In fact, this bug isn't a recent regression. AFAICT, it was
>>>>> introduced between in 5.4 and 5.5 - 5.4 did not reproduce, 5.5 did
>>>>> reproduce. More info once I've finished bisecting it....
>>>>
>>>> f67676d160c6ee2ed82917fadfed6d29cab8237c is the first bad commit
>>>> commit f67676d160c6ee2ed82917fadfed6d29cab8237c
>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>> Date:   Mon Dec 2 11:03:47 2019 -0700
>>>>
>>>>     io_uring: ensure async punted read/write requests copy iovec
>>>
>>> ....
>>>
>>> Ok, I went back to vanilla 5.8 to continue debugging and adding
>>> tracepoints, and it's proving strangely difficult to reproduce now.
>>
>> Which turns out to be caused by a tracepoint I inserted to try to
>> narrow down if this was an invalidation race. I put this in
>> invalidate_complete_page:
>>
>>
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -257,8 +257,11 @@ int invalidate_inode_page(struct page *page)
>>         struct address_space *mapping = page_mapping(page);
>>         if (!mapping)
>>                 return 0;
>> -       if (PageDirty(page) || PageWriteback(page))
>> +       if (PageDirty(page) || PageWriteback(page)) {
>> +               trace_printk("ino 0x%lx page %p, offset 0x%lx\n",
>> +                       mapping->host->i_ino, page, page->index * PAGE_SIZE);
>>                 return 0;
>> +       }
>>         if (page_mapped(page))
>>                 return 0;
>>         return invalidate_complete_page(mapping, page);
>>
>>
>> And that alone, without even enabling tracepoints, made the
>> corruption go completely away. So I suspect a page state race
>> condition and look at POSIX_FADV_DONTNEED, which fio is issuing
>> before running it's verification reads. First thing that does:
>>
>> 	if (!inode_write_congested(mapping->host))
>> 		__filemap_fdatawrite_range(mapping, offset, endbyte,
>> 					   WB_SYNC_NONE);
>>
>> It starts async writeback of the dirty pages. There's 256MB of dirty
>> pages on these inodes, and iomap tracing indicates the entire 256MB
>> immediately runs through the trace_iomap_writepage() tracepoint.
>> i.e. every page goes Dirty -> Writeback and is submitted for async
>> IO.
>>
>> Then the POSIX_FADV_DONTNEED code goes and runs
>> invalidate_mapping_pages(), which ends up try-locking each page and
>> then running invalidate_inode_page() on the page, which is where the
>> trace debug I put in on pages under writeback gets hit. So if
>> changing the invalidation code for pages under writeback makes the
>> problem go away, then stopping invalidate_mapping_pages() from
>> racing with page writeback should make the problem go away, too.
>>
>> This does indeed make the corruption go away:
>>
>> --- a/mm/fadvise.c
>> +++ b/mm/fadvise.c
>> @@ -109,9 +109,8 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>>         case POSIX_FADV_NOREUSE:
>>                 break;
>>         case POSIX_FADV_DONTNEED:
>>                 if (!inode_write_congested(mapping->host))
>> -                       __filemap_fdatawrite_range(mapping, offset, endbyte,
>> -                                                  WB_SYNC_NONE);
>> +                       filemap_write_and_wait_range(mapping, offset, endbyte);
>>  
>>                 /*
>>                  * First and last FULL page! Partial pages are deliberately
>>
>> by making the invalidation wait for the pages to go fully to the
>> clean state before starting.
>>
>> This, however, only fixes the specific symptom being tripped over
>> here.  To further test this, I removed this writeback from
>> POSIX_FADV_DONTNEED completely so I could trigger writeback via
>> controlled background writeback. And, as I expected, whenever
>> background writeback ran to write back these dirty files, the
>> verification failures triggered again. It is quite reliable.
>>
>> So it looks like there is some kind of writeback completion vs page
>> invalidation race condition occurring, but more work is needed to
>> isolate it further. I don't know what part the async read plays in
>> the corruption yet, because I don't know how we are getting pages in
>> the cache where page->index != the file offset stamped in the data.
>> That smells of leaking PageUptodate flags...
> 
> The async read really isn't doing anything that you could not do with
> separate threads. Unfortunately it's not that easy to have multiple
> threads working on the same region with fio, or we could've reproduced
> it with a job file written to use that instead.
> 
> I'll dig a bit here...

Have we verified that the actual page cache is inconsistent, or is that
just an assumption? I'm asking since I poked a bit on the fio side, and
suspiciously the failed verification was a short IO. At least
originally, fio will retry those, but it could be a bug in the io_uring
engine for fio.

I'll poke some more.

-- 
Jens Axboe

