Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EGoVsV017188 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 10:50:32 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 3/3] XFS: Don't wake xfsbufd when idle
Date: Thu, 14 Jan 2010 10:51:25 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A696D@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1263210599-25067-4-git-send-email-david@fromorbit.com>
From: "Alex Elder" <aelder@sgi.com>
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

Dave Chinner wrote:
> The xfsbufd wakes every xfsbufd_centisecs (once per second by
> default) for each filesystem even when the filesystem is idle.
> If the xfsbufd has nothing to do, put it into a long term sleep
> and only wake it up when there is work pending (i.e. dirty
> buffers to flush soon). This will make laptop power misers happy.

Patch generally looks good but I have a question, below.

> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |   20 +++++++++++++++-----
>  1 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index 77b8be8..b51be4e 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1595,6 +1595,11 @@ xfs_buf_delwri_queue(
>  		list_del(&bp->b_list);
>  	}
> 
> +	if (list_empty(dwq)) {
> +		/* start xfsbufd as it is about to have something to do */
> +		wake_up_process(bp->b_target->bt_task);
> +	}
> +
>  	bp->b_flags |= _XBF_DELWRI_Q;
>  	list_add_tail(&bp->b_list, dwq);
>  	bp->b_queuetime = jiffies;
> @@ -1644,6 +1649,8 @@ xfsbufd_wakeup(
>  	list_for_each_entry(btp, &xfs_buftarg_list, bt_list) {
>  		if (test_bit(XBT_FORCE_SLEEP, &btp->bt_flags))
>  			continue;
> +		if (list_empty(&btp->bt_delwrite_queue))
> +			continue;
>  		set_bit(XBT_FORCE_FLUSH, &btp->bt_flags);
>  		wake_up_process(btp->bt_task);
>  	}
> @@ -1708,6 +1715,9 @@ xfsbufd(
>  	set_freezable();
> 
>  	do {
> +		long	age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
> +		long	tout = age;

Why do you switch from using xfs_buf_timer_centisecs to
using xfs_buf_age_centisecs for the timeout (in the non-empty
delwrite queue case)?


> +
>  		if (unlikely(freezing(current))) {
>  			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
>  			refrigerator();
> @@ -1715,12 +1725,12 @@ xfsbufd(
>  			clear_bit(XBT_FORCE_SLEEP, &target->bt_flags);
>  		}
> 
> -		schedule_timeout_interruptible(
> -			xfs_buf_timer_centisecs * msecs_to_jiffies(10));

Here is where the timeout was computed previously.

> -
> -		xfs_buf_delwri_split(target, &tmp,
> -				xfs_buf_age_centisecs * msecs_to_jiffies(10));
> +		/* sleep for a long time if there is nothing to do. */
> +		if (list_empty(&target->bt_delwrite_queue))
> +			tout = MAX_SCHEDULE_TIMEOUT;

Effect of the timout change is here...

> +		schedule_timeout_interruptible(tout);
> 
> +		xfs_buf_delwri_split(target, &tmp, age);
>  		count = 0;
>  		while (!list_empty(&tmp)) {
>  			bp = list_entry(tmp.next, xfs_buf_t, b_list);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
