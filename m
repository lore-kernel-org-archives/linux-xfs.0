Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q292vV4F128894 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 20:57:31 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Gpcopx3ePlaDXKJb for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 18:57:29 -0800 (PST)
Date: Fri, 9 Mar 2012 13:57:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: df bigger than ls?
Message-ID: <20120309025725.GT5091@dastard>
References: <20120307155439.GA23360@nsrc.org> <20120307171619.GA23557@nsrc.org>
	<4F57A32A.5010704@sandeen.net> <20120308021054.GM3592@dastard>
	<20120308162348.GT7762@sgi.com> <20120309001710.GR5091@dastard>
	<20120309015603.GZ8545@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120309015603.GZ8545@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Brian Candler <B.Candler@pobox.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Mar 08, 2012 at 07:56:03PM -0600, Ben Myers wrote:
> On Fri, Mar 09, 2012 at 11:17:10AM +1100, Dave Chinner wrote:
> > On Thu, Mar 08, 2012 at 10:23:48AM -0600, Ben Myers wrote:
> > > On Thu, Mar 08, 2012 at 01:10:54PM +1100, Dave Chinner wrote:
> > > > On Wed, Mar 07, 2012 at 12:04:26PM -0600, Eric Sandeen wrote:
> > Alex and I discussed this problem briefly awhile ago.  What is the best
> > > way to lose when you hit ENOSPC (project quotas) or EDQUOT in
> > > xfs_iomap_write_delay?  You want to be fair; one user hitting his quota
> > > shouldn't be able to steal some other user's block reservations unless
> > > you really are near ENOSPC for the entire filesystem.  
> > > 
> > > I suggested something like... track inodes with preallocated block
> > > reservations in LRU order and by dquot, so that the poor fella who is at
> > > EDQUOT will first clean up the preallocations that resulted in quota
> > > being enforced, try again, and then work on preallocations of other
> > > users only if it can help in his situation.  IIRC Alex shut me down when
> > > he heard LRU.  ;)
> > 
> > And I agree with Alex. Nothing additional needs to be tracked on top
> > of inodes with speculative prealloc. Just the search filter would
> > need to be different (i.e. only select inodes with a specific dquot
> > attached).
> 
> Yeah, maybe not.  A single list of inodes with speculative prealloc does
> seem a good place to start.

Except it involves growing the inode by a struct listhead. Keeping
per-inode memory usage down is extremely important, and growing it
by 16 bytes for a rare corner case is not a particularly good
tradeoff.  Especially as using a radix tree tag for tracking doesn't
involve any increase in memory usage and tag based scans are
lock-free and quite efficient.

> Later maybe you would not want to
> scan/filter through all of them and we could add additional lists for
> dquots.  My suggestion of using LRU was because I think that the oldest
> unused speculative preallocs should be the first to go.  One chronic
> over-quota user shouldn't be able to punish everyone else.

Sure. But we only need to check if the inode with prealloc
belongs to the user/group/project that hit EDQUOT before taking
action. We don't need an LRU for that.

Indeed, I don't believe that removing the entire preallocation on
each inode is the right thing to do, either. Chopping it in half is
probably the right thing to do so that we free up lots of space in
the case of excessive (large preallocation) but don't cause
significant extra fragmentation for the work that currently requires
it.

If we still get EDQUOT after trimming speculative preallocations, we
can try a second time. If reducing speculative preallocations by 75%
doesn't avoid the EDQUOT (or ENOSPC), then I think we can consider it
a real error....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
