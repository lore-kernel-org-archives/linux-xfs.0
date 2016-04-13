Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ACDAA7CA0
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 01:49:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 798528F8033
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 23:49:05 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	D4kfsfnoyiK85i8m for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2016 23:49:02 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aqEbk-0003yb-MW
	for xfs@oss.sgi.com; Wed, 13 Apr 2016 16:49:00 +1000
Date: Wed, 13 Apr 2016 16:49:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/11] xfs: mark reclaimed inodes invalid earlier
Message-ID: <20160413064900.GP567@dastard>
References: <1460525492-1170-1-git-send-email-david@fromorbit.com>
	<1460525492-1170-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460525492-1170-8-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Wed, Apr 13, 2016 at 03:31:28PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The last thing we do before using call_rcu() on an xfs_inode to be
> freed is mark it as invalid. This means there is a window between
> when we know for certain that the inode is going to be freed and
> when we do actually mark it as "freed".
> 
> This is important in the context of RCU lookups - we can look up the
> inode, find that it is valid, and then use it as such not realising
> that it is in the final stages of being freed.
> 
> As such, mark the inode as being invalid the moment we know it is
> going to be reclaimed. This can be done while we still hold the
> XFS_ILOCK_EXCL and the flush lock in xfs_inode_reclaim, meaning that
> it occurs well before we remove it from the radix tree, and that
> the i_flags_lock, the XFS_ILOCK and the inode flush lock all act as
> synchronisation points for detecting that an inode is about to go
> away.
> 
> For defensive purposes, this allows us to add a further check to
> xfs_iflush_cluster to ensure we skip inodes that are being freed
> after we grab the XFS_ILOCK_SHARED and the flush lock - we know that
> if the inode number if valid while we have these locks held we know
> that it has not progressed through reclaim to the point where it is
> clean and is about to be freed.
> 
> [bfoster: fixed __xfs_inode_clear_reclaim() using ip->i_ino after it
> 	  had already been zeroed.]

And, of course, in reordering this I dropped this fix because it was
handled by the reworking of tagging code to use pag->pag_agno.

So I've brought that small change forward to this patch (using
pag->pag_agno instead of deriving it from the ip->i_ino in
__xfs_inode_clear_reclaim()).

That means I have to rebase the later cleanup patch too, but the end
result of the patch set is identical...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
