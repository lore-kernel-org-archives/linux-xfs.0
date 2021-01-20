Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA36CC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 14:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71ACF207D2
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 14:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbhATOQ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 09:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388391AbhATMgZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jan 2021 07:36:25 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512B4C0613C1
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jan 2021 04:35:39 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b8so12459686plx.0
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jan 2021 04:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Wyrel8tVMPDNmnijEzid7KktGZjgrvGxpPiTMu/xK2I=;
        b=I68AsjRRqqWa11PhGMYZ/8GQLNhJE4YvQzcgu2KHp3uadFpT2Yk/xlsVG+9XOH75ih
         7tXbzw4YxIZT1kLBKDkbpoLPu1avgpeTjSGka904UPN/ZOyecwpdg3Dh7TWdT85nRn9g
         2eOiTqYoduoWs6fdvX6/VKj7g3rfxv+NkE/Fz3MKDXwKYf9Kps0rlEhAF6N+YY4qfEIT
         LXg90oPHrSlJhAcO8QV2EFK7Z/hfbZLtUwApo+1B5CK10KKJoEO7weSPMzTur2DdteES
         ZrYajaSN2OG51Olc9f0qeNeHGtPKSoVWw3/GMVKLKLQEqCksUthjOATzFWxHzINzVA2B
         T4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Wyrel8tVMPDNmnijEzid7KktGZjgrvGxpPiTMu/xK2I=;
        b=hdj/OZwDGA5w9vdd4JFRY9IsuCGD80jyUKSYbGPv+1rpEhNX+RqAQ69sord0e68ran
         onfJqjJeLvh2EWA14k+M1CO0T3S0AsbztCzC7NVkmOxEO8hCmBvoUH0joPTYkFMMDQkF
         LLkRM+WYdJtgFRVDdmEn4aFKMzAOi2SurRHzyFZrfavZn2bKocW18XaN9XQWFrBzh+KE
         2qS7Z26hN5CFDFtsR929WM2i06yLho/+iAUHakvPfSUkPWMAH/vBxURTPXpmLzG1JvHM
         1lAs8215JMzHteqBHQV5l3uG6WYKo79WvufdTCs3ziaCYCPsxBEtuDe4ofou1KgDIZKl
         wiOw==
X-Gm-Message-State: AOAM530yzdNs5plvPf9Cll0ZRjgLKmsSrdL5l9ctJdu8nkXeOxyjhBnW
        gFvzRRq5D/cHzrWZ4bysVZXS7AAMN9k=
X-Google-Smtp-Source: ABdhPJy0XBR85EOLcbNAxnQ2dy1GQvOjFmHHYbdxyFUqsBFA9ZGofePTSbpbkz5Ujuq2xzV1sqrwow==
X-Received: by 2002:a17:90a:5581:: with SMTP id c1mr5625275pji.86.1611146138633;
        Wed, 20 Jan 2021 04:35:38 -0800 (PST)
Received: from garuda ([122.171.200.115])
        by smtp.gmail.com with ESMTPSA id u12sm2194159pgi.91.2021.01.20.04.35.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Jan 2021 04:35:38 -0800 (PST)
