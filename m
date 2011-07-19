Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6J1Ourh138008 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 20:24:57 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB4DF1E65081
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 18:24:54 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	N4iKwXsnEMSwTCUO for <xfs@oss.sgi.com>;
	Mon, 18 Jul 2011 18:24:54 -0700 (PDT)
Date: Tue, 19 Jul 2011 11:24:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: introduce an allocation workqueue
Message-ID: <20110719012450.GG30254@dastard>
References: <1310960989-10284-1-git-send-email-david@fromorbit.com>
	<1310960989-10284-2-git-send-email-david@fromorbit.com>
	<20110718160046.GA14094@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110718160046.GA14094@infradead.org>
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

On Mon, Jul 18, 2011 at 12:00:46PM -0400, Christoph Hellwig wrote:
> On Mon, Jul 18, 2011 at 01:49:47PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We currently have significant issues with the amount of stack that
> > allocation in XFS uses, especially in the writeback path. We can
> > easily consume 4k of stack between mapping the page, manipulating
> > the bmap btree and allocating blocks from the free list. Not to
> > mention btree block readahead and other functionality that issues IO
> > in the allocation path.
> > 
> > As a result, we can no longer fit allocation in the writeback path
> > in the stack space provided on x86_64. To alleviate this problem,
> > introduce an allocation workqueue and move all allocations to a
> > seperate context. This can be easily added as an interposing layer
> > into xfs_alloc_vextent(), which takes a single argument structure
> > and does not return until the allocation is complete or has failed.
> 
> I've mentioned before that I really don't like it, but I suspect there's
> not much of an way around it giving the small stacks, and significant
> amount of stacks that's already used above and below XFS.
> 
> Can we at least have a sysctl nob or mount option to switch back to
> direct allocator calls so that we can still debug any performance
> or other issues with this one?

Honestly, I'd prefer not to do that because it's a slippery slope.
I've got plenty more "do stuff in the background via workqueues"
patches lined up, so if we start adding knobs/mount options to turn
each of them off "just in case there's an issue".

So far I haven't found any issues at all and I've been running this
split allocation stack like this in -all- my performance testing for
the past 2-3 months. I know that is not conclusive, but if the
bechmarks I've been using to improve XFS performance over the past
18 months don't show regressions, that's fairly indicative of the
fact that most workloads won't even notice the change....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
