Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:49846 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755253AbcKBClI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2016 22:41:08 -0400
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id uA22TrGc026864
        for <linux-xfs@vger.kernel.org>; Tue, 1 Nov 2016 19:29:55 -0700
Message-ID: <58194CF8.1000501@tlinx.org>
Date: Tue, 01 Nov 2016 19:18:32 -0700
From: "L.A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: [rfe]: finobt option separable from crc option? (was [rfc] larger
 batches for crc32c)
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com> <20161027214244.GO14023@dastard> <20161028131234.24a5cb6f@roar.ozlabs.ibm.com> <20161028160218.1af40906@roar.ozlabs.ibm.com> <20161031030853.GK22126@dastard> <20161101143918.4f154154@roar.ozlabs.ibm.com> <20161101054725.GZ14023@dastard>
In-Reply-To: <20161101054725.GZ14023@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Snipping in various places:

Dave Chinner wrote:
> directory operations:
> 	lookups = 79418,  creates = 460612
> 	removes = 460544, getdents = 5685160
>
> SO, we have 80k directory lookups to instantiate an inode, but 460k
> creates and removes, and 5.6M readdir calls. That's a lot of readdir
> calls....
>   
>> trans 0 3491960 0
>>     
> 3.5 million asynchronous transaction commits. That's a lot, so far I
> can account for about 1.5M of them (creates, removes and a handful
> of data extents). Oh, a couple of million data writes - I bet the
> rest are timestamp/i_version updates.
>   
> [...]
> log force sleeps = 143932               (fsync waits!)
> ...
> Identifying what that is will give you some idea
> of how to reduce the fsync load and hence potentially decrease the
> log and CRC overhead that it is causing....
>   
----
    Back when the free-inode performance enhancement was introduced,
it was required that crc'ing of metadata also be enabled.  Have
these options been separated yet?  If so, save yourself some reading
and just get the "thanks!", and ignore the rest of this, but if
not... please read on, and please re-consider...

    I asked for a separation of these options on the basis that
crc'ing of the file system was not something I wanted on my files due
to performance and data security and recovery considerations.  I was
told that the crc'ing of the data wouldn't be noticeable (something I
was skeptical of), and that allowing the options separately wouldn't
be offered). 

    My inner-cynic thought that this was because many, if not most
users wouldn't need the crc and it would only be another source of
problems -- one that would disable data-access if the crc counts
couldn't be verified. 

    I really, still, don't want the crc's on my disks, I don't see
that they would provide any positive benefit in my usage -- nor in
many uses of xfs -- which ISN'T to say I can't see the need and/or
desire to have them for many classes of xfs users -- just not one
that I belong to at this point.  I was more worried about performance
than anything else (always trying to eek the most out of fixed budget!).

    I see the speedup from the free-inode tree in saving the
time during the real-time-search for free space, but only saw the crc
calculations as time-wasting overhead for the customer not needing
such integrity guarantees. 

    Is the free-space inode feature anything more than something to
offset the speed lost by crc calculations?  Wouldn't xfs be more
flexible if it could be tuned for performance OR integrity (or
a mix of both, using both).   Even if someone only wants to support
the combination in some official release, allowing selection
of those options to be separate would allow better testing
as well as isolation of features for specific workloads, testing
and/or benchmarks.

L. Walsh


