Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4K2v4Qr067546 for <xfs@oss.sgi.com>; Thu, 19 May 2011 21:57:05 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FF3046CB40
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 19:57:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	uE7DSawzHfarrPIb for <xfs@oss.sgi.com>;
	Thu, 19 May 2011 19:57:02 -0700 (PDT)
Date: Fri, 20 May 2011 12:56:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110520025659.GO32466@dastard>
References: <20110520005510.GA15348@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110520005510.GA15348@schmorp.de>
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
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

On Fri, May 20, 2011 at 02:55:11AM +0200, Marc Lehmann wrote:
> Hi!
> 
> I have "allocsize=64m" (or simialr sizes, such as 1m, 16m etc.) on many of my
> xfs filesystems, in an attempt to fight fragmentation on logfiles.
> 
> I am not sure about it's effectiveness, but in 2.6.38 (but not in 2.6.32),
> this leads to very unexpected and weird behaviour, namely that files being
> written have semi-permanently allocated chunks of allocsize to them.

The change that will be causing this was to how the preallocation is
dropped. In normal use cases, the preallocation should be dropped
when the file descriptor is closed. The change in 2.6.38 was to make
this conditional on whether the inode had been closed multiple times
while dirty. If the inode is closed (.release is called) multiple
times while dirty, then the preallocation is not truncated away
until the inode is dropped from the caches, rather than immediately
on close.  This prevents writes on NFS servers from doing excessive
work and triggering excessive fragmentation, as the NFS server does
an "open-write-close" for every write that comes across the wire.

This was also coupled witha change to the default speculative
allocation behaviour to do more and larger specualtive preallocation
and so in most cases remove the need for ever using the allocsize
mount option. It dynamically increases the preallocation size as the
file size increases, so small file writes behave like pre-2.6.38
without the allocsize mount option, large file writes behave like
they have a large allocsize mount option set and thereby preventing
most known delayed allocation fragmentation cases from occurring.

> I realised this when I did a make clean and a make in a buildroot directory,
> which cross-compiles uclibc, gcc, and lots of other packages, leading to a
> lot of mostly small files.

So the question there: how is your workload accessing the files? Is
it opening and closing them multiple times in quick succession after
writing them? I think it is triggering the "NFS server access
pattern" logic and so keeping speculative preallocation around for
longer.

> Atfer I deleted some files to get some space and rebooted, I suddenly had
> 180GB of space again, so it seems an unmount "fixes" this issue.
> 
> I often do these kind of build,s and I have allocsize on thee high values for
> a very long time, without ever having run into this kind of problem.
> 
> It seems that files get temporarily allocated much larger chunks (which is
> expoected behaviour), but xfs doesn't free them until there is a unmount
> (which is unexpected).

"echo 3 > /proc/sys/vm/drop_caches" should free up the space as the
preallocation will be truncated as the inodes are removed from the
VFS inode cache.

> Is this the desired behaviour? I would assume that any allocsize > 0 could
> lead to a lot of fragmentation if files that are closed and no longer being
> in-use always have extra space allocated for expansion for extremely long
> periods of time.

I'd suggest removing the allocsize mount option - you shouldn't need
it anymore because the new default behaviour resists fragmentation a
whole lot better than pre-2.6.38 kernels.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
