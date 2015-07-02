Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F7AC29DFC
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 21:27:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AA213AC003
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 19:27:46 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id fT7dm7CfYeDChZiY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Jul 2015 19:27:44 -0700 (PDT)
Date: Wed, 1 Jul 2015 19:27:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/14] libxfs: support unmapping reflink blocks
Message-ID: <20150702022739.GD10043@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
	<20150625233930.4992.88802.stgit@birch.djwong.org>
	<20150701012632.GR22807@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150701012632.GR22807@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 01, 2015 at 11:26:32AM +1000, Dave Chinner wrote:
> On Thu, Jun 25, 2015 at 04:39:30PM -0700, Darrick J. Wong wrote:
> > When we're unmapping blocks from a file, we need to decrease refcounts
> > in the btree and only free blocks if they refcount is 1.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c          |    5 +
> >  fs/xfs/libxfs/xfs_reflink_btree.c |  140 +++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_reflink_btree.h |    4 +
> >  3 files changed, 147 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 057fa9a..3f5e8da 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -45,6 +45,7 @@
> >  #include "xfs_symlink.h"
> >  #include "xfs_attr_leaf.h"
> >  #include "xfs_filestream.h"
> > +#include "xfs_reflink_btree.h"
> >  
> >  
> >  kmem_zone_t		*xfs_bmap_free_item_zone;
> > @@ -4984,8 +4985,8 @@ xfs_bmap_del_extent(
> >  	 * If we need to, add to list of extents to delete.
> >  	 */
> >  	if (do_fx)
> > -		xfs_bmap_add_free(mp, flist, del->br_startblock,
> > -				  del->br_blockcount, ip->i_ino);
> > +		xfs_reflink_bmap_add_free(mp, flist, del->br_startblock,
> > +					  del->br_blockcount, ip->i_ino, tp);
> 
> I think this is the wrong abstraction. I think the code should look
> like this:
> 
> 	if (do_fx) {
> 		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> 			error = xfs_reflink_del_extent(mp, tp, flist,
> 						del->br_startblock,
> 						del->br_blockcount, ip->i_ino);
> 			if (error)
> 				goto done;
> 		} else
> 			xfs_bmap_add_free()
> 	}
> 
> Because what we are doing is deleting an extent from the reflink
> btree, not adding a freed extent to the "to-be-freed" list.

<nod> Not a great choice of name, I agree...

