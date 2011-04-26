Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3QKhHu5181869 for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 15:43:17 -0500
Subject: Re: [PATCH] xfs: Remove duplicate XFS from xfs_alert_tag, neatening
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <59d707d5d1bc37ef3a08fdd23c8e1fe72fa55fbb.1303419931.git.joe@perches.com>
References: <59d707d5d1bc37ef3a08fdd23c8e1fe72fa55fbb.1303419931.git.joe@perches.com>
Date: Tue, 26 Apr 2011 15:46:45 -0500
Message-ID: <1303850805.2080.164.camel@doink>
MIME-Version: 1.0
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
To: Joe Perches <joe@perches.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-04-21 at 14:08 -0700, Joe Perches wrote:
> The xfs_printk in xfs_alert_tag doesn't need an XFS: prefix
> as it's added by xfs_printk.
> 
> Add format checking to the non-debug inline function xfs_debug.
> Miscellaneous function prototype argument alignment.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

This seems like three very minor changes, but I actually
have something to say about each...

> ---
>  fs/xfs/linux-2.6/xfs_message.c |    3 +--
>  fs/xfs/linux-2.6/xfs_message.h |    5 +++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_message.c b/fs/xfs/linux-2.6/xfs_message.c
> index 9f76cce..e894ab2 100644
> --- a/fs/xfs/linux-2.6/xfs_message.c
> +++ b/fs/xfs/linux-2.6/xfs_message.c
> @@ -95,8 +95,7 @@ xfs_alert_tag(
>  	int			do_panic = 0;
>  
>  	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) {
> -		xfs_printk(KERN_ALERT, mp,
> -			"XFS: Transforming an alert into a BUG.");
> +		xfs_alert(mp, "Transforming an alert into a BUG.");
>  		do_panic = 1;
>  	}
>  

I'll highlight the fact that this was the last caller of
xfs_printk().  As such I think it should just be eliminated,
and make the use of xfs_info() or xfs_debug() mandatory.
They are clean, easy, and have meaningful enough names
that this should be fine.  (What do others think?)

> diff --git a/fs/xfs/linux-2.6/xfs_message.h b/fs/xfs/linux-2.6/xfs_message.h
> index f1b3fc1..c11f415 100644
> --- a/fs/xfs/linux-2.6/xfs_message.h
> +++ b/fs/xfs/linux-2.6/xfs_message.h
> @@ -11,7 +11,7 @@ extern void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...)
>  extern void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...)
>          __attribute__ ((format (printf, 2, 3)));
>  extern void xfs_alert_tag(const struct xfs_mount *mp, int tag,
> -			 const char *fmt, ...)
> +			  const char *fmt, ...)

This is a silly white space change, and I guess I don't care
either way.  But I think much of the XFS code tab-aligns
things that wrap to successive lines.

>          __attribute__ ((format (printf, 3, 4)));
>  extern void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...)
>          __attribute__ ((format (printf, 2, 3)));
> @@ -28,7 +28,8 @@ extern void xfs_info(const struct xfs_mount *mp, const char *fmt, ...)
>  extern void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
>          __attribute__ ((format (printf, 2, 3)));
>  #else
> -static inline void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
> +static inline __attribute__ ((format (printf, 2, 3)))
> +void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
>  {
>  }
>  #endif

How about:

static inline void
__attribute__ ((format (printf, 2, 3)))
xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
{
}




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
