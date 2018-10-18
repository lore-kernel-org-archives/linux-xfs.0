Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f51.google.com ([209.85.128.51]:55566 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbeJRXqf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 19:46:35 -0400
Received: by mail-wm1-f51.google.com with SMTP id 206-v6so744356wmb.5
        for <linux-xfs@vger.kernel.org>; Thu, 18 Oct 2018 08:44:58 -0700 (PDT)
Subject: Re: ENSOPC on a 10% used disk
From: Avi Kivity <avi@scylladb.com>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
 <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
 <20181018100504.GH6311@dastard>
 <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
Message-ID: <5516031c-6c4f-072f-e9f9-9f0ecee9927d@scylladb.com>
Date: Thu, 18 Oct 2018 18:44:54 +0300
MIME-Version: 1.0
In-Reply-To: <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org


On 18/10/2018 14.00, Avi Kivity wrote:
>
>
> This can happen, and indeed I see our default hint is 1MB, so our 
> small files use a 1MB hint. Looks like we should remove that 1MB hint 
> since it's reducing allocation flexibility for XFS without a good return.


I convinced myself that this is the root cause, it fits perfectly with 
your explanation. I still think that XFS should allocate *something* 
rather than ENOSPC, but I can also understand someone wanting a guarantee.


> On the other hand, I worry that because we bypass the page cache, XFS 
> doesn't get to see the entire file at one time and so it will get 
> fragmented.


That's what happens. I write 1000 4k writes to 400 files, in parallel, 
AIO+DIO. I got 400 perfectly-fragmented files, each had 1000 extents.


So I'll remove the default hint for small files, and replace it with 
larger buffer sizes so we batch more and don't get 8k-sized extents 
(which is our default buffer size).


>
>
> Suppose I write a 4k file with a 1MB hint. How is that trailing 
> (1MB-4k) marked? Free extent, free extent with extra annotation, or 
> allocated extent? We may need to deallocate those extents? (will 
> FALLOC_FL_PUNCH_HOLE do the trick?)
>

I found an 11-year-old post from you that says those reservations are 
freed on close:


https://linux-xfs.oss.sgi.narkive.com/Bpctu4DN/reducing-memory-requirements-for-high-extent-xfs-files#post6


This is consistent with xfs_db reporting those areas are free.
