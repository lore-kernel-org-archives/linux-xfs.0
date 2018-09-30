Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:45735 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727719AbeI3MhB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Sep 2018 08:37:01 -0400
Date: Sun, 30 Sep 2018 16:05:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2 V3] xfs: verify size-vs-format for symlinks & dirs
Message-ID: <20180930060520.GK31060@dastard>
References: <ba65356c-2b57-75fb-0436-804913285809@redhat.com>
 <1e55b111-eae4-b0cf-0221-c96eb3f17b77@redhat.com>
 <20180930032553.GJ31060@dastard>
 <71034ef7-836b-a462-a4f9-53d9004339bc@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71034ef7-836b-a462-a4f9-53d9004339bc@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, "Xu, Wen" <wen.xu@gatech.edu>

On Sun, Sep 30, 2018 at 12:06:44AM -0500, Eric Sandeen wrote:
> On 9/29/18 10:25 PM, Dave Chinner wrote:
> > On Mon, Sep 24, 2018 at 10:00:39PM -0500, Eric Sandeen wrote:
> >> Today, xfs_ifork_verify_data() will simply skip verification if the inode
> >> claims to be in non-local format.  However, nothing catches the case where
> >> the size for the format is too small to be non-local.  xfs_repair tests
> >> for this mismatch in process_check_inode_sizes(), so do the same in this
> >> verifier.
> >>
> >> Reported-by: Xu, Wen <wen.xu@gatech.edu>
> >> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=200925
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> Reviewed-by: Brian Foster <bfoster@redhat.com>
> >> ---
> >>
> >> V2: restructure code & tests per Dave's suggestion on the V1 patch.
> >> V3: rewrite dave's comments per brian's suggestions
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> >> index f9acf1d436f6..d1a58e7a872f 100644
> >> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> >> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> >> @@ -704,12 +704,33 @@ xfs_ifork_verify_data(
> >>  	struct xfs_inode	*ip,
> >>  	struct xfs_ifork_ops	*ops)
> >>  {
> >> -	/* Non-local data fork, we're done. */
> >> -	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> >> +	struct xfs_mount	*mp = ip->i_mount;
> >> +	int			mode = VFS_I(ip)->i_mode;
> >> +
> >> +	/*
> >> +	 * Verify non-local format forks have a valid size. Symlinks must have
> >> +	 * outgrown the data fork size. The same goes for non-local dirs, but
> >> +	 * dirs grow at dirblock granularity. Perform a slightly stronger check
> >> +	 * and require the dir is at least one dirblock in size.
> >> +	 */
> >> +	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL) {
> >> +		switch (mode & S_IFMT) {
> >> +		case S_IFDIR:
> >> +			if (ip->i_d.di_size < mp->m_dir_geo->blksize)
> >> +				return __this_address;
> >> +			break;
> >> +		case S_IFLNK:
> >> +			if (ip->i_d.di_size <= XFS_IFORK_DSIZE(ip))
> >> +				return __this_address;
> > 
> > Just had this fire in inode writeback from generic/390. I'm going to
> > drop it for the moment, because I'm not sure what the correct fix is
> > yet.  Consider this:
> > 
> > 	create symlink XFS_LITINO bytes in length
> > 	  fits in inode, so put inline. size <= IFORK_DSIZE
> > 	[....]
> > 	add attr to symlink
> > 	  creates attr fork
> > 	    inline data fork too large, size > new IFORK_DSIZE
> > 	      xfs_symlink_local_to_remote()
> > 		data fork goes to extent format, size remains unchanged
> > 	[....]
> > 	remove last attrs from inode
> > 	  remove attr fork
> > 	    IFORK_DSIZE grows again, now size = IFORK_DSIZE again
> > 	    data fork remains in extent format
> > 	[....]
> > 	inode writeback
> > 	  size = IFORK_DSIZE, extent format
> > 	    xfs_ifork_verify_data verifier fails.
> > 
> > 
> > With this process, I think a symlink can be out of line even if it
> > is less than the size of the data fork. I think this can happen even
> > for symlinks much smaller than XFS_LITINO, because the attribute
> > fork can grow into free space in the literal area and push local
> > data larger than XFS_BMDR_SPACE_CALC(MINDBTPTRS) bytes to extent
> > format.
> > 
> > #define MINDBTPTRS 3
> > 
> > #define XFS_BMDR_SPACE_CALC(nrecs) \
> >         (int)(sizeof(xfs_bmdr_block_t) + \
> > 	       ((nrecs) * (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t)))) 
> > 
> > = 4 + 3 * (8 + 8)
> > = 52 bytes
> > = 56 bytes when rounded up to 8 byte offset
> > 
> > So, yeah, I think that this check needs to be different because I
> > think we could have symlinks as short at 56 bytes in extent format,
> > even when the inode has no attribute fork...
> 
> Hrmph.  And yet, xfs_repair:
> 
> static int
> process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
> {
>         xfs_fileoff_t           expected_offset;
>         xfs_bmbt_rec_t          *rp;
>         xfs_bmbt_irec_t         irec;
>         int                     numrecs;
>         int                     i;
>         int                     max_blocks;
> 
>         if (be64_to_cpu(dino->di_size) <= XFS_DFORK_DSIZE(dino, mp)) {
>                 if (dino->di_format == XFS_DINODE_FMT_LOCAL)
>                         return 0;
>                 do_warn(
> _("mismatch between format (%d) and size (%" PRId64 ") in symlink ino %" PRIu64 "\n"),
>                         dino->di_format,
>                         (int64_t)be64_to_cpu(dino->di_size), lino);
>                 return 1;
>         }
> 
> seems to clearly call "non-local symlink with size < XFS_DFORK_DSIZE" corruption.
> What gives?

Seems to me like another cases that the verifiers have uncovered
another situation that even repair doesn't handle correctly. (Which
is why I like to look at these things from first principles, rather
than just from the "what does reapir do" POV?). It's like to be rare
because who removes all the attributes on a file apart from when
unlinking the inode?

xfs_attr_fork_remove() has set the di_forkoff back to zero
when the last attribute is removed from the inode for a long time
(I stopped looking when I got to ~2008...), so this isn't a new
situation. i.e. trying to define what are valid values has
demonstrated that there are more cases we need to take into account
than anyone has realised.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
