Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:52126 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbdKHVuf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 16:50:35 -0500
Message-ID: <5A03754E.5070903@tlinx.org>
Date: Wed, 08 Nov 2017 13:21:18 -0800
From: L A Walsh <lkml@tlinx.org>
MIME-Version: 1.0
Subject: Re: Bug? or normal behavior? if bug, then where? overlay, vfs, xfs,
 or ????
References: <59FA4499.2030502@tlinx.org> <CAOQ4uxg-bkYnpV146kBgdbgCK9On+=jM1gCe1975J8HKkWxcNg@mail.gmail.com> <59FEC912.4000005@tlinx.org> <CAOQ4uxjDbNiZiUUzNZEHTt8SQW-1trC6dSF=c28bD8EuWLWFrw@mail.gmail.com> <20171105223445.GA5858@dastard>
In-Reply-To: <20171105223445.GA5858@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

Dave Chinner wrote:
> Are you still getting all worked up about how metadata CRCs and
> the v5 on-disk format is going to make the sky fall, Linda? It's
> time to give in and come join us on the dark side...
>   
---
    I don't believe I've heard that the sky would fall.  I only had
2 issues -- 1 that metadata that I that I didn't care about or that I
wanted to change would be crc'd and prevent changing meta data I wanted
to change or would flag errors in meta data I didn't care about
(file last access time being a nanosecond or a day off due to bit rot
and crc flagging it as an error.

    Maybe you might remember, I first ran into this when,  as part of
my mkfs procedure, I assigned my own value to my disk's UUID, and at the
time, the crc-feature claimed the disk had a fault in it. 

    My second issue was it being tied to the finobt feature in a way that
precluded benchmarking changes on our own filesystems and workload.


>   
>> I don't know if there was a specific reason, but that's the way it is.
>>     
>
> ftype was implemented as part of the format changes for the v5
> format so it's always enabled for v5 filesystems.  It was introduced
> as a mkfs option for the v4 format in early 2014, and since mid-2015
> it's been the default for non-crc filesystems:
>
> # mkfs.xfs -f -m crc=0 /dev/vdb
> .....
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> .....
>
> Users should try to keep your userspace tools up to date with the
> kernel being run.... :)
>   
----
    And tools space writers should remember that those who run some
distro may have tools from 2+ years old and have even been told that
we are running unsupported configurations if we update system tools
(not that this always stops some people).


   I forget -- what switch do I pass to xfs utils to have them tell
me what features are supported (v4 or v5, for example)?

    I do see ftype=0|1 under naming and that it has nothing to do
with crc of data as well as crc and finobt under metadata.

    The problem I had was following the kernel docs for the overlayfs
and not seeing where ftype=1 was required when making an xfs file system.

    It seems like my mkfs supports ftype, but it isn't the default and
I didn't know I was supposed to turn it on.

>   
>> I have never heard about those issues that you raise.
>> It sounds like a myth about XFS metadata CRC that should be debunked
>> so forwarding your message on to XFS list.
>>     
>
> FYI, Amir.
>
> Keep in mind that a lot of people didn't like the concept of
> metadata CRCs in XFS because .... reasons.  
---
    See above for for my reasons.


> As to the issue that Linda raised, yes, it *did* exist.  We baked
> the UUID into the metadata format so we knew what filesystem owns a
> specific metadata block. Handy for detecting stale metadata on a
> reused device as well as misdirected writes.  We knew about it from
> the start (all the tools had to be modified to disallow changing
> UUIDS on v5 filesystems!) but it just wasn't an important enough
> requirement to have this functionality up front for CRC enabled
> filesystems.
>   
====
    And you have confirmed 1 of my 2 reasons for disliking the crc
feature -- it sounds like you can no longer set the UUID field on a
new file systems. 

    Please don't tell people that they sky is falling when you have broken
the ability to change UUID's as was present in the past.  That was a valid
feature -- that I was told would be excluded from crc'ing, but now find
that it can't be done without damaging ability for old systems to read
such file systems.
   
>
> Yeah, that was in reaction to the loud claims that "CRCs are going
> to slow everything down". Late last year we significantly reduced
> the CPU overhead of CRC calculation on the write side , so it drops
> off the CPU profiles in the workloads described in that like above
> almost entirely. This was the commit:
>   
----
    That article had nothing to do w/my concern and predated my involvement.
My concern was tying the finobt feature to the crc feature so they could
not be tested in isolation to allow seeing what the impact of crc's 
might be,
but more importantly, seeing if finobt had any positive impact on
more mature file systems without including  the crc feature.

     Your stance seems to be that the the crc feature combined with the
finobt feature don't show a measurable slowdown on newly created file 
systems.

    I would expect that, especially since finobt would benefit more mature
file systems more than newer ones.  While on newer file systems, finobt+crc
comes out to about the same performance.  

    My issue was the inability to bench or use them separately.

    No sky falling, just standard benchmark methodology to test changes
on your own workload.

    But as to the ftype flag -- that was me using v4 tools and seeing
no information that I needed to explicitly specify it to make the overlay
file system work with xfs, which I don't think has
anything to do with crc's.  Right?

-linda




