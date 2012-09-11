Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8BMgaHo166378 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 17:42:36 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mE90NOEAzIDk4rJW for <xfs@oss.sgi.com>;
	Tue, 11 Sep 2012 15:43:39 -0700 (PDT)
Date: Wed, 12 Sep 2012 08:43:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] Add ratelimited printk for different alert levels
Message-ID: <20120911224337.GF11511@dastard>
References: <cover.1347396641.git.rprabhu@wnohang.net>
	<ef779779fdfb84c7c1216b374216246d4de83233.1347396641.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ef779779fdfb84c7c1216b374216246d4de83233.1347396641.git.rprabhu@wnohang.net>
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
To: raghu.prabhu13@gmail.com
Cc: open list <linux-kernel@vger.kernel.org>, Raghavendra D Prabhu <rprabhu@wnohang.net>, Alex Elder <elder@kernel.org>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Wed, Sep 12, 2012 at 03:43:22AM +0530, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> Ratelimited printk will be useful in printing xfs messages which are otherwise
> not required to be printed always due to their high rate (to prevent kernel ring
> buffer from overflowing), while at the same time required to be printed.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> ---
>  fs/xfs/xfs_message.h | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index 56dc0c1..87999a5 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -1,6 +1,8 @@
>  #ifndef __XFS_MESSAGE_H
>  #define __XFS_MESSAGE_H 1
>  
> +#include <linux/ratelimit.h>
> +

Include this in xfs_linux.h rather than here.

>  struct xfs_mount;
>  
>  extern __printf(2, 3)
> @@ -30,6 +32,32 @@ void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
>  }
>  #endif
>  
> +#define xfs_printk_ratelimited(xfs_printk, dev, fmt, ...)		\
> +do {									\
> +	static DEFINE_RATELIMIT_STATE(_rs,				\
> +				      DEFAULT_RATELIMIT_INTERVAL,	\
> +				      DEFAULT_RATELIMIT_BURST);		\
> +	if (__ratelimit(&_rs))						\
> +		xfs_printk(dev, fmt, ##__VA_ARGS__);			\
> +} while (0)

Use "func" not xfs_printk here. xfs_printk looks too much like a
real function name (indeed, we already have __xfs_printk) rather
than a macro parameter.

> +#define xfs_emerg_ratelimited(dev, fmt, ...)				\
> +	xfs_printk_ratelimited(xfs_emerg, dev, fmt, ##__VA_ARGS__)
> +#define xfs_alert_ratelimited(dev, fmt, ...)				\
> +	xfs_printk_ratelimited(xfs_alert, dev, fmt, ##__VA_ARGS__)
> +#define xfs_crit_ratelimited(dev, fmt, ...)				\
> +	xfs_printk_ratelimited(xfs_crit, dev, fmt, ##__VA_ARGS__)
> +#define xfs_err_ratelimited(dev, fmt, ...)				\
> +	xfs_printk_ratelimited(xfs_err, dev, fmt, ##__VA_ARGS__)
> +#define xfs_warn_ratelimited(dev, fmt, ...)				\
> +	xfs_printk_ratelimited(xfs_warn, dev, fmt, ##__VA_ARGS__)
> +#define xfs_notice_ratelimited(dev, fmt, ...)				\
> +	xfs_printk_ratelimited(xfs_notice, dev, fmt, ##__VA_ARGS__)
> +#define xfs_info_ratelimited(dev, fmt, ...)				\
> +	xfs_printk_ratelimited(xfs_info, dev, fmt, ##__VA_ARGS__)
> +#define xfs_dbg_ratelimited(dev, fmt, ...)				\
> +	xfs_printk_ratelimited(xfs_dbg, dev, fmt, ##__VA_ARGS__)

Here's the problem with adding macros that aren't used. xfs_dbg
does not exist - the function is xfs_debug(). The compiler won't
catch that until the macro is used, so only add the macros which are
needed for this patch series.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
