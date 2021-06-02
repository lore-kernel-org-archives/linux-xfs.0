Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97496C4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 21:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 650EE600D4
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 21:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhFBVik (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 17:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229467AbhFBVij (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 17:38:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ED95613D7;
        Wed,  2 Jun 2021 21:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622669816;
        bh=muO08GfGsT1XEWOTyWdwgcE+TRqu3POs27Gs6DO5yUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XBBfBIlnHgMq8KmxONMjeUIzx1v4JabFN8mKO4Y/GWBuy3iE1NX049yBbuPY6rl0o
         EUHjnQghdMaycYqEil+A+sbMoUCXDvWr3Nxx0bwYol4chHzSEIJynvMaHohSB+ZoSL
         FQomTQfV4nXaf2qX/3MV/f1C2Vgo1aHYURzKmxgrnH90omV5J4LTftnRF8iGQap0DM
         mpKlaKVUFwme8mkAwW7M/FwJVK9RHVpqrnI0zeQsPOpgmXfE7mkM1t88Qv5YhyOO5c
         852xm5rA5/dL0tpO5PmBR2sOnstUNJK+lEGgopnERtBXbkerCWy2GvEZbgxvWn5DoW
         tRDKT3rMPQaDg==
Date:   Wed, 2 Jun 2021 14:36:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: factor free space tree transaciton reservations
Message-ID: <20210602213655.GL26380@locust>
References: <20210527045202.1155628-1-david@fromorbit.com>
 <20210527045202.1155628-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527045202.1155628-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 02:52:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Convert all the open coded free space tree modification reservations
> to use the new xfs_allocfree_extent_res() function.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c | 122 ++++++++++++---------------------
>  1 file changed, 45 insertions(+), 77 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 6363cacb790f..02079f55ef20 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -143,18 +143,16 @@ xfs_calc_inode_res(
>   * reservation:
>   *
>   * the inode btree: max depth * blocksize
> - * the allocation btrees: 2 trees * (max depth - 1) * block size
> + * one extent allocfree reservation for the AG.
>   *
> - * The caller must account for SB and AG header modifications, etc.
>   */
>  STATIC uint
>  xfs_calc_inobt_res(
>  	struct xfs_mount	*mp)
>  {
>  	return xfs_calc_buf_res(M_IGEO(mp)->inobt_maxlevels,
> -			XFS_FSB_TO_B(mp, 1)) +
> -				xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> -			XFS_FSB_TO_B(mp, 1));
> +				XFS_FSB_TO_B(mp, 1)) +
> +		xfs_allocfree_extent_res(mp);

Hm.  xfs_allocfree_extent_res computes the space to handle full splits
of both free space btrees and updates to the AGFL and AGF.

This function did not previously account for AG header updates -- it
only computes the space needed to log a split of an inode btree and
splits of both free space btrees.  It looks like xfs_calc_inobt_res's
callers themselves add reservation space for AG headers.

So, doesn't this introduce double-counting of the AGF for inode
operations?  It's probably not a big deal to allocate more space, but
this doesn't look like a straight refactoring.

>  }
>  
>  /*
> @@ -182,7 +180,7 @@ xfs_calc_finobt_res(
>   * Calculate the reservation required to allocate or free an inode chunk. This
>   * includes:
>   *
> - * the allocation btrees: 2 trees * (max depth - 1) * block size
> + * one extent allocfree reservation for the AG.
>   * the inode chunk: m_ino_geo.ialloc_blks * N
>   *
>   * The size N of the inode chunk reservation depends on whether it is for
> @@ -200,8 +198,7 @@ xfs_calc_inode_chunk_res(
>  {
>  	uint			res, size = 0;
>  
> -	res = xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> -			       XFS_FSB_TO_B(mp, 1));
> +	res = xfs_allocfree_extent_res(mp);

Same question here.

>  	if (alloc) {
>  		/* icreate tx uses ordered buffers */
>  		if (xfs_sb_version_has_v3inode(&mp->m_sb))
> @@ -256,22 +253,18 @@ xfs_rtalloc_log_count(
>   * extents.  This gives (t1):
>   *    the inode getting the new extents: inode size
>   *    the inode's bmap btree: max depth * block size
> - *    the agfs of the ags from which the extents are allocated: 2 * sector
>   *    the superblock free block counter: sector size
> - *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> + *    two extent allocfree reservations for the AG.
>   * Or, if we're writing to a realtime file (t2):
>   *    the inode getting the new extents: inode size
>   *    the inode's bmap btree: max depth * block size
> - *    the agfs of the ags from which the extents are allocated: 2 * sector
> + *    one extent allocfree reservation for the AG.
>   *    the superblock free block counter: sector size
>   *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
>   *    the realtime summary: 1 block
> - *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
>   * And the bmap_finish transaction can free bmap blocks in a join (t3):
> - *    the agfs of the ags containing the blocks: 2 * sector size
> - *    the agfls of the ags containing the blocks: 2 * sector size
>   *    the super block free block counter: sector size
> - *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> + *    two extent allocfree reservations for the AG.
>   */
>  STATIC uint
>  xfs_calc_write_reservation(
> @@ -282,8 +275,8 @@ xfs_calc_write_reservation(
>  
>  	t1 = xfs_calc_inode_res(mp, 1) +
>  	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), blksz) +
> -	     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> -	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> +	     xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> +	     xfs_allocfree_extent_res(mp) * 2;

This conversion looks ok.

>  
>  	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
>  		t2 = xfs_calc_inode_res(mp, 1) +
> @@ -291,13 +284,13 @@ xfs_calc_write_reservation(
>  				     blksz) +
>  		     xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
>  		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 1), blksz) +
> -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1), blksz);
> +		     xfs_allocfree_extent_res(mp);

