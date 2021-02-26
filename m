Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A02D3C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 04:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 661F664DDC
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Feb 2021 04:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhBZEa1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 23:30:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhBZEa1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Feb 2021 23:30:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CDF8601FD;
        Fri, 26 Feb 2021 04:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614313786;
        bh=Ds75fILKnoSaWuEDcOBdCE72huQDhw0fb98hue35TXg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NbiD6pRSZq8wFHr2QusIPubs92PRqO7Z696G3JRWsFkajQ/K6GVb9NtR7hDhUx8lU
         uGcLFWdWrj46wDW6PrNsvFqlxS2jrECxeJkekr84aZyQfCcvwSOlTi4SE9RgHougAH
         sHPTQP28bWHSA5vypW14VdiLFHGlUBJPwI3csUBTPRPuWWITteq+hRQ2b3CN7IESfi
         pX0/pLHOLwd6WnhwIhrdIQaRHOmCn/jjE/FTBSleQxYJMQguL5MEFhPD0g9lvU3Ny2
         P0xQNlEfF3hyYuPIjUuqr7S86CY/DG+kauf4k45yAZnRgT2ydGSlUkhPh2iROeBj1Z
         HH7hO/mAyNSrg==
Date:   Thu, 25 Feb 2021 20:29:46 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 21/22] xfs: Add delattr mount option
Message-ID: <20210226042946.GW7272@magnolia>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-22-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-22-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:47AM -0700, Allison Henderson wrote:
> This patch adds a mount option to enable delayed attributes. Eventually
> this can be removed when delayed attrs becomes permanent.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.h | 2 +-
>  fs/xfs/xfs_mount.h       | 1 +
>  fs/xfs/xfs_super.c       | 6 +++++-
>  fs/xfs/xfs_xattr.c       | 2 ++
>  4 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index f82c0b1..35f3a53 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -30,7 +30,7 @@ struct xfs_attr_list_context;
>  
>  static inline bool xfs_hasdelattr(struct xfs_mount *mp)
>  {
> -	return false;
> +	return mp->m_flags & XFS_MOUNT_DELATTR;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 659ad95..57cd914 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -250,6 +250,7 @@ typedef struct xfs_mount {
>  #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
>  #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
>  #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
> +#define XFS_MOUNT_DELATTR	(1ULL << 28)	/* enable delayed attributes */
>  
>  /*
>   * Max and min values for mount-option defined I/O
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 21b1d03..f6b08f9 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -93,7 +93,7 @@ enum {
>  	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
>  	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
>  	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
> -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
> +	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_delattr
>  };
>  
>  static const struct fs_parameter_spec xfs_fs_parameters[] = {
> @@ -138,6 +138,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
>  	fsparam_flag("nodiscard",	Opt_nodiscard),
>  	fsparam_flag("dax",		Opt_dax),
>  	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
> +	fsparam_flag("delattr",		Opt_delattr),

I wonder if this ought to be hidden behind CONFIG_XFS_DEBUG=y, but
other than that this looks fine to me.

--D

>  	{}
>  };
>  
> @@ -1263,6 +1264,9 @@ xfs_fs_parse_param(
>  		xfs_mount_set_dax_mode(mp, result.uint_32);
>  		return 0;
>  #endif
> +	case Opt_delattr:
> +		mp->m_flags |= XFS_MOUNT_DELATTR;
> +		return 0;
>  	/* Following mount options will be removed in September 2025 */
>  	case Opt_ikeep:
>  		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 9b0c790..8ec61df 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -8,6 +8,8 @@
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
>  #include "xfs_da_format.h"
>  #include "xfs_inode.h"
>  #include "xfs_da_btree.h"
> -- 
> 2.7.4
> 
