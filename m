Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA40C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 20:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbiKQUhg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 15:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiKQUhf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 15:37:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996348CB91
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 12:37:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3320862253
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 20:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCA1C433D6;
        Thu, 17 Nov 2022 20:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668717453;
        bh=yrBWEKnwO3cI2DNXgzD2XJ19X6vMAjzsfIOJeiDljyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=otvmeO2ih6h/VRl0ZJwe8LvWjGTm7y3iqzpL0dKOkxAdTuOADaxlWfLKiYJzMS9re
         rAWx9JAP2PKqJLCh23dtfJwRDHxC1zYWxIVhzHXQwYPfl6vxLAXnvqBy0pRqNl36PD
         VHbQkxJtCZuYI4WAnVh56YtMrHSJz/gneKh6nctAar2dTBS8hu77PgkTDlD0JSwXgb
         iRocfDdSnhVpEyj2zMHAULULYzHm32yqwJQ8anyKY6J2xSyvm3zIjh5UlhRYUBJkBe
         FTSpb+0dfjtRXmu9qOvWb1X0etHrVs7oIjswRFtrh1OD1paLVOAnsvMnqD66TnbRnc
         XSNQuCZL6PiQw==
Date:   Thu, 17 Nov 2022 12:37:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1] xfs_spaceman: add fsuuid command
Message-ID: <Y3abjYmX//CF/ey0@magnolia>
References: <20221109222335.84920-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221109222335.84920-1-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 09, 2022 at 02:23:35PM -0800, Catherine Hoang wrote:
> Add support for the fsuuid command to retrieve the UUID of a mounted
> filesystem.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  spaceman/Makefile |  4 +--
>  spaceman/fsuuid.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++
>  spaceman/init.c   |  1 +
>  spaceman/space.h  |  1 +
>  4 files changed, 67 insertions(+), 2 deletions(-)
>  create mode 100644 spaceman/fsuuid.c
> 
> diff --git a/spaceman/Makefile b/spaceman/Makefile
> index 1f048d54..901e4e6d 100644
> --- a/spaceman/Makefile
> +++ b/spaceman/Makefile
> @@ -7,10 +7,10 @@ include $(TOPDIR)/include/builddefs
>  
>  LTCOMMAND = xfs_spaceman
>  HFILES = init.h space.h
> -CFILES = info.c init.c file.c health.c prealloc.c trim.c
> +CFILES = info.c init.c file.c health.c prealloc.c trim.c fsuuid.c
>  LSRCFILES = xfs_info.sh
>  
> -LLDLIBS = $(LIBXCMD) $(LIBFROG)
> +LLDLIBS = $(LIBXCMD) $(LIBFROG) $(LIBUUID)
>  LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
>  LLDFLAGS = -static
>  
> diff --git a/spaceman/fsuuid.c b/spaceman/fsuuid.c
> new file mode 100644
> index 00000000..be12c1ad
> --- /dev/null
> +++ b/spaceman/fsuuid.c
> @@ -0,0 +1,63 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2022 Oracle.
> + * All Rights Reserved.
> + */
> +
> +#include "libxfs.h"
> +#include "libfrog/fsgeom.h"
> +#include "libfrog/paths.h"
> +#include "command.h"
> +#include "init.h"
> +#include "space.h"
> +#include <sys/ioctl.h>
> +
> +#ifndef FS_IOC_GETFSUUID
> +#define FS_IOC_GETFSUUID	_IOR('f', 44, struct fsuuid)
> +#define UUID_SIZE 16
> +struct fsuuid {
> +    __u32   fsu_len;
> +    __u32   fsu_flags;
> +    __u8    fsu_uuid[];

This is a flex array   ^^ which has no size.  struct fsuuid therefore
has a size of 8 bytes (i.e. enough to cover the two u32 fields) and no
more.  It's assumed that the caller will allocate the memory for
fsu_uuid...

> +};
> +#endif
> +
> +static cmdinfo_t fsuuid_cmd;
> +
> +static int
> +fsuuid_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	struct fsuuid	fsuuid;
> +	int		error;

...which makes this usage a problem, because we've not reserved any
space on the stack to hold the UUID.  The kernel will blindly assume
that there are fsuuid.fsu_len bytes after fsuuid and write to them,
which will clobber something on the stack.

If you're really unlucky, the C compiler will put the fsuuid right
before the call frame, which is how stack smashing attacks work.  It
might also lay out bp[] immediately afterwards, which will give you
weird results as the unparse function overwrites its source buffer.  The
C compiler controls the stack layout, which means this can go bad in
subtle ways.

Either way, gcc complains about this (albeit in an opaque manner)...

In file included from ../include/xfs.h:9,
                 from ../include/libxfs.h:15,
                 from fsuuid.c:7:
In function ‘platform_uuid_unparse’,
    inlined from ‘fsuuid_f’ at fsuuid.c:45:3:
../include/xfs/linux.h:100:9: error: ‘uuid_unparse’ reading 16 bytes from a region of size 0 [-Werror=stringop-overread]
  100 |         uuid_unparse(*uu, buffer);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~
../include/xfs/linux.h: In function ‘fsuuid_f’:
../include/xfs/linux.h:100:9: note: referencing argument 1 of type ‘const unsigned char *’
In file included from ../include/xfs/linux.h:13,
                 from ../include/xfs.h:9,
                 from ../include/libxfs.h:15,
                 from fsuuid.c:7:
/usr/include/uuid/uuid.h:107:13: note: in a call to function ‘uuid_unparse’
  107 | extern void uuid_unparse(const uuid_t uu, char *out);
      |             ^~~~~~~~~~~~
cc1: all warnings being treated as errors

...so please allocate the struct fsuuid object dynamically.

--D

> +	char		bp[40];
> +
> +	fsuuid.fsu_len = UUID_SIZE;
> +	fsuuid.fsu_flags = 0;
> +
> +	error = ioctl(file->xfd.fd, FS_IOC_GETFSUUID, &fsuuid);
> +
> +	if (error) {
> +		perror("fsuuid");
> +		exitcode = 1;
> +	} else {
> +		platform_uuid_unparse((uuid_t *)fsuuid.fsu_uuid, bp);
> +		printf("UUID = %s\n", bp);
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
> +	fsuuid_cmd.flags = CMD_FLAG_ONESHOT;
> +	fsuuid_cmd.oneline = _("get mounted filesystem UUID");
> +
> +	add_command(&fsuuid_cmd);
> +}
> diff --git a/spaceman/init.c b/spaceman/init.c
> index cf1ff3cb..efe1bf9b 100644
> --- a/spaceman/init.c
> +++ b/spaceman/init.c
> @@ -35,6 +35,7 @@ init_commands(void)
>  	trim_init();
>  	freesp_init();
>  	health_init();
> +	fsuuid_init();
>  }
>  
>  static int
> diff --git a/spaceman/space.h b/spaceman/space.h
> index 723209ed..dcbdca08 100644
> --- a/spaceman/space.h
> +++ b/spaceman/space.h
> @@ -33,5 +33,6 @@ extern void	freesp_init(void);
>  #endif
>  extern void	info_init(void);
>  extern void	health_init(void);
> +extern void	fsuuid_init(void);
>  
>  #endif /* XFS_SPACEMAN_SPACE_H_ */
> -- 
> 2.25.1
> 
