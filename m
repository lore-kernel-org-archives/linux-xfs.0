Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E0DC433E7
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 16:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C894206D9
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 16:22:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z/MxtnHl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgJNQWf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 12:22:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34548 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgJNQWf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 12:22:35 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09EGEWgF161213;
        Wed, 14 Oct 2020 16:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+9CMLrDFXUMlxvhxdWhwvZNCoIxBDp5BN8YnC9VZlIM=;
 b=Z/MxtnHlvNEQHWESx93vw2jJrjVUrIhTmmRvvXwPL/EjV2DL4JpWMCrwKrqfRnDjPWDP
 GaH6TW9akHQap3USabQaxFFDnCTCOZc/6Pnx/wo6eodcLoLL04lgMmahwMZopUtAYFu1
 ns1mre8aPZfHYMVfY947glTsaSKk/5zYkIvlbAlAlBxoCQBlmp09F6fniCi+3exKW19l
 wSCoy6U2vOIJSjb1BKScc/kw85cPr+qdvUs/yJmerBEKM749cwUeEui205C70ofEi59h
 ukx2KTRqH1VeAxrOldZPmcpM7pHQmpSPN0Mo5VGMoUefzFqxr+LrbI3YFb4kKmzj0+41 xA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 343pajy50h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Oct 2020 16:22:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09EGFG8h130943;
        Wed, 14 Oct 2020 16:20:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 343pv0jm5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Oct 2020 16:20:31 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09EGKUCL020952;
        Wed, 14 Oct 2020 16:20:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Oct 2020 09:20:30 -0700
Date:   Wed, 14 Oct 2020 09:20:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 3/3] mkfs: make use of xfs_validate_stripe_geometry()
Message-ID: <20201014162029.GH9832@magnolia>
References: <20201013040627.13932-1-hsiangkao@redhat.com>
 <20201013040627.13932-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013040627.13932-4-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=1 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010140115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=1
 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140115
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 13, 2020 at 12:06:27PM +0800, Gao Xiang wrote:
> Check stripe numbers in calc_stripe_factors() by using
> xfs_validate_stripe_geometry().
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  libxfs/libxfs_api_defs.h |  1 +
>  mkfs/xfs_mkfs.c          | 23 +++++++----------------
>  2 files changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index e7e42e93..306d0deb 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -188,6 +188,7 @@
>  #define xfs_trans_roll_inode		libxfs_trans_roll_inode
>  #define xfs_trans_roll			libxfs_trans_roll
>  
> +#define xfs_validate_stripe_geometry	libxfs_validate_stripe_geometry
>  #define xfs_verify_agbno		libxfs_verify_agbno
>  #define xfs_verify_agino		libxfs_verify_agino
>  #define xfs_verify_cksum		libxfs_verify_cksum
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 8fe149d7..aec40c1f 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2305,12 +2305,6 @@ _("both data su and data sw options must be specified\n"));
>  			usage();
>  		}
>  
> -		if (dsu % cfg->sectorsize) {
> -			fprintf(stderr,
> -_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
> -			usage();
> -		}
> -
>  		dsunit  = (int)BTOBBT(dsu);
>  		big_dswidth = (long long int)dsunit * dsw;
>  		if (big_dswidth > INT_MAX) {
> @@ -2322,13 +2316,9 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
>  		dswidth = big_dswidth;
>  	}
>  
> -	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
> -	    (dsunit && (dswidth % dsunit != 0))) {
> -		fprintf(stderr,
> -_("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
> -			dswidth, dsunit);
> +	if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit), BBTOB(dswidth),
> +					     cfg->sectorsize, false))
>  		usage();
> -	}
>  
>  	/* If sunit & swidth were manually specified as 0, same as noalign */
>  	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
> @@ -2344,11 +2334,12 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
>  
>  	/* if no stripe config set, use the device default */
>  	if (!dsunit) {
> -		/* Ignore nonsense from device.  XXX add more validation */
> -		if (ft->dsunit && ft->dswidth == 0) {
> +		/* Ignore nonsense from device report. */
> +		if (!libxfs_validate_stripe_geometry(NULL, BBTOB(ft->dsunit),
> +				BBTOB(ft->dswidth), 0, true)) {
>  			fprintf(stderr,
> -_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
> -				progname, BBTOB(ft->dsunit));
> +_("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\n"),
> +				progname, BBTOB(ft->dsunit), BBTOB(ft->dswidth));
>  			ft->dsunit = 0;
>  			ft->dswidth = 0;
>  		} else {
> -- 
> 2.18.1
> 
