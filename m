Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6F7C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C38364F51
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 09:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhBDJkN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 04:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbhBDJkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 04:40:11 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D807C0613D6
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 01:39:31 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id t29so1749891pfg.11
        for <linux-xfs@vger.kernel.org>; Thu, 04 Feb 2021 01:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=BR3C6ObCpJnDfNt+57Sa7O7tY2cjA3Tm/TdWMaAf1VM=;
        b=aZhDB0m2PFlVuQZv9PtuKzM0A+YfkjLgT9uqZklXh90V52c5Rl+lBy8esQjDld2+4R
         No6T/qk8Cyk5r7G+N1jIV3Zj5zxylYGP02Wf3t1GdkW3Im4m+3oa7z6u3f8SOTTR/YkP
         D0FLIMD5aZ+Z6Ky/ci9yeHW8Bb5m5KLu5HkbfrTtp3GGDnHHYrip48JfV64MHlY0lR0i
         VS47otR3AFRwm1CuK0rADYGKFEeM7lR7PsDAtuKjRjsktSF6rcjxhDDIXhJaG8ZxxbJv
         HERRYNuF8hlf+DoRGsNJ19zf+bOTBRYIXgVjKNs0ym5pGhr/J64Abk4q6SPabI4NTNCd
         7SZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=BR3C6ObCpJnDfNt+57Sa7O7tY2cjA3Tm/TdWMaAf1VM=;
        b=Gv4/jcXk0UqZRPc0dPIzNwLy+KtmCdFss0hooFpwWpncocAy9x+DfcUu0e3x1oDhsf
         3pA3JdtodwpZN7R0fBrOQpEF4sf+ffqGlrmFMLQyyJjmkXcXrjReyruBwpNh30ox4859
         ikJP1Cek3mrUMK72ZIii5yGxRLoYLzkH7sj7GIDl0ieieHE8Kbv83+O+AYSH7qS3Lhtk
         7WJRBBXJOFeCYajOB/jTJKlwylebr5veDGIDB/MR9yirmDHCMAPygActPvCc2bxbfYtd
         GH3ut+iKUInEtSP/vgv25ThfP6CUMSQyXdW7gTmdMcYHeo7mZeCUqIiL3qhokxaLffkO
         WBbA==
X-Gm-Message-State: AOAM532KwWu0QduWwwboPRTioUyqf77e5i0qh9evRfQcysPbGbZbUhP9
        84gVUFsI552u7THNPvgmH54=
X-Google-Smtp-Source: ABdhPJyrFJk0NZ7dHtLJlKhewaEUkqn5PzcG/1GprUMgWVAIJXToVDwYYaYU+rv3sEsWk7v1xAHx4w==
X-Received: by 2002:aa7:9a48:0:b029:1b7:bb17:38c9 with SMTP id x8-20020aa79a480000b02901b7bb1738c9mr7438219pfj.51.1612431570613;
        Thu, 04 Feb 2021 01:39:30 -0800 (PST)
Received: from garuda ([122.167.153.206])
        by smtp.gmail.com with ESMTPSA id a19sm4813194pff.186.2021.02.04.01.39.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Feb 2021 01:39:30 -0800 (PST)
References: <161238137774.1278216.17346983364750025070.stgit@magnolia> <161238138376.1278216.8359405119101341154.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        chandanrlinux@gmail.com
Subject: Re: [PATCH 1/2] xfs_db: add a directory path lookup command
In-reply-to: <161238138376.1278216.8359405119101341154.stgit@magnolia>
Date:   Thu, 04 Feb 2021 15:09:27 +0530
Message-ID: <87r1lww4s0.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 04 Feb 2021 at 01:13, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Add a command to xfs_db so that we can navigate to inodes by path.

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  db/Makefile       |    3 -
>  db/command.c      |    1 
>  db/command.h      |    1 
>  db/namei.c        |  220 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  man/man8/xfs_db.8 |    4 +
>  5 files changed, 228 insertions(+), 1 deletion(-)
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
> index 00000000..6fddbc4a
> --- /dev/null
> +++ b/db/namei.c
> @@ -0,0 +1,220 @@
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
> +	path_free(dirpath);
> +	return error;
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
