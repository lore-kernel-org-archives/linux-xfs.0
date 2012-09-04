Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q84FlOOt117656 for <xfs@oss.sgi.com>; Tue, 4 Sep 2012 10:47:24 -0500
Message-ID: <504622C1.20201@sgi.com>
Date: Tue, 04 Sep 2012 10:48:17 -0500
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
> -	/*
> -	 * We shouldn't write/force the log if we are in the mount/unmount
> -	 * process or on a read only filesystem. The workqueue still needs to be
> -	 * active in both cases, however, because it is used for inode reclaim
> -	 * during these times.  Use the MS_ACTIVE flag to avoid doing anything
> -	 * during mount.  Doing work during unmount is avoided by calling
> -	 * cancel_delayed_work_sync on this work queue before tearing down
> -	 * the ail and the log in xfs_log_unmount.
> -	 */
> -	if (!(mp->m_super->s_flags&  MS_ACTIVE)&&
> -	    !(mp->m_flags&  XFS_MOUNT_RDONLY)) {
> +	if (!(mp->m_flags&  XFS_MOUNT_RDONLY)) {
>   		/* dgc: errors ignored here */
>   		if (mp->m_super->s_writers.frozen == SB_UNFROZEN&&
>   		xfs_log_need_covered(mp))
> @@ -408,8 +398,7 @@ xfs_sync_worker(
>   		else
>   			xfs_log_force(mp, 0);
>
> -		/* start pushing all the metadata that is currently
> -		 * dirty */
> +		/* start pushing all the metadata that is currently dirty */
>   		xfs_ail_push_all(mp->m_ail);
>   	}
>

It appears that the removal of the MS_ACTIVE flag is causing the
"atomic_read(&bp->b_hold)>  0," ASSERT.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
