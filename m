Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 738327F66
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 17:18:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C83F304053
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 15:18:31 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	5DMAHo3b88QQO0uA for <xfs@oss.sgi.com>;
	Thu, 03 Apr 2014 15:18:28 -0700 (PDT)
Date: Fri, 4 Apr 2014 09:18:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] xfs: run an eofblocks scan on ENOSPC/EDQUOT
Message-ID: <20140403221826.GS17603@dastard>
References: <1396012563-60973-1-git-send-email-bfoster@redhat.com>
	<1396012563-60973-5-git-send-email-bfoster@redhat.com>
	<20140331222246.GF17603@dastard>
	<20140401135518.GC21540@bfoster.bfoster>
	<20140401211926.GH17603@dastard>
	<20140401232022.GA15934@bfoster.bfoster>
	<20140402051103.GL17603@dastard>
	<20140402201110.GC3043@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140402201110.GC3043@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 02, 2014 at 04:11:10PM -0400, Brian Foster wrote:
> On Wed, Apr 02, 2014 at 04:11:03PM +1100, Dave Chinner wrote:
> > On Tue, Apr 01, 2014 at 07:20:23PM -0400, Brian Foster wrote:
> > > On Wed, Apr 02, 2014 at 08:19:26AM +1100, Dave Chinner wrote:
> > > > On Tue, Apr 01, 2014 at 09:55:18AM -0400, Brian Foster wrote:
> > > > Yes, it means that there is a global flush when a project quota runs
> > > > out of space, but it means that we only do it once and we don't burn
> > > > excessive CPU walking radix trees scanning inodes needlessly every
> > > > time we get a storm of processes hammering project quota ENOSPC.
> > > > 
> > > 
> > > It's not clear to me that excess scanning is an issue, but it seems
> > 
> > Have 100 threads hit ENOSPC on the same project quota at the same
> > time on a filesystem with a couple of thousand AGs with a few
> > million cached inode, and then you'll see the problem....
> > 
> 
> Right, that certainly sounds like a mess if we kicked off a bunch of the
> mini-flush scans. I'm curious how much overhead there would be with the
> flush out of the picture and a scan can actually go ahead and free up
> some space (hopefully) quickly. That's something I'll have to test.
> 
> > > orthogonal to how we organize the enospc logic (at least once the flush
> > > is out of the equation). IOW, we'll invoke the scanner with the same
> > > frequency either way. Or maybe you are just referring to scanning
> > > specifically for the purpose of doing flushes as a waste..?
> > 
> > Well, lots of concurrent scanning for the same purpose is highly
> > inefficient - look at the amount of additional serialisation in the
> > inode recalim walker that is aimed at reducing concurrency to one
> > reclaim thread per AG at a time...
> > 
> 
> Interesting, and I think this touches a bit on what I mean by the
> scanning being somewhat orthogonal to the purpose of this patch. If the
> scanning does turn out to be a real problem in this particular context,
> why not try to improve the efficiency of the scan? We could include this
> kind of per-ag locking for internal scans, or perhaps create a new scan
> mode that exits after freeing a specified amount of space, etc. 

Well, xfs_flush_inodes() serialises callers, so if we flush before
scan we already effectively have a method of throttling the EOF
block scans ;)

The idea of the generic scan code, however, is not to do any
serialisation at all. i.e. to be as fast and concurrent as possible.
If a caller needs throttling, then we do that at the caller.

The reclaim code has /interesting/ serialisation requirements - it
has to be as concurrent as possible (because shrinkers can be called
concurrently) but not waste CPU scanning the same inodes
unnecesarily (hence the cursors). But it also needs to throttle
inode allocation to the rate at which we can clean and free them,
and hence the mutexes and synchronous inode writeback to throttle
and back up excessive reclaim concurrency without wasting CPU.

> > I expect that if the serialisation on xfs_flush_inodes() isn't
> > sufficient to throttle eofblock scanning concurrency in case like
> > the above then we'll know about it pretty quickly.
> > 
> 
> How much space should we expect xfs_flush_inodes() to free up? Using

Depends on the amount of delalloc space. Assume and average indirect
block reservation of 4 blocks per delalloc region that is flushed.

> your example of the unconditional flush followed by the global scan - it
> seems like it could throttle things temporarily by allowing some set of
> writers to serialize on a flush and hopefully soon after that other
> writers can allocate space again. Once we're past that, those flushing
> threads head into the scan just the same.
>
> So I guess the question is, will the flush satisfy concurrent writers
> long enough for one of the flush inducing threads to get into the scan
> and prevent others from queuing further? If so, it seems like a
> potential positive if the overhead of the flush is less than the
> overhead of the "unbounded" scan in the same scenario. If not, it seems
> like it could also be a potential net negative because we'll effectively
> queue more threads on the flush that could have avoided allocation
> failure were a scan already running and freeing space. I guess that all
> depends on how long the flush takes, how much data is in cache, storage
> hardware, etc. Something else I'll have to experiment with a little
> more I suppose... :)

Right, but in general I think that the FIFO serialisation behaviour
of xfs_flush_inodes() will be sufficent to limit the scanning
concurrency, especially if each flush causes a few IOs to be done
and so metres out the start of each new scan to a 10-20 new scans
per second....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
