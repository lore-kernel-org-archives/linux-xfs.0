Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECA1C4332D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 11:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ACE565228
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 11:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhCILmV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 06:42:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50490 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230435AbhCILmH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 06:42:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615290126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bxz2dqygXeHyKjO0KCupS9oM8kAgApt4Ss2ZPcjO7Vo=;
        b=SG2S6Mif9wdVpVXLKHV/8/E6nsuNduQAixAZy3Udz9xfB/scoGCFpV0xYPPn4eGXq+cNam
        66U6kyK/cbhGy5t0a5B+27dYvdrZHbSkTljn2gvPtY37SVBIYnHhsN9pI0t0KBlCxcvIlG
        aNRDzPP0s9ikh/KoZbu88cwZwqRUdeo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-WXWn0szFPieeutmyO8b_CA-1; Tue, 09 Mar 2021 06:42:04 -0500
X-MC-Unique: WXWn0szFPieeutmyO8b_CA-1
Received: by mail-ej1-f70.google.com with SMTP id rl7so5477635ejb.16
        for <linux-xfs@vger.kernel.org>; Tue, 09 Mar 2021 03:42:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=bxz2dqygXeHyKjO0KCupS9oM8kAgApt4Ss2ZPcjO7Vo=;
        b=cuia4sDJRtdl/0dnx1y9LrnJhY7QDZdgYm30e7OBwGWWx3ZBMOtOKsnwz8Cb5ZOp5U
         sSBMzLE6LDYI9gDUehgqr471P2PNhkAqkhv3Dmw0kUUjLWklPdczcBsM9dVZCs3QvGYU
         18jfYeky0ofiHHmU5cWN5sPZPpT7b/AhSumJiyDDugQIC51xYkCV/UtJBkK71G8XyGq5
         BNbWbRDriICxemfddIjryTvX4rBv9xuvfxE/mBmj7UmIpCU//S6/nJaXgWBRYjHYb+F5
         f/4lZcRleIcUB2nirS1iGX0jBpgN/Ory1kH0sGBzZ2CvFK0+2B9XTXdEoszUtPvUIauS
         32YA==
X-Gm-Message-State: AOAM533uo/ceRYosfMNnJs/O3JPehIiIdIx7yVmdvG392uqob7CeujD/
        mYubSujqtmfIQiTWOorV30ovXeUHgwaOhEuQ1/uR8VYGvfPqYCwPmY9bIQYXWBY8DBoB9/6MsJJ
        uxrpTvwQJApD8IKSdYPSW
X-Received: by 2002:a17:906:9515:: with SMTP id u21mr20168644ejx.86.1615290123354;
        Tue, 09 Mar 2021 03:42:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdVCoQKv1Oy46AIxs294fQCmxShf9+5yiJYl9sBozZB4RO9eK4fnkazA0baU3JFPC29pkqug==
X-Received: by 2002:a17:906:9515:: with SMTP id u21mr20168629ejx.86.1615290123166;
        Tue, 09 Mar 2021 03:42:03 -0800 (PST)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id s20sm7446329ejj.38.2021.03.09.03.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 03:42:02 -0800 (PST)
Date:   Tue, 9 Mar 2021 12:42:00 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs: rename variable mp to parsing_mp
Message-ID: <20210309114200.f7khrhrc5uro6wmv@andromeda.lan>
Mail-Followup-To: Pavel Reichl <preichl@redhat.com>,
        linux-xfs@vger.kernel.org
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
> ---
>  fs/xfs/xfs_super.c | 102 ++++++++++++++++++++++-----------------------
>  1 file changed, 51 insertions(+), 51 deletions(-)

Looks good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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

-- 
Carlos

