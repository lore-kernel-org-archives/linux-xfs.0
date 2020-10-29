Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 269F2C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4C1D20838
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WG7G9hN8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgJ2VSk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 17:18:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47646 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgJ2VSj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 17:18:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TL9BTc006362;
        Thu, 29 Oct 2020 21:18:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bsYxchL/BTEB3cgmEWX7Vit2zZc5tdNCqZHy6Q4M22M=;
 b=WG7G9hN8B8b38Wmyeq7SPwz141JPGqXQUUSYtoXh1f1EkSJVKO+v3rrlQT7cZ9XfEXYK
 fTN1XNmCbRnunB/S9yDgUntQZzzwtAfnz5VfFbEyBp/FiFd3aXYT98qlAOD7zo+3fe+a
 8AYKjbXmCC/LvcBylkcXvPvZ+cXMVuRzLdx93wOyqK6lUToP9lzc3e03Bj3D88hrMDiy
 kiN4xgAPIuNLN0WhBjk9ZDH13bHyCbnKQQyCvhZOBE3ryyL6V1tp+iSoDc1BpwtRDLeg
 WKL0nYO5jL7qIWWPeeDB+LV3vxIbfbl/bj4GoXNeIDrs/7UUk6SP+5rlXoBIS4xHn8q6 wQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7m748n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 21:18:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TLAC2a062573;
        Thu, 29 Oct 2020 21:18:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx60yh6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 21:18:36 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TLIY6T006475;
        Thu, 29 Oct 2020 21:18:35 GMT
Received: from localhost (/10.159.244.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 14:18:34 -0700
Date:   Thu, 29 Oct 2020 14:18:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 4/5] mkfs: hook up suboption parsing to ini files
Message-ID: <20201029211833.GF1061252@magnolia>
References: <20201027205258.2824424-1-david@fromorbit.com>
 <20201027205258.2824424-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027205258.2824424-5-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 07:52:57AM +1100, Dave Chinner wrote:
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
>  mkfs/xfs_mkfs.c | 94 +++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 79 insertions(+), 15 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 829f0383b602..635a36f393b7 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -143,6 +143,12 @@ enum {
>   * name MANDATORY
>   *   Name is a single char, e.g., for '-d file', name is 'd'.
>   *
> + * ini_section MANDATORY
> + *   This field is required to connect each opt_params (that is to say, each
> + *   option class) to a section in the config file. The only option class this
> + *   is not required for is the config file specification class itself.
> + *   The section name is a string, not longer than MAX_INI_NAME_LEN.
> + *
>   * subopts MANDATORY
>   *   Subopts is a list of strings naming suboptions. In the example above,
>   *   it would contain "file". The last entry of this list has to be NULL.
> @@ -201,6 +207,8 @@ enum {
>   */
>  struct opt_params {
>  	const char	name;
> +#define MAX_INI_NAME_LEN	32
> +	const char	ini_section[MAX_INI_NAME_LEN];
>  	const char	*subopts[MAX_SUBOPTS];
>  
>  	struct subopt_param {
> @@ -228,6 +236,7 @@ static struct opt_params sopts;
>  
>  static struct opt_params bopts = {
>  	.name = 'b',
> +	.ini_section = "block",
>  	.subopts = {
>  		[B_SIZE] = "size",
>  	},
> @@ -267,6 +276,7 @@ static struct opt_params copts = {
>  
>  static struct opt_params dopts = {
>  	.name = 'd',
> +	.ini_section = "data",
>  	.subopts = {
>  		[D_AGCOUNT] = "agcount",
>  		[D_FILE] = "file",
> @@ -411,6 +421,7 @@ static struct opt_params dopts = {
>  
>  static struct opt_params iopts = {
>  	.name = 'i',
> +	.ini_section = "inode",
>  	.subopts = {
>  		[I_ALIGN] = "align",
>  		[I_MAXPCT] = "maxpct",
> @@ -472,6 +483,7 @@ static struct opt_params iopts = {
>  
>  static struct opt_params lopts = {
>  	.name = 'l',
> +	.ini_section = "log",
>  	.subopts = {
>  		[L_AGNUM] = "agnum",
>  		[L_INTERNAL] = "internal",
> @@ -571,6 +583,7 @@ static struct opt_params lopts = {
>  
>  static struct opt_params nopts = {
>  	.name = 'n',
> +	.ini_section = "naming",
>  	.subopts = {
>  		[N_SIZE] = "size",
>  		[N_VERSION] = "version",
> @@ -602,6 +615,7 @@ static struct opt_params nopts = {
>  
>  static struct opt_params ropts = {
>  	.name = 'r',
> +	.ini_section = "realtime",
>  	.subopts = {
>  		[R_EXTSIZE] = "extsize",
>  		[R_SIZE] = "size",
> @@ -652,6 +666,7 @@ static struct opt_params ropts = {
>  
>  static struct opt_params sopts = {
>  	.name = 's',
> +	.ini_section = "sector",
>  	.subopts = {
>  		[S_SIZE] = "size",
>  		[S_SECTSIZE] = "sectsize",
> @@ -682,6 +697,7 @@ static struct opt_params sopts = {
>  
>  static struct opt_params mopts = {
>  	.name = 'm',
> +	.ini_section = "metadata",
>  	.subopts = {
>  		[M_CRC] = "crc",
>  		[M_FINOBT] = "finobt",
> @@ -982,6 +998,17 @@ unknown(
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

Silly nit: space after the last colon.

"/etc/xfs.conf: invalid config file option: [metadata]: crc=0"

(A pity libinih doesn't tell you the line number...)

Also, does this really need a separate function since it's only called
from one place?

> +}
> +
>  static void
>  check_device_type(
>  	const char	*name,
> @@ -1696,23 +1723,22 @@ sector_opts_parser(
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
> @@ -1726,7 +1752,7 @@ parse_subopts(
>  	int		ret = 0;
>  
>  	while (sop->opts) {
> -		if (sop->opt == opt)
> +		if (opt && sop->opts->name == opt)

When does parse_subopts get passed a opt==0?  AFAICT the only caller is
the switch statement under getopt, which constrains c to one of
'bdilmnrsc'.

--D

>  			break;
>  		sop++;
>  	}
> @@ -1749,6 +1775,45 @@ parse_subopts(
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
> +		if (sop->opts->ini_section[0] != '\0' &&
> +		    strcasecmp(section, sop->opts->ini_section) == 0)
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
> @@ -3630,9 +3695,8 @@ cfgfile_parse_ini(
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
