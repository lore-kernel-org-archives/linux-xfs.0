Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1205C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiF2Sau (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiF2Sau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:30:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A1F3134A
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:30:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92DA0B82615
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4059AC34114;
        Wed, 29 Jun 2022 18:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656527446;
        bh=cScUZ0F1+xkg6yJP9YcP3VfnDI8uhLoJ9FaGxx/mW7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gXP1okGoA3OJJXL3izLDPlBx7cfwxMbEcvWVcSd8CpFjmpZZ5QrtiyigwtTqYxp2Y
         MRLOVQ45ZZZkC0ijoemWcq+stsdcP+q/FV3ik15gvWoeUNotCu9YAGSbdjffHgL660
         Y20VYOLW5/StQrvDv+YpDP750IKra7yLYEkD4Tpx4WPmS+JiRXCmSlyvD23XToEBD4
         PUss2Ai+Jh8LoQlrh5mio5IJ9z+xcrt+nOC+DCYwFSB94kBm+d1J53N04iQLIww63p
         aaLYrzzxJnhCU0oPprO/umhcmzwohk56F2SxB08j52k58VkjRdINe9DXMXvTFeZUl2
         2lIGRsUhgETHQ==
Date:   Wed, 29 Jun 2022 11:30:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 05/17] xfs: get directory offset when replacing a
 directory name
