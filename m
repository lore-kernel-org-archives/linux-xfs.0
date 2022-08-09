Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C533BC19F2D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 17:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiHIRsu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 13:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbiHIRst (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 13:48:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BEE237D0
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 10:48:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D163B816ED
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 17:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBF5C433D7;
        Tue,  9 Aug 2022 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660067325;
        bh=8fAcsHpadoIgZ2uiC3TdqzJzxTOpRdL7d+O1Xhqohgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mnOLqrdLjcaMpngn7jU11J9orARw5fY4jdwFpSpH3oaUYIzcaTkYBnaizMetK884B
         DSUW7jywhA81nIoknYcus4utXAw4iA6bJpmMmBebadUB07eO0aCGJWYvfqA4GnzStu
         hyYFmXLc8W+phRN/NXO2OOUzzhVU/VftD3237VI5MqMUsLTgw+4B/nzTR0ycUCYRtM
         +Ydcu3w+hBCxOzvkDlz1OII4pKmh6a4g2OApiT7CxvXjeRnRxsltMwiQhbooW5ZIo7
         3mj1919ncvW+xPMLVwB8af7fl4SENqkALOa/jnZisFkQZVbQoRZiveSrTL7EtkGrRY
         ad2Cj1Ra0yTxw==
Date:   Tue, 9 Aug 2022 10:48:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 11/18] xfs: extend transaction reservations for
 parent attributes
Message-ID: <YvKd/eEXN0GYJSYa@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
 <20220804194013.99237-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804194013.99237-12-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 12:40:06PM -0700, Allison Henderson wrote:
> We need to add, remove or modify parent pointer attributes during
> create/link/unlink/rename operations atomically with the dirents in the
> parent directories being modified. This means they need to be modified
> in the same transaction as the parent directories, and so we need to add
> the required space for the attribute modifications to the transaction
> reservations.

While we're on the topic of log reservations ... Dave and I noticed
during the 5.19 cycle that xfs_log_calc_max_attrsetm_res has a unit
conversion problem when it's trying to compute the minimum log size:

STATIC int
xfs_log_calc_max_attrsetm_res(
	struct xfs_mount	*mp)
{
	int			size;
	int			nblks;

	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
	       MAXNAMELEN - 1;

Notice here that @size is the maximum amount of space that a local
format attribute can use in an xattr leaf block.  The computation is in
units of bytes.

	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
	nblks += XFS_B_TO_FSB(mp, size);

...and here we convert bytes to fs blocks for the block count
computation...

	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);

...but here we pass the byte count into a macro that takes a block count
as its second parameter and returns the number of bmbt blocks needed to
add that many blocks to an attribute fork.  Oops!

I would like to fix this incorrect code, but it's never a good idea to
adjust downwards the min log size calculation for existing filesystems,
because this can result in the situation where new mkfs formats a
filesystem with a small enough log that an old kernel won't mount it.

Therefore, the corrected logic would have to be gated on whatever
happens to be the next new ondisk feature.  It's probably too late to do
this for large extent counts, but fixing the calculation would be (I
think) appropriate for parent pointers, since it's still undergoing
review and won't be an easy upgrade, which eliminates the legacy
problem.

I'll attach the patches that I've written as patches 19 and 20 to this
patchset, if you don't mind having a look and adding them?

	return  M_RES(mp)->tr_attrsetm.tr_logres +
		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
}


> [achender: rebased]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_trans_resv.c | 105 +++++++++++++++++++++++++++------
>  1 file changed, 86 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index e9913c2c5a24..b43ac4be7564 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -909,24 +909,67 @@ xfs_calc_sb_reservation(
>  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
>  }
>  
> -void
> -xfs_trans_resv_calc(
> -	struct xfs_mount	*mp,
> -	struct xfs_trans_resv	*resp)
> +STATIC void
> +xfs_calc_parent_ptr_reservations(
> +	struct xfs_mount     *mp)
>  {
> -	int			logcount_adj = 0;
> +	struct xfs_trans_resv   *resp = M_RES(mp);
>  
> -	/*
> -	 * The following transactions are logged in physical format and
> -	 * require a permanent reservation on space.
> -	 */
> -	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
> -	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> -	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +	/* Calculate extra space needed for parent pointer attributes */

This might be better expressed as a comment just prior to the function
declaration above.

> +	if (!xfs_has_parent(mp))
> +		return;
>  
> -	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
> -	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> -	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +	/* rename can add/remove/modify 4 parent attributes */
> +	resp->tr_rename.tr_logres += 4 * max(resp->tr_attrsetm.tr_logres,
> +					 resp->tr_attrrm.tr_logres);

Why does the per-transaction reservation increase by 4x the amount of
space needed to set (or delete) an xattr?  The pptr patchset now uses
logged xattrs, which means that each xattr update needed to commit the
rename operation will happen in a separate transaction.  IOWs, each
transaction in the chain does not have to handle *every* update that
must be made during the entire chain, it only has to handle one step of
the full process.

Doesn't that mean that the size of tr_rename.tr_logres only needs to
increase by the amount of space needed to log the four(?) xattr items to
the first transaction in the chain?  AFAICT, it also can't be smaller
than max(resp->tr_attrsetm.tr_logres, resp->tr_attrrm.tr_logres);

(I'm also not sure why four -- the patch for xfs_rename only creates
three xfs_parent_defer objects.)

I also think that adjusting tr_rename to account for parent pointers is
something that should be done in xfs_calc_rename_reservation, not a
separate function:

/*
 * In renaming a files we can modify (t1):
 *    the four inodes involved: 4 * inode size
 *    the two directory btrees: 2 * (max depth + v2) * dir block size
 *    the two directory bmap btrees: 2 * max depth * block size
 * And the bmap_finish transaction can free dir and bmap blocks (two sets
 *	of bmap blocks) giving (t2):
 *    the agf for the ags in which the blocks live: 3 * sector size
 *    the agfl for the ags in which the blocks live: 3 * sector size
 *    the superblock for the free block count: sector size
 *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
 * If parent pointers are enabled (t3), then each transaction in the chain
 *    must be capable of setting or removing the extended attribute
 *    containing the parent information.  It must also be able to handle
 *    the three xattr intent items that track the progress of the parent
 *    pointer update.
 */
STATIC uint
xfs_calc_rename_reservation(
	struct xfs_mount	*mp)
{
	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
	unsigned int		t1, t2, t3 = 0;

	t1 = xfs_calc_inode_res(mp, 4) +
	     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
			XFS_FSB_TO_B(mp, 1));

	t2 = xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
			XFS_FSB_TO_B(mp, 1))));

	if (xfs_has_parent(mp)) {
		t3 = max(resp->tr_attrsetm.tr_logres,
				resp->tr_attrrm.tr_logres);
		overhead += 3 * (size of a pptr xattr intent item);
	}

	return overhead + max3(t1, t2, t3);
}

