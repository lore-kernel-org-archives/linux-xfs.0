Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8675C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 03:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93F0F206C3
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 03:01:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="neU2foYk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgHKDBX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Aug 2020 23:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgHKDBX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Aug 2020 23:01:23 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C527DC06174A
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2020 20:01:21 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t10so6106974plz.10
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2020 20:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H7zBKwXR1hl+I5qs85CVSPvoX3+z9itftT6vnIdQN3E=;
        b=neU2foYkt6yvbHD/1IyQKEpGXrvQeEA3hy+mzcmij4SyN9KNS+1tEDWDDzSCqyN1q9
         DjECC1l50bJFRSmaFIYSerHwTXfSjCX666ysxMMvc81CN9lRE3Nx9V4cXc7K1BPnLl/v
         N5+FxGxB1wwZe9aqeVNf585oQdvB1BFkCCYhKHaowq7FQKbMWSusW6rrY3iymkEcyitb
         EyX8q0mHZ4siOzY7s3hiLu3XfVRUGdqN+9bZ0E2HoFlnXyb866XZCndfC6CVH1hm/99h
         o8/hexh+8Tr/Lv5398S+fscOnW64OD7Uxt9sPAAiDa5R9tX/QTMT849+zArxpdgsA/Kf
         eNIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H7zBKwXR1hl+I5qs85CVSPvoX3+z9itftT6vnIdQN3E=;
        b=E2ba5O9tyxrbLStNwuB84Uzxsew0gaknNM7ogiCTCFS7qalVHJpPUkel1cwSRTtGLh
         dcvl+jdDS9oJxavB/3E/sdDDHS+91Ripc9XNhFPdmuvTcFb48DII9X1F2Aq97Iw2vBR3
         7EvAuQsCAZcO98PB+zoVkXdplExzUl55+T88nZZcxLsjF5Ktyo4IGdu9glJLdsfTMtSk
         340kBtMKS0OM3aX++2NJjAdjaBeYo3I6nkwu6VHgBQuhC0FHLVm0rjJMZRSiR45OJdK2
         YtRyvIpIskfohTTsZW/C7amMNXb33qXxt0T2cOpGr+yj3S1QD9tZKPBq+aaBIBSsAwaB
         XTYg==
X-Gm-Message-State: AOAM530OirqdpR4P3Qu/95Giq1HzX0TzVlPXJJWqC8y62e9NpCAtxREy
        Vn/pDNiAK2F7793HNhA/4/6U0JyIJFI=
X-Google-Smtp-Source: ABdhPJy9dzcnnCtztU9OJDy9ScM2gpdDEETjpytjH5VdQAqxBn/qCMpe4xHstVj2A/0oKoSyPeij1g==
X-Received: by 2002:a17:90a:214a:: with SMTP id a68mr2339238pje.59.1597114880605;
        Mon, 10 Aug 2020 20:01:20 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q25sm20336669pfn.181.2020.08.10.20.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 20:01:19 -0700 (PDT)
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
 <1e2d99ff-a893-9100-2684-f0f2c2d1b787@kernel.dk>
 <cd94fcfb-6a8f-b0f4-565e-74733d71d7c3@kernel.dk>
