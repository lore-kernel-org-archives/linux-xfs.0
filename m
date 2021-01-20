Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93664C4332D
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 15:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 604DA23381
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 15:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390295AbhATPcI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 10:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390896AbhATPZ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jan 2021 10:25:27 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15336C0613D3
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jan 2021 07:24:47 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id b8so12668415plh.12
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jan 2021 07:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=7vaul3PodGiyZwNzXqMQ+0lOzuzFPrqhj11svpaD64o=;
        b=FKKynedtAzv9WCE77Q9A96WQzCfCI8lwqhMNvb+YD/C6VRP656FW2miBejrjF10UXq
         SBP9O9zpHI9VpfFASecY5/bvUwA+3G4SkB4RS8CopABf77WPgSdZPbR3oOB5VK52aXcm
         5q44tK90OHLljpEyK7wUnczeUKNlaTTuwITawHSNKAg9EEQ9sApsDqx1ZWmhQZLSGh3Q
         7wl3k3MV9UtYNg5zxGy5dLsMizX6PVcbhhLHj6W/5vgsnhOz8vQzds9YNPXaUmNJMChj
         kIj3xRk9Ak7EHsJ72o9AIksfQ+TVbz0+221MJd8Z1WKwTPJce8C/qPJagwoL/NKGyWFp
         MR4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=7vaul3PodGiyZwNzXqMQ+0lOzuzFPrqhj11svpaD64o=;
        b=SAZdh34DKDjJlnBR7rKzH++ApxoD+Ylc3ybK5nFhHnpMByOk8dyy5EZhaIQnLGLebc
         zm1nDar05Zz8Lu2uzeej9DycxawXc6w160rg9mkWdFkWgTgvDDhAGqcjX2VAc273OyE1
         PrIkUSQDzgMR8MKIi6tpqV6PX8jmtxFLa3RWjqcgwLhwqalX3/WX+hhWZqIbI5HMQ/Fb
         t58GW6aEs1SuiGU42mHCb1Oh5FvWO3/gjz0CD/Ohm4RW1kdsPQo1l3jt0oA50IcHT39N
         u+ZS2EQ4drAQtcrEVBJI+qVmMHh/K6nswHXoyljoC9kvUiBHvL1edv3Gw6cO0nZBFnxb
         q76A==
X-Gm-Message-State: AOAM530MEI29JcQY5MuQIS5Ug87qwh3KOHZve32m+lOhAdk1BryQF3Tn
        uIMbiWDSJvkTzf0vqDLVJbqJxX91wfA=
X-Google-Smtp-Source: ABdhPJzOzpMLL54NmBbbMKO4cM2g0kW6+1cbWqpwUCSySdboqUAFmwKmU/U45CHEHM6B4D33y5K7jg==
X-Received: by 2002:a17:903:230b:b029:dd:7cf1:8c33 with SMTP id d11-20020a170903230bb02900dd7cf18c33mr10384011plh.31.1611156286277;
        Wed, 20 Jan 2021 07:24:46 -0800 (PST)
Received: from garuda ([122.171.200.115])
        by smtp.gmail.com with ESMTPSA id h11sm2707869pjg.46.2021.01.20.07.24.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Jan 2021 07:24:45 -0800 (PST)
References: <161076026570.3386403.8299786881687962135.stgit@magnolia> <161076027792.3386403.5440822079722465061.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: add an ls command
In-reply-to: <161076027792.3386403.5440822079722465061.stgit@magnolia>
Date:   Wed, 20 Jan 2021 20:54:42 +0530
Message-ID: <87im7r1vid.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 16 Jan 2021 at 06:54, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Add to xfs_db the ability to list a directory.
>

