Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBA4FxSf038673 for <xfs@oss.sgi.com>; Wed, 9 Dec 2009 22:15:59 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 88D6119481C1
	for <xfs@oss.sgi.com>; Wed,  9 Dec 2009 20:16:33 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 28N89T5gwZjk7s1E for
	<xfs@oss.sgi.com>; Wed, 09 Dec 2009 20:16:33 -0800 (PST)
Message-ID: <4B207620.3060605@sandeen.net>
Date: Wed, 09 Dec 2009 22:16:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Disappointing performance of copy (MD raid + XFS)
References: <4B204334.1000605@shiftmail.org>
In-Reply-To: <4B204334.1000605@shiftmail.org>
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
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

Asdo wrote:
> Hi all,
> 
> I'm copying a bagzillion of files (14TB) from a 26disk MD-raid 6 array
> to a 16disk MD-raid 6 array.
> Filesystems are XFS for both arrays.
> Kernel is 2.6.31 ubuntu generic-14
> Performance is very disappointing, going from 150MB/sec to 22MB/sec
> depending apparently to the size of files it encounters. 150MB/sec is
> when files are 40-80MB in size, 22MB/sec is when files are 1MB in size
> on average, and I think I have seen around 10MB/sec when they are of
> 500KB (this transfer at 10MB/sec was in parallel with another faster one
> however).
> Doing multiple rsync transfers simultaneously for different files of the
> filesystem does increase the speed, up to a point however, and even
> launching 5 of them I am not able to bring it above 150MB/sec (that's
> the average: it's actually very unstable).
> 
> Already tried tweaking: stripe_cache_size, readahead, elevator type and
> its parameters, increasing elevator queue length, some parameters in
> /proc/sys/fs/xfs (randomly without understanding much of the xfs params
> actually), and /proc/sys/vm/*dirty* parameters .
> Mount options for destination initially were defaults, then I tried to
> change them via remount to rw,nodiratime,relatime,largeio but without
> much improvements.

A few things come to mind.

For large filesystems such as this, xfs restricts inode locations such that
inode numbers will stay below 32 bits (the number reflects the disk location).
This has the tendency to skew inodes & data away from each other, and copying
a lot of little files will probably get plenty seeky for you.  This may explain
why little files are so much slower than larger ones.

If you mount with -o inode64, new inodes are free to roam the filesystem, and
stay nearer to their data blocks.  This won't help on the read side though
if you've got an existing filesystem.  Note that not all 32-bit applications
cope well with > 32-bit inode numbers, though.

Also, you need to be sure that your filesystem geometry is well-aligned to
the raid geometry, but if this is MD software raid, that should have happened
automatically.

You might also want to see how fragmented your source files are; if they
are highly fragmented, this would reduce performance as you seek around to
get to the pieces.  xfs_bmap will tell you this info.

You might try running blktrace on the source & target block devices to see
what your IOs look like; you can use seekwatcher to graph the results
(or just use seekwatcher to run the whole show).  Nasty IO patterns could
certainly kill performance.

You might also try each piece; see how fast your reads can go, and your
writes, independently.

-Eric

> The above are the best results I could obtain.
> 
> Firstly I tried copying with cp and then with rsync. Not much difference
> between the two.
> 
> Rsync is nicer to monitor because it splits in 2 processes, one reads
> only, the other one only writes.
> 
> So I have repeatedly catted /proc/pid/stack for the reader and writer
> processes: the *writer* is the bottleneck, and 90% of the times it is
> stuck in one of the following stacktraces:
> 

...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
