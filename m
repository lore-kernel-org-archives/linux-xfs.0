Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0657B7F78
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2014 15:11:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DC0F7304053
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2014 13:11:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CFrj8aCIjpaa2rJ4 for
	<xfs@oss.sgi.com>; Wed, 02 Apr 2014 13:11:17 -0700 (PDT)
Date: Wed, 2 Apr 2014 16:11:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/5] xfs: run an eofblocks scan on ENOSPC/EDQUOT
Message-ID: <20140402201110.GC3043@laptop.bfoster>
References: <1396012563-60973-1-git-send-email-bfoster@redhat.com>
	<1396012563-60973-5-git-send-email-bfoster@redhat.com>
	<20140331222246.GF17603@dastard>
	<20140401135518.GC21540@bfoster.bfoster>
	<20140401211926.GH17603@dastard>
	<20140401232022.GA15934@bfoster.bfoster>
	<20140402051103.GL17603@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140402051103.GL17603@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 02, 2014 at 04:11:03PM +1100, Dave Chinner wrote:
> On Tue, Apr 01, 2014 at 07:20:23PM -0400, Brian Foster wrote:
> > On Wed, Apr 02, 2014 at 08:19:26AM +1100, Dave Chinner wrote:
> > > On Tue, Apr 01, 2014 at 09:55:18AM -0400, Brian Foster wrote:
> > > Yes, it means that there is a global flush when a project quota runs
> > > out of space, but it means that we only do it once and we don't burn
> > > excessive CPU walking radix trees scanning inodes needlessly every
> > > time we get a storm of processes hammering project quota ENOSPC.
> > > 
> > 
> > It's not clear to me that excess scanning is an issue, but it seems
> 
> Have 100 threads hit ENOSPC on the same project quota at the same
> time on a filesystem with a couple of thousand AGs with a few
> million cached inode, and then you'll see the problem....
> 

Right, that certainly sounds like a mess if we kicked off a bunch of the
mini-flush scans. I'm curious how much overhead there would be with the
flush out of the picture and a scan can actually go ahead and free up
some space (hopefully) quickly. That's something I'll have to test.

> > orthogonal to how we organize the enospc logic (at least once the flush
> > is out of the equation). IOW, we'll invoke the scanner with the same
> > frequency either way. Or maybe you are just referring to scanning
> > specifically for the purpose of doing flushes as a waste..?
> 
> Well, lots of concurrent scanning for the same purpose is highly
> inefficient - look at the amount of additional serialisation in the
> inode recalim walker that is aimed at reducing concurrency to one
> reclaim thread per AG at a time...
> 

Interesting, and I think this touches a bit on what I mean by the
scanning being somewhat orthogonal to the purpose of this patch. If the
scanning does turn out to be a real problem in this particular context,
why not try to improve the efficiency of the scan? We could include this
kind of per-ag locking for internal scans, or perhaps create a new scan
mode that exits after freeing a specified amount of space, etc. 

> I expect that if the serialisation on xfs_flush_inodes() isn't
> sufficient to throttle eofblock scanning concurrency in case like
> the above then we'll know about it pretty quickly.
> 

How much space should we expect xfs_flush_inodes() to free up? Using
your example of the unconditional flush followed by the global scan - it
seems like it could throttle things temporarily by allowing some set of
writers to serialize on a flush and hopefully soon after that other
writers can allocate space again. Once we're past that, those flushing
threads head into the scan just the same.

So I guess the question is, will the flush satisfy concurrent writers
long enough for one of the flush inducing threads to get into the scan
and prevent others from queuing further? If so, it seems like a
potential positive if the overhead of the flush is less than the
overhead of the "unbounded" scan in the same scenario. If not, it seems
like it could also be a potential net negative because we'll effectively
queue more threads on the flush that could have avoided allocation
failure were a scan already running and freeing space. I guess that all
depends on how long the flush takes, how much data is in cache, storage
hardware, etc. Something else I'll have to experiment with a little
more I suppose... :)

> > > > simplify things. The helper can run the quota scan and/or the global
> > > > scan based on the data regarding the situation (i.e., the inode and
> > > > associated quota characteristics). This allows us to preserve the notion
> > > > of attempting a lightweight recovery first and a heavyweight recovery
> > > > second, reserving the inode flush for when space is truly tight.
> > > > Thoughts?
> > > 
> > > It's still damn clunky, IMO. It's still trying to work around the
> > > fact that project quotas use ENOSPC rather than EDQUOT, and that
> > > makes the logic rather twisted. And it still has that hidden data
> > > flush in it so it can't really be called lightweight...
> > > 
> > 
> > Ok. Well if the high level logic is the issue, we could still turn that
> > inside out a bit to use your EDQUOT/ENOSPC logic, yet still preserve the
> > standalone eofblocks scan. It might be a few more lines, but perhaps
> > more clear. E.g.:
> > 
> > 	if (ret == -EDQUOT && !enospc) {
> > 		enospc = 1;
> > 		xfs_inode_free_quota_eofblocks(ip);
> > 		goto retry;
> > 	else if (ret == -ENOSPC && !enospc) {
> > 		if (!scanned) {
> > 			struct xfs_eofblocks eofb = {0};
> > 			...
> > 			scanned = 1;
> > 			xfs_icache_free_eofblocks(ip->i_mount, &eofb);
> > 			goto retry;
> > 		}
> > 
> > 		enospc = 1;
> > 		xfs_flush_inodes(ip->i_mount);
> > 		goto retry;
> > 	}
> > 
> > Thoughts on that?
> 
> Even more convoluted. :/
> 

That's pretty close to your example with the exception of adding the
retry after the scan and the scan/flush order. It loses the EDQUT/ENOSPC
confusion.

> Look at it this way - I've never been a fan of this "retry write on
> enospc once" code. It's a necessary evil due to the reality of
> locking orders and having to back out of the write far enough to
> safely trigger dirty inode writeback so we *might* be able to write
> this data. Making this code more finicky and tricky is the last
> thing I think we should be doing.
> 
> I don't have any better ideas at this point - I'm still tired and
> jetlagged and need to sort out everything for a merge window pull of
> the current tree, so time for me to think up a creative solution is
> limited. I'm hoping that you might be able to think of a different
> way entirely of doing this "write retry on ENOSPC" that dolves all
> these problems simply and easily ;)
> 

Fair enough, that's certainly more helpful. ;) We're probably closer on
this than I thought. I'm not arguing because I think this code is great,
but rather because the behavior we have seems kind of obtuse in
particular situations and can be improved with some reasonably small
changes.

> > We'll handle project quota ENOSPC just as we handle
> > global ENOSPC with respect to the scan and the flush, but we'll still
> > have the opportunity to free up a decent amount of space without
> > initiating I/O. The project quota scan down in free_quota_eofblocks()
> > might be rendered pointless as well.
> 
> Well, therein lies an avenue of investigation: for EOF block
> trimming, why would we need to do a flush first, even for project
> quotas? And if we aren't going to flush data, why does it need to be
> done at this level? Can it be done deep in the quota code where we
> know exactly what quota ran out of space?
> 

This is something I considered way back when first looking at this
(http://oss.sgi.com/archives/xfs/2012-12/msg00112.html). I don't recall
specifically what made that difficult, perhaps lack of enough
information to run a scan in a single context. I'll reset and have
another look at it.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
