Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39Nc4wp241813 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 18:38:05 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id DaG06FlMTtyB1cPn
	for <xfs@oss.sgi.com>; Mon, 09 Apr 2012 16:38:03 -0700 (PDT)
Message-ID: <4F8372DC.7030405@hardwarefreak.com>
Date: Mon, 09 Apr 2012 18:38:04 -0500
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
	<4F8055E4.1000808@hardwarefreak.com>
	<CAAxjCEz8TpRvjvbuYPp1xf9X2HwskN5AuPak62R5Jhkg+mmFHA@mail.gmail.com>
In-Reply-To: <CAAxjCEz8TpRvjvbuYPp1xf9X2HwskN5AuPak62R5Jhkg+mmFHA@mail.gmail.com>
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

On 4/9/2012 6:02 AM, Stefan Ring wrote:
>> Not at all.  You can achieve this performance with the 6 300GB spindles
>> you currently have, as Christoph and I both mentioned.  You simply lose
>> one spindle of capacity, 300GB, vs your current RAID6 setup.  Make 3
>> RAID1 pairs in the p400 and concatenate them.  If the p400 can't do this
>> concat the mirror pair devices with md --linear.  Format the resulting
>> Linux block device with the following and mount with inode64.
>>
>> $ mkfs.xfs -d agcount=3D3 /dev/[device]
>>
>> That will give you 1 AG per spindle, 3 horizontal AGs total instead of 4
>> vertical AGs as you get with default striping setup.  This is optimal
>> for your high IOPS workload as it eliminates all 'extraneous' seeks
>> yielding a per disk access pattern nearly identical to EXT4.  And it
>> will almost certainly outrun EXT4 on your RAID6 due mostly to the
>> eliminated seeks, but also to elimination of parity calculations.
>> You've wiped the array a few times in your testing already right, so one
>> or two more test setups should be no sweat.  Give it a go.  The results
>> will be pleasantly surprising.
> =

> Well I had to move around quite a bit of data, but for the sake of
> completeness, I had to give it a try.
> =

> With a nice and tidy fresh XFS file system, performance is indeed
> impressive =96 about 16 sec for the same task that would take 2 min 25
> before. So that=92s about 150 MB/sec, which is not great, but for many
> tiny files it would perhaps be a bit unreasonable to expect more. A

150MB/s isn't correct.  Should be closer to 450MB/s.  This makes it
appear that you're writing all these files to a single directory.  If
you're writing them fairly evenly to 3 directories or a multiple of 3,
you should see close to 450MB/s, if using mdraid linear over 3 P400
RAID1 pairs.  If this is what you're doing then something seems wrong
somewhere.  Try unpacking a kernel tarball.  Lots of subdirectories to
exercise all 3 AGs thus all 3 spindles.

> simple copy of the tar onto the XFS file system yields the same linear
> performance, the same as with ext4, btw. So 150 MB/sec seems to be the
> best these disks can do, meaning that theoretically, with 3 AGs, it
> should be able to reach 450 MB/sec under optimal conditions.

The optimal condition, again, requires writing 3 of this file to 3
directories to hit ~450MB/s, which you should get close to if using
mdraid linear over RAID1 pairs.  XFS is a filesystem after all, so it's
parallelism must come from manipulating usage of filesystem structures.
 I thought I explained all of this previously when I introduced the "XFS
concat" into this thread.

> I will still do a test with the free space fragmentation priming on
> the concatenated AG=3D3 volume, because it seems to be rather slow as
> well.

> But then I guess I=92m back to ext4 land. XFS just doesn=92t offer enough
> benefits in this case to justify the hassle.

If you were writing to only one directory I can understand this
sentiment.  Again, if you were writing 3 directories fairly evenly, with
the md concat, then your sentiment here should be quite different.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
