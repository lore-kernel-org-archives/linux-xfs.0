Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ONjbr4138666 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 17:45:38 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0B5E28D1B5
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 15:47:59 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GPtqYLzYgq2eaCwA for <xfs@oss.sgi.com>;
	Mon, 24 Jan 2011 15:47:59 -0800 (PST)
Date: Tue, 25 Jan 2011 10:47:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] libxlog: sync up with 2.6.38 kernel code
Message-ID: <20110124234741.GF11040@dastard>
References: <1294649091-27174-1-git-send-email-david@fromorbit.com>
	<1294649091-27174-3-git-send-email-david@fromorbit.com>
	<20110124084732.GA4378@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110124084732.GA4378@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jan 24, 2011 at 03:47:32AM -0500, Christoph Hellwig wrote:
> > +typedef	int32_t	atomic_t;
> > +typedef	int64_t	atomic64_t;
> > +
> > +#define atomic_inc_return(x)	(++(*(x)))
> > +#define atomic_dec_return(x)	(--(*(x)))
> > +
> > +#define atomic64_read(x)	*(x)
> > +#define atomic64_set(x, v)	(*(x) = v)
> 
> These defintions are pretty dangerous if we ever happens to use
> them in multi-threaded code like repair.   Currently we're not,
> but they should grow a larger warning comment.

Ok, I'll add a warning to that effect.

> > --- /dev/null
> > +++ b/include/hlist.h
> 
> Why not add the hlist helpers to list.h, like in the kernel tree?

It was just a side effect of the process I followed to add the bits
of missing functionality that were needed. I can add it to list.h if
you want, but I don't think it really matters either way...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
