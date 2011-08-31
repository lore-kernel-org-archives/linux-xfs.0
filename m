Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7V5Kqiq181838 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 00:20:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2BFC1248AA
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 22:20:51 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7RGD9xizarYo0QCH for <xfs@oss.sgi.com>;
	Tue, 30 Aug 2011 22:20:51 -0700 (PDT)
Date: Wed, 31 Aug 2011 01:20:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: merging the quota source files
Message-ID: <20110831052049.GA29511@infradead.org>
References: <20110830121112.GA19509@infradead.org>
	<20110831002236.GV3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110831002236.GV3162@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Aug 31, 2011 at 10:22:36AM +1000, Dave Chinner wrote:
> > I've started a bit work on the quota code, and the split between the
> > implementation files is rather annoying.  I'd suggest we merge at least
> > xfs_dquot.c and xfs_qm.c into a single file, as there is no visible
> > split.
> 
> It seems to me to be a reasonable separation - xfs_qm.c is mostly
> global management functions e.g. quota cache initialisation,
> reclaim, quotacheck, etc, which xfs_dquot.c is all single dquot
> specific operations which don't have global scope.
> 
> I'd argue that there are parts of xfs_qm.c that could be moved into
> xfs_dquot.c (like the xfs_qm_vop_* and xfs_qm_dq*attach* functions
> that only act on a specific dquots) which would make this separation
> much clearer. This would also reflect the same sort of separation as
> we have with inode operations vs cache infrastructure....

That and things like quota reclaim which tends to operate on the single
dquot, but mostly sit in xfs_qm.c. 

> > Does this a) sound good to others, and b) does anyone have a preference
> > for the name of the new quota implementation file?
> 
> If you are going to rename xfs_qm.c, then xfs_quota.c seems like the
> best name to me.

Ok.

> FWIW, this is what I'd like to seen done with the quota
> infrastructure in the medium term:
> 
> 
> 	4. clearly document the locking model and simplify it to
> 	remove all the unnecessary nested locking and try-locking
> 	that the current deeply nested model requires. This is
> 	appears to just be a replication of the locking model pattern
> 	already defined by the VFS dentry and inode caches...

This is the queue I plan to submit for Linux 3.2 if we get any progress
on getting the current pending queue reviewed and applied.

> 
> 	2. remove the lookup hash tables and replace it with
> 	something more flexible (btree/radix-tree/rbtree) for
> 	different cache sizes.

I have a prototype to use a radix tree.  You said before you didn't like
it as the radix tree assumeds the quota ids are clustered, but so are
the actual dqouts in the quota file, so I do not think it is a problem.
We'll probably need testing at a big quota user site to decided this.

> 
> 	4. change the shrinker implementation to be "normal" so that
> 	the dquot cache sizes respond to memory pressure correctly

I'm waiting for your shrinker interface changes to start with as there
will be too many conflicts otherwise.

> 	3. replace the weird, complex freelist and dquot recycling
> 	code with a standard LRU implementation.

I have ptrototypes / WIP patches for this, but it doesn't make sense
before item 3 is done.

> The gets rid of roughly ~50% of the infrastructure code that

> 	1. break up the global quota manager into per-xfs_mount
> 	structures (move into the quotainfo structure).

Moving to the radix tree remove the hashtable and some accounting
from the global quota manager.  After that we only have the freelist
and assorted accounting and the slab caches left.  The freelist can
fairly easily be changed to be per-mount at this point, but the slab
caches should remain global.  We probably could just create them
unconditionally if quota support is compiled in and kill the global
quota manager at this point.


> currently exists in xfs_qm.c, and remaining stuff like the sync
> infrastructure mostly goes away with AIL driven writeback, too.

Most of the sync infrastructure is already gone in my series, we only
do one non-trylocking but delwri pass after quotacheck, after that
all quota updates are logged.

> Some
> of the functionality remaining (like the shrinkers) can be placed in
> xfs_sync.c with the inode cache shrinkers, which further reduces the
> code in xfs_qm.c.
> 
> At that point the delineation between xfs_qm.c and xfs_dquot.c will
> be much clearer, I think, especially if the changes I suggested
> above were made...

So that's one vote for keeping them separate.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
