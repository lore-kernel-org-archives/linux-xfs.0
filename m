Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2EE6C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2993E2224D
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:46:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XRRkS3cB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgJOFqk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 01:46:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39084 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbgJOFqk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 01:46:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5f0TQ128790;
        Thu, 15 Oct 2020 05:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xUcITC/cWK60YRCy7rxe+/4tK1fEy8vEsNw+mOPA1aA=;
 b=XRRkS3cBnc+phYlQ5Xkt+6mdJCETfNk+LAzTKuWFPOejcmgmfX12XV1jelXhypVd2pVT
 hD+A1G2+JbghtSm61BRIZJ0b/X24ZthFPiOW9OWeDr+rfv88ndrFLnUuNqNqW34FjD2d
 F1PCrH+44Lz3MV0MuD7Wjtw/Zw0RyIWDPzyRgi6+OQQiIUfVERB+0S5rH3SKLyi8lmP/
 ZpZICFYZSkdurhlorRRmqES5CAk03FKqlRvZelxraVq88WfapKQKvRVyHVHRwO/WH5y4
 UEhFS/Txkt9x3yYwvGN95i3HnTNpRnpsnOhBZF2HELQbfbhnWWSifDL+KwV7kaVb8XaE CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3434wktvbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 05:46:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5jjgt079492;
        Thu, 15 Oct 2020 05:46:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 343phqkgfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 05:46:36 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09F5kY3G026759;
        Thu, 15 Oct 2020 05:46:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Oct 2020 22:46:34 -0700
Date:   Wed, 14 Oct 2020 22:46:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] mkfs: add initial ini format config file parsing
 support
Message-ID: <20201015054633.GS9832@magnolia>
References: <20201015032925.1574739-1-david@fromorbit.com>
 <20201015032925.1574739-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015032925.1574739-3-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 02:29:22PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add the framework that will allow the config file to be supplied on
