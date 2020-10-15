Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 474E1C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCD4E22248
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:24:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HbzAhr2H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgJOFYm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 01:24:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41496 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgJOFYm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 01:24:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5DvVX145857;
        Thu, 15 Oct 2020 05:24:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9pNgPQSTNft5DtQCdkzbkviVZcKH3zfO6s99NWQ/FbA=;
 b=HbzAhr2HBfvqnQ+lnDotJ8OgVLlDbiLhJ0Yw5k6MqjHWHF7ZhmufkBu+6iap2o1+lFF5
 AYUvOYFlnEEOIQrKdShNZsPco5KpBZwr19zthfWGuyoJtOGgFb6OcD8kf3dUEhr6NN+S
 t455VVOtw+fKBdD1jikaCHe9M6WcH8BNj29ICa8ekF0/4wspkq8HqJBo1I6RG55FkiTI
 W26iq5/bQ45ZpjDJg6ZwU/R59o85TPEAHY7AB5EOsazK0rSbFBrdGaeCqzOTJBMOR8YE
 dXy60gDU3C5oGA0hdixSf7OUHncoGCx9eMUMvmcW2yUQ1/mX1cOFBQckU/7mtfz/Cj9c vA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 343vaeh58n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 05:24:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5Eb4r002538;
        Thu, 15 Oct 2020 05:24:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 343pvyuntf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 05:24:39 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09F5Ochu001052;
        Thu, 15 Oct 2020 05:24:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Oct 2020 22:24:38 -0700
Date:   Wed, 14 Oct 2020 22:24:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] mkfs: hook up suboption parsing to ini files
Message-ID: <20201015052437.GN9832@magnolia>
References: <20201015032925.1574739-1-david@fromorbit.com>
 <20201015032925.1574739-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015032925.1574739-5-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=1 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150038
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 02:29:24PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now we have the config file parsing hooked up and feeding in
> parameters to mkfs, wire the parameters up to the existing CLI
> option parsing functions. THis gives the config file exactly the
> same capabilities and constraints as the command line option
> specification.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 95 +++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 80 insertions(+), 15 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 99ce0dc48d3b..370ac6194e2f 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -143,6 +143,13 @@ enum {
>   * name MANDATORY
>   *   Name is a single char, e.g., for '-d file', name is 'd'.
>   *
> + * ini_name MANDATORY
> + *   Name is a string, not longer than MAX_INI_NAME_LEN, that is used as the
> + *   section name for this option set in INI format config files. The only
> + *   option set this is not required for is the command line config file
> + *   specification options, everything else must be configurable via config
> + *   files.

I don't understand this last sentence.

OH, I get it:

"This field is required to connect each opt_params (that is to say, each
option class) to a section in the config file."

(and maybe a note in copts that config files cannot specify other config
files, so ini_name is not necessary there.)

