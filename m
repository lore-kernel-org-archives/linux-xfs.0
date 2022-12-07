Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B491C352A1
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Dec 2022 17:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiLGRon (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiLGRo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Dec 2022 12:44:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B8C654E9
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2022 09:44:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25512B81F1F
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2022 17:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB22C433D6;
        Wed,  7 Dec 2022 17:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670435063;
        bh=P1erhoSAIapA+WOetCeETXw0v41vPSznfumMWVg18ms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f8aZdVDHJMwEbKqOUOiQMqQePpAAC+7VmubnCSQ1oW/gzJSHjoGjvLGqYB6pXyzaV
         zw7ka68j1P9v2rtjbW54KoOE0p715ZZiLQUM8l6Zkc6dfPvCBscLirUWRqQhRlCRgj
         3R/BbdE6OaPWkcn+xRJ7faTh4ucsD19PAxW/3Hqh4lWLapTrxZF2XEWkugbSWIS3Cm
         8oKHAfhAia4BkPKkDFQpkcI2112cIAgUPKZExvV0mbGWUCZOhyNi3X/Iw9LnupYq92
         tfRnebm207jNW7qR0OllYaV02GhnOu30I/ukaViz1PynBGY2vlvUFspxF9A7jllNO2
         cefgc/u3Bf+4g==
Date:   Wed, 7 Dec 2022 09:44:23 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 1/2] xfs_io: add fsuuid command
Message-ID: <Y5DQ9089o0YFk85E@magnolia>
References: <20221207022346.56671-1-catherine.hoang@oracle.com>
 <20221207022346.56671-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207022346.56671-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 06, 2022 at 06:23:45PM -0800, Catherine Hoang wrote:
> Add support for the fsuuid command to retrieve the UUID of a mounted
> filesystem.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  io/Makefile |  6 +++---
>  io/fsuuid.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  io/init.c   |  1 +
>  io/io.h     |  1 +
>  4 files changed, 54 insertions(+), 3 deletions(-)
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

New xfs_io commands should be added to man/man/xfs_io.8.

Other than those two issues, this looks good to me.

--D

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
> -- 
> 2.25.1
> 
