Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K6ZD10249467 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 01:35:14 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	S4jx6VhaivQxFlBY for <xfs@oss.sgi.com>;
	Tue, 19 Jun 2012 23:35:12 -0700 (PDT)
Date: Wed, 20 Jun 2012 16:35:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] xfs: convert internal buffer functions to pass maps
Message-ID: <20120620063508.GD30705@dastard>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-3-git-send-email-david@fromorbit.com>
	<20120618204325.GX4721@sgi.com> <20120618210713.GY4721@sgi.com>
	<20120619071552.GA23093@infradead.org>
	<20120619155946.GA2676@sgi.com>
	<20120619170304.GC7554@infradead.org>
	<20120619171153.GD2676@sgi.com> <20120620055619.GA30705@dastard>
	<20120620060400.GA5617@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620060400.GA5617@infradead.org>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Wed, Jun 20, 2012 at 02:04:00AM -0400, Christoph Hellwig wrote:
> On Wed, Jun 20, 2012 at 03:56:19PM +1000, Dave Chinner wrote:
> > > they are rebased not to require the inode allocator patchset.  I think that Jan
> > > is also going to repost his 'Fix overallocation in xfs_buf_allocate_memory()'
> > > based upon Dave's suggestions.  It's best not to depend upon that either.  What
> > > do you say, Dave?
> > 
> > I reorder my local patch set and repost it after running it through
> > some testing....
> 
> Sorry, I totally misunderstood the initial issue - I though Ben had my
> series applied, and thus yours didn't apply.
> 
> I still think reordering is better - I'm quite busy and I'd rather get
> your series reviewed first before redoing and retesting the inode
> allocator changes.

I stand corrected - it doesn't need a rebase - all it needs is to be
applied on top of Jan Kara's bug fix. Looking back, that's exactly
what I said in patch 0 of the series....

So it should be good to go as Jan's fix needs to go to Linus before
3.5 is released...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
