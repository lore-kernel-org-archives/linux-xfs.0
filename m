Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q84GDtrO121668 for <xfs@oss.sgi.com>; Tue, 4 Sep 2012 11:13:55 -0500
Message-ID: <504628FB.5080304@sgi.com>
Date: Tue, 04 Sep 2012 11:14:51 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 05/13] xfs: sync work is now only periodic log work
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1346328017-2795-6-git-send-email-david@fromorbit.com>
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
> + * Every sync period we need to unpin all items in the AIL and push them to
> + * disk. If there is nothing dirty, then we might need to cover the log to
> + * indicate that the filesystem is idle.
> + */
> +void
> +xfs_log_worker(
> +	struct work_struct	*work)
> +{
> +	struct xlog		*log = container_of(to_delayed_work(work),
> +						struct xlog, l_work);
> +	struct xfs_mount	*mp = log->l_mp;
> +
> +	/* dgc: errors ignored - not fatal and nowhere to report them */
> +	if (xfs_log_need_covered(mp))
> +		xfs_fs_log_dummy(mp);
> +	else
> +		xfs_log_force(mp, 0);
> +
> +	/* start pushing all the metadata that is currently dirty */
> +	xfs_ail_push_all(mp->m_ail);
> +
> +	/* queue us up again */
> +	xfs_log_work_queue(mp);
> +}

Having log space for the xfs_fs_log_dummy() is the weak point in the 
remaining log hang problems.

I agree with Dave and the above should remain in this series and log 
issue handled in another series.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
