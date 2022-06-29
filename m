Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAAEFC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiF2S3b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiF2S3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:29:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306E027B16
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFC0461B40
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A6BC341C8;
        Wed, 29 Jun 2022 18:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656527368;
        bh=7auMeBAuKYiMe2EyBDkXOqxglQOP/T1GK8KiSLeHF7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NlTQPXvhMhhB8MrqEk/J+pmS8Iqx9kqp9X5CBA/S3+GkWjRMNRhJqAL8f3yXwZjGq
         ya1bB9eWiXyFGfwiGKYnDRoCqFjNfBMXP3NV0g7x+d2Z/xa5JdvH6pmYldUYL5Drei
         JTIvhjWVR5/cCKrFVcvOPcm1RpWAs8pa3m1alD265X3EzlC3rXAqhcawxzwaj4IpMI
         uPz1pDpBAS4pLdjTc+ljVsNelBakmdQF190H4jvi80BVLjEOWKQaZjoRicu/AJSuuY
         WftrA+ia7/239rDaPB3wNaExkdDeTcOrOhcHS5wIVsSo1wXmqYd/x4ONkyA88GPcRZ
         OEEo7dlcyhCYw==
Date:   Wed, 29 Jun 2022 11:29:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 03/17] xfs: get directory offset when adding directory
 name
Message-ID: <YryaB1tjerPFmzKz@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-4-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:46AM -0700, Allison Henderson wrote:
> Return the directory offset information when adding an entry to the
> directory.
> 
> This offset will be used as the parent pointer offset in xfs_create,
> xfs_symlink, xfs_link and xfs_rename.
> 
> [dchinner: forward ported and cleaned up]
> [dchinner: no s-o-b from Mark]
> [bfoster: rebased, use args->geo in dir code]
> [achender: rebased, chaged __uint32_t to xfs_dir2_dataptr_t]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>

Pretty straightforward...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_da_btree.h   | 1 +
>  fs/xfs/libxfs/xfs_dir2.c       | 9 +++++++--
>  fs/xfs/libxfs/xfs_dir2.h       | 2 +-
>  fs/xfs/libxfs/xfs_dir2_block.c | 1 +
>  fs/xfs/libxfs/xfs_dir2_leaf.c  | 2 ++
>  fs/xfs/libxfs/xfs_dir2_node.c  | 2 ++
>  fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
>  fs/xfs/xfs_inode.c             | 6 +++---
>  fs/xfs/xfs_symlink.c           | 3 ++-
>  9 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index d33b7686a0b3..e07eeecbe8a9 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -79,6 +79,7 @@ typedef struct xfs_da_args {
>  	int		rmtvaluelen2;	/* remote attr value length in bytes */
>  	uint32_t	op_flags;	/* operation flags */
>  	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
> +	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
>  } xfs_da_args_t;
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 3cd51fa3837b..f7f7fa79593f 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -257,7 +257,8 @@ xfs_dir_createname(
>  	struct xfs_inode	*dp,
>  	const struct xfs_name	*name,
>  	xfs_ino_t		inum,		/* new entry inode number */
> -	xfs_extlen_t		total)		/* bmap's total block count */
> +	xfs_extlen_t		total,		/* bmap's total block count */
> +	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
>  {
>  	struct xfs_da_args	*args;
>  	int			rval;
> @@ -312,6 +313,10 @@ xfs_dir_createname(
>  		rval = xfs_dir2_node_addname(args);
>  
>  out_free:
> +	/* return the location that this entry was place in the parent inode */
> +	if (offset)
> +		*offset = args->offset;
> +
>  	kmem_free(args);
>  	return rval;
>  }
> @@ -550,7 +555,7 @@ xfs_dir_canenter(
>  	xfs_inode_t	*dp,
>  	struct xfs_name	*name)		/* name of entry to add */
>  {
> -	return xfs_dir_createname(tp, dp, name, 0, 0);
> +	return xfs_dir_createname(tp, dp, name, 0, 0, NULL);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index b6df3c34b26a..4d1c2570b833 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -40,7 +40,7 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_inode *pdp);
>  extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
>  				const struct xfs_name *name, xfs_ino_t inum,
> -				xfs_extlen_t tot);
> +				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
>  extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
>  				const struct xfs_name *name, xfs_ino_t *inum,
>  				struct xfs_name *ci_name);
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index df0869bba275..85869f604960 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -573,6 +573,7 @@ xfs_dir2_block_addname(
>  	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
>  	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> +	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
>  	/*
>  	 * Clean up the bestfree array and log the header, tail, and entry.
>  	 */
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index d9b66306a9a7..bd0c2f963545 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -865,6 +865,8 @@ xfs_dir2_leaf_addname(
>  	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
>  	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> +	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
> +						(char *)dep - (char *)hdr);
>  	/*
>  	 * Need to scan fix up the bestfree table.
>  	 */
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 7a03aeb9f4c9..5a9513c036b8 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1974,6 +1974,8 @@ xfs_dir2_node_addname_int(
>  	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
>  	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> +	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
> +						  (char *)dep - (char *)hdr);
>  	xfs_dir2_data_log_entry(args, dbp, dep);
>  
>  	/* Rescan the freespace and log the data block if needed. */
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 5a97a87eaa20..c6c06e8ab54b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -485,6 +485,7 @@ xfs_dir2_sf_addname_easy(
>  	memcpy(sfep->name, args->name, sfep->namelen);
>  	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
>  	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
> +	args->offset = xfs_dir2_byte_to_dataptr(offset);
>  
>  	/*
>  	 * Update the header and inode.
> @@ -575,6 +576,7 @@ xfs_dir2_sf_addname_hard(
>  	memcpy(sfep->name, args->name, sfep->namelen);
>  	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
>  	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
> +	args->offset = xfs_dir2_byte_to_dataptr(offset);
>  	sfp->count++;
>  	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
>  		sfp->i8count++;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 23b93403a330..05be02f6f62b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1052,7 +1052,7 @@ xfs_create(
>  	unlock_dp_on_error = false;
>  
>  	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
> -					resblks - XFS_IALLOC_SPACE_RES(mp));
> +				   resblks - XFS_IALLOC_SPACE_RES(mp), NULL);
>  	if (error) {
>  		ASSERT(error != -ENOSPC);
>  		goto out_trans_cancel;
> @@ -1275,7 +1275,7 @@ xfs_link(
>  	}
>  
>  	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
> -				   resblks);
> +				   resblks, NULL);
>  	if (error)
>  		goto error_return;
>  	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> @@ -3294,7 +3294,7 @@ xfs_rename(
>  		 * to account for the ".." reference from the new entry.
>  		 */
>  		error = xfs_dir_createname(tp, target_dp, target_name,
> -					   src_ip->i_ino, spaceres);
> +					   src_ip->i_ino, spaceres, NULL);
>  		if (error)
>  			goto out_trans_cancel;
>  
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 18f71fc90dd0..c8b252fa98ff 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -314,7 +314,8 @@ xfs_symlink(
>  	/*
>  	 * Create the directory entry for the symlink.
>  	 */
> -	error = xfs_dir_createname(tp, dp, link_name, ip->i_ino, resblks);
> +	error = xfs_dir_createname(tp, dp, link_name,
> +			ip->i_ino, resblks, NULL);
>  	if (error)
>  		goto out_trans_cancel;
>  	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> -- 
> 2.25.1
> 
