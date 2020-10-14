Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107CAC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 16:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5009214D8
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 16:19:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fNVNpdGk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgJNQTk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 12:19:40 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60242 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbgJNQTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 12:19:39 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09EGEdO1161282;
        Wed, 14 Oct 2020 16:19:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=dxy7TWFSlF+Zw9+PEVgiUMD1RDwdJn3y8HmadbGLpNY=;
 b=fNVNpdGkJZo0dzmcDY9CnGZJy6ZgZq1EdOZR42S8mg7bXsO2K5c9eU/K59ktcdtFLwQi
 L1JeoZyLnlm7IrtVSPSf94jeSmjT34w1pD+HnQxzPV9Dj8oi1u+3Biz+NiTugdgkigy2
 IKy740AcibO2e+5Uwnwnb9naWcAJrZtlkN6HY2KG775Pxoymksc7ArDtepDGCvCO1Ku6
 a4k5sWLh0rTGimjaj5ghZBA46wSKLaVtimc2xYVbU5MBZQ3gtG8GT2vNNSPqY7W4zjCY
 5T2NJjWNZsJOew8oJEUowwZ9hgG7O6xN19CRPT7vbBgg3L3qZHHUltbNt73wPYARzPJE Bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 343pajy4j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Oct 2020 16:19:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09EGJYwM181217;
        Wed, 14 Oct 2020 16:19:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 344by3vpj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Oct 2020 16:19:34 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09EGJNv5031275;
        Wed, 14 Oct 2020 16:19:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Oct 2020 09:19:23 -0700
Date:   Wed, 14 Oct 2020 09:19:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 RESEND] xfs: introduce xfs_validate_stripe_geometry()
Message-ID: <20201014161922.GG9832@magnolia>
References: <20201013231359.12860-1-hsiangkao@redhat.com>
 <20201014074550.20552-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014074550.20552-1-hsiangkao@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140115
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 14, 2020 at 03:45:50PM +0800, Gao Xiang wrote:
> Introduce a common helper to consolidate stripe validation process.
> Also make kernel code xfs_validate_sb_common() use it first.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> [v3 RESEND]:
>  sorry forget to drop a pair of unnecessary brace brackets.
> 
> v2: https://lore.kernel.org/r/20201013034853.28236-1-hsiangkao@redhat.com
> 
> Changes since v2:
>  - update the expression on sb_unit and hasdalign check (Brian);
>  - drop parentheses since modulus operation is a basic
>    math operation (Brian);
>  - (I missed earlier..) avoid div_s64_rem on modulus operation
>    by checking swidth, sunit range first and casting to 32-bit
>    integer. since sunit/swidth in the callers are in FSB or BB,
>    so need to check the overflow first...
> 
> Anyway, since logic change is made due to div_s64_rem() issue,
> please kindly help review again...
> 
> Thanks,
> Gao Xiang
> 
>  fs/xfs/libxfs/xfs_sb.c | 77 ++++++++++++++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_sb.h |  3 ++
>  2 files changed, 69 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 5aeafa59ed27..2078f4fe93b2 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -360,21 +360,18 @@ xfs_validate_sb_common(
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
> +	/*
> +	 * Either (sb_unit and !hasdalign) or (!sb_unit and hasdalign)
> +	 * would imply the image is corrupted.
> +	 */
> +	if (!!sbp->sb_unit ^ xfs_sb_version_hasdalign(sbp)) {
>  		xfs_notice(mp, "SB stripe alignment sanity check failed");
>  		return -EFSCORRUPTED;
> -	} else if (sbp->sb_width) {
> -		xfs_notice(mp, "SB stripe width sanity check failed");
> -		return -EFSCORRUPTED;
>  	}
>  
> +	if (!xfs_validate_stripe_geometry(mp, XFS_FSB_TO_B(mp, sbp->sb_unit),
> +			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
> +		return -EFSCORRUPTED;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
> @@ -1233,3 +1230,61 @@ xfs_sb_get_secondary(
>  	*bpp = bp;
>  	return 0;
>  }
> +
> +/*
> + * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
> + * so users won't be confused by values in error messages.
> + */
> +bool
> +xfs_validate_stripe_geometry(
> +	struct xfs_mount	*mp,
> +	__s64			sunit,
> +	__s64			swidth,
> +	int			sectorsize,
> +	bool			silent)
> +{
> +	if (swidth > INT_MAX) {
> +		if (!silent)
> +			xfs_notice(mp,
> +"stripe width (%lld) is too large", swidth);
> +		return false;
> +	}
> +
> +	if (sunit > swidth) {
> +		if (!silent)
> +			xfs_notice(mp,
> +"stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
> +		return false;
> +	}
> +
> +	if (sectorsize && (int)sunit % sectorsize) {
> +		if (!silent)
> +			xfs_notice(mp,
> +"stripe unit (%lld) must be a multiple of the sector size (%d)",
> +				   sunit, sectorsize);
> +		return false;
> +	}
> +
> +	if (sunit && !swidth) {
> +		if (!silent)
> +			xfs_notice(mp,
> +"invalid stripe unit (%lld) and stripe width of 0", sunit);
> +		return false;
> +	}
> +
> +	if (!sunit && swidth) {
> +		if (!silent)
> +			xfs_notice(mp,
> +"invalid stripe width (%lld) and stripe unit of 0", swidth);
> +		return false;
> +	}
> +
> +	if (sunit && (int)swidth % (int)sunit) {
> +		if (!silent)
> +			xfs_notice(mp,
> +"stripe width (%lld) must be a multiple of the stripe unit (%lld)",
> +				   swidth, sunit);
> +		return false;
> +	}
> +	return true;
> +}
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 92465a9a5162..f79f9dc632b6 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -42,4 +42,7 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
>  				struct xfs_trans *tp, xfs_agnumber_t agno,
>  				struct xfs_buf **bpp);
>  
> +extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
> +		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
> +
>  #endif	/* __XFS_SB_H__ */
> -- 
> 2.18.1
> 
