Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 598748008
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 13:39:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CEC78F8050
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 11:39:51 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	W9kXjdgIpCKzhSsu for <xfs@oss.sgi.com>;
	Mon, 02 Feb 2015 11:39:48 -0800 (PST)
Date: Tue, 3 Feb 2015 06:39:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: use generic percpu counters for free block
	counter
Message-ID: <20150202193947.GM6282@dastard>
References: <1422826983-29570-1-git-send-email-david@fromorbit.com>
	<1422826983-29570-5-git-send-email-david@fromorbit.com>
	<20150202171133.GD6096@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202171133.GD6096@laptop.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 02, 2015 at 12:11:33PM -0500, Brian Foster wrote:
> On Mon, Feb 02, 2015 at 08:43:02AM +1100, Dave Chinner wrote:
> > +		/*
> > +		 * Taking blocks away, need to be more accurate the closer we
> > +		 * are to zero.
> > +		 *
> > +		 * batch size is set to a maximum of 1024 blocks - if we are
> > +		 * allocating of freeing extents larger than this then we aren't
> > +		 * going to be hammering the counter lock so a lock per update
> > +		 * is not a problem.
> > +		 *
> 
> IIUC, the batch size determines the point at which the local cpu delta
> is folded back into the global counter (under lock). If we're allocating
> large extents, these will surpass the batch size and result in a locked
> update. Smaller updates are aggregated into the cpu counter and folded
> in at some later time.

Right.

> > +		 * If the counter has a value of less than 2 * max batch size,
> > +		 * then make everything serialise as we are real close to
> > +		 * ENOSPC.
> > +		 */
> > +#define __BATCH	1024
> > +		if (percpu_counter_compare(&mp->m_sb.sb_fdblocks,
> > +					   2 * __BATCH) < 0)
> > +			batch = 1;
> > +		else
> > +			batch = __BATCH;
> > +
> 
> The general approach seems logical. I do wonder whether blocks is the
> right scale as opposed to block count normalized against some fixed I/O
> size (to account for different block sizes).

We allocate in blocks, so the IO size is really irrelevant. The
scalability issue at hand is page-by-page space reservation during
delayed allocation, so really the block size makes less difference
to performance than the page size....

> Also, it seems like speculative preallocation could hide some of the
> overhead here, depending on workload of course. Had that factored into
> your testing?

Yes, somewhat, though I shuld do some testing using 4k direct IO and
buffered IO with allocsize set appropriately.

> 
> > +		__percpu_counter_add(&mp->m_sb.sb_fdblocks, delta, batch);
> > +		if (percpu_counter_compare(&mp->m_sb.sb_fdblocks,
> > +					   XFS_ALLOC_SET_ASIDE(mp)) >= 0) {
> > +			/* we had space! */
> > +			return 0;
> >  		}
> >  
> > -		mp->m_sb.sb_fdblocks = lcounter + XFS_ALLOC_SET_ASIDE(mp);
> > -		return 0;
> > +		/*
> > +		 * lock up the sb for dipping into reserves before releasing
> > +		 * the space that took us to ENOSPC.
> > +		 */
> > +		spin_lock(&mp->m_sb_lock);
> 
> Can you elaborate on the locking here, why it's needed where it wasn't
> before?

The lock protects the reserved pool. And it was used before as the
only time we called into this function was with the m_sb_lock held.
this is a bit of a hack because we now call into the function
without the lock held....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
