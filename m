Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q98MbtIS154010 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 17:37:55 -0500
Date: Mon, 8 Oct 2012 17:39:21 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/14 V5]: xfs: remove the xfssyncd mess
Message-ID: <20121008223921.GS13214@sgi.com>
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349693772-8064-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On Mon, Oct 08, 2012 at 09:55:58PM +1100, Dave Chinner wrote:
> Hopefully the final version.

I am testing this new rev now... My v4 run over the weekend crashed but
unfortunately I wasn't able to get a stack trace.  We'll see what shakes out.

Regards,
	Ben

> Version 5:
> - move initial queuing of log work so it isn't started on log mount
>   error
> - move xfs_flush_inodes() to xfs_super.c
> - pass xfs_mount to xfs_flush_inodes()
> - rewrite commit message for xfs_flush_inodes() changes
> - added last_sync_lsn fix to series as the problem it fixes is
>   reliably exposed by the changes in this series
> 
> Version 4:
> - updated 'xfs: xfs_sync_data is redundant' with cleanups to the
>   xfs_flush_inodes interface as per Christoph's request,
> - updated 'xfs: xfs_sync_data is redundant', folding in changes from
>   http://oss.sgi.com/archives/xfs/2012-10/msg00036.html
> - fixed a minor typo in xfs: 'syncd workqueue is no more', renaming the
>   log worker from 'xfs-reclaim' to 'xfs-log'.
> 
> Version 3:
> - per-mount log and reclaim workqueues instead of a generic mount
>   workqueue.
> - reordering of some of the patches as Christoph requested.
> - fixed the writeback_inodes_sb_if_idle deadlock by moving it all
>   the way back up the write stack to xfs_file_aio_buffered_write
>   where we were just flushing the current file to avoid deadlocking
>   on it anyway.
> - reintroduced xfs_flush_inodes() as a wrapper for
>   writeback_inodes_sb_if_idle().
> - rebased on a current TOT.
> 
> Version 2:
> - fix writeback_inodes_sb_if_idle call in xfs_create()
> - refreshed patch 13 before sending.
> 
> Initial version:
> - http://oss.sgi.com/archives/xfs/2012-06/msg00064.html
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
