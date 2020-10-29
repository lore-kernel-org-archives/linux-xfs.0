Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D65C4742C
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6F9D20791
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:07:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ehMY99pP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgJ2VHG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 17:07:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37052 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgJ2VHF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 17:07:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TL5cm0003340;
        Thu, 29 Oct 2020 21:07:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=rxU42wIs0tupRYk8JK0dLW1lZX8J2oHAnB+BfAiMNSo=;
 b=ehMY99pPbkwKpfGxAqcYWTLJJsNa41UraKKQVn4ZP9osN4QWOLX2WEZzi5UC/qjZJ8rz
 6qtj/KeIuMjk5yLfov1mXgkMVB1mKqFTvU2YAt4iq0hlZ4nm966ofyra4FQvCymid/Eo
 wAxL8HoDyyT3xWwJojA2Opfmd66oKHMnhhXwwB61CIiRwUt/tI/T4UVdjYwKRm4qy3Hi
 N0QSWvntz/xnmU2FPC6moCA2GfvVZUXpQt64t6cE9xZGYSJftNYPSXy7yj7yZe1B6Vfh
 VJlx7FafpxFGWlZRnqzWJpka99XNZMDarqc4Wf+/uET/ry/0WDyh6DGl9mpCOsm+AnMd qw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7m72c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 21:07:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TL6P68003526;
        Thu, 29 Oct 2020 21:07:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cx1tpb8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 21:07:02 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TL718F031818;
        Thu, 29 Oct 2020 21:07:01 GMT
Received: from localhost (/10.159.244.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 14:07:01 -0700
Date:   Thu, 29 Oct 2020 14:07:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/5] mkfs: add initial ini format config file parsing
 support
Message-ID: <20201029210700.GE1061252@magnolia>
References: <20201027205258.2824424-1-david@fromorbit.com>
 <20201027205258.2824424-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027205258.2824424-3-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290147
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 07:52:55AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add the framework that will allow the config file to be supplied on
> the CLI and passed to the library that will parse it. This does not
> yet do any option parsing from the config file.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  mkfs/Makefile   |   2 +-
>  mkfs/xfs_mkfs.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 119 insertions(+), 2 deletions(-)
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
> index 8fe149d74b0a..33be9ba16c90 100644
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
> + * mkfs.xfs -c options=<name>
> + *
> + * A subopt is used for the filename so in future we can extend the behaviour
> + * of the config file (e.g. specified defaults rather than options) if we ever
> + * have a need to do that sort of thing.
> + */
> +static struct opt_params copts = {
> +	.name = 'c',
> +	.subopts = {
> +		[C_OPTFILE] = "options",
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
> +/* config file */	[-c options=xxx]\n\
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
> @@ -3562,6 +3611,65 @@ check_root_ino(
>  	}
>  }
>  
> +/*
> + * INI file format option parser.
> + *
> + * This is called by the file parser library for every valid option it finds in
> + * the config file. The option is already broken down into a
> + * {section,name,value} tuple, so all we need to do is feed it to the correct
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
> +		} else if (error == -1) {
> +			fprintf(stderr,
> +		_("Unable to open config file %s. Aborting.\n"),
> +				cli->cfgfile);
> +		} else if (error == -2) {
> +			fprintf(stderr,
> +		_("Memory allocation failure parsing %s. Aborting.\n"),
> +				cli->cfgfile);
> +		} else {
> +			fprintf(stderr,
> +		_("Unknown error %d opening config file %s. Aborting.\n"),
> +				error, cli->cfgfile);
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
> @@ -3648,13 +3756,14 @@ main(
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
> @@ -3698,6 +3807,14 @@ main(
>  	} else
>  		dfile = xi.dname;
>  
> +	/*
> +	 * Now we have all the options parsed, we can read in the option file
> +	 * specified on the command line via "-c options=xxx". Once we have all
> +	 * the options from this file parsed, we can then proceed with parameter
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
