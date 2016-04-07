Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E0D037CA1
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 17:49:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F6A0AC004
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 15:49:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id IRdUlVl1W8Z4lkaX for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 15:49:15 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7F969142D
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 17:49:14 -0500 (CDT)
Subject: Re: [PATCH 14/19] mkfs: add string options to generic parsing
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-15-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5706E3E8.8020007@sandeen.net>
Date: Thu, 7 Apr 2016 17:49:12 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-15-git-send-email-jtulak@redhat.com>
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
> o Remove unused argument of check_opt.
> o Add a comment to explain a new member of opt_params struct.
> o A stray chunk moved from the following patch to this one.
> 
> So that string options are correctly detected for conflicts and
> respecification, add a getstr() function that modifies the option
> tables appropriately.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 143 ++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 78 insertions(+), 65 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index d119580..9261ed5 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -83,6 +83,10 @@ unsigned int		sectorsize;
>   *     Do not set this flag when definning a subopt. It is used to remeber that
>   *     this subopt was already seen, for example for conflicts detection.
>   *
> + *   str_seen INTERNAL
> + *     Do not set. It is used internally for respecification, when some options
> + *     has to be parsed twice - at first as a string, then later as a number.
> + *
>   *   convert OPTIONAL
>   *     A flag signalling whether the user-given value can use suffixes.
>   *     If you want to allow the use of user-friendly values like 13k, 42G,
> @@ -124,6 +128,7 @@ struct opt_params {
>  	struct subopt_param {
>  		int		index;
>  		bool		seen;
> +		bool		str_seen;
>  		bool		convert;
>  		bool		is_power_2;
>  		int		conflicts[MAX_CONFLICTS];
> @@ -1470,14 +1475,17 @@ illegal_option(
>  	usage();
>  }
>  
> -static long long
> -getnum(
> -	const char		*str,
> +/*
> + * Check for conflicts and option respecification.
> + */
> +static void
> +check_opt(
>  	struct opt_params	*opts,
> -	int			index)
> +	int			index,
> +	bool			str_seen)
>  {
> -	struct subopt_param *sp = &opts->subopt_params[index];
> -	long long		c;
> +	struct subopt_param	*sp = &opts->subopt_params[index];
> +	int			i;
>  
>  	if (sp->index != index) {
>  		fprintf(stderr,
> @@ -1486,22 +1494,47 @@ getnum(
>  		reqval(opts->name, (char **)opts->subopts, index);
>  	}
>  
> -	/* check for respecification of the option */
> -	if (sp->seen)
> -		respec(opts->name, (char **)opts->subopts, index);
> -	sp->seen = true;
> +	/*
> +	 * Check for respecification of the option. This is more complex than it
> +	 * seems because some options are parsed twice - once as a string during
> +	 * input parsing, then later the string is passed to getnum for
> +	 * conversion into a number and bounds checking. Hence the two variables
> +	 * used to track the different uses based on the @str parameter passed
> +	 * to us.
> +	 */
> +	if (!str_seen) {
> +		if (sp->seen)
> +			respec(opts->name, (char **)opts->subopts, index);
> +		sp->seen = true;
> +	} else {
> +		if (sp->str_seen)
> +			respec(opts->name, (char **)opts->subopts, index);
> +		sp->str_seen = true;
> +	}
>  
>  	/* check for conflicts with the option */
> -	for (c = 0; c < MAX_CONFLICTS; c++) {
> -		int conflict_opt = sp->conflicts[c];
> +	for (i = 0; i < MAX_CONFLICTS; i++) {
> +		int conflict_opt = sp->conflicts[i];
>  
>  		if (conflict_opt == LAST_CONFLICT)
>  			break;
> -		if (opts->subopt_params[conflict_opt].seen)
> +		if (opts->subopt_params[conflict_opt].seen ||
> +			opts->subopt_params[conflict_opt].str_seen)
>  			conflict(opts->name, (char **)opts->subopts,
>  				 conflict_opt, index);
>  	}
> +}
>  
> +static long long
> +getnum(
> +	const char		*str,
> +	struct opt_params	*opts,
> +	int			index)
> +{
> +	struct subopt_param	*sp = &opts->subopt_params[index];
> +	long long		c;
> +
> +	check_opt(opts, index, false);
>  	/* empty strings might just return a default value */
>  	if (!str || *str == '\0') {
>  		if (sp->defaultval == SUBOPT_NEEDS_VAL)
> @@ -1543,6 +1576,26 @@ getnum(
>  	return c;
>  }
>  
> +/*
> + * Option is a string - do all the option table work, and check there
> + * is actually an option string. Otherwise we don't do anything with the string
> + * here - validation will be done later when the string is converted to a value
> + * or used as a file/device path.
> + */
> +static char *
> +getstr(
> +	char			*str,
> +	struct opt_params	*opts,
> +	int			index)
> +{
> +	check_opt(opts, index, true);
> +
> +	/* empty strings for string options are not valid */
> +	if (!str || *str == '\0')
> +		reqval(opts->name, (char **)opts->subopts, index);
> +	return str;
> +}
> +
>  int
>  main(
>  	int			argc,
> @@ -1738,18 +1791,10 @@ main(
>  						xi.dcreat = 1;
>  					break;
>  				case D_NAME:
> -					if (!value || *value == '\0')
> -						reqval('d', subopts, D_NAME);
> -					if (xi.dname)
> -						respec('d', subopts, D_NAME);
> -					xi.dname = value;
> +					xi.dname = getstr(value, &dopts, D_NAME);
>  					break;
>  				case D_SIZE:
> -					if (!value || *value == '\0')
> -						reqval('d', subopts, D_SIZE);
> -					if (dsize)
> -						respec('d', subopts, D_SIZE);
> -					dsize = value;
> +					dsize = getstr(value, &dopts, D_SIZE);
>  					break;
>  				case D_SUNIT:
>  					dsunit = getnum(value, &dopts, D_SUNIT);
> @@ -1890,18 +1935,10 @@ main(
>  					break;
>  				case L_NAME:
>  				case L_DEV:
> -					if (laflag)
> -						conflict('l', subopts, L_AGNUM, L_DEV);
> -					if (liflag)
> -						conflict('l', subopts, L_INTERNAL, L_DEV);
> -					if (!value || *value == '\0')
> -						reqval('l', subopts, L_NAME);
> -					if (xi.logname)
> -						respec('l', subopts, L_NAME);
> +					logfile = getstr(value, &lopts, L_NAME);
> +					xi.logname = logfile;
>  					ldflag = 1;
>  					loginternal = 0;
> -					logfile = value;
> -					xi.logname = value;
>  					break;
>  				case L_VERSION:
>  					sb_feat.log_version =
> @@ -1909,12 +1946,7 @@ main(
>  					lvflag = 1;
>  					break;
>  				case L_SIZE:
> -					if (!value || *value == '\0')
> -						reqval('l', subopts, L_SIZE);
> -					if (logsize)
> -						respec('l', subopts, L_SIZE);
> -					logsize = value;
> -					lsflag = 1;
> +					logsize = getstr(value, &lopts, L_SIZE);
>  					break;
>  				case L_SECTLOG:
>  					lsectorlog = getnum(value, &lopts,
> @@ -2000,10 +2032,7 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  					nsflag = 1;
>  					break;
>  				case N_VERSION:
> -					if (!value || *value == '\0')
> -						reqval('n', subopts, N_VERSION);
> -					if (nvflag)
> -						respec('n', subopts, N_VERSION);
> +					value = getstr(value, &nopts, N_VERSION);
>  					if (!strcasecmp(value, "ci")) {
>  						/* ASCII CI mode */
>  						sb_feat.nci = true;
> @@ -2052,11 +2081,8 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  				switch (getsubopt(&p, (constpp)subopts,
>  						  &value)) {
>  				case R_EXTSIZE:
> -					if (!value || *value == '\0')
> -						reqval('r', subopts, R_EXTSIZE);
> -					if (rtextsize)
> -						respec('r', subopts, R_EXTSIZE);
> -					rtextsize = value;
> +					rtextsize = getstr(value, &ropts,
> +							   R_EXTSIZE);
>  					break;
>  				case R_FILE:
>  					xi.risfile = getnum(value, &ropts,
> @@ -2066,18 +2092,11 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  					break;
>  				case R_NAME:
>  				case R_DEV:
> -					if (!value || *value == '\0')
> -						reqval('r', subopts, R_NAME);
> -					if (xi.rtname)
> -						respec('r', subopts, R_NAME);
> -					xi.rtname = value;
> +					xi.rtname = getstr(value, &ropts,
> +							   R_NAME);
>  					break;
>  				case R_SIZE:
> -					if (!value || *value == '\0')
> -						reqval('r', subopts, R_SIZE);
> -					if (rtsize)
> -						respec('r', subopts, R_SIZE);
> -					rtsize = value;
> +					rtsize = getstr(value, &ropts, R_SIZE);
>  					break;
>  				case R_NOALIGN:
>  					norsflag = getnum(value, &ropts,
> @@ -2137,13 +2156,7 @@ _("cannot specify both -m crc=1 and -n ftype\n"));
>  		fprintf(stderr, _("extra arguments\n"));
>  		usage();
>  	} else if (argc - optind == 1) {
> -		dfile = xi.volname = argv[optind];
> -		if (xi.dname) {
> -			fprintf(stderr,
> -				_("cannot specify both %s and -d name=%s\n"),
> -				xi.volname, xi.dname);
> -			usage();
> -		}
> +		dfile = xi.volname = getstr(argv[optind], &dopts, D_NAME);
>  	} else
>  		dfile = xi.dname;
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
