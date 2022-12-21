Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C92C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 16:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiLUQZG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 11:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiLUQZF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 11:25:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF94210C9
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 08:24:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C2E0B81BA8
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 16:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD09AC433EF;
        Wed, 21 Dec 2022 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671639895;
        bh=5ruQa119IoOasYBJiDyxHQ4b2h0K/e43t5fVKErqBS0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hkethdkLIVxNJzOL97k1j8mman23m005XwJSsyELMuCzkCQgbJGZDAKNcYJWqnZAP
         lTPIePawURztQs+rKaLpBZQfq3gcQD9ZbB7JYgKMrWdKAQwSzVcWzxMRMshErHt6I5
         2pMFecNDbeOUd+GISISxin9mO+VrOEVVul1TcRsghvJDedAechy0fFH88uKCzGNs0A
         316wCrjMbjhHfeemLHFG+ZPOHGtnL2px/3wc1vFlDVcqQYIPcCLlZKLf7MAGVoOnhC
         gBoTxdotovx07PCYvNxa7TyY2kq8Cc2wbvm/a+lCzdGPxBrF/NVRelMwsE8J2J78lG
         gu4s0mgXAmWuQ==
Date:   Wed, 21 Dec 2022 08:24:55 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] xfs_io: add fsuuid command
Message-ID: <Y6MzV7o6+FeUfZQk@magnolia>
References: <20221219181824.25157-1-catherine.hoang@oracle.com>
 <20221219181824.25157-2-catherine.hoang@oracle.com>
 <Y6IvPpDfS/fmNQTJ@magnolia>
 <7F927E70-E9EA-4527-BDEC-EE00A2BC6A54@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7F927E70-E9EA-4527-BDEC-EE00A2BC6A54@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 21, 2022 at 07:11:42AM +0000, Catherine Hoang wrote:
> > On Dec 20, 2022, at 1:55 PM, Darrick J. Wong <djwong@kernel.org> wrote:
> > 
> > On Mon, Dec 19, 2022 at 10:18:23AM -0800, Catherine Hoang wrote:
> >> Add support for the fsuuid command to retrieve the UUID of a mounted
> >> filesystem.
> >> 
> >> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> >> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> >> ---
> >> io/Makefile       |  6 +++---
> >> io/fsuuid.c       | 49 +++++++++++++++++++++++++++++++++++++++++++++++
> >> io/init.c         |  1 +
> >> io/io.h           |  1 +
> >> man/man8/xfs_io.8 |  3 +++
> >> 5 files changed, 57 insertions(+), 3 deletions(-)
> >> create mode 100644 io/fsuuid.c
> >> 
> >> diff --git a/io/Makefile b/io/Makefile
> >> index 498174cf..53fef09e 100644
> >> --- a/io/Makefile
> >> +++ b/io/Makefile
> >> @@ -10,12 +10,12 @@ LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
> >> HFILES = init.h io.h
> >> CFILES = init.c \
> >> 	attr.c bmap.c bulkstat.c crc32cselftest.c cowextsize.c encrypt.c \
> >> -	file.c freeze.c fsync.c getrusage.c imap.c inject.c label.c link.c \
> >> -	mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
> >> +	file.c freeze.c fsuuid.c fsync.c getrusage.c imap.c inject.c label.c \
> >> +	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
> >> 	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
> >> 	truncate.c utimes.c
> >> 
> >> -LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
> >> +LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
> >> LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
> >> LLDFLAGS = -static-libtool-libs
> >> 
> >> diff --git a/io/fsuuid.c b/io/fsuuid.c
> >> new file mode 100644
> >> index 00000000..7e14a95d
> >> --- /dev/null
> >> +++ b/io/fsuuid.c
> >> @@ -0,0 +1,49 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/*
> >> + * Copyright (c) 2022 Oracle.
> >> + * All Rights Reserved.
> >> + */
> >> +
> >> +#include "libxfs.h"
> >> +#include "command.h"
> >> +#include "init.h"
> >> +#include "io.h"
> >> +#include "libfrog/fsgeom.h"
> >> +#include "libfrog/logging.h"
> >> +
> >> +static cmdinfo_t fsuuid_cmd;
> >> +
> >> +static int
> >> +fsuuid_f(
> >> +	int			argc,
> >> +	char			**argv)
> >> +{
> >> +	struct xfs_fsop_geom	fsgeo;
> >> +	int			ret;
> >> +	char			bp[40];
> >> +
> >> +	ret = -xfrog_geometry(file->fd, &fsgeo);
> >> +
> >> +	if (ret) {
> >> +		xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
> >> +		exitcode = 1;
> >> +	} else {
> >> +		platform_uuid_unparse((uuid_t *)fsgeo.uuid, bp);
> >> +		printf("UUID = %s\n", bp);
> > 
> > Lowercase "uuid" to match the xfs_db uuid command.
> 
> I noticed xfs_db also prints “uuid" in uppercase, so I didn’t change it

Lol, dunno why I didn't notice that. :/

Carry on!

--D

> > With that fixed,
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> Thanks for reviewing!
> > 
> > --D
> > 
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +void
> >> +fsuuid_init(void)
> >> +{
> >> +	fsuuid_cmd.name = "fsuuid";
> >> +	fsuuid_cmd.cfunc = fsuuid_f;
> >> +	fsuuid_cmd.argmin = 0;
> >> +	fsuuid_cmd.argmax = 0;
> >> +	fsuuid_cmd.flags = CMD_FLAG_ONESHOT | CMD_NOMAP_OK;
> >> +	fsuuid_cmd.oneline = _("get mounted filesystem UUID");
> >> +
> >> +	add_command(&fsuuid_cmd);
> >> +}
> >> diff --git a/io/init.c b/io/init.c
> >> index 033ed67d..104cd2c1 100644
> >> --- a/io/init.c
> >> +++ b/io/init.c
> >> @@ -56,6 +56,7 @@ init_commands(void)
> >> 	flink_init();
> >> 	freeze_init();
> >> 	fsmap_init();
> >> +	fsuuid_init();
> >> 	fsync_init();
> >> 	getrusage_init();
> >> 	help_init();
> >> diff --git a/io/io.h b/io/io.h
> >> index 64b7a663..fe474faf 100644
> >> --- a/io/io.h
> >> +++ b/io/io.h
> >> @@ -94,6 +94,7 @@ extern void		encrypt_init(void);
> >> extern void		file_init(void);
> >> extern void		flink_init(void);
> >> extern void		freeze_init(void);
> >> +extern void		fsuuid_init(void);
> >> extern void		fsync_init(void);
> >> extern void		getrusage_init(void);
> >> extern void		help_init(void);
> >> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> >> index 223b5152..ef7087b3 100644
> >> --- a/man/man8/xfs_io.8
> >> +++ b/man/man8/xfs_io.8
> >> @@ -1455,6 +1455,9 @@ This option is not compatible with the
> >> flag.
> >> .RE
> >> .PD
> >> +.TP
> >> +.B fsuuid
> >> +Print the mounted filesystem UUID.
> >> 
> >> 
> >> .SH OTHER COMMANDS
> >> -- 
> >> 2.25.1
> >> 
> 
