Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5F0657CA1
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 17:40:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 53B028F8049
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 15:40:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 9889fnXFxp1UFUrb for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 15:40:32 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4D0DA142D
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 17:40:28 -0500 (CDT)
Subject: Re: [PATCH 13/19] mkfs: encode conflicts into parsing table
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-14-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5706E1DB.4040205@sandeen.net>
Date: Thu, 7 Apr 2016 17:40:27 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-14-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> CHANGELOG:
> o Add .conflicts init where it was missing
> o Add explanation of a new member of opt_params struct.
> o A long line fix.
> 
> Many options conflict, so we need to specify which options conflict
> with each other in a generic manner. We already have a "seen"
> variable used for respecification detection, so we can also use this
> code conflict detection. Hence add a "conflicts" array to the sub
> options parameter definition.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 258 +++++++++++++++++++++++++++++---------------------------
>  1 file changed, 134 insertions(+), 124 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 1f06110..d119580 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -54,6 +54,9 @@ unsigned int		sectorsize;
>  
>  #define MAX_SUBOPTS	16
>  #define SUBOPT_NEEDS_VAL	(-1LL)
> +#define MAX_CONFLICTS	8
> +#define LAST_CONFLICT	(-1)
> +
>  /*
>   * Table for parsing mkfs parameters.
>   *
> @@ -89,6 +92,11 @@ unsigned int		sectorsize;
>   *     An optional flag for subopts where the given value has to be a power
>   *     of two.
>   *
> + *   conflicts MANDATORY
> + *     If your subopt is in a conflict with some other option, specify it.
> + *     Accepts the .index values of the conflicting subopts and the last
> + *     member of this list has to be LAST_CONFLICT.
> + *
>   *   minval, maxval OPTIONAL
>   *     These options are used for automatic range check and they have to be
>   *     always used together in pair. If you don't want to limit the max value,
> @@ -118,6 +126,7 @@ struct opt_params {
>  		bool		seen;
>  		bool		convert;
>  		bool		is_power_2;
> +		int		conflicts[MAX_CONFLICTS];
>  		long long	minval;
>  		long long	maxval;
>  		long long	defaultval;
> @@ -135,6 +144,8 @@ struct opt_params bopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = B_LOG,
> +		  .conflicts = { B_SIZE,
> +				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_BLOCKSIZE_LOG,
>  		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
> @@ -142,6 +153,8 @@ struct opt_params bopts = {
>  		{ .index = B_SIZE,
>  		  .convert = true,
>  		  .is_power_2 = true,
> +		  .conflicts = { B_LOG,
> +				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_BLOCKSIZE,
>  		  .maxval = XFS_MAX_BLOCKSIZE,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
> @@ -186,57 +199,84 @@ struct opt_params dopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = D_AGCOUNT,
> +		  .conflicts = { D_AGSIZE,
> +				 LAST_CONFLICT },
>  		  .minval = 1,
>  		  .maxval = XFS_MAX_AGNUMBER,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_FILE,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = D_NAME,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SIZE,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .convert = true,
>  		  .minval = XFS_AG_MIN_BYTES,
>  		  .maxval = LLONG_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SUNIT,
> +		  .conflicts = { D_NOALIGN,
> +				 D_SU,
> +				 D_SW,
> +				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SWIDTH,
> +		  .conflicts = { D_NOALIGN,
> +				 D_SU,
> +				 D_SW,
> +				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_AGSIZE,
> +		  .conflicts = { D_AGCOUNT,
> +				 LAST_CONFLICT },
>  		  .convert = true,
>  		  .minval = XFS_AG_MIN_BYTES,
>  		  .maxval = XFS_AG_MAX_BYTES,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SU,
> +		  .conflicts = { D_NOALIGN,
> +				 D_SUNIT,
> +				 D_SWIDTH,
> +				 LAST_CONFLICT },
>  		  .convert = true,
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SW,
> +		  .conflicts = { D_NOALIGN,
> +				 D_SUNIT,
> +				 D_SWIDTH,
> +				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SECTLOG,
> +		  .conflicts = { D_SECTSIZE,
> +				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_SECTSIZE,
> +		  .conflicts = { D_SECTLOG,
> +				 LAST_CONFLICT },
>  		  .convert = true,
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_SECTORSIZE,
> @@ -244,21 +284,29 @@ struct opt_params dopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_NOALIGN,
> +		  .conflicts = { D_SU,
> +				 D_SW,
> +				 D_SUNIT,
> +				 D_SWIDTH,
> +				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = D_RTINHERIT,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 1,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = D_PROJINHERIT,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = D_EXTSZINHERIT,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
> @@ -290,43 +338,57 @@ struct opt_params iopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = I_ALIGN,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = I_LOG,
> +		  .conflicts = { I_PERBLOCK,
> +				 I_SIZE,
> +				 LAST_CONFLICT },
>  		  .minval = XFS_DINODE_MIN_LOG,
>  		  .maxval = XFS_DINODE_MAX_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_MAXPCT,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 100,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_PERBLOCK,
> +		  .conflicts = { I_LOG,
> +				 I_SIZE,
> +				 LAST_CONFLICT },
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_INODE_PERBLOCK,
>  		  .maxval = XFS_MAX_BLOCKSIZE / XFS_DINODE_MIN_SIZE,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_SIZE,
> +		  .conflicts = { I_PERBLOCK,
> +				 I_LOG,
> +				 LAST_CONFLICT },
>  		  .is_power_2 = true,
>  		  .minval = XFS_DINODE_MIN_SIZE,
>  		  .maxval = XFS_DINODE_MAX_SIZE,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_ATTR,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 2,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = I_PROJID32BIT,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = I_SPINODES,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
> @@ -365,46 +427,64 @@ struct opt_params lopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = L_AGNUM,
> +		  .conflicts = { L_DEV,
> +				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_INTERNAL,
> +		  .conflicts = { L_FILE,
> +				 L_DEV,
> +				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = L_SIZE,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .convert = true,
>  		  .minval = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
>  		  .maxval = XFS_MAX_LOG_BYTES,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_VERSION,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 1,
>  		  .maxval = 2,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SUNIT,
> +		  .conflicts = { L_SU,
> +				 LAST_CONFLICT },
>  		  .minval = BTOBB(XLOG_MIN_RECORD_BSIZE),
>  		  .maxval = BTOBB(XLOG_MAX_RECORD_BSIZE),
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SU,
> +		  .conflicts = { L_SUNIT,
> +				 LAST_CONFLICT },
>  		  .convert = true,
>  		  .minval = XLOG_MIN_RECORD_BSIZE,
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_DEV,
> +		  .conflicts = { L_AGNUM,
> +				 L_INTERNAL,
> +				 LAST_CONFLICT },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SECTLOG,
> +		  .conflicts = { L_SECTSIZE,
> +				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_SECTSIZE,
> +		  .conflicts = { L_SECTLOG,
> +				 LAST_CONFLICT },
>  		  .convert = true,
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_SECTORSIZE,
> @@ -412,14 +492,20 @@ struct opt_params lopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_FILE,
> +		  .conflicts = { L_INTERNAL,
> +				 LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = L_NAME,
> +		  .conflicts = { L_AGNUM,
> +				 L_INTERNAL,
> +				 LAST_CONFLICT },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = L_LAZYSBCNTR,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
> @@ -442,11 +528,15 @@ struct opt_params nopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = N_LOG,
> +		  .conflicts = { N_SIZE,
> +				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_REC_DIRSIZE,
>  		  .maxval = XFS_MAX_BLOCKSIZE_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = N_SIZE,
> +		  .conflicts = { N_LOG,
> +				 LAST_CONFLICT },
>  		  .convert = true,
>  		  .is_power_2 = true,
>  		  .minval = 1 << XFS_MIN_REC_DIRSIZE,
> @@ -454,11 +544,13 @@ struct opt_params nopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = N_VERSION,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 2,
>  		  .maxval = 2,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = N_FTYPE,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
> @@ -485,32 +577,38 @@ struct opt_params ropts = {
>  	},
>  	.subopt_params = {
>  		{ .index = R_EXTSIZE,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .convert = true,
>  		  .minval = XFS_MIN_RTEXTSIZE,
>  		  .maxval = XFS_MAX_RTEXTSIZE,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_SIZE,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .convert = true,
>  		  .minval = 0,
>  		  .maxval = LLONG_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_DEV,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_FILE,
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
> +		  .conflicts = { LAST_CONFLICT },
>  		},
>  		{ .index = R_NAME,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = R_NOALIGN,
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
> +		  .conflicts = { LAST_CONFLICT },
>  		},
>  	},
>  };
> @@ -530,16 +628,25 @@ struct opt_params sopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = S_LOG,
> +		  .conflicts = { S_SIZE,
> +				 S_SECTSIZE,
> +				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = S_SECTLOG,
> +		  .conflicts = { S_SIZE,
> +				 S_SECTSIZE,
> +				 LAST_CONFLICT },
>  		  .minval = XFS_MIN_SECTORSIZE_LOG,
>  		  .maxval = XFS_MAX_SECTORSIZE_LOG,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = S_SIZE,
> +		  .conflicts = { S_LOG,
> +				 S_SECTLOG,
> +				 LAST_CONFLICT },
>  		  .convert = true,
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_SECTORSIZE,
> @@ -547,6 +654,9 @@ struct opt_params sopts = {
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  		{ .index = S_SECTSIZE,
> +		  .conflicts = { S_LOG,
> +				 S_SECTLOG,
> +				 LAST_CONFLICT },
>  		  .convert = true,
>  		  .is_power_2 = true,
>  		  .minval = XFS_MIN_SECTORSIZE,
> @@ -569,16 +679,19 @@ struct opt_params mopts = {
>  	},
>  	.subopt_params = {
>  		{ .index = M_CRC,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = M_FINOBT,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .minval = 0,
>  		  .maxval = 1,
>  		  .defaultval = 1,
>  		},
>  		{ .index = M_UUID,
> +		  .conflicts = { LAST_CONFLICT },
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
>  	},
> @@ -620,30 +733,14 @@ calc_stripe_factors(
>  	int		*lsunit)
>  {
>  	/* Handle data sunit/swidth options */
> -	if (*dsunit || *dswidth) {
> -		if (dsu || dsw) {
> -			fprintf(stderr,
> -				_("data su/sw must not be used in "
> -				"conjunction with data sunit/swidth\n"));
> -			usage();
> -		}
> -
> -		if ((*dsunit && !*dswidth) || (!*dsunit && *dswidth)) {
> -			fprintf(stderr,
> -				_("both data sunit and data swidth options "
> -				"must be specified\n"));
> -			usage();
> -		}
> +	if ((*dsunit && !*dswidth) || (!*dsunit && *dswidth)) {
> +		fprintf(stderr,
> +			_("both data sunit and data swidth options "
> +			"must be specified\n"));
> +		usage();
>  	}
>  
>  	if (dsu || dsw) {
> -		if (*dsunit || *dswidth) {
> -			fprintf(stderr,
> -				_("data sunit/swidth must not be used in "
> -				"conjunction with data su/sw\n"));
> -			usage();
> -		}
> -
>  		if ((dsu && !dsw) || (!dsu && dsw)) {
>  			fprintf(stderr,
>  				_("both data su and data sw options "
> @@ -671,24 +768,8 @@ calc_stripe_factors(
>  
>  	/* Handle log sunit options */
>  
> -	if (*lsunit) {
> -		if (lsu) {
> -			fprintf(stderr,
> -				_("log su should not be used in "
> -				"conjunction with log sunit\n"));
> -			usage();
> -		}
> -	}
> -
> -	if (lsu) {
> -		if (*lsunit) {
> -			fprintf(stderr,
> -				_("log sunit should not be used in "
> -				"conjunction with log su\n"));
> -			usage();
> -		}
> +	if (lsu)
>  		*lsunit = (int)BTOBBT(lsu);
> -	}
>  }
>  
>  /*
> @@ -1410,6 +1491,17 @@ getnum(
>  		respec(opts->name, (char **)opts->subopts, index);
>  	sp->seen = true;
>  
> +	/* check for conflicts with the option */
> +	for (c = 0; c < MAX_CONFLICTS; c++) {
> +		int conflict_opt = sp->conflicts[c];
> +
> +		if (conflict_opt == LAST_CONFLICT)
> +			break;
> +		if (opts->subopt_params[conflict_opt].seen)
> +			conflict(opts->name, (char **)opts->subopts,
> +				 conflict_opt, index);
> +	}
> +
>  	/* empty strings might just return a default value */
>  	if (!str || *str == '\0') {
>  		if (sp->defaultval == SUBOPT_NEEDS_VAL)
> @@ -1607,17 +1699,11 @@ main(
>  				switch (getsubopt(&p, (constpp)subopts,
>  						  &value)) {
>  				case B_LOG:
> -					if (bsflag)
> -						conflict('b', subopts, B_SIZE,
> -							 B_LOG);
>  					blocklog = getnum(value, &bopts, B_LOG);
>  					blocksize = 1 << blocklog;
>  					blflag = 1;
>  					break;
>  				case B_SIZE:
> -					if (blflag)
> -						conflict('b', subopts, B_LOG,
> -							 B_SIZE);
>  					blocksize = getnum(value, &bopts,
>  							   B_SIZE);
>  					blocklog = libxfs_highbit32(blocksize);
> @@ -1666,61 +1752,29 @@ main(
>  					dsize = value;
>  					break;
>  				case D_SUNIT:
> -					if (nodsflag)
> -						conflict('d', subopts, D_NOALIGN,
> -							 D_SUNIT);
>  					dsunit = getnum(value, &dopts, D_SUNIT);
>  					break;
>  				case D_SWIDTH:
> -					if (nodsflag)
> -						conflict('d', subopts, D_NOALIGN,
> -							 D_SWIDTH);
>  					dswidth = getnum(value, &dopts,
>  							 D_SWIDTH);
>  					break;
>  				case D_SU:
> -					if (nodsflag)
> -						conflict('d', subopts, D_NOALIGN,
> -							 D_SU);
>  					dsu = getnum(value, &dopts, D_SU);
>  					break;
>  				case D_SW:
> -					if (nodsflag)
> -						conflict('d', subopts, D_NOALIGN,
> -							 D_SW);
>  					dsw = getnum(value, &dopts, D_SW);
>  					break;
>  				case D_NOALIGN:
>  					nodsflag = getnum(value, &dopts,
> -							 	D_NOALIGN);
> -					if (nodsflag) {
> -						if (dsu)
> -							conflict('d', subopts, D_SU,
> -								D_NOALIGN);
> -						if (dsunit)
> -							conflict('d', subopts, D_SUNIT,
> -								D_NOALIGN);
> -						if (dsw)
> -							conflict('d', subopts, D_SW,
>  								D_NOALIGN);
> -						if (dswidth)
> -							conflict('d', subopts, D_SWIDTH,
> -								D_NOALIGN);
> -					}
>  					break;
>  				case D_SECTLOG:
> -					if (ssflag)
> -						conflict('d', subopts, D_SECTSIZE,
> -							 D_SECTLOG);
>  					sectorlog = getnum(value, &dopts,
>  							   D_SECTLOG);
>  					sectorsize = 1 << sectorlog;
>  					slflag = 1;
>  					break;
>  				case D_SECTSIZE:
> -					if (slflag)
> -						conflict('d', subopts, D_SECTLOG,
> -							 D_SECTSIZE);
>  					sectorsize = getnum(value, &dopts,
>  							    D_SECTSIZE);
>  					sectorlog =
> @@ -1763,12 +1817,6 @@ main(
>  								&iopts, I_ALIGN);
>  					break;
>  				case I_LOG:
> -					if (ipflag)
> -						conflict('i', subopts, I_PERBLOCK,
> -							 I_LOG);
> -					if (isflag)
> -						conflict('i', subopts, I_SIZE,
> -							 I_LOG);
>  					inodelog = getnum(value, &iopts, I_LOG);
>  					isize = 1 << inodelog;
>  					ilflag = 1;
> @@ -1779,23 +1827,11 @@ main(
>  					imflag = 1;
>  					break;
>  				case I_PERBLOCK:
> -					if (ilflag)
> -						conflict('i', subopts, I_LOG,
> -							 I_PERBLOCK);
> -					if (isflag)
> -						conflict('i', subopts, I_SIZE,
> -							 I_PERBLOCK);
>  					inopblock = getnum(value, &iopts,
>  							   I_PERBLOCK);
>  					ipflag = 1;
>  					break;
>  				case I_SIZE:
> -					if (ilflag)
> -						conflict('i', subopts, I_LOG,
> -							 I_SIZE);
> -					if (ipflag)
> -						conflict('i', subopts, I_PERBLOCK,
> -							 I_SIZE);
>  					isize = getnum(value, &iopts, I_SIZE);
>  					inodelog = libxfs_highbit32(isize);
>  					isflag = 1;
> @@ -1810,9 +1846,8 @@ main(
>  							I_PROJID32BIT);
>  					break;
>  				case I_SPINODES:
> -					sb_feat.spinodes =
> -						getnum(value, &iopts,
> -								I_SPINODES);
> +					sb_feat.spinodes = getnum(value,
> +							&iopts, I_SPINODES);
>  					break;
>  				default:
>  					unknown('i', value);
> @@ -1828,8 +1863,6 @@ main(
>  				switch (getsubopt(&p, (constpp)subopts,
>  						  &value)) {
>  				case L_AGNUM:
> -					if (ldflag)
> -						conflict('l', subopts, L_AGNUM, L_DEV);
>  					logagno = getnum(value, &lopts, L_AGNUM);
>  					laflag = 1;
>  					break;
> @@ -1843,12 +1876,6 @@ main(
>  						xi.lcreat = 1;
>  					break;
>  				case L_INTERNAL:
> -					if (ldflag)
> -						conflict('l', subopts, L_INTERNAL, L_DEV);
> -					if (xi.lisfile)
> -						conflict('l', subopts, L_FILE,
> -							 L_INTERNAL);
> -
>  					loginternal = getnum(value, &lopts,
>  							     L_INTERNAL);
>  					liflag = 1;
> @@ -1890,18 +1917,12 @@ main(
>  					lsflag = 1;
>  					break;
>  				case L_SECTLOG:
> -					if (lssflag)
> -						conflict('l', subopts, L_SECTSIZE,
> -							 L_SECTLOG);
>  					lsectorlog = getnum(value, &lopts,
>  							    L_SECTLOG);
>  					lsectorsize = 1 << lsectorlog;
>  					lslflag = 1;
>  					break;
>  				case L_SECTSIZE:
> -					if (lslflag)
> -						conflict('l', subopts, L_SECTLOG,
> -							 L_SECTSIZE);
>  					lsectorsize = getnum(value, &lopts,
>  							     L_SECTSIZE);
>  					lsectorlog =
> @@ -1966,18 +1987,12 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  				switch (getsubopt(&p, (constpp)subopts,
>  						  &value)) {
>  				case N_LOG:
> -					if (nsflag)
> -						conflict('n', subopts, N_SIZE,
> -							 N_LOG);
>  					dirblocklog = getnum(value, &nopts,
>  							     N_LOG);
>  					dirblocksize = 1 << dirblocklog;
>  					nlflag = 1;
>  					break;
>  				case N_SIZE:
> -					if (nlflag)
> -						conflict('n', subopts, N_LOG,
> -							 N_SIZE);
>  					dirblocksize = getnum(value, &nopts,
>  							      N_SIZE);
>  					dirblocklog =
> @@ -2083,7 +2098,7 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  						  &value)) {
>  				case S_LOG:
>  				case S_SECTLOG:
> -					if (ssflag || lssflag)
> +					if (lssflag)
>  						conflict('s', subopts,
>  							 S_SECTSIZE, S_SECTLOG);
>  					sectorlog = getnum(value, &sopts,
> @@ -2095,7 +2110,7 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  					break;
>  				case S_SIZE:
>  				case S_SECTSIZE:
> -					if (slflag || lslflag)
> +					if (lslflag)
>  						conflict('s', subopts, S_SECTLOG,
>  							 S_SECTSIZE);
>  					sectorsize = getnum(value, &sopts,
> @@ -2316,11 +2331,6 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
>  		dirblocksize = 1 << dirblocklog;
>  	}
>  
> -	if (daflag && dasize) {
> -		fprintf(stderr,
> -	_("both -d agcount= and agsize= specified, use one or the other\n"));
> -		usage();
> -	}
>  
>  	if (xi.disfile && (!dsize || !xi.dname)) {
>  		fprintf(stderr,
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
