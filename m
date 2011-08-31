Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7V0MgmD166728 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 19:22:42 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DACF61281AE
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 17:22:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bzzj1aOSrS7EhFIW for <xfs@oss.sgi.com>;
	Tue, 30 Aug 2011 17:22:40 -0700 (PDT)
Date: Wed, 31 Aug 2011 10:22:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: RFC: merging the quota source files
Message-ID: <20110831002236.GV3162@dastard>
References: <20110830121112.GA19509@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110830121112.GA19509@infradead.org>
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

On Tue, Aug 30, 2011 at 08:11:12AM -0400, Christoph Hellwig wrote:
> Hi,
> 
> I've started a bit work on the quota code, and the split between the
> implementation files is rather annoying.  I'd suggest we merge at least
> xfs_dquot.c and xfs_qm.c into a single file, as there is no visible
> split.

It seems to me to be a reasonable separation - xfs_qm.c is mostly
global management functions e.g. quota cache initialisation,
reclaim, quotacheck, etc, which xfs_dquot.c is all single dquot
specific operations which don't have global scope.

I'd argue that there are parts of xfs_qm.c that could be moved into
xfs_dquot.c (like the xfs_qm_vop_* and xfs_qm_dq*attach* functions
that only act on a specific dquots) which would make this separation
much clearer. This would also reflect the same sort of separation as
we have with inode operations vs cache infrastructure....

> Given how small and useless xfs_qm_bhv.c is I'd throw it in.

Agreed, that should be merged into xfs_qm.c at least.

> As a second pass I'd also like to kill xfs_qm_syscalls.c and merge
> it into the new xfs_qm.c/xfs_dquot.c for the low-level helpers, and
> xfs_quotaops.c for high-level code that deals directly with the Linux
> interface.

That seems like a good idea, too.

> Does this a) sound good to others, and b) does anyone have a preference
> for the name of the new quota implementation file?

If you are going to rename xfs_qm.c, then xfs_quota.c seems like the
best name to me.

FWIW, this is what I'd like to seen done with the quota
infrastructure in the medium term:

	1. break up the global quota manager into per-xfs_mount
	structures (move into the quotainfo structure).

	2. remove the lookup hash tables and replace it with
	something more flexible (btree/radix-tree/rbtree) for
	different cache sizes.

	3. replace the weird, complex freelist and dquot recycling
	code with a standard LRU implementation.

	4. clearly document the locking model and simplify it to
	remove all the unnecessary nested locking and try-locking
	that the current deeply nested model requires. This is
	appears to just be a replication of the locking model pattern
	already defined by the VFS dentry and inode caches...

	4. change the shrinker implementation to be "normal" so that
	the dquot cache sizes respond to memory pressure correctly

The gets rid of roughly ~50% of the infrastructure code that
currently exists in xfs_qm.c, and remaining stuff like the sync
infrastructure mostly goes away with AIL driven writeback, too. Some
of the functionality remaining (like the shrinkers) can be placed in
xfs_sync.c with the inode cache shrinkers, which further reduces the
code in xfs_qm.c.

At that point the delineation between xfs_qm.c and xfs_dquot.c will
be much clearer, I think, especially if the changes I suggested
above were made...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
