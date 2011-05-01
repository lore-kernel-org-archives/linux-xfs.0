Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p41EhYmL180159 for <xfs@oss.sgi.com>; Sun, 1 May 2011 09:43:34 -0500
Received: from hermes1.dur.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BBCC15D0F49
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 07:47:05 -0700 (PDT)
Received: from hermes1.dur.ac.uk (hermes1.dur.ac.uk [129.234.248.1]) by
	cuda.sgi.com with ESMTP id ZkGRA1D35GYgOzDa for
	<xfs@oss.sgi.com>; Sun, 01 May 2011 07:47:05 -0700 (PDT)
Received: from smtphost2.dur.ac.uk (smtphost2.dur.ac.uk [129.234.252.2])
	by hermes1.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p41Ekoin015482
	for <xfs@oss.sgi.com>; Sun, 1 May 2011 15:46:55 +0100
Received: from ty.sabi.co.UK (o1.phyip3.dur.ac.uk [129.234.186.1])
	by smtphost2.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p41EkZB3011973
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 1 May 2011 15:46:35 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1QGXn2-0004hA-Gw
	for <xfs@oss.sgi.com>; Sun, 01 May 2011 15:38:28 +0100
MIME-Version: 1.0
Message-ID: <19901.28769.553575.864887@tree.ty.sabi.co.UK>
Date: Sun, 1 May 2011 15:38:25 +0100
Subject: Re: xfs performance problem
In-Reply-To: <20110501084919.GE13542@dastard>
References: <4DB72084.8020205@inf.ethz.ch> <4DB74331.3030804@hardwarefreak.com>
	<4DB75C6D.1080901@inf.ethz.ch>
	<19898.53907.842827.480883@tree.ty.sabi.co.UK>
	<20110501084919.GE13542@dastard>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>

> [ ... ]

[ ... Extracting a kernel 'tar' with GNU tar on 'ext3': ]
>>> real    0m21.769s
[ ... Extracting a kernel 'tar' with GNU tar on XFS: ]
>>> real    2m20.522s

>> [ ... ] in most cases the wrong number is the one for 'ext3'
>> on RAID1 (way too small). Even the number for XFS and RAID0
>> 'delaylog' is a wrong number (somewhat small) in many cases.

>> There are 38000 files in 440MB in 'linux-2.6.38.tar', ~40% of
>> them are smaller than 4KiB and ~60% smaller than 8KiB. Also you
>> didn't flush caches, and you don't say whether the filesystems
>> are empty or full or at the same position on the disk.
>> 
>> Can 'ext3' really commit 1900 small files per second (including
>> directory updates) to a filesystem on a RAID1 that probably can
>> do around 100 IOPS? That would be amazing news.

In the real world 'ext3' as reported in my previous message can
"really commit" around 50 "small files per second (including
directory updates)" in near-optimal conditions to a storage
device that can proboably do around 100IOPS; copying here the
actual numbers:

  % mount -t ext3 -o relatime /dev/sdb /mnt/sdb
  % time sh -c 'cd /mnt/sdb; star -x -b 2048 -f /tmp/linux-2.6.38.tar; cd /; umount /mnt/sdb'
  star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

  real    12m49.610s
  user    0m0.990s
  sys     0m8.610s
  ....
  % df -BM /mnt/sdb
  Filesystem           1M-blocks      Used Available Use% Mounted on
  /dev/sdb               469455M      687M   444922M   1% /mnt/sdb
  % df -i /mnt/sdb
  Filesystem            Inodes   IUsed   IFree IUse% Mounted on
  /dev/sdb             30531584   38100 30493484    1% /mnt/sdb

As a side note, even 12m49.610s is probably a bit optimistic
because of the 1s timestamp resolution of 'ext3':

  http://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg272253.html

> Of course it can.

And a pony! Or rather 'O_PONIES' :-).

> Why? Because the allocator is optimised to pack small files
> written at the same time together on disk, and the elevator
> will merge them into one large IO when they are finally
> written to disk. With a typical 512k max IO size, that's 128
> <=4k files packed into each IO,

This is an argument based on a cunning or distracted or ignorant
shift of the goalposts: because this is an argument about purely
*writing* the *data* in those small files, while the bigger
issue is *committing* the *metadata*, all of it "(including
directory updates)". Also, this argument is also based on the
assumption that it is permissible to commit 128 small files when
the last one gets closed, not when each gets committed.

In this discussion it is rather comical to make an argument
based on the speed of IO using what is in effect EatMyData as
described here:

  http://talk.maemo.org/showthread.php?t=67901

but here it is:

> In a perfect world, we're talking about ~13000 4k files a
> second being written to disk @ 100 IOPS. In the real world,
> writing an order of magnitude less files per second is quite
> obtainable.

But in the real world the "quite obtainable" number with 'ext3'
for "really commit [ ... ]  small files per second (including
directory updates)" on storage that "probably can do around 100
IOPS" is around *50* (fifty), not 1,300, never mind 13,000.

Sure if one want to look instead at  whatever number they can
get with their clever "benchmarks"  one can get:

    % mount -t ext3 -o relatime /dev/sdb /mnt/sdb
    % time sh -c 'cd /mnt/sdb; star -x -b 2048 -f /tmp/linux-2.6.38.tar -no-fsync; cd /; umount /mnt/sdb'
    star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

    real    0m27.414s
    user    0m0.270s
    sys     0m2.430s

That's a fantastic result, somewhat over 1,300 small files per
second (14 commits per nominal IOPS), but "fantastic" (as in
fantasy) is the keyword, because it is for completely different
and broken semantics, a point that should not be lost on anybody
who can "understand IOPS and metadata and commits and caching".

It is not as if the difference isn't widely known:

  http://cdrecord.berlios.de/private/man/star/star.1.html

    Star is a very fast tar(1) like tape archiver with improved
    functionality. 
    On operating systems with slow file I/O (such as Linux), it
    may help to use -no-fsync in addition, but then star is
    unable to detect all error conditions; so use with care. 

That GNU 'tar' does not commit files when extracting is pretty
old news, and therefore as I wrote in a previous message on a
similar detail:

  There is something completely different: a tradeoff between
  levels of safety (whether you want committed transactions or
  not and how finely grained) and time to completion. 

  But when one sees comical "performance" comparisons without
  even cache flushing, explaining the difference between a
  performance problem and different safety/speed tradeoffs seems
  a bit wasted.
  Again, the fundamental problem is how many committed IOPS the
  storage system can do given a metadata (and thus journal)
  intensive load (the answer is "not many" per spinning medium). 

Plus of course:

>> Despite decades of seeing it happen, I keep being astonished by
>> how many people (some with decades of "experience") just don't
>> understand IOPS and metadata and commits and caching and who

> Oh, the irony.... :)

Indeed :-).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
