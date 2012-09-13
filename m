Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8D0oFgf075647 for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 19:50:15 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	xTDvKyqVGJfcCusV for <xfs@oss.sgi.com>;
	Wed, 12 Sep 2012 17:51:20 -0700 (PDT)
Date: Thu, 13 Sep 2012 10:51:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] Add ratelimited printk for different alert levels
Message-ID: <20120913005112.GK11511@dastard>
References: <cover.1347396641.git.rprabhu@wnohang.net>
	<ef779779fdfb84c7c1216b374216246d4de83233.1347396641.git.rprabhu@wnohang.net>
	<1347420159.2456.15.camel@joe2Laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1347420159.2456.15.camel@joe2Laptop>
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
Cc: Alex Elder <elder@kernel.org>, Ben Myers <bpm@sgi.com>, open list <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Raghavendra D Prabhu <rprabhu@wnohang.net>, raghu.prabhu13@gmail.com

On Tue, Sep 11, 2012 at 08:22:39PM -0700, Joe Perches wrote:
> On Wed, 2012-09-12 at 03:43 +0530, raghu.prabhu13@gmail.com wrote:
> > Ratelimited printk will be useful in printing xfs messages which are otherwise
> > not required to be printed always due to their high rate (to prevent kernel ring
> > buffer from overflowing), while at the same time required to be printed.
> []
> > diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> []
> > @@ -30,6 +32,32 @@ void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
> >  }
> >  #endif
> >  
> > +#define xfs_printk_ratelimited(xfs_printk, dev, fmt, ...)		\
> > +do {									\
> > +	static DEFINE_RATELIMIT_STATE(_rs,				\
> > +				      DEFAULT_RATELIMIT_INTERVAL,	\
> > +				      DEFAULT_RATELIMIT_BURST);		\
> > +	if (__ratelimit(&_rs))						\
> > +		xfs_printk(dev, fmt, ##__VA_ARGS__);			\
> > +} while (0)
> 
> It might be better to use an xfs singleton RATELIMIT_STATE
> 
> DEFINE_RATELIMIT_STATE(xfs_rs);
> ...
> #define xfs_printk_ratelimited(xfs_printk, dev, fmt, ...)		\
> do {									\
> 	if (__ratelimit(&xfs_rs))					\
> 		xfs_printk(dev, fmt, ##__VA_ARGS__);			\
> } while (0)

Which would then result in ratelimiting dropping potentially
important, unique messages. I think it's much better to guarantee
ratelimited messages get emitted at least once, especially as there
is the potential for multiple filesystems to emit messages
simultaneously.

I think per-location rate limiting is fine for the current usage -
ratelimiting is not widespread so there isn't a massive increase in
size as a result of this. If we do start to use ratelimiting in lots
of places in XFS, then we might have to revisit this, but it's OK
for now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
