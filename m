Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C057B7F37
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 17:39:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 988678F8037
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 15:39:42 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DPyvS7FcVKu5CTHK for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 15:39:39 -0700 (PDT)
Date: Sat, 15 Aug 2015 08:39:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: stop holding ILOCK over filldir callbacks
Message-ID: <20150814223937.GW3902@dastard>
References: <1439330648-1057-1-git-send-email-david@fromorbit.com>
	<1439330648-1057-3-git-send-email-david@fromorbit.com>
	<20150814194145.GB18522@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150814194145.GB18522@bfoster.bfoster>
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
Cc: jack@suse.cz, oleg@redhat.com, xfs@oss.sgi.com

On Fri, Aug 14, 2015 at 03:41:45PM -0400, Brian Foster wrote:
> On Wed, Aug 12, 2015 at 08:04:08AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The recent change to the readdir locking made in 40194ec ("xfs:
> > reinstate the ilock in xfs_readdir") for CXFS directory sanity was
> > probably the wrong thing to do. Deep in the readdir code we
> > can take page faults in the filldir callback, and so taking a page
> > fault while holding an inode ilock creates a new set of locking
> > issues that lockdep warns all over the place about.
> > 
> > The locking order for regular inodes w.r.t. page faults is io_lock
> > -> pagefault -> mmap_sem -> ilock. The directory readdir code now
> > triggers ilock -> page fault -> mmap_sem. While we cannot deadlock
> > at this point, it inverts all the locking patterns that lockdep
> > normally sees on XFS inodes, and so triggers lockdep. We worked
> > around this with commit 93a8614 ("xfs: fix directory inode iolock
> > lockdep false positive"), but that then just moved the lockdep
> > warning to deeper in the page fault path and triggered on security
> > inode locks. Fixing the shmem issue there just moved the lockdep
> > reports somewhere else, and now we are getting false positives from
> > filesystem freezing annotations getting confused.
> > 
> > Further, if we enter memory reclaim in a readdir path, we now get
> > lockdep warning about potential deadlocks because the ilock is held
> > when we enter reclaim. This, again, is different to a regular file
> > in that we never allow memory reclaim to run while holding the ilock
> > for regular files. Hence lockdep now throws
> > ilock->kmalloc->reclaim->ilock warnings.
> > 
> > Basically, the problem is that the ilock is being used to protect
> > the directory data and the inode metadata, whereas for a regular
> > file the iolock protects the data and the ilock protects the
> > metadata. From the VFS perspective, the i_mutex serialises all
> > accesses to the directory data, and so not holding the ilock for
> > readdir doesn't matter. The issue is that CXFS doesn't access
> > directory data via the VFS, so it has no "data serialisaton"
> > mechanism. Hence we need to hold the IOLOCK in the correct places to
> > provide this low level directory data access serialisation.
> > 
> > The ilock can then be used just when the extent list needs to be
> > read, just like we do for regular files. The directory modification
> > code can take the iolock exclusive when the ilock is also taken,
> > and this then ensures that readdir is correct excluded while
> > modifications are in progress.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_dir2.c  |  3 +++
> >  fs/xfs/xfs_dir2_readdir.c | 11 ++++++++---
> >  fs/xfs/xfs_inode.c        | 34 +++++++++++++++++++++-------------
> >  fs/xfs/xfs_symlink.c      |  7 ++++---
> >  4 files changed, 36 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> > index a69fb3a..42799d8 100644
> > --- a/fs/xfs/libxfs/xfs_dir2.c
> > +++ b/fs/xfs/libxfs/xfs_dir2.c
> > @@ -362,6 +362,7 @@ xfs_dir_lookup(
> >  	struct xfs_da_args *args;
> >  	int		rval;
> >  	int		v;		/* type-checking value */
> > +	int		lock_mode;
> >  
> >  	ASSERT(S_ISDIR(dp->i_d.di_mode));
> >  	XFS_STATS_INC(xs_dir_lookup);
> > @@ -387,6 +388,7 @@ xfs_dir_lookup(
> >  	if (ci_name)
> >  		args->op_flags |= XFS_DA_OP_CILOOKUP;
> >  
> > +	lock_mode = xfs_ilock_data_map_shared(dp);
> >  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> >  		rval = xfs_dir2_sf_lookup(args);
> >  		goto out_check_rval;
> > @@ -419,6 +421,7 @@ out_check_rval:
> >  		}
> >  	}
> >  out_free:
> > +	xfs_iunlock(dp, lock_mode);
> >  	kmem_free(args);
> >  	return rval;
> >  }
> > diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> > index 098cd78..a989a9c 100644
> > --- a/fs/xfs/xfs_dir2_readdir.c
> > +++ b/fs/xfs/xfs_dir2_readdir.c
> > @@ -171,6 +171,7 @@ xfs_dir2_block_getdents(
> >  	int			wantoff;	/* starting block offset */
> >  	xfs_off_t		cook;
> >  	struct xfs_da_geometry	*geo = args->geo;
> > +	int			lock_mode;
> >  
> >  	/*
> >  	 * If the block number in the offset is out of range, we're done.
> > @@ -178,7 +179,9 @@ xfs_dir2_block_getdents(
> >  	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
> >  		return 0;
> >  
> > +	lock_mode = xfs_ilock_data_map_shared(dp);
> >  	error = xfs_dir3_block_read(NULL, dp, &bp);
> > +	xfs_iunlock(dp, lock_mode);
> 
> Ok, so the iolock bits exclude directory reads/lookups against directory
> modification. The ilock around these buffer reads serves the purpose of
> the commit 40194ec mentioned above, to protect reading in the extent
> tree.

Right.

> The locking all looks fine, but what I'm not quite clear on is where the
> requirement for the iolock comes in. Is this necessary because the ilock
> has been pushed down?

Yes.

Basically, the ilock currently serialises access to directory data
in it's entirity. Not just the inode metadata (i.e. struct xfs_inode
and the BMBT in the data forks) but also everything the BMBT points
to.

The problem with this is that it means that when reading the
directory data we have to hold the ilock to prevent racing with
modification - not just inode metadata, but also the directory data
blocks themselves. i.e. if we don't hold the ilock, we could read
one directory data block, and when we go to read the next we could
have raced with a modification that shifted dirents from one block
to the next. This would result in missing or duplicate dirents in
readdir, even though the BMBT had not changed....

Hence we need some form or locking against modification of the
directory data, not just the directory inode structure. THis is
exactly what we do with file data - the ilock protects against
modification of the inode metadata, the iolock serialises access to
the file data appropriately (e.g. vs truncate).

So effectively this change makes the directory data access be
serialised in a similar manner to the file data. Note that it's not
just directory data - it's also the hash indexes and the free space
blocks that are protected by the iolock. i.e. the xfs_dir_lookup()
method uses the hash index to find the dirent in the directory data
segment, so effectively we are moving to locking structure of "ilock
protects against BMBT changes, iolock protects against directory
data and internal data index changes".

> Are we just trying to mirror how i_mutex is used
> and/or provide a consistent locking pattern as for regular files?

We're not trying to replicate i_mutex - we are trying to ensure that
we have shared read access to the directory data, even though the
VFS does not allow shared read access. The CXFS metadata server
makes use of shared read access because it does not go throught the
VFS layers, and we want to preserve this behaviour so that if we
ever get shared directory access through the VFS everything just
works on XFS.

And, yes, we are trying to replicate the iolock/mmap_sem/ilock
locking pattern used for regular files, because it doesn't through
lockdep false positives as the iolock is not used underneath the
mmap_sem like the ilock is during block mapping in page faults...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
