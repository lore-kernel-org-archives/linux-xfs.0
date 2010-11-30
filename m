Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAU4aFFc028651 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 22:36:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8B101B4848
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 20:37:56 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	HhcfKInUhKFscbia for <xfs@oss.sgi.com>;
	Mon, 29 Nov 2010 20:37:56 -0800 (PST)
Date: Tue, 30 Nov 2010 15:37:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: use generic per-cpu counter infrastructure
Message-ID: <20101130043741.GD3556@dastard>
References: <1290991002-18680-1-git-send-email-david@fromorbit.com>
	<1290991002-18680-3-git-send-email-david@fromorbit.com>
	<20101129091610.GA13902@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101129091610.GA13902@infradead.org>
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
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 29, 2010 at 04:16:10AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 29, 2010 at 11:36:40AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > XFS has a per-cpu counter implementation for in-core superblock
> > counters that pre-dated the generic implementation. It is complex
> > and baroque as it is tailored directly to the needs of ENOSPC
> > detection.
> > 
> > Now that the generic percpu counter infrastructure has the
> > percpu_counter_add_unless_lt() function that implements the
> > necessary threshold checks for us, switch the XFS per-cpu
> > superblock counters to use the generic percpu counter
> > infrastructure.
> 
> Looks good, but a few comments below:
> 
> > +/*
> > + * Per-cpu incore superblock counters
> > + *
> > + * Simple concept, difficult implementation, now somewhat simplified by generic
> > + * per-cpu counter support.  This provides distributed per cpu counters for
> > + * contended fields (e.g.  free block count).
> 
> The kind of historic comments like now simplified by  .. don't make any
> sense after only a short while.  I'd just remove the first senstence
> above, as the details of the problems are explained much better later.

Ok, will do.
> 
> > +static inline int
> > +xfs_icsb_add(
> > +	struct xfs_mount	*mp,
> > +	int			counter,
> > +	int64_t			delta,
> > +	int64_t			threshold)
> > +{
> > +	int			ret;
> > +
> > +	ret = percpu_counter_add_unless_lt(&mp->m_icsb[counter], delta,
> > +								threshold);
> > +	if (ret < 0)
> > +		return -ENOSPC;
> > +	return 0;
> > +}
> > +
> > +static inline void
> > +xfs_icsb_set(
> > +	struct xfs_mount	*mp,
> > +	int			counter,
> > +	int64_t			value)
> > +{
> > +	percpu_counter_set(&mp->m_icsb[counter], value);
> > +}
> > +
> > +static inline int64_t
> > +xfs_icsb_sum(
> > +	struct xfs_mount	*mp,
> > +	int			counter)
> > +{
> > +	return percpu_counter_sum_positive(&mp->m_icsb[counter]);
> > +}
> 
> I still don't like these wrappers.  They are all local to xfs_mount.c,
> and only have a single function calling them.  See the RFC patch below
> which removes them, and imho makes the code more readable.  Especially
> in xfs _add case where we can get rid of one level of error remapping,
> and go directly from the weird percpu return values to the positive
> xfs errors instead of doing a detour via the negative linux errors.

Ok, if we need to tweak the batch size in future, then we can deal
with it then. I'll clean it up as you suggest...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
