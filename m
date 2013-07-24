Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E5C57F3F
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 16:29:53 -0500 (CDT)
Date: Wed, 24 Jul 2013 16:29:49 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 10/48] xfs: add CRC checking to dir2 free blocks
Message-ID: <20130724212949.GS3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-11-git-send-email-david@fromorbit.com>
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

On Fri, Jun 07, 2013 at 10:25:33AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This addition follows the same pattern as the dir2 block CRCs, but
> with a few differences. The main difference is that the free block
> header is different between the v2 and v3 formats, so an "in-core"
> free block header has been added and _todisk/_from_disk functions
> used to abstract the differences in structure format from the code.
> This is similar to the on-disk superblock versus the in-core
> superblock setup. The in-core strucutre is populated when the buffer
> is read from disk, all the in memory checks and modifications are
> done on the in-core version of the structure which is written back
> to the buffer before the buffer is logged.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Corresponds to cbc8adf8972

> diff --git a/include/xfs_dir2_format.h b/include/xfs_dir2_format.h
> index da928c7..5c28a6a 100644
> --- a/include/xfs_dir2_format.h
> +++ b/include/xfs_dir2_format.h

...

> +static int
> +xfs_dir3_free_get_buf(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*dp,
> +	xfs_dir2_db_t		fbno,
> +	struct xfs_buf		**bpp)
> +{
> +	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_buf		*bp;
> +	int			error;
> +	struct xfs_dir3_icfree_hdr hdr;
> +
> +	error = xfs_da_get_buf(tp, dp, xfs_dir2_db_to_da(mp, fbno),
> +				   -1, &bp, XFS_DATA_FORK);
> +	if (error)
> +		return error;
> +
> +	bp->b_ops = &xfs_dir3_free_buf_ops;;

Extra ;

> +
> +	/*
> +	 * Initialize the new block to be empty, and remember
> +	 * its first slot as our empty slot.
> +	 */
> +	hdr.magic = XFS_DIR2_FREE_MAGIC;
> +	hdr.firstdb = 0;
> +	hdr.nused = 0;
> +	hdr.nvalid = 0;
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		struct xfs_dir3_free_hdr *hdr3 = bp->b_addr;
> +
> +		hdr.magic = XFS_DIR3_FREE_MAGIC;
> +		hdr3->hdr.blkno = cpu_to_be64(bp->b_bn);
> +		hdr3->hdr.owner = cpu_to_be64(dp->i_ino);
> +		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_uuid);
> +

Extra line.

> @@ -883,7 +1031,7 @@ xfs_dir2_leafn_rebalance(
>  }
>  
>  static int
> -xfs_dir2_data_block_free(
> +xfs_dir3_data_block_free(

There were some differences in comments and whitespace between this version and
the one in the kernel.  I took a look and didn't see any functional changes
though.

> @@ -894,59 +1042,68 @@ xfs_dir2_data_block_free(
>  {
>  	struct xfs_trans	*tp = args->trans;
>  	int			logfree = 0;
> +	__be16			*bests;
> +	struct xfs_dir3_icfree_hdr freehdr;
>  
> -	if (!hdr) {
> -		/* One less used entry in the free table.  */
> -		be32_add_cpu(&free->hdr.nused, -1);
> -		xfs_dir2_free_log_header(tp, fbp);
>  
> -		/*
> -		 * If this was the last entry in the table, we can trim the
> -		 * table size back.  There might be other entries at the end
> -		 * referring to non-existent data blocks, get those too.
> -		 */
> -		if (findex == be32_to_cpu(free->hdr.nvalid) - 1) {
> -			int	i;		/* free entry index */
> +	xfs_dir3_free_hdr_from_disk(&freehdr, free);
>  
> -			for (i = findex - 1; i >= 0; i--) {
> -				if (free->bests[i] != cpu_to_be16(NULLDATAOFF))
> -					break;
> -			}
> -			free->hdr.nvalid = cpu_to_be32(i + 1);
> -			logfree = 0;
> -		} else {
> -			/* Not the last entry, just punch it out.  */
> -			free->bests[findex] = cpu_to_be16(NULLDATAOFF);
> -			logfree = 1;
> -		}
> +	bests = xfs_dir3_free_bests_p(tp->t_mountp, free);
> +	if (hdr) {
>  		/*
> -		 * If there are no useful entries left in the block,
> -		 * get rid of the block if we can.
> +		 * Data block is not empty, just set the free entry to the new
> +		 * value.
>  		 */
> -		if (!free->hdr.nused) {
> -			int error;
> +		bests[findex] = cpu_to_be16(longest);
> +		xfs_dir2_free_log_bests(tp, fbp, findex, findex);
> +		return 0;
> +	}
>  
> -			error = xfs_dir2_shrink_inode(args, fdb, fbp);
> -			if (error == 0) {
> -				fbp = NULL;
> -				logfree = 0;
> -			} else if (error != ENOSPC || args->total != 0)
> -				return error;
> -			/*
> -			 * It's possible to get ENOSPC if there is no
> -			 * space reservation.  In this case some one
> -			 * else will eventually get rid of this block.
> -			 */
> +	/*
> +	 * One less used entry in the free table. Unused is not converted
> +	 * because we only need to know if it zero
> +	 */
> +	freehdr.nused--;
> +
> +	if (findex == freehdr.nvalid - 1) {
> +		int	i;		/* free entry index */
> +
> +		for (i = findex - 1; i >= 0; i--) {
> +			if (bests[i] != cpu_to_be16(NULLDATAOFF))
> +				break;
>  		}
> +		freehdr.nvalid = i + 1;
> +		logfree = 0;
>  	} else {
> +		/* Not the last entry, just punch it out.  */
> +		bests[findex] = cpu_to_be16(NULLDATAOFF);
> +		logfree = 1;
> +	}
> +
> +	xfs_dir3_free_hdr_to_disk(free, &freehdr);
> +	xfs_dir2_free_log_header(tp, fbp);
> +
> +	/*
> +	 * If there are no useful entries left in the block, get rid of the
> +	 * block if we can.
> +	 */
> +	if (!freehdr.nused) {
> +		int error;
> +
> +		error = xfs_dir2_shrink_inode(args, fdb, fbp);
> +		if (error == 0) {
> +			fbp = NULL;
> +			logfree = 0;
> +		} else if (error != ENOSPC || args->total != 0)
> +			return error;
>  		/*
> -		 * Data block is not empty, just set the free entry to the new
> -		 * value.
> +		 * It's possible to get ENOSPC if there is no
> +		 * space reservation.  In this case some one
> +		 * else will eventually get rid of this block.
>  		 */
> -		free->bests[findex] = cpu_to_be16(longest);
> -		logfree = 1;
>  	}
>  
> +

Extra line


> @@ -1532,20 +1697,26 @@ xfs_dir2_node_addname_int(
>  			if (!fbp)
>  				continue;
>  			free = fbp->b_addr;
> -			ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
>  			findex = 0;
>  		}
>  		/*
>  		 * Look at the current free entry.  Is it good enough?
> +		 *
> +		 * The bests initialisation should be wher eteh bufer is read in

							where the

> +		 * the above branch. But gcc is too stupid to realise that bests
> +		 * iand the freehdr are actually initialised if they are placed

		   and

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
