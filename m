Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27045C433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 13:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D028C2475D
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 13:44:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZK81TMof"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387785AbgJMNon (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 09:44:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56493 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387783AbgJMNon (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 09:44:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602596681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xFw8ue9qI3thqC46pUre7vs+WjmFQHR/WsXP5NLlvFs=;
        b=ZK81TMofkNRW6lgwYaU4edyGMiNtZPGS8EAFVdAfD9Q293l7gmZv+QNB9dE3TgAhoQTbFZ
        8elRXnjkDJzfQAkEDDgnIVfagp1R17LY+ngTsZDhPT/GmwcH5hKPucF/n5eoWsRDIVIccZ
        UG3I1ZaSoFiamuw6ufcr3j9let44zJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-u-l-WUE8NduLFZsvKrrV_g-1; Tue, 13 Oct 2020 09:44:39 -0400
X-MC-Unique: u-l-WUE8NduLFZsvKrrV_g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C874188C120;
        Tue, 13 Oct 2020 13:44:38 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 793F15D9CD;
        Tue, 13 Oct 2020 13:44:31 +0000 (UTC)
Date:   Tue, 13 Oct 2020 09:44:29 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v6 3/3] mkfs: make use of xfs_validate_stripe_geometry()
Message-ID: <20201013134429.GF966478@bfoster>
References: <20201013040627.13932-1-hsiangkao@redhat.com>
 <20201013040627.13932-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013040627.13932-4-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 13, 2020 at 12:06:27PM +0800, Gao Xiang wrote:
> Check stripe numbers in calc_stripe_factors() by using
> xfs_validate_stripe_geometry().
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

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

