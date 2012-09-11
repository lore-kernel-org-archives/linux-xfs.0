Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8BLOksa156852 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 16:24:46 -0500
Message-ID: <504FAC55.1000508@sgi.com>
Date: Tue, 11 Sep 2012 16:25:41 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/13] xfs: rationalise xfs_mount_wq users
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1346328017-2795-4-git-send-email-david@fromorbit.com>
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

On 08/30/12 07:00, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Instead of starting and stopping background work on the xfs_mount_wq
> all at the same time, separate them to where they really are needed
> to start and stop.
>
> The xfs_sync_worker, only needs to be started after all the mount
> processing has completed successfully, while it needs to be stopped
> before the log is unmounted.
>
> The xfs_reclaim_worker is started on demand, and can be
> stopped before the unmount process does it's own inode reclaim pass.
>
> The xfs_flush_inodes work is run on demand, and so we really only
> need to ensure that it has stopped running before we start
> processing an unmount, freeze or remount,ro.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

The patch itself looks good. and the "atomic_read(&bp->b_hold)> 0" 
assert appears specific to my machines, so forgive the noise.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
