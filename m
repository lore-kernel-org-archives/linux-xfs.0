Return-Path: <SRS0=ns7q=BN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9467AC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Aug 2020 15:28:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 691FE20775
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Aug 2020 15:28:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wHM6+W6k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgHCP2R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Aug 2020 11:28:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36774 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCP2Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Aug 2020 11:28:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 073FSDC6160031;
        Mon, 3 Aug 2020 15:28:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=thEmV8D+p9DER3c5ZzMVm2mRfWkGY1ts5zDFcrqePIk=;
 b=wHM6+W6kBAyCEQNBGn51eVX3x78rxDTOSi4MM9ss1cnrEn6a+sMnUM13gYEK9vs0nBV6
 32iC771VARkuS3QPurcGZpKhZBp1cgMB50apvUeEsyIfKf8IAhh7qi8p6bEI5xCzLq5D
 DD+85z8gPOzUoFi+I9MA0iNnYZBG/GOmQb+0uSNUicxLY8XyFgrrYs1PtCAoSl/eslrk
 U7EYCGsudSwRULPC/si92WRnNSyQAQrLw4T8M5Ero56xZZyW4Q6RPgsD1fapsJa8fmTE
 PpBkpS23NYu8FGkbmMsdAjB9guoPJSvvsFFGHRg81EhFOZdDC/K8h6zLHoOtm/3HkQtA kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32n11my1nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 03 Aug 2020 15:28:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 073FDhlS073948;
        Mon, 3 Aug 2020 15:26:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32njav3fhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Aug 2020 15:26:12 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 073FQBbq013147;
        Mon, 3 Aug 2020 15:26:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Aug 2020 08:26:11 -0700
Date:   Mon, 3 Aug 2020 08:26:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mkfs.xfs: introduce sunit/swidth validation helper
Message-ID: <20200803152609.GA67818@magnolia>
References: <a673fbd3-5038-2dc8-8135-a58c24042734@redhat.com>
 <20200803125018.16718-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803125018.16718-1-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9702 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9702 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008030116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 03, 2020 at 08:50:18PM +0800, Gao Xiang wrote:
> Currently stripe unit/width checking logic is all over xfsprogs.
> So, refactor the same code snippet into a single validation helper
> xfs_validate_stripe_factors(), including:
>  - integer overflows of either value
>  - sunit and swidth alignment wrt sector size
>  - if either sunit or swidth are zero, both should be zero
>  - swidth must be a multiple of sunit
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> 
> This patch follows Darrick's original suggestion [1], yet I'm
> not sure if I'm doing the right thing or if something is still
> missing (e.g the meaning of six(ish) places)... So post it
> right now...
> 
> TBH, especially all these naming and the helper location (whether
> in topology.c)...plus, click a dislike on calc_stripe_factors()
> itself...
> 
> (Hopefully hear some advice about this... Thanks!)
> 
> [1] https://lore.kernel.org/r/20200515204802.GO6714@magnolia
> 
>  libfrog/topology.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++
>  libfrog/topology.h | 15 ++++++++++++++
>  mkfs/xfs_mkfs.c    | 48 ++++++++++++++++++++++----------------------
>  3 files changed, 89 insertions(+), 24 deletions(-)
> 
> diff --git a/libfrog/topology.c b/libfrog/topology.c
> index b1b470c9..cf56fb03 100644
> --- a/libfrog/topology.c
> +++ b/libfrog/topology.c
> @@ -174,6 +174,41 @@ out:
>  	return ret;
>  }
>  
> +enum xfs_stripe_retcode
> +xfs_validate_stripe_factors(

libfrog functions (and enums) should be prefixed with libfrog, not xfs.

LIBFROG_STRIPEVAL_{OK,SUNIT_MISALIGN, etc.}

> +	int	sectorsize,
> +	int 	*sup,

Errant space between "int" and "*sup".

> +	int	*swp)

Strange that a validator function has out parameters...

Also, uh, .... full names, please.

	int	*sunitp,
	int	*swidthp)

