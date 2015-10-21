Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B13F129DF5
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 16:40:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F2A9304066
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 14:40:08 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id P5neMQGwD4wELoPE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 21 Oct 2015 14:40:01 -0700 (PDT)
Date: Wed, 21 Oct 2015 14:39:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 25/58] xfs: bmap btree changes should update rmap btree
Message-ID: <20151021213953.GN10397@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
	<20151007045752.30457.78721.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151007045752.30457.78721.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Oct 06, 2015 at 09:57:52PM -0700, Darrick J. Wong wrote:
> Any update to a file's bmap should make the corresponding change to
> the rmapbt.  On a reflink filesystem, this is absolutely required
> because a given (file data) physical block can have multiple owners
> and the only sane way to find an rmap given a bmap is if there is a
> 1:1 correspondence.
> 
> (At some point we can optimize this for non-reflink filesystems
> because regular merge still works there.)

Still working on this; xfs_repair will have to be taught to merge the
extent rmaps for non-reflink filesystems, and the functions that are
called by the functions in xfs_bmap.c will of course need to be shut
off on !reflink.

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       |  262 ++++++++++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_bmap.h       |    1 
>  fs/xfs/libxfs/xfs_rmap.c       |  296 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_rmap_btree.h |   20 +++
>  4 files changed, 568 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index e740ef5..81f0ae0 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -45,6 +45,7 @@
>  #include "xfs_symlink.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_filestream.h"
> +#include "xfs_rmap_btree.h"
>  
>  
>  kmem_zone_t		*xfs_bmap_free_item_zone;
> @@ -1861,6 +1862,10 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		error = xfs_rmap_combine(bma->rcur, bma->ip->i_ino,
> +				XFS_DATA_FORK, &LEFT, &RIGHT, &PREV);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
> @@ -1893,6 +1898,10 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		error = xfs_rmap_lcombine(bma->rcur, bma->ip->i_ino,
> +				XFS_DATA_FORK, &LEFT, &PREV);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
> @@ -1924,6 +1933,10 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		error = xfs_rmap_rcombine(bma->rcur, bma->ip->i_ino,
> +				XFS_DATA_FORK, &RIGHT, &PREV, new);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
> @@ -1953,6 +1966,10 @@ xfs_bmap_add_extent_delay_real(
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  		}
> +		error = xfs_rmap_insert(bma->rcur, bma->ip->i_ino,
> +				XFS_DATA_FORK, new);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
> @@ -1988,6 +2005,10 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		error = xfs_rmap_lcombine(bma->rcur, bma->ip->i_ino,
> +				XFS_DATA_FORK, &LEFT, new);
> +		if (error)
> +			goto done;
>  		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
>  			startblockval(PREV.br_startblock));
>  		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
> @@ -2023,6 +2044,10 @@ xfs_bmap_add_extent_delay_real(
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  		}
> +		error = xfs_rmap_insert(bma->rcur, bma->ip->i_ino,
> +				XFS_DATA_FORK, new);
> +		if (error)
> +			goto done;
>  
>  		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
>  			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
> @@ -2071,6 +2096,8 @@ xfs_bmap_add_extent_delay_real(
>  			if (error)
>  				goto done;
>  		}
> +		error = xfs_rmap_rcombine(bma->rcur, bma->ip->i_ino,
> +				XFS_DATA_FORK, &RIGHT, new, new);
>  
>  		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
>  			startblockval(PREV.br_startblock));
> @@ -2107,6 +2134,10 @@ xfs_bmap_add_extent_delay_real(
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  		}
> +		error = xfs_rmap_insert(bma->rcur, bma->ip->i_ino,
> +				XFS_DATA_FORK, new);
> +		if (error)
> +			goto done;
>  
>  		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
>  			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
> @@ -2176,6 +2207,10 @@ xfs_bmap_add_extent_delay_real(
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  		}
> +		error = xfs_rmap_insert(bma->rcur, bma->ip->i_ino,
> +				XFS_DATA_FORK, new);
> +		if (error)
> +			goto done;
>  
>  		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
>  			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
> @@ -2271,7 +2306,8 @@ xfs_bmap_add_extent_unwritten_real(
>  	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
>  	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
>  	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
> -	int			*logflagsp) /* inode logging flags */
> +	int			*logflagsp, /* inode logging flags */
> +	struct xfs_btree_cur	*rcur)/* rmap btree pointer */
>  {
>  	xfs_btree_cur_t		*cur;	/* btree cursor */
>  	xfs_bmbt_rec_host_t	*ep;	/* extent entry for idx */
> @@ -2417,6 +2453,10 @@ xfs_bmap_add_extent_unwritten_real(
>  				RIGHT.br_blockcount, LEFT.br_state)))
>  				goto done;
>  		}
> +		error = xfs_rmap_combine(rcur, ip->i_ino,
> +				XFS_DATA_FORK, &LEFT, &RIGHT, &PREV);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
> @@ -2454,6 +2494,10 @@ xfs_bmap_add_extent_unwritten_real(
>  				LEFT.br_state)))
>  				goto done;
>  		}
> +		error = xfs_rmap_lcombine(rcur, ip->i_ino,
> +				XFS_DATA_FORK, &LEFT, &PREV);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
> @@ -2489,6 +2533,10 @@ xfs_bmap_add_extent_unwritten_real(
>  				newext)))
>  				goto done;
>  		}
> +		error = xfs_rmap_rcombine(rcur, ip->i_ino,
> +				XFS_DATA_FORK, &RIGHT, &PREV, new);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:

