Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9EA1C43381
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 01:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EF4764DBD
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 01:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbhBXBHS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 20:07:18 -0500
Received: from sandeen.net ([63.231.237.45]:59728 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234241AbhBXALj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Feb 2021 19:11:39 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 49CA25A10B8;
        Tue, 23 Feb 2021 18:10:32 -0600 (CST)
Subject: Re: [PATCH v7 3/3] mkfs: make use of xfs_validate_stripe_geometry()
To:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
References: <20201013040627.13932-4-hsiangkao@redhat.com>
 <20210219013734.428396-1-hsiangkao@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e703b458-63a5-e68c-aec3-5a28c5c0d27f@sandeen.net>
Date:   Tue, 23 Feb 2021 18:10:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210219013734.428396-1-hsiangkao@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/18/21 7:37 PM, Gao Xiang wrote:
> Check stripe numbers in calc_stripe_factors() by using
> xfs_validate_stripe_geometry().
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

I think this is good to go now, thank you.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

-Eric

> ---
> changes since v6:
>  - fix dsu round-down issue (the related print message has also
>    been turned into bytes to avoid round-down issue);
>  - rebase on for-next.
> 
>  libxfs/libxfs_api_defs.h |  1 +
>  mkfs/xfs_mkfs.c          | 35 +++++++++++++++--------------------
>  2 files changed, 16 insertions(+), 20 deletions(-)
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 9a00ce66..e4192e1b 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -192,6 +192,7 @@
>  #define xfs_trans_roll			libxfs_trans_roll
>  #define xfs_trim_extent			libxfs_trim_extent
>  
> +#define xfs_validate_stripe_geometry	libxfs_validate_stripe_geometry
>  #define xfs_verify_agbno		libxfs_verify_agbno
>  #define xfs_verify_agino		libxfs_verify_agino
>  #define xfs_verify_cksum		libxfs_verify_cksum
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index d72d21ef..dcdd5262 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2361,28 +2361,22 @@ _("both data su and data sw options must be specified\n"));
>  			usage();
>  		}
>  
> -		if (dsu % cfg->sectorsize) {
> +		big_dswidth = (long long int)dsu * dsw;
> +		if (BTOBBT(big_dswidth) > INT_MAX) {
>  			fprintf(stderr,
> -_("data su must be a multiple of the sector size (%d)\n"), cfg->sectorsize);
> +_("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
> +				big_dswidth, dsu);
>  			usage();
>  		}
>  
> -		dsunit  = (int)BTOBBT(dsu);
> -		big_dswidth = (long long int)dsunit * dsw;
> -		if (big_dswidth > INT_MAX) {
> -			fprintf(stderr,
> -_("data stripe width (%lld) is too large of a multiple of the data stripe unit (%d)\n"),
> -				big_dswidth, dsunit);
> +		if (!libxfs_validate_stripe_geometry(NULL, dsu, big_dswidth,
> +						     cfg->sectorsize, false))
>  			usage();
> -		}
> -		dswidth = big_dswidth;
> -	}
>  
> -	if ((dsunit && !dswidth) || (!dsunit && dswidth) ||
> -	    (dsunit && (dswidth % dsunit != 0))) {
> -		fprintf(stderr,
> -_("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
> -			dswidth, dsunit);
> +		dsunit = BTOBBT(dsu);
> +		dswidth = BTOBBT(big_dswidth);
> +	} else if (!libxfs_validate_stripe_geometry(NULL, BBTOB(dsunit),
> +			BBTOB(dswidth), cfg->sectorsize, false)) {
>  		usage();
>  	}
>  
> @@ -2400,11 +2394,12 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
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
> 