References: <161076026570.3386403.8299786881687962135.stgit@magnolia> <161076027195.3386403.12700317703299129248.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_db: add a directory path lookup command
In-reply-to: <161076027195.3386403.12700317703299129248.stgit@magnolia>
Date:   Wed, 20 Jan 2021 18:05:35 +0530
Message-ID: <87k0s723c8.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 16 Jan 2021 at 06:54, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Add a command to xfs_db so that we can navigate to inodes by path.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  db/Makefile       |    3 -
>  db/command.c      |    1
>  db/command.h      |    1
>  db/namei.c        |  223 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/xfs_db.8 |    4 +
>  5 files changed, 231 insertions(+), 1 deletion(-)
>  create mode 100644 db/namei.c
>
>
> diff --git a/db/Makefile b/db/Makefile
> index 9d502bf0..beafb105 100644
> --- a/db/Makefile
> +++ b/db/Makefile
> @@ -14,7 +14,8 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
>  	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
>  	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
>  	fuzz.h
> -CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c timelimit.c
> +CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c \
> +	timelimit.c
>  LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
>
>  LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
> diff --git a/db/command.c b/db/command.c
> index 43828369..02f778b9 100644
> --- a/db/command.c
> +++ b/db/command.c
> @@ -131,6 +131,7 @@ init_commands(void)
>  	logformat_init();
>  	io_init();
>  	metadump_init();
> +	namei_init();
>  	output_init();
>  	print_init();
>  	quit_init();
> diff --git a/db/command.h b/db/command.h
> index 6913c817..498983ff 100644
> --- a/db/command.h
> +++ b/db/command.h
> @@ -33,3 +33,4 @@ extern void		btdump_init(void);
>  extern void		info_init(void);
>  extern void		btheight_init(void);
>  extern void		timelimit_init(void);
> +extern void		namei_init(void);
> diff --git a/db/namei.c b/db/namei.c
> new file mode 100644
> index 00000000..eebebe15
> --- /dev/null
> +++ b/db/namei.c
> @@ -0,0 +1,223 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2021 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <djwong@kernel.org>
> + */
> +#include "libxfs.h"
> +#include "command.h"
> +#include "output.h"
> +#include "init.h"
> +#include "io.h"
> +#include "type.h"
> +#include "input.h"
> +#include "faddr.h"
> +#include "fprint.h"
> +#include "field.h"
> +#include "inode.h"
> +
> +/* Path lookup */
> +
> +/* Key for looking up metadata inodes. */
> +struct dirpath {
> +	/* Array of string pointers. */
> +	char		**path;
> +
> +	/* Number of strings in path. */
> +	unsigned int	depth;
> +};
> +
> +static void
> +path_free(
> +	struct dirpath	*dirpath)
> +{
> +	unsigned int	i;
> +
> +	for (i = 0; i < dirpath->depth; i++)
> +		free(dirpath->path[i]);
> +	free(dirpath->path);
> +	free(dirpath);
> +}
> +
> +/* Chop a freeform string path into a structured path. */
> +static struct dirpath *
> +path_parse(
> +	const char	*path)
> +{
> +	struct dirpath	*dirpath;
> +	const char	*p = path;
> +	const char	*endp = path + strlen(path);
> +
> +	dirpath = calloc(sizeof(*dirpath), 1);
> +	if (!dirpath)
> +		return NULL;
> +
> +	while (p < endp) {
> +		char		**new_path;
> +		const char	*next_slash;
> +
> +		next_slash = strchr(p, '/');
> +		if (next_slash == p) {
> +			p++;
> +			continue;
> +		}
> +		if (!next_slash)
> +			next_slash = endp;
> +
> +		new_path = realloc(dirpath->path,
> +				(dirpath->depth + 1) * sizeof(char *));
> +		if (!new_path) {
> +			path_free(dirpath);
> +			return NULL;
> +		}
> +
> +		dirpath->path = new_path;
> +		dirpath->path[dirpath->depth] = strndup(p, next_slash - p);
> +		dirpath->depth++;
> +
> +		p = next_slash + 1;
> +	}
> +
> +	return dirpath;
> +}
> +
> +/* Given a directory and a structured path, walk the path and set the cursor. */
> +static int
> +path_navigate(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		rootino,
> +	struct dirpath		*dirpath)
> +{
> +	struct xfs_inode	*dp;
> +	xfs_ino_t		ino = rootino;
> +	unsigned int		i;
> +	int			error;
> +
> +	error = -libxfs_iget(mp, NULL, ino, 0, &dp);
> +	if (error)
> +		return error;
> +
> +	for (i = 0; i < dirpath->depth; i++) {
> +		struct xfs_name	xname = {
> +			.name	= dirpath->path[i],
> +			.len	= strlen(dirpath->path[i]),
> +		};
> +
> +		if (!S_ISDIR(VFS_I(dp)->i_mode)) {
> +			error = ENOTDIR;
> +			goto rele;
> +		}
> +
> +		error = -libxfs_dir_lookup(NULL, dp, &xname, &ino, NULL);
> +		if (error)
> +			goto rele;
> +		if (!xfs_verify_ino(mp, ino)) {
> +			error = EFSCORRUPTED;
> +			goto rele;
> +		}
> +
> +		libxfs_irele(dp);
> +		dp = NULL;
> +
> +		error = -libxfs_iget(mp, NULL, ino, 0, &dp);
> +		switch (error) {
> +		case EFSCORRUPTED:
> +		case EFSBADCRC:
> +		case 0:
> +			break;
> +		default:
> +			return error;
> +		}
> +	}
> +
> +	set_cur_inode(ino);
> +rele:
> +	if (dp)
> +		libxfs_irele(dp);
> +	return error;
> +}
> +
> +/* Walk a directory path to an inode and set the io cursor to that inode. */
> +static int
> +path_walk(
> +	char		*path)
> +{
> +	struct dirpath	*dirpath;
> +	char		*p = path;
> +	xfs_ino_t	rootino = mp->m_sb.sb_rootino;
> +	int		error = 0;
> +
> +	if (*p == '/') {
> +		/* Absolute path, start from the root inode. */
> +		p++;
> +	} else {
> +		/* Relative path, start from current dir. */
> +		if (iocur_top->typ != &typtab[TYP_INODE] ||
> +		    !S_ISDIR(iocur_top->mode))
> +			return ENOTDIR;
> +
> +		rootino = iocur_top->ino;
> +	}
> +
> +	dirpath = path_parse(p);
> +	if (!dirpath)
> +		return ENOMEM;
> +
> +	error = path_navigate(mp, rootino, dirpath);
> +	if (error)
> +		return error;

Memory pointed by dirpath (and its members) is not freed if the call to
path_navigate() returns a non-zero error value.

> +
> +	path_free(dirpath);
> +	return 0;
> +}
> +
> +static void
> +path_help(void)
> +{
> +	dbprintf(_(
> +"\n"
> +" Navigate to an inode via directory path.\n"
> +	));
> +}
> +
> +static int
> +path_f(
> +	int		argc,
> +	char		**argv)
> +{
> +	int		c;
> +	int		error;
> +
> +	while ((c = getopt(argc, argv, "")) != -1) {
> +		switch (c) {
> +		default:
> +			path_help();
> +			return 0;
> +		}
> +	}
> +
> +	error = path_walk(argv[optind]);
> +	if (error) {
> +		dbprintf("%s: %s\n", argv[optind], strerror(error));
> +		exitcode = 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct cmdinfo path_cmd = {
> +	.name		= "path",
> +	.altname	= NULL,
> +	.cfunc		= path_f,
> +	.argmin		= 1,
> +	.argmax		= 1,
> +	.canpush	= 0,
> +	.args		= "",
> +	.help		= path_help,
> +};
> +
> +void
> +namei_init(void)
> +{
> +	path_cmd.oneline = _("navigate to an inode by path");
> +	add_command(&path_cmd);
> +}
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 55388be6..4df265ec 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -831,6 +831,10 @@ See the
>  .B print
>  command.
>  .TP
> +.BI "path " dir_path
> +Walk the directory tree to an inode using the supplied path.
> +Absolute and relative paths are supported.
> +.TP
>  .B pop
>  Pop location from the stack.
>  .TP


--
chandan
