Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 00:43:22 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m757hGdj014975
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 00:43:16 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F19E1985425
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 00:44:30 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id wTMs54y6no6aJyvx for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 00:44:30 -0700 (PDT)
Date: Tue, 5 Aug 2008 17:44:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Move vn_iowait() earlier in the reclaim path
Message-ID: <20080805074425.GD21635@disturbed>
References: <4897F691.6010806@sgi.com> <20080805073711.GA21635@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805073711.GA21635@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com, xfs-dev <xfs-dev@sgi.com>

On Tue, Aug 05, 2008 at 05:37:11PM +1000, Dave Chinner wrote:
> On Tue, Aug 05, 2008 at 04:43:29PM +1000, Lachlan McIlroy wrote:
> > Currently by the time we get to vn_iowait() in xfs_reclaim() we have already
> > gone through xfs_inactive()/xfs_free() and recycled the inode.  Any I/O
> 
> xfs_free()? What's that?
> 
> > completions still running (file size updates and unwritten extent conversions)
> > may be working on an inode that is no longer valid.
> 
> The linux inode does not get freed until after ->clear_inode
> completes, hence it is perfectly valid to reference it anywhere
> in the ->clear_inode path.
> 
> My bet is that you are seeing I/O completion mark an inode dirty
> that is being freed. ie.  Calling mark_inode_dirty_sync() in the I/O
> completion blindly assumes that the linux inode is still valid, 
> when it may be in the 'being freed' path. e.g. we can put it back on the
> superblock dirty list just before it gets freed for real...
> 
> I came across this about a week ago when tracking down a QA failure
> with a combined linux/XFS inode patch. The fix is to make I/O
> completion call xfs_mark_inode_dirty_sync() so we check that this
> linux inode not in the process of being freed before we try to
> mark it dirty.

Oh, I should point out that that xfs_mark_inode_dirty sync looked
like this prior to the patch I posted:

/*
 * If the linux inode is valid, mark it dirty.
 * Used when commiting a dirty inode into a transaction so that
 * the inode will get written back by the linux code
 */
void
xfs_mark_inode_dirty_sync(
        xfs_inode_t     *ip)
{
        struct inode    *inode = VFS_I(ip);

        if (!(inode->i_state & (I_WILL_FREE|I_FREEING|I_CLEAR)))
                mark_inode_dirty_sync(inode);
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
