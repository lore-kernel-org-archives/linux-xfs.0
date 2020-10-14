Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408A0C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 13:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD98E22202
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 13:24:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hq8eU0bO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgJNNY3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 09:24:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbgJNNY3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 09:24:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602681867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i61pPzlOaxTYHsxwvO0oPo8rq2LFIug8bibcHO71oDw=;
        b=hq8eU0bORllehxmvz2GwFP57SUcdB3L4m0m3GMy/YclgFHkW5+8sjP77g5RmrDVeH/jWV8
        51hDYKdQaa29OAN4vcSbnX3n+RZRRloRFWw82mjD7dw06+yI3aksbpFE6VSAhk9qgrNVEs
        J7wr6roXuQwL8YdPYyiUgVHGMDmBed8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-qk4CvyEaMtWRPoVEb6rK5Q-1; Wed, 14 Oct 2020 09:24:23 -0400
X-MC-Unique: qk4CvyEaMtWRPoVEb6rK5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F8B7835B58;
        Wed, 14 Oct 2020 13:24:22 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BCC046EF68;
        Wed, 14 Oct 2020 13:24:15 +0000 (UTC)
Date:   Wed, 14 Oct 2020 09:24:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 RESEND] xfs: introduce xfs_validate_stripe_geometry()
Message-ID: <20201014132413.GB1109375@bfoster>
References: <20201013231359.12860-1-hsiangkao@redhat.com>
 <20201014074550.20552-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014074550.20552-1-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 14, 2020 at 03:45:50PM +0800, Gao Xiang wrote:
> Introduce a common helper to consolidate stripe validation process.
> Also make kernel code xfs_validate_sb_common() use it first.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

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