Message-ID: <a01b791f-c6e9-c554-5293-b4baff01e9fd@kernel.dk>
Date:   Mon, 10 Aug 2020 21:01:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cd94fcfb-6a8f-b0f4-565e-74733d71d7c3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/10/20 8:01 PM, Jens Axboe wrote:
> On 8/10/20 7:50 PM, Jens Axboe wrote:
>> On 8/10/20 7:15 PM, Jens Axboe wrote:
>>> On 8/10/20 3:08 AM, Dave Chinner wrote:
>>>> On Mon, Aug 10, 2020 at 05:08:07PM +1000, Dave Chinner wrote:
>>>>> [cc Jens]
>>>>>
>>>>> [Jens, data corruption w/ io_uring and simple fio reproducer. see
>>>>> the bz link below.]
>>>>>
>>>>> On Mon, Aug 10, 2020 at 01:56:05PM +1000, Dave Chinner wrote:
>>>>>> On Mon, Aug 10, 2020 at 10:09:32AM +1000, Dave Chinner wrote:
>>>>>>> On Fri, Aug 07, 2020 at 03:12:03AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
>>>>>>>> --- Comment #1 from Dave Chinner (david@fromorbit.com) ---
>>>>>>>> On Thu, Aug 06, 2020 at 04:57:58AM +0000, bugzilla-daemon@bugzilla.kernel.org
>>>>>>>> wrote:
>>>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=208827
>>>>>>>>>
>>>>>>>>>             Bug ID: 208827
>>>>>>>>>            Summary: [fio io_uring] io_uring write data crc32c verify
>>>>>>>>>                     failed
>>>>>>>>>            Product: File System
>>>>>>>>>            Version: 2.5
>>>>>>>>>     Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4
>>>>>>>
>>>>>>> FWIW, I can reproduce this with a vanilla 5.8 release kernel,
>>>>>>> so this isn't related to contents of the XFS dev tree at all...
>>>>>>>
>>>>>>> In fact, this bug isn't a recent regression. AFAICT, it was
>>>>>>> introduced between in 5.4 and 5.5 - 5.4 did not reproduce, 5.5 did
>>>>>>> reproduce. More info once I've finished bisecting it....
>>>>>>
>>>>>> f67676d160c6ee2ed82917fadfed6d29cab8237c is the first bad commit
>>>>>> commit f67676d160c6ee2ed82917fadfed6d29cab8237c
>>>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>>>> Date:   Mon Dec 2 11:03:47 2019 -0700
>>>>>>
>>>>>>     io_uring: ensure async punted read/write requests copy iovec
>>>>>
>>>>> ....
>>>>>
>>>>> Ok, I went back to vanilla 5.8 to continue debugging and adding
>>>>> tracepoints, and it's proving strangely difficult to reproduce now.
>>>>
>>>> Which turns out to be caused by a tracepoint I inserted to try to
>>>> narrow down if this was an invalidation race. I put this in
>>>> invalidate_complete_page:
>>>>
>>>>
>>>> --- a/mm/truncate.c
>>>> +++ b/mm/truncate.c
>>>> @@ -257,8 +257,11 @@ int invalidate_inode_page(struct page *page)
>>>>         struct address_space *mapping = page_mapping(page);
>>>>         if (!mapping)
>>>>                 return 0;
>>>> -       if (PageDirty(page) || PageWriteback(page))
>>>> +       if (PageDirty(page) || PageWriteback(page)) {
>>>> +               trace_printk("ino 0x%lx page %p, offset 0x%lx\n",
>>>> +                       mapping->host->i_ino, page, page->index * PAGE_SIZE);
>>>>                 return 0;
>>>> +       }
>>>>         if (page_mapped(page))
>>>>                 return 0;
>>>>         return invalidate_complete_page(mapping, page);
>>>>
>>>>
>>>> And that alone, without even enabling tracepoints, made the
>>>> corruption go completely away. So I suspect a page state race
>>>> condition and look at POSIX_FADV_DONTNEED, which fio is issuing
>>>> before running it's verification reads. First thing that does:
>>>>
>>>> 	if (!inode_write_congested(mapping->host))
>>>> 		__filemap_fdatawrite_range(mapping, offset, endbyte,
>>>> 					   WB_SYNC_NONE);
>>>>
>>>> It starts async writeback of the dirty pages. There's 256MB of dirty
>>>> pages on these inodes, and iomap tracing indicates the entire 256MB
>>>> immediately runs through the trace_iomap_writepage() tracepoint.
>>>> i.e. every page goes Dirty -> Writeback and is submitted for async
>>>> IO.
>>>>
>>>> Then the POSIX_FADV_DONTNEED code goes and runs
>>>> invalidate_mapping_pages(), which ends up try-locking each page and
>>>> then running invalidate_inode_page() on the page, which is where the
>>>> trace debug I put in on pages under writeback gets hit. So if
>>>> changing the invalidation code for pages under writeback makes the
>>>> problem go away, then stopping invalidate_mapping_pages() from
>>>> racing with page writeback should make the problem go away, too.
>>>>
>>>> This does indeed make the corruption go away:
>>>>
>>>> --- a/mm/fadvise.c
>>>> +++ b/mm/fadvise.c
>>>> @@ -109,9 +109,8 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>>>>         case POSIX_FADV_NOREUSE:
>>>>                 break;
>>>>         case POSIX_FADV_DONTNEED:
>>>>                 if (!inode_write_congested(mapping->host))
>>>> -                       __filemap_fdatawrite_range(mapping, offset, endbyte,
>>>> -                                                  WB_SYNC_NONE);
>>>> +                       filemap_write_and_wait_range(mapping, offset, endbyte);
>>>>  
>>>>                 /*
>>>>                  * First and last FULL page! Partial pages are deliberately
>>>>
>>>> by making the invalidation wait for the pages to go fully to the
>>>> clean state before starting.
>>>>
>>>> This, however, only fixes the specific symptom being tripped over
>>>> here.  To further test this, I removed this writeback from
>>>> POSIX_FADV_DONTNEED completely so I could trigger writeback via
>>>> controlled background writeback. And, as I expected, whenever
>>>> background writeback ran to write back these dirty files, the
>>>> verification failures triggered again. It is quite reliable.
>>>>
>>>> So it looks like there is some kind of writeback completion vs page
>>>> invalidation race condition occurring, but more work is needed to
>>>> isolate it further. I don't know what part the async read plays in
>>>> the corruption yet, because I don't know how we are getting pages in
>>>> the cache where page->index != the file offset stamped in the data.
>>>> That smells of leaking PageUptodate flags...
>>>
>>> The async read really isn't doing anything that you could not do with
>>> separate threads. Unfortunately it's not that easy to have multiple
>>> threads working on the same region with fio, or we could've reproduced
>>> it with a job file written to use that instead.
>>>
>>> I'll dig a bit here...
>>
>> Have we verified that the actual page cache is inconsistent, or is that
>> just an assumption? I'm asking since I poked a bit on the fio side, and
>> suspiciously the failed verification was a short IO. At least
>> originally, fio will retry those, but it could be a bug in the io_uring
>> engine for fio.
>>
>> I'll poke some more.
> 
> The on-disk state seems sane. I added a hack that clears the rest of the
> buffer to 0x5a when we get a short read. When the verify fails, the io_u
> that was attempted verified looks like this:
> 
> 0000fe0 116b b418 d14b 0477 822d 6dcd 201d 1316
> 0000ff0 3045 eca3 0d1c 1a4f e608 0571 6b52 015e
> 0001000 5a5a 5a5a 5a5a 5a5a 5a5a 5a5a 5a5a 5a5a
> *
> 0010000
> 
> where fio dumps this as the expected data:
> 
> 0000fe0 116b b418 d14b 0477 822d 6dcd 201d 1316
> 0000ff0 3045 eca3 0d1c 1a4f e608 0571 6b52 015e
> 0001000 3cc1 4daa cab1 12ba c798 0b54 b281 0a05
> 0001010 98f3 bd9e 30a5 1728 531e 6b3a 2745 1877
> 
> Fio says the offset is 62652416 in the file, and reading
> that 64k block from the file and dumping it:
> 
> 0000fe0 116b b418 d14b 0477 822d 6dcd 201d 1316
> 0000ff0 3045 eca3 0d1c 1a4f e608 0571 6b52 015e
> 0001000 3cc1 4daa cab1 12ba c798 0b54 b281 0a05
> 0001010 98f3 bd9e 30a5 1728 531e 6b3a 2745 1877
> 
> So it seems to me like the file state is consistent, at least after the
> run, and that this seems more likely to be a fio issue with short
> read handling.
> 
> Poking along...

I've pushed some fixes for fio for this, it now works fine for me. JFYI.

-- 
Jens Axboe

