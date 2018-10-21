Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f51.google.com ([209.85.221.51]:45951 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbeJURfS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Oct 2018 13:35:18 -0400
Received: by mail-wr1-f51.google.com with SMTP id f17-v6so9903073wrs.12
        for <linux-xfs@vger.kernel.org>; Sun, 21 Oct 2018 02:21:37 -0700 (PDT)
Subject: Re: ENSOPC on a 10% used disk
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
 <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
 <20181018100504.GH6311@dastard>
 <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
 <20181019011526.GJ6311@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <9f5b5009-8b6c-65a9-8e18-6620557f5abc@scylladb.com>
Date: Sun, 21 Oct 2018 12:21:33 +0300
MIME-Version: 1.0
In-Reply-To: <20181019011526.GJ6311@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org


On 19/10/2018 04.15, Dave Chinner wrote:
> On Thu, Oct 18, 2018 at 02:00:19PM +0300, Avi Kivity wrote:
>> On 18/10/2018 13.05, Dave Chinner wrote:
>>> On Thu, Oct 18, 2018 at 10:55:18AM +0300, Avi Kivity wrote:
>>>> On 18/10/2018 04.37, Dave Chinner wrote:
>>>>> On Wed, Oct 17, 2018 at 10:52:48AM +0300, Avi Kivity wrote:
>>>>>> I have a user running a 1.7TB filesystem with ~10% usage (as shown
>>>>>> by df), getting sporadic ENOSPC errors. The disk is mounted with
>>>>>> inode64 and has a relatively small number of large files. The disk
>>>>>> is a single-member RAID0 array, with 1MB chunk size. There are 32
>>> Ok, now I need to know what "single member RAID0 array" means,
>>> becuase this is clearly related to allocation alignment and I need
>>> to know why the FS was configured the way it was.
>>
>> It's a Linux RAID device, /dev/md0.
>>
>>
>> We configure it this way so that it's easy to add storage (okay, the
>> real reason is probably to avoid special casing one drive).
> As a stripe? That requires resilvering to expand, which is a slow,
> messy operation. There's also been too many horror stories about
> crashes during rsilvering causing unrecoverable corruptions for my
> liking...


Like I said, the real reason is to avoid a special case for one disk. I 
don't think we, or one of our users, ever expanded a RAID array in this way.


>
>> One disk, organized into a Linux RAID device with just one member.
> So there's no realy need for IO alignment at all. Unaligned writes
> to RAID0 don't require RMW cycles, so alignment is really onl used
> to avoid hotspotting a disk in the stripe. Which isn't an issue
> here, either.


It does help (for >1 member arrays) in avoiding a logically aligned read 
or write to be split into two ops targeting two disks.


>>>> meta-data=/dev/loop2		isize=512 agcount=32, agsize=14494720 blks
>>>>           =                    sectsz=512 attr=2, projid32bit=1
>>>>           =                    crc=1 finobt=0 spinodes=0 rmapbt=0
>>>>           =                    reflink=0
>>>> data     =                    bsize=4096 blocks=463831040, imaxpct=5
>>>>           =                    sunit=256 swidth=256 blks
>>> sunit=swidth is unusual for a RAID0 array, unless it's hardware RAID
>>> and the array only reports one number to mkfs. What this chosen by
>>> mkfs, or specifically configured by the user? If specifically
>>> configured, why?
>>
>> I'm guessing it's because it has one member? I'm guessing the usual
>> is swidth=sunit*nmembers?
> *nod*. Which is unusual for a RAID0 device.
>
>>> What is important is that it means aligned allocations will be used
>>> for any allocation that is over sunit (1MB) and that's where all the
>>> problems seem to come from.
>> Do these aligned allocations not fall back to non-aligned
>> allocations if they fail?
> They do, but extent size hints change the fallback behaviour...
>
>>> See how we lost a large aligned 2MB freespace @ 9 when the small
>>> file "nn" was laid down? repeat this fill and free pattern over and
>>> over again, and eventually it fragments the free space until there's
>>> no large contiguous free spaces left, and large aligned extents can
>>> no longer be allocated.
>>>
>>> For this to trigger you need the small files to be larger than 1
>>> stripe unit, but still much smaller than the extent size hint, and
>>> the small files need to hang around as the large files come and go.
>>
>> This can happen, and indeed I see our default hint is 1MB, so our
>> small files use a 1MB hint.
> Ok, which forces all allocations to be at least stripe unit (1MB)
> aligned.


If the hint were smaller than the stripe unit, would it remove the 
alignment requirement? I see you answered below.




>> Looks like we should remove that 1MB
>> hint since it's reducing allocation flexibility for XFS without a
>> good return. On the other hand, I worry that because we bypass the
>> page cache, XFS doesn't get to see the entire file at one time and
>> so it will get fragmented.
> Yes. Your other option is to use an extent size hint that is smaller
> than the sunit. That should not align to 1MB because the initial
> data allocation size is not large enough to trigger stripe
> alignment.


