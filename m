Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23758 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932131AbeCBV4v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 16:56:51 -0500
Date: Sat, 3 Mar 2018 08:56:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't retry xfs_buf_find on XBF_TRYLOCK failure
Message-ID: <20180302215648.GS30854@dastard>
References: <20180301223632.28742-1-david@fromorbit.com>
 <20180302173722.GU19312@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180302173722.GU19312@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Mar 02, 2018 at 09:37:22AM -0800, Darrick J. Wong wrote:
> On Fri, Mar 02, 2018 at 09:36:32AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When looking at an event trace recently, I noticed that non-blocking
> > buffer lookup attempts would fail on cached locked buffers and then
> > run the slow cache-miss path. This means we are doing an xfs_buf
> > allocation, lookup and free unnecessarily every time we avoid
> > blocking on a locked buffer.
> > 
> > Fix this by changing _xfs_buf_find() to return an error status
> > encoded via ERR_PTR() to the caller to indicate that we failed the
> > lock attempt rather than just returning a NULL. This allows the
> > higher level code to discriminate between a cache miss and an cache
> > hit that we failed to lock.
> > 
> > This also allows us to return a -EFSCORRUPTED state if we are asked
> > to look up a block number outside the range of the filesystem in
> > _xfs_buf_find(), which moves us one step closer to being able to
> > handle such errors in a more graceful manner at the higher levels.
> > 
> > Finally, to ensure code outside the buffer cache does not see any
> > change, convert external callers to use xfs_incore() and change that
> > to an inline function that maintains the old "buffer or NULL" return
> > values so the external code doesn't need to care about this internal
> > change to _xfs_buf_find() semantics.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > @@ -666,9 +673,28 @@ xfs_buf_get_map(
> >  	int			error = 0;
> >  
> >  	bp = _xfs_buf_find(target, map, nmaps, flags, NULL);
> > -	if (likely(bp))
> > +	if (!IS_ERR_OR_NULL(bp))
> >  		goto found;
> >  
> > +	switch (PTR_ERR(bp)) {
> > +		case 0:
> > +			/* cache miss, need to insert new buffer */
> > +			break;
> > +
> > +		case -EAGAIN:
> > +			/* cache hit, trylock failure, caller handles failure */
> > +			ASSERT(flags & XBF_TRYLOCK);
> > +			return NULL;
> > +
> > +		case -EFSCORRUPTED:
> > +		default:
> > +			/*
> > +			 * None of the higher layers understand failure types
> > +			 * yet, so return NULL to signal a fatal lookup error.
> > +			 */
> > +			return NULL;
> 
> Should I expect a follow-on patch to fix the higher layers?

Not immediately. There's much larger quantity of code affected by
pushing it another layer up, and that's way outside the scope of
fixing this inefficiency. I've just fixed this layer in a way that
moves us towards being able to report more accurate failures higher
up without changing the current status quo...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
