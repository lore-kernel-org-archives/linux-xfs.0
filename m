Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47252 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935733AbeFNCe5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jun 2018 22:34:57 -0400
Subject: Re: [PATCH 1/5] mkfs: move build-time defaults to a separate file
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <152891831271.3968.10226627538379732223.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <712a5dfc-8da1-cc6a-2647-b54a8ea6dfef@sandeen.net>
Date: Wed, 13 Jun 2018 21:34:56 -0500
MIME-Version: 1.0
In-Reply-To: <152891831271.3968.10226627538379732223.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/13/18 2:31 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the built-in defaults to a separate file so that we can generate
> config files and manpages from them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  mkfs/Makefile   |    2 +-
>  mkfs/config.h   |    2 ++
>  mkfs/defaults.c |   27 +++++++++++++++++++++++++++
>  mkfs/xfs_mkfs.c |   19 +------------------
>  4 files changed, 31 insertions(+), 19 deletions(-)
>  create mode 100644 mkfs/defaults.c
> 
> 
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index c7815b3e..5af8a6cc 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
>  LTCOMMAND = mkfs.xfs
>  
>  HFILES =
> -CFILES = proto.c xfs_mkfs.c config.c
> +CFILES = proto.c xfs_mkfs.c config.c defaults.c
>  
>  LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
>  	$(LIBUUID)
> diff --git a/mkfs/config.h b/mkfs/config.h
> index db22adec..544f8a6d 100644
> --- a/mkfs/config.h
> +++ b/mkfs/config.h
> @@ -119,4 +119,6 @@ parse_defaults_file(
>  	struct mkfs_default_params	*dft,
>  	const char			*config_file);
>  
> +extern const struct sb_feat_args default_features;
> +
>  #endif /* _XFS_MKFS_CONFIG_H */
> diff --git a/mkfs/defaults.c b/mkfs/defaults.c
> new file mode 100644
> index 00000000..6e35a4f9
> --- /dev/null
> +++ b/mkfs/defaults.c
> @@ -0,0 +1,27 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#include "libxfs.h"
> +#include "config.h"
> +
> +/* build time feature defaults */
> +const struct sb_feat_args default_features = {
> +	.log_version = 2,
> +	.attr_version = 2,
> +	.dir_version = 2,
> +	.inode_align = true,
> +	.nci = false,
> +	.lazy_sb_counters = true,
> +	.projid32bit = true,
> +	.crcs_enabled = true,
> +	.dirftype = true,
> +	.finobt = true,
> +	.spinodes = true,
> +	.rmapbt = false,
> +	.reflink = false,
> +	.parent_pointers = false,
> +	.nodalign = false,
> +	.nortalign = false,
> +};
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index d32c2c8e..40a5da12 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3725,24 +3725,7 @@ main(
>  		.type = DEFAULTS_BUILTIN,
>  		.sectorsize = XFS_MIN_SECTORSIZE,
>  		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
> -		.sb_feat = {
> -			.log_version = 2,
> -			.attr_version = 2,
> -			.dir_version = 2,
> -			.inode_align = true,
> -			.nci = false,
> -			.lazy_sb_counters = true,
> -			.projid32bit = true,
> -			.crcs_enabled = true,
> -			.dirftype = true,
> -			.finobt = true,
> -			.spinodes = true,
> -			.rmapbt = false,
> -			.reflink = false,
> -			.parent_pointers = false,
> -			.nodalign = false,
> -			.nortalign = false,
> -		},
> +		.sb_feat = default_features,

I'm not a huge fan of making a new "defaults.c" which only contains /some/ of
the defaults (the boolean features, more or less, except also too some versions,
but also too not sizes ...) it's a weird split that's not intuitive at all.

If having the separate file is helpful wouldn't it make more sense to move all of
mkfs_default_params into it?

-Eric
