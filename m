Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBDBC43217
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Oct 2022 14:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiJQOWx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Oct 2022 10:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiJQOWw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2022 10:22:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3797265651
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2022 07:22:45 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6FB5D33AD5;
        Mon, 17 Oct 2022 14:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666016563;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ieLim755GWnQk3Uq8uQOv2Bg2ABrJnBUn7nfnhMCG+0=;
        b=uYpBfILjO9k6DThCTUyubK/Xvz37uzySa2FD2JcW9Hk5bF2zErxtPjrukv3ML1FB0NHydI
        wP6rxFW0rJFnm/lEWOVNNW0XGuAsyIgP+lTEaO8+auYS6ZguIfeonTxpQ+86CBnwv1VVBy
        yUGdPDuALon5knsFiQSuuv9IYr7ZvOo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666016563;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ieLim755GWnQk3Uq8uQOv2Bg2ABrJnBUn7nfnhMCG+0=;
        b=fGtQoxHvDipSiuQUnFXBCko9slpPnF3CjMVmL+UI0DHVO/lxEOFRZCJ36yehcDDdKbfTTo
        V/414DvgpeZNCdBA==
Received: from g78 (unknown [10.100.228.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 606F82C141;
        Mon, 17 Oct 2022 14:22:42 +0000 (UTC)
References: <20221004090810.9023-1-pvorel@suse.cz>
User-agent: mu4e 1.6.10; emacs 28.1
From:   Richard Palethorpe <rpalethorpe@suse.de>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>, ltp@lists.linux.it
Subject: Re: [LTP] [PATCH 1/1] df01.sh: Use own fsfreeze implementation for XFS
Date:   Mon, 17 Oct 2022 15:20:05 +0100
Reply-To: rpalethorpe@suse.de
In-reply-to: <20221004090810.9023-1-pvorel@suse.cz>
Message-ID: <87sfjmmswf.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

Petr Vorel <pvorel@suse.cz> writes:

> df01.sh started to fail on XFS on certain configuration since mkfs.xfs
> and kernel 5.19. Implement fsfreeze instead of introducing external
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

Why would that be the consensus? :-)

> can rewrite to use it just to get SAFE_*() macros (like
> testcases/lib/tst_checkpoint.c) or even with tst_test workarounds
> (testcases/lib/tst_get_free_pids.c).

Yes, it should work fine with TST_NO_DEFAULT_MAIN

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
> +		err_exit("%s: is not a directory", argv[1]);
> +
> +	if (ioctl(fd, FIFREEZE, 0) < 0)
> +		err_exit("ioctl FIFREEZE on '%s' failed", argv[1]);
> +
> +	usleep(100);
> +
> +	if (ioctl(fd, FITHAW, 0) < 0)
> +		err_exit("ioctl FITHAW on '%s' failed", argv[1]);
> +
> +	close(fd);
> +
> +	return EXIT_SUCCESS;
> +}
> -- 
> 2.37.3


-- 
Thank you,
Richard.
