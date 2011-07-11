Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6BBAksp217520 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 06:10:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9CB75527DA4
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 04:10:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	TohOV8WcA0E8Ef36 for <xfs@oss.sgi.com>;
	Mon, 11 Jul 2011 04:10:45 -0700 (PDT)
Date: Mon, 11 Jul 2011 07:10:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/27] xfs: use write_cache_pages for writeback clustering
Message-ID: <20110711111039.GA3139@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.950805096@bombadil.infradead.org>
	<20110701022248.GM561@dastard> <20110701041851.GN561@dastard>
	<20110701093305.GA28531@infradead.org>
	<20110701154136.GA17881@localhost> <20110704032534.GD1026@dastard>
	<20110705143409.GB15285@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110705143409.GB15285@suse.de>
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
To: Mel Gorman <mgorman@suse.de>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Tue, Jul 05, 2011 at 03:34:10PM +0100, Mel Gorman wrote:
> > However, what I'm questioning is whether we should even care what
> > page memory reclaim wants to write - it seems to make fundamentally
> > bad decisions from an IO persepctive.
> > 
> 
> It sucks from an IO perspective but from the perspective of the VM that
> needs memory to be free in a particular zone or node, it's a reasonable
> request.

It might appear reasonable, but it's not.

What the VM wants underneath is generally (1):

 - free N pages in zone Z

and it then goes own to free the pages one one by one though kswapd,
which leads to freeing those N pages, but unless they already were
clean it will take very long to get there and bog down the whole
system.

So we need a better way to actually perform that underlying request.
Dave's suggestion of keeping different lists for clean vs dirty pages
in the VM and preferably reclaiming for the clean ones when having
zone pressure is one first step.  The second one will be to tell the
writeback threads to preferably reclaim from a zone.  I'm actually
not sure how do that yet, as we could have memory from different
zones on a single inode.  Taking an inode that has memory from the
right zone and the writing that out will probably work fine for
different zones in a 64-bit NUMA systems where zones more or less
equal nodes.  It probably won't work very well if we need to free
up memory in the various low memory zones, as those will be spread
over random inodes.

> It doesnt' check how many pages are under writeback. Direct reclaim
> will check if the block device is congested but that is about
> it. Otherwise the expectation was the elevator would handle the
> merging of requests into a sensible patter.

It can't.  The elevator has a relatively small window it can operate
on, and can never fix up a bad large scale writeback pattern. 

> Also, while filesystem
> pages are getting cleaned by flushs, that does not cover anonymous
> pages being written to swap.

At least for now we will have to keep kswapd writeback for swap.  It
is just as inefficient a on a filesystem, but given that people don't
rely on swap performance we can probably live with it.  Note that we
can't simply use background flushing for swap, as that would mean
we'd need backing space allocated for all main memory, which isn't
very practical with todays memory sized.  The whole concept of demand
paging anonymous memory leads to pretty bad I/O patterns.  If you're
actually making heavy use of it the old-school unix full process paging
would be a lot faster.

(1) moulo things like compaction

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