Message-ID: <YryaVadQSphHB1xa@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-6-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:48AM -0700, Allison Henderson wrote:
> Return the directory offset information when replacing an entry to the
> directory.
> 
> This offset will be used as the parent pointer offset in xfs_rename.
> 
> [dchinner: forward ported and cleaned up]
> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
>            Changed typedefs to raw struct types]
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2.c       |  8 ++++++--
>  fs/xfs/libxfs/xfs_dir2.h       |  2 +-
>  fs/xfs/libxfs/xfs_dir2_block.c |  4 ++--
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |  1 +
>  fs/xfs/libxfs/xfs_dir2_node.c  |  1 +
>  fs/xfs/libxfs/xfs_dir2_sf.c    |  2 ++
>  fs/xfs/xfs_inode.c             | 16 ++++++++--------
>  7 files changed, 21 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index c3fa1bd1c370..6af2f5a8e627 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -482,7 +482,7 @@ xfs_dir_removename(
>  	else
>  		rval = xfs_dir2_node_removename(args);
>  out_free:
> -	if (offset)
> +	if (!rval && offset)
>  		*offset = args->offset;
>  
>  	kmem_free(args);
> @@ -498,7 +498,8 @@ xfs_dir_replace(
>  	struct xfs_inode	*dp,
>  	const struct xfs_name	*name,		/* name of entry to replace */
>  	xfs_ino_t		inum,		/* new inode number */
> -	xfs_extlen_t		total)		/* bmap's total block count */
> +	xfs_extlen_t		total,		/* bmap's total block count */
> +	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
>  {
>  	struct xfs_da_args	*args;
>  	int			rval;
> @@ -546,6 +547,9 @@ xfs_dir_replace(
>  	else
>  		rval = xfs_dir2_node_replace(args);
>  out_free:
> +	if (offset)
> +		*offset = args->offset;
> +
>  	kmem_free(args);
>  	return rval;
>  }
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index c581d3b19bc6..fd943c0c00a0 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -50,7 +50,7 @@ extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
>  				xfs_dir2_dataptr_t *offset);
>  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
>  				const struct xfs_name *name, xfs_ino_t inum,
> -				xfs_extlen_t tot);
> +				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
>  extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_name *name);
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 4579e9be5d1a..ee8905d16223 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -885,9 +885,9 @@ xfs_dir2_block_replace(
>  	/*
>  	 * Point to the data entry we need to change.
>  	 */
> +	args->offset = be32_to_cpu(blp[ent].address);
>  	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
> -			xfs_dir2_dataptr_to_off(args->geo,
> -						be32_to_cpu(blp[ent].address)));
> +			xfs_dir2_dataptr_to_off(args->geo, args->offset));
>  	ASSERT(be64_to_cpu(dep->inumber) != args->inumber);
>  	/*
>  	 * Change the inode number to the new value.
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index c13763c16095..958b9fea64bd 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -1518,6 +1518,7 @@ xfs_dir2_leaf_replace(
>  	/*
>  	 * Point to the data entry.
>  	 */
> +	args->offset = be32_to_cpu(lep->address);
>  	dep = (xfs_dir2_data_entry_t *)
>  	      ((char *)dbp->b_addr +
>  	       xfs_dir2_dataptr_to_off(args->geo, be32_to_cpu(lep->address)));
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 39cbdeafa0f6..53cd0d5d94f7 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -2242,6 +2242,7 @@ xfs_dir2_node_replace(
>  		hdr = state->extrablk.bp->b_addr;
>  		ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
>  		       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
> +		args->offset = be32_to_cpu(leafhdr.ents[blk->index].address);
>  		dep = (xfs_dir2_data_entry_t *)
>  		      ((char *)hdr +
>  		       xfs_dir2_dataptr_to_off(args->geo,
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 51d42faabb18..1de51eded26b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -1109,6 +1109,8 @@ xfs_dir2_sf_replace(
>  				xfs_dir2_sf_put_ino(mp, sfp, sfep,
>  						args->inumber);
>  				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
> +				args->offset = xfs_dir2_byte_to_dataptr(
> +						  xfs_dir2_sf_get_offset(sfep));
>  				break;
>  			}
>  		}
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 0c0c82e5dc59..b2dfd84e1f62 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2817,7 +2817,7 @@ xfs_remove(
>  		 */
>  		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
>  			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
> -					tp->t_mountp->m_sb.sb_rootino, 0);
> +					tp->t_mountp->m_sb.sb_rootino, 0, NULL);
>  			if (error)
>  				return error;
>  		}
> @@ -2952,12 +2952,12 @@ xfs_cross_rename(
>  	int		dp2_flags = 0;
>  
>  	/* Swap inode number for dirent in first parent */
> -	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
> +	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres, NULL);
>  	if (error)
>  		goto out_trans_abort;
>  
>  	/* Swap inode number for dirent in second parent */
> -	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
> +	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres, NULL);
>  	if (error)
>  		goto out_trans_abort;
>  
> @@ -2971,7 +2971,7 @@ xfs_cross_rename(
>  
>  		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
>  			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
> -						dp1->i_ino, spaceres);
> +						dp1->i_ino, spaceres, NULL);
>  			if (error)
>  				goto out_trans_abort;
>  
> @@ -2995,7 +2995,7 @@ xfs_cross_rename(
>  
>  		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
>  			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
> -						dp2->i_ino, spaceres);
> +						dp2->i_ino, spaceres, NULL);
>  			if (error)
>  				goto out_trans_abort;
>  
> @@ -3315,7 +3315,7 @@ xfs_rename(
>  		 * name at the destination directory, remove it first.
>  		 */
>  		error = xfs_dir_replace(tp, target_dp, target_name,
> -					src_ip->i_ino, spaceres);
> +					src_ip->i_ino, spaceres, NULL);
>  		if (error)
>  			goto out_trans_cancel;
>  
> @@ -3349,7 +3349,7 @@ xfs_rename(
>  		 * directory.
>  		 */
>  		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
> -					target_dp->i_ino, spaceres);
> +					target_dp->i_ino, spaceres, NULL);
>  		ASSERT(error != -EEXIST);
>  		if (error)
>  			goto out_trans_cancel;
> @@ -3388,7 +3388,7 @@ xfs_rename(
>  	 */
>  	if (wip)
>  		error = xfs_dir_replace(tp, src_dp, src_name, wip->i_ino,
> -					spaceres);
> +					spaceres, NULL);
>  	else
>  		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
>  					   spaceres, NULL);
> -- 
> 2.25.1
> 
