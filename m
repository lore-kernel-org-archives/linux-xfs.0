Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2T0qSXH256949 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 19:52:28 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	VzlychuQOHj8Lb74 for <xfs@oss.sgi.com>;
	Wed, 28 Mar 2012 17:52:26 -0700 (PDT)
Date: Thu, 29 Mar 2012 11:52:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/10] remove xfsbufd
Message-ID: <20120329005224.GJ5091@dastard>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120328005337.GH3592@dastard>
	<20120328151040.GA2487@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120328151040.GA2487@infradead.org>
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

On Wed, Mar 28, 2012 at 11:10:41AM -0400, Christoph Hellwig wrote:
> On Wed, Mar 28, 2012 at 11:53:37AM +1100, Dave Chinner wrote:
> > in IO patterns and performance under heavy load here with this
> > patch set. it doesn't however, reduce the buffer cache lookups all
> > that much on such workloads - about 10% at most - as most of the
> > lookups are common from the directory and inode buffer
> > modifications. Here's a sample profile:
> 
> 10% might not be extremly huge, but it's pretty significant.

Yes, I didn't mean to belittle the improvement it makes, as every
little bit helps, just that the buffer cache lookups are dominated
by other types of lookups.

> > This shows that 50% of the lookups from the directory code, 25% from
> > the inode btree lookups, 12% from mapping inodes, and 10% from
> > reading the AGI buffer during inode allocation. 
> > 
> > You know, I suspect that we could avoid almost all those AGI buffer
> > lookups by moving to a similar in-core log and flush technique that
> > the inodes use. We've already got all the information in the struct
> > xfs_perag - rearranging it to have a "in-core on disk" structures
> > for the AGI, AGF and AGFL would make a lot of the "select an AG"
> > code much simpler than having to read and modify the AG buffers
> > directly. It might even be possible to do such a change without
> > needing to change the on-disk journal format for them...

I just had a crazy thought - it would be relatively easy to make
object based caches for finding buffers. Add an rbtree root to
various structures (e.g. inode, AGI, AGF, etc) and index all the
buffers associated with the btrees on that object in the object
rbtree. Need to find a directory/bmapbt/attr buffer? look up the
rbtree on the inode. Need to find a freespace btree buffer? lookup
the rbtree on the AGF.

I suspect that this can be done without much API churn, and it would
remove the central per-AG buffer cache lookups for most operations.
Smaller caches means less lookup overhead for most operations - with
10-11% of CPU time being spent in lookups on an 8p machine, that's
almost an entire CPU worth of time being used. Hence reducing the
rbtree lookup and modification overhead should be a significant win.

Crazy idea, yes, but I'm going to think about it some more,
especially as the shrinker operates of the LRU and is entirely
independent of the rbtree indexing.....

> > I think I'll put that on my list of stuff to do - right next to
> > in-core unlinked inode lists....
> 
> Sounds fine.  A simple short-term fix might be to simply pin a reference
> to the AGI buffers and add a pointer from struct xfs_perag to them.

I'd prefer not to do that - filesystems with lots of AGs will then
pin significant amounts of memory that would otherwise be
reclaimable. Besides, I don't think the problem is that significant
to need immediate resolution in such a way.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
