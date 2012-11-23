Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN0xNDi005917 for <xfs@oss.sgi.com>; Thu, 22 Nov 2012 18:59:24 -0600
Date: Fri, 23 Nov 2012 12:01:23 +1100
From: Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] xfs: fix broken error handling in xfs_vm_writepage
Message-ID: <20121123010123.GD18889@devil.redhat.com>
References: <1353625410-1413-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1353625410-1413-1-git-send-email-peterhuewe@gmx.de>
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
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Ben Myers <bpm@sgi.com>, stable@vger.kernel.org, xfs@oss.sgi.com

[add xfs@oss.sgi.com cc]

On Fri, Nov 23, 2012 at 12:03:30AM +0100, Peter Huewe wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we shut down the filesystem, it might first be detected in
> writeback when we are allocating a inode size transaction. This
> happens after we have moved all the pages into the writeback state
> and unlocked them. Unfortunately, if we fail to set up the
> transaction we then abort writeback and try to invalidate the
> current page. This then triggers are BUG() in block_invalidatepage()
> because we are trying to invalidate an unlocked page.
> 
> Fixing this is a bit of a chicken and egg problem - we can't
> allocate the transaction until we've clustered all the pages into
> the IO and we know the size of it (i.e. whether the last block of
> the IO is beyond the current EOF or not). However, we don't want to
> hold pages locked for long periods of time, especially while we lock
> other pages to cluster them into the write.
> 
> To fix this, we need to make a clear delineation in writeback where
> errors can only be handled by IO completion processing. That is,
> once we have marked a page for writeback and unlocked it, we have to
> report errors via IO completion because we've already started the
> IO. We may not have submitted any IO, but we've changed the page
> state to indicate that it is under IO so we must now use the IO
> completion path to report errors.
> 
> To do this, add an error field to xfs_submit_ioend() to pass it the
> error that occurred during the building on the ioend chain. When
> this is non-zero, mark each ioend with the error and call
> xfs_finish_ioend() directly rather than building bios. This will
> immediately push the ioends through completion processing with the
> error that has occurred.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> Signed-off-by: Ben Myers <bpm@sgi.com>

Any particular reason you picked this patch for a backport and not
many of the other fixes that went into the 3.7 series?

As it is, this problem is not that easy to hit, and I'm wary of
backporting changes to the io completion/Io submission error
handling paths to stable kernels without wider testing of the fix
(i.e. release of 3.7 and then a couple of weeks of people using it).
That's the reason why I didn't put a cc to the stable kernel on the
commit in the first place.

Sometimes there's good reason for being cautious about
backporting fixes to stable kernels - if the problem is not being
reported by users then letting the fixes get out into the real world
for a while before backporting them to the stable kernels is the
right approach. Stable kernels are supposed to be stable, and as
such we want to be certain that changes are not going to have
unintneded consequences and then have to rush more fixes back to the
stable kernels because we broke them....

Cheers,

Dave.
-- 
Dave Chinner
dchinner@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
