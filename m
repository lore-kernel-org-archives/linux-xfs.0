Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f43.google.com ([209.85.221.43]:43656 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727375AbeJVQxF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Oct 2018 12:53:05 -0400
Received: by mail-wr1-f43.google.com with SMTP id t10-v6so2351692wrn.10
        for <linux-xfs@vger.kernel.org>; Mon, 22 Oct 2018 01:35:30 -0700 (PDT)
Subject: Re: ENSOPC on a 10% used disk
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
 <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
 <20181018100504.GH6311@dastard>
 <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
 <85530ca3-22ef-21e5-a4da-1f924a6e2d7e@scylladb.com>
 <20181019075109.GM6311@dastard>
 <da5448d6-2ea1-ac8b-e21c-ce1124d400a1@scylladb.com>
 <20181021142847.GO6311@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <0b69189c-033f-e7c1-3987-de67ea43d2ac@scylladb.com>
Date: Mon, 22 Oct 2018 11:35:26 +0300
MIME-Version: 1.0
In-Reply-To: <20181021142847.GO6311@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org


On 21/10/2018 17.28, Dave Chinner wrote:
> On Sun, Oct 21, 2018 at 11:55:47AM +0300, Avi Kivity wrote:
>> On 19/10/2018 10.51, Dave Chinner wrote:
>>> On Thu, Oct 18, 2018 at 04:36:42PM +0300, Avi Kivity wrote:
>>>> On 18/10/2018 14.00, Avi Kivity wrote:
>>>>>> Can I get access to the metadump to dig around in the filesystem
>>>>>> directly so I can see how everything has ended up laid out? that
>>>>>> will help me work out what is actually occurring and determine if
>>>>>> mkfs/mount options can address the problem or whether deeper
>>>>>> allocator algorithm changes may be necessary....
>>>>> I will ask permission to share the dump.
>>>> I'll send you a link privately.
>>> Thanks - I've started looking at this - the information here is
>>> just layout stuff - I'm omitted filenames and anything else that
>>> might be identifying from the output.
>>>
>>> Looking at a commit log file:
>>>
>>> stat.size = 33554432
>>> stat.blocks = 34720
>>> fsxattr.xflags = 0x800 [----------e-----]
>>> fsxattr.projid = 0
>>> fsxattr.extsize = 33554432
>>> fsxattr.cowextsize = 0
>>> fsxattr.nextents = 14
>>>
>>>
>>> and the layout:
>>>
>>> EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET            TOTAL FLAGS
>>>    0: [0..4079]:       2646677520..2646681599 22 (95606800..95610879)  4080 001010
>>>    1: [4080..8159]:    2643130384..2643134463 22 (92059664..92063743)  4080 001010
>>>    2: [8160..12239]:   2642124816..2642128895 22 (91054096..91058175)  4080 001010
>>>    3: [12240..16319]:  2640666640..2640670719 22 (89595920..89599999)  4080 001010
>>>    4: [16320..18367]:  2640523264..2640525311 22 (89452544..89454591)  2048 000000
>>>    5: [18368..20415]:  2640119808..2640121855 22 (89049088..89051135)  2048 000000
>>>    6: [20416..21287]:  2639874064..2639874935 22 (88803344..88804215)   872 001111
>>>    7: [21288..21295]:  2639874936..2639874943 22 (88804216..88804223)     8 011111
>>>    8: [21296..24495]:  2639874944..2639878143 22 (88804224..88807423)  3200 001010
>>>    9: [24496..26543]:  2639427584..2639429631 22 (88356864..88358911)  2048 000000
>>>   10: [26544..28591]:  2638981120..2638983167 22 (87910400..87912447)  2048 000000
>>>   11: [28592..30639]:  2638770176..2638772223 22 (87699456..87701503)  2048 000000
>>>   12: [30640..31279]:  2638247952..2638248591 22 (87177232..87177871)   640 001111
>>>   13: [31280..34719]:  2638248592..2638252031 22 (87177872..87181311)  3440 011010
>>>   14: [34720..65535]:  hole                                           30816
>>>
>>> The first thing I note is the initial allocations are just short of
>>> 2MB and so the extent size hint is, indeed, being truncated here
>>> according to contiguous free space limitations. I had thought that
>>> should occur from reading the code, but it's complex and I wasn't
>>> 100% certain what minimum allocation length would be used.
>>>
>>> Looking at the system batchlog files, I'm guessing the filesystem
>>> ran out of contiguous 32MB free space extents some time around
>>> September 25. The *Data.db files from 24 Sep and earlier then are
>>> all nice 32MB extents, from 25 sep onwards they never make the full
>>> 32MB (30-31MB max). eg, good:
>>>
>>>   EXT: FILE-OFFSET       BLOCK-RANGE          AG AG-OFFSET            TOTAL FLAGS
>>>     0: [0..65535]:       350524552..350590087  3 (2651272..2716807)   65536 001111
>>>     1: [65536..131071]:  353378024..353443559  3 (5504744..5570279)   65536 001111
>>>     2: [131072..196607]: 355147016..355212551  3 (7273736..7339271)   65536 001111
>>>     3: [196608..262143]: 360029416..360094951  3 (12156136..12221671) 65536 001111
>>>     4: [262144..327679]: 362244144..362309679  3 (14370864..14436399) 65536 001111
>>>     5: [327680..343415]: 365809456..365825191  3 (17936176..17951911) 15736 001111
>>>
>>> bad:
>>>
>>> EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET            TOTAL FLAGS
>>>    0: [0..64127]:       512855496..512919623  4 (49024456..49088583) 64128 001111
>>>    1: [64128..128247]:  266567048..266631167  2 (34651528..34715647) 64120 001010
>>>    2: [128248..142327]: 264401888..264415967  2 (32486368..32500447) 14080 001111
>>
>> So extent size is a hint but the extent alignment is a hard
>> requirement.
> No, physical alignment is being ignored here, too. THose flags on
> the end?
>
>   FLAG Values:
>      0100000 Shared extent
>      0010000 Unwritten preallocated extent
>      0001000 Doesn't begin on stripe unit
>      0000100 Doesn't end   on stripe unit
>      0000010 Doesn't begin on stripe width
>      0000001 Doesn't end   on stripe width
>
> When you have 001111, the allocation was completely unaligned.
> When you have 001010, the tail is stripe aligned
> When you ahve 000000, the head and tail are stripe aligned
>
> As you can see, there is a mix of aligned, tail aligned and
> completely unaligned extents.
>
> So, no, XFS is droping both size hints and alignment hints when
> it starts running out of aligned contiguous free space extents.


You are right; I searched for and found some files that where 
head-aligned, and jumped to conclusions, but there are many that are 
not. Those head-aligned files probably belonged to an era in that 
filesystem's life where head-aligned extents less than 1MB were available.


>>> Ok, so the results is not perfect, but there are now huge contiguous
>>> free space extents available again - ~70% of the free space is now
>>> contiguous extents >=32MB in length. There's every chance that the
>>> fs would confinue to help reform large contiguous free spaces as the
>>> database files come and go now, as long as the snapshot problem is
>>> dealt with.
>>>
>>> So, what's the problem? Well, it's simply that the workload is
>>> mixing data with vastly different temporal characteristics in the
>>> same physical locality. Every half an hour, a set of ~100 smallish
>>> files are written into a new directory which lands them at the low
>>> endof the largest free space extent in that AG. Each new snapshot
>>> directory ends up in a different AG, so it slowly spreads the
>>> snapshots across all the AGs in the filesystem.
>>
>> Not exactly - those snapshots are hard links into the live database
>> files, which eventually get removed. Usually, small files get
>> removed early, but with the snapshots they get to live forever.
> They might be created as hard links, but the effect when the
> orginal database file links are removed is the same - the snapshotted
> data lives forever, interleaved amongst short term data.


Yes.


>>> Each snapshot effective appends to the current working area in the
>>> AG, chopping it out of the largest contiguous free space. By the
>>> time the next snapshot in that AG comes around, there's other new
>>> short term data between the old snapshot and the new one. The new
>>> snapshot chops up the largest freespace, and on goes the cycle.
>>>
>>> Eventually the short term data between the snapshots gets removed,
>>> but this doesn't reform large contiguous free spaces because the
>>> snapshot data is in the way. And so this cycle continues with the
>>> snapshot data chopping up the largest freespace extents in the
>>> filesystem until there's not more large free space extents to be
>>> found.
>>>
>>> The solution is to manage the snapshot data better. We need to keep
>>> all the long term data physically isolated from the short term data
>>> so they don't fragment free space. A short term application level
>>> solution would require migrating the snapshot data out of the
>>> filesystem to somewhere else and point to it with symlinks.
>>
>> Snapshots should not live forever on the disk. The procedure is to
>> create a snapshot, copy it away, and then delete the snapshot. It's
>> okay to let snapshots live for a while, but not all of them and not
>> without a bound on their lifetime.
>>
>>
>> The filesystem did have a role in this, by requiring alignment of
>> the extent to the RAID stripe size.
> No, in the end it didn't.


Right.


>
>> Now, given that this was a RAID
>> with one member, alignment is pointless, but most of our deployments
>> are to RAID arrays with >1 members, and alignment does save 12.5% of
>> IOPS compared to un-aligned extents for compactions and writes (our
>> scans/writes use 128k buffers, and the alignment is to 1MB). The
>> database caused the problem by indirectly requiring 1MB alignment
>> for files that are much smaller than 1MB, and the user contributed
>> to the problem by causing millions of such small files to be kept.
> *nod*
>
>>> <ding>
>>>
>>> Hold on....
>>>
>>> <rummage in code>
>>>
>>> ....we already have an interface so setting those sorts of hints.
>>>
>>> fcntl(F_SET_RW_HINT, rw_hint)
>>>
>>> /*
>>>   * Valid hint values for F_{GET,SET}_RW_HINT. 0 is "not set", or can be
>>>   * used to clear any hints previously set.
>>>   */
>>> #define RWF_WRITE_LIFE_NOT_SET  0
>>> #define RWH_WRITE_LIFE_NONE     1
>>> #define RWH_WRITE_LIFE_SHORT    2
>>> #define RWH_WRITE_LIFE_MEDIUM   3
>>> #define RWH_WRITE_LIFE_LONG     4
>>> #define RWH_WRITE_LIFE_EXTREME  5
>>>
>>> Avi, does this sound like something that you could use to
>>> classify the different types of data the data base writes out?
>>
>> So long as the penalty for a mis-classification is not too large, we
>> can for sure.
> OK.
>
>>> I'll need to have a think about how to apply this to the allocator
>>> policy algorithms before going any further, but I suspect making use
>>> of this hint interface will allow us prevent interleaving of short
>>> and long term data so avoid the freespace fragmentation it is
>>> causing here....
>>
>> IIUC, the problem (of having ENOSPC on a 10% used disk) is not
>> fragmentation per se, it's the alignment requirement.
> Which, as I've noted above, alignment is a hint, not a requirement.
>
>> To take it to
>> extreme, a 1TB disk can only hold a million files if those files
>> must be aligned to 1MB, even if everything is perfectly laid out.
>> For sure fragmentation would have degraded performance sooner or
>> later, but that's not as bad as that ENOSPC.
> What it comes down to is that having looked into it, I don't know
> why that ENOSPC error occurred.
>
> Alignment didn't cause it because alignment was being dropped - that
> just caused free space fragmentation.  Extent size hints didn't
> cause it because the size hints were dropped - that just caused
> freespace fragmentation. A lack of free space
> didn't cause it, because there was heaps of free space in all
> allocation groups.
>
> But something tickled a corner case that triggered an allocation
> failure that was interpretted as ENOSPC rather than retrying the
> allocation.  Until I can reproduce the ENOSPC allocation failure
> (and I tried!) then it'll be a mystery as to what caused it.


The user reported the error happening multiple times, taking many hours 
to reproduce, but on more than one node. So it's an obscure corner case 
but not obscure enough to be a one-off event.


I've asked the user to regularly trim their snapshots (they we're not 
aware of the snapshots actually - they were performed as a side effect 
of a TRUNCATE operation), and we'll remove the default extent hint for 
small files. I'll also consider noalign - the 12.5% reduction in IOPS is 
perhaps not worth the fragmentation it generates.


>
>> entire file. But I think that, given that the extent size is treated
>> as a hint (or so I infer from the fact that we have <32MB extents),
>> so should the alignment. Perhaps allocation with a hint should be
>> performed in two passes, first trying to match size and alignment,
>> and second relaxing both restrictions.
> I think I already mentioned there were 5 separate attmepts to
> allocate, each failure reducing restrictions:
>
> 1. extent sized and contiguous to adjacent block in file
> 2. extent sized and aligned, at higher block in AG
> 3. extent sized, not aligned, at higher block in AG
> 4. >= minimum length, not aligned, anywhere in AG >= target AG


Surprised at this one. Won't it skew usage in high AGs?


Perhaps it's rare enough not to matter.


Perhaps those higher-block/higher-AG heuristics can be improved for 
non-rotational media.


> 5. minimum length, not aligned, in any AG


Thanks for your patience in helping me understand this issue.


Avi


> Cheers,
>
> Dave.
