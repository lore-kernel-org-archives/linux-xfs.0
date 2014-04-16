Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 23FCE7F37
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 08:25:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D19EE8F8066
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 06:25:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WavtcbLCpbDpFShA for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 06:25:07 -0700 (PDT)
Date: Wed, 16 Apr 2014 09:25:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 9/9] repair: detect and handle attribute tree CRC errors
Message-ID: <20140416132503.GC4180@laptop.bfoster>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397550301-31883-10-git-send-email-david@fromorbit.com>
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

On Tue, Apr 15, 2014 at 06:25:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently the attribute code will not detect and correct errors in
> the attribute tree. It also fails to validate the CRCs and headers
> on remote attribute blocks. Ensure that all the attribute blocks are
> CRC checked and that the processing functions understand the correct
> block formats for decoding.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/attr_repair.c | 35 ++++++++++++++++++++++++++++-------
>  1 file changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index ba85ac2..13ec90e 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -611,6 +611,8 @@ verify_da_path(xfs_mount_t	*mp,
>  		ASSERT(cursor->level[this_level].dirty == 0 ||
>  			(cursor->level[this_level].dirty && !no_modify));
>  
> +		if (bp->b_error == EFSBADCRC)
> +			cursor->level[this_level].dirty++;

I was wondering why this wasn't checked closer to the readbuf call, then
I noticed the assert. Any reason not to be consistent with the other
changes, move this up closer to the call and nuke the assert?

>  		if (cursor->level[this_level].dirty && !no_modify)
>  			libxfs_writebuf(cursor->level[this_level].bp, 0);
>  		else
> @@ -974,6 +976,10 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
>  	xfs_dfsbno_t	bno;
>  	xfs_buf_t	*bp;
>  	int		clearit = 0, i = 0, length = 0, amountdone = 0;
> +	int		hdrsize = 0;
> +
> +	if (xfs_sb_version_hascrc(&mp->m_sb))
> +		hdrsize = sizeof(struct xfs_attr3_rmt_hdr);
>  
>  	/* ASSUMPTION: valuelen is a valid number, so use it for looping */
>  	/* Note that valuelen is not a multiple of blocksize */
> @@ -986,16 +992,26 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
>  			break;
>  		}
>  		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
> -				XFS_FSB_TO_BB(mp, 1), 0, NULL);
> +				    XFS_FSB_TO_BB(mp, 1), 0,
> +				    &xfs_attr3_rmt_buf_ops);
>  		if (!bp) {
>  			do_warn(
>  	_("can't read remote block for attributes of inode %" PRIu64 "\n"), ino);
>  			clearit = 1;
>  			break;
>  		}
> +
> +		if (bp->b_error == EFSBADCRC || bp->b_error == EFSCORRUPTED) {
> +			do_warn(
> +	_("Corrupt remote block for attributes of inode %" PRIu64 "\n"), ino);
> +			clearit = 1;
> +			break;
> +		}
> +
>  		ASSERT(mp->m_sb.sb_blocksize == XFS_BUF_COUNT(bp));
> -		length = MIN(XFS_BUF_COUNT(bp), valuelen - amountdone);
> -		memmove(value, XFS_BUF_PTR(bp), length);
> +
> +		length = MIN(XFS_BUF_COUNT(bp) - hdrsize, valuelen - amountdone);
> +		memmove(value, XFS_BUF_PTR(bp) + hdrsize, length);
>  		amountdone += length;
>  		value += length;
>  		i++;
> @@ -1320,13 +1336,16 @@ process_leaf_attr_level(xfs_mount_t	*mp,
>  		}
>  
>  		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, dev_bno),
> -					XFS_FSB_TO_BB(mp, 1), 0, NULL);
> +				    XFS_FSB_TO_BB(mp, 1), 0,
> +				    &xfs_attr3_leaf_buf_ops);
>  		if (!bp) {
>  			do_warn(
>  	_("can't read file block %u (fsbno %" PRIu64 ") for attribute fork of inode %" PRIu64 "\n"),
>  				da_bno, dev_bno, ino);
>  			goto error_out;
>  		}
> +		if (bp->b_error == EFSBADCRC)
> +			repair++;

Could you remind me why we only check EFSBADCRC in some places and
EFSCORRUPTED as well in others?

>  
>  		leaf = bp->b_addr;
>  		xfs_attr3_leaf_hdr_from_disk(&leafhdr, leaf);
> @@ -1382,9 +1401,9 @@ process_leaf_attr_level(xfs_mount_t	*mp,
>  
>  		current_hashval = greatest_hashval;
>  
> -		if (repair && !no_modify) 
> +		if (repair && !no_modify)
>  			libxfs_writebuf(bp, 0);
> -		else 
> +		else
>  			libxfs_putbuf(bp);
>  	} while (da_bno != 0);
>  
> @@ -1512,6 +1531,8 @@ process_longform_attr(
>  			ino);
>  		return(1);
>  	}
> +	if (bp->b_error == EFSBADCRC)
> +		(*repair)++;

Note that repair is unconditionally reset to 0 at the beginning of
process_leaf_attr_block() (in the XFS_ATTR_LEAF_MAGIC case further down
this function).

Brian

>  
>  	/* verify leaf block */
>  	leaf = (xfs_attr_leafblock_t *)XFS_BUF_PTR(bp);
> @@ -1555,7 +1576,7 @@ process_longform_attr(
>  	case XFS_DA_NODE_MAGIC:		/* btree-form attribute */
>  	case XFS_DA3_NODE_MAGIC:
>  		/* must do this now, to release block 0 before the traversal */
> -		if (repairlinks) {
> +		if (*repair || repairlinks) {
>  			*repair = 1;
>  			libxfs_writebuf(bp, 0);
>  		} else
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
