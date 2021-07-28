Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987A7C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7773E60F46
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhG1Ar7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232883AbhG1Ar7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 20:47:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 527AF60F58;
        Wed, 28 Jul 2021 00:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627433278;
        bh=PLaOxLiE74p2y4RZpoRvz2TAhEL5DvA9AtgzQvrVfIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aevLlJpG1cruvX3AO4Z7TEDrpT0XJ0WqXPLBpArCclN1+b31IVn0C3spryTHSHsQh
         PhLuyQUGbvqX7u0Xa2KYzFA0PVlQCx4vIazzoRVjOJlSH9QqjZlFmt6UtRwZTHbFem
         x8ue8Ct4HZmU2LKnS6Hq8gGjJp0BcFVF2JtECsQqZSKkNZzMo2Dl1HqOQRGxK/5vB4
         fewtGJqsFPTmPR1yKwVKqw2M35sqPVUBjBabW/MQl0SHfMoT2+s78apaXHr/w6GlpE
         9iAOz8oz/59Bh9GCdPnkRtOlf0oDFNUaOiFLB3n80MsC0bi8eH1GRubgTq5QbOvzWN
         YjQ7x6I/s+/fA==
Date:   Tue, 27 Jul 2021 17:47:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 14/16] xfs: Add delattr mount option
Message-ID: <20210728004757.GB559212@magnolia>
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-15-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727062053.11129-15-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 11:20:51PM -0700, Allison Henderson wrote:
> This patch adds a mount option to enable delayed attributes. Eventually
> this can be removed when delayed attrs becomes permanent.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.h |  2 +-
>  fs/xfs/xfs_mount.h       |  1 +
>  fs/xfs/xfs_super.c       | 11 ++++++++++-
>  fs/xfs/xfs_xattr.c       |  2 ++
>  4 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index c0c92bd3..d4e7521 100644
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
> index 66a47f5..2945868 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -257,6 +257,7 @@ typedef struct xfs_mount {
>  #define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 format */
>  #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
>  #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
> +#define XFS_MOUNT_DELATTR	(1ULL << 28)	/* enable delayed attributes */

So uh while we're renaming things away from "delattr", maybe this ...

	LOGGED ATTRIBUTE RE PLAY

... really should become the "larp" debug-only mount option.

	XFS_MOUNT_LARP

Yeah.  Do it!!!

>  /*
>   * Max and min values for mount-option defined I/O
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2c9e26a..39d6645 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -94,7 +94,7 @@ enum {
>  	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
>  	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
>  	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
> -	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
> +	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_delattr
>  };
>  
>  static const struct fs_parameter_spec xfs_fs_parameters[] = {
> @@ -139,6 +139,7 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
>  	fsparam_flag("nodiscard",	Opt_nodiscard),
>  	fsparam_flag("dax",		Opt_dax),
>  	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
> +	fsparam_flag("delattr",		Opt_delattr),

I think you need this line to be guarded by #ifdefs so that the mount
options parsing code will reject -o larp on non-debug kernels.

--D

>  	{}
>  };
>  
> @@ -1273,6 +1274,14 @@ xfs_fs_parse_param(
>  		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
>  		return 0;
>  #endif
> +#ifdef CONFIG_XFS_DEBUG
> +	case Opt_delattr:
> +		xfs_warn(parsing_mp,
> +			"EXPERIMENTAL logged xattrs feature in use. "
> +			"Use at your own risk");
> +		parsing_mp->m_flags |= XFS_MOUNT_DELATTR;
> +		return 0;
> +#endif
>  	/* Following mount options will be removed in September 2025 */
>  	case Opt_ikeep:
>  		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 0d050f8..a4f97e7 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -8,6 +8,8 @@
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
>  #include "xfs_da_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -- 
> 2.7.4
> 
