Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F65C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiF2She (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiF2ShZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:37:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670B73B299
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:37:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27565B82475
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CF6C34114;
        Wed, 29 Jun 2022 18:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656527841;
        bh=kiV/P9Bw+8P+gQscPN3bXV6FpXxnkoFf46x9USr6q3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U8v/2n1NAvZXeI2G2c5I0gqqePYFPU2kPQJuTMMSZ8vo6x+MgPQUFo5QFCMkXjQd8
         RQc6xfBPLeliJN7107rqYlUk7qChF1waz7iZy+PsukCkYsVBHqHE8oyy40KfxHZrCP
         EbwJJCfk+rt4aW1FL/tPjgMYoJUY1cliWypBMa32MTU3ktXK7nqBsLBSgj1VgZjr1T
         mhznZBvTes1vEIGcVduQDNxvZIoDNTo5+EVpqjnuvtop2L+uARTO/FtdrM4YPPJAWz
         pSbFlaSFmt1BxIicvMa6hET5MIyKHl2bL4WMoejID0UCXwpFinYsB/rkdsnW7djKid
         HNGKAyx6PD/rg==
Date:   Wed, 29 Jun 2022 11:37:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 09/17] xfs: extent transaction reservations for parent
 attributes
Message-ID: <Yryb4TYRKm+g0iBv@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-10-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-10-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Subject: xfs: extent transaction reservations for parent attributeso

s/extent/extend/?


On Sat, Jun 11, 2022 at 02:41:52AM -0700, Allison Henderson wrote:
> We need to add, remove or modify parent pointer attributes during
> create/link/unlink/rename operations atomically with the dirents in the
> parent directories being modified. This means they need to be modified
> in the same transaction as the parent directories, and so we need to add
> the required space for the attribute modifications to the transaction
> reservations.
> 
> [achender: rebased, added xfs_sb_version_hasparent stub]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h     |   5 ++
>  fs/xfs/libxfs/xfs_trans_resv.c | 103 +++++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_trans_resv.h |   1 +
>  3 files changed, 90 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index afdfc8108c5f..96976497306c 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -390,6 +390,11 @@ xfs_sb_has_incompat_feature(
>  	return (sbp->sb_features_incompat & feature) != 0;
>  }
>  
> +static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
> +{
> +	return false; /* We'll enable this at the end of the set */
> +}
> +
>  #define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
>  #define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
>  	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index e9913c2c5a24..fbe46fd3b722 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -909,24 +909,30 @@ xfs_calc_sb_reservation(
>  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
>  }
>  
> -void
> -xfs_trans_resv_calc(
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
> + * modifications can be done atomically with the rename operation.
> + */
> +STATIC void
> +xfs_calc_namespace_reservations(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans_resv	*resp)
>  {
> -	int			logcount_adj = 0;
> -
> -	/*
> -	 * The following transactions are logged in physical format and
> -	 * require a permanent reservation on space.
> -	 */
> -	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp, false);
> -	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> -	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> -
> -	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp, false);
> -	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> -	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> +	ASSERT(resp->tr_attrsetm.tr_logres > 0);
>  
>  	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
>  	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
> @@ -948,15 +954,72 @@ xfs_trans_resv_calc(
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
> +void xfs_calc_parent_ptr_reservations(struct xfs_mount     *mp)

Indenting, etc.

Also vaguely wondering if this should be static inline?  Or does
something else call this?

--D

> +{
> +	struct xfs_trans_resv   *resp = M_RES(mp);
> +
> +	/* Calculate extra space needed for parent pointer attributes */
> +	if (!xfs_sb_version_hasparent(&mp->m_sb))
> +		return;
> +
> +	/* rename can add/remove/modify 4 parent attributes */
> +	resp->tr_rename.tr_logres += 4 * max(resp->tr_attrsetm.tr_logres,
> +					 resp->tr_attrrm.tr_logres);
> +	resp->tr_rename.tr_logcount += 4 * max(resp->tr_attrsetm.tr_logcount,
> +					   resp->tr_attrrm.tr_logcount);
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
> @@ -986,6 +1049,8 @@ xfs_trans_resv_calc(
>  	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
>  	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>  
> +	xfs_calc_namespace_reservations(mp, resp);
> +
>  	/*
>  	 * The following transactions are logged in logical format with
>  	 * a default log count.
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> index 0554b9d775d2..cab8084a84d6 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.h
> +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> @@ -101,5 +101,6 @@ uint xfs_allocfree_block_count(struct xfs_mount *mp, uint num_ops);
>  unsigned int xfs_calc_itruncate_reservation_minlogsize(struct xfs_mount *mp);
>  unsigned int xfs_calc_write_reservation_minlogsize(struct xfs_mount *mp);
>  unsigned int xfs_calc_qm_dqalloc_reservation_minlogsize(struct xfs_mount *mp);
> +void xfs_calc_parent_ptr_reservations(struct xfs_mount *mp);
>  
>  #endif	/* __XFS_TRANS_RESV_H__ */
> -- 
> 2.25.1
> 
