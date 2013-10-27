Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 248C67F3F
	for <xfs@oss.sgi.com>; Sun, 27 Oct 2013 04:04:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98F70AC004
	for <xfs@oss.sgi.com>; Sun, 27 Oct 2013 02:04:16 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	pQuFVcDg3Lg70Daj for <xfs@oss.sgi.com>;
	Sun, 27 Oct 2013 02:04:14 -0700 (PDT)
Date: Sun, 27 Oct 2013 20:04:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: prevent stack overflows from page cache allocation
Message-ID: <20131027090409.GA2797@dastard>
References: <1382585110-1796-1-git-send-email-david@fromorbit.com>
	<20131024084803.GA28144@infradead.org>
	<20131024103751.GS2797@dastard>
	<20131024154220.GA19055@infradead.org>
	<20131024164115.GU1935@sgi.com> <20131024212448.GW2797@dastard>
	<20131025112934.GA1585@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131025112934.GA1585@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Fri, Oct 25, 2013 at 04:29:34AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 25, 2013 at 08:24:48AM +1100, Dave Chinner wrote:
> > > > I'd much prefer aiming for the proper fix first.  If for some reason we
> > > > can't get it done in time the workaround can be applied.
> > > 
> > > Dave probably has a customer waiting on this.
> > 
> > Obviously. And being a kernel where we have a fixed ABI, we can't
> > backport any fix that changes core code.
> 
> No one is trying to tell you what to ship to your customers.  That
> doesn't mean we should aim for the right fix upstream.

Have you looked at the page cache allocation code recently? e.g,
grab_cache_page_write_begin(), which we pass AOP_FLAG_NOFS into to
prevent direct reclaim deadlocks:

        gfp_mask = mapping_gfp_mask(mapping);
        if (mapping_cap_account_dirty(mapping))
                gfp_mask |= __GFP_WRITE;
        if (flags & AOP_FLAG_NOFS)
                gfp_notmask = __GFP_FS;

See? The gfp mask that is used for allocation is directly based on
the gfp mask that is set on the mapping. With this patch I proposed,
we can remove the all the AOP_FLAG_NOFS usage because it's
redundant.  IOWs, the mapping alread has the correct allocation
context set on it for *all* mapping based allocations without having
to add and pass magic flags to various interfaces to get it to do
the right thing.

> I don't really mind pushing patches like yours as a last resort when
> dealing with unrepsonsive or disagreeing maintainers like we had to do
> in the past, but trying to push the workaround without even attemping
> the proper fix is a bit sad.

The page cache infrastructure (i.e. the generic VFS code) is already
set up to be used in this manner, and other filesystems use it in
this way where they need to as well. So, really, I'm not sure what
problem you think needs solving here.

Indeed, I'm not even sure yet how this would be "fixed" in the VFS
code.  Passing AOP_FLAG_NOFS several functions deep to get it into
ra_submit or the low level splice functions is a non-starter, so the
context needs to be carried by something else. That's exactly what
the per-mapping gfp mask does...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
