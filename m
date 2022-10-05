Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F758C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Oct 2022 06:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiJEGXh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Oct 2022 02:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiJEGXb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2022 02:23:31 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4700474BAD
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 23:23:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E3464219C0;
        Wed,  5 Oct 2022 06:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1664951008;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eoe4KVjOnZ5gE/jAOzlZBUVEOOgs+557G5AqsN1R7k0=;
        b=fyopVA++UaY+l0GuhuYBSePPfA0kjNNHx0DO8s8R1qFLq+xX2qOU7ZPzVnrEHO66iSqCkR
        5B9lQfFW2idA0OGWI9ZGNXaSROL8F30v7YtXXK81MVS3dMLjymre26GseelpD4NNh+yu1c
        VeK1boKBD275SKlgXAMdYFhNLuhMpig=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1664951008;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eoe4KVjOnZ5gE/jAOzlZBUVEOOgs+557G5AqsN1R7k0=;
        b=DRZf1rJbUXdWvEUqwcmm2DMJ7yPrzirYEqDFoE8uu8oqod7mE8KFVfbcX5LbB12P5nyYDF
        aYDMqEgG1hX2yVBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9893213345;
        Wed,  5 Oct 2022 06:23:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ujfdIeAiPWOuSAAAMHmgww
        (envelope-from <pvorel@suse.cz>); Wed, 05 Oct 2022 06:23:28 +0000
Date:   Wed, 5 Oct 2022 08:23:26 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     ltp@lists.linux.it, Tim.Bird@sony.com, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/1] df01.sh: Use own fsfreeze implementation for XFS
Message-ID: <Yz0i3lRt1feuVi3O@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20221004090810.9023-1-pvorel@suse.cz>
 <YzxbkyJlcxKgs/Fd@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzxbkyJlcxKgs/Fd@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick, all,

> On Tue, Oct 04, 2022 at 11:08:10AM +0200, Petr Vorel wrote:
> > df01.sh started to fail on XFS on certain configuration since mkfs.xfs
> > and kernel 5.19. Implement fsfreeze instead of introducing external

> ...since the introduction of background garbage collection on XFS in
> kernel 5.19. ;)
Thank you, I'll update the commit message before merge.

> > dependency. NOTE: implementation could fail on other filesystems
> > (EOPNOTSUPP on exfat, ntfs, vfat).

> > Suggested-by: Darrick J. Wong <djwong@kernel.org>
> > Suggested-by: Eric Sandeen <sandeen@redhat.com>
> > Signed-off-by: Petr Vorel <pvorel@suse.cz>
> > ---
> > Hi,

> > FYI the background of this issue:
> > https://lore.kernel.org/ltp/Yv5oaxsX6z2qxxF3@magnolia/
> > https://lore.kernel.org/ltp/974cc110-d47e-5fae-af5f-e2e610720e2d@redhat.com/

> > @LTP developers: not sure if the consensus is to avoid LTP API
> > completely (even use it just with TST_NO_DEFAULT_MAIN), if required I
> > can rewrite to use it just to get SAFE_*() macros (like
> > testcases/lib/tst_checkpoint.c) or even with tst_test workarounds
> > (testcases/lib/tst_get_free_pids.c).

> > Kind regards,
> > Petr

> >  testcases/commands/df/Makefile        |  4 +-
> >  testcases/commands/df/df01.sh         |  3 ++
> >  testcases/commands/df/df01_fsfreeze.c | 55 +++++++++++++++++++++++++++
> >  3 files changed, 61 insertions(+), 1 deletion(-)
> >  create mode 100644 testcases/commands/df/df01_fsfreeze.c

> > diff --git a/testcases/commands/df/Makefile b/testcases/commands/df/Makefile
> > index 2787bb43a..1e0b4283a 100644
> > --- a/testcases/commands/df/Makefile
> > +++ b/testcases/commands/df/Makefile
> > @@ -1,11 +1,13 @@
> >  # SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) Linux Test Project, 2021-2022
> >  # Copyright (c) 2015 Fujitsu Ltd.
> > -# Author:Zhang Jin <jy_zhangjin@cn.fujitsu.com>
> > +# Author: Zhang Jin <jy_zhangjin@cn.fujitsu.com>

