Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5KNp0Dx197086 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 18:51:01 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0B6A1E4AEB0
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 16:50:58 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	yb7OIsDrWU0iTDbM for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2011 16:50:58 -0700 (PDT)
Date: Tue, 21 Jun 2011 09:50:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: question on xfs_vm_writepage in combination with fsync
Message-ID: <20110620235040.GQ561@dastard>
References: <4DFFB3F3.3070606@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DFFB3F3.3070606@sgi.com>
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
To: Kevan Rehm <kfr@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 20, 2011 at 03:56:19PM -0500, Kevan Rehm wrote:
> Greetings,
> 
> I've run into a case where the fsync() system call seems to have
> returned before all file data was actually on disk.  (A SLES11SP1 system
> crash occurred shortly after an fsync which had returned zero.  After
> restarting the machine, the last I/O before the fsync is not in the
> file.)  In attempting to find the problem, I've come across code I don't
> understand, and am hoping someone can enlighten me as to how things are
> supposed to work.
> 
> Routine xfs_vm_writepage has various situations under which it will
> decide it can't currently initiate writeback on a page, and in that case
> calls redirty_page_for_writepage, unlocks the page, and returns zero.
> That seems to me to be incompatible with fsync(), so I'm obviously
> missing some key piece of logic.
> 
> The calling sequence of routines involved in fsync is:
> 
> do_fsync->vfs_fsync->vfs_fsync_range->
> 	filemap_write_and_wait_range->
> 	__filemap_fdatawrite_range->
> 	do_writepages->generic_writepages->
> 	write_cache_pages
> 
> Routine write_cache_pages walks the radix tree and calls
> clear_page_dirty_for_io and then __writepage on each dirty page to
> initiate writeback.  __writepage calls xfs_vm_writepage.  That routine
> is occasionally unable to immediately start writeback of the page, and
> so it calls redirty_page_for_writepage without setting the writeback flag.

Hi Kevan,

The current xfs_vm_writepage mainline code will only enter the
redirty path if:

	- it is called from direct memory reclaim
	- it is called within a transaction context and we need to
	  do an allocation transaction
	- it is WB_SYNC_NONE writeback and we can't get the inode
	  lock without blocking during block mapping (EAGAIN case).

None of these cases are triggered by fsync() driven (WB_SYNC_ALL)
writeback, so AFAICT fsync() based writeback should not be skipping
writeback of dirty pages in the given fsync range. So for a mainline
kernel I don't think there are any problems w.r.t. fsync() and
redirtying pages causing dirty pages to be skipped during writeback.

However, the mainline writeback path has had significant change
(especially to WB_SYNC_ALL writeback) since sles11sp1 was
snapshotted (2.6.32, right?). Hence it is possible that one (or
several) of the changes fixed this bug without us even realising it
was a problem.

That said, having dirty pages after an fsync is not necessarily an
fsync bug - something coul dhave dirtied them while the fsync was in
progress. I don't know any details of how this occurred, so I'm
simply speculating that there could be other causes of the dirty
pages you are seeing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
