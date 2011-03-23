Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2NMjDMH120242 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 17:45:18 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3269D3714C2
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 15:48:13 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	WJyRTWCBu3HQ6NsQ for <xfs@oss.sgi.com>;
	Wed, 23 Mar 2011 15:48:13 -0700 (PDT)
Date: Thu, 24 Mar 2011 09:48:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: outstanding patches for 2.6.39
Message-ID: <20110323224810.GE26611@dastard>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<m24o6u48xu.fsf@firstfloor.org> <20110323113803.GB26611@dastard>
	<20110323160515.GF21838@one.firstfloor.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110323160515.GF21838@one.firstfloor.org>
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
To: Andi Kleen <andi@firstfloor.org>
Cc: aelder@sgi.com, xfs@oss.sgi.com

On Wed, Mar 23, 2011 at 05:05:15PM +0100, Andi Kleen wrote:
> > We can't do that right now, anyway.
> 
> It seemed to work on XFS when we tested it. Undoutedly after your
> patch it won't work anymore.

And why? We still have exactly the same nuumber of active buffers as
before this patch, so exactly the same number of pages that you
simply can't replace

> > If the page is not in use, we don't care about it after this patch
> > set is applied - the page is either active in a buffer or it has been
> > freed. If it is in use, then we'll shut the filesystem down if we
> > detect the memory corruption just like we currently do. Hence I
> > don't see any regression here.
> 
> I think you're confusing the memory_failure() HWPoison path with some XFS
> internal checking. I don't think XFS has any HWPoison checking on its own.

No, it doesn't. My point is that you can't tear down an active page
in a buffer without causing in memory corruption that XFS will notice.

That is, the old lifecycle is:

	alloc buffer
	alloc page cache page
	attach page to buffer	(active reference)
	use buffer
	....
	buffer placed on buffer LRU
	....
	buffer reclaimed by shrinker
	page left in page cache LRU (no active reference)
	.....
	page removed from LRU by memory reclaim


During the time that there is an active reference, an uncorrectable
memory error will corrupt the contents of the buffer. The
memory_failure() path sets flags on the page (page error) and the
mapping, and then tries to invalidate the page in the mapping, which
may or may not fail. Either way, we still has an active reference to
the page so we'll continue to use it regardless of the fact that the
page has been poisoned. IOWs, it does not work at all for errors in
active metadata buffers on XFS and such memory errors will end up
with filesystem metadata corruption.

If the page has no active buffers, then it is in the LRU, and
invalidating the page will work just fine to remove it from the
cache.

The new lifecycle is:

	alloc buffer
	alloc page
	attach page to buffer (active reference)
	use buffer
	....
	buffer placed on buffer LRU
	....
	buffer reclaimed by shrinker
	free page (no reference at all)

IOWs, the page attached to the buffer is only ever in the active
state now, which is the case for the existing code where the error
propagation simply does not work. And instead of leaving the page
on the LRU when the buffer is no longer active, we free it back to
the allocator and errors in freed pages are handled just fine by the
existing code (just like LRU pages).


> > As it is, there is no way for the filesytem to be notified about
> > such failures on active pages in buffers, so in reality we can't
> > reliably detect them so there is little point in trying to recover
> > from such errors.
> 
> Well it works today if the page is in pagecache. memory-failure will
> just remove it transparently.

It's not transparent as it requires help from the layer above the
page cache to handle errors on pages correctly (i.e. the
error_remove_page callback). That special handling is completely
missing from the XFS buffer cache regardless of whether we use the
page cache or not.

> In principle you can check for HWPoison manually yourself, but I'm not sure
> that is a good way to do it.

It'd require a custom callback from memory_failure() and a bunch
of restructing to be able to map a page back to the owner buffer
efficiently and then tearing down the buffer (clean case) or
shutting down the filesystem (dirty case).  If we wait for a check
of the page state to catch such an error rather than trigger an
immediate filesysetm shutdown, then it is too late because we've
could have either written the bad memory onto disk (either via a
transaction into the log or via buffer writeback) and so we will
have propagated the memory error onto disk...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
