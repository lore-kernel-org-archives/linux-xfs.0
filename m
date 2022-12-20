Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFD2C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 21:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbiLTVzO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 16:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLTVzN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 16:55:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603D61EEDB
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 13:55:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F04A1615D4
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 21:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54825C433D2;
        Tue, 20 Dec 2022 21:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671573311;
        bh=X7u26GFQyTR/hkDZtScYDKzsQEBAwUwXIBO5RvYPCg4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ap8LYz2tjyD76SAUpP2Jt4X8xJH+RX2HTKQhW1/Mfd3E7nE7qK7LufrQxJy9dNh5/
         ZktiTHeKhWcjTQdInaJG+hVBjZgq2/rbPBxZ37bYghBjUK9lBc8t0mSKmbntJaQceN
         N0elP6NSMfsA0fY10pmhlq88iHQjZ6RLMl8Ri9b+SgWmU2ckx2CaMgImf694sOGVTJ
         UZNlM+8XwkYgW8ZHjM1Fm5zzOI9d/L6Et/JKfSsR3tCLdttah87eY8+YWtk/npXLJz
         LcGqwZ2OVy6DziX0zGTin6OJmG4dapbuVC1pjPlq2qW3SsLIVK/dRJlvx77ynY8QIP
         yqAC6PmaZUtUA==
Date:   Tue, 20 Dec 2022 13:55:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs_io: add fsuuid command
Message-ID: <Y6IvPpDfS/fmNQTJ@magnolia>
References: <20221219181824.25157-1-catherine.hoang@oracle.com>
 <20221219181824.25157-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219181824.25157-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 19, 2022 at 10:18:23AM -0800, Catherine Hoang wrote:
> Add support for the fsuuid command to retrieve the UUID of a mounted
> filesystem.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  io/Makefile       |  6 +++---
>  io/fsuuid.c       | 49 +++++++++++++++++++++++++++++++++++++++++++++++
>  io/init.c         |  1 +
>  io/io.h           |  1 +
>  man/man8/xfs_io.8 |  3 +++
>  5 files changed, 57 insertions(+), 3 deletions(-)
>  create mode 100644 io/fsuuid.c
> 
> diff --git a/io/Makefile b/io/Makefile
> index 498174cf..53fef09e 100644
> --- a/io/Makefile
> +++ b/io/Makefile
> @@ -10,12 +10,12 @@ LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
>  HFILES = init.h io.h
>  CFILES = init.c \
>  	attr.c bmap.c bulkstat.c crc32cselftest.c cowextsize.c encrypt.c \
> -	file.c freeze.c fsync.c getrusage.c imap.c inject.c label.c link.c \
> -	mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
> +	file.c freeze.c fsuuid.c fsync.c getrusage.c imap.c inject.c label.c \
> +	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
>  	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
>  	truncate.c utimes.c
>  
> -LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
> +LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
>  LLDFLAGS = -static-libtool-libs
>  
> diff --git a/io/fsuuid.c b/io/fsuuid.c
> new file mode 100644
> index 00000000..7e14a95d
> --- /dev/null
> +++ b/io/fsuuid.c
> @@ -0,0 +1,49 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2022 Oracle.
> + * All Rights Reserved.
> + */
> +
> +#include "libxfs.h"
> +#include "command.h"
> +#include "init.h"
> +#include "io.h"
> +#include "libfrog/fsgeom.h"
> +#include "libfrog/logging.h"
> +
> +static cmdinfo_t fsuuid_cmd;
> +
> +static int
> +fsuuid_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	struct xfs_fsop_geom	fsgeo;
> +	int			ret;
> +	char			bp[40];
> +
> +	ret = -xfrog_geometry(file->fd, &fsgeo);
> +
> +	if (ret) {
> +		xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
> +		exitcode = 1;
> +	} else {
> +		platform_uuid_unparse((uuid_t *)fsgeo.uuid, bp);
> +		printf("UUID = %s\n", bp);

Lowercase "uuid" to match the xfs_db uuid command.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +	}
> +
> +	return 0;
> +}
> +
> +void
> +fsuuid_init(void)
> +{
> +	fsuuid_cmd.name = "fsuuid";
> +	fsuuid_cmd.cfunc = fsuuid_f;
> +	fsuuid_cmd.argmin = 0;
> +	fsuuid_cmd.argmax = 0;
> +	fsuuid_cmd.flags = CMD_FLAG_ONESHOT | CMD_NOMAP_OK;
> +	fsuuid_cmd.oneline = _("get mounted filesystem UUID");
> +
> +	add_command(&fsuuid_cmd);
> +}
> diff --git a/io/init.c b/io/init.c
> index 033ed67d..104cd2c1 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -56,6 +56,7 @@ init_commands(void)
>  	flink_init();
>  	freeze_init();
>  	fsmap_init();
> +	fsuuid_init();
>  	fsync_init();
>  	getrusage_init();
>  	help_init();
> diff --git a/io/io.h b/io/io.h
> index 64b7a663..fe474faf 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -94,6 +94,7 @@ extern void		encrypt_init(void);
>  extern void		file_init(void);
>  extern void		flink_init(void);
>  extern void		freeze_init(void);
> +extern void		fsuuid_init(void);
>  extern void		fsync_init(void);
>  extern void		getrusage_init(void);
>  extern void		help_init(void);
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 223b5152..ef7087b3 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -1455,6 +1455,9 @@ This option is not compatible with the
>  flag.
>  .RE
>  .PD
> +.TP
> +.B fsuuid
> +Print the mounted filesystem UUID.
>  
>  
>  .SH OTHER COMMANDS
> -- 
> 2.25.1
> 
