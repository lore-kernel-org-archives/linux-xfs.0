Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1561FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 16:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiJDQNO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 12:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJDQNN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 12:13:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096532C124
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 09:13:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 582B9CE10EC
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 16:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB38C433C1;
        Tue,  4 Oct 2022 16:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664899988;
        bh=hWmdNenGYwkJ5nm6qAEqQIe8T2NHeSqGqdRiN3MoH04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qbf2sPJI11nLeoOtTQEhq8Hw9uvLIyR+sarLsLMKK4ci5LrnUhadfTPeifsNo3QyH
         1fx2nb7ZRYYHit7gBKEXxKmNJyiLH5u+xjgNDVZUSsHKchKDfaLgVgYwaPEOQSRNnG
         ddA5aHlysgV8w1u8W86rPurXrfT34JVWEL0rZxwOiCpAgeKoH+0FJwLJrUvPED8K0n
         bekHBwkPsF/DunBbNxdMPFtntriNr2DFjW81fPRvx/jF8QRMFVsMMGNu0Cdmp3AgAE
         kaoxFwGlUGCOAN2ceam/V7cMB/hKFm0X6HCl32biozktA6kSuUEC3A44WodqzvDRIU
         hX0leBL4NcSFA==
Date:   Tue, 4 Oct 2022 09:13:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     ltp@lists.linux.it, Tim.Bird@sony.com, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/1] df01.sh: Use own fsfreeze implementation for XFS
Message-ID: <YzxbkyJlcxKgs/Fd@magnolia>
References: <20221004090810.9023-1-pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004090810.9023-1-pvorel@suse.cz>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 04, 2022 at 11:08:10AM +0200, Petr Vorel wrote:
> df01.sh started to fail on XFS on certain configuration since mkfs.xfs
> and kernel 5.19. Implement fsfreeze instead of introducing external

...since the introduction of background garbage collection on XFS in
kernel 5.19. ;)

> dependency. NOTE: implementation could fail on other filesystems
> (EOPNOTSUPP on exfat, ntfs, vfat).
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Suggested-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Petr Vorel <pvorel@suse.cz>
> ---
> Hi,
> 
> FYI the background of this issue:
> https://lore.kernel.org/ltp/Yv5oaxsX6z2qxxF3@magnolia/
> https://lore.kernel.org/ltp/974cc110-d47e-5fae-af5f-e2e610720e2d@redhat.com/
> 
> @LTP developers: not sure if the consensus is to avoid LTP API
> completely (even use it just with TST_NO_DEFAULT_MAIN), if required I
> can rewrite to use it just to get SAFE_*() macros (like
> testcases/lib/tst_checkpoint.c) or even with tst_test workarounds
> (testcases/lib/tst_get_free_pids.c).
> 
> Kind regards,
> Petr
> 
>  testcases/commands/df/Makefile        |  4 +-
>  testcases/commands/df/df01.sh         |  3 ++
>  testcases/commands/df/df01_fsfreeze.c | 55 +++++++++++++++++++++++++++
>  3 files changed, 61 insertions(+), 1 deletion(-)
>  create mode 100644 testcases/commands/df/df01_fsfreeze.c
> 
> diff --git a/testcases/commands/df/Makefile b/testcases/commands/df/Makefile
> index 2787bb43a..1e0b4283a 100644
> --- a/testcases/commands/df/Makefile
> +++ b/testcases/commands/df/Makefile
> @@ -1,11 +1,13 @@
>  # SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) Linux Test Project, 2021-2022
>  # Copyright (c) 2015 Fujitsu Ltd.
> -# Author:Zhang Jin <jy_zhangjin@cn.fujitsu.com>
> +# Author: Zhang Jin <jy_zhangjin@cn.fujitsu.com>
>  
>  top_srcdir		?= ../../..
>  
>  include $(top_srcdir)/include/mk/env_pre.mk
>  
>  INSTALL_TARGETS		:= df01.sh
> +MAKE_TARGETS			:= df01_fsfreeze
>  
>  include $(top_srcdir)/include/mk/generic_leaf_target.mk
> diff --git a/testcases/commands/df/df01.sh b/testcases/commands/df/df01.sh
> index ae0449c3c..c59d2a01d 100755
> --- a/testcases/commands/df/df01.sh
> +++ b/testcases/commands/df/df01.sh
> @@ -46,6 +46,9 @@ df_test()
>  
>  	ROD_SILENT rm -rf $TST_MNTPOINT/testimg
>  
> +	# ensure free space change can be seen by statfs
> +	[ "$fs" = "xfs" ] && ROD_SILENT df01_fsfreeze $TST_MNTPOINT
> +
>  	# flush file system buffers, then we can get the actual sizes.
>  	sync
>  }
> diff --git a/testcases/commands/df/df01_fsfreeze.c b/testcases/commands/df/df01_fsfreeze.c
> new file mode 100644
> index 000000000..d47e1b01a
> --- /dev/null
> +++ b/testcases/commands/df/df01_fsfreeze.c
> @@ -0,0 +1,55 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (c) 2010 Hajime Taira <htaira@redhat.com>
> + * Copyright (c) 2010 Masatake Yamato <yamato@redhat.com>
> + * Copyright (c) 2022 Petr Vorel <pvorel@suse.cz>
> + */
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <linux/fs.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +
> +#define err_exit(...) ({ \
> +	fprintf(stderr, __VA_ARGS__); \
> +	if (errno) \
> +		fprintf(stderr, ": %s (%d)", strerror(errno), errno); \
> +	fprintf(stderr, "\n"); \
> +	exit(EXIT_FAILURE); \
> +})
> +
> +int main(int argc, char *argv[])
> +{
> +	int fd;
> +	struct stat sb;
> +
> +	if (argc < 2)
> +		err_exit("USAGE: df01_fsfreeze <mountpoint>");
> +
> +	fd = open(argv[1], O_RDONLY);
> +	if (fd < 0)
> +		err_exit("open '%s' failed", argv[1]);
> +
> +	if (fstat(fd, &sb) == -1)
> +		err_exit("stat of '%s' failed", argv[1]);
> +
> +	if (!S_ISDIR(sb.st_mode))

Note that XFS is perfectly happy to let you call FIFREEZE on a
nondirectory.

> +		err_exit("%s: is not a directory", argv[1]);
> +
> +	if (ioctl(fd, FIFREEZE, 0) < 0)
> +		err_exit("ioctl FIFREEZE on '%s' failed", argv[1]);
> +
> +	usleep(100);

The usleep shouldn't be necessary here.  All the work necessary
(background gc flushing, log quiescing, etc.) to stabilize the free
space counters are performed synchronously before the FIFREEZE ioctl
returns.

If that's not been your experience, please let us know.

--D

> +	if (ioctl(fd, FITHAW, 0) < 0)
> +		err_exit("ioctl FITHAW on '%s' failed", argv[1]);
> +
> +	close(fd);
> +
> +	return EXIT_SUCCESS;
> +}
> -- 
> 2.37.3
> 
