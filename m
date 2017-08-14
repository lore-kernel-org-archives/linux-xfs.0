Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36924 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752643AbdHNXeZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 19:34:25 -0400
Date: Mon, 14 Aug 2017 16:34:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/6] mkfs: replace variables with opts table: -l options
Message-ID: <20170814233419.GN4796@magnolia>
References: <20170811123058.16061-1-jtulak@redhat.com>
 <20170811123058.16061-5-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811123058.16061-5-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 11, 2017 at 02:30:56PM +0200, Jan Tulak wrote:
> Remove variables that can be replaced with a direct access to the opts
> table, so we have it all in a single place, accessible from anywhere.
> 
> In future, we can remove some instances where we are passing values as
> arguments to helper functions, when we have the values in the opts
> struct and could pass only the struct.  But for now, limit the changes
> to simple replacement without any change in the logic.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  mkfs/xfs_mkfs.c | 258 +++++++++++++++++++++++++++++---------------------------
>  1 file changed, 134 insertions(+), 124 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 66ba2869..4e85694f 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -448,6 +448,7 @@ struct opt_params {
>  			  .minval = 0,
>  			  .maxval = 1,
>  			  .flagval = 1,
> +			  .value = 1,
>  			},
>  			{ .index = L_SIZE,
>  			  .conflicts = { LAST_CONFLICT },
> @@ -1121,7 +1122,8 @@ parse_conf_val(int opt, int subopt, char *value)
>  }
>  
>  /*
> - * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
> + * Convert L_SU to L_SUNIT for 512 bytes blocks and check validity of the
> + * values.
>   */
>  static void
>  calc_stripe_factors(
> @@ -1173,7 +1175,7 @@ calc_stripe_factors(
>  	if (lsu)
>  		*lsunit = (int)BTOBBT(lsu);
>  
> -	/* verify if lsu/lsunit is a multiple block size */
> +	/* verify if L_SU/L_SUNIT is a multiple block size */
>  	if (lsu % get_conf_val(OPT_B, B_SIZE) != 0) {
>  		fprintf(stderr,
>  _("log stripe unit (%d) must be a multiple of the block size (%lld)\n"),
> @@ -1697,22 +1699,15 @@ main(
>  	int			lalign;
>  	int			ldflag;
>  	int			liflag;
> -	xfs_agnumber_t		logagno;
>  	xfs_rfsblock_t		logblocks;
>  	char			*logfile;
> -	int			loginternal;
> -	uint64_t		logbytes;
>  	xfs_fsblock_t		logstart;
>  	int			lvflag;
>  	int			lsflag;
>  	int			lsuflag;
>  	int			lsunitflag;
> -	int			lsectorlog;
> -	int			lsectorsize;
>  	int			lslflag;
>  	int			lssflag;
> -	int			lsu;
> -	int			lsunit;
>  	int			min_logblocks;
>  	xfs_mount_t		*mp;
>  	xfs_mount_t		mbuf;
> @@ -1767,20 +1762,17 @@ main(
>  	textdomain(PACKAGE);
>  
>  	blflag = bsflag = slflag = ssflag = lslflag = lssflag = 0;
> -	lsectorlog = 0;
> -	lsectorsize = 0;
>  	dasize = dblocks = 0;
>  	daflag = ilflag = imflag = ipflag = isflag = false;
>  	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = false;
> -	loginternal = 1;
> -	logagno = logblocks = rtblocks = rtextblocks = 0;
> -	Nflag = nlflag = nsflag = nvflag = 0;
> +	logblocks = rtblocks = rtextblocks = 0;
> +	Nflag = nlflag = nsflag = nvflag = false;
>  	dirblocklog = dirblocksize = 0;
>  	qflag = false;
>  	dfile = logfile = rtfile = NULL;
>  	protofile = NULL;
> -	rtbytes = rtextbytes = logbytes = 0;
> -	lalign = lsu = lsunit = 0;
> +	rtbytes = rtextbytes = 0;
> +	lalign = 0;
>  	dsflag = norsflag = false;
>  	force_overwrite = false;
>  	worst_freelist = 0;
> @@ -1969,9 +1961,7 @@ main(
>  
>  				switch (getsubopt(&p, subopts, &value)) {
>  				case L_AGNUM:
> -					logagno = parse_conf_val(OPT_L,
> -								 L_AGNUM,
> -								 value);
> +					parse_conf_val(OPT_L, L_AGNUM, value);
>  					laflag = 1;
>  					break;
>  				case L_FILE:
> @@ -1980,20 +1970,16 @@ main(
>  								    value);
>  					break;
>  				case L_INTERNAL:
> -					loginternal =
> -						parse_conf_val(OPT_L,
> -							       L_INTERNAL,
> -							       value);
> +					parse_conf_val(OPT_L, L_INTERNAL,
> +						       value);
>  					liflag = 1;
>  					break;
>  				case L_SU:
> -					lsu = parse_conf_val(OPT_L, L_SU,
> -							     value);
> +					parse_conf_val(OPT_L, L_SU, value);
>  					lsuflag = 1;
>  					break;
>  				case L_SUNIT:
> -					lsunit = parse_conf_val(OPT_L, L_SUNIT,
> -								value);
> +					parse_conf_val(OPT_L, L_SUNIT, value);
>  					lsunitflag = 1;
>  					break;
>  				case L_NAME:
> @@ -2002,7 +1988,7 @@ main(
>  								L_NAME);
>  					xi.logname = logfile;
>  					ldflag = 1;
> -					loginternal = 0;
> +					set_conf_val(OPT_L, L_INTERNAL, 0);
>  					set_conf_val(OPT_L, L_NAME, 1);
>  					set_conf_val(OPT_L, L_DEV, 1);
>  					break;
> @@ -2014,24 +2000,18 @@ main(
>  					lvflag = 1;
>  					break;
>  				case L_SIZE:
> -					logbytes = parse_conf_val(OPT_L,
> -								  L_SIZE,
> -								  value);
> +					parse_conf_val(OPT_L, L_SIZE, value);
>  					break;
>  				case L_SECTLOG:
> -					lsectorlog = parse_conf_val(OPT_L,
> +					parse_conf_val(OPT_L,
>  								    L_SECTLOG,
>  								    value);
> -					lsectorsize = 1 << lsectorlog;
>  					lslflag = 1;
>  					break;
>  				case L_SECTSIZE:
> -					lsectorsize =
>  						parse_conf_val(OPT_L,
>  							       L_SECTSIZE,
>  							       value);
> -					lsectorlog =
> -						libxfs_highbit32(lsectorsize);
>  					lssflag = 1;
>  					break;
>  				case L_LAZYSBCNTR:
> @@ -2201,7 +2181,6 @@ main(
>  				char	**subopts =
>  						(char **)opts[OPT_S].subopts;
>  				char	*value;
> -				uint64_t tmp;
>  
>  				switch (getsubopt(&p, subopts, &value)) {
>  				case S_LOG:
> @@ -2210,12 +2189,8 @@ main(
>  						conflict('s', subopts,
>  							 S_SECTSIZE,
>  							 S_SECTLOG);
> -					tmp = parse_conf_val(OPT_S,
> -								   S_SECTLOG,
> -								   value);
> -
> -					lsectorlog = tmp;
> -					lsectorsize = tmp;
> +					parse_conf_val(OPT_S, S_SECTLOG,
> +							value);
>  					lslflag = slflag = 1;
>  					break;
>  				case S_SIZE:
> @@ -2224,12 +2199,8 @@ main(
>  						conflict('s', subopts,
>  							 S_SECTLOG,
>  							 S_SECTSIZE);
> -					tmp = parse_conf_val(OPT_S,
> -								    S_SECTSIZE,
> -								    value);
> -
> -					lsectorlog = libxfs_highbit32(tmp);
> -					lsectorsize = tmp;
> +					parse_conf_val(OPT_S, S_SECTSIZE,
> +							value);
>  					lssflag = ssflag = 1;
>  					break;
>  				default:
> @@ -2285,8 +2256,9 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
>  		set_conf_val(OPT_D, D_SECTSIZE, XFS_MIN_SECTORSIZE);
>  	}
>  	if (!lslflag && !lssflag) {
> -		lsectorlog = get_conf_val(OPT_D, D_SECTLOG);
> -		lsectorsize = get_conf_val(OPT_D, D_SECTSIZE);
> +		set_conf_val(OPT_L, L_SECTLOG, get_conf_val(OPT_D, D_SECTLOG));
> +		set_conf_val(OPT_L, L_SECTSIZE,
> +			     get_conf_val(OPT_D, D_SECTSIZE));
>  	}
>  
>  	/*
> @@ -2299,8 +2271,9 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
>  	check_device_type(dfile, &xi.disfile, !get_conf_val(OPT_D, D_SIZE),
>  			  !dfile,
>  			  Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
> -	if (!loginternal)
> -		check_device_type(xi.logname, &xi.lisfile, !logbytes,
> +	if (!get_conf_val(OPT_L, L_INTERNAL))
> +		check_device_type(xi.logname, &xi.lisfile,
> +				  !get_conf_val(OPT_L, L_SIZE),
>  				  !xi.logname, Nflag ? NULL : &xi.lcreat,
>  				  force_overwrite, "l");
>  	if (xi.rtname)
> @@ -2348,9 +2321,11 @@ _("switching to logical sector size %d\n"),
>  	if (!ssflag) {
>  		set_conf_val(OPT_D, D_SECTLOG,
>  			     libxfs_highbit32(get_conf_val(OPT_D, D_SECTSIZE)));
> -		if (loginternal) {
> -			lsectorsize = get_conf_val(OPT_D, D_SECTSIZE);
> -			lsectorlog = get_conf_val(OPT_D, D_SECTLOG);
> +		if (get_conf_val(OPT_L, L_INTERNAL)) {
> +			set_conf_val(OPT_L, L_SECTSIZE,
> +				     get_conf_val(OPT_D, D_SECTSIZE));
> +			set_conf_val(OPT_L, L_SECTLOG,
> +				     get_conf_val(OPT_D, D_SECTLOG));
>  		}
>  	}
>  
> @@ -2371,13 +2346,16 @@ _("block size %lld cannot be smaller than logical sector size %d\n"),
>  			get_conf_val(OPT_D, D_SECTSIZE), ft.lsectorsize);
>  		usage();
>  	}
> -	if (lsectorsize < XFS_MIN_SECTORSIZE ||
> -	    lsectorsize > XFS_MAX_SECTORSIZE ||
> -	    lsectorsize > get_conf_val(OPT_B, B_SIZE)) {
> -		fprintf(stderr, _("illegal log sector size %d\n"), lsectorsize);
> +	if (get_conf_val(OPT_L, L_SECTSIZE) < XFS_MIN_SECTORSIZE ||
> +	    get_conf_val(OPT_L, L_SECTSIZE) > XFS_MAX_SECTORSIZE ||
> +	    get_conf_val(OPT_L, L_SECTSIZE) > get_conf_val(OPT_B, B_SIZE)) {
> +		fprintf(stderr, _("illegal log sector size %lld\n"),
> +			get_conf_val(OPT_L, L_SECTSIZE));
>  		usage();
> -	} else if (lsectorsize > XFS_MIN_SECTORSIZE && !lsu && !lsunit) {
> -		lsu = get_conf_val(OPT_B, B_SIZE);
> +	} else if (get_conf_val(OPT_L, L_SECTSIZE) > XFS_MIN_SECTORSIZE &&
> +		   !get_conf_val(OPT_L, L_SU) &&
> +		   !get_conf_val(OPT_L, L_SUNIT)) {
> +		set_conf_val(OPT_L, L_SU, get_conf_val(OPT_B, B_SIZE));
>  		sb_feat.log_version = 2;
>  	}
>  
> @@ -2530,19 +2508,20 @@ _("rmapbt not supported with realtime devices\n"));
>  		usage();
>  	}
>  
> -	if (logbytes) {
> -		if (logbytes % XFS_MIN_BLOCKSIZE) {
> +	if (get_conf_val(OPT_L, L_SIZE)) {
> +		if (get_conf_val(OPT_L, L_SIZE) % XFS_MIN_BLOCKSIZE) {
>  			fprintf(stderr,
>  			_("illegal log length %lld, not a multiple of %d\n"),
> -				(long long)logbytes, XFS_MIN_BLOCKSIZE);
> +				get_conf_val(OPT_L, L_SIZE), XFS_MIN_BLOCKSIZE);
>  			usage();
>  		}
> -		logblocks = (xfs_rfsblock_t)(logbytes >>
> +		logblocks = (xfs_rfsblock_t)(get_conf_val(OPT_L, L_SIZE) >>
>  					     get_conf_val(OPT_B, B_LOG));
> -		if (logbytes % get_conf_val(OPT_B, B_SIZE))
> +		if (get_conf_val(OPT_L, L_SIZE) % get_conf_val(OPT_B, B_SIZE))
>  			fprintf(stderr,
>  	_("warning: log length %lld not a multiple of %lld, truncated to %lld\n"),
> -				(long long)logbytes, get_conf_val(OPT_B, B_SIZE),
> +				get_conf_val(OPT_L, L_SIZE),
> +				get_conf_val(OPT_B, B_SIZE),
>  				(long long)(logblocks <<
>  					   get_conf_val(OPT_B, B_LOG)));
>  	}
> @@ -2634,8 +2613,9 @@ _("rmapbt not supported with realtime devices\n"));
>  		exit(1);
>  	}
>  
> -	/* if lsu or lsunit was specified, automatically use v2 logs */
> -	if ((lsu || lsunit) && sb_feat.log_version == 1) {
> +	/* if L_SU or L_SUNIT was specified, automatically use v2 logs */
> +	if ((get_conf_val(OPT_L, L_SU) ||
> +	     get_conf_val(OPT_L, L_SUNIT)) && sb_feat.log_version == 1) {
>  		fprintf(stderr,
>  			_("log stripe unit specified, using v2 logs\n"));
>  		sb_feat.log_version = 2;
> @@ -2643,13 +2623,14 @@ _("rmapbt not supported with realtime devices\n"));
>  
>  	int dsunit = get_conf_val(OPT_D, D_SUNIT);
>  	int dswidth = get_conf_val(OPT_D, D_SWIDTH);
> +	int lsunit = get_conf_val(OPT_L, L_SUNIT);
>  
>  	calc_stripe_factors(get_conf_val(OPT_D, D_SU),
>  			    get_conf_val(OPT_D, D_SW),
>  			    get_conf_val(OPT_D, D_SECTSIZE),
> -			    lsu,
> -			    lsectorsize,
> -				&dsunit, &dswidth, &lsunit);
> +			    get_conf_val(OPT_L, L_SU),
> +			    get_conf_val(OPT_L, L_SECTSIZE),
> +			    &dsunit, &dswidth, &lsunit);
>  
>  	/* If sunit & swidth were manually specified as 0, same as noalign */
>  	if (dsflag && !dsunit && !dswidth)
> @@ -2657,6 +2638,7 @@ _("rmapbt not supported with realtime devices\n"));
>  
>  	set_conf_val(OPT_D, D_SUNIT, dsunit);
>  	set_conf_val(OPT_D, D_SWIDTH, dswidth);
> +	set_conf_val(OPT_L, L_SUNIT, lsunit);
>  
>  	xi.setblksize = get_conf_val(OPT_D, D_SECTSIZE);
>  
> @@ -2685,7 +2667,8 @@ _("rmapbt not supported with realtime devices\n"));
>  		(MAX(get_conf_val(OPT_D, D_SECTLOG), 10) - BBSHIFT);
>  	xi.dsize &= sector_mask;
>  	xi.rtsize &= sector_mask;
> -	xi.logBBsize &= (uint64_t)-1 << (MAX(lsectorlog, 10) - BBSHIFT);
> +	xi.logBBsize &= (uint64_t)-1 << (MAX(get_conf_val(OPT_L, L_SECTLOG),
> +					     10) - BBSHIFT);
>  
>  
>  	/* don't do discards on print-only runs or on files */
> @@ -2699,10 +2682,10 @@ _("rmapbt not supported with realtime devices\n"));
>  	}
>  
>  	if (!liflag && !ldflag)
> -		loginternal = xi.logdev == 0;
> +		set_conf_val(OPT_L, L_INTERNAL, xi.logdev == 0);
>  	if (xi.logname)
>  		logfile = xi.logname;
> -	else if (loginternal)
> +	else if (get_conf_val(OPT_L, L_INTERNAL))
>  		logfile = _("internal log");
>  	else if (xi.volname && xi.logdev)
>  		logfile = _("volume log");
> @@ -2738,12 +2721,13 @@ _("rmapbt not supported with realtime devices\n"));
>  		usage();
>  	}
>  
> -	if (loginternal && xi.logdev) {
> +	if (get_conf_val(OPT_L, L_INTERNAL) && xi.logdev) {
>  		fprintf(stderr,
>  			_("can't have both external and internal logs\n"));
>  		usage();
> -	} else if (loginternal &&
> -		   get_conf_val(OPT_D, D_SECTSIZE) != lsectorsize) {
> +	} else if (get_conf_val(OPT_L, L_INTERNAL) &&
> +		   get_conf_val(OPT_D, D_SECTSIZE) !=
> +		   get_conf_val(OPT_L, L_SECTSIZE)) {
>  		fprintf(stderr,
>  	_("data and log sector sizes must be equal for internal logs\n"));
>  		usage();
> @@ -2755,11 +2739,12 @@ _("rmapbt not supported with realtime devices\n"));
>  reported by the device (%u).\n"),
>  			get_conf_val(OPT_D, D_SECTSIZE), xi.dbsize);
>  	}
> -	if (!loginternal && xi.lbsize > lsectorsize) {
> +	if (!get_conf_val(OPT_L, L_INTERNAL) &&
> +	    xi.lbsize > get_conf_val(OPT_L, L_SECTSIZE)) {
>  		fprintf(stderr, _(
> -"Warning: the log subvolume sector size %u is less than the sector size\n\
> +"Warning: the log subvolume sector size %lld is less than the sector size\n\
>  reported by the device (%u).\n"),
> -			lsectorsize, xi.lbsize);
> +			get_conf_val(OPT_L, L_SECTSIZE), xi.lbsize);
>  	}
>  	if (rtbytes && xi.rtsize > 0 &&
>  	    xi.rtbsize > get_conf_val(OPT_D, D_SECTSIZE)) {
> @@ -3037,27 +3022,31 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>  	 * check that log sunit is modulo fsblksize or default it to D_SUNIT.
>  	 */
>  
> -	if (lsunit) {
> +	if (get_conf_val(OPT_L, L_SUNIT)) {
>  		/* convert from 512 byte blocks to fs blocks */
> -		lsunit = DTOBT(lsunit);
> +		set_conf_val(OPT_L, L_SUNIT,
> +			     DTOBT(get_conf_val(OPT_L, L_SUNIT)));
>  	} else if (sb_feat.log_version == 2 &&
> -		   loginternal &&
> +		   get_conf_val(OPT_L, L_INTERNAL) &&
>  		   get_conf_val(OPT_D, D_SUNIT)) {
> -		/* lsunit and get_conf_val(OPT_D, D_SUNIT) now in fs blocks */
> -		lsunit = get_conf_val(OPT_D, D_SUNIT);
> +		/* L_SUNIT and D_SUNIT now in fs blocks */
> +		set_conf_val(OPT_L, L_SUNIT, get_conf_val(OPT_D, D_SUNIT));
>  	}
>  
>  	if (sb_feat.log_version == 2 &&
> -	    (lsunit * get_conf_val(OPT_B, B_SIZE)) > 256 * 1024) {
> +	    (get_conf_val(OPT_L, L_SUNIT) *
> +	     get_conf_val(OPT_B, B_SIZE)) > 256 * 1024) {
>  		/* Warn only if specified on commandline */
>  		if (lsuflag || lsunitflag) {
>  			fprintf(stderr,
>  	_("log stripe unit (%lld bytes) is too large (maximum is 256KiB)\n"),
> -				(lsunit * get_conf_val(OPT_B, B_SIZE)));
> +				(get_conf_val(OPT_L, L_SUNIT) *
> +				 get_conf_val(OPT_B, B_SIZE)));
>  			fprintf(stderr,
>  	_("log stripe unit adjusted to 32KiB\n"));
>  		}
> -		lsunit = (32 * 1024) >> get_conf_val(OPT_B, B_LOG);
> +		set_conf_val(OPT_L, L_SUNIT,
> +			     (32 * 1024) >> get_conf_val(OPT_B, B_LOG));
>  	}
>  
>  	min_logblocks = max_trans_res(get_conf_val(OPT_D, D_AGSIZE),
> @@ -3065,35 +3054,41 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>  				   get_conf_val(OPT_D, D_SECTLOG),
>  				   get_conf_val(OPT_B, B_LOG),
>  				   get_conf_val(OPT_I, I_LOG), dirblocklog,
> -				   sb_feat.log_version, lsunit, sb_feat.finobt,
> +				   sb_feat.log_version,
> +				   get_conf_val(OPT_L, L_SUNIT),
> +				   sb_feat.finobt,
>  				   sb_feat.rmapbt, sb_feat.reflink,
>  				   sb_feat.inode_align);
>  	ASSERT(min_logblocks);
>  	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
> -	if (!logbytes &&
> +	if (!get_conf_val(OPT_L, L_SIZE) &&
>  	    dblocks >= (1024*1024*1024) >> get_conf_val(OPT_B, B_LOG))
>  		min_logblocks = MAX(min_logblocks,
>  				    XFS_MIN_LOG_BYTES >>
>  				    get_conf_val(OPT_B, B_LOG));
> -	if (logbytes && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
> +	if (get_conf_val(OPT_L, L_SIZE) && xi.logBBsize > 0 &&
> +	    logblocks > DTOBT(xi.logBBsize)) {
>  		fprintf(stderr,
>  _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  			get_conf_raw_safe(OPT_L, L_SIZE),
>  			(long long)DTOBT(xi.logBBsize));
>  		usage();
> -	} else if (!logbytes && xi.logBBsize > 0) {
> +	} else if (!get_conf_val(OPT_L, L_SIZE) && xi.logBBsize > 0) {
>  		logblocks = DTOBT(xi.logBBsize);
> -	} else if (logbytes && !xi.logdev && !loginternal) {
> +	} else if (get_conf_val(OPT_L, L_SIZE) && !xi.logdev &&
> +		   !get_conf_val(OPT_L, L_INTERNAL)) {
>  		fprintf(stderr,
>  			_("size specified for non-existent log subvolume\n"));
>  		usage();
> -	} else if (loginternal && logbytes && logblocks >= dblocks) {
> +	} else if (get_conf_val(OPT_L, L_INTERNAL) &&
> +		   get_conf_val(OPT_L, L_SIZE) && logblocks >= dblocks) {
>  		fprintf(stderr, _("size %lld too large for internal log\n"),
>  			(long long)logblocks);
>  		usage();
> -	} else if (!loginternal && !xi.logdev) {
> +	} else if (!get_conf_val(OPT_L, L_INTERNAL) && !xi.logdev) {
>  		logblocks = 0;
> -	} else if (loginternal && !logbytes) {
> +	} else if (get_conf_val(OPT_L, L_INTERNAL) &&
> +		   !get_conf_val(OPT_L, L_SIZE)) {
>  
>  		if (dblocks < GIGABYTES(1, get_conf_val(OPT_B, B_LOG))) {
>  			/* tiny filesystems get minimum sized logs. */
> @@ -3157,16 +3152,16 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  	 */
>  	sb_set_features(&mp->m_sb, &sb_feat,
>  			get_conf_val(OPT_D, D_SECTSIZE),
> -			lsectorsize,
> +			get_conf_val(OPT_L, L_SECTSIZE),
>  			get_conf_val(OPT_D, D_SUNIT));
>  
>  
> -	if (loginternal) {
> +	if (get_conf_val(OPT_L, L_INTERNAL)) {
>  		/*
>  		 * Readjust the log size to fit within an AG if it was sized
>  		 * automatically.
>  		 */
> -		if (!logbytes) {
> +		if (!get_conf_val(OPT_L, L_SIZE)) {
>  			logblocks = MIN(logblocks,
>  					libxfs_alloc_ag_max_usable(mp));
>  
> @@ -3184,25 +3179,28 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  		}
>  
>  		if (laflag) {
> -			if (logagno >= get_conf_val(OPT_D, D_AGCOUNT)) {
> +			if (get_conf_val(OPT_L, L_AGNUM) >=
> +			    get_conf_val(OPT_D, D_AGCOUNT)) {
>  				fprintf(stderr,
> -		_("log ag number %d too large, must be less than %lld\n"),
> -					logagno,
> +	_("log ag number %lld too large, must be less than %lld\n"),
> +					get_conf_val(OPT_L, L_AGNUM),
>  					get_conf_val(OPT_D, D_AGCOUNT));
>  				usage();
>  			}
>  		} else
> -			logagno = (xfs_agnumber_t)(
> -					get_conf_val(OPT_D, D_AGCOUNT) / 2);
> +			set_conf_val(OPT_L, L_AGNUM, (xfs_agnumber_t)(
> +					get_conf_val(OPT_D, D_AGCOUNT) / 2));
>  
> -		logstart = XFS_AGB_TO_FSB(mp, logagno, libxfs_prealloc_blocks(mp));
> +		logstart = XFS_AGB_TO_FSB(mp, get_conf_val(OPT_L, L_AGNUM),
> +					  libxfs_prealloc_blocks(mp));
>  		/*
>  		 * Align the logstart at stripe unit boundary.
>  		 */
> -		if (lsunit) {
> +		if (get_conf_val(OPT_L, L_SUNIT)) {
>  			logstart = fixup_internal_log_stripe(mp,
>  					lsflag, logstart,
> -					get_conf_val(OPT_D, D_AGSIZE), lsunit,
> +					get_conf_val(OPT_D, D_AGSIZE),
> +					get_conf_val(OPT_L, L_SUNIT),
>  					&logblocks,
>  					get_conf_val(OPT_B, B_LOG), &lalign);
>  		} else if (get_conf_val(OPT_D, D_SUNIT)) {
> @@ -3215,8 +3213,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  		}
>  	} else {
>  		logstart = 0;
> -		if (lsunit)
> -			fixup_log_stripe_unit(lsflag, lsunit,
> +		if (get_conf_val(OPT_L, L_SUNIT))
> +			fixup_log_stripe_unit(lsflag,
> +					      get_conf_val(OPT_L, L_SUNIT),
>  					&logblocks, get_conf_val(OPT_B, B_LOG));
>  	}
>  	validate_log_size(logblocks, get_conf_val(OPT_B, B_LOG), min_logblocks);
> @@ -3248,7 +3247,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  			sb_feat.dir_version, (long long)dirblocksize, sb_feat.nci,
>  				sb_feat.dirftype,
>  			logfile, 1 << get_conf_val(OPT_B, B_LOG), (long long)logblocks,
> -			sb_feat.log_version, "", (long long)lsectorsize, (long long)lsunit,
> +			sb_feat.log_version, "",
> +			get_conf_val(OPT_L, L_SECTSIZE),
> +			get_conf_val(OPT_L, L_SUNIT),
>  				sb_feat.lazy_sb_counters,
>  			rtfile, rtextblocks << get_conf_val(OPT_B, B_LOG),
>  			(long long)rtblocks, (long long)rtextents);
> @@ -3289,7 +3290,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  	sbp->sb_ifree = 0;
>  	sbp->sb_fdblocks = dblocks -
>  		get_conf_val(OPT_D, D_AGCOUNT) * libxfs_prealloc_blocks(mp) -
> -		(loginternal ? logblocks : 0);
> +		(get_conf_val(OPT_L, L_INTERNAL) ? logblocks : 0);
>  	sbp->sb_frextents = 0;	/* will do a free later */
>  	sbp->sb_uquotino = sbp->sb_gquotino = sbp->sb_pquotino = 0;
>  	sbp->sb_qflags = 0;
> @@ -3297,8 +3298,11 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  	sbp->sb_width = get_conf_val(OPT_D, D_SWIDTH);
>  	sbp->sb_dirblklog = dirblocklog - get_conf_val(OPT_B, B_LOG);
>  	if (sb_feat.log_version == 2) {	/* This is stored in bytes */
> -		lsunit = (lsunit == 0) ? 1 : XFS_FSB_TO_B(mp, lsunit);
> -		sbp->sb_logsunit = lsunit;
> +		set_conf_val(OPT_L, L_SUNIT,
> +			     (get_conf_val(OPT_L, L_SUNIT) == 0) ?
> +			     1 : XFS_FSB_TO_B(mp,
> +					      get_conf_val(OPT_L, L_SUNIT)));
> +		sbp->sb_logsunit = get_conf_val(OPT_L, L_SUNIT);
>  	} else
>  		sbp->sb_logsunit = 0;
>  	if (sb_feat.inode_align) {
> @@ -3310,10 +3314,11 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  		sb_feat.inode_align = sbp->sb_inoalignmt != 0;
>  	} else
>  		sbp->sb_inoalignmt = 0;
> -	if (lsectorsize != BBSIZE ||
> +	if (get_conf_val(OPT_L, L_SECTSIZE) != BBSIZE ||
>  	    get_conf_val(OPT_D, D_SECTSIZE) != BBSIZE) {
> -		sbp->sb_logsectlog = (uint8_t)lsectorlog;
> -		sbp->sb_logsectsize = (uint16_t)lsectorsize;
> +		sbp->sb_logsectlog = (uint8_t)get_conf_val(OPT_L, L_SECTLOG);
> +		sbp->sb_logsectsize =
> +			(uint16_t)get_conf_val(OPT_L, L_SECTSIZE);
>  	} else {
>  		sbp->sb_logsectlog = 0;
>  		sbp->sb_logsectsize = 0;
> @@ -3321,7 +3326,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  
>  	sb_set_features(&mp->m_sb, &sb_feat,
>  			get_conf_val(OPT_D, D_SECTSIZE),
> -			lsectorsize,
> +			get_conf_val(OPT_L, L_SECTSIZE),
>  			get_conf_val(OPT_D, D_SUNIT));
>  
>  	if (force_overwrite)
> @@ -3383,7 +3388,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  	libxfs_log_clear(mp->m_logdev_targp, NULL,
>  		XFS_FSB_TO_DADDR(mp, logstart),
>  		(xfs_extlen_t)XFS_FSB_TO_BB(mp, logblocks),
> -		&sbp->sb_uuid, sb_feat.log_version, lsunit, XLOG_FMT, XLOG_INIT_CYCLE, false);
> +		&sbp->sb_uuid, sb_feat.log_version,
> +		get_conf_val(OPT_L, L_SUNIT), XLOG_FMT, XLOG_INIT_CYCLE, false);
>  
>  	mp = libxfs_mount(mp, sbp, xi.ddev, xi.logdev, xi.rtdev, 0);
>  	if (mp == NULL) {
> @@ -3460,7 +3466,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  		if (xfs_sb_version_hascrc(&mp->m_sb))
>  			platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
>  
> -		if (loginternal && agno == logagno) {
> +		if (get_conf_val(OPT_L, L_INTERNAL) &&
> +		    agno == get_conf_val(OPT_L, L_AGNUM)) {
>  			be32_add_cpu(&agf->agf_freeblks, -logblocks);
>  			agf->agf_longest =
>  				cpu_to_be32(get_conf_val(OPT_D, D_AGSIZE) -
> @@ -3534,7 +3541,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  
>  		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
>  		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
> -		if (loginternal && agno == logagno) {
> +		if (get_conf_val(OPT_L, L_INTERNAL) &&
> +		    agno == get_conf_val(OPT_L, L_AGNUM)) {
>  			if (lalign) {
>  				/*
>  				 * Have to insert two records
> @@ -3585,7 +3593,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  
>  		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
>  		arec->ar_startblock = cpu_to_be32(libxfs_prealloc_blocks(mp));
> -		if (loginternal && agno == logagno) {
> +		if (get_conf_val(OPT_L, L_INTERNAL) &&
> +		    agno == get_conf_val(OPT_L, L_AGNUM)) {
>  			if (lalign) {
>  				arec->ar_blockcount = cpu_to_be32(
>  					XFS_FSB_TO_AGBNO(mp, logstart) -
> @@ -3720,7 +3729,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  			}
>  
>  			/* account for the log space */
> -			if (loginternal && agno == logagno) {
> +			if (get_conf_val(OPT_L, L_INTERNAL) && agno ==
> +			    get_conf_val(OPT_L, L_AGNUM)) {
>  				rrec = XFS_RMAP_REC_ADDR(block,
>  					be16_to_cpu(block->bb_numrecs) + 1);
>  				rrec->rm_startblock = cpu_to_be32(
> -- 
> 2.13.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