> +	resp->tr_rename.tr_logcount += 4 * max(resp->tr_attrsetm.tr_logcount,
> +					   resp->tr_attrrm.tr_logcount);

Looks correct, module the 4 vs. 3 thing.

> +
> +	/* create will add 1 parent attribute */
> +	resp->tr_create.tr_logres += resp->tr_attrsetm.tr_logres;
> +	resp->tr_create.tr_logcount += resp->tr_attrsetm.tr_logcount;
> +
> +	/* mkdir will add 1 parent attribute */
> +	resp->tr_mkdir.tr_logres += resp->tr_attrsetm.tr_logres;
> +	resp->tr_mkdir.tr_logcount += resp->tr_attrsetm.tr_logcount;
> +
> +	/* link will add 1 parent attribute */
> +	resp->tr_link.tr_logres += resp->tr_attrsetm.tr_logres;
> +	resp->tr_link.tr_logcount += resp->tr_attrsetm.tr_logcount;
> +
> +	/* symlink will add 1 parent attribute */
> +	resp->tr_symlink.tr_logres += resp->tr_attrsetm.tr_logres;
> +	resp->tr_symlink.tr_logcount += resp->tr_attrsetm.tr_logcount;
> +
> +	/* remove will remove 1 parent attribute */
> +	resp->tr_remove.tr_logres += resp->tr_attrrm.tr_logres;
> +	resp->tr_remove.tr_logcount += resp->tr_attrrm.tr_logcount;
> +}
> +
> +/*
> + * Namespace reservations.
> + *
> + * These get tricky when parent pointers are enabled as we have attribute
> + * modifications occurring from within these transactions. Rather than confuse
> + * each of these reservation calculations with the conditional attribute
> + * reservations, add them here in a clear and concise manner. This assumes that
> + * the attribute reservations have already been calculated.
> + *
> + * Note that we only include the static attribute reservation here; the runtime
> + * reservation will have to be modified by the size of the attributes being
> + * added/removed/modified. See the comments on the attribute reservation
> + * calculations for more details.
> + *
> + * Note for rename: rename will vastly overestimate requirements. This will be
> + * addressed later when modifications are made to ensure parent attribute

Later?  I took a look at the rename patch, and it looks like we're using
logged xattrs from the start.

--D

> + * modifications can be done atomically with the rename operation.
> + */
> +STATIC void
> +xfs_calc_namespace_reservations(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_resv	*resp)
> +{
> +	ASSERT(resp->tr_attrsetm.tr_logres > 0);
>  
>  	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
>  	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
> @@ -948,15 +991,37 @@ xfs_trans_resv_calc(
>  	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
>  	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
> +	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
> +	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
> +	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	xfs_calc_parent_ptr_reservations(mp);
> +}
> +
> +void
> +xfs_trans_resv_calc(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans_resv	*resp)
> +{
> +	int			logcount_adj = 0;
> +
> +	/*
> +	 * The following transactions are logged in physical format and
> +	 * require a permanent reservation on space.
> +	 */
> +	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
> +	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> +	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
> +	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
> +	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> +	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +
>  	resp->tr_create_tmpfile.tr_logres =
>  			xfs_calc_create_tmpfile_reservation(mp);
>  	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
>  	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
> -	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
> -	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
> -	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> -
>  	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
>  	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
>  	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> @@ -986,6 +1051,8 @@ xfs_trans_resv_calc(
>  	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
>  	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
> +	xfs_calc_namespace_reservations(mp, resp);
> +
>  	/*
>  	 * The following transactions are logged in logical format with
>  	 * a default log count.
> -- 
> 2.25.1
> 
