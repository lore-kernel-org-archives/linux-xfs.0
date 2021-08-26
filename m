Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C698CC432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 18:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A76A160F4C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 18:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241975AbhHZSKf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Aug 2021 14:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243092AbhHZSKf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Aug 2021 14:10:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7773360F4A;
        Thu, 26 Aug 2021 18:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630001387;
        bh=KMOUuyc17kouRLLm5sE+QnCooTpfKn+Vs0Ewbld0V+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c+63CZ9Hoq0kU/2Pk8mEFknSnVbZcIjPvwkYKnw4VIN5uFNNcYmpZ66pSXPKcsQM3
         VUFcpv/VWKcnde67CZ66UkI8d4vULSlL/txn0M0WxjUsfOeL0TZnUnqO3kdoiTr1wH
         sI9Q3Gcxjqj+XWIjkXvWPsKF9To//zfiSEKbC/JXqBY2wnfCKe4UUStWiSd/HZOL54
         gNI4HGQCgba7PC2GlZi3MyWWqGr2HR0dxDuQSLsXTmYpsHyKw358wmHrOTzvvQV7iV
         3oQ5WZ4VnJSyRlQh3Rta2G9HaNMVnwLKaVTLiYh1/e9ofILazufltZTzrpNP4EvJ3x
         BYA8Z32ZVYGpg==
Date:   Thu, 26 Aug 2021 11:09:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bill O'Donnell <bodonnel@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: dax: facilitate EXPERIMENTAL warning for dax=inode
 case
Message-ID: <20210826180947.GL12640@magnolia>
References: <20210826173012.273932-1-bodonnel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826173012.273932-1-bodonnel@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 26, 2021 at 12:30:12PM -0500, Bill O'Donnell wrote:
> When dax-mode was tri-stated by adding dax=inode case, the EXPERIMENTAL
> warning on mount was missed for the case. Add logic to handle the
> warning similar to that of the 'dax=always' case.
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> ---
>  fs/xfs/xfs_mount.h | 2 ++
>  fs/xfs/xfs_super.c | 8 +++++---
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index e091f3b3fa15..c9243a1b8d05 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -277,6 +277,7 @@ typedef struct xfs_mount {
>  #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
>  
>  /* Mount features */
> +#define XFS_FEAT_DAX_INODE	(1ULL << 47)	/* DAX enabled */
>  #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
>  #define XFS_FEAT_NOALIGN	(1ULL << 49)	/* ignore alignment */
>  #define XFS_FEAT_ALLOCSIZE	(1ULL << 50)	/* user specified allocation size */
> @@ -359,6 +360,7 @@ __XFS_HAS_FEAT(swalloc, SWALLOC)
>  __XFS_HAS_FEAT(filestreams, FILESTREAMS)
>  __XFS_HAS_FEAT(dax_always, DAX_ALWAYS)
>  __XFS_HAS_FEAT(dax_never, DAX_NEVER)
> +__XFS_HAS_FEAT(dax_inode, DAX_INODE)
>  __XFS_HAS_FEAT(norecovery, NORECOVERY)
>  __XFS_HAS_FEAT(nouuid, NOUUID)
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5e73ac78bf2f..f73f3687f0a8 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -84,15 +84,16 @@ xfs_mount_set_dax_mode(
>  {
>  	switch (mode) {
>  	case XFS_DAX_INODE:
> +		mp->m_features |= XFS_FEAT_DAX_INODE;
>  		mp->m_features &= ~(XFS_FEAT_DAX_ALWAYS | XFS_FEAT_DAX_NEVER);
>  		break;
>  	case XFS_DAX_ALWAYS:
>  		mp->m_features |= XFS_FEAT_DAX_ALWAYS;
> -		mp->m_features &= ~XFS_FEAT_DAX_NEVER;
> +		mp->m_features &= ~(XFS_FEAT_DAX_NEVER | XFS_FEAT_DAX_INODE);
>  		break;
>  	case XFS_DAX_NEVER:
>  		mp->m_features |= XFS_FEAT_DAX_NEVER;
> -		mp->m_features &= ~XFS_FEAT_DAX_ALWAYS;
> +		mp->m_features &= ~(XFS_FEAT_DAX_ALWAYS | XFS_FEAT_DAX_INODE);
>  		break;
>  	}
>  }
> @@ -189,6 +190,7 @@ xfs_fs_show_options(
>  		{ XFS_FEAT_LARGE_IOSIZE,	",largeio" },
>  		{ XFS_FEAT_DAX_ALWAYS,		",dax=always" },
>  		{ XFS_FEAT_DAX_NEVER,		",dax=never" },
> +		{ XFS_FEAT_DAX_INODE,		",dax=inode" },
>  		{ 0, NULL }
>  	};
>  	struct xfs_mount	*mp = XFS_M(root->d_sb);
> @@ -1584,7 +1586,7 @@ xfs_fs_fill_super(
>  	if (xfs_has_crc(mp))
>  		sb->s_flags |= SB_I_VERSION;
>  
> -	if (xfs_has_dax_always(mp)) {
> +	if (xfs_has_dax_always(mp) || xfs_has_dax_inode(mp)) {

Er... can't this be done without burning another feature bit by:

	if (xfs_has_dax_always(mp) || (!xfs_has_dax_always(mp) &&
				       !xfs_has_dax_never(mp))) {
		...
		xfs_warn(mp, "DAX IS EXPERIMENTAL");
	}

--D

>  		bool rtdev_is_dax = false, datadev_is_dax;
>  
>  		xfs_warn(mp,
> -- 
> 2.31.1
> 
