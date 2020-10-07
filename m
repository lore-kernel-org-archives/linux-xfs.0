Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DEFC4727E
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 22:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E3C32145D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 22:32:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BLwYFYgy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgJGWcx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 18:32:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60228 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728850AbgJGWcx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 18:32:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097MTSB5028328;
        Wed, 7 Oct 2020 22:32:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=XCQEKOYdxWzMneXH/yQQ57gYWlIEWLjeQolD0hP5zys=;
 b=BLwYFYgyni3aU4lA3yHzswXPvXHkTrhP+GqXG1fO2IZ7CKAg2W2hsBH+c/dTT98hXb2w
 mWY5KNQ96QTxrFvxmKMSOgJBK5D0WFyQFXBk2JTAzF+u9NMgaWgNs9O/BvyKaMb1RlXp
 hB6PeIf1P+r7E+gdJjeCyKuuqy+O3wOv/H1323O0PsNlGBtQV31Z8Sb3udoa095TFZoK
 LgkhDmAPcm5B8HuNOQn/9oXIO0XT7ulTFE2t7nct6WY6hbmyLR089GQmT3BIxnqLdzW7
 KrYJbGuWxmdAGjI5QAW8zDdB9v1LFvubJbwFy2e9D0MJObteDo7SaK9qnc6OkYnr47Fw FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33xhxn4mmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 22:32:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097MPEbW085800;
        Wed, 7 Oct 2020 22:30:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33yyjhswwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 22:30:46 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 097MUjAA012252;
        Wed, 7 Oct 2020 22:30:45 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 15:30:45 -0700
Date:   Wed, 7 Oct 2020 15:30:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH v4 3/3] xfsprogs: make use of
 xfs_validate_stripe_factors()
Message-ID: <20201007223044.GI6540@magnolia>
References: <20201007140402.14295-1-hsiangkao@aol.com>
 <20201007140402.14295-4-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007140402.14295-4-hsiangkao@aol.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070143
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 10:04:02PM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Check stripe numbers in calc_stripe_factors() by
> using xfs_validate_stripe_factors().
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 2e6cd280e388..b7f8f98147eb 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2289,12 +2289,6 @@ _("both data su and data sw options must be specified\n"));
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
> @@ -2306,13 +2300,9 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
>  		dswidth = big_dswidth;
>  	}
>  
> -	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
> -	    (dsunit && (dswidth % dsunit != 0))) {
> -		fprintf(stderr,
> -_("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
> -			dswidth, dsunit);
> +	if (!xfs_validate_stripe_factors(NULL, BBTOB(dsunit), BBTOB(dswidth),

if (!libxfs_validate_stripe_factors(...))

Unless we get rid of the weird libxfs macro thing, you're supposed to
use prefixes in userspace.

--D

> +					 cfg->sectorsize))
>  		usage();
> -	}
>  
>  	/* If sunit & swidth were manually specified as 0, same as noalign */
>  	if ((cli_opt_set(&dopts, D_SUNIT) || cli_opt_set(&dopts, D_SU)) &&
> @@ -2328,11 +2318,12 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
>  
>  	/* if no stripe config set, use the device default */
>  	if (!dsunit) {
> -		/* Ignore nonsense from device.  XXX add more validation */
> -		if (ft->dsunit && ft->dswidth == 0) {
> +		/* Ignore nonsense from device report. */
> +		if (!xfs_validate_stripe_factors(NULL, ft->dsunit,
> +						 ft->dswidth, 0)) {
>  			fprintf(stderr,
> -_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
> -				progname, BBTOB(ft->dsunit));
> +_("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\n"),
> +				progname, BBTOB(ft->dsunit), BBTOB(ft->dswidth));
>  			ft->dsunit = 0;
>  			ft->dswidth = 0;
>  		} else {
> -- 
> 2.24.0
> 
