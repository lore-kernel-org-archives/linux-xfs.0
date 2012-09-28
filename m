Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8SLhYhQ071345 for <xfs@oss.sgi.com>; Fri, 28 Sep 2012 16:43:34 -0500
Message-ID: <50661A4B.4020802@sgi.com>
Date: Fri, 28 Sep 2012 16:44:43 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/13] xfs: xfs_sync_data is redundant.
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1348807485-20165-7-git-send-email-david@fromorbit.com>
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

On 09/27/12 23:44, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> We don't do any data writeback from XFS any more - the VFS is
> completely responsible for that, including for freeze. We can
> replace the remaining caller with the VFS level function that
> achieves the same thing, but without conflicting with current
> writeback work - writeback_inodes_sb_if_idle().
>
> This means we can remove the flush_work and xfs_flush_inodes() - the
> VFS functionality completely replaces the internal flush queue for
> doing this writeback work in a separate context to avoid stack
> overruns.
>
> This does have one complication - it cannot be called with page
> locks held.  Hence move the flushing of delalloc space when ENOSPC
> occurs back up into xfs_file_aio_buffered_write when we don't hold
> any locks that will stall writeback.
>
> Note that we always need to pass a count of zero to
> generic_file_buffered_write() as the previously written byte count.
> We only do this by accident before this patch by the virtue of ret
> always being zero when there are no errors. Make this explicit
> rather than needing to specifically zero ret in the ENOSPC retry
> case.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
