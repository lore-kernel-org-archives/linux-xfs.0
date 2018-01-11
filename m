Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32990 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965724AbeAKTik (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 14:38:40 -0500
Date: Thu, 11 Jan 2018 14:38:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: recheck reflink / dirty page status before freeing
 CoW reservations
Message-ID: <20180111193828.GC22600@bfoster.bfoster>
References: <20180110220336.GU5602@magnolia>
 <20180111120410.GB22600@bfoster.bfoster>
 <20180111174027.GZ5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180111174027.GZ5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Thu, Jan 11, 2018 at 09:40:27AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 11, 2018 at 07:04:10AM -0500, Brian Foster wrote:
> > On Wed, Jan 10, 2018 at 02:03:36PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Eryu Guan reported seeing occasional hangs when running generic/269 with
> > > a new fsstress that supports clonerange/deduperange.  The cause of this
> > > hang is an infinite loop when we convert the CoW fork extents from
> > > unwritten to real just prior to writing the pages out; the infinite
> > > loop happens because there's nothing in the CoW fork to convert, and so
> > > it spins forever.
> > > 
> > > The underlying issue here is that when we go to perform these CoW fork
> > > conversions, we're supposed to have an extent waiting for us, but the
> > > low space CoW reaper has snuck in and blown them away!  There are four
> > > conditions that can dissuade the reaper from touching our file -- no
> > > reflink iflag; dirty page cache; writeback in progress; or directio in
> > > progress.  We check the four conditions prior to taking the locks, but
> > > we neglect to recheck them once we have the locks, which is how we end
> > > up whacking the writeback that's in progress.
> > > 
> > > Therefore, refactor the four checks into a helper function and call it
> > > once again once we have the locks to make sure we really want to reap
> > > the inode.  While we're at it, add an ASSERT for this weird condition so
> > > that we'll fail noisily if we ever screw this up again.
> > > 
> > > Reported-by: Eryu Guan <eguan@redhat.com>
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_bmap.c |    7 +++++
> > >  fs/xfs/xfs_icache.c      |   61 +++++++++++++++++++++++++++++-----------------
> > >  2 files changed, 46 insertions(+), 22 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > index a01cef4..7bd933f 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > @@ -4311,6 +4311,13 @@ xfs_bmapi_write(
> > >  	while (bno < end && n < *nmap) {
> > >  		bool			need_alloc = false, wasdelay = false;
> > >  
> > > +		/*
> > > +		 * CoW fork conversions should /never/ hit EOF.  There should
> > > +		 * always be something for us to work on.
> > > +		 */
> > > +		ASSERT(!eof || !(flags & XFS_BMAPI_CONVERT) ||
> > > +			       !(flags & XFS_BMAPI_COWFORK));
> > > +
> > 
> > The hunk just below asserts for BMAPI_COWFORK in a case that explicitly
> > considers eof. That makes the logic confusing to follow IMO, but I'm
> > more wondering whether pushing something like ASSERT(!((flags & CONVERT)
> > && (flags & COWFORK))) down into that hunk is effectively the same
> > thing..?  I.e., is it also true that we should not find a hole in the
> > (CONVERT & COW) case?
> 
> Yes.
> 
> > >  		/* in hole or beyoned EOF? */
> > >  		if (eof || bma.got.br_startoff > bno) {
> > >  			if (flags & XFS_BMAPI_DELALLOC) {
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index 1f84562..3fbcc03 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -1654,6 +1654,35 @@ xfs_inode_clear_eofblocks_tag(
> > >  			trace_xfs_perag_clear_eofblocks, XFS_ICI_EOFBLOCKS_TAG);
> > >  }
> > >  
> > > +/* Is this a good time to reap the CoW reservations for this file? */
> > > +static bool
> > > +xfs_can_free_cowblocks(
> > > +	struct xfs_inode	*ip,
> > > +	struct xfs_ifork	*ifp)
> > > +{
> > > +	/*
> > > +	 * Just clear the tag if we have an empty cow fork or none at all. It's
> > > +	 * possible the inode was fully unshared since it was originally tagged.
> > > +	 */
> > > +	if (!xfs_is_reflink_inode(ip) || !ifp->if_bytes) {
> > > +		trace_xfs_inode_free_cowblocks_invalid(ip);
> > > +		xfs_inode_clear_cowblocks_tag(ip);
> > > +		return false;
> > 
> > I think the flag update and tracepoint should probably remain in the
> > caller. They're somewhat misplaced for a "xfs_can_do_something()"
> > helper, particularly if it's ever exported and used in other contexts in
> > the future. Otherwise seems fine.
> 
> Hmm.  There's a subtlety to step around here, which is that this
> predicate can return false to mean "nothing here to see" or to mean
> "cannot clear anything at this time".  We want the trace+clear for the
> first case, but not the second.
> 
> I suppose this function could return the regular error code int and the
> caller can figure out what that means to it, but then all the post-check
> stuff ends up duplicated in the callers... so maybe I should just rename
> it xfs_prep_free_cowblocks().
> 

Are both checks necessarily required to be repeated under lock to fix
the bug? IOW, Could the !fork || !flag check remain in the caller to
cover the first case?

> And change the comment to:
> 
> /*
>  * Set ourselves up to free CoW blocks from this file.  If it's already
>  * clean then we can bail out quickly, but otherwise we must back off if
>  * the file is undergoing some kind of write.
>  */
> 

That sounds reasonable too.

Brian

> --D
> 
> > Brian
> > 
> > > +	}
> > > +
> > > +	/*
> > > +	 * If the mapping is dirty or under writeback we cannot touch the
> > > +	 * CoW fork.  Leave it alone if we're in the midst of a directio.
> > > +	 */
> > > +	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
> > > +	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
> > > +	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
> > > +	    atomic_read(&VFS_I(ip)->i_dio_count))
> > > +		return false;
> > > +
> > > +	return true;
> > > +}
> > > +
> > >  /*
> > >   * Automatic CoW Reservation Freeing
> > >   *
> > > @@ -1672,29 +1701,12 @@ xfs_inode_free_cowblocks(
> > >  	int			flags,
> > >  	void			*args)
> > >  {
> > > -	int ret;
> > > -	struct xfs_eofblocks *eofb = args;
> > > -	int match;
> > > +	struct xfs_eofblocks	*eofb = args;
> > >  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
> > > +	int			match;
> > > +	int			ret = 0;
> > >  
> > > -	/*
> > > -	 * Just clear the tag if we have an empty cow fork or none at all. It's
> > > -	 * possible the inode was fully unshared since it was originally tagged.
> > > -	 */
> > > -	if (!xfs_is_reflink_inode(ip) || !ifp->if_bytes) {
> > > -		trace_xfs_inode_free_cowblocks_invalid(ip);
> > > -		xfs_inode_clear_cowblocks_tag(ip);
> > > -		return 0;
> > > -	}
> > > -
> > > -	/*
> > > -	 * If the mapping is dirty or under writeback we cannot touch the
> > > -	 * CoW fork.  Leave it alone if we're in the midst of a directio.
> > > -	 */
> > > -	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
> > > -	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
> > > -	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
> > > -	    atomic_read(&VFS_I(ip)->i_dio_count))
> > > +	if (!xfs_can_free_cowblocks(ip, ifp))
> > >  		return 0;
> > >  
> > >  	if (eofb) {
> > > @@ -1715,7 +1727,12 @@ xfs_inode_free_cowblocks(
> > >  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> > >  	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> > >  
> > > -	ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
> > > +	/*
> > > +	 * Check again, nobody else should be able to dirty blocks or change
> > > +	 * the reflink iflag now that we have the first two locks held.
> > > +	 */
> > > +	if (xfs_can_free_cowblocks(ip, ifp))
> > > +		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
> > >  
> > >  	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> > >  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
