Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADEPYJb093406 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 08:25:34 -0600
Message-ID: <50A258D6.8070606@sgi.com>
Date: Tue, 13 Nov 2012 08:27:34 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfs: fix broken error handling in xfs_vm_writepage
References: <1352718586-3538-1-git-send-email-david@fromorbit.com>
	<1352718586-3538-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1352718586-3538-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/12/12 05:09, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
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
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

I could not recreate the problem with my test machines, which is not
surprising - it is a matter of timing.

The patch looks sound to me.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