(I'm vaguely wondering why we use signed ints here vs. unsigned, but
that isn't critical...)

> +{
> +	int sunit = *sup, swidth = *swp;
> +
> +	if (sectorsize) {
> +		long long	big_swidth;
> +
> +		if (sunit % sectorsize)
> +			return XFS_STRIPE_RET_SUNIT_MISALIGN;
> +
> +		sunit = (int)BTOBBT(sunit);

Hmm.  On input, *sup is in units of bytes, but on output it can be in
units of 512b blocks?  That is very surprising...

> +		big_swidth = (long long)sunit * swidth;
> +
> +		if (big_swidth > INT_MAX)
> +			return XFS_STRIPE_RET_SWIDTH_OVERFLOW;
> +		swidth = big_swidth;
> +	}
> +	if ((sunit && !swidth) || (!sunit && swidth))
> +		return XFS_STRIPE_RET_PARTIAL_VALID;
> +
> +	if (sunit > swidth)
> +		return XFS_STRIPE_RET_SUNIT_TOO_LARGE;
> +
> +	if (sunit && (swidth % sunit))
> +		return XFS_STRIPE_RET_SWIDTH_MISALIGN;
> +
> +	*sup = sunit;

...especially since in the !sectorsize case we don't change it at all.

> +	*swp = swidth;
> +	return XFS_STRIPE_RET_OK;
> +}
> +
>  static void blkid_get_topology(
>  	const char	*device,
>  	int		*sunit,
> @@ -229,6 +264,21 @@ static void blkid_get_topology(
>  	 */
>  	*sunit = *sunit >> 9;
>  	*swidth = *swidth >> 9;
> +	switch (xfs_validate_stripe_factors(0, sunit, swidth)) {
> +	case XFS_STRIPE_RET_OK:
> +		break;
> +	case XFS_STRIPE_RET_PARTIAL_VALID:
> +		fprintf(stderr,
> +_("%s: Volume reports stripe unit of %d bytes and stripe width of %d bytes, ignoring.\n"),
> +				progname, BBTOB(*sunit), BBTOB(*swidth));

Needs a "/* fallthrough */" comment here.

> +	default:

Why don't we warn about receiving garbage geometry that produces
MISALIGN or OVERFLOW?

> +		/*
> +		 * if firmware is broken, just give up and set both to zero,
> +		 * we can't trust information from this device.
> +		 */
> +		*sunit = 0;
> +		*swidth = 0;
> +	}
>  
>  	if (blkid_topology_get_alignment_offset(tp) != 0) {
>  		fprintf(stderr,
> diff --git a/libfrog/topology.h b/libfrog/topology.h
> index 6fde868a..e8be26b2 100644
> --- a/libfrog/topology.h
> +++ b/libfrog/topology.h
> @@ -36,4 +36,19 @@ extern int
>  check_overwrite(
>  	const char	*device);
>  
> +enum xfs_stripe_retcode {
> +	XFS_STRIPE_RET_OK = 0,
> +	XFS_STRIPE_RET_SUNIT_MISALIGN,
> +	XFS_STRIPE_RET_SWIDTH_OVERFLOW,
> +	XFS_STRIPE_RET_PARTIAL_VALID,
> +	XFS_STRIPE_RET_SUNIT_TOO_LARGE,
> +	XFS_STRIPE_RET_SWIDTH_MISALIGN,
> +};
> +
> +enum xfs_stripe_retcode
> +xfs_validate_stripe_factors(
> +	int	sectorsize,
> +	int 	*sup,

Errant space between "int" and "*sup".

> +	int	*swp);
> +
>  #endif	/* __LIBFROG_TOPOLOGY_H__ */
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 2e6cd280..a3d6032c 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2255,7 +2255,6 @@ calc_stripe_factors(
>  	struct cli_params	*cli,
>  	struct fs_topology	*ft)
>  {
> -	long long int	big_dswidth;
>  	int		dsunit = 0;
>  	int		dswidth = 0;
>  	int		lsunit = 0;
> @@ -2263,6 +2262,7 @@ calc_stripe_factors(
>  	int		dsw = 0;
>  	int		lsu = 0;
>  	bool		use_dev = false;
> +	int		error;
>  
>  	if (cli_opt_set(&dopts, D_SUNIT))
>  		dsunit = cli->dsunit;
> @@ -2289,31 +2289,40 @@ _("both data su and data sw options must be specified\n"));
>  			usage();
>  		}
>  
> -		if (dsu % cfg->sectorsize) {
> +		dsunit = dsu;
> +		dswidth = dsw;
> +		error = xfs_validate_stripe_factors(cfg->sectorsize, &dsunit, &dswidth);

I thought this function returned an enum?

> +		switch(error) {
> +		case XFS_STRIPE_RET_SUNIT_MISALIGN:
>  			fprintf(stderr,
>  _("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
>  			usage();
> -		}
> -
> -		dsunit  = (int)BTOBBT(dsu);
> -		big_dswidth = (long long int)dsunit * dsw;
> -		if (big_dswidth > INT_MAX) {
> +			break;
> +		case XFS_STRIPE_RET_SWIDTH_OVERFLOW:
>  			fprintf(stderr,
> -_("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
> -				big_dswidth, dsunit);
> +_("data stripe width (dsw %d) is too large of a multiple of the data stripe unit (%d)\n"),

Why change this message?

> +				dsw, dsunit);
>  			usage();
> +			break;
>  		}
> -		dswidth = big_dswidth;
> +	} else {
> +		error = xfs_validate_stripe_factors(0, &dsunit, &dswidth);
>  	}
>  
> -	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
> -	    (dsunit && (dswidth % dsunit != 0))) {
> +	if (error == XFS_STRIPE_RET_PARTIAL_VALID ||
> +	    error == XFS_STRIPE_RET_SWIDTH_MISALIGN) {
>  		fprintf(stderr,
>  _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
>  			dswidth, dsunit);
>  		usage();
>  	}
>  
> +	if (error) {
> +		fprintf(stderr,
> +_("invalid data stripe unit (%d), width (%d)\n"), dsunit, dswidth);

Invalid how?  We know the exact reason, so we should say so.

--D

> +		usage();
> +	}
> +
>  	/* If sunit & swidth were manually specified as 0, same as noalign */
>  	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
>  	    !dsunit && !dswidth)
> @@ -2328,18 +2337,9 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
>  
>  	/* if no stripe config set, use the device default */
>  	if (!dsunit) {
> -		/* Ignore nonsense from device.  XXX add more validation */
> -		if (ft->dsunit && ft->dswidth == 0) {
> -			fprintf(stderr,
> -_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
> -				progname, BBTOB(ft->dsunit));
> -			ft->dsunit = 0;
> -			ft->dswidth = 0;
> -		} else {
> -			dsunit = ft->dsunit;
> -			dswidth = ft->dswidth;
> -			use_dev = true;
> -		}
> +		dsunit = ft->dsunit;
> +		dswidth = ft->dswidth;
> +		use_dev = true;
>  	} else {
>  		/* check and warn if user-specified alignment is sub-optimal */
>  		if (ft->dsunit && ft->dsunit != dsunit) {
> -- 
> 2.18.1
> 
