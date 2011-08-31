Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VCHqjp206735 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 07:17:52 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FC41544720
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 05:17:50 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	26rqMdYjA7vTiQTu for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2011 05:17:50 -0700 (PDT)
Date: Wed, 31 Aug 2011 22:17:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RFC: merging the quota source files
Message-ID: <20110831121746.GJ32358@dastard>
References: <20110830121112.GA19509@infradead.org>
	<20110831002236.GV3162@dastard>
	<20110831052049.GA29511@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110831052049.GA29511@infradead.org>
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

On Wed, Aug 31, 2011 at 01:20:49AM -0400, Christoph Hellwig wrote:
> On Wed, Aug 31, 2011 at 10:22:36AM +1000, Dave Chinner wrote:
> > FWIW, this is what I'd like to seen done with the quota
> > infrastructure in the medium term:
> > 
> > 
> > 	4. clearly document the locking model and simplify it to
> > 	remove all the unnecessary nested locking and try-locking
> > 	that the current deeply nested model requires. This is
> > 	appears to just be a replication of the locking model pattern
> > 	already defined by the VFS dentry and inode caches...
> 
> This is the queue I plan to submit for Linux 3.2 if we get any progress
> on getting the current pending queue reviewed and applied.

I'm slowly working my way through the queue. I've got plenty of
stuff on my plate at the moment, though, and I'll be on holidays
for a couple of weeks starting next week, so don't rely on me to get
stuff reviewed in the near term....

> > 	2. remove the lookup hash tables and replace it with
> > 	something more flexible (btree/radix-tree/rbtree) for
> > 	different cache sizes.
> 
> I have a prototype to use a radix tree.  You said before you didn't like
> it as the radix tree assumeds the quota ids are clustered, but so are
> the actual dqouts in the quota file, so I do not think it is a problem.
> We'll probably need testing at a big quota user site to decided this.

I'd just use the generic btree code in lib/btree.c. That way we
simply don't have to care what quota ids are in use and how sparse
they are....

> > 	4. change the shrinker implementation to be "normal" so that
> > 	the dquot cache sizes respond to memory pressure correctly
> 
> I'm waiting for your shrinker interface changes to start with as there
> will be too many conflicts otherwise.

Yeah, that's what I was planning on doing

> > 	3. replace the weird, complex freelist and dquot recycling
> > 	code with a standard LRU implementation.
> 
> I have ptrototypes / WIP patches for this, but it doesn't make sense
> before item 3 is done.

Similarly I was planning ondoingthis to use the generic LRU code
I've proposed...

> > The gets rid of roughly ~50% of the infrastructure code that
> 
> > 	1. break up the global quota manager into per-xfs_mount
> > 	structures (move into the quotainfo structure).
> 
> Moving to the radix tree remove the hashtable and some accounting
> from the global quota manager.  After that we only have the freelist
> and assorted accounting and the slab caches left.  The freelist can
> fairly easily be changed to be per-mount at this point, but the slab
> caches should remain global.  We probably could just create them
> unconditionally if quota support is compiled in and kill the global
> quota manager at this point.

*nod*

> > currently exists in xfs_qm.c, and remaining stuff like the sync
> > infrastructure mostly goes away with AIL driven writeback, too.
> 
> Most of the sync infrastructure is already gone in my series, we only
> do one non-trylocking but delwri pass after quotacheck, after that
> all quota updates are logged.
> 
> > Some
> > of the functionality remaining (like the shrinkers) can be placed in
> > xfs_sync.c with the inode cache shrinkers, which further reduces the
> > code in xfs_qm.c.
> > 
> > At that point the delineation between xfs_qm.c and xfs_dquot.c will
> > be much clearer, I think, especially if the changes I suggested
> > above were made...
> 
> So that's one vote for keeping them separate.

Yeah. the dquot design pattern is based on the pattern that inodes
use, so having the code structured in a similar manner makes sense
to me.

Speaking of which (and going well and truly OT), I don't see much
reason for keeping xfs_iget.c separate from xfs_inode.c anymore -
there isn't really much code left in xfs_iget.c now, and stuff like
all the locking code isn't really related to the inode lookup
function of xfs_iget(), anyway...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