W.r.t logical correctness of the code,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  db/namei.c               |  389 ++++++++++++++++++++++++++++++++++++++++++++++
>  libxfs/libxfs_api_defs.h |    1 
>  man/man8/xfs_db.8        |   16 ++
>  3 files changed, 406 insertions(+)
>
>
> diff --git a/db/namei.c b/db/namei.c
> index eebebe15..e75b5ebd 100644
> --- a/db/namei.c
> +++ b/db/namei.c
> @@ -215,9 +215,398 @@ static struct cmdinfo path_cmd = {
>  	.help		= path_help,
>  };
>  
> +/* List a directory's entries. */
> +
> +static const char *filetype_strings[XFS_DIR3_FT_MAX] = {
> +	[XFS_DIR3_FT_UNKNOWN]	= "unknown",
> +	[XFS_DIR3_FT_REG_FILE]	= "regular",
> +	[XFS_DIR3_FT_DIR]	= "directory",
> +	[XFS_DIR3_FT_CHRDEV]	= "chardev",
> +	[XFS_DIR3_FT_BLKDEV]	= "blkdev",
> +	[XFS_DIR3_FT_FIFO]	= "fifo",
> +	[XFS_DIR3_FT_SOCK]	= "socket",
> +	[XFS_DIR3_FT_SYMLINK]	= "symlink",
> +	[XFS_DIR3_FT_WHT]	= "whiteout",
> +};
> +
> +static const char *
> +get_dstr(
> +	struct xfs_mount	*mp,
> +	uint8_t			filetype)
> +{
> +	if (!xfs_sb_version_hasftype(&mp->m_sb))
> +		return filetype_strings[XFS_DIR3_FT_UNKNOWN];
> +
> +	if (filetype >= XFS_DIR3_FT_MAX)
> +		return filetype_strings[XFS_DIR3_FT_UNKNOWN];
> +
> +	return filetype_strings[filetype];
> +}
> +
> +static void
> +dir_emit(
> +	struct xfs_mount	*mp,
> +	xfs_dir2_dataptr_t	off,
> +	char			*name,
> +	ssize_t			namelen,
> +	xfs_ino_t		ino,
> +	uint8_t			dtype)
> +{
> +	char			*display_name;
> +	struct xfs_name		xname = { .name = name };
> +	const char		*dstr = get_dstr(mp, dtype);
> +	xfs_dahash_t		hash;
> +	bool			good;
> +
> +	if (namelen < 0) {
> +		/* Negative length means that name is null-terminated. */
> +		display_name = name;
> +		xname.len = strlen(name);
> +		good = true;
> +	} else {
> +		/*
> +		 * Otherwise, name came from a directory entry, so we have to
> +		 * copy the string to a buffer so that we can add the null
> +		 * terminator.
> +		 */
> +		display_name = malloc(namelen + 1);
> +		memcpy(display_name, name, namelen);
> +		display_name[namelen] = 0;
> +		xname.len = namelen;
> +		good = libxfs_dir2_namecheck(name, namelen);
> +	}
> +	hash = libxfs_dir2_hashname(mp, &xname);
> +
> +	dbprintf("%-10u %-18llu %-14s 0x%08llx %3d %s %s\n", off & 0xFFFFFFFF,
> +			ino, dstr, hash, xname.len,
> +			display_name, good ? _("(good)") : _("(corrupt)"));
> +
> +	if (display_name != name)
> +		free(display_name);
> +}
> +
> +static int
> +list_sfdir(
> +	struct xfs_da_args		*args)
> +{
> +	struct xfs_inode		*dp = args->dp;
> +	struct xfs_mount		*mp = dp->i_mount;
> +	struct xfs_da_geometry		*geo = args->geo;
> +	struct xfs_dir2_sf_entry	*sfep;
> +	struct xfs_dir2_sf_hdr		*sfp;
> +	xfs_ino_t			ino;
> +	xfs_dir2_dataptr_t		off;
> +	unsigned int			i;
> +	uint8_t				filetype;
> +
> +	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
> +
> +	/* . and .. entries */
> +	off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
> +			geo->data_entry_offset);
> +	dir_emit(args->dp->i_mount, off, ".", -1, dp->i_ino, XFS_DIR3_FT_DIR);
> +
> +	ino = libxfs_dir2_sf_get_parent_ino(sfp);
> +	off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
> +			geo->data_entry_offset +
> +			libxfs_dir2_data_entsize(mp, sizeof(".") - 1));
> +	dir_emit(args->dp->i_mount, off, "..", -1, ino, XFS_DIR3_FT_DIR);
> +
> +	/* Walk everything else. */
> +	sfep = xfs_dir2_sf_firstentry(sfp);
> +	for (i = 0; i < sfp->count; i++) {
> +		ino = libxfs_dir2_sf_get_ino(mp, sfp, sfep);
> +		filetype = libxfs_dir2_sf_get_ftype(mp, sfep);
> +		off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
> +				xfs_dir2_sf_get_offset(sfep));
> +
> +		dir_emit(args->dp->i_mount, off, (char *)sfep->name,
> +				sfep->namelen, ino, filetype);
> +		sfep = libxfs_dir2_sf_nextentry(mp, sfp, sfep);
> +	}
> +
> +	return 0;
> +}
> +
> +/* List entries in block format directory. */
> +static int
> +list_blockdir(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_buf		*bp;
> +	struct xfs_da_geometry	*geo = mp->m_dir_geo;
> +	xfs_dir2_dataptr_t	diroff;
> +	unsigned int		offset;
> +	unsigned int		end;
> +	int			error;
> +
> +	error = xfs_dir3_block_read(NULL, dp, &bp);
> +	if (error)
> +		return error;
> +
> +	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
> +	for (offset = geo->data_entry_offset; offset < end;) {
> +		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
> +		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
> +		uint8_t				filetype;
> +
> +		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
> +			/* Unused entry */
> +			offset += be16_to_cpu(dup->length);
> +			continue;
> +		}
> +
> +		/* Real entry */
> +		diroff = xfs_dir2_db_off_to_dataptr(geo, geo->datablk, offset);
> +		offset += libxfs_dir2_data_entsize(mp, dep->namelen);
> +		filetype = libxfs_dir2_data_get_ftype(dp->i_mount, dep);
> +		dir_emit(mp, diroff, (char *)dep->name, dep->namelen,
> +				be64_to_cpu(dep->inumber), filetype);
> +	}
> +
> +	libxfs_trans_brelse(args->trans, bp);
> +	return error;
> +}
> +
> +/* List entries in leaf format directory. */
> +static int
> +list_leafdir(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_bmbt_irec	map;
> +	struct xfs_iext_cursor	icur;
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_buf		*bp = NULL;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(dp, XFS_DATA_FORK);
> +	struct xfs_da_geometry	*geo = mp->m_dir_geo;
> +	xfs_dir2_off_t		dirboff;
> +	xfs_dablk_t		dabno = 0;
> +	int			error = 0;
> +
> +	/* Read extent map. */
> +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +		error = -libxfs_iread_extents(NULL, dp, XFS_DATA_FORK);
> +		if (error)
> +			return error;
> +	}
> +
> +	while (dabno < geo->leafblk) {
> +		unsigned int	offset;
> +		unsigned int	length;
> +
> +		/* Find mapping for leaf block. */
> +		if (!xfs_iext_lookup_extent(dp, ifp, dabno, &icur, &map))
> +			break;
> +		if (map.br_startoff >= geo->leafblk)
> +			break;
> +		libxfs_trim_extent(&map, dabno, geo->leafblk - dabno);
> +
> +		/* Read the directory block of that first mapping. */
> +		error = xfs_dir3_data_read(NULL, dp, map.br_startoff, 0, &bp);
> +		if (error)
> +			break;
> +
> +		dirboff = xfs_dir2_da_to_byte(geo, map.br_startoff);
> +		for (offset = geo->data_entry_offset; offset < geo->blksize;) {
> +			struct xfs_dir2_data_entry	*dep;
> +			struct xfs_dir2_data_unused	*dup;
> +			uint8_t				filetype;
> +
> +			dup = bp->b_addr + offset;
> +			dep = bp->b_addr + offset;
> +
> +			if (be16_to_cpu(dup->freetag) ==
> +			    XFS_DIR2_DATA_FREE_TAG) {
> +				/* Skip unused entry */
> +				length = be16_to_cpu(dup->length);
> +				offset += length;
> +				continue;
> +			}
> +
> +			offset += libxfs_dir2_data_entsize(mp, dep->namelen);
> +			filetype = libxfs_dir2_data_get_ftype(mp, dep);
> +
> +			dir_emit(mp, xfs_dir2_byte_to_dataptr(dirboff + offset),
> +					(char *)dep->name, dep->namelen,
> +					be64_to_cpu(dep->inumber), filetype);
> +		}
> +
> +		dabno += XFS_DADDR_TO_FSB(mp, bp->b_length);
> +		libxfs_buf_relse(bp);
> +		bp = NULL;
> +	}
> +
> +	if (bp)
> +		libxfs_buf_relse(bp);
> +
> +	return error;
> +}
> +
> +/* Read the directory, display contents. */
> +int
> +listdir(
> +	struct xfs_inode	*dp)
> +{
> +	struct xfs_da_args	args = {
> +		.dp		= dp,
> +		.geo		= dp->i_mount->m_dir_geo,
> +	};
> +	int			error;
> +	int			isblock;
> +
> +	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
> +		return list_sfdir(&args);
> +
> +	error = -libxfs_dir2_isblock(&args, &isblock);
> +	if (error)
> +		return error;
> +
> +	if (isblock)
> +		return list_blockdir(&args);
> +	return list_leafdir(&args);
> +}
> +
> +/* List the inode number of the currently selected inode. */
> +static int
> +inum_cur(void)
> +{
> +	if (iocur_top->typ != &typtab[TYP_INODE])
> +		return ENOENT;
> +
> +	dbprintf("%llu\n", iocur_top->ino);
> +	return 0;
> +}
> +
> +/* If the io cursor points to a directory, list its contents. */
> +static int
> +ls_cur(
> +	char			*tag)
> +{
> +	struct xfs_inode	*dp;
> +	int			error = 0;
> +
> +	if (iocur_top->typ != &typtab[TYP_INODE] ||
> +	    !S_ISDIR(iocur_top->mode))
> +		return ENOTDIR;
> +
> +	error = -libxfs_iget(mp, NULL, iocur_top->ino, 0, &dp);
> +	if (error)
> +		return error;
> +
> +	if (!S_ISDIR(VFS_I(dp)->i_mode)) {
> +		error = ENOTDIR;
> +		goto rele;
> +	}
> +
> +	/* List the contents of a directory. */
> +	if (tag)
> +		dbprintf(_("%s:\n"), tag);
> +
> +	error = listdir(dp);
> +	if (error)
> +		goto rele;
> +
> +rele:
> +	libxfs_irele(dp);
> +	return error;
> +}
> +
> +static void
> +ls_help(void)
> +{
> +	dbprintf(_(
> +"\n"
> +" List the contents of the currently selected directory inode.\n"
> +"\n"
> +" Options:\n"
> +"   -i -- Resolve the given paths to their corresponding inode numbers.\n"
> +"         If no paths are given, display the current inode number.\n"
> +"\n"
> +" Directory contents will be listed in the format:\n"
> +" dir_cookie	inode_number	type	hash	name_length	name\n"
> +	));
> +}
> +
> +static int
> +ls_f(
> +	int			argc,
> +	char			**argv)
> +{
> +	bool			inum_only = false;
> +	int			c;
> +	int			error = 0;
> +
> +	while ((c = getopt(argc, argv, "i")) != -1) {
> +		switch (c) {
> +		case 'i':
> +			inum_only = true;
> +			break;
> +		default:
> +			ls_help();
> +			return 0;
> +		}
> +	}
> +
> +	if (optind == argc) {
> +		if (inum_only)
> +			error = inum_cur();
> +		else
> +			error = ls_cur(NULL);
> +		if (error) {
> +			dbprintf("%s\n", strerror(error));
> +			exitcode = 1;
> +		}
> +
> +		return 0;
> +	}
> +
> +	for (c = optind; c < argc; c++) {
> +		push_cur();
> +
> +		error = path_walk(argv[c]);
> +		if (error)
> +			goto err_cur;
> +
> +		if (inum_only)
> +			error = inum_cur();
> +		else
> +			error = ls_cur(argv[c]);
> +		if (error)
> +			goto err_cur;
> +
> +		pop_cur();
> +	}
> +
> +	return 0;
> +err_cur:
> +	pop_cur();
> +	if (error) {
> +		dbprintf("%s: %s\n", argv[c], strerror(error));
> +		exitcode = 1;
> +	}
> +	return 0;
> +}
> +
> +static struct cmdinfo ls_cmd = {
> +	.name		= "ls",
> +	.altname	= "l",
> +	.cfunc		= ls_f,
> +	.argmin		= 0,
> +	.argmax		= -1,
> +	.canpush	= 0,
> +	.args		= "[-i] [paths...]",
> +	.help		= ls_help,
> +};
> +
>  void
>  namei_init(void)
>  {
>  	path_cmd.oneline = _("navigate to an inode by path");
>  	add_command(&path_cmd);
> +
> +	ls_cmd.oneline = _("list directory contents");
> +	add_command(&ls_cmd);
>  }
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 9492955d..9a00ce66 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -190,6 +190,7 @@
>  #define xfs_trans_resv_calc		libxfs_trans_resv_calc
>  #define xfs_trans_roll_inode		libxfs_trans_roll_inode
>  #define xfs_trans_roll			libxfs_trans_roll
> +#define xfs_trim_extent			libxfs_trim_extent
>  
>  #define xfs_verify_agbno		libxfs_verify_agbno
>  #define xfs_verify_agino		libxfs_verify_agino
> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> index 4df265ec..58727495 100644
> --- a/man/man8/xfs_db.8
> +++ b/man/man8/xfs_db.8
> @@ -806,6 +806,22 @@ This makes it easier to find discrepancies in the reservation calculations
>  between xfsprogs and the kernel, which will help when diagnosing minimum
>  log size calculation errors.
>  .TP
> +.BI "ls [\-i] [" paths "]..."
> +List the contents of a directory.
> +If a path resolves to a directory, the directory will be listed.
> +If no paths are supplied and the IO cursor points at a directory inode,
> +the contents of that directory will be listed.
> +
> +The output format is:
> +directory cookie, inode number, file type, hash, name length, name.
> +.RS 1.0i
> +.TP 0.4i
> +.B \-i
> +Resolve each of the given paths to an inode number and print that number.
> +If no paths are given and the IO cursor points to an inode, print the inode
> +number.
> +.RE
> +.TP
>  .BI "metadump [\-egow] " filename
>  Dumps metadata to a file. See
>  .BR xfs_metadump (8)


-- 
chandan