> >  top_srcdir		?= ../../..

> >  include $(top_srcdir)/include/mk/env_pre.mk

> >  INSTALL_TARGETS		:= df01.sh
> > +MAKE_TARGETS			:= df01_fsfreeze

> >  include $(top_srcdir)/include/mk/generic_leaf_target.mk
> > diff --git a/testcases/commands/df/df01.sh b/testcases/commands/df/df01.sh
> > index ae0449c3c..c59d2a01d 100755
> > --- a/testcases/commands/df/df01.sh
> > +++ b/testcases/commands/df/df01.sh
> > @@ -46,6 +46,9 @@ df_test()

> >  	ROD_SILENT rm -rf $TST_MNTPOINT/testimg

> > +	# ensure free space change can be seen by statfs
> > +	[ "$fs" = "xfs" ] && ROD_SILENT df01_fsfreeze $TST_MNTPOINT
> > +
> >  	# flush file system buffers, then we can get the actual sizes.
> >  	sync
> >  }
> > diff --git a/testcases/commands/df/df01_fsfreeze.c b/testcases/commands/df/df01_fsfreeze.c
> > new file mode 100644
> > index 000000000..d47e1b01a
> > --- /dev/null
> > +++ b/testcases/commands/df/df01_fsfreeze.c
> > @@ -0,0 +1,55 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * Copyright (c) 2010 Hajime Taira <htaira@redhat.com>
> > + * Copyright (c) 2010 Masatake Yamato <yamato@redhat.com>
> > + * Copyright (c) 2022 Petr Vorel <pvorel@suse.cz>
> > + */
> > +
> > +#include <errno.h>
> > +#include <fcntl.h>
> > +#include <linux/fs.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <sys/ioctl.h>
> > +#include <sys/stat.h>
> > +#include <unistd.h>
> > +
> > +#define err_exit(...) ({ \
> > +	fprintf(stderr, __VA_ARGS__); \
> > +	if (errno) \
> > +		fprintf(stderr, ": %s (%d)", strerror(errno), errno); \
> > +	fprintf(stderr, "\n"); \
> > +	exit(EXIT_FAILURE); \
> > +})
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +	int fd;
> > +	struct stat sb;
> > +
> > +	if (argc < 2)
> > +		err_exit("USAGE: df01_fsfreeze <mountpoint>");
> > +
> > +	fd = open(argv[1], O_RDONLY);
> > +	if (fd < 0)
> > +		err_exit("open '%s' failed", argv[1]);
> > +
> > +	if (fstat(fd, &sb) == -1)
> > +		err_exit("stat of '%s' failed", argv[1]);
> > +
> > +	if (!S_ISDIR(sb.st_mode))

> Note that XFS is perfectly happy to let you call FIFREEZE on a
> nondirectory.
Thanks for info. I added this because the tool is intended to be used on
$TST_MNTPOINT, which is directory. But as not needed, I might remove it.

> > +		err_exit("%s: is not a directory", argv[1]);
> > +
> > +	if (ioctl(fd, FIFREEZE, 0) < 0)
> > +		err_exit("ioctl FIFREEZE on '%s' failed", argv[1]);
> > +
> > +	usleep(100);

> The usleep shouldn't be necessary here.  All the work necessary
> (background gc flushing, log quiescing, etc.) to stabilize the free
> space counters are performed synchronously before the FIFREEZE ioctl
> returns.

> If that's not been your experience, please let us know.

Indeed usleep() is not needed. I added it when I was debugging failures
on other filesystems.

Kind regards,
Petr

> --D

> > +	if (ioctl(fd, FITHAW, 0) < 0)
> > +		err_exit("ioctl FITHAW on '%s' failed", argv[1]);
> > +
> > +	close(fd);
> > +
> > +	return EXIT_SUCCESS;
> > +}
> > -- 
> > 2.37.3

