Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159CDC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 13:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D393C20838
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 13:05:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eJVlFpHg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgJLNFk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 09:05:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728945AbgJLNFk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 09:05:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602507938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+p2c85GjJYleRFLpakl1Nseg+kY9rUxq6bUclTDdzVs=;
        b=eJVlFpHgiRvbPze6gK5TO8H0lgikGYgEggM06n9wOzxypWRiyAybcXyHNpDYZ3efWZRzhY
        Kbv+cxjAzmPA7ffinEm1wpLjFv+Vt7OcbZiDcMwxqseRHjk3esTTf1ewaQxFpL0YiKdLA+
        rQt6CUA25DopBmXno7/4JCekVWdGb8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-qYkGSJmkOpW8IkE10FqcZg-1; Mon, 12 Oct 2020 09:05:33 -0400
X-MC-Unique: qYkGSJmkOpW8IkE10FqcZg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D69691021207;
        Mon, 12 Oct 2020 13:05:32 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 42678277D7;
        Mon, 12 Oct 2020 13:05:26 +0000 (UTC)
Date:   Mon, 12 Oct 2020 09:05:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs: introduce xfs_validate_stripe_factors()
Message-ID: <20201012130524.GD917726@bfoster>
References: <20201009050546.32174-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009050546.32174-1-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 09, 2020 at 01:05:46PM +0800, Gao Xiang wrote:
> Introduce a common helper to consolidate stripe validation process.
> Also make kernel code xfs_validate_sb_common() use it first.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> 
> kernel side of:
> https://lore.kernel.org/r/20201007140402.14295-3-hsiangkao@aol.com
> with update suggested by Darrick:
>  - stretch columns for commit message;
>  - add comments to hasdalign check;
>  - break old sunit / swidth != 0 check into two seperate checks;
>  - update an error message description.
> 
> also use bytes for sunit / swidth representation, so users can
> see values in the unique unit.
> 
> see
> https://lore.kernel.org/r/20201007140402.14295-1-hsiangkao@aol.com
> for the background.
> 
>  fs/xfs/libxfs/xfs_sb.c | 65 +++++++++++++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_sb.h |  3 ++
>  2 files changed, 57 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 5aeafa59ed27..cb2a7aa0ad51 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
...
> @@ -1233,3 +1230,49 @@ xfs_sb_get_secondary(
>  	*bpp = bp;
>  	return 0;
>  }
> +
> +/*
> + * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
> + * so users won't be confused by values in error messages.
> + */
> +bool
> +xfs_validate_stripe_factors(

xfs_validate_stripe_geometry() perhaps?

> +	struct xfs_mount	*mp,
> +	__s64			sunit,
> +	__s64			swidth,
> +	int			sectorsize)
> +{
> +	if (sectorsize && sunit % sectorsize) {
> +		xfs_notice(mp,
> +"stripe unit (%lld) must be a multiple of the sector size (%d)",
> +			   sunit, sectorsize);
> +		return false;
> +	}
> +
> +	if (sunit && !swidth) {
> +		xfs_notice(mp,
> +"invalid stripe unit (%lld) and stripe width of 0", sunit);
> +		return false;
> +	}
> +
> +	if (!sunit && swidth) {
> +		xfs_notice(mp,
> +"invalid stripe width (%lld) and stripe unit of 0", swidth);
> +		return false;
> +	}

Seems like these two could be combined into one check that prints
something like:

	invalid stripe width (%lld) and stripe unit (%lld)

> +
> +	if (sunit > swidth) {
> +		xfs_notice(mp,
> +"stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
> +		return false;
> +	}
> +
> +	if (sunit && (swidth % sunit)) {
> +		xfs_notice(mp,
> +"stripe width (%lld) must be a multiple of the stripe unit (%lld)",
> +			   swidth, sunit);
> +		return false;
> +	}
> +	return true;
> +}
> +

Trailing whitespace here.

Otherwise looks reasonable outside of those nits.

Brian

> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 92465a9a5162..2d3504eb9886 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -42,4 +42,7 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
>  				struct xfs_trans *tp, xfs_agnumber_t agno,
>  				struct xfs_buf **bpp);
>  
> +extern bool	xfs_validate_stripe_factors(struct xfs_mount *mp,
> +				__s64 sunit, __s64 swidth, int sectorsize);
> +
>  #endif	/* __XFS_SB_H__ */
> -- 
> 2.18.1
> 

