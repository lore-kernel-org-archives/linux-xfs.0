Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Oct 2006 15:32:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k92MVmaG022787
	for <xfs@oss.sgi.com>; Mon, 2 Oct 2006 15:31:50 -0700
Date: Tue, 3 Oct 2006 08:30:56 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Long sleep with i_mutex in xfs_flush_device(), affects NFS service
Message-ID: <20061002223056.GN4695059@melbourne.sgi.com>
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal> <451A618B.5080901@agami.com> <Pine.LNX.4.64.0610020939450.5072@madrid.max-t.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0610020939450.5072@madrid.max-t.internal>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: Shailendra Tripathi <stripathi@agami.com>, xfs@oss.sgi.com

On Mon, Oct 02, 2006 at 10:45:12AM -0400, Stephane Doyon wrote:
> On Wed, 27 Sep 2006, Shailendra Tripathi wrote:
> 
> >Hi Stephane,
> >> When the file system becomes nearly full, we eventually call down to
> >> xfs_flush_device(), which sleeps for 0.5seconds, waiting for xfssyncd to
> >> do some work. xfs_flush_space()does
> >>         xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >> before calling xfs_flush_device(), but i_mutex is still held, at least
> >> when we're being called from under xfs_write(). 
> >
> >1. I agree that the delay of 500 ms is not a deterministic wait.

AFAICT, it was never intended to be.

It's not deterministic, and the wait is really only there to ensure
that the synchronous log force catches all the operations that may
have recently occurred so they can be unpinned and flushed.

For example, an extent that has been truncated and freed cannot be
reused until the transaction that it was freed in has actually been
commited to disk.....

> >2. xfs_flush_device is a big operation. It has to flush all the dirty 
> >pages possibly in the cache on the device. Depending upon the device, it 
> >might take significant amount of time. Keeping view of it, 500 ms in that 
> >unreasonable. Also, perhaps you would never want more than one request to 
> >be queued for device flush.
> >3. The hope is that after one big flush operation, it would be able to 
> >free up resources which are in transient state (over-reservation of 
> >blocks, delalloc, pending removes, ...). The whole operation is intended 
> >to make sure that ENOSPC is not returned unless really required.
> 
> Yes I had surmised as much. That last part is still a little vague to 
> me... But my two points were:
> 
> -It's a long time to hold a mutex. The code bothers to drop the 
> xfs_ilock, so I'm wondering whether the i_mutex had been forgotten?

This deep in the XFS allocation functions, we cannot tell if we hold
the i_mutex or not, and it plays no part in determining if we have
space or not. Hence we don't touch it here. 

> -Once we've actually hit ENOSPC, do we need to try again? Isn't it 
> possible to tell when resources have actually been freed?

Given that the only way to determine if space was made available is
to query every AG in the exact same way an allocation does, it makes
sense to try the allocation again to determine if space was made
available....

> >4. This wait could be made deterministic by waiting for the syncer thread 
> >to complete when device flush is triggered.
> 
> I remember that some time ago, there wasn't any xfs_syncd, and the 
> flushing operation was performed by the task wanting the free space. And 
> it would cause deadlocks. So I presume we would have to be careful if we 
> wanted to wait on sync.

*nod*

Last thing we want is more deadlocks. This code is already
convoluted enough without added yet more special cases to it....

> >> The rough workaround I have come up with for the problem is to have
> >> xfs_flush_space() skip calling xfs_flush_device() if we are within 2secs
> >> of having returned ENOSPC. I have verified that this workaround is
> >> effective, but I imagine there might be a cleaner solution.
> >
> >The fix would not be a good idea for standalone use of XFS.

I doubt it's a good idea for an NFS server, either.

Remember that XFS, like most filesystems, trades off speed for
correctness as we approach ENOSPC. Many parts of XFS slow down as we
approach ENOSPC, and this is just one example of where we need to be
correct, not fast.

> It seems to me ENOSPC has never been something very exact anyway:
> df (statfs) often still shows a few remaining free blocks even on
> a full file system.  Apps can't really calculate how many blocks
> will be needed for inodes, btrees and directories, so the number
> of remaining data blocks is an approximation.

It's not supposed to be an approximation - the number reported by df
should be taking all this into account because it's coming directly
from how much space XFS thinks it has available.

> >You might experiment by adding deterministic wait. When you enqueue, set 
> >some flag. All others who come in between just get enqueued. Once, device 
> >flush is over wake up all. If flush could free enough resources, threads 
> >will proceed ahead and return. Otherwise, another flush would be enqueued 
> >to flush what might have come since last flush.
> 
> But how do you know whether you need to flush again, or whether your file 
> system is really full this time? And there's still the issue with the 
> i_mutex.
> 
> Perhaps there's a way to evaluate how much resources are "in transient 
> state" as you put it.

I doubt there's any way of doing this without introducing non-enospc
performance regressions and extra memory usage.

> Otherwise, we could set a flag when ENOSPC is 
> returned, and have that flag cleared at appropriate places in the code 
> where blocks are actually freed. I keep running into various deadlocks 
> related to full file systems, so I'm wary of clever solutions :-).

IMO, this is a non-problem.  You're talking about optimising a
relatively rare corner case where correctness is more important than
speed and your test case is highly artificial. AFAIC, if you are
running at ENOSPC then you get what performance is appropriate for
correctness and if you are continually runing at ENOSPC, then buy
some more disks.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
