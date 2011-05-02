Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p422lRqe205163 for <xfs@oss.sgi.com>; Sun, 1 May 2011 21:47:27 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27D2516471AF
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 19:50:59 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	D0h3UhrD19vCVo9x for <xfs@oss.sgi.com>;
	Sun, 01 May 2011 19:50:59 -0700 (PDT)
Date: Mon, 2 May 2011 12:50:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs performance problem
Message-ID: <20110502025042.GK13542@dastard>
References: <4DB72084.8020205@inf.ethz.ch> <4DB74331.3030804@hardwarefreak.com>
	<4DB75C6D.1080901@inf.ethz.ch>
	<19898.53907.842827.480883@tree.ty.sabi.co.UK>
	<20110501084919.GE13542@dastard>
	<19901.28769.553575.864887@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19901.28769.553575.864887@tree.ty.sabi.co.UK>
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Sun, May 01, 2011 at 03:38:25PM +0100, Peter Grandi wrote:
> > [ ... ]
> 
> [ ... Extracting a kernel 'tar' with GNU tar on 'ext3': ]
> >>> real    0m21.769s
> [ ... Extracting a kernel 'tar' with GNU tar on XFS: ]
> >>> real    2m20.522s
> 
> >> [ ... ] in most cases the wrong number is the one for 'ext3'
> >> on RAID1 (way too small). Even the number for XFS and RAID0
> >> 'delaylog' is a wrong number (somewhat small) in many cases.
> 
> >> There are 38000 files in 440MB in 'linux-2.6.38.tar', ~40% of
> >> them are smaller than 4KiB and ~60% smaller than 8KiB. Also you
> >> didn't flush caches, and you don't say whether the filesystems
> >> are empty or full or at the same position on the disk.
> >> 
> >> Can 'ext3' really commit 1900 small files per second (including
> >> directory updates) to a filesystem on a RAID1 that probably can
> >> do around 100 IOPS? That would be amazing news.
> 
> In the real world 'ext3' as reported in my previous message can
> "really commit" around 50 "small files per second (including
> directory updates)" in near-optimal conditions to a storage
> device that can proboably do around 100IOPS; copying here the
> actual numbers:
> 
>   % mount -t ext3 -o relatime /dev/sdb /mnt/sdb
>   % time sh -c 'cd /mnt/sdb; star -x -b 2048 -f /tmp/linux-2.6.38.tar; cd /; umount /mnt/sdb'
>   star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

Oh, you fsync every file.  The problem the user reported did not
involve fsync at all, so your straw man isn't really relevant to the
reported problem. You're redefining the problem to suit your
argument.

> > Why? Because the allocator is optimised to pack small files
> > written at the same time together on disk, and the elevator
> > will merge them into one large IO when they are finally
> > written to disk. With a typical 512k max IO size, that's 128
> > <=4k files packed into each IO,
> 
> This is an argument based on a cunning or distracted or ignorant
> shift of the goalposts: because this is an argument about purely
> *writing* the *data* in those small files, while the bigger
> issue is *committing* the *metadata*, all of it "(including
> directory updates)". Also, this argument is also based on the
> assumption that it is permissible to commit 128 small files when
> the last one gets closed, not when each gets committed.

I haven't confused anything - indeed I explained exactly why the
user got the results they did with ext3.  You seem to be implying
that the only way for data safety to be given is:

	write file
	fsync file
	fsync parent dir
	write file
	fsync file
	fsync parent dir
	.....

Which is, quite frankly, a load of bollocks.

The user doesn't care if the untar is not complete because a crash
occurred during it - they are still going to have to redo it from
scratch regardless of whether file-by-file fsync is in use or not.
Indeed, doing this:

	write file
	write file
	write file
	write file
	write file
	.....
	sync

Gives the same overall guarantees as your preferred method, but
completes much, much faster.  Taking 30s to write the files
asynchronously and then another second or two for the sync to
complete is far more appropriate for this workload than doing a
file-by-file fsync.

> In this discussion it is rather comical to make an argument
> based on the speed of IO using what is in effect EatMyData as
> described here:
> 
>   http://talk.maemo.org/showthread.php?t=67901
> 
> but here it is:

/me starts laughing uncontrollably.

The source:

http://www.flamingspork.com/projects/libeatmydata/

for speeding up database testing where fsync is not needed to
determine the success of the test or not.

The fact is that the dpkg devs went completely nuts with fsync()
when ext4 came around because it had problems with losing files when
crashes occurred shortly after upgrades. It was excessive and
unneccessary and didn't take into account the transactional grouping
of updates.

This problem has since been fixed - there is now a sync issued at
the end of each package install so the data is on disk before the
"installation complete" entry is updated in the dpkg database. A
single sync rather than a sync-per-file is much, much faster, and
matches the intended "transaction grouping" of the dpkg operation.
With the recent addition of a "sync a single fs" syscall, it will
get faster again....

> That's a fantastic result, somewhat over 1,300 small files per
> second (14 commits per nominal IOPS), but "fantastic" (as in
> fantasy) is the keyword, because it is for completely different
> and broken semantics, a point that should not be lost on anybody
> who can "understand IOPS and metadata and commits and caching".

Where's the "broken semantics" here? The filesystem did exactly what
you asked, and performed in exactly the way we'd expect it to.
Atomicity and stability guarantees are application dependent
- they are not defined by the filesystem.

Fundamentally, untarring a kernel tarball does not require the same
data safety semantics of databases nor does it need to deal with
safely overwriting files. Sometimes people care more about
performance than they do about data safety, and untarring some huge
tarball is usually one of those cases. If they care about data
safety, that is what sync(1) is for after the untar...

> It is not as if the difference isn't widely known:
> 
>   http://cdrecord.berlios.de/private/man/star/star.1.html
> 
>     Star is a very fast tar(1) like tape archiver with improved
>     functionality. 
>     On operating systems with slow file I/O (such as Linux), it
>     may help to use -no-fsync in addition, but then star is
>     unable to detect all error conditions; so use with care. 

Ah, quoting Joerg Schilling FUD about Linux. That's a good way
to get people to ignore you....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
