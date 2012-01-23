Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0N4LXYB051902 for <xfs@oss.sgi.com>; Sun, 22 Jan 2012 22:21:33 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Zg9OpcTJA5KI5I4q for <xfs@oss.sgi.com>;
	Sun, 22 Jan 2012 20:21:31 -0800 (PST)
Date: Mon, 23 Jan 2012 15:21:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Optimal XFS formatting options?
Message-ID: <20120123042128.GG15102@dastard>
References: <33140169.post@talk.nabble.com>
	<20242.10382.19330.275280@tree.ty.sabi.co.UK>
	<4F192DEC.4030400@tlinx.org>
	<20249.22727.359884.733592@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20249.22727.359884.733592@tree.ty.sabi.co.UK>
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

On Fri, Jan 20, 2012 at 12:06:31PM +0000, Peter Grandi wrote:
> [ ... ]
> >> * XFS has several limitations on 32b kernels. Just make sure
> >>   you have a 64b kernel.
> [ ... ]
> > I was unaware that the block size was larger on 64b kernels.
> > Is that what you are referring to ? (would be nice)...
> 
> Not as such, the maximum block size is limited by the Linux page
> cache, that is hw page size, which is for IA32 and AMD64
> architectures the same at 4KiB. However other architectures
> which are natively 64b allow bigger page sizes (notably IA64
> [aka Itanium]), so the page cache and thus XFS can do larger
> blocks sizes.
> 
> The limitations of XFS on 32b kernels come from limitations of
> XFS itself in 32b mode, limitations of Linux in 32b mode, and
> combined limitations. For example:
> 
>   * There be 32b inode numbers, which limit inodes to the first
>     1TB of a filetree if sector size is 512B.

Internally XFS still uses 64 bit inode numbers - the on-disk format
does not change just because the CPU arch has changed. If you use
the stat64() style interfaces, even on 32 bit machines you can
access the full 64 bit inode numbers.

>   * The 32b block IO subsystems limits partition sizes to 16TiB.

The sector_t is a 64 bit number even on 32 bit systems. The
problem is that the page cache cannot index past offsets of 16TB.
Given that XFS no longer uses the page cache for it's metadata
indexing, we could remove this limit in the kernel code if we
wanted to. And given that the userpsace tools use direct IO, the
page cache limitation doesn't cause problems there, either, because
we bypass it.

So in theory we could lift this limit, but there really isn't much
demand for >16TB filesystems on 32 bit, because....

>   * XFS tools scanning a large filesystem, usually for repair,
>     can run out of the available 32b address space (by default
>     around 2GiB).

.... you need 64 bit systems to handle the userspace memory
requirements tools like xfs_check and xfs_repair require to run.  If
the filesystem is large enough that you can't run repair because it
needs more than 2GB of RAM, then you shouldn't be using a 32 bit
systems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
