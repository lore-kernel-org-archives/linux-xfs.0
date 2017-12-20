Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47810 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753414AbdLTDBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 22:01:16 -0500
Date: Tue, 19 Dec 2017 19:01:12 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/7] mkfs: remove logarithm based CLI options
Message-ID: <20171220030111.GO12613@magnolia>
References: <20171218091158.14537-1-david@fromorbit.com>
 <20171218091158.14537-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171218091158.14537-8-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 18, 2017 at 08:11:58PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Very few people use the log2 based size options for various mkfs
> parameters and they just clutter up the code. Get rid of them.

Maybe we should deprecate them for at least one release instead of
just hard breaking everyone's scripts?

--D

> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 150 ++++----------------------------------------------------
>  1 file changed, 10 insertions(+), 140 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index b8752965c6d7..e66e34311a74 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -51,8 +51,7 @@ unsigned int		sectorsize;
>   * maximum array size needed to hold them automatically.
>   */
>  enum {
> -	B_LOG = 0,
> -	B_SIZE,
> +	B_SIZE = 0,
>  	B_MAX_OPTS,
>  };
>  
> @@ -66,7 +65,6 @@ enum {
>  	D_AGSIZE,
>  	D_SU,
>  	D_SW,
> -	D_SECTLOG,
>  	D_SECTSIZE,
>  	D_NOALIGN,
>  	D_RTINHERIT,
> @@ -78,7 +76,6 @@ enum {
>  
>  enum {
>  	I_ALIGN = 0,
> -	I_LOG,
>  	I_MAXPCT,
>  	I_PERBLOCK,
>  	I_SIZE,
> @@ -96,7 +93,6 @@ enum {
>  	L_SUNIT,
>  	L_SU,
>  	L_DEV,
> -	L_SECTLOG,
>  	L_SECTSIZE,
>  	L_FILE,
>  	L_NAME,
> @@ -105,8 +101,7 @@ enum {
>  };
>  
>  enum {
> -	N_LOG = 0,
> -	N_SIZE,
> +	N_SIZE = 0,
>  	N_VERSION,
>  	N_FTYPE,
>  	N_MAX_OPTS,
> @@ -123,9 +118,7 @@ enum {
>  };
>  
>  enum {
> -	S_LOG = 0,
> -	S_SECTLOG,
> -	S_SIZE,
> +	S_SIZE = 0,
>  	S_SECTSIZE,
>  	S_MAX_OPTS,
>  };
> @@ -240,22 +233,13 @@ extern struct opt_params sopts;
>  struct opt_params bopts = {
>  	.name = 'b',
>  	.subopts = {
> -		[B_LOG] = "log",
>  		[B_SIZE] = "size",
>  	},
>  	.subopt_params = {
> -		{ .index = B_LOG,
> -		  .conflicts = { { &bopts, B_SIZE },
> -				 { &bopts, LAST_CONFLICT } },
> -		  .minval = XFS_MIN_BLOCKSIZE_LOG,
> -		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> -		},
>  		{ .index = B_SIZE,
>  		  .convert = true,
>  		  .is_power_2 = true,
> -		  .conflicts = { { &bopts, B_LOG },
> -				 { &bopts, LAST_CONFLICT } },
> +		  .conflicts = { { &bopts, LAST_CONFLICT } },
>  		  .minval = XFS_MIN_BLOCKSIZE,
>  		  .maxval = XFS_MAX_BLOCKSIZE,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
> @@ -275,7 +259,6 @@ struct opt_params dopts = {
>  		[D_AGSIZE] = "agsize",
>  		[D_SU] = "su",
>  		[D_SW] = "sw",
> -		[D_SECTLOG] = "sectlog",
>  		[D_SECTSIZE] = "sectsize",
>  		[D_NOALIGN] = "noalign",
>  		[D_RTINHERIT] = "rtinherit",
> @@ -353,23 +336,9 @@ struct opt_params dopts = {
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
> -		{ .index = D_SECTLOG,
> -		  .conflicts = { { &dopts, D_SECTSIZE },
> -				 { &sopts, S_SIZE },
> -				 { &sopts, S_SECTSIZE },
> -				 { &sopts, S_LOG },
> -				 { &sopts, S_SECTLOG },
> -				 { &dopts, LAST_CONFLICT } },
> -		  .minval = XFS_MIN_SECTORSIZE_LOG,
> -		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> -		},
>  		{ .index = D_SECTSIZE,
> -		  .conflicts = { { &dopts, D_SECTLOG },
> -				 { &sopts, S_SIZE },
> +		  .conflicts = { { &sopts, S_SIZE },
>  				 { &sopts, S_SECTSIZE },
> -				 { &sopts, S_LOG },
> -				 { &sopts, S_SECTLOG },
>  				 { &dopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .is_power_2 = true,
> @@ -419,7 +388,6 @@ struct opt_params iopts = {
>  	.name = 'i',
>  	.subopts = {
>  		[I_ALIGN] = "align",
> -		[I_LOG] = "log",
>  		[I_MAXPCT] = "maxpct",
>  		[I_PERBLOCK] = "perblock",
>  		[I_SIZE] = "size",
> @@ -434,14 +402,6 @@ struct opt_params iopts = {
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
> -		{ .index = I_LOG,
> -		  .conflicts = { { &iopts, I_PERBLOCK },
> -				 { &iopts, I_SIZE },
> -				 { &iopts, LAST_CONFLICT } },
> -		  .minval = XFS_DINODE_MIN_LOG,
> -		  .maxval = XFS_DINODE_MAX_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> -		},
>  		{ .index = I_MAXPCT,
>  		  .conflicts = { { &iopts, LAST_CONFLICT } },
>  		  .minval = 0,
> @@ -449,8 +409,7 @@ struct opt_params iopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_PERBLOCK,
> -		  .conflicts = { { &iopts, I_LOG },
> -				 { &iopts, I_SIZE },
> +		  .conflicts = { { &iopts, I_SIZE },
>  				 { &iopts, LAST_CONFLICT } },
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_INODE_PERBLOCK,
> @@ -459,7 +418,6 @@ struct opt_params iopts = {
>  		},
>  		{ .index = I_SIZE,
>  		  .conflicts = { { &iopts, I_PERBLOCK },
> -				 { &iopts, I_LOG },
>  				 { &iopts, LAST_CONFLICT } },
>  		  .is_power_2 = true,
>  		  .minval = XFS_DINODE_MIN_SIZE,
> @@ -497,7 +455,6 @@ struct opt_params lopts = {
>  		[L_SUNIT] = "sunit",
>  		[L_SU] = "su",
>  		[L_DEV] = "logdev",
> -		[L_SECTLOG] = "sectlog",
>  		[L_SECTSIZE] = "sectsize",
>  		[L_FILE] = "file",
>  		[L_NAME] = "name",
> @@ -514,7 +471,6 @@ struct opt_params lopts = {
>  		{ .index = L_INTERNAL,
>  		  .conflicts = { { &lopts, L_FILE },
>  				 { &lopts, L_DEV },
> -				 { &lopts, L_SECTLOG },
>  				 { &lopts, L_SECTSIZE },
>  				 { &lopts, LAST_CONFLICT } },
>  		  .minval = 0,
> @@ -555,17 +511,8 @@ struct opt_params lopts = {
>  				 { &lopts, LAST_CONFLICT } },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
> -		{ .index = L_SECTLOG,
> -		  .conflicts = { { &lopts, L_SECTSIZE },
> -				 { &lopts, L_INTERNAL },
> -				 { &lopts, LAST_CONFLICT } },
> -		  .minval = XFS_MIN_SECTORSIZE_LOG,
> -		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> -		},
>  		{ .index = L_SECTSIZE,
> -		  .conflicts = { { &lopts, L_SECTLOG },
> -				 { &lopts, L_INTERNAL },
> +		  .conflicts = { { &lopts, L_INTERNAL },
>  				 { &lopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .is_power_2 = true,
> @@ -598,22 +545,13 @@ struct opt_params lopts = {
>  struct opt_params nopts = {
>  	.name = 'n',
>  	.subopts = {
> -		[N_LOG] = "log",
>  		[N_SIZE] = "size",
>  		[N_VERSION] = "version",
>  		[N_FTYPE] = "ftype",
>  	},
>  	.subopt_params = {
> -		{ .index = N_LOG,
> -		  .conflicts = { { &nopts, N_SIZE },
> -				 { &nopts, LAST_CONFLICT } },
> -		  .minval = XFS_MIN_REC_DIRSIZE,
> -		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> -		},
>  		{ .index = N_SIZE,
> -		  .conflicts = { { &nopts, N_LOG },
> -				 { &nopts, LAST_CONFLICT } },
> +		  .conflicts = { { &nopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .is_power_2 = true,
>  		  .minval = 1 << XFS_MIN_REC_DIRSIZE,
> @@ -686,40 +624,13 @@ struct opt_params ropts = {
>  struct opt_params sopts = {
>  	.name = 's',
>  	.subopts = {
> -		[S_LOG] = "log",
> -		[S_SECTLOG] = "sectlog",
>  		[S_SIZE] = "size",
>  		[S_SECTSIZE] = "sectsize",
>  	},
>  	.subopt_params = {
> -		{ .index = S_LOG,
> -		  .conflicts = { { &sopts, S_SIZE },
> -				 { &sopts, S_SECTSIZE },
> -				 { &sopts, S_SECTLOG },
> -				 { &dopts, D_SECTSIZE },
> -				 { &dopts, D_SECTLOG },
> -				 { &sopts, LAST_CONFLICT } },
> -		  .minval = XFS_MIN_SECTORSIZE_LOG,
> -		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> -		},
> -		{ .index = S_SECTLOG,
> -		  .conflicts = { { &sopts, S_SIZE },
> -				 { &sopts, S_SECTSIZE },
> -				 { &sopts, S_LOG },
> -				 { &dopts, D_SECTSIZE },
> -				 { &dopts, D_SECTLOG },
> -				 { &sopts, LAST_CONFLICT } },
> -		  .minval = XFS_MIN_SECTORSIZE_LOG,
> -		  .maxval = XFS_MAX_SECTORSIZE_LOG,
> -		  .defaultval = SUBOPT_NEEDS_VAL,
> -		},
>  		{ .index = S_SIZE,
> -		  .conflicts = { { &sopts, S_LOG },
> -				 { &sopts, S_SECTLOG },
> -				 { &sopts, S_SECTSIZE },
> +		  .conflicts = { { &sopts, S_SECTSIZE },
>  				 { &dopts, D_SECTSIZE },
> -				 { &dopts, D_SECTLOG },
>  				 { &sopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .is_power_2 = true,
> @@ -728,11 +639,8 @@ struct opt_params sopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = S_SECTSIZE,
> -		  .conflicts = { { &sopts, S_LOG },
> -				 { &sopts, S_SECTLOG },
> -				 { &sopts, S_SIZE },
> +		  .conflicts = { { &sopts, S_SIZE },
>  				 { &dopts, D_SECTSIZE },
> -				 { &dopts, D_SECTLOG },
>  				 { &sopts, LAST_CONFLICT } },
>  		  .convert = true,
>  		  .is_power_2 = true,
> @@ -860,7 +768,6 @@ struct cli_params {
>  
>  	/* parameters where 0 is not a valid value */
>  	int64_t	agcount;
> -	int	dirblocklog;
>  	int	inodesize;
>  	int	inopblock;
>  	int	imaxpct;
> @@ -1493,13 +1400,7 @@ block_opts_parser(
>  	char			*value,
>  	struct cli_params	*cli)
>  {
> -	int			blocklog;
> -
>  	switch (subopt) {
> -	case B_LOG:
> -		blocklog = getnum(value, opts, B_LOG);
> -		cli->blocksize = 1 << blocklog;
> -		break;
>  	case B_SIZE:
>  		cli->blocksize = getnum(value, opts, B_SIZE);
>  		break;
> @@ -1516,8 +1417,6 @@ data_opts_parser(
>  	char			*value,
>  	struct cli_params	*cli)
>  {
> -	int			sectorlog;
> -
>  	switch (subopt) {
>  	case D_AGCOUNT:
>  		cli->agcount = getnum(value, opts, D_AGCOUNT);
> @@ -1549,10 +1448,6 @@ data_opts_parser(
>  	case D_NOALIGN:
>  		cli->sb_feat.nodalign = getnum(value, opts, D_NOALIGN);
>  		break;
> -	case D_SECTLOG:
> -		sectorlog = getnum(value, opts, D_SECTLOG);
> -		cli->sectorsize = 1 << sectorlog;
> -		break;
>  	case D_SECTSIZE:
>  		cli->sectorsize = getnum(value, opts, D_SECTSIZE);
>  		break;
> @@ -1585,16 +1480,10 @@ inode_opts_parser(
>  	char			*value,
>  	struct cli_params	*cli)
>  {
> -	int			inodelog;
> -
>  	switch (subopt) {
>  	case I_ALIGN:
>  		cli->sb_feat.inode_align = getnum(value, opts, I_ALIGN);
>  		break;
> -	case I_LOG:
> -		inodelog = getnum(value, opts, I_LOG);
> -		cli->inodesize = 1 << inodelog;
> -		break;
>  	case I_MAXPCT:
>  		cli->imaxpct = getnum(value, opts, I_MAXPCT);
>  		break;
> @@ -1626,8 +1515,6 @@ log_opts_parser(
>  	char			*value,
>  	struct cli_params	*cli)
>  {
> -	int			lsectorlog;
> -
>  	switch (subopt) {
>  	case L_AGNUM:
>  		cli->logagno = getnum(value, opts, L_AGNUM);
> @@ -1655,10 +1542,6 @@ log_opts_parser(
>  	case L_SIZE:
>  		cli->logsize = getstr(value, opts, L_SIZE);
>  		break;
> -	case L_SECTLOG:
> -		lsectorlog = getnum(value, opts, L_SECTLOG);
> -		cli->lsectorsize = 1 << lsectorlog;
> -		break;
>  	case L_SECTSIZE:
>  		cli->lsectorsize = getnum(value, opts, L_SECTSIZE);
>  		break;
> @@ -1713,9 +1596,6 @@ naming_opts_parser(
>  	struct cli_params	*cli)
>  {
>  	switch (subopt) {
> -	case N_LOG:
> -		cli->dirblocklog = getnum(value, opts, N_LOG);
> -		break;
>  	case N_SIZE:
>  		cli->dirblocksize = getstr(value, opts, N_SIZE);
>  		break;
> @@ -1774,15 +1654,7 @@ sector_opts_parser(
>  	char			*value,
>  	struct cli_params	*cli)
>  {
> -	int			sectorlog;
> -
>  	switch (subopt) {
> -	case S_LOG:
> -	case S_SECTLOG:
> -		sectorlog = getnum(value, opts, subopt);
> -		cli->sectorsize = 1 << sectorlog;
> -		cli->lsectorsize = cli->sectorsize;
> -		break;
>  	case S_SIZE:
>  	case S_SECTSIZE:
>  		cli->sectorsize = getnum(value, opts, subopt);
> @@ -2172,8 +2044,6 @@ validate_dirblocksize(
>  
>  	if (cli->dirblocksize)
>  		cfg->dirblocksize = getnum(cli->dirblocksize, &nopts, N_SIZE);
> -	if (cli->dirblocklog)
> -		cfg->dirblocksize = 1 << cli->dirblocklog;
>  
>  	if (cfg->dirblocksize) {
>  		if (cfg->dirblocksize < cfg->blocksize ||
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
