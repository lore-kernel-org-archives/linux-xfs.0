Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39159 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751697AbdIUPkh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 11:40:37 -0400
Date: Thu, 21 Sep 2017 08:40:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: rewrite getbmap using the xfs_iext_* helpers
Message-ID: <20170921154032.GG7112@magnolia>
References: <20170918152630.24592-1-hch@lst.de>
 <20170918152630.24592-2-hch@lst.de>
 <20170920230036.GB7112@magnolia>
 <20170921133506.GC13541@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921133506.GC13541@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2017 at 03:35:06PM +0200, Christoph Hellwig wrote:
> On Wed, Sep 20, 2017 at 04:00:36PM -0700, Darrick J. Wong wrote:
> > On Mon, Sep 18, 2017 at 08:26:29AM -0700, Christoph Hellwig wrote:
> > > Currently getbmap uses xfs_bmapi_read to query the extent map, and then
> > > fixes up various bits that are eventually reported to userspace.
> > > 
> > > This patch instead rewrites it to use xfs_iext_lookup_extent and
> > > xfs_iext_get_extent to iteratively process the extent map.  This not
> > > only avoids the need to allocate a map for the returned xfs_bmbt_irec
> > > structures but also greatly simplified the code.
> > > 
> > > There are two intentional behavior changes compared to the old code:
> > > 
> > >  - the current code reports unwritten extents that don't directly border
> > >    a written one as unwritten even when not passing the BMV_IF_PREALLOC
> > >    option, contrary to the documentation.  The new code requires the
> > >    BMV_IF_PREALLOC flag to report the unwrittent extent bit.
> > >  - The new code does never merges consecutive extents, unlike the old
> > >    code that sometimes does it based on the boundaries of the
> > >    xfs_bmapi_read calls.  Note that the extent merging behavior was
> > >    entirely undocumented.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  fs/xfs/xfs_bmap_util.c | 525 ++++++++++++++++++++-----------------------------
> > >  1 file changed, 208 insertions(+), 317 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > index cd9a5400ba4f..a87d05978c92 100644
> > > --- a/fs/xfs/xfs_bmap_util.c
> > > +++ b/fs/xfs/xfs_bmap_util.c
> > > @@ -403,125 +403,103 @@ xfs_bmap_count_blocks(
> > >  	return 0;
> > >  }
> > >  
> > > -/*
> > > - * returns 1 for success, 0 if we failed to map the extent.
> > > - */
> > > -STATIC int
> > > -xfs_getbmapx_fix_eof_hole(
> > > -	xfs_inode_t		*ip,		/* xfs incore inode pointer */
> > > -	int			whichfork,
> > > -	struct getbmapx		*out,		/* output structure */
> > > -	int			prealloced,	/* this is a file with
> > > -						 * preallocated data space */
> > > -	int64_t			end,		/* last block requested */
> > > -	xfs_fsblock_t		startblock,
> > > -	bool			moretocome)
> > > +static int
> > > +xfs_getbmap_report_one(
> > > +	struct xfs_inode	*ip,
> > > +	struct getbmapx		*bmv,
> > > +	struct getbmapx		*out,
> > > +	int64_t			bmv_end,
> > > +	struct xfs_bmbt_irec	*got)
> > >  {
> > > -	int64_t			fixlen;
> > > -	xfs_mount_t		*mp;		/* file system mount point */
> > > -	xfs_ifork_t		*ifp;		/* inode fork pointer */
> > > -	xfs_extnum_t		lastx;		/* last extent pointer */
> > > -	xfs_fileoff_t		fileblock;
> > > -
> > > -	if (startblock == HOLESTARTBLOCK) {
> > > -		mp = ip->i_mount;
> > > -		out->bmv_block = -1;
> > > -		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, XFS_ISIZE(ip)));
> > > -		fixlen -= out->bmv_offset;
> > > -		if (prealloced && out->bmv_offset + out->bmv_length == end) {
> > > -			/* Came to hole at EOF. Trim it. */
> > > -			if (fixlen <= 0)
> > > -				return 0;
> > > -			out->bmv_length = fixlen;
> > > -		}
> > > +	struct getbmapx		*p = out + bmv->bmv_entries;
> > > +	bool			shared = false, trimmed = false;
> > > +	int			error;
> > > +
> > > +	error = xfs_reflink_trim_around_shared(ip, got, &shared, &trimmed);
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	if (isnullstartblock(got->br_startblock) ||
> > > +	    got->br_startblock == DELAYSTARTBLOCK) {
> > > +		/*
> > > +		 * Delalloc extents that start beyond EOF can occur due to
> > > +		 * speculative EOF allocation when the delalloc extent is larger
> > > +		 * than the largest freespace extent at conversion time.  These
> > > +		 * extents cannot be converted by data writeback, so can exist
> > > +		 * here even if we are not supposed to be finding delalloc
> > > +		 * extents.
> > > +		 */
> > > +		if (got->br_startoff < XFS_B_TO_FSB(ip->i_mount, XFS_ISIZE(ip)))
> > > +			ASSERT((bmv->bmv_iflags & BMV_IF_DELALLOC) != 0);
> > > +
> > > +		p->bmv_oflags |= BMV_OF_DELALLOC;
> > > +		p->bmv_block = -2;
> > 
> > Could you please turn the special bmv_block values (-2 for delayed
> > allocation, -1 for hole) into defined constants in xfs_fs.h?
> > 
> > I'm particularly cranky about bmv_block == -1 since there isn't even a
> > BMV_OF_ flag for holes.
> 
> I can prepare a patch for it, but I don't want to throw random cleanups
> into this series which I need as a preparation for the extent list
> rework.

Yes, please! :)

> > > +	if (got->br_state == XFS_EXT_UNWRITTEN &&
> > > +	    (bmv->bmv_iflags & BMV_IF_PREALLOC))
> > > +		p->bmv_oflags |= BMV_OF_PREALLOC;
> > 
> > Am I the only one who thought (from the xfs_bmap manpage) that you're
> > supposed to BMV_IF_PREALLOC if you want the output to contain prealloc
> > extents, and omit the flag if you don't want them?
> > 
> > Versus what the kernel actually does, which seems to be to merge extents
> > together if you don't pass the flag:
> > 
> > $ xfs_io -c 'bmap -vvvv' moo
> > moo:
> >  EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET        TOTAL
> >    0: [0..39]:         335288488..335288527  7 (736424..736463)    40
> > 
> > $ xfs_io -c 'bmap -vvvv -p' moo
> > moo:
> >  EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET        TOTAL FLAGS
> >    0: [0..7]:          335288488..335288495  7 (736424..736431)     8 000000
> >    1: [8..39]:         335288496..335288527  7 (736432..736463)    32 010000
> > 
> > Eh.  I guess the old code would report prealloc extents, it just doesn't
> > flag them, so this is ok.
> 
> The old code even flags them if there is no normal extent to merge them
> with, but I consider that a bug I didn't want to follow in the new
> code.  E.g. try creating a sparse file and just preallocate an extent
> in it, and it will be marked as preallocated.
> 
> I never understood the point of the BMV_IF_PREALLOC flag - why would
> we ever want to not report preallocated extents?  We also set
> the new BMV_OF_SHARED unconditionally for example.

I don't really understand the bmap behavior either, but I do get a whiff
of 'historical reasons' :)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
