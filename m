Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q251nu1M080948 for <xfs@oss.sgi.com>; Sun, 4 Mar 2012 19:49:56 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GndyqXyu0gN6frcZ for <xfs@oss.sgi.com>;
	Sun, 04 Mar 2012 17:49:39 -0800 (PST)
Date: Mon, 5 Mar 2012 12:49:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfs: add a shrinker for quotacheck
Message-ID: <20120305014936.GN5091@dastard>
References: <1330661507-1121-1-git-send-email-david@fromorbit.com>
	<1330661507-1121-9-git-send-email-david@fromorbit.com>
	<20120302075104.GG4117@infradead.org>
	<20120302100426.GI5091@dastard>
	<20120302103831.GA16825@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120302103831.GA16825@infradead.org>
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

On Fri, Mar 02, 2012 at 05:38:31AM -0500, Christoph Hellwig wrote:
> On Fri, Mar 02, 2012 at 09:04:26PM +1100, Dave Chinner wrote:
> > On Fri, Mar 02, 2012 at 02:51:04AM -0500, Christoph Hellwig wrote:
> > > Hmm, I don't like this complication all that much.
> > 
> > Though it is a simple, self contained fix for the problem...
> 
> It just smells hacky.  If the non-caching version doesn't go anywhere
> I won't veto it, but it's defintively not my favourite.
> 
> > > Why would we even bother caching inodes during quotacheck?  The bulkstat
> > > is a 100% sequential read only workload going through all inodes in the
> > > filesystem.  I think we should simply not cache any inodes while in
> > > quotacheck.
> > 
> > I have tried that approach previously with inodes read through
> > bulkstat, but I couldn't find a clean workable solution. It kept
> > getting rather complex because all our caching and recycling is tied
> > into VFS level triggers. That was a while back, so maybe there is a
> > simpler solution that I missed in attempting to do this.
> > 
> > I suspect for a quotacheck only solution we can hack a check into
> > .drop_inode, but a generic coherent non-cached bulkstat lookup is
> > somewhat more troublesome.
> 
> Right, the whole issue also applies to any bulkstat.  But even for that
> it doesn't seem that bad.
> 
> We add a new XFS_IGET_BULKSTAT flag for iget, which then sets an
> XFS_INOTCACHE or similar flag on the inode.  If we see that in bulkstat
> on a clean inode in ->drop_inode return true there, which takes care
> of the VFS side.

Right, that's effectively what I did. All the problems came from
getting cache hits on an inode marked XFS_INOTCACHE and having to
convert it to a cached inode at that point. I suspect that the
problems I had related to the fact that this bug:

778e24b xfs: reset inode per-lifetime state when recycling it

had not been discovered at the time so that was likely related to
the problems I was seeing.

> For the XFS side we'd have to move the call to xfs_syncd_init earlier 
> during the mount process, which effectively revers
> 2bcf6e970f5a88fa05dced5eeb0326e13d93c4a1.  That should be fine now that
> we never call into the quota code from the sync work items.  If we want
> to be entirely on the safe side we could only move starting the reclaim
> work item earlier.

I initially suspected that all we needed to do here is check if
(mp->m_super->sb_flags & MS_ACTIVE) is set in the syncd work, and if
it isn't, just requeue the work again. That would prevent it from
running during mount and shutdown.

However, the reclaim work already checks this to prevent shutdown
races, so we can't actually queue inode reclaim work during the mount
process right now, either. Indeed, this is the only reason we are
not crashing on quotacheck right now - the syncd workqueue is not
intialised until after the quotacheck completes, but we are most
certainly trying to queue reclaim work during quotacheck. It's only
this check against MS_ACTIVE that is preventing quotacheck from
trying to queue work on an uninitialised workqueue.

This is turning into quite a mess - the additional shrinker might be
the simplest solution for 3.4....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
