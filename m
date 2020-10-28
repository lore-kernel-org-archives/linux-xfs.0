Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596D4C4363A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A4172064C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgJ1Vsb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:48:31 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:56402 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727828AbgJ1Vsa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:48:30 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5873658C599;
        Wed, 28 Oct 2020 12:27:04 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kXaEx-005431-Eh; Wed, 28 Oct 2020 12:27:03 +1100
Date:   Wed, 28 Oct 2020 12:27:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_db: add an ls command
Message-ID: <20201028012703.GA7391@dread.disaster.area>
References: <160375514873.880118.10145241423813965771.stgit@magnolia>
 <160375516100.880118.14555322605178437533.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375516100.880118.14555322605178437533.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=RXP_zP5u0uVEFUwKNq4A:9 a=UaMI6QF61Q7ME9Dh:21 a=XaoduWK0L3oULcm0:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:32:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add to xfs_db the ability to list a directory.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/namei.c               |  380 ++++++++++++++++++++++++++++++++++++++++++++++
>  libxfs/libxfs_api_defs.h |    1 
>  man/man8/xfs_db.8        |   14 ++
>  3 files changed, 395 insertions(+)
> 
> 
> diff --git a/db/namei.c b/db/namei.c
> index 3c9889d62338..b2c036e6777a 100644
> --- a/db/namei.c
> +++ b/db/namei.c
> @@ -221,8 +221,388 @@ static const cmdinfo_t path_cmd = {
>  	.help		= path_help,
>  };
>  
> +/* List a directory's entries. */
> +
> +static const char *filetype_strings[XFS_DIR3_FT_MAX] = {
> +	[XFS_DIR3_FT_UNKNOWN]	= N_("unknown"),
> +	[XFS_DIR3_FT_REG_FILE]	= N_("regular"),
> +	[XFS_DIR3_FT_DIR]	= N_("directory"),
> +	[XFS_DIR3_FT_CHRDEV]	= N_("chardev"),
> +	[XFS_DIR3_FT_BLKDEV]	= N_("blkdev"),
> +	[XFS_DIR3_FT_FIFO]	= N_("fifo"),
> +	[XFS_DIR3_FT_SOCK]	= N_("socket"),
> +	[XFS_DIR3_FT_SYMLINK]	= N_("symlink"),
> +	[XFS_DIR3_FT_WHT]	= N_("whiteout"),
> +};

What does N_() do that is different to _()?

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
> +	dbprintf("%-18llu %-14s 0x%08llx %3d %s", ino, dstr, hash, xname.len,
> +			display_name);
> +	if (!good)
> +		dbprintf(_(" (corrupt)"));
> +	dbprintf("\n");

Can we get this to emit the directory offset of the entry as well?
Also, can this be done as a single dbprintf call like this?

	dbprintf(%-18llu %-14s 0x%08llx %3d %s %s\n",
		ino, dstr, hash, xname.len, display_name,
		good ? _("(good)") : _("(corrupt)"));

(there will be lots of output on big directories....)

> +static int
> +list_sfdir(
> +	struct xfs_da_args		*args)
> +{
> +	struct xfs_inode		*dp = args->dp;
> +	struct xfs_mount		*mp = dp->i_mount;
> +	struct xfs_dir2_sf_entry	*sfep;
> +	struct xfs_dir2_sf_hdr		*sfp;
> +	xfs_ino_t			ino;
> +	unsigned int			i;
> +	uint8_t				filetype;
> +
> +	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
> +
> +	/* . and .. entries */
> +	dir_emit(args->dp->i_mount, ".", -1, dp->i_ino, XFS_DIR3_FT_DIR);
> +
> +	ino = libxfs_dir2_sf_get_parent_ino(sfp);
> +	dir_emit(args->dp->i_mount, "..", -1, ino, XFS_DIR3_FT_DIR);
> +
> +	/* Walk everything else. */
> +	sfep = xfs_dir2_sf_firstentry(sfp);
> +	for (i = 0; i < sfp->count; i++) {
> +		ino = libxfs_dir2_sf_get_ino(mp, sfp, sfep);
> +		filetype = libxfs_dir2_sf_get_ftype(mp, sfep);
> +
> +		dir_emit(args->dp->i_mount, (char *)sfep->name, sfep->namelen,
> +				ino, filetype);
> +		sfep = libxfs_dir2_sf_nextentry(mp, sfp, sfep);
> +	}
> +
> +	return 0;
> +}

Hmmm - how much of the xfs_readdir() implementation from the kernel
does this duplicate? It doesn't contain the seek cookie stuff, but
otherwise it's almost identical, right?

[....]

> +/* If the io cursor points to a directory, list its contents. */
> +static int
> +ls_cur(
> +	char			*tag,
> +	bool			direct)

I find the name "direct" rather confusing here. according to
the help below, it will be true when we want to "list the directory
itself, not it's contents"....


> +{
> +	struct xfs_inode	*dp;
> +	int			ret = 0;
> +
> +	if (iocur_top->typ != &typtab[TYP_INODE]) {
> +		dbprintf(_("current object is not an inode.\n"));
> +		return -1;
> +	}
> +
> +	ret = -libxfs_iget(mp, NULL, iocur_top->ino, 0, &dp);
> +	if (ret) {
> +		dbprintf(_("failed to iget directory %llu, error %d\n"),
> +				(unsigned long long)iocur_top->ino, ret);
> +		return -1;
> +	}
> +
> +	if (S_ISDIR(VFS_I(dp)->i_mode) && !direct) {
> +		/* List the contents of a directory. */
> +		if (tag)
> +			dbprintf(_("%s:\n"), tag);
> +
> +		ret = listdir(dp);
> +		if (ret) {
> +			dbprintf(_("failed to list directory %llu: %s\n"),
> +					(unsigned long long)iocur_top->ino,
> +					strerror(ret));
> +			ret = -1;
> +			goto rele;
> +		}
> +	} else if (direct || !S_ISDIR(VFS_I(dp)->i_mode)) {
> +		/* List the directory entry associated with a single file. */
> +		char		inum[32];
> +
> +		if (!tag) {
> +			snprintf(inum, sizeof(inum), "<%llu>",
> +					(unsigned long long)iocur_top->ino);
> +			tag = inum;
> +		} else {
> +			char	*p = strrchr(tag, '/');
> +
> +			if (p)
> +				tag = p + 1;
> +		}
> +
> +		dir_emit(mp, tag, -1, iocur_top->ino,
> +				libxfs_mode_to_ftype(VFS_I(dp)->i_mode));

I'm not sure what this is supposed to do - we turn the current inode
if it's not a directory into a -directory entry- without actually
know it's name? And we can pass in an inode that isn't a directory
and do the same? This doesn't make a huge amount of sense to me - it
tries to display the inode number as a dirent?

> +	} else {
> +		dbprintf(_("current inode %llu is not a directory.\n"),
> +				(unsigned long long)iocur_top->ino);
> +		ret = -1;
> +		goto rele;
> +	}

I don't think we can get to this else branch. If we don't take the
first branch (dir && !direct), the either we are not a dir or direct
is set. The second branch will then be taken if we are not a dir or
direct is set....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