Wow, so we had so many  factors leading to this:

- 1-disk installations arranged as RAID0 even though not strictly needed

- having a default extent allocation hint, even for small files

- having that default hint be >= the stripe unit size

- the user not removing snapshots

- XFS not falling back to unaligned allocations


>> Suppose I write a 4k file with a 1MB hint. How is that trailing
>> (1MB-4k) marked? Free extent, free extent with extra annotation, or
>> allocated extent? We may need to deallocate those extents? (will
>> FALLOC_FL_PUNCH_HOLE do the trick?)
> It's an unwritten extent beyond EOF, and how that is treated when
> the file is last closed depends on how that extent was allocated.
> But, yes, punching the range beyond EOF will definitely free it.


I think we can conclude from the dump that the filesystem freed it?


>>>>>> Is this a known issue?
>>> The effect and symptom is - it's a generic large aligned extent vs small unaligned extent
>>> issue, but I've never seen it manifest in a user workload outside of
>>> a very constrained multistream realtime video ingest/playout
>>> workload (i.e. the workload the filestreams allocator was written
>>> for). And before you ask, no, the filestreams allocator does not
>>> solve this problem.
>>>
>>> The most common manifestation of this problem has been inode
>>> allocation on filesystems full of small files - inodes are allocated
>>> in large aligned extents compared to small files, and so eventually
>>> the filesystem runs out of large contigouous freespace and inodes
>>> can't be allocated. The sparse inodes mkfs option fixed this by
>>> allowing inodes to be allocated as sparse chunks so they could
>>> interleave into any free space available....
>> Shouldn't XFS fall back to a non-aligned allocation rather that
>> returning ENOSPC on a filesystem with 90% free space?
> The filesystem does fall back to unaligned allocation - there's ~5
> spearate, progressively less strict allocation attempts on failure.
>
> The problem is that the extent size hint is asking to allocate a
> contiguous 32MB extent and there's no contiguous 32MB free space
> extent available, aligned or not.  That's what I think is generating
> the ENOSPC error, but it's not clear to me from the code whether it
> is supposed to ignore the extent size hint on failure and allocate a
> set of shorter unaligned extents or not....


Here's a file from the dump:


  ext:     logical_offset:        physical_offset: length: expected: flags:
    0:        0..    1eb2:    3928e00..   392acb2:   1eb3:
    1:     1eb3..    3cb2:    3c91200..   3c92fff:   1e00: 392acb3:
    2:     3cb3..    57b2:    3454100..   3455bff:   1b00: 3c93000:
    3:     57b3..    6fb2:    34ecd00..   34ee4ff:   1800: 3455c00:
    4:     6fb3..    85fe:    3386a00..   338804b:   164c: 34ee500:
    5:     85ff..    9c0b:    2c85c00..   2c8720c:   160d: 338804c:
    6:     9c0c..    b217:    3099900..   309af0b:   160c: 2c8720d:
    7:     b218..    c823:    34fb300..   34fc90b:   160c: 309af0c:
    8:     c824..    de2b:    315ef00..   3160507:   1608: 34fc90c:
    9:     de2c..    f42f:    36adc00..   36af203:   1604: 3160508:
   10:     f430..   10a30:    2cf4400..   2cf5a00:   1601: 36af204:
   11:    10a31..   12030:    2e03300..   2e048ff:   1600: 2cf5a01:
   12:    12031..   13630:    2ff5200..   2ff67ff:   1600: 2e04900:
   13:    13631..   14c30:    3199e00..   319b3ff:   1600: 2ff6800:
   14:    14c31..   16230:    32ed500..   32eeaff:   1600: 319b400:
   15:    16231..   17830:    34a0b00..   34a20ff:   1600: 32eeb00:
   16:    17831..   18e30:    354e700..   354fcff:   1600: 34a2100:
   17:    18e31..   1a430:    362c400..   362d9ff:   1600: 354fd00:
   18:    1a431..   1ba1d:    3192b00..   31940ec:   15ed: 362da00:
   19:    1ba1e..   1d05c:    4228500..   4229b3e:   163f: 31940ed:
   20:    1d05d..   1e692:    3f6c900..   3f6df35:   1636: 4229b3f:
   21:    1e693..   1fcc0:    37d4400..   37d5a2d:   162e: 3f6df36:
   22:    1fcc1..   212e4:    43f9c00..   43fb223:   1624: 37d5a2e:
   23:    212e5..   22905:    4003500..   4004b20:   1621: 43fb224:
   24:    22906..   23803:    1fdb900..   1fdc7fd:    efe: 4004b21: last,eof


So, lengths are not always aligned, but physical_offset always is. So 
XFS relaxes the extent size hint but not alignment.


It looks like XFS allocates one extent and moves on, not trying to 
allocate all the way to the 32MB hint size. If that were the case, we'd 
see logical_offset restore alignment every 32MB.
