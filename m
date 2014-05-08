Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2251B7F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 08:04:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A45A7AC003
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 06:04:35 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id U5FXAbQgO2tiniKM
	for <xfs@oss.sgi.com>; Thu, 08 May 2014 06:04:31 -0700 (PDT)
Message-ID: <536B80E0.9000406@hardwarefreak.com>
Date: Thu, 08 May 2014 08:04:32 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Alignment: XFS + LVM2
References: <CAPrERe02bfrW6+5c+oZPgd9c_7AUx=BEUcAOAj2dT_iYn=P_1w@mail.gmail.com>	<536AEBB9.3020807@hardwarefreak.com>
	<CAPrERe3v_1mPy6ABAKj4TxTmy1FB2=ipi6Vn3N6dZ7w8B9DeZA@mail.gmail.com>
In-Reply-To: <CAPrERe3v_1mPy6ABAKj4TxTmy1FB2=ipi6Vn3N6dZ7w8B9DeZA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Marc Caubet <mcaubet@pic.es>
Cc: xfs@oss.sgi.com

On 5/8/2014 4:12 AM, Marc Caubet wrote:
> Hi Stan,
> 
> thanks for your answer.
> 
> Everything begins and ends with the workload.
>>
>> On 5/7/2014 7:43 AM, Marc Caubet wrote:
>>> Hi all,
>>>
>>> I am trying to setup a storage pool with correct disk alignment and I
>> hope
>>> somebody can help me to understand some unclear parts to me when
>>> configuring XFS over LVM2.
>>
>> I'll try.  But to be honest, after my first read of your post, a few
>> things jump out as breaking traditional rules.
>>
>> The first thing you need to consider is your workload and the type of
>> read/write patterns it will generate.  This document is unfinished, and
>> unformatted, but reading what is there should be informative:
>>
>> http://www.hardwarefreak.com/xfs/storage-arch.txt
>>
> 
> Basically we are moving a lot of data :) It means, parallel large files
> (GBs) are being written and read all the time. Basically we have a batch
> farm with 3,5k cores processing jobs that are constantly reading and
> writing to the storage pools (4PBs). Only few pools (~5% of the total)
> contain small files (and only small files).

And these pools are tied together with?  Gluster?  Ceph?

>>> Actually we have few storage pools with the following settings each:
>>>
>>> - LSI Controller with 3xRAID6
>>> - Each RAID6 is configured with 10 data disks + 2 for double-parity.
>>> - Each disk has a capacity of 4TB, 512e and physical sector size of 4K.
>>
>> 512e drives may cause data loss.  See:
>> http://docs.oracle.com/cd/E26502_01/html/E28978/gmkgj.html#gmlfz
>>
> 
> Haven't experienced this yet. But good to know thanks :)  On the other
> hand, we do not use zfs

This problem affects all filesystems.  If the drive loses power during
an RMW cycle the physical sector is corrupted.  As noted, not all 512e
drives may have this problem.  And for the bulk of your workload this
shouldn't be an issue.  If you have sufficient and properly functioning
UPS it shouldn't be an issue either.

>>> - 3x(10+2) configuration was considered in order to gain best performance
>>> and data safety (less disks per RAID less probability of data corruption)
>>
>> RAID6 is the worst performer of all the RAID levels but gives the best
>> resilience to multiple drive failure.  The reason for using fewer drives
>> per array has less to do with probability of corruption, but
>>
>> 1. Limiting RMW operations to as few drives as possible, especially for
>> controllers that do full stripe scrubbing on RMW
>>
>> 2.  Lowering bandwidth and time required to rebuild a dead drive, fewer
>> drives tied up during a rebuild
>>
> 
>>> From the O.S. side we see:
>>>
>>> [root@stgpool01 ~]# fdisk -l /dev/sda /dev/sdb /dev/sdc
>> ...
>>
>> You omitted crucial information.  What is the stripe unit size of each
>> RAID6?
>>
> 
> Actually the stripe size for each RAID6 is 256KB but we plan to increase
> some pools to 1MB for all their RAIDs. It will be in order to compare
> performance for pools containing large files and if this improves, we will
> apply it to the other systems in the future.

So currently you have a 2.5MB stripe width per RAID6 and you plan to
test with a 10MB stripe width.

