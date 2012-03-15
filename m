Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2FM5jxO201359 for <xfs@oss.sgi.com>; Thu, 15 Mar 2012 17:05:46 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dZp0YFq6iOKkWzEi for <xfs@oss.sgi.com>;
	Thu, 15 Mar 2012 15:05:43 -0700 (PDT)
Date: Fri, 16 Mar 2012 09:05:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/10] xfs: don't cache inodes read through bulkstat
Message-ID: <20120315220540.GM5091@dastard>
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
	<1331095828-28742-11-git-send-email-david@fromorbit.com>
	<20120315181426.GO7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120315181426.GO7762@sgi.com>
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
Cc: xfs@oss.sgi.com

On Thu, Mar 15, 2012 at 01:14:26PM -0500, Ben Myers wrote:
> On Wed, Mar 07, 2012 at 03:50:28PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When we read inodes via bulkstat, we generally only read them once
> > and then throw them away - they never get used again. If we retain
> > them in cache, then it simply causes the working set of inodes and
> > other cached items to be reclaimed just so the inode cache can grow.
> > 
> > Avoid this problem by marking inodes read by bulkstat as not to be
> > cached and check this flag in .drop_inode to determine whether the
> > inode should be added to the VFS LRU or not. If the inode lookup
> > hits an already cached inode, then don't set the flag. If the inode
> > lookup hits an inode marked with no cache flag, remove the flag and
> > allow it to be cached once the current reference goes away.
> > 
> > Inodes marked as not cached will get cleaned up by the background
> > inode reclaim or via memory pressure, so they will still generate
> > some short term cache pressure. They will, however, be reclaimed
> > much sooner and in preference to cache hot inodes.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_iget.c   |    8 ++++++--
> >  fs/xfs/xfs_inode.h  |    4 +++-
> >  fs/xfs/xfs_itable.c |    3 ++-
> >  fs/xfs/xfs_super.c  |   17 +++++++++++++++++
> >  4 files changed, 28 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
> > index 93fc1dc..20ddb1e 100644
> > --- a/fs/xfs/xfs_iget.c
> > +++ b/fs/xfs/xfs_iget.c
> > @@ -290,7 +290,7 @@ xfs_iget_cache_hit(
> >  	if (lock_flags != 0)
> >  		xfs_ilock(ip, lock_flags);
> >  
> > -	xfs_iflags_clear(ip, XFS_ISTALE);
> > +	xfs_iflags_clear(ip, XFS_ISTALE | XFS_IDONTCACHE);
> 
> If XFS_IGET_DONTCACHE is set, maybe you don't want to clear
> XFS_IDONTCACHE.

I think that if we get a cache hit, regardless of the access method,
then the inode needs to stay cached for longer. I can't think of a
workload other than repeated xfsdump or xfs_fsr cycles that would
cause this, and in these cases it will only occur if the scans
happen faster than the reclaim period. That sort of workload would
be extremely unusual, but if it is happening then I think we should
treat it as a cached workload rather than an uncached workload
because caching the inodes long term results in better and more
consistent performance.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
