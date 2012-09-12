Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8C3LaMU190896 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 22:21:36 -0500
Received: from labridge.com (perches-mx.perches.com [206.117.179.246]) by
	cuda.sgi.com with ESMTP id FmyfP9w7iN57E0Sz (version=SSLv3
	cipher=DES-CBC3-SHA bits=168 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Sep 2012 20:22:40 -0700 (PDT)
Message-ID: <1347420159.2456.15.camel@joe2Laptop>
Subject: Re: [PATCH 1/3] Add ratelimited printk for different alert levels
From: Joe Perches <joe@perches.com>
Date: Tue, 11 Sep 2012 20:22:39 -0700
In-Reply-To: <ef779779fdfb84c7c1216b374216246d4de83233.1347396641.git.rprabhu@wnohang.net>
References: <cover.1347396641.git.rprabhu@wnohang.net>
	<ef779779fdfb84c7c1216b374216246d4de83233.1347396641.git.rprabhu@wnohang.net>
Mime-Version: 1.0
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
Cc: Alex Elder <elder@kernel.org>, Ben Myers <bpm@sgi.com>, open list <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Raghavendra D Prabhu <rprabhu@wnohang.net>

On Wed, 2012-09-12 at 03:43 +0530, raghu.prabhu13@gmail.com wrote:
> Ratelimited printk will be useful in printing xfs messages which are otherwise
> not required to be printed always due to their high rate (to prevent kernel ring
> buffer from overflowing), while at the same time required to be printed.
[]
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
[]
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

It might be better to use an xfs singleton RATELIMIT_STATE

DEFINE_RATELIMIT_STATE(xfs_rs);
...
#define xfs_printk_ratelimited(xfs_printk, dev, fmt, ...)		\
do {									\
	if (__ratelimit(&xfs_rs))					\
		xfs_printk(dev, fmt, ##__VA_ARGS__);			\
} while (0)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
