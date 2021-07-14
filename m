Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC55C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 764E4613CF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237563AbhGNXYL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:24:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235370AbhGNXYL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:24:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDB0E613CF;
        Wed, 14 Jul 2021 23:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626304878;
        bh=4WLrsWgN8nvfxhXcguf1UjoNJKlFY0unrHSSicOOvfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZqmhsrnNnwBuZTpl+NstpJMOnnCl96ja/IiJbWsE4NfP6CVMeiqBsnSkgmd1QdNs7
         o8fekvvFDT9BLx5bQhtoO8+8OrpipzErS7IzVhtTQ+AwZVoNQQ0wdqtCAu5L8VLUqy
         Jg+CXwe8wlAIAA4vZAfOoDKbIAjrVt6zEs6P7pIX1KbnbohRhMmNtePOwvueDEbPuv
         rmNAmgFLAw7saHWXu1uYZq4EUs4FeCPNVuyjy23445ddn7Bf7dMLwKRfubQMsg/kvJ
         AcpdW8f6Bu9/4kPqcfC4Eh9pxrGtgE1MOslpd43OJLsfgw1IFH0Ls1MvmJp2ZFea7d
         anK0Tj96mykdA==
Date:   Wed, 14 Jul 2021 16:21:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/16] xfs: remove unused xfs_sb_version_has wrappers
Message-ID: <20210714232118.GH22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-15-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-15-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:10PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The vast majority of these wrappers are now unused. Remove them
> leaving just the small subset of wrappers that are used to either
> add feature bits or make the mount features field setup code
> simpler.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

MMMMM code removal!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_format.h | 155 +------------------------------------
>  1 file changed, 3 insertions(+), 152 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index d1b0933c90eb..0bd44a780937 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -279,11 +279,6 @@ typedef struct xfs_dsb {
>  
>  #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
>  
> -static inline bool xfs_sb_version_hasrealtime(struct xfs_sb *sbp)
> -{
> -	return sbp->sb_rblocks > 0;
> -}
> -
>  /*
>   * Detect a mismatched features2 field.  Older kernels read/wrote
>   * this into the wrong slot, so to be safe we keep them in sync.
> @@ -293,9 +288,10 @@ static inline bool xfs_sb_has_mismatched_features2(struct xfs_sb *sbp)
>  	return sbp->sb_bad_features2 != sbp->sb_features2;
>  }
>  
> -static inline bool xfs_sb_version_hasattr(struct xfs_sb *sbp)
> +static inline bool xfs_sb_version_hasmorebits(struct xfs_sb *sbp)
>  {
> -	return (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT);
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
> +	       (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
>  }
>  
>  static inline void xfs_sb_version_addattr(struct xfs_sb *sbp)
> @@ -303,79 +299,17 @@ static inline void xfs_sb_version_addattr(struct xfs_sb *sbp)
>  	sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
>  }
>  
> -static inline bool xfs_sb_version_hasquota(struct xfs_sb *sbp)
> -{
> -	return (sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
> -}
> -
>  static inline void xfs_sb_version_addquota(struct xfs_sb *sbp)
>  {
>  	sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
>  }
>  
> -static inline bool xfs_sb_version_hasalign(struct xfs_sb *sbp)
> -{
> -	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
> -		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT));
> -}
> -
> -static inline bool xfs_sb_version_hasdalign(struct xfs_sb *sbp)
> -{
> -	return (sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
> -}
> -
> -static inline bool xfs_sb_version_haslogv2(struct xfs_sb *sbp)
> -{
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
> -	       (sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
> -}
> -
> -static inline bool xfs_sb_version_hassector(struct xfs_sb *sbp)
> -{
> -	return (sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
> -}
> -
> -static inline bool xfs_sb_version_hasasciici(struct xfs_sb *sbp)
> -{
> -	return (sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
> -}
> -
> -static inline bool xfs_sb_version_hasmorebits(struct xfs_sb *sbp)
> -{
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
> -	       (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
> -}
> -
> -/*
> - * sb_features2 bit version macros.
> - */
> -static inline bool xfs_sb_version_haslazysbcount(struct xfs_sb *sbp)
> -{
> -	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> -	       (xfs_sb_version_hasmorebits(sbp) &&
> -		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
> -}
> -
> -static inline bool xfs_sb_version_hasattr2(struct xfs_sb *sbp)
> -{
> -	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> -	       (xfs_sb_version_hasmorebits(sbp) &&
> -		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT));
> -}
> -
>  static inline void xfs_sb_version_addattr2(struct xfs_sb *sbp)
>  {
>  	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
>  	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
>  }
>  
> -static inline bool xfs_sb_version_hasprojid32(struct xfs_sb *sbp)
> -{
> -	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> -	       (xfs_sb_version_hasmorebits(sbp) &&
> -		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT));
> -}
> -
>  static inline void xfs_sb_version_addprojid32(struct xfs_sb *sbp)
>  {
>  	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
> @@ -459,13 +393,6 @@ xfs_sb_has_incompat_log_feature(
>  	return (sbp->sb_features_log_incompat & feature) != 0;
>  }
>  
> -/*
> - * V5 superblock specific feature checks
> - */
> -static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
> -{
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
> -}
>  
>  /*
>   * v5 file systems support V3 inodes only, earlier file systems support
> @@ -484,82 +411,6 @@ static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
>  	return version == 1 || version == 2;
>  }
>  
> -static inline bool xfs_sb_version_haspquotino(struct xfs_sb *sbp)
> -{
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
> -}
> -
> -static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
> -{
> -	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> -		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE)) ||
> -	       (xfs_sb_version_hasmorebits(sbp) &&
> -		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
> -}
> -
> -static inline bool xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
> -{
> -	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> -		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
> -}
> -
> -static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
> -{
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> -		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_SPINODES);
> -}
> -
> -/*
> - * XFS_SB_FEAT_INCOMPAT_META_UUID indicates that the metadata UUID
> - * is stored separately from the user-visible UUID; this allows the
> - * user-visible UUID to be changed on V5 filesystems which have a
> - * filesystem UUID stamped into every piece of metadata.
> - */
> -static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
> -{
> -	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> -		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
> -}
> -
> -static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
> -{
> -	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> -		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
> -}
> -
> -static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
> -{
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> -		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
> -}
> -
> -static inline bool xfs_sb_version_hasbigtime(struct xfs_sb *sbp)
> -{
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> -		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME);
> -}
> -
> -/*
> - * Inode btree block counter.  We record the number of inobt and finobt blocks
> - * in the AGI header so that we can skip the finobt walk at mount time when
> - * setting up per-AG reservations.
> - */
> -static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
> -{
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> -		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
> -}
> -
> -static inline bool xfs_sb_version_needsrepair(struct xfs_sb *sbp)
> -{
> -	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> -		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR);
> -}
> -
> -/*
> - * end of superblock version macros
> - */
> -
>  static inline bool
>  xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
>  {
> -- 
> 2.31.1
> 
