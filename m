Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D96C4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 22:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D173C20882
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 22:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nYDRQnXn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgJGW3v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 18:29:51 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34124 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728850AbgJGW3v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 18:29:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097MP7SC194796;
        Wed, 7 Oct 2020 22:29:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qzubscNpoQ7NBElsVECGCC8UplAJk2oSCbUyDKht6lg=;
 b=nYDRQnXn2fgBnSdvzO0dTU/Bw8xuGOMD910+PIaS8p6a5kvbJe+RCiaomBEeHncihYNS
 PhpHSdSrIXYwKTHDYvsw77T5iuzjNC7vA97hJn5d5F3qsghuEa0G1E02NxnfwlcGHe6A
 kYzel2v0P4m3p2GBuz2L5RWmUPa5S3oGQvsTSe5bpwLBl6UBSw7RgLYHkOJw5bMNBbUc
 +RsU4r3b90iUpyHMO/2KItJzk9ZMIUxTQ4zKVq8NmpHKp8rSNrbeEU9dYk+V/zytsDzg
 pQlV1ttAaohttQ/llDPgGfYRLtLBMQyhkQa//kVb40bTOEAKMaMArNaLqqsVgjvYa4OD cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33xetb4ust-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 22:29:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097MQCBQ026845;
        Wed, 7 Oct 2020 22:29:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33y38059yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 22:29:44 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 097MTitk011730;
        Wed, 7 Oct 2020 22:29:44 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 15:29:43 -0700
Date:   Wed, 7 Oct 2020 15:29:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: Re: [PATCH v4 2/3] xfs: introduce xfs_validate_stripe_factors()
Message-ID: <20201007222942.GH6540@magnolia>
References: <20201007140402.14295-1-hsiangkao@aol.com>
 <20201007140402.14295-3-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007140402.14295-3-hsiangkao@aol.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070142
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 10:04:01PM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Introduce a common helper to consolidate
> stripe validation process. Also make kernel
> code xfs_validate_sb_common() use it first.

Please use all 72(?) columns here.

> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  libxfs/xfs_sb.c | 54 +++++++++++++++++++++++++++++++++++++++----------
>  libxfs/xfs_sb.h |  3 +++

These libxfs changes will have to go through the kernel first.

>  2 files changed, 46 insertions(+), 11 deletions(-)
> 
> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> index d37d60b39a52..bd65828c844e 100644
> --- a/libxfs/xfs_sb.c
> +++ b/libxfs/xfs_sb.c
> @@ -357,21 +357,13 @@ xfs_validate_sb_common(
>  		}
>  	}
>  
> -	if (sbp->sb_unit) {
> -		if (!xfs_sb_version_hasdalign(sbp) ||
> -		    sbp->sb_unit > sbp->sb_width ||
> -		    (sbp->sb_width % sbp->sb_unit) != 0) {
> -			xfs_notice(mp, "SB stripe unit sanity check failed");
> -			return -EFSCORRUPTED;
> -		}
> -	} else if (xfs_sb_version_hasdalign(sbp)) {
> +	if (!sbp->sb_unit ^ !xfs_sb_version_hasdalign(sbp)) {

Urgh, this logic makes my brain hurt.

"If the zeroness of sb_unit differs from the unsetness of the dalign
feature"?  This might need some kind of comment, such as:

	/*
	 * Either sb_unit and hasdalign are both set, or they are zero
	 * and not set, respectively.
	 */
	if (!sbp->sb_unit ^ !xfs_sb_version_hasdalign(sbp)) {

>  		xfs_notice(mp, "SB stripe alignment sanity check failed");
>  		return -EFSCORRUPTED;
> -	} else if (sbp->sb_width) {
> -		xfs_notice(mp, "SB stripe width sanity check failed");
> -		return -EFSCORRUPTED;
>  	}
>  
> +	if (!xfs_validate_stripe_factors(mp, sbp->sb_unit, sbp->sb_width, 0))
> +		return -EFSCORRUPTED;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
> @@ -1208,3 +1200,43 @@ xfs_sb_get_secondary(
>  	*bpp = bp;
>  	return 0;
>  }
> +
> +/*
> + * If sectorsize is specified, sunit / swidth must be in bytes;
> + * or both can be in any kind of units (e.g. 512B sector or blocksize).
> + */
> +bool
> +xfs_validate_stripe_factors(
> +	struct xfs_mount	*mp,
> +	int			sunit,
> +	int			swidth,
> +	int			sectorsize)
> +{
> +	if (sectorsize && sunit % sectorsize) {
> +		xfs_notice(mp,
> +"stripe unit (%d) must be a multiple of the sector size (%d)",
> +			   sunit, sectorsize);
> +		return false;
> +	}
> +
> +	if ((sunit && !swidth) || (!sunit && swidth)) {
> +		xfs_notice(mp,
> +"stripe unit (%d) and width (%d) are partially valid", sunit, swidth);

I would break these into separate checks and messages.

> +		return false;
> +	}
> +
> +	if (sunit > swidth) {
> +		xfs_notice(mp,
> +"stripe unit (%d) is too large of the stripe width (%d)", sunit, swidth);

"stripe unit (%d) is larger than the stripe width..."

--D

> +		return false;
> +	}
> +
> +	if (sunit && (swidth % sunit)) {
> +		xfs_notice(mp,
> +"stripe width (%d) must be a multiple of the stripe unit (%d)",
> +			   swidth, sunit);
> +		return false;
> +	}
> +	return true;
> +}
> +
> diff --git a/libxfs/xfs_sb.h b/libxfs/xfs_sb.h
> index 92465a9a5162..015b2605f587 100644
> --- a/libxfs/xfs_sb.h
> +++ b/libxfs/xfs_sb.h
> @@ -42,4 +42,7 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
>  				struct xfs_trans *tp, xfs_agnumber_t agno,
>  				struct xfs_buf **bpp);
>  
> +extern bool	xfs_validate_stripe_factors(struct xfs_mount *mp,
> +				int sunit, int swidth, int sectorsize);
> +
>  #endif	/* __XFS_SB_H__ */
> -- 
> 2.24.0
> 
