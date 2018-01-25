Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44708 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751011AbeAYTVq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jan 2018 14:21:46 -0500
Date: Thu, 25 Jan 2018 11:21:42 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/11] xfs: track CoW blocks separately in the inode
Message-ID: <20180125192142.GL9068@magnolia>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676030942.12349.14467032190779795677.stgit@magnolia>
 <20180125130644.GC43198@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180125130644.GC43198@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 25, 2018 at 08:06:45AM -0500, Brian Foster wrote:
> On Tue, Jan 23, 2018 at 06:18:29PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Track the number of blocks reserved in the CoW fork so that we can
> > move the quota reservations whenever we chown, and don't account for
> > CoW fork delalloc reservations in i_delayed_blks.  This should make
> > chown work properly for quota reservations, enables us to fully
> > account for real extents in the cow fork in the file stat info, and
> > improves the post-eof scanning decisions because we're no longer
> > confusing data fork delalloc extents with cow fork delalloc extents.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c      |   16 ++++++++++++----
> >  fs/xfs/libxfs/xfs_inode_buf.c |    1 +
> >  fs/xfs/xfs_bmap_util.c        |    5 +++++
> >  fs/xfs/xfs_icache.c           |    3 ++-
> >  fs/xfs/xfs_inode.c            |   11 +++++------
> >  fs/xfs/xfs_inode.h            |    1 +
> >  fs/xfs/xfs_iops.c             |    3 ++-
> >  fs/xfs/xfs_itable.c           |    3 ++-
> >  fs/xfs/xfs_qm.c               |    2 +-
> >  fs/xfs/xfs_reflink.c          |    4 ++--
> >  fs/xfs/xfs_super.c            |    1 +
> >  11 files changed, 34 insertions(+), 16 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 4a38cfc..a208825 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> ...
> > @@ -1669,7 +1667,7 @@ xfs_release(
> >  		truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
> >  		if (truncated) {
> >  			xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
> > -			if (ip->i_delayed_blks > 0) {
> > +			if (ip->i_delayed_blks > 0 || ip->i_cow_blocks > 0) {
> >  				error = filemap_flush(VFS_I(ip)->i_mapping);
> >  				if (error)
> >  					return error;
> 
> Is having cowblocks really relevant to this hunk? I thought this was
> purely a delalloc vs. file size thing, but I could be wrong. 

AFAICT, if we (1) use truncate to reduce a file's size, (2) write
somewhere past eof, (3) make some delalloc reservations for the post-eof
write, and (4) close the file, then this chunk flushes the dirty data to
disk so that if we crash after the close() call returns, the file will
still have all the data that was written out.  IOWs, this provides for
flush-on-close after a file size reduction.

So I was thinking that if a write to a lower offset causes the creation
of a speculative cow extent of some kind that extends past eof, we'd
still want to flush the dirty data to disk on close even if there are no
delalloc reservations in the data fork.

Ofc now I see that xfs_file_iomap_begin_delay will create the data fork
da reservation for a non-shared block even if a cow fork extent already
exists (the write is promoted to cow), so perhaps this isn't strictly
necessary... but adding a data fork da extent when there's already a cow
fork extent seems like a (mostly harmless) bug to me.

--D

> 
> Brian
> 
> > @@ -1909,7 +1907,8 @@ xfs_inactive(
> >  
> >  	if (S_ISREG(VFS_I(ip)->i_mode) &&
> >  	    (ip->i_d.di_size != 0 || XFS_ISIZE(ip) != 0 ||
> > -	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0))
> > +	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0 ||
> > +	     ip->i_cow_blocks > 0))
> >  		truncate = 1;
> >  
> >  	error = xfs_qm_dqattach(ip, 0);
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index ff56486..6feee8a 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -62,6 +62,7 @@ typedef struct xfs_inode {
> >  	/* Miscellaneous state. */
> >  	unsigned long		i_flags;	/* see defined flags below */
> >  	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
> > +	unsigned int		i_cow_blocks;	/* count of cow fork blocks */
> >  
> >  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
> >  
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index 56475fc..6c3381c 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -513,7 +513,8 @@ xfs_vn_getattr(
> >  	stat->mtime = inode->i_mtime;
> >  	stat->ctime = inode->i_ctime;
> >  	stat->blocks =
> > -		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
> > +		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks +
> > +				  ip->i_cow_blocks);
> >  
> >  	if (ip->i_d.di_version == 3) {
> >  		if (request_mask & STATX_BTIME) {
> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index d583105..412d7eb 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> > @@ -122,7 +122,8 @@ xfs_bulkstat_one_int(
> >  	case XFS_DINODE_FMT_BTREE:
> >  		buf->bs_rdev = 0;
> >  		buf->bs_blksize = mp->m_sb.sb_blocksize;
> > -		buf->bs_blocks = dic->di_nblocks + ip->i_delayed_blks;
> > +		buf->bs_blocks = dic->di_nblocks + ip->i_delayed_blks +
> > +				 ip->i_cow_blocks;
> >  		break;
> >  	}
> >  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index 5b848f4..28f12f8 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -1847,7 +1847,7 @@ xfs_qm_vop_chown_reserve(
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> >  	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
> >  
> > -	delblks = ip->i_delayed_blks;
> > +	delblks = ip->i_delayed_blks + ip->i_cow_blocks;
> >  	blkflags = XFS_IS_REALTIME_INODE(ip) ?
> >  			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
> >  
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index e367351..f875ea7 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -619,7 +619,7 @@ xfs_reflink_cancel_cow_blocks(
> >  	}
> >  
> >  	/* clear tag if cow fork is emptied */
> > -	if (!ifp->if_bytes)
> > +	if (ip->i_cow_blocks == 0)
> >  		xfs_inode_clear_cowblocks_tag(ip);
> >  
> >  	return error;
> > @@ -704,7 +704,7 @@ xfs_reflink_end_cow(
> >  	trace_xfs_reflink_end_cow(ip, offset, count);
> >  
> >  	/* No COW extents?  That's easy! */
> > -	if (ifp->if_bytes == 0)
> > +	if (ip->i_cow_blocks == 0)
> >  		return 0;
> >  
> >  	offset_fsb = XFS_B_TO_FSBT(ip->i_mount, offset);
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index f3e0001..9d04cfb 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -989,6 +989,7 @@ xfs_fs_destroy_inode(
> >  	xfs_inactive(ip);
> >  
> >  	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
> > +	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_cow_blocks == 0);
> >  	XFS_STATS_INC(ip->i_mount, vn_reclaim);
> >  
> >  	/*
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