>>> The idea is to aggregate the above devices and show only 1 storage space.
>>> We did as follows:
>>>
>>> vgcreate dcvg_a /dev/sda /dev/sdb /dev/sdc
>>> lvcreate -i 3 -I 4096 -n dcpool -l 100%FREE -v dcvg_a
>>
>> You've told LVM that its stripe unit is 4MB, and thus the stripe width
>> of each RAID6 is 4MB.  This is not possible with 10 data spindles.
>> Again, show the RAID geometry from the LSI tools.
>>
> When creating a nested stripe, the stripe unit of the outer stripe (LVM)
>> must equal the stripe width of eachinner stripe (RAID6).
>>
> 
> Great. Hence, if the RAID6 stripe size is 256k then the LVM should be
> defined with 256k as well, isn't it?

No.  And according to lvcreate(8) you cannot use LVM for the outer
stripe because you have 10 data spindles per RAID6.  "StripeSize" is
limited to power of 2 values.  Your RAID6 stripe width is 2560 KB which
is not a power of 2 value.  So you must use md.  See mdadm(8).

And be careful with terminology.  "Stripe unit" is per disk, called
"chunk" by mdadm.  "Stripe width" is per array.  "Stripe size" is ambiguous.

When nesting stripes, the "stripe width" of the RAID6 becomes the
"stripe unit" of the outer stripe of the resulting RAID60.  In essence,
each RAID6 is treated as a "drive" in the outer stripe.  For example:

RAID6  stripe unit  =  256 KB
RAID6  stripe width = 2560 KB
RAID60 stripe unit  = 2560 KB
RAID60 stripe width = 7680 KB

For RAID6 w/1MB stripe unit

RAID6  stripe unit  =  1 MB
RAID6  stripe width = 10 MB
RAID60 stripe unit  = 10 MB
RAID60 stripe width = 30 MB

This is assuming your stated configuration of 12 drives per RAID6, 10
data spindles, and 3 RAID6 arrays per nested stripe.

>> Hence, stripe of the 3 RAID6 in a LV.
>>
>> Each RAID6 has ~1.3GB/s of throughput.  By striping the 3 arrays into a
>> nested RAID60 this suggests you need single file throughput greater than
>> 1.3GB/s and that all files are very large.  If not, you'd be better off
>> using a concatenation, and using md to accomplish that instead of LVM.
>>
>>> And here is my first question: How can I check if the storage and the LV
>>> are correctly aligned?
>>
>> Answer is above.  But the more important question is whether your
>> workload wants a stripe or a concatenation.
>>
>>> On the other hand, I have formatted XFS as follows:
>>>
>>> mkfs.xfs -d su=256k,sw=10 -l size=128m,lazy-count=1 /dev/dcvg_a/dcpool

lazy-count=1 is the default.  No need to specify it.

>> This alignment is not correct.  XFS must be aligned to the LVM stripe
>> geometry.  Here you apparently aligned XFS to the RAID6 geometry
>> instead.  Why are you manually specifying a 128M log?  If you knew your
>> workload that well, you would not have made these other mistakes.
>>
> 
> We receive several parallel writes all the time, and afaik filesystems with
> such write load benenfit from a larger log. 128M is the maximum log size.

Metadata is journaled, file data is not.  Filesystems experiencing a
large amount of metadata modification may benefit from a larger journal
log, however writing many large files in parallel typically doesn't
generate much metadata modification.  In addition, with delayed logging
now the default, the amount of data written to the journal is much less
than it used to be.  So specifying a log size should not be necessary
with your workload.

> So how XFS should be formatted then? As you specify, should be aligned with
> the LVM stripe, as we have a LV with 3 stripes then 256k*3 and sw=30?

It must be aligned to the outer stripe in the nest, which would be the
LVM geometry if it could work.  However, as stated, it appears you
cannot use lvcreate to make the outer stripe because it does not allow a
2560 KiB StripeSize.  Destroy the LVM volume and create an md RAID0
device of the 3 RAID6 devices, eg:

$ mdadm -C /dev/md0 --raid_devices=3 --chunk=2560 --level=0 /dev/sd[abc]

For making the filesystem and aligning it to the md nested stripe
RAID60, this is all that is required:

$ mkfs.xfs -d su=2560k,sw=3 /dev/md0


Cheers,

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
