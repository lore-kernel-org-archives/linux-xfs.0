Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q37EvgJ3015933 for <xfs@oss.sgi.com>; Sat, 7 Apr 2012 09:57:42 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id BAiyfzhngiEXFSz9
	for <xfs@oss.sgi.com>; Sat, 07 Apr 2012 07:57:41 -0700 (PDT)
Message-ID: <4F8055E4.1000808@hardwarefreak.com>
Date: Sat, 07 Apr 2012 09:57:40 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<4F7F7C25.8040605@hardwarefreak.com>
	<CAAxjCEyJW1b4dbKctbrgdWjykQt8Hb4Sw1RKdys3oUsehNHCcQ@mail.gmail.com>
In-Reply-To: <CAAxjCEyJW1b4dbKctbrgdWjykQt8Hb4Sw1RKdys3oUsehNHCcQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On 4/7/2012 2:27 AM, Stefan Ring wrote:
>> Instead, a far more optimal solution would be to set aside 4 spares per
>> chassis and create 14 four drive RADI10 arrays.  This would yield ~600
>> seeks/sec and ~400MB/s sequential throughput performance per 2 spindle
>> array.  We'd stitch the resulting 56 hardware RAID10 arrays together in
>> an mdraid linear (concatenated) array.  Then we'd format this 112
>> effective spindle linear array with simply:
>>
>> $ mkfs.xfs -d agcount=3D56 /dev/md0
>>
>> Since each RAID10 is 900GB capacity, we have 56 AGs of just under the
>> 1TB limit, 1 AG per 2 physical spindles.  Due to the 2 stripe spindle
>> nature of the constituent hardware RAID10 arrays, we don't need to worry
>> about aligning XFS writes to the RAID stripe width.  The hardware cache
>> will take care of filling the small stripes.  Now we're in the opposite
>> situation of having too many AGs per spindle.  We've put 2 spindles in a
>> single AG and turned the seek starvation issues on its head.
> =

> So it sounds like that for poor guys like us, who can=92t afford the
> hardware to have dozens of spindles, the best option would be to
> create the XFS file system with agcount=3D1? =


Not at all.  You can achieve this performance with the 6 300GB spindles
you currently have, as Christoph and I both mentioned.  You simply lose
one spindle of capacity, 300GB, vs your current RAID6 setup.  Make 3
RAID1 pairs in the p400 and concatenate them.  If the p400 can't do this
concat the mirror pair devices with md --linear.  Format the resulting
Linux block device with the following and mount with inode64.

$ mkfs.xfs -d agcount=3D3 /dev/[device]

That will give you 1 AG per spindle, 3 horizontal AGs total instead of 4
vertical AGs as you get with default striping setup.  This is optimal
for your high IOPS workload as it eliminates all 'extraneous' seeks
yielding a per disk access pattern nearly identical to EXT4.  And it
will almost certainly outrun EXT4 on your RAID6 due mostly to the
eliminated seeks, but also to elimination of parity calculations.
You've wiped the array a few times in your testing already right, so one
or two more test setups should be no sweat.  Give it a go.  The results
will be pleasantly surprising.

> That seems to be the only
> reasonable conclusion to me, since a single RAID device, like a single
> disk, cannot write in parallel anyway.

It's not a reasonable conclusion.  And both striping and concat arrays
write in parallel, just a different kind of parallel.  The very coarse
description (for which I'll likely take heat) is that striping 'breaks
up' one file into stripe_width number of blocks, then writes all the
blocks, one to each disk, in parallel, until all the blocks of the file
are written.  Conversely, with a concatenated array, since XFS writes
each file to a different AG, and each spindle is 1 AG in this case, each
file's blocks are written serially to one disk.  But we can have 3 of
these going in parallel with 3 disks.

The former method relies on being able to neatly pack a file's blocks
into stripes that are written in parallel, to get max write performance.
 This is irrelevant with a concat.  We write all the blocks until the
file is written, and we waste no rotation or seeks in the process as can
be the case with partial stripe width writes on striped arrays.  The
only thing we "waste" is some disk space.  Everyone knows parity equals
lower write IOPS, and knows of the disk space tradeoff with non-parity
RAID to get maximum IOPS.  And since we're talking EXT4 vs XFS, make the
playing field level by testing EXT4 on a p400 based RAID10 of these 6
drives and compare the results to the concat.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
