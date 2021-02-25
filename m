Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2018AC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 02:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC2F364ED3
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 02:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhBYClU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 21:41:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232678AbhBYClU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 21:41:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34BB364ECF;
        Thu, 25 Feb 2021 02:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614220839;
        bh=1ctA/KkWRWCiPhP6WpUpWx7UjFRehT/YecppmPslUMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jyKdXBv/WamB+fKWzTPkZQmMrTheId54TSi9SBalH5jCb5ksVSgAcyRfCmWOnmwZl
         vEQlpDXUfg/8htqdVXtRGXtWniEtO+CIeanbhTqi7iQWVtj4IuoW3qDtX0LsW7G0kX
         3Bgxo6AT0FqSOm6LTD/umpm0yYErL5tpl8pfEv5Y7Iqcvnntx0HxwHu1NRF3XuhLIA
         ege3+xN1CmB2R7qoIUi/9ICo8/hAF3AdL2bNb6s25ZxO1/9oxtLYIjqSGNCyVgXw+o
         biQeO5tXt8U0AlMDTUHpgwPsXxbDtbp6t9puoZdYuoJJEZsVWyYe9i3znMzsLui5G3
         HMuYFU9UszVyg==
Date:   Wed, 24 Feb 2021 18:40:38 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs: rename variable mp to parsing_mp
Message-ID: <20210225024038.GH7272@magnolia>
References: <20210224214323.394286-1-preichl@redhat.com>
 <20210224214323.394286-3-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224214323.394286-3-preichl@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 10:43:22PM +0100, Pavel Reichl wrote:
> Rename mp variable to parsisng_mp so it is easy to distinguish
> between current mount point handle and handle for mount point
> which mount options are being parsed.
> 
> Suggested-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Pavel Reichl <preichl@redhat.com>

