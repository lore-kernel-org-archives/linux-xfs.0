Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62345C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiF2SaU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiF2SaU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F102A94D
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C90B661B40
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCBAC34114;
        Wed, 29 Jun 2022 18:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656527418;
        bh=l7rcdEU/N50EYpieAARVAhc4XhI7ozCJd8+S3MgzKW4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=krAoV1kg+16QYsn9+CtjHzKkgmxcY5+moTt8Mo5ZhqE2v2MAGJSc3QVUENz192pMJ
         DTOj5ujbEJ/9UWSOu3Lln8W3fqM+j/HFc0VOdI3MKtyZCMbzdxpl1h0TGFxw7UAGGz
         wsnHrYfz56rYpPtLrO1aR7T78+TwcK5qhgL9AF36ZZdDGkpKlemHAz3sn5U7VLsPTk
         HZN/VzVDu4eGDvXe6YTSsP+8o/mSuysGseMJJCqt2lRD0zIgYNGk2MJjA78dAXpBJo
         Vu9CEqt212w0Pw58npOAG84aODIJouwf8u5F0Aa/N2BNQKbJ6GrBRUTa+wAUD8s8E0
         3q11JUsJUD6Jw==
Date:   Wed, 29 Jun 2022 11:30:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 04/17] xfs: get directory offset when removing
 directory name
Message-ID: <YryaOVNvaUpEw9zO@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-5-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:47AM -0700, Allison Henderson wrote:
> Return the directory offset information when removing an entry to the
> directory.
> 
> This offset will be used as the parent pointer offset in xfs_remove.
> 
> [dchinner: forward ported and cleaned up]
> [achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
>            Changed typedefs to raw struct types]
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2.c       | 6 +++++-
>  fs/xfs/libxfs/xfs_dir2.h       | 3 ++-
>  fs/xfs/libxfs/xfs_dir2_block.c | 4 ++--
>  fs/xfs/libxfs/xfs_dir2_leaf.c  | 5 +++--
>  fs/xfs/libxfs/xfs_dir2_node.c  | 5 +++--
>  fs/xfs/libxfs/xfs_dir2_sf.c    | 2 ++
>  fs/xfs/xfs_inode.c             | 4 ++--
>  7 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index f7f7fa79593f..c3fa1bd1c370 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -436,7 +436,8 @@ xfs_dir_removename(
>  	struct xfs_inode	*dp,
>  	struct xfs_name		*name,
>  	xfs_ino_t		ino,
> -	xfs_extlen_t		total)		/* bmap's total block count */
> +	xfs_extlen_t		total,		/* bmap's total block count */
> +	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
>  {
>  	struct xfs_da_args	*args;
>  	int			rval;
> @@ -481,6 +482,9 @@ xfs_dir_removename(
>  	else
>  		rval = xfs_dir2_node_removename(args);
>  out_free:
> +	if (offset)
> +		*offset = args->offset;
> +
>  	kmem_free(args);
>  	return rval;
>  }
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 4d1c2570b833..c581d3b19bc6 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -46,7 +46,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_name *ci_name);
>  extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
>  				struct xfs_name *name, xfs_ino_t ino,
> -				xfs_extlen_t tot);
> +				xfs_extlen_t tot,
> +				xfs_dir2_dataptr_t *offset);
>  extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
>  				const struct xfs_name *name, xfs_ino_t inum,
>  				xfs_extlen_t tot);
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 85869f604960..4579e9be5d1a 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -810,9 +810,9 @@ xfs_dir2_block_removename(
>  	/*
>  	 * Point to the data entry using the leaf entry.
>  	 */
> +	args->offset = be32_to_cpu(blp[ent].address);
>  	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
> -			xfs_dir2_dataptr_to_off(args->geo,
> -						be32_to_cpu(blp[ent].address)));
> +			xfs_dir2_dataptr_to_off(args->geo, args->offset));
>  	/*
>  	 * Mark the data entry's space free.
>  	 */
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index bd0c2f963545..c13763c16095 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -1381,9 +1381,10 @@ xfs_dir2_leaf_removename(
>  	 * Point to the leaf entry, use that to point to the data entry.
>  	 */
>  	lep = &leafhdr.ents[index];
> -	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
> +	args->offset = be32_to_cpu(lep->address);
> +	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
>  	dep = (xfs_dir2_data_entry_t *)((char *)hdr +
> -		xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address)));
> +		xfs_dir2_dataptr_to_off(args->geo, args->offset));
>  	needscan = needlog = 0;
>  	oldbest = be16_to_cpu(bf[0].length);
>  	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 5a9513c036b8..39cbdeafa0f6 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1296,9 +1296,10 @@ xfs_dir2_leafn_remove(
>  	/*
>  	 * Extract the data block and offset from the entry.
>  	 */
> -	db = xfs_dir2_dataptr_to_db(geo, be32_to_cpu(lep->address));
> +	args->offset = be32_to_cpu(lep->address);
> +	db = xfs_dir2_dataptr_to_db(args->geo, args->offset);
>  	ASSERT(dblk->blkno == db);
> -	off = xfs_dir2_dataptr_to_off(geo, be32_to_cpu(lep->address));
> +	off = xfs_dir2_dataptr_to_off(args->geo, args->offset);
>  	ASSERT(dblk->index == off);
>  
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index c6c06e8ab54b..51d42faabb18 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -971,6 +971,8 @@ xfs_dir2_sf_removename(
>  								XFS_CMP_EXACT) {
>  			ASSERT(xfs_dir2_sf_get_ino(mp, sfp, sfep) ==
>  			       args->inumber);
> +			args->offset = xfs_dir2_byte_to_dataptr(
> +						xfs_dir2_sf_get_offset(sfep));
>  			break;
>  		}
>  	}
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 05be02f6f62b..0c0c82e5dc59 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2836,7 +2836,7 @@ xfs_remove(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
> +	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks, NULL);
>  	if (error) {
>  		ASSERT(error != -ENOENT);
>  		goto out_trans_cancel;
> @@ -3391,7 +3391,7 @@ xfs_rename(
>  					spaceres);
>  	else
>  		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
> -					   spaceres);
> +					   spaceres, NULL);
>  
>  	if (error)
>  		goto out_trans_cancel;
> -- 
> 2.25.1
> 
