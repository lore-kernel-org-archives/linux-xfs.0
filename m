Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NGJ65K135423 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 11:19:06 -0500
Subject: Re: [PATCH 04/16] xfs: don't use vfs writeback for pure metadata
	modifications
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1285137869-10310-5-git-send-email-david@fromorbit.com>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-5-git-send-email-david@fromorbit.com>
Date: Thu, 23 Sep 2010 11:19:57 -0500
Message-ID: <1285258797.1973.10.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2010-09-22 at 16:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Under heavy multi-way parallel create workloads, the VFS struggles
> to write back all the inodes that have been changed in age order.
> The bdi flusher thread becomes CPU bound, spending 85% of it's time
> in the VFS code, mostly traversing the superblock dirty inode list
> to separate dirty inodes old enough to flush.
> 
> We already keep an index of all metadata changes in age order - in
> the AIL - and continued log pressure will do age ordered writeback
> without any extra overhead at all. If there is no pressure on the
> log, the xfssyncd will periodically write back metadata in ascending
> disk address offset order so will be very efficient.
> 
> Hence we can stop marking VFS inodes dirty during transaction commit
> or when changing timestamps during transactions. This will keep the
> inodes in the superblock dirty list to those containing data or
> unlogged metadata changes.

This looks good.  There is a minor typo I'll highlight
below in case you want to fix it.

> However, the timstamp changes are slightly more complex than this -
> there are a couple of places that do unlogged updates of the
> timestamps, and the VFS need to be informed of these. Hence add a
> new function xfs_trans_inode_chgtime() for transactional changes,

You actually used the name "xfs_trans_ichgtime".

> and leave xfs_ichgtime() for the non-transactional changes.

I haven't updated my cscope database, but it looks to me like
this leaves just one spot where xfs_ichtime() is still used.
Namely, xfs_setattr(), when truncating a zero-length file.

> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Alex Elder <aelder@sgi.com>

. . . 

> diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
> index b1fc2a6..37918f4 100644
> --- a/fs/xfs/linux-2.6/xfs_iops.c
> +++ b/fs/xfs/linux-2.6/xfs_iops.c
> @@ -96,40 +96,63 @@ xfs_mark_inode_dirty(
>  
>  /*

. . .

> +	if (xfs_ichgtime_int(ip, flags))
>  		xfs_mark_inode_dirty_sync(ip);
>  }
>  
>  /*
> + * Transactional inode timestamp update. requires inod to be locked and joined

s/inod /inode /

> + * to the transaction supplied. Relies on the transaction subsystem to track
. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