> the CLI and passed to the library that will parse it. This does not
> yet do any option parsing from the config file.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  mkfs/Makefile   |   2 +-
>  mkfs/xfs_mkfs.c | 115 +++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 115 insertions(+), 2 deletions(-)
> 
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index 31482b08d559..b8805f7e1ea1 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -11,7 +11,7 @@ HFILES =
>  CFILES = proto.c xfs_mkfs.c
>  
>  LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
> -	$(LIBUUID)
> +	$(LIBUUID) $(LIBINIH)
>  LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
>  LLDFLAGS = -static-libtool-libs
>  
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 8fe149d74b0a..e84be74fb100 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -11,6 +11,7 @@
>  #include "libfrog/fsgeom.h"
>  #include "libfrog/topology.h"
>  #include "libfrog/convert.h"
> +#include <ini.h>
>  
>  #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
>  #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
> @@ -44,6 +45,11 @@ enum {
>  	B_MAX_OPTS,
>  };
>  
> +enum {
> +	C_OPTFILE = 0,
> +	C_MAX_OPTS,
> +};
> +
>  enum {
>  	D_AGCOUNT = 0,
>  	D_FILE,
> @@ -237,6 +243,28 @@ static struct opt_params bopts = {
>  	},
>  };
>  
> +/*
> + * Config file specification. Usage is:
> + *
> + * mkfs.xfs -c file=<name>

I thought it was -c options=/dev/random ?

> + *
> + * A subopt is used for the filename so in future we can extend the behaviour
> + * of the config file (e.g. specified defaults rather than options) if we ever
> + * have a need to do that sort of thing.
> + */
> +static struct opt_params copts = {
> +	.name = 'c',
> +	.subopts = {
> +		[C_OPTFILE] = "options",

Sure looks that way here...

> +	},
> +	.subopt_params = {
> +		{ .index = C_OPTFILE,
> +		  .conflicts = { { NULL, LAST_CONFLICT } },
> +		  .defaultval = SUBOPT_NEEDS_VAL,
> +		},
> +	},
> +};
> +
>  static struct opt_params dopts = {
>  	.name = 'd',
>  	.subopts = {
> @@ -748,6 +776,8 @@ struct cli_params {
>  	int	sectorsize;
>  	int	blocksize;
>  
> +	char	*cfgfile;
> +
>  	/* parameters that depend on sector/block size being validated. */
>  	char	*dsize;
>  	char	*agsize;
> @@ -862,6 +892,7 @@ usage( void )
>  {
>  	fprintf(stderr, _("Usage: %s\n\
>  /* blocksize */		[-b size=num]\n\
> +/* config file */	[-c file=xxx]\n\

...but then we go back to -c file=...

>  /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
>  /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
>  			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
> @@ -1385,6 +1416,23 @@ block_opts_parser(
>  	return 0;
>  }
>  
> +static int
> +cfgfile_opts_parser(
> +	struct opt_params	*opts,
> +	int			subopt,
> +	char			*value,
> +	struct cli_params	*cli)
> +{
> +	switch (subopt) {
> +	case C_OPTFILE:
> +		cli->cfgfile = getstr(value, opts, subopt);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  static int
>  data_opts_parser(
>  	struct opt_params	*opts,
> @@ -1656,6 +1704,7 @@ static struct subopts {
>  				  struct cli_params	*cli);
>  } subopt_tab[] = {
>  	{ 'b', &bopts, block_opts_parser },
> +	{ 'c', &copts, cfgfile_opts_parser },
>  	{ 'd', &dopts, data_opts_parser },
>  	{ 'i', &iopts, inode_opts_parser },
>  	{ 'l', &lopts, log_opts_parser },
> @@ -3562,6 +3611,61 @@ check_root_ino(
>  	}
>  }
>  
> +/*
> + * INI file format option parser.
> + *
> + * This is called by the file parser library for every valid option it finds in
> + * the config file. The option is already broken down into a
> + * {section,name,value} tuple, so all we need to do is feed it to the correct

XFS, SAX style.

> + * suboption parser function and translate the return value.
> + *
> + * Returns 0 on failure, 1 for success.
> + */
> +static int
> +cfgfile_parse_ini(
> +	void			*user,
> +	const char		*section,
> +	const char		*name,
> +	const char		*value)
> +{
> +	struct cli_params	*cli = user;
> +
> +	fprintf(stderr, "Ini debug: file %s, section %s, name %s, value %s\n",
> +		cli->cfgfile, section, name, value);
> +
> +	return 1;
> +}
> +
> +void
> +cfgfile_parse(
> +	struct cli_params	*cli)
> +{
> +	int			error;
> +
> +	if (!cli->cfgfile)
> +		return;
> +
> +	error = ini_parse(cli->cfgfile, cfgfile_parse_ini, cli);
> +	if (error) {
> +		if (error > 0) {
> +			fprintf(stderr,
> +		_("%s: Unrecognised input on line %d. Aborting.\n"),
> +				cli->cfgfile, error);
> +		} else if (error == -2) {
> +			fprintf(stderr,
> +		_("Memory allocation failure parsing %s. Aborting.\n"),
> +				cli->cfgfile);
> +		} else {
> +			fprintf(stderr,
> +		_("Unable to open config file %s. Aborting.\n"),
> +				cli->cfgfile);

I worry about libinih someday defining more negative error codes.  -1 is
"open failed", -2 is OOM, and positive is the line number of a parsing
error, at least according to the documentation.

Maybe we should handle -1 specifically and use the else as a catchall
for unrecognized error codes?

> +		}
> +		exit(1);
> +	}
> +	printf(_("Parameters parsed from config file %s successfully\n"),
> +		cli->cfgfile);
> +}
> +
>  int
>  main(
>  	int			argc,
> @@ -3648,13 +3752,14 @@ main(
>  	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
>  	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
>  
> -	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
>  		switch (c) {
>  		case 'C':
>  		case 'f':
>  			force_overwrite = 1;
>  			break;
>  		case 'b':
> +		case 'c':
>  		case 'd':
>  		case 'i':
>  		case 'l':
> @@ -3698,6 +3803,14 @@ main(
>  	} else
>  		dfile = xi.dname;
>  
> +	/*
> +	 * Now we have all the options parsed, we can read in the option file
> +	 * specified on the command line via "-c file=xxx". Once we have all the

-c options=xxx?

--D

> +	 * options from this file parsed, we can then proceed with parameter
> +	 * and bounds checking and making the filesystem.
> +	 */
> +	cfgfile_parse(&cli);
> +
>  	protostring = setup_proto(protofile);
>  
>  	/*
> -- 
> 2.28.0
> 