Missing a xfs_rmap operation to update the rmap here.

> @@ -2562,6 +2610,14 @@ xfs_bmap_add_extent_unwritten_real(
>  			if (error)
>  				goto done;
>  		}
> +		error = xfs_rmap_move(rcur, ip->i_ino,
> +				XFS_DATA_FORK, &PREV, new->br_blockcount);
> +		if (error)
> +			goto done;
> +		error = xfs_rmap_resize(rcur, ip->i_ino,
> +				XFS_DATA_FORK, &LEFT, -new->br_blockcount);

The move operation moves the start of PREV rightward, so the arg to resize
should be positive to make LEFT bigger.

> +		if (error)
> +			goto done;
>  		break;
>  
>  	case BMAP_LEFT_FILLING:
> @@ -2600,6 +2656,14 @@ xfs_bmap_add_extent_unwritten_real(
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  		}
> +		error = xfs_rmap_move(rcur, ip->i_ino,
> +				XFS_DATA_FORK, &PREV, new->br_blockcount);
> +		if (error)
> +			goto done;
> +		error = xfs_rmap_insert(rcur, ip->i_ino,
> +				XFS_DATA_FORK, new);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
> @@ -2642,6 +2706,14 @@ xfs_bmap_add_extent_unwritten_real(
>  				newext)))
>  				goto done;
>  		}
> +		error = xfs_rmap_resize(rcur, ip->i_ino,
> +				XFS_DATA_FORK, &PREV, -new->br_blockcount);
> +		if (error)
> +			goto done;
> +		error = xfs_rmap_move(rcur, ip->i_ino,
> +				XFS_DATA_FORK, &RIGHT, -new->br_blockcount);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case BMAP_RIGHT_FILLING:
> @@ -2682,6 +2754,14 @@ xfs_bmap_add_extent_unwritten_real(
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  		}
> +		error = xfs_rmap_resize(rcur, ip->i_ino,
> +				XFS_DATA_FORK, &PREV, -new->br_blockcount);
> +		if (error)
> +			goto done;
> +		error = xfs_rmap_insert(rcur, ip->i_ino,
> +				XFS_DATA_FORK, new);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case 0:
> @@ -2743,6 +2823,17 @@ xfs_bmap_add_extent_unwritten_real(
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  		}
> +		error = xfs_rmap_resize(rcur, ip->i_ino, XFS_DATA_FORK, &PREV,
> +				new->br_startoff - PREV.br_startoff -
> +				PREV.br_blockcount);
> +		if (error)
> +			goto done;
> +		error = xfs_rmap_insert(rcur, ip->i_ino, XFS_DATA_FORK, new);
> +		if (error)
> +			goto done;
> +		error = xfs_rmap_insert(rcur, ip->i_ino, XFS_DATA_FORK, &r[1]);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
> @@ -2946,6 +3037,7 @@ xfs_bmap_add_extent_hole_real(
>  	int			rval=0;	/* return value (logging flags) */
>  	int			state;	/* state bits, accessed thru macros */
>  	struct xfs_mount	*mp;
> +	struct xfs_bmbt_irec	prev;	/* fake previous extent entry */
>  
>  	mp = bma->tp ? bma->tp->t_mountp : NULL;
>  	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
> @@ -3053,6 +3145,12 @@ xfs_bmap_add_extent_hole_real(
>  			if (error)
>  				goto done;
>  		}
> +		prev = *new;
> +		prev.br_startblock = nullstartblock(0);
> +		error = xfs_rmap_combine(bma->rcur, bma->ip->i_ino,
> +				whichfork, &left, &right, &prev);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case BMAP_LEFT_CONTIG:
> @@ -3085,6 +3183,10 @@ xfs_bmap_add_extent_hole_real(
>  			if (error)
>  				goto done;
>  		}
> +		error = xfs_rmap_resize(bma->rcur, bma->ip->i_ino,
> +				whichfork, &left, new->br_blockcount);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case BMAP_RIGHT_CONTIG:
> @@ -3119,6 +3221,10 @@ xfs_bmap_add_extent_hole_real(
>  			if (error)
>  				goto done;
>  		}
> +		error = xfs_rmap_move(bma->rcur, bma->ip->i_ino,
> +				whichfork, &right, -new->br_blockcount);
> +		if (error)
> +			goto done;
>  		break;
>  
>  	case 0:
> @@ -3147,6 +3253,10 @@ xfs_bmap_add_extent_hole_real(
>  				goto done;
>  			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
>  		}
> +		error = xfs_rmap_insert(bma->rcur, bma->ip->i_ino,
> +				whichfork, new);
> +		if (error)
> +			goto done;
>  		break;
>  	}
>  
> @@ -4276,6 +4386,59 @@ xfs_bmapi_delay(
>  	return 0;
>  }
>  
> +static int
> +alloc_rcur(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xfs_btree_cur	**pcur,
> +	xfs_fsblock_t		fsblock)
> +{
> +	struct xfs_btree_cur	*cur = *pcur;
> +	struct xfs_buf		*agbp;
> +	int			error;
> +	xfs_agnumber_t		agno;
> +
> +	agno = XFS_FSB_TO_AGNO(mp, fsblock);
> +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		return 0;
> +	if (cur && cur->bc_private.a.agno == agno)
> +		return 0;
> +	if (isnullstartblock(fsblock))
> +		return 0;
> +
> +	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
> +	if (error)
> +		return error;
> +
> +	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
> +	if (!cur) {
> +		xfs_trans_brelse(tp, agbp);
> +		return -ENOMEM;
> +	}
> +
> +	*pcur = cur;
> +	return 0;
> +}
> +
> +static void
> +free_rcur(
> +	struct xfs_btree_cur	**pcur,
> +	int			bt_error)
> +{
> +	struct xfs_btree_cur	*cur = *pcur;
> +	struct xfs_buf		*agbp;
> +	struct xfs_trans	*tp;
> +
> +	if (cur == NULL)
> +		return;
> +
> +	agbp = cur->bc_private.a.agbp;
> +	tp = cur->bc_tp;
> +	xfs_btree_del_cursor(cur, bt_error);
> +	xfs_trans_brelse(tp, agbp);
> +
> +	*pcur = NULL;
> +}

