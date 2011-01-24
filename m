Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0O8jCBY071522 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 02:45:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80C6915467E6
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 00:47:34 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JIspyX1RyGWPgatt for
	<xfs@oss.sgi.com>; Mon, 24 Jan 2011 00:47:34 -0800 (PST)
Date: Mon, 24 Jan 2011 03:47:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] libxlog: sync up with 2.6.38 kernel code
Message-ID: <20110124084732.GA4378@infradead.org>
References: <1294649091-27174-1-git-send-email-david@fromorbit.com>
	<1294649091-27174-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294649091-27174-3-git-send-email-david@fromorbit.com>
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

> +typedef	int32_t	atomic_t;
> +typedef	int64_t	atomic64_t;
> +
> +#define atomic_inc_return(x)	(++(*(x)))
> +#define atomic_dec_return(x)	(--(*(x)))
> +
> +#define atomic64_read(x)	*(x)
> +#define atomic64_set(x, v)	(*(x) = v)

These defintions are pretty dangerous if we ever happens to use
them in multi-threaded code like repair.   Currently we're not,
but they should grow a larger warning comment.

> --- /dev/null
> +++ b/include/hlist.h

Why not add the hlist helpers to list.h, like in the kernel tree?

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
