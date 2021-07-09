Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FAA3C07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 544C56138C
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 04:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbhGIEQv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 00:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhGIEQu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jul 2021 00:16:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72B886138C;
        Fri,  9 Jul 2021 04:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625804047;
        bh=3HHra3Jq53lo+WVPnVyS8ov3rj8AA0CHBs9KW+uCg8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sCPHgfsmW8gCHixlhy4GexBfVr6z1kmaZ8NleirhWsiV3Y2zKeCWbV+TzNlxp0eeN
         Fw2pp8OQu+M0DuxR+L7xIGOuc7XUOhuPviF6iC5VWOz57IbBjIhI7f8w/j326atKOz
         3AnBN3Uy2mSWUEV4BG4MZVSUzHy5xLTXbe7XaIAoOc6j6tHQEo0FH1GWpuCqP9qkk4
         BNNzm9bIIiZIIvG7lSFmcxd1CY4n62mCPgD6dRgg7JuIHoG6fT9tityIji9pMF+Nkf
         dfHYO3ZYbAP+C0Kp3s8mlwyL/G8aVuU7ZVrdx1VSBjgCL1wD2eePyNue6BzX+T3wzk
         Pl5cG2B5SxASg==
Date:   Thu, 8 Jul 2021 21:14:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v21 11/13] xfs: Add delattr mount option
Message-ID: <20210709041407.GP11588@locust>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
 <20210707222111.16339-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707222111.16339-12-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 07, 2021 at 03:21:09PM -0700, Allison Henderson wrote:
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
> index 859dbef..5141958 100644
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
>  
>  /*
>   * Max and min values for mount-option defined I/O
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index c30b077..1a7edae 100644
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
>  	{}
>  };
>  
> @@ -1277,6 +1278,9 @@ xfs_fs_parse_param(
>  		xfs_mount_set_dax_mode(parsing_mp, result.uint_32);
>  		return 0;
>  #endif
> +	case Opt_delattr:
> +		parsing_mp->m_flags |= XFS_MOUNT_DELATTR;
> +		return 0;

Can we restrict this to CONFIG_XFS_DEBUG=y or at least log the usual

"EXPERIMENTAL logged xattrs feature in use, use at your orkgs!"

message at mount?

--D

>  	/* Following mount options will be removed in September 2025 */
>  	case Opt_ikeep:
>  		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_IKEEP, true);
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 66b334f..7335423 100644
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
