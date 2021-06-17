Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF62C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 251E161185
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhFQQZI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 12:25:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229671AbhFQQZI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 12:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623946980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=APhr/9KWtbvy2CCfFzb6B+B9GBZJr2joOIanjG645nc=;
        b=JltKMDziK8ddiVmdoQub6L8+aivwjrb2oA3sDaK/yvGYYE9Kz07CuHnvRq1IeRs3lFLb/+
        WdmzYGGM72OicJ7uO6/jER3HOQhFP+he3Xa/U7cUE/zMfmMMszdRzux5IP4hhUVRi+lad5
        SsNbSIMEqLVNzyqx81IUCYjrE5ARl2A=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-axi0HeSxP6i-piABGX5nwA-1; Thu, 17 Jun 2021 12:22:58 -0400
X-MC-Unique: axi0HeSxP6i-piABGX5nwA-1
Received: by mail-oi1-f197.google.com with SMTP id l136-20020acaed8e0000b02901f3ebfedbf2so3242379oih.11
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 09:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=APhr/9KWtbvy2CCfFzb6B+B9GBZJr2joOIanjG645nc=;
        b=AIAzSU/RGtpi8vHkJH42+8lZsSj6Kxkrk69xtaquJP+yzN0ZXdTqlwBqNJ16m0RwXt
         p1g7z4WrhnEaJ/qjh1hNAy+Wwo7rTPcIC+VclKWAGWJU4akyE+BcV0gGuE1uqQPxV7tT
         rvigvt2o9LXDb2ZIb8dvN9awNfig0jYf8nGVJPTOHBhh7wIU7cPRIaFEZs8NpLqrCONW
         1HS9iYBl4XUhlf+pY6ESfj3B/QRSg9pqLX5PRrjqmBF9ZM7zIs0I3lM7WXZzGLwWhMV5
         Fvsqodt7CN7U2OL8wTzB2XaFpwv8bAEmhVhIwdbV8eJpzV9XLx7Nx+NGyCc0QHm+t/vD
         oEPw==
X-Gm-Message-State: AOAM531mFDX30Srlmyc86tm7JfTWphGp0MBkze2kae3WMtzcPItIMuyw
        V90GWXtWCtaH3abhK60Z27TNszQz2JnDc9W/QMwRwtyNEbqMvIFYWLBdcWllPpQmDLp2F7s3Y5O
        PIhnR7NsJxYfBoxFIapF9
X-Received: by 2002:aca:1c03:: with SMTP id c3mr3455814oic.21.1623946977273;
        Thu, 17 Jun 2021 09:22:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPIVXwy0+ALs3IF3cYO8OZg84cl2ctxiotKWs8SUWEtU5L+G4WV1/188pTUEykZ+CqEjyYLQ==
X-Received: by 2002:aca:1c03:: with SMTP id c3mr3455805oic.21.1623946977122;
        Thu, 17 Jun 2021 09:22:57 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id e29sm1210681oiy.53.2021.06.17.09.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 09:22:56 -0700 (PDT)
Date:   Thu, 17 Jun 2021 12:22:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: change the type of ic_datap
Message-ID: <YMt23l9+/+/OzJdG@bfoster>
References: <20210616163212.1480297-1-hch@lst.de>
 <20210616163212.1480297-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616163212.1480297-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 06:32:05PM +0200, Christoph Hellwig wrote:
> Turn ic_datap from a char into a void pointer given that it points
> to arbitrary data.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c      | 2 +-
>  fs/xfs/xfs_log_priv.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e921b554b68367..8999c78f3ac6d9 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3613,7 +3613,7 @@ xlog_verify_iclog(
>  		if (field_offset & 0x1ff) {
>  			clientid = ophead->oh_clientid;
>  		} else {
> -			idx = BTOBBT((char *)&ophead->oh_clientid - iclog->ic_datap);
> +			idx = BTOBBT((void *)&ophead->oh_clientid - iclog->ic_datap);
>  			if (idx >= (XLOG_HEADER_CYCLE_SIZE / BBSIZE)) {
>  				j = idx / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
>  				k = idx % (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index e4e421a7033558..96dbe713954f7e 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -185,7 +185,7 @@ typedef struct xlog_in_core {
>  	u32			ic_offset;
>  	enum xlog_iclog_state	ic_state;
>  	unsigned int		ic_flags;
> -	char			*ic_datap;	/* pointer to iclog data */
> +	void			*ic_datap;	/* pointer to iclog data */
>  
>  	/* Callback structures need their own cacheline */
>  	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;
> -- 
> 2.30.2
> 