> + *
>   * subopts MANDATORY
>   *   Subopts is a list of strings naming suboptions. In the example above,
>   *   it would contain "file". The last entry of this list has to be NULL.
> @@ -201,6 +208,8 @@ enum {
>   */
>  struct opt_params {
>  	const char	name;
> +#define MAX_INI_NAME_LEN	32
> +	const char	ini_name[MAX_INI_NAME_LEN];

How about "ini_section" ?

--D

>  	const char	*subopts[MAX_SUBOPTS];
>  
>  	struct subopt_param {
> @@ -228,6 +237,7 @@ static struct opt_params sopts;
>  
>  static struct opt_params bopts = {
>  	.name = 'b',
> +	.ini_name = "block",
>  	.subopts = {
>  		[B_SIZE] = "size",
>  	},
> @@ -267,6 +277,7 @@ static struct opt_params copts = {
>  
>  static struct opt_params dopts = {
>  	.name = 'd',
> +	.ini_name = "data",
>  	.subopts = {
>  		[D_AGCOUNT] = "agcount",
>  		[D_FILE] = "file",
> @@ -411,6 +422,7 @@ static struct opt_params dopts = {
>  
>  static struct opt_params iopts = {
>  	.name = 'i',
> +	.ini_name = "inode",
>  	.subopts = {
>  		[I_ALIGN] = "align",
>  		[I_MAXPCT] = "maxpct",
> @@ -472,6 +484,7 @@ static struct opt_params iopts = {
>  
>  static struct opt_params lopts = {
>  	.name = 'l',
> +	.ini_name = "log",
>  	.subopts = {
>  		[L_AGNUM] = "agnum",
>  		[L_INTERNAL] = "internal",
> @@ -571,6 +584,7 @@ static struct opt_params lopts = {
>  
>  static struct opt_params nopts = {
>  	.name = 'n',
> +	.ini_name = "naming",
>  	.subopts = {
>  		[N_SIZE] = "size",
>  		[N_VERSION] = "version",
> @@ -602,6 +616,7 @@ static struct opt_params nopts = {
>  
>  static struct opt_params ropts = {
>  	.name = 'r',
> +	.ini_name = "realtime",
>  	.subopts = {
>  		[R_EXTSIZE] = "extsize",
>  		[R_SIZE] = "size",
> @@ -652,6 +667,7 @@ static struct opt_params ropts = {
>  
>  static struct opt_params sopts = {
>  	.name = 's',
> +	.ini_name = "sector",
>  	.subopts = {
>  		[S_SIZE] = "size",
>  		[S_SECTSIZE] = "sectsize",
> @@ -682,6 +698,7 @@ static struct opt_params sopts = {
>  
>  static struct opt_params mopts = {
>  	.name = 'm',
> +	.ini_name = "metadata",
>  	.subopts = {
>  		[M_CRC] = "crc",
>  		[M_FINOBT] = "finobt",
> @@ -982,6 +999,17 @@ unknown(
>  	usage();
>  }
>  
> +static void
> +invalid_cfgfile_opt(
> +	const char	*filename,
> +	const char	*section,
> +	const char	*name,
> +	const char	*value)
> +{
> +	fprintf(stderr, _("%s: invalid config file option: [%s]:%s=%s\n"),
> +		filename, section, name, value);
> +}
> +
>  static void
>  check_device_type(
>  	const char	*name,
> @@ -1696,23 +1724,22 @@ sector_opts_parser(
>  }
>  
>  static struct subopts {
> -	char		opt;
>  	struct opt_params *opts;
>  	int		(*parser)(struct opt_params	*opts,
>  				  int			subopt,
>  				  const char		*value,
>  				  struct cli_params	*cli);
>  } subopt_tab[] = {
> -	{ 'b', &bopts, block_opts_parser },
> -	{ 'c', &copts, cfgfile_opts_parser },
> -	{ 'd', &dopts, data_opts_parser },
> -	{ 'i', &iopts, inode_opts_parser },
> -	{ 'l', &lopts, log_opts_parser },
> -	{ 'm', &mopts, meta_opts_parser },
> -	{ 'n', &nopts, naming_opts_parser },
> -	{ 'r', &ropts, rtdev_opts_parser },
> -	{ 's', &sopts, sector_opts_parser },
> -	{ '\0', NULL, NULL },
> +	{ &bopts, block_opts_parser },
> +	{ &copts, cfgfile_opts_parser },
> +	{ &dopts, data_opts_parser },
> +	{ &iopts, inode_opts_parser },
> +	{ &lopts, log_opts_parser },
> +	{ &mopts, meta_opts_parser },
> +	{ &nopts, naming_opts_parser },
> +	{ &ropts, rtdev_opts_parser },
> +	{ &sopts, sector_opts_parser },
> +	{ NULL, NULL },
>  };
>  
>  static void
> @@ -1726,7 +1753,7 @@ parse_subopts(
>  	int		ret = 0;
>  
>  	while (sop->opts) {
> -		if (sop->opt == opt)
> +		if (opt && sop->opts->name == opt)
>  			break;
>  		sop++;
>  	}
> @@ -1749,6 +1776,45 @@ parse_subopts(
>  	}
>  }
>  
> +static bool
> +parse_cfgopt(
> +	const char	*section,
> +	const char	*name,
> +	const char	*value,
> +	struct cli_params *cli)
> +{
> +	struct subopts	*sop = &subopt_tab[0];
> +	char		**subopts;
> +	int		ret = 0;
> +	int		i;
> +
> +	while (sop->opts) {
> +		if (sop->opts->ini_name[0] != '\0' &&
> +		    strcasecmp(section, sop->opts->ini_name) == 0)
> +			break;
> +		sop++;
> +	}
> +
> +	/* Config files with unknown sections get caught here. */
> +	if (!sop->opts)
> +		goto invalid_opt;
> +
> +	subopts = (char **)sop->opts->subopts;
> +	for (i = 0; i < MAX_SUBOPTS; i++) {
> +		if (!subopts[i])
> +			break;
> +		if (strcasecmp(name, subopts[i]) == 0) {
> +			ret = (sop->parser)(sop->opts, i, value, cli);
> +			if (ret)
> +				goto invalid_opt;
> +			return true;
> +		}
> +	}
> +invalid_opt:
> +	invalid_cfgfile_opt(cli->cfgfile, section, name, value);
> +	return false;
> +}
> +
>  static void
>  validate_sectorsize(
>  	struct mkfs_params	*cfg,
> @@ -3630,9 +3696,8 @@ cfgfile_parse_ini(
>  {
>  	struct cli_params	*cli = user;
>  
> -	fprintf(stderr, "Ini debug: file %s, section %s, name %s, value %s\n",
> -		cli->cfgfile, section, name, value);
> -
> +	if (!parse_cfgopt(section, name, value, cli))
> +		return 0;
>  	return 1;
>  }
>  
> -- 
> 2.28.0
> 
