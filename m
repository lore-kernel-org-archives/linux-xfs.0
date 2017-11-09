Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:45560 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752887AbdKIHvT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 02:51:19 -0500
Message-ID: <5A0408E9.5010501@tlinx.org>
Date: Wed, 08 Nov 2017 23:51:05 -0800
From: L A Walsh <lkml@tlinx.org>
MIME-Version: 1.0
Subject: Re: Bug? or normal behavior? if bug, then where? overlay, vfs, xfs,
 or ????
References: <59FA4499.2030502@tlinx.org> <CAOQ4uxg-bkYnpV146kBgdbgCK9On+=jM1gCe1975J8HKkWxcNg@mail.gmail.com> <59FEC912.4000005@tlinx.org> <CAOQ4uxjDbNiZiUUzNZEHTt8SQW-1trC6dSF=c28bD8EuWLWFrw@mail.gmail.com> <20171105223445.GA5858@dastard> <5A03754E.5070903@tlinx.org> <20171109014726.GI4094@dastard>
In-Reply-To: <20171109014726.GI4094@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

Dave Chinner wrote:
>
>
> Changing the UUID on v5 filesystems is now implemented and
> supported:
>   
---
    And it won't have a problem if seen by a previous gen
tool -- like xfsrestore on an older "emergency boot disk"?

    If not, then I misunderstood what you wrote earlier.
>>    My issue was the inability to bench or use them separately.
>>     
>
> <sigh>
>
> Not an XFS problem:
>
> $ mkfs.xfs -f -m finobt=0 /dev/pmem0
> ....
>          =                       crc=1        finobt=0, sparse=0, rmapbt=0, reflink=0
> .....
>
> Yup, crc's enabled, finobt is not. As documented in the mkfs.xfs manpage.
>   

So you are saying I can set finobt to 0 or 1 with crc=0?

Because testing sigh crc=1 and finobt=0|1 isn't
the same as testing crc=0 and finobt=0|1.

I'm more interested in testing finobt's affect by itself and have
a secondary interest in the effect of the crc option because I would
like to use the finobt option (thus desire to test it first), but
do not currently want to use the crc otpion, thus it being of secondary
interest.

Again, if I can test finobt 0 or 1 with no requirements I turn on
crc, then I was mistaken in my earlier understanding.

So I still have 2 issues: UUID labels that don't preclude using older
emergency boot disks, to restore a file system, and the ability to
test finobt apart from other features.




> ge.
>
> IOWs, We can directly measure the impact of the finobt on
> workloads/benchamrks. And if we want to compare the impact of CRCs,
> then 'mkfs.xfs -f -isize=512, -m crc=0 <dev>' will be directly
> comparable to the above non-finobt filesystem. THis is how we
> benchmarked the changes in the first place....
>   
----
  

    That methodology is flawed.

    If the crc option is on during finobt being tested as 0 or 1,
the crc option on means different disk caching -- if the crc
option pulls in some or all of the finobt info, then you can't measure
the finobt option with the crc option turned on. Even if you turn the crc
feature off, if the disk has crc features, those also change how
information is read in.

    Only if you create a disk with no crc info on it, and then can test
finobt=0|1, can you see the relative performance of the finobt cases. 

    If it is the case that finobt can be toggled on a disk with no
crc data or option in use, then I've misunderstood previously read
constraints (or they've changed).

-l

