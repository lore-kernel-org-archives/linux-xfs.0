Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AKTBQg206759 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 15:29:11 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ldPg7rvNH1VHHX5J
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 13:29:10 -0700 (PDT)
Message-ID: <4F849817.4060102@hardwarefreak.com>
Date: Tue, 10 Apr 2012 15:29:11 -0500
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
	<4F8372DC.7030405@hardwarefreak.com>
	<CAAxjCEx14NrgUatB349vx8h0kCxE=cS7d4DLLPnjwB035tB3Hw@mail.gmail.com>
In-Reply-To: <CAAxjCEx14NrgUatB349vx8h0kCxE=cS7d4DLLPnjwB035tB3Hw@mail.gmail.com>
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

On 4/10/2012 1:11 AM, Stefan Ring wrote:
>> 150MB/s isn't correct.  Should be closer to 450MB/s.  This makes it
>> appear that you're writing all these files to a single directory.  If
>> you're writing them fairly evenly to 3 directories or a multiple of 3,
>> you should see close to 450MB/s, if using mdraid linear over 3 P400
>> RAID1 pairs.  If this is what you're doing then something seems wrong
>> somewhere.  Try unpacking a kernel tarball.  Lots of subdirectories to
>> exercise all 3 AGs thus all 3 spindles.
> =

> The spindles were exercised; I watched it with iostat. Maybe I could
> have reached more with more parallelism, but that wasn=92t my goal at
> all. Although, over the course of these experiments, I got to doubt
> that the controller could even handle this data rate.

Hmm.  We might need to see me detail of what your workload is actually
doing.  It's possible that 3 AGs is too few.  Going with more will cause
more head seeking, but it might also alleviate some bottlenecks within
XFS itself that we may be creating by using only 3 AGs.  I don't know
XFS internals well enough to say.  Dave can surely tell us if 3 may be
too few.

And yes, that controller doesn't seem to be the speediest with a huge
random IO workload.

>>> simple copy of the tar onto the XFS file system yields the same linear
>>> performance, the same as with ext4, btw. So 150 MB/sec seems to be the
>>> best these disks can do, meaning that theoretically, with 3 AGs, it
>>> should be able to reach 450 MB/sec under optimal conditions.
>>
>> The optimal condition, again, requires writing 3 of this file to 3
>> directories to hit ~450MB/s, which you should get close to if using
>> mdraid linear over RAID1 pairs.  XFS is a filesystem after all, so it's
>> parallelism must come from manipulating usage of filesystem structures.
>>  I thought I explained all of this previously when I introduced the "XFS
>> concat" into this thread.
> =

> The optimal condition would be 3 parallel writes of huge files, which
> can be easily written linearly. Not thousands of tiny files.

That was my point.  You mentioned copying a single tar file.  A single
file write to a concatenated XFS will hit only one AG, thus only one
spindle.  If you launch 3 parallel copies of that file to 3 different
directories, each one on a different AG, then you should hit close to
450.  The trick is knowing which directories are on which AGs.  If you
manually create 3 directories right after making the filesystem, each
one will be on a different AG.  Write a file to each of these dirs in
parallel and you should hit ~450MB/s.

>>> But then I guess I=92m back to ext4 land. XFS just doesn=92t offer enou=
gh
>>> benefits in this case to justify the hassle.
>>
>> If you were writing to only one directory I can understand this
>> sentiment.  Again, if you were writing 3 directories fairly evenly, with
>> the md concat, then your sentiment here should be quite different.
> =

> Haha, I made a U-turn on this one. XFS is back on the table (and on
> the disks now) ;). When I thought I was done, I wanted to restore a
> few large KVM images which were on the disks prior to the RAID
> reconfiguration. With ext4, I watched iostat writing at 130MB/s for a
> while. After 2 or 3 minutes, it broke down completely and languished
> at 30-40MB/s for many minutes, even after I had SIGSTOPed the writing
> process, during which it was nearly impossible to use vim to edit a
> file on the ext4 partition. It would pause for tens of seconds all the
> time. It=92s not even clear why it broke down so badly. From another
> seekwatcher sample I took, it looked like fairly linear writing.

What was the location of the KVM images you were copying?  Is it
possible the source device simply slowed down?  Or network congestion if
this was an NFS copy?

> So I threw XFS back in, restarted the restore, and it went very
> smoothly while still providing acceptable interactivity.

It's nice to know XFS "saved the day" but I'm not so sure XFS deserves
the credit here.  The EXT4 driver itself/alone shouldn't cause the lack
of responsiveness behavior you saw.  I'm guessing something went wrong
on the source side of these file copies, given your report of dropping
to 30-40MB/s on the writeout.

> XFS is not a panacea (obviously), and it may be a bit slower in many
> cases, and doesn=92t seem to cope well with fragmented free space (which
> is what this entire thread is really about), =


Did you retest fragmented freespace writes with the linear concat or
RAID10?  If not you're drawing incorrect conclusions due to not having
all the facts.  RAID6 can cause tremendous overhead with writes into
fragmented free space because of RMW, same with RAID5.  And given the
P400's RAID6 performance it's not at all surprising XFS would appear to
perform poorly here.  And my suggestion of using only 3 AGs to minimize
seeks may actually be detrimental here as well.  6 AGs may perform
better, and overall, than 3 AGs.

> but overall it feels more
> well-rounded. After all, I don=92t really care how much it writes per
> time unit, as long as it=92s not ridiculously little and it doesn=92t
> bring everything else to a halt.

And you should be discovering by now that while XFS may not be a
"panacea" of a filesystem, it has unbelievable flexibility in allowing
you to tune it for specific storage layouts and workloads to wring out
its maximum performance.  Even with optimum tuning, it may not match the
performance of other filesystems for specific workloads, but you can
tune it to get damn close with ALL workloads, and also trounce all other
with very large workloads.  No other filesystem can do this.  Note
Geoffrey's example of an XFS on 600 disks with 15GB/s throughput.  Name
another FS that can perform acceptably with your workload, and also that
workload. ;)

-- =

Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