Shouldn't this change the 3 above to 1?

Same questions for the rest of this patch.

--D

>  	} else {
>  		t2 = 0;
>  	}
>  
> -	t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> -	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> +	t3 = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> +	     xfs_allocfree_extent_res(mp) * 2;
>  
>  	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
>  }
> @@ -307,19 +300,13 @@ xfs_calc_write_reservation(
>   *    the inode being truncated: inode size
>   *    the inode's bmap btree: (max depth + 1) * block size
>   * And the bmap_finish transaction can free the blocks and bmap blocks (t2):
> - *    the agf for each of the ags: 4 * sector size
> - *    the agfl for each of the ags: 4 * sector size
>   *    the super block to reflect the freed blocks: sector size
> - *    worst case split in allocation btrees per extent assuming 4 extents:
> - *		4 exts * 2 trees * (2 * max depth - 1) * block size
> + *    four extent allocfree reservations for the AG.
>   * Or, if it's a realtime file (t3):
> - *    the agf for each of the ags: 2 * sector size
> - *    the agfl for each of the ags: 2 * sector size
>   *    the super block to reflect the freed blocks: sector size
>   *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
>   *    the realtime summary: 2 exts * 1 block
> - *    worst case split in allocation btrees per extent assuming 2 extents:
> - *		2 exts * 2 trees * (2 * max depth - 1) * block size
> + *    two extent allocfree reservations for the AG.
>   */
>  STATIC uint
>  xfs_calc_itruncate_reservation(
> @@ -331,13 +318,13 @@ xfs_calc_itruncate_reservation(
>  	t1 = xfs_calc_inode_res(mp, 1) +
>  	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
>  
> -	t2 = xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
> -	     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4), blksz);
> +	t2 = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> +	     xfs_allocfree_extent_res(mp) * 4;
>  
>  	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
> -		t3 = xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> +		t3 = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
>  		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
> -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2), blksz);
> +		     xfs_allocfree_extent_res(mp) * 2;
>  	} else {
>  		t3 = 0;
>  	}
> @@ -352,10 +339,8 @@ xfs_calc_itruncate_reservation(
>   *    the two directory bmap btrees: 2 * max depth * block size
>   * And the bmap_finish transaction can free dir and bmap blocks (two sets
>   *	of bmap blocks) giving:
> - *    the agf for the ags in which the blocks live: 3 * sector size
> - *    the agfl for the ags in which the blocks live: 3 * sector size
>   *    the superblock for the free block count: sector size
> - *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
> + *    three extent allocfree reservations for the AG.
>   */
>  STATIC uint
>  xfs_calc_rename_reservation(
> @@ -365,9 +350,8 @@ xfs_calc_rename_reservation(
>  		max((xfs_calc_inode_res(mp, 4) +
>  		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
>  				      XFS_FSB_TO_B(mp, 1))),
> -		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
> -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 3),
> -				      XFS_FSB_TO_B(mp, 1))));
> +		    (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> +		     xfs_allocfree_extent_res(mp) * 3));
>  }
>  
>  /*
> @@ -381,20 +365,19 @@ xfs_calc_iunlink_remove_reservation(
>  	struct xfs_mount        *mp)
>  {
>  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> -	       2 * M_IGEO(mp)->inode_cluster_size;
> +	       xfs_calc_buf_res(2, M_IGEO(mp)->inode_cluster_size);
>  }
>  
>  /*
>   * For creating a link to an inode:
> + *    the inode is removed from the iunlink list (O_TMPFILE)
>   *    the parent directory inode: inode size
>   *    the linked inode: inode size
>   *    the directory btree could split: (max depth + v2) * dir block size
>   *    the directory bmap btree could join or split: (max depth + v2) * blocksize
>   * And the bmap_finish transaction can free some bmap blocks giving:
> - *    the agf for the ag in which the blocks live: sector size
> - *    the agfl for the ag in which the blocks live: sector size
>   *    the superblock for the free block count: sector size
> - *    the allocation btrees: 2 trees * (2 * max depth - 1) * block size
> + *    one extent allocfree reservation for the AG.
>   */
>  STATIC uint
>  xfs_calc_link_reservation(
> @@ -405,9 +388,8 @@ xfs_calc_link_reservation(
>  		max((xfs_calc_inode_res(mp, 2) +
>  		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
>  				      XFS_FSB_TO_B(mp, 1))),
> -		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> -				      XFS_FSB_TO_B(mp, 1))));
> +		    (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> +		     xfs_allocfree_extent_res(mp)));
>  }
>  
>  /*
> @@ -419,20 +401,19 @@ STATIC uint
>  xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
>  {
>  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> -			M_IGEO(mp)->inode_cluster_size;
> +	       xfs_calc_buf_res(1, M_IGEO(mp)->inode_cluster_size);
>  }
>  
>  /*
>   * For removing a directory entry we can modify:
> + *    the inode is added to the agi unlinked list
>   *    the parent directory inode: inode size
>   *    the removed inode: inode size
>   *    the directory btree could join: (max depth + v2) * dir block size
>   *    the directory bmap btree could join or split: (max depth + v2) * blocksize
>   * And the bmap_finish transaction can free the dir and bmap blocks giving:
> - *    the agf for the ag in which the blocks live: 2 * sector size
> - *    the agfl for the ag in which the blocks live: 2 * sector size
>   *    the superblock for the free block count: sector size
> - *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> + *    two extent allocfree reservations for the AG.
>   */
>  STATIC uint
>  xfs_calc_remove_reservation(
> @@ -443,9 +424,8 @@ xfs_calc_remove_reservation(
>  		max((xfs_calc_inode_res(mp, 1) +
>  		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
>  				      XFS_FSB_TO_B(mp, 1))),
> -		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
> -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
> -				      XFS_FSB_TO_B(mp, 1))));
> +		    (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> +		     xfs_allocfree_extent_res(mp) * 2));
>  }
>  
>  /*
> @@ -581,16 +561,14 @@ xfs_calc_ichange_reservation(
>  /*
>   * Growing the data section of the filesystem.
>   *	superblock
> - *	agi and agf
> - *	allocation btrees
> + *      one extent allocfree reservation for the AG.
>   */
>  STATIC uint
>  xfs_calc_growdata_reservation(
>  	struct xfs_mount	*mp)
>  {
> -	return xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
> -		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> -				 XFS_FSB_TO_B(mp, 1));
> +	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> +	       xfs_allocfree_extent_res(mp);
>  }
>  
>  /*
> @@ -598,10 +576,9 @@ xfs_calc_growdata_reservation(
>   * In the first set of transactions (ALLOC) we allocate space to the
>   * bitmap or summary files.
>   *	superblock: sector size
> - *	agf of the ag from which the extent is allocated: sector size
>   *	bmap btree for bitmap/summary inode: max depth * blocksize
>   *	bitmap/summary inode: inode size
> - *	allocation btrees for 1 block alloc: 2 * (2 * maxdepth - 1) * blocksize
> + *      one extent allocfree reservation for the AG.
>   */
>  STATIC uint
>  xfs_calc_growrtalloc_reservation(
> @@ -611,8 +588,7 @@ xfs_calc_growrtalloc_reservation(
>  		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK),
>  				 XFS_FSB_TO_B(mp, 1)) +
>  		xfs_calc_inode_res(mp, 1) +
> -		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> -				 XFS_FSB_TO_B(mp, 1));
> +		xfs_allocfree_extent_res(mp);
>  }
>  
>  /*
> @@ -675,7 +651,7 @@ xfs_calc_writeid_reservation(
>   *	agf block and superblock (for block allocation)
>   *	the new block (directory sized)
>   *	bmap blocks for the new directory block
> - *	allocation btrees
> + *      one extent allocfree reservation for the AG.
>   */
>  STATIC uint
>  xfs_calc_addafork_reservation(
> @@ -687,8 +663,7 @@ xfs_calc_addafork_reservation(
>  		xfs_calc_buf_res(1, mp->m_dir_geo->blksize) +
>  		xfs_calc_buf_res(XFS_DAENTER_BMAP1B(mp, XFS_DATA_FORK) + 1,
>  				 XFS_FSB_TO_B(mp, 1)) +
> -		xfs_calc_buf_res(xfs_allocfree_log_count(mp, 1),
> -				 XFS_FSB_TO_B(mp, 1));
> +		xfs_allocfree_extent_res(mp);
>  }
>  
>  /*
> @@ -696,11 +671,8 @@ xfs_calc_addafork_reservation(
>   *    the inode being truncated: inode size
>   *    the inode's bmap btree: max depth * block size
>   * And the bmap_finish transaction can free the blocks and bmap blocks:
> - *    the agf for each of the ags: 4 * sector size
> - *    the agfl for each of the ags: 4 * sector size
>   *    the super block to reflect the freed blocks: sector size
> - *    worst case split in allocation btrees per extent assuming 4 extents:
> - *		4 exts * 2 trees * (2 * max depth - 1) * block size
> + *    four extent allocfree reservations for the AG.
>   */
>  STATIC uint
>  xfs_calc_attrinval_reservation(
> @@ -709,9 +681,8 @@ xfs_calc_attrinval_reservation(
>  	return max((xfs_calc_inode_res(mp, 1) +
>  		    xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
>  				     XFS_FSB_TO_B(mp, 1))),
> -		   (xfs_calc_buf_res(9, mp->m_sb.sb_sectsize) +
> -		    xfs_calc_buf_res(xfs_allocfree_log_count(mp, 4),
> -				     XFS_FSB_TO_B(mp, 1))));
> +		   (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> +		    xfs_allocfree_extent_res(mp) * 4));
>  }
>  
>  /*
> @@ -760,10 +731,8 @@ xfs_calc_attrsetrt_reservation(
>   *    the attribute btree could join: max depth * block size
>   *    the inode bmap btree could join or split: max depth * block size
>   * And the bmap_finish transaction can free the attr blocks freed giving:
> - *    the agf for the ag in which the blocks live: 2 * sector size
> - *    the agfl for the ag in which the blocks live: 2 * sector size
>   *    the superblock for the free block count: sector size
> - *    the allocation btrees: 2 exts * 2 trees * (2 * max depth - 1) * block size
> + *    two extent allocfree reservations for the AG.
>   */
>  STATIC uint
>  xfs_calc_attrrm_reservation(
> @@ -776,9 +745,8 @@ xfs_calc_attrrm_reservation(
>  		     (uint)XFS_FSB_TO_B(mp,
>  					XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
>  		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), 0)),
> -		    (xfs_calc_buf_res(5, mp->m_sb.sb_sectsize) +
> -		     xfs_calc_buf_res(xfs_allocfree_log_count(mp, 2),
> -				      XFS_FSB_TO_B(mp, 1))));
> +		    (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> +		     xfs_allocfree_extent_res(mp) * 2));
>  }
>  
>  /*
> -- 
> 2.31.1
> 
