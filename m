Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A07C433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 13:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FAA624758
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 13:44:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JjENBZMW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387694AbgJMNo2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 09:44:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53364 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387620AbgJMNo2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 09:44:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602596667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o6u45f194HLj0LglCkbehExUEI4TfmIU4dOq8rG3VVA=;
        b=JjENBZMWKxB3V6Hc8z62a1s8ueGk3AN+eCZ5ApP9LoYzW8gXFxcMBFXvWBIqDFF8JMdMTN
        497mXYH9HO3sDhIULm1kTlaVWu9iRvVCFSZjQWTSkC3pTXMycDsMuR6teC6JBCrBrXhmQ2
        ywconHOTMiBD8+tirIOufu6FOTDgZ7E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-NadZeOszPXG1NFszE4OpOA-1; Tue, 13 Oct 2020 09:44:25 -0400
X-MC-Unique: NadZeOszPXG1NFszE4OpOA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1BC0803F4D;
        Tue, 13 Oct 2020 13:44:23 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB15D5C1C2;
        Tue, 13 Oct 2020 13:44:13 +0000 (UTC)
Date:   Tue, 13 Oct 2020 09:44:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: introduce xfs_validate_stripe_geometry()
Message-ID: <20201013134411.GE966478@bfoster>
References: <20201013034853.28236-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013034853.28236-1-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 13, 2020 at 11:48:53AM +0800, Gao Xiang wrote:
> Introduce a common helper to consolidate stripe validation process.
> Also make kernel code xfs_validate_sb_common() use it first.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> v1: https://lore.kernel.org/r/20201009050546.32174-1-hsiangkao@redhat.com
> 
> changes since v1:
>  - rename the helper to xfs_validate_stripe_geometry() (Brian);
>  - drop a new added trailing newline in xfs_sb.c (Brian);
>  - add a "bool silent" argument to avoid too many error messages (Brian).
> 
>  fs/xfs/libxfs/xfs_sb.c | 70 +++++++++++++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_sb.h |  3 ++
>  2 files changed, 62 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 5aeafa59ed27..9178715ded45 100644
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
> +	if (!sbp->sb_unit ^ !xfs_sb_version_hasdalign(sbp)) {

This can be simplified to drop the negations (!), right?

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
> @@ -1233,3 +1230,54 @@ xfs_sb_get_secondary(
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
> +	if (sectorsize && sunit % sectorsize) {
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
> +	if (sunit > swidth) {
> +		if (!silent)
> +			xfs_notice(mp,
> +"stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
> +		return false;
> +	}
> +
> +	if (sunit && (swidth % sunit)) {

It might be good to use (or not) params consistently. I.e., the
sectorsize check earlier in the function has similar logic structure but
drops the params.

Those nits aside:

Reviewed-by: Brian Foster <bfoster@redhat.com>

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

