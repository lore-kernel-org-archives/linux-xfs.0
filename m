Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBFN5fg5026638 for <xfs@oss.sgi.com>; Thu, 15 Dec 2011 17:05:42 -0600
Date: Thu, 15 Dec 2011 17:06:05 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: remove unused XBT_FORCE_SLEEP bit
Message-ID: <20111215230605.GN29840@sgi.com>
References: <4EE7DBED.8090600@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EE7DBED.8090600@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Dec 13, 2011 at 05:12:45PM -0600, Eric Sandeen wrote:
> XBT_FORCE_SLEEP is no longer ever tested; it is only set
> and cleared.  Remove it.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Yep... looks like XBT_FORCE_SLEEP is never tested.
Reviewed-by: Ben Myers <bpm@sgi.com>

> ---
> 
> p.s. I left bt_flags as a bitfield even with only one bit defined now... OK?
> 
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index 5e68099..f7830c3 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1762,12 +1762,8 @@ xfsbufd(
>  		struct list_head tmp;
>  		struct blk_plug plug;
>  
> -		if (unlikely(freezing(current))) {
> -			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
> +		if (unlikely(freezing(current)))
>  			refrigerator();
> -		} else {
> -			clear_bit(XBT_FORCE_SLEEP, &target->bt_flags);
> -		}
>  
>  		/* sleep for a long time if there is nothing to do. */
>  		if (list_empty(&target->bt_delwrite_queue))
> diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
> index 50a7d5f..1b4aec1 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.h
> +++ b/fs/xfs/linux-2.6/xfs_buf.h
> @@ -87,8 +87,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
>  
>  typedef enum {
> -	XBT_FORCE_SLEEP = 0,
> -	XBT_FORCE_FLUSH = 1,
> +	XBT_FORCE_FLUSH = 0,
>  } xfs_buftarg_flags_t;
>  
>  typedef struct xfs_bufhash {
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
