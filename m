Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 11 Oct 2007 14:54:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9BLs03X013755
	for <xfs@oss.sgi.com>; Thu, 11 Oct 2007 14:54:03 -0700
Date: Fri, 12 Oct 2007 07:53:53 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS regression?
Message-ID: <20071011215352.GX995458@sgi.com>
References: <20071010152742.1b2a7bce@zeus.pccl.info> <20071011010139.GT995458@sgi.com> <20071011151512.69f19419@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011151512.69f19419@zeus.pccl.info>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Clayton <andrew@digital-domain.net>
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 11, 2007 at 03:15:12PM +0100, Andrew Clayton wrote:
> On Thu, 11 Oct 2007 11:01:39 +1000, David Chinner wrote:
> 
> > So it's almost certainly pointing at an elevator or driver change, not an
> > XFS change.
> 
> heh, git bisect begs to differ :)
> 
> 4c60658e0f4e253cf275f12b7c76bf128515a774 is first bad commit commit
> 4c60658e0f4e253cf275f12b7c76bf128515a774 Author: David Chinner <dgc@sgi.com>
> Date:   Sat Nov 11 18:05:00 2006 +1100
> 
>     [XFS] Prevent a deadlock when xfslogd unpins inodes.

Oh, of course - I failed to notice the significance of
this loop in your test:

	while [foo]; do
		touch fred
		rm fred
	done

The inode allocator keeps reusing the same inode.  If the
transaction that did the unlink has not hit the disk before we
allocate the inode again, we have to force the log to get the unlink
transaction to disk to get the xfs inode unpinned (i.e. able to be
modified in memory again).

It's the log force I/O that's introducing the latency.

If we don't force the log, then we have a possible use-after free
of the linux inode because of a fundamental mismatch between
the XFS inode life cycle and the linux inode life cycle. The
use-after free only occurs on large machines under heavy, heavy
metadata load to many disks and filesystems (requires enough
traffic to overload an xfslogd) and is very difficult to
reproduce (large machine, lots of disks and 20-30 hours MTTF).

I'll have a look at other ways to solve this problem, but it
took 6 months to find a solution to the race in the first place
so don't hold your breath.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
