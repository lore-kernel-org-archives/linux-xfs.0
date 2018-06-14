Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49354 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935777AbeFNDFS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jun 2018 23:05:18 -0400
Subject: Re: [PATCH 4/5] mkfs: emit config file from builtin defaults
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <152891833127.3968.5527165230597489132.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8d84e371-7a2d-ce5d-f158-2400fe757c50@sandeen.net>
Date: Wed, 13 Jun 2018 22:05:17 -0500
MIME-Version: 1.0
In-Reply-To: <152891833127.3968.5527165230597489132.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/13/18 2:32 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a build-time helper program to generate a config file from the
> built-in defaults.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok.  This is good, but I think we are going ot have to find a way to collapse
all these structures down, now we've replicated things 3 times (i.e. a new
boolean/feature will now hit xfs_mkfs.c, config.c, and mkconfig.c ...)

But this is a step forward for consistency w.r.t. manpage & template file,
so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/Makefile   |   14 ++++-
>  mkfs/mkconfig.c |  163 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 176 insertions(+), 1 deletion(-)
>  create mode 100644 mkfs/mkconfig.c
> 
> 
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index 102f5214..44ddbd30 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -12,13 +12,24 @@ CFILES = proto.c xfs_mkfs.c config.c defaults.c
>  
>  CFGFILE_CFLAGS = -DMKFS_XFS_CONF_DIR=\"$(PKG_MKFS_CFG_DIR)\" \
>  		 -DMKFS_XFS_DEFAULT_CONFIG=\"$(PKG_MKFS_DEFAULT_CFGFILE)\"
> +CFGFILE_TEMPLATE = $(PKG_MKFS_DEFAULT_CFGFILE).template
> +
>  LCFLAGS += $(CFGFILE_CFLAGS)
>  LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
>  	$(LIBUUID)
>  LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
>  LLDFLAGS = -static-libtool-libs
> +LDIRT = $(CFGFILE_TEMPLATE)
> +
> +default: depend $(CFGFILE_TEMPLATE) $(LTCOMMAND)
> +
> +mkconfig: mkconfig.c defaults.c
> +	@echo "    [CC]     mkconfig"
> +	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) $(CFGFILE_CFLAGS) -o $@ $^
>  
> -default: depend $(LTCOMMAND)
> +$(CFGFILE_TEMPLATE): mkconfig
> +	@echo "    [GENERATE] $@"
> +	$(Q) ./mkconfig > $@
>  
>  include $(BUILDRULES)
>  
> @@ -27,6 +38,7 @@ install: default
>  	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
>  	$(INSTALL) -m 755 -d $(PKG_CFG_DIR)
>  	$(INSTALL) -m 755 -d $(PKG_MKFS_CFG_DIR)
> +	$(INSTALL) -m 644 $(CFGFILE_TEMPLATE) $(PKG_MKFS_CFG_DIR)
>  install-dev:
>  
>  -include .dep
> diff --git a/mkfs/mkconfig.c b/mkfs/mkconfig.c
> new file mode 100644
> index 00000000..3826b0bf
> --- /dev/null
> +++ b/mkfs/mkconfig.c
> @@ -0,0 +1,163 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#include "libxfs.h"
> +#include "config.h"
> +
> +enum cfgfile_var_type {
> +	FV_BOOL = 0
> +};
> +
> +struct subopt_map {
> +	const char		*suboptname;
> +	const void		*ptr;
> +	enum cfgfile_var_type	type;
> +};
> +
> +/* Map all the config file options to their default_features equivalents. */
> +struct confopts {
> +	const char		*name;
> +	struct subopt_map	subopts[CFG_MAX_SUBOPTS];
> +} confopts_tab[] = {
> +	{
> +		.name = "data",
> +		.subopts = {
> +			[CFG_D_NOALIGN] = {
> +				.suboptname	= "noalign",
> +				.ptr		= &default_features.nodalign,
> +				.type		= FV_BOOL,
> +			},
> +			{NULL}
> +		},
> +	},
> +	{
> +		.name = "inode",
> +		.subopts = {
> +			[CFG_I_ALIGN] = {
> +				.suboptname	= "align",
> +				.ptr		= &default_features.inode_align,
> +				.type		= FV_BOOL,
> +			},
> +			[CFG_I_PROJID32BIT] = {
> +				.suboptname	= "projid32bit",
> +				.ptr		= &default_features.projid32bit,
> +				.type		= FV_BOOL,
> +			},
> +			[CFG_I_SPINODES] = {
> +				.suboptname	= "sparse",
> +				.ptr		= &default_features.spinodes,
> +				.type		= FV_BOOL,
> +			},
> +			{NULL}
> +		},
> +	},
> +	{
> +		.name = "log",
> +		.subopts = {
> +			[CFG_L_LAZYSBCNTR] = {
> +				.suboptname	= "lazy-count",
> +				.ptr		= &default_features.lazy_sb_counters,
> +				.type		= FV_BOOL,
> +			},
> +			{NULL}
> +		},
> +	},
> +	{
> +		.name = "metadata",
> +		.subopts = {
> +			[CFG_M_CRC] = {
> +				.suboptname	= "crc",
> +				.ptr		= &default_features.crcs_enabled,
> +				.type		= FV_BOOL,
> +			},
> +			[CFG_M_FINOBT] = {
> +				.suboptname	= "finobt",
> +				.ptr		= &default_features.finobt,
> +				.type		= FV_BOOL,
> +			},
> +			[CFG_M_RMAPBT] = {
> +				.suboptname	= "rmapbt",
> +				.ptr		= &default_features.rmapbt,
> +				.type		= FV_BOOL,
> +			},
> +			[CFG_M_REFLINK] = {
> +				.suboptname	= "reflink",
> +				.ptr		= &default_features.reflink,
> +				.type		= FV_BOOL,
> +			},
> +			{NULL}
> +		},
> +	},
> +	{
> +		.name = "naming",
> +		.subopts = {
> +			[CFG_N_FTYPE] = {
> +				.suboptname	= "ftype",
> +				.ptr		= &default_features.dirftype,
> +				.type		= FV_BOOL,
> +			},
> +			{NULL}
> +		},
> +	},
> +	{
> +		.name = "rtdev",
> +		.subopts = {
> +			[CFG_R_NOALIGN] = {
> +				.suboptname	= "noalign",
> +				.ptr		= &default_features.nortalign,
> +				.type		= FV_BOOL,
> +			},
> +			{NULL}
> +		},
> +	},
> +};
> +
> +/* Spit out a config file template. */
> +int
> +main(
> +	int			argc,
> +	char			*argv[])
> +{
> +	struct confopts		*opts = confopts_tab;
> +	struct subopt_map	*submap;
> +	int			c;
> +	unsigned int		i, j;
> +
> +	while ((c = getopt(argc, argv, "")) != EOF) {
> +		switch (c) {
> +		case '?':
> +			fprintf(stderr, "Unknown option %c.\n", optopt);
> +			return 1;
> +		}
> +	}
> +	if (argc - optind != 0) {
> +		fprintf(stderr, "extra arguments\n");
> +		return 1;
> +	}
> +
> +	printf("# mkfs.xfs configuration file to collect settings.\n");
> +	printf("# See the mkfs.xfs(8) manpage for details.\n");
> +	printf("# Copy this file to %s/%s to override the built-in defaults.\n",
> +			MKFS_XFS_CONF_DIR, MKFS_XFS_DEFAULT_CONFIG);
> +
> +	for (i = 0; i < ARRAY_SIZE(confopts_tab); i++, opts++) {
> +		if (i > 0)
> +			printf("\n");
> +		printf("[%s]\n", opts->name);
> +		submap = opts->subopts;
> +		for (j = 0;
> +		     j < ARRAY_SIZE(opts->subopts) && submap->suboptname;
> +		     j++, submap++) {
> +			printf("%s = ", submap->suboptname);
> +			switch (submap->type) {
> +			case FV_BOOL:
> +				printf("%d\n", *((bool *)submap->ptr));
> +				break;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
