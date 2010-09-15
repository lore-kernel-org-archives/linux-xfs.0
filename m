Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8FKIeDN209156 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 15:18:41 -0500
Subject: Re: [PATCH 16/18] xfs: convert xfsbud shrinker to a per-buftarg
	shrinker.
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1284461777-1496-17-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-17-git-send-email-david@fromorbit.com>
Date: Wed, 15 Sep 2010 15:19:27 -0500
Message-ID: <1284581967.2452.25.camel@doink>
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

On Tue, 2010-09-14 at 20:56 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Before we introduce per-buftarg LRU lists, split the shrinker
> implementation into per-buftarg shrinker callbacks. At the moment
> we wake all the xfsbufds to run the delayed write queues to free
> the dirty buffers and make their pages available for reclaim.
> However, with an LRU, we want to be able to free clean, unused
> buffers as well, so we need to separate the xfsbufd from the
> shrinker callbacks.

I have one comment/question embedded below.

Your new shrinker is better than the old one (and would
have been even if you didn't make them per-buftarg).
It doesn't initiate flushing when it's passed 0 for
nr_to_scan (though to be honest I'm not sure what
practical effect that will have).

In any case...

Reviewed-by: Alex Elder <aelder@sgi.com>


> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |   89 ++++++++++++--------------------------------
>  fs/xfs/linux-2.6/xfs_buf.h |    4 +-
>  2 files changed, 27 insertions(+), 66 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index cce427d..3b54fee 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c

. . .

> @@ -337,7 +332,6 @@ _xfs_buf_lookup_pages(
>  					__func__, gfp_mask);
>  
>  			XFS_STATS_INC(xb_page_retries);
> -			xfsbufd_wakeup(NULL, 0, gfp_mask);

Why is it OK not to wake up the shrinker(s) here
now, when it was called for previously?

>  			congestion_wait(BLK_RW_ASYNC, HZ/50);
>  			goto retry;
>  		}

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
