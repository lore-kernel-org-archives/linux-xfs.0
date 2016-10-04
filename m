Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:28950 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753303AbcJDTHc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2016 15:07:32 -0400
Date: Wed, 5 Oct 2016 06:07:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 24/63] xfs: when replaying bmap operations, don't let
 unlinked inodes get reaped
Message-ID: <20161004190727.GP27872@dastard>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520489698.29434.13242363533695270347.stgit@birch.djwong.org>
 <20161003190409.GB49915@bfoster.bfoster>
 <20161004002925.GC14092@birch.djwong.org>
 <20161004124400.GB55212@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161004124400.GB55212@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Oct 04, 2016 at 08:44:01AM -0400, Brian Foster wrote:
> On Mon, Oct 03, 2016 at 05:29:25PM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 03, 2016 at 03:04:10PM -0400, Brian Foster wrote:
> > > On Thu, Sep 29, 2016 at 08:08:17PM -0700, Darrick J. Wong wrote:
> > > > Log recovery will iget an inode to replay BUI items and iput the inode
> > > > when it's done.  Unfortunately, the iput will see that i_nlink == 0
> > > > and decide to truncate & free the inode, which prevents us from
> > > > replaying subsequent BUIs.  We can't skip the BUIs because we have to
> > > > replay all the redo items to ensure that atomic operations complete.
> > > > 
> ...
> > > 
> > > > Since unlinked inode recovery will reap the inode anyway, we can
> > > > safely introduce a new inode flag to indicate that an inode is in this
> > > > 'unlinked recovery' state and should not be auto-reaped in the
> > > > drop_inode path.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/xfs_bmap_item.c   |    1 +
> > > >  fs/xfs/xfs_inode.c       |    8 ++++++++
> > > >  fs/xfs/xfs_inode.h       |    6 ++++++
> > > >  fs/xfs/xfs_log_recover.c |    1 +
> > > >  4 files changed, 16 insertions(+)
> > > > 
> > > > 
> ...
> > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > index e08eaea..0c25a76 100644
> > > > --- a/fs/xfs/xfs_inode.c
> > > > +++ b/fs/xfs/xfs_inode.c
> > > > @@ -1855,6 +1855,14 @@ xfs_inactive(
> > > >  	if (mp->m_flags & XFS_MOUNT_RDONLY)
> > > >  		return;
> > > >  
> > > > +	/*
> > > > +	 * If this unlinked inode is in the middle of recovery, don't
> > > > +	 * truncate and free the inode just yet; log recovery will take
> > > > +	 * care of that.  See the comment for this inode flag.
> > > > +	 */
> > > > +	if (xfs_iflags_test(ip, XFS_IRECOVER_UNLINKED))
> > > > +		return;
> > > > +
> > > 
> > > Also, it might be better to push this one block of code down since the
> > > following block still deals with i_nlink > 0 properly (not that it will
> > > likely affect the code as it is now, since we only handle eofblocks
> > > trimming atm).
> > 
> > I put the jump-out case there so that we touch the inode's bmap as little
> > as possible while we're recovering the inode.  Since the inode is still
> > around in memory, so we'll end up back there at a later point anyway.
> > 
> 
> I'm not quite following... it looks like we set the reclaim tag on the
> inode unconditionally after we get through xfs_inactive(). That implies
> the in-memory inode can go away at any point thereafter, unless somebody
> else comes along and happens to look for it. Hmm?

Yup - the iunlink recover check needs to go into xfs_fs_drop_inode()
to determine whether the inode should be dropped from the cache or
not by iput_final(). That way it will never get near xfs_inactive()
because the VFS won't try to evict it until the
XFS_IRECOVER_UNLINKED flag is cleared.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