So this whole strategy of updating rmaps right after updating the bmbt
has an unfortunate flaw -- we iterate file extents in logical offset
order, which means that we have no guarantee that the extents we
process will be in order of increasing AG.  This violates the deadlock
prevention rule that says we must only lock thing in increasing AG
order, and indeed I've seen some deadlocks with generic/013.

A solution to this is to pursue a strategy similar to the
xfs_bmap_free list handling -- collect rmap update intents in a list
that's kept sorted in first AG and then chronological order, then when
we're done making bmbt updates we can use xfs_trans_roll to make all
the rmapbt updates in AG order as part of a separate transaction.

I don't know if that's a good strategy since it means that bmbt and
rmapbt updates commit in different transactions, but it at least gets
rid of some deadlock opportunities.

A side benefit is that we can hang the rmap intents off the
xfs_bmap_free structure which should reduce the amount of code
changes.

>  
>  static int
>  xfs_bmapi_allocate(
> @@ -4368,6 +4531,10 @@ xfs_bmapi_allocate(
>  	    xfs_sb_version_hasextflgbit(&mp->m_sb))
>  		bma->got.br_state = XFS_EXT_UNWRITTEN;
>  
> +	error = alloc_rcur(mp, bma->tp, &bma->rcur, bma->got.br_startblock);
> +	if (error)
> +		return error;
> +
>  	if (bma->wasdel)
>  		error = xfs_bmap_add_extent_delay_real(bma);
>  	else
> @@ -4429,9 +4596,14 @@ xfs_bmapi_convert_unwritten(
>  	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
>  				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
>  
> +	error = alloc_rcur(bma->ip->i_mount, bma->tp, &bma->rcur,
> +			mval->br_startblock);
> +	if (error)
> +		return error;
> +
>  	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, &bma->idx,
>  			&bma->cur, mval, bma->firstblock, bma->flist,
> -			&tmp_logflags);
> +			&tmp_logflags, bma->rcur);
>  	/*
>  	 * Log the inode core unconditionally in the unwritten extent conversion
>  	 * path because the conversion might not have done so (e.g., if the
> @@ -4633,6 +4805,7 @@ xfs_bmapi_write(
>  	}
>  	*nmap = n;
>  
> +	free_rcur(&bma.rcur, XFS_BTREE_NOERROR);
>  	/*
>  	 * Transform from btree to extents, give it cur.
>  	 */
> @@ -4652,6 +4825,7 @@ xfs_bmapi_write(
>  		XFS_IFORK_MAXEXT(ip, whichfork));
>  	error = 0;
>  error0:
> +	free_rcur(&bma.rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
>  	/*
>  	 * Log everything.  Do this after conversion, there's no point in
>  	 * logging the extent records if we've converted to btree format.
> @@ -4704,7 +4878,8 @@ xfs_bmap_del_extent(
>  	xfs_btree_cur_t		*cur,	/* if null, not a btree */
>  	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
>  	int			*logflagsp, /* inode logging flags */
> -	int			whichfork) /* data or attr fork */
> +	int			whichfork, /* data or attr fork */
> +	struct xfs_btree_cur	*rcur)	/* rmap btree */
>  {
>  	xfs_filblks_t		da_new;	/* new delay-alloc indirect blocks */
>  	xfs_filblks_t		da_old;	/* old delay-alloc indirect blocks */
> @@ -4822,6 +4997,9 @@ xfs_bmap_del_extent(
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
>  			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
>  		flags |= XFS_ILOG_CORE;
> +		error = xfs_rmap_delete(rcur, ip->i_ino, whichfork, &got);
> +		if (error)
> +			goto done;
>  		if (!cur) {
>  			flags |= xfs_ilog_fext(whichfork);
>  			break;
> @@ -4849,6 +5027,10 @@ xfs_bmap_del_extent(
>  		}
>  		xfs_bmbt_set_startblock(ep, del_endblock);
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
> +		error = xfs_rmap_move(rcur, ip->i_ino, whichfork,
> +				&got, del->br_blockcount);
> +		if (error)
> +			goto done;
>  		if (!cur) {
>  			flags |= xfs_ilog_fext(whichfork);
>  			break;
> @@ -4875,6 +5057,10 @@ xfs_bmap_del_extent(
>  			break;
>  		}
>  		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
> +		error = xfs_rmap_resize(rcur, ip->i_ino, whichfork,
> +				&got, -del->br_blockcount);
> +		if (error)
> +			goto done;
>  		if (!cur) {
>  			flags |= xfs_ilog_fext(whichfork);
>  			break;
> @@ -4900,6 +5086,15 @@ xfs_bmap_del_extent(
>  		if (!delay) {
>  			new.br_startblock = del_endblock;
>  			flags |= XFS_ILOG_CORE;
> +			error = xfs_rmap_resize(rcur, ip->i_ino,
> +					whichfork, &got,
> +					temp - got.br_blockcount);
> +			if (error)
> +				goto done;
> +			error = xfs_rmap_insert(rcur, ip->i_ino,
> +					whichfork, &new);
> +			if (error)
> +				goto done;
>  			if (cur) {
>  				if ((error = xfs_bmbt_update(cur,
>  						got.br_startoff,
> @@ -5052,6 +5247,7 @@ xfs_bunmapi(
>  	int			wasdel;		/* was a delayed alloc extent */
>  	int			whichfork;	/* data or attribute fork */
>  	xfs_fsblock_t		sum;
> +	struct xfs_btree_cur	*rcur = NULL;	/* rmap btree */
>  
>  	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
>  
> @@ -5136,6 +5332,11 @@ xfs_bunmapi(
>  			got.br_startoff + got.br_blockcount - 1);
>  		if (bno < start)
>  			break;
> +
> +		error = alloc_rcur(mp, tp, &rcur, got.br_startblock);
> +		if (error)
> +			goto error0;
> +
>  		/*
>  		 * Then deal with the (possibly delayed) allocated space
>  		 * we found.
> @@ -5195,7 +5396,7 @@ xfs_bunmapi(
>  			del.br_state = XFS_EXT_UNWRITTEN;
>  			error = xfs_bmap_add_extent_unwritten_real(tp, ip,
>  					&lastx, &cur, &del, firstblock, flist,
> -					&logflags);
> +					&logflags, rcur);
>  			if (error)
>  				goto error0;
>  			goto nodelete;
> @@ -5253,7 +5454,8 @@ xfs_bunmapi(
>  				lastx--;
>  				error = xfs_bmap_add_extent_unwritten_real(tp,
>  						ip, &lastx, &cur, &prev,
> -						firstblock, flist, &logflags);
> +						firstblock, flist, &logflags,
> +						rcur);
>  				if (error)
>  					goto error0;
>  				goto nodelete;
> @@ -5262,7 +5464,8 @@ xfs_bunmapi(
>  				del.br_state = XFS_EXT_UNWRITTEN;
>  				error = xfs_bmap_add_extent_unwritten_real(tp,
>  						ip, &lastx, &cur, &del,
> -						firstblock, flist, &logflags);
> +						firstblock, flist, &logflags,
> +						rcur);
>  				if (error)
>  					goto error0;
>  				goto nodelete;
> @@ -5315,7 +5518,7 @@ xfs_bunmapi(
>  			goto error0;
>  		}
>  		error = xfs_bmap_del_extent(ip, tp, &lastx, flist, cur, &del,
> -				&tmp_logflags, whichfork);
> +				&tmp_logflags, whichfork, rcur);
>  		logflags |= tmp_logflags;
>  		if (error)
>  			goto error0;
> @@ -5339,6 +5542,7 @@ nodelete:
>  	}
>  	*done = bno == (xfs_fileoff_t)-1 || bno < start || lastx < 0;
>  
> +	free_rcur(&rcur, XFS_BTREE_NOERROR);
>  	/*
>  	 * Convert to a btree if necessary.
>  	 */
> @@ -5366,6 +5570,7 @@ nodelete:
>  	 */
>  	error = 0;
>  error0:
> +	free_rcur(&rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
>  	/*
>  	 * Log everything.  Do this after conversion, there's no point in
>  	 * logging the extent records if we've converted to btree format.
> @@ -5438,7 +5643,8 @@ xfs_bmse_merge(
>  	struct xfs_bmbt_rec_host	*gotp,		/* extent to shift */
>  	struct xfs_bmbt_rec_host	*leftp,		/* preceding extent */
>  	struct xfs_btree_cur		*cur,
> -	int				*logflags)	/* output */
> +	int				*logflags,	/* output */
> +	struct xfs_btree_cur		*rcur)		/* rmap btree */
>  {
>  	struct xfs_bmbt_irec		got;
>  	struct xfs_bmbt_irec		left;
> @@ -5469,6 +5675,13 @@ xfs_bmse_merge(
>  	XFS_IFORK_NEXT_SET(ip, whichfork,
>  			   XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
>  	*logflags |= XFS_ILOG_CORE;
> +	error = xfs_rmap_resize(rcur, ip->i_ino, whichfork, &left,
> +			blockcount - left.br_blockcount);
> +	if (error)
> +		return error;
> +	error = xfs_rmap_delete(rcur, ip->i_ino, whichfork, &got);
> +	if (error)
> +		return error;
>  	if (!cur) {
>  		*logflags |= XFS_ILOG_DEXT;
>  		return 0;
> @@ -5511,7 +5724,8 @@ xfs_bmse_shift_one(
>  	struct xfs_bmbt_rec_host	*gotp,
>  	struct xfs_btree_cur		*cur,
>  	int				*logflags,
> -	enum shift_direction		direction)
> +	enum shift_direction		direction,
> +	struct xfs_btree_cur		*rcur)
>  {
>  	struct xfs_ifork		*ifp;
>  	struct xfs_mount		*mp;
> @@ -5561,7 +5775,7 @@ xfs_bmse_shift_one(
>  				       offset_shift_fsb)) {
>  			return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
>  					      *current_ext, gotp, adj_irecp,
> -					      cur, logflags);
> +					      cur, logflags, rcur);
>  		}
>  	} else {
>  		startoff = got.br_startoff + offset_shift_fsb;
> @@ -5598,6 +5812,10 @@ update_current_ext:
>  		(*current_ext)--;
>  	xfs_bmbt_set_startoff(gotp, startoff);
>  	*logflags |= XFS_ILOG_CORE;
> +	error = xfs_rmap_slide(rcur, ip->i_ino, whichfork,
> +			&got, startoff - got.br_startoff);
> +	if (error)
> +		return error;
>  	if (!cur) {
>  		*logflags |= XFS_ILOG_DEXT;
>  		return 0;
> @@ -5649,6 +5867,7 @@ xfs_bmap_shift_extents(
>  	int				error = 0;
>  	int				whichfork = XFS_DATA_FORK;
>  	int				logflags = 0;
> +	struct xfs_btree_cur		*rcur = NULL;
>  
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> @@ -5737,9 +5956,14 @@ xfs_bmap_shift_extents(
>  	}
>  
>  	while (nexts++ < num_exts) {
> +		xfs_bmbt_get_all(gotp, &got);
> +		error = alloc_rcur(mp, tp, &rcur, got.br_startblock);
> +		if (error)
> +			return error;
> +
>  		error = xfs_bmse_shift_one(ip, whichfork, offset_shift_fsb,
>  					   &current_ext, gotp, cur, &logflags,
> -					   direction);
> +					   direction, rcur);
>  		if (error)
>  			goto del_cursor;
>  		/*
> @@ -5765,6 +5989,7 @@ xfs_bmap_shift_extents(
>  	}
>  
>  del_cursor:
> +	free_rcur(&rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
>  	if (cur)
>  		xfs_btree_del_cursor(cur,
>  			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> @@ -5801,6 +6026,7 @@ xfs_bmap_split_extent_at(
>  	int				error = 0;
>  	int				logflags = 0;
>  	int				i = 0;
> +	struct xfs_btree_cur		*rcur = NULL;
>  
>  	if (unlikely(XFS_TEST_ERROR(
>  	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
> @@ -5895,6 +6121,18 @@ xfs_bmap_split_extent_at(
>  		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, del_cursor);
>  	}
>  
> +	/* update rmapbt */
> +	error = alloc_rcur(mp, tp, &rcur, new.br_startblock);
> +	if (error)
> +		goto del_cursor;
> +	error = xfs_rmap_resize(rcur, ip->i_ino, whichfork, &got, -gotblkcnt);

got is modified by the previous code clause, so this causes incorrect
rmap entries to end up in the rmapbt.

> +	if (error)
> +		goto del_cursor;
> +	error = xfs_rmap_insert(rcur, ip->i_ino, whichfork, &new);
> +	if (error)
> +		goto del_cursor;
> +	free_rcur(&rcur, XFS_BTREE_NOERROR);
> +
>  	/*
>  	 * Convert to a btree if necessary.
>  	 */
> @@ -5908,6 +6146,8 @@ xfs_bmap_split_extent_at(
>  	}
>  
>  del_cursor:
> +	free_rcur(&rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> +
>  	if (cur) {
>  		cur->bc_private.b.allocated = 0;
>  		xfs_btree_del_cursor(cur,
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 89fa3dd..59f26cf 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -56,6 +56,7 @@ struct xfs_bmalloca {
>  	bool			aeof;	/* allocated space at eof */
>  	bool			conv;	/* overwriting unwritten extents */
>  	int			flags;
> +	struct xfs_btree_cur	*rcur;	/* rmap btree cursor */
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 045f9a7..d821b1a 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -563,3 +563,299 @@ out_error:
>  	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>  	return error;
>  }
> +
> +/* Encode logical offset for a rmapbt record */
> +STATIC uint64_t
> +b2r_off(
> +	int		whichfork,
> +	xfs_fileoff_t	off)
> +{
> +	uint64_t	x;
> +
> +	x = off;
> +	if (whichfork == XFS_ATTR_FORK)
> +		x |= XFS_RMAP_OFF_ATTR;
> +	return x;
> +}
> +
> +/* Encode blockcount for a rmapbt record */
> +STATIC xfs_extlen_t
> +b2r_len(
> +	struct xfs_bmbt_irec	*irec)
> +{
> +	xfs_extlen_t		x;
> +
> +	x = irec->br_blockcount;
> +	if (irec->br_state == XFS_EXT_UNWRITTEN)
> +		x |= XFS_RMAP_LEN_UNWRITTEN;
> +	return x;
> +}
> +
> +/* Combine two adjacent rmap extents */
> +int
> +xfs_rmap_combine(
> +	struct xfs_btree_cur	*rcur,
> +	xfs_ino_t		ino,
> +	int			whichfork,
> +	struct xfs_bmbt_irec	*LEFT,
> +	struct xfs_bmbt_irec	*RIGHT,
> +	struct xfs_bmbt_irec	*PREV)
> +{
> +	int			error;
> +
> +	if (!rcur)
> +		return 0;
> +
> +	trace_xfs_rmap_combine(rcur->bc_mp, rcur->bc_private.a.agno, ino,
> +			whichfork, LEFT, PREV, RIGHT);
> +
> +	/* Delete right rmap */
> +	error = xfs_rmapbt_delete(rcur,
> +			XFS_FSB_TO_AGBNO(rcur->bc_mp, RIGHT->br_startblock),
> +			b2r_len(RIGHT), ino,
> +			b2r_off(whichfork, RIGHT->br_startoff));
> +	if (error)
> +		goto done;
> +
> +	/* Delete prev rmap */
> +	if (!isnullstartblock(PREV->br_startblock)) {
> +		error = xfs_rmapbt_delete(rcur,
> +				XFS_FSB_TO_AGBNO(rcur->bc_mp,
> +						PREV->br_startblock),
> +				b2r_len(PREV), ino,
> +				b2r_off(whichfork, PREV->br_startoff));
> +		if (error)
> +			goto done;
> +	}
> +
> +	/* Enlarge left rmap */
> +	return xfs_rmap_resize(rcur, ino, whichfork, LEFT,
> +			PREV->br_blockcount + RIGHT->br_blockcount);
> +done:
> +	return error;
> +}
> +
> +/* Extend a left rmap extent */
> +int
> +xfs_rmap_lcombine(
> +	struct xfs_btree_cur	*rcur,
> +	xfs_ino_t		ino,
> +	int			whichfork,
> +	struct xfs_bmbt_irec	*LEFT,
> +	struct xfs_bmbt_irec	*PREV)
> +{
> +	int			error;
> +
> +	if (!rcur)
> +		return 0;
> +
> +	trace_xfs_rmap_lcombine(rcur->bc_mp, rcur->bc_private.a.agno, ino,
> +			whichfork, LEFT, PREV);
> +
> +	/* Delete prev rmap */
> +	if (!isnullstartblock(PREV->br_startblock)) {
> +		error = xfs_rmapbt_delete(rcur,
> +				XFS_FSB_TO_AGBNO(rcur->bc_mp,
> +						PREV->br_startblock),
> +				b2r_len(PREV), ino,
> +				b2r_off(whichfork, PREV->br_startoff));
> +		if (error)
> +			goto done;
> +	}
> +
> +	/* Enlarge left rmap */
> +	return xfs_rmap_resize(rcur, ino, whichfork, LEFT, PREV->br_blockcount);
> +done:
> +	return error;
> +}
> +
> +/* Extend a right rmap extent */
> +int
> +xfs_rmap_rcombine(
> +	struct xfs_btree_cur	*rcur,
> +	xfs_ino_t		ino,
> +	int			whichfork,
> +	struct xfs_bmbt_irec	*RIGHT,
> +	struct xfs_bmbt_irec	*PREV,
> +	struct xfs_bmbt_irec	*new)
> +{
> +	int			error;
> +
> +	if (!rcur)
> +		return 0;
> +	ASSERT(PREV->br_startoff == new->br_startoff);
> +
> +	trace_xfs_rmap_rcombine(rcur->bc_mp, rcur->bc_private.a.agno, ino,
> +			whichfork, RIGHT, PREV);
> +
> +	/* Delete prev rmap */
> +	if (!isnullstartblock(PREV->br_startblock)) {
> +		error = xfs_rmapbt_delete(rcur,
> +				XFS_FSB_TO_AGBNO(rcur->bc_mp,
> +						PREV->br_startblock),
> +				b2r_len(PREV), ino,
> +				b2r_off(whichfork, PREV->br_startoff));
> +		if (error)
> +			goto done;
> +	}
> +
> +	/* Enlarge right rmap */
> +	return xfs_rmap_resize(rcur, ino, whichfork, RIGHT,
> +			-PREV->br_blockcount);

The starting point of RIGHT should be moved leftward to the start of
PREV, so this is really an xfs_rmap_move(..., -PREV->br_blockcount);

--D

> +done:
> +	return error;
> +}
> +
> +/* Insert a rmap extent */
> +int
> +xfs_rmap_insert(
> +	struct xfs_btree_cur	*rcur,
> +	xfs_ino_t		ino,
> +	int			whichfork,
> +	struct xfs_bmbt_irec	*new)
> +{
> +	if (!rcur)
> +		return 0;
> +
> +	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_private.a.agno, ino,
> +			whichfork, new);
> +
> +	return xfs_rmapbt_insert(rcur,
> +			XFS_FSB_TO_AGBNO(rcur->bc_mp, new->br_startblock),
> +			b2r_len(new), ino,
> +			b2r_off(whichfork, new->br_startoff));
> +}
> +
> +/* Delete a rmap extent */
> +int
> +xfs_rmap_delete(
> +	struct xfs_btree_cur	*rcur,
> +	xfs_ino_t		ino,
> +	int			whichfork,
> +	struct xfs_bmbt_irec	*new)
> +{
> +	if (!rcur)
> +		return 0;
> +
> +	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_private.a.agno, ino,
> +			whichfork, new);
> +
> +	return xfs_rmapbt_delete(rcur,
> +			XFS_FSB_TO_AGBNO(rcur->bc_mp, new->br_startblock),
> +			b2r_len(new), ino,
> +			b2r_off(whichfork, new->br_startoff));
> +}
> +
> +/* Change the start of an rmap */
> +int
> +xfs_rmap_move(
> +	struct xfs_btree_cur	*rcur,
> +	xfs_ino_t		ino,
> +	int			whichfork,
> +	struct xfs_bmbt_irec	*PREV,
> +	long			start_adj)
> +{
> +	int			error;
> +	struct xfs_bmbt_irec	irec;
> +
> +	if (!rcur)
> +		return 0;
> +
> +	trace_xfs_rmap_move(rcur->bc_mp, rcur->bc_private.a.agno, ino,
> +			whichfork, PREV, start_adj);
> +
> +	/* Delete prev rmap */
> +	error = xfs_rmapbt_delete(rcur,
> +			XFS_FSB_TO_AGBNO(rcur->bc_mp, PREV->br_startblock),
> +			b2r_len(PREV), ino,
> +			b2r_off(whichfork, PREV->br_startoff));
> +	if (error)
> +		goto done;
> +
> +	/* Re-add rmap with new start */
> +	irec = *PREV;
> +	irec.br_startblock += start_adj;
> +	irec.br_startoff += start_adj;
> +	irec.br_blockcount -= start_adj;
> +	return xfs_rmapbt_insert(rcur,
> +			XFS_FSB_TO_AGBNO(rcur->bc_mp, irec.br_startblock),
> +			b2r_len(&irec), ino,
> +			b2r_off(whichfork, irec.br_startoff));
> +done:
> +	return error;
> +}
> +
> +/* Change the logical offset of an rmap */
> +int
> +xfs_rmap_slide(
> +	struct xfs_btree_cur	*rcur,
> +	xfs_ino_t		ino,
> +	int			whichfork,
> +	struct xfs_bmbt_irec	*PREV,
> +	long			start_adj)
> +{
> +	int			error;
> +
> +	if (!rcur)
> +		return 0;
> +
> +	trace_xfs_rmap_slide(rcur->bc_mp, rcur->bc_private.a.agno, ino,
> +			whichfork, PREV, start_adj);
> +
> +	/* Delete prev rmap */
> +	error = xfs_rmapbt_delete(rcur,
> +			XFS_FSB_TO_AGBNO(rcur->bc_mp, PREV->br_startblock),
> +			b2r_len(PREV), ino,
> +			b2r_off(whichfork, PREV->br_startoff));
> +	if (error)
> +		goto done;
> +
> +	/* Re-add rmap with new logical offset */
> +	return xfs_rmapbt_insert(rcur,
> +			XFS_FSB_TO_AGBNO(rcur->bc_mp, PREV->br_startblock),
> +			b2r_len(PREV), ino,
> +			b2r_off(whichfork, PREV->br_startoff + start_adj));
> +done:
> +	return error;
> +}
> +
> +/* Change the size of an rmap */
> +int
> +xfs_rmap_resize(
> +	struct xfs_btree_cur	*rcur,
> +	xfs_ino_t		ino,
> +	int			whichfork,
> +	struct xfs_bmbt_irec	*PREV,
> +	long			size_adj)
> +{
> +	int			i;
> +	int			error;
> +	struct xfs_bmbt_irec	irec;
> +	struct xfs_rmap_irec	rrec;
> +
> +	if (!rcur)
> +		return 0;
> +
> +	trace_xfs_rmap_resize(rcur->bc_mp, rcur->bc_private.a.agno, ino,
> +			whichfork, PREV, size_adj);
> +
> +	error = xfs_rmap_lookup_eq(rcur,
> +			XFS_FSB_TO_AGBNO(rcur->bc_mp, PREV->br_startblock),
> +			b2r_len(PREV), ino,
> +			b2r_off(whichfork, PREV->br_startoff), &i);
> +	if (error)
> +		goto done;
> +	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
> +	error = xfs_rmap_get_rec(rcur, &rrec, &i);
> +	if (error)
> +		goto done;
> +	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
> +	irec = *PREV;
> +	irec.br_blockcount += size_adj;
> +	rrec.rm_blockcount = b2r_len(&irec);
> +	error = xfs_rmap_update(rcur, &rrec);
> +	if (error)
> +		goto done;
> +done:
> +	return error;
> +}
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index d7c9722..0131d9a 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> @@ -68,4 +68,24 @@ int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
>  		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
>  		  struct xfs_owner_info *oinfo);
>  
> +/* functions for updating the rmapbt based on bmbt map/unmap operations */
> +int xfs_rmap_combine(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
> +		struct xfs_bmbt_irec *LEFT, struct xfs_bmbt_irec *RIGHT,
> +		struct xfs_bmbt_irec *PREV);
> +int xfs_rmap_lcombine(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
> +		struct xfs_bmbt_irec *LEFT, struct xfs_bmbt_irec *PREV);
> +int xfs_rmap_rcombine(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
> +		struct xfs_bmbt_irec *RIGHT, struct xfs_bmbt_irec *PREV,
> +		struct xfs_bmbt_irec *new);
> +int xfs_rmap_insert(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
> +		struct xfs_bmbt_irec *new);
> +int xfs_rmap_delete(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
> +		struct xfs_bmbt_irec *new);
> +int xfs_rmap_move(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
> +		struct xfs_bmbt_irec *PREV, long start_adj);
> +int xfs_rmap_slide(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
> +		struct xfs_bmbt_irec *PREV, long start_adj);
> +int xfs_rmap_resize(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
> +		struct xfs_bmbt_irec *PREV, long size_adj);
> +
>  #endif	/* __XFS_RMAP_BTREE_H__ */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