Seems reasonable...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_super.c | 102 ++++++++++++++++++++++-----------------------
>  1 file changed, 51 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 813be879a5e5..7e281d1139dc 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1165,7 +1165,7 @@ xfs_fs_parse_param(
>  	struct fs_context	*fc,
>  	struct fs_parameter	*param)
>  {
> -	struct xfs_mount	*mp = fc->s_fs_info;
> +	struct xfs_mount	*parsing_mp = fc->s_fs_info;
>  	struct fs_parse_result	result;
>  	int			size = 0;
>  	int			opt;
> @@ -1176,142 +1176,142 @@ xfs_fs_parse_param(
>  
>  	switch (opt) {
>  	case Opt_logbufs:
> -		mp->m_logbufs = result.uint_32;
> +		parsing_mp->m_logbufs = result.uint_32;
>  		return 0;
>  	case Opt_logbsize:
> -		if (suffix_kstrtoint(param->string, 10, &mp->m_logbsize))
> +		if (suffix_kstrtoint(param->string, 10, &parsing_mp->m_logbsize))
>  			return -EINVAL;
>  		return 0;
>  	case Opt_logdev:
> -		kfree(mp->m_logname);
> -		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
> -		if (!mp->m_logname)
> +		kfree(parsing_mp->m_logname);
> +		parsing_mp->m_logname = kstrdup(param->string, GFP_KERNEL);
> +		if (!parsing_mp->m_logname)
>  			return -ENOMEM;
>  		return 0;
>  	case Opt_rtdev:
> -		kfree(mp->m_rtname);
> -		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
> -		if (!mp->m_rtname)
> +		kfree(parsing_mp->m_rtname);
> +		parsing_mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
> +		if (!parsing_mp->m_rtname)
>  			return -ENOMEM;
>  		return 0;
>  	case Opt_allocsize:
>  		if (suffix_kstrtoint(param->string, 10, &size))
>  			return -EINVAL;
> -		mp->m_allocsize_log = ffs(size) - 1;
> -		mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
> +		parsing_mp->m_allocsize_log = ffs(size) - 1;
> +		parsing_mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
>  		return 0;
>  	case Opt_grpid:
>  	case Opt_bsdgroups:
> -		mp->m_flags |= XFS_MOUNT_GRPID;
> +		parsing_mp->m_flags |= XFS_MOUNT_GRPID;
>  		return 0;
>  	case Opt_nogrpid:
>  	case Opt_sysvgroups:
> -		mp->m_flags &= ~XFS_MOUNT_GRPID;
> +		parsing_mp->m_flags &= ~XFS_MOUNT_GRPID;
>  		return 0;
>  	case Opt_wsync:
> -		mp->m_flags |= XFS_MOUNT_WSYNC;
> +		parsing_mp->m_flags |= XFS_MOUNT_WSYNC;
>  		return 0;
>  	case Opt_norecovery:
> -		mp->m_flags |= XFS_MOUNT_NORECOVERY;
> +		parsing_mp->m_flags |= XFS_MOUNT_NORECOVERY;
>  		return 0;
>  	case Opt_noalign:
> -		mp->m_flags |= XFS_MOUNT_NOALIGN;
> +		parsing_mp->m_flags |= XFS_MOUNT_NOALIGN;
>  		return 0;
>  	case Opt_swalloc:
> -		mp->m_flags |= XFS_MOUNT_SWALLOC;
> +		parsing_mp->m_flags |= XFS_MOUNT_SWALLOC;
>  		return 0;
>  	case Opt_sunit:
> -		mp->m_dalign = result.uint_32;
> +		parsing_mp->m_dalign = result.uint_32;
>  		return 0;
>  	case Opt_swidth:
> -		mp->m_swidth = result.uint_32;
> +		parsing_mp->m_swidth = result.uint_32;
>  		return 0;
>  	case Opt_inode32:
> -		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> +		parsing_mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
>  		return 0;
>  	case Opt_inode64:
> -		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> +		parsing_mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
>  		return 0;
>  	case Opt_nouuid:
> -		mp->m_flags |= XFS_MOUNT_NOUUID;
> +		parsing_mp->m_flags |= XFS_MOUNT_NOUUID;
>  		return 0;
>  	case Opt_largeio:
> -		mp->m_flags |= XFS_MOUNT_LARGEIO;
> +		parsing_mp->m_flags |= XFS_MOUNT_LARGEIO;
>  		return 0;
>  	case Opt_nolargeio:
> -		mp->m_flags &= ~XFS_MOUNT_LARGEIO;
> +		parsing_mp->m_flags &= ~XFS_MOUNT_LARGEIO;
>  		return 0;
>  	case Opt_filestreams:
> -		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
> +		parsing_mp->m_flags |= XFS_MOUNT_FILESTREAMS;
>  		return 0;
>  	case Opt_noquota:
> -		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> -		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> -		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
> +		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
> +		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
> +		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
>  		return 0;
>  	case Opt_quota:
>  	case Opt_uquota:
>  	case Opt_usrquota:
> -		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
> +		parsing_mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
>  				 XFS_UQUOTA_ENFD);
>  		return 0;
>  	case Opt_qnoenforce:
>  	case Opt_uqnoenforce:
> -		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
> -		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
> +		parsing_mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
> +		parsing_mp->m_qflags &= ~XFS_UQUOTA_ENFD;
>  		return 0;
>  	case Opt_pquota:
>  	case Opt_prjquota:
> -		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
> +		parsing_mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
>  				 XFS_PQUOTA_ENFD);
>  		return 0;
>  	case Opt_pqnoenforce:
> -		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
> -		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
> +		parsing_mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
> +		parsing_mp->m_qflags &= ~XFS_PQUOTA_ENFD;
>  		return 0;
>  	case Opt_gquota:
>  	case Opt_grpquota:
> -		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
> +		parsing_mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
>  				 XFS_GQUOTA_ENFD);
>  		return 0;
>  	case Opt_gqnoenforce:
> -		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
> -		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
> +		parsing_mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
> +		parsing_mp->m_qflags &= ~XFS_GQUOTA_ENFD;
>  		return 0;
>  	case Opt_discard:
> -		mp->m_flags |= XFS_MOUNT_DISCARD;
> +		parsing_mp->m_flags |= XFS_MOUNT_DISCARD;
>  		return 0;
>  	case Opt_nodiscard:
> -		mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +		parsing_mp->m_flags &= ~XFS_MOUNT_DISCARD;
>  		return 0;
>  #ifdef CONFIG_FS_DAX
>  	case Opt_dax:
> -		xfs_mount_set_dax_mode(mp, XFS_DAX_ALWAYS);
> +		xfs_mount_set_dax_mode(parsing_mp, XFS_DAX_ALWAYS);
>  		return 0;
>  	case Opt_dax_enum:
> -		xfs_mount_set_dax_mode(mp, result.uint_32);
> +		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
>  		return 0;
>  #endif
>  	/* Following mount options will be removed in September 2025 */
>  	case Opt_ikeep:
> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> -		mp->m_flags |= XFS_MOUNT_IKEEP;
> +		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
> +		parsing_mp->m_flags |= XFS_MOUNT_IKEEP;
>  		return 0;
>  	case Opt_noikeep:
> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> -		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> +		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
> +		parsing_mp->m_flags &= ~XFS_MOUNT_IKEEP;
>  		return 0;
>  	case Opt_attr2:
> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> -		mp->m_flags |= XFS_MOUNT_ATTR2;
> +		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
> +		parsing_mp->m_flags |= XFS_MOUNT_ATTR2;
>  		return 0;
>  	case Opt_noattr2:
> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> -		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> -		mp->m_flags |= XFS_MOUNT_NOATTR2;
> +		xfs_warn(parsing_mp, "%s mount option is deprecated.", param->key);
> +		parsing_mp->m_flags &= ~XFS_MOUNT_ATTR2;
> +		parsing_mp->m_flags |= XFS_MOUNT_NOATTR2;
>  		return 0;
>  	default:
> -		xfs_warn(mp, "unknown mount option [%s].", param->key);
> +		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
>  		return -EINVAL;
>  	}
>  
> -- 
> 2.29.2
> 