> 
> 
> > diff --git a/fs/xfs/libxfs/xfs_reflink_btree.c b/fs/xfs/libxfs/xfs_reflink_btree.c
> > index 380ed72..f40ba1f 100644
> > --- a/fs/xfs/libxfs/xfs_reflink_btree.c
> > +++ b/fs/xfs/libxfs/xfs_reflink_btree.c
> 
> Again, xfs_reflink.c
> 
> > @@ -935,3 +935,143 @@ error0:
> >  	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> >  	return error;
> >  }
> > +
> > +/**
> > + * xfs_reflink_bmap_add_free() - release a range of blocks
> > + *
> > + * @mp: XFS mount object
> > + * @flist: List of blocks to be freed at the end of the transaction
> > + * @fsbno: First fs block of the range to release
> > + * @len: Length of range
> > + * @owner: owner of the extent
> > + * @tp: transaction that goes with the free operation
> > + */
> > +int
> > +xfs_reflink_bmap_add_free(
> > +	struct xfs_mount	*mp,		/* mount point structure */
> > +	xfs_bmap_free_t		*flist,		/* list of extents */
> > +	xfs_fsblock_t		fsbno,		/* fs block number of extent */
> > +	xfs_filblks_t		fslen,		/* length of extent */
> > +	uint64_t		owner,		/* extent owner */
> > +	struct xfs_trans	*tp)		/* transaction */
> > +{
> > +	struct xfs_btree_cur	*cur;
> > +	int			error;
> > +	struct xfs_buf		*agbp;
> > +	xfs_agnumber_t		agno;		/* allocation group number */
> > +	xfs_agblock_t		agbno;		/* ag start of range to free */
> > +	xfs_agblock_t		agbend;		/* ag end of range to free */
> > +	xfs_extlen_t		aglen;		/* ag length of range to free */
> > +	int			i, have;
> > +	xfs_agblock_t		lbno;		/* rlextent start */
> > +	xfs_extlen_t		llen;		/* rlextent length */
> > +	xfs_nlink_t		lnr;		/* rlextent refcount */
> > +	xfs_agblock_t		bno;		/* rlext block # in loop */
> > +	xfs_extlen_t		len;		/* rlext length in loop */
> > +	unsigned long long	blocks_freed;
> > +	xfs_fsblock_t		range_fsb;
> > +
> > +	if (!xfs_sb_version_hasreflink(&mp->m_sb)) {
> > +		xfs_bmap_add_free(mp, flist, fsbno, fslen, owner);
> > +		return 0;
> > +	}
> 
> That canbe dropped.
> > +
> > +	agno = XFS_FSB_TO_AGNO(mp, fsbno);
> > +	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
> > +	CHECK_AG_NUMBER(mp, agno);
> > +	ASSERT(fslen < mp->m_sb.sb_agblocks);
> > +	CHECK_AG_EXTENT(mp, agbno, fslen);
> 
> These extent lengths have already been checked. If they are invalid,
> then the extent deletion would have errored out with corruption
> long before we get here.

Ok.

> > +	aglen = fslen;
> > +
> > +	/*
> > +	 * Drop reference counts in the reflink tree.
> > +	 */
> > +	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
> > +	if (error)
> > +		return error;
> > +
> > +	/*
> > +	 * Grab a rl btree cursor.
> > +	 */
> > +	cur = xfs_reflinkbt_init_cursor(mp, tp, agbp, agno);
> > +	bno = agbno;
> > +	len = aglen;
> > +	agbend = agbno + aglen - 1;
> > +	blocks_freed = 0;
> > +
> > +	/*
> > +	 * Account for a left extent that partially covers our range.
> > +	 */
> > +	error = xfs_reflink_lookup_le(cur, bno, &have);
> > +	if (error)
> > +		goto error0;
> > +	if (have) {
> > +		error = xfs_reflink_get_rec(cur, &lbno, &llen, &lnr, &i);
> > +		if (error)
> > +			goto error0;
> > +		XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, lbno, llen, lnr, error0);
> > +		if (lbno + llen > bno) {
> > +			blocks_freed += min(len, lbno + llen - bno);
> > +			bno += blocks_freed;
> > +			len -= blocks_freed;
> > +		}
> > +	}
> 
> So we unconditionally look up the reflink btree on extent free to
> see if we need to free it, even if the inode has not been reflinked?
> Doesn't this add a lot of overhead to the extent freeing?
> 
> Indeed, why not just mark inodes that have been reflinked (i.e. have
> shared extents) with an on-disk flag so that we know if we need to
> do reflink btree work or not? That way the code fragment above could
> just check an inode flag rather than always calling into this
> function for reflink enabled filesystems....

Yep, the inode flag comes later, though I'm melding it into an earlier
part of the patch...

> 
> > +	while (len > 0) {
> > +		/*
> > +		 * Go find the next rlext.
> > +		 */
> > +		range_fsb = XFS_AGB_TO_FSB(mp, agno, bno);
> > +		error = xfs_btree_increment(cur, 0, &have);
> > +		if (error)
> > +			goto error0;
> > +		if (!have) {
> > +			/*
> > +			 * There's no right rlextent, so free bno to the end.
> > +			 */
> > +			lbno = bno + len;
> > +			llen = 0;
> > +		} else {
> > +			/*
> > +			 * Find the next rlextent.
> > +			 */
> > +			error = xfs_reflink_get_rec(cur, &lbno, &llen,
> > +					&lnr, &i);
> > +			if (error)
> > +				goto error0;
> > +			XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, lbno, llen, lnr,
> > +						      error0);
> > +			if (lbno >= bno + len) {
> > +				lbno = bno + len;
> > +				llen = 0;
> > +			}
> > +		}
> > +
> > +		/*
> > +		 * Free everything up to the start of the rlextent and
> > +		 * account for still-mapped blocks.
> > +		 */
> > +		if (lbno - bno > 0) {
> > +			xfs_bmap_add_free(mp, flist, range_fsb, lbno - bno,
> > +					  owner);
> > +			len -= lbno - bno;
> > +			bno += lbno - bno;
> > +		}
> > +		llen = min(llen, agbend + 1 - lbno);
> > +		blocks_freed += llen;
> > +		len -= llen;
> > +		bno += llen;
> > +	}
> > +
> > +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> > +
> > +	error = xfs_reflinkbt_adjust_refcount(mp, tp, agbp, agno, agbno, aglen,
> > +					      -1);
> 
> Hmmm - we just walked the btree to determine what extents to
> free, and now we are going to walk the btree again to drop the
> reference counts on shared extents? So every extent that gets freed
> does two walks of the reflink btree regardless of the whether it has
> shared blocks or not?

Yeah, it would be more efficient to bundle the xfs_bmap_add_free loop
into adjust_refcount() so that we only have to make one pass.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
