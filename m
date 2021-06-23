Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D66C4743C
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Jun 2021 10:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 192716024A
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Jun 2021 10:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhFWKVV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Jun 2021 06:21:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46396 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229833AbhFWKVV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Jun 2021 06:21:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624443543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r9Vtk8QcLVX2AtyoCT/oZD6hF+yhr/6Mj5ae/QAkdjo=;
        b=ZnCUmXT5DBWHmtrPdRy7LhNpyNZqbsHaI/EerUjrdO01PqanDNUC9J5YKe+qEKjQVJtSAS
        KdkmVigXfTNBObe94SoUdWaFNubFqiSmxYd2CIBMDPj3tlCA3wvn/IlSuOYmL4YEaJymEE
        aR2HMqLqJQPmWj7iLOiv7xr6H9z7aHI=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-uudwz5PmPkSet1QLK9q9UA-1; Wed, 23 Jun 2021 06:19:00 -0400
X-MC-Unique: uudwz5PmPkSet1QLK9q9UA-1
Received: by mail-qk1-f199.google.com with SMTP id d194-20020a3768cb0000b02903ad9d001bb6so1920869qkc.7
        for <linux-xfs@vger.kernel.org>; Wed, 23 Jun 2021 03:19:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r9Vtk8QcLVX2AtyoCT/oZD6hF+yhr/6Mj5ae/QAkdjo=;
        b=NQLQKbnFbXlMsvRF+sJso4tOhGyqbHq6WOPeaXqjd908DzBWKJQk5jTMy7Yf0+z3NP
         tL5ltRpBh4XZSjXTgGqvcyaq+m6+buRUw4NHrtFlrF1tKg+i8TlIEMYCmOztaxvibDIa
         H4vFaL5TMB3J+bETaXloma3a3Uyk8MlhLTLx/L7umcrLII/MlLNgjykshtXdawPng642
         sMMH4aVltg5NNG7vUTP8RmdI5RDnC/i5Fw3IVh52bbR51hEmIGDHR+1E5nlyA6Q+2Z7v
         W1lRlQw7ZxBvBusYDdegDG5e6lwYRNyWiczRpSE/O/uSoEDO9W/Tl4PBiCGKI494vBbn
         wiSg==
X-Gm-Message-State: AOAM533+4DTOxSHOzKk0RV8ctBB4dauyqkvxfR1aoXJ3eSHmHsKXXtUC
        h8N8oVhRm+pmMSfOrteoFpM933BVNPBcx/Wc2anTdxhlI2rlBhyNIlFbmAD6DNAshNgD7Kpc3aG
        NvTLHnaI1dF+hUSIeWUlI
X-Received: by 2002:a05:622a:1701:: with SMTP id h1mr3188365qtk.36.1624443540005;
        Wed, 23 Jun 2021 03:19:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqni1T+iQFiCXNAf7it3enD8HlVgzsvaDSyGNHTslzIlKTURdIizdMkjj6tQp71ye6s1ssbg==
X-Received: by 2002:a05:622a:1701:: with SMTP id h1mr3188359qtk.36.1624443539877;
        Wed, 23 Jun 2021 03:18:59 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id r19sm3481743qtw.59.2021.06.23.03.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 03:18:59 -0700 (PDT)
Date:   Wed, 23 Jun 2021 06:18:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Initialize error in xfs_attr_remove_iter
Message-ID: <YNMKkfHvrP0/jzAB@bfoster>
References: <20210622210852.9511-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622210852.9511-1-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 22, 2021 at 02:08:52PM -0700, Allison Henderson wrote:
> A recent bug report generated a warning that a code path in
> xfs_attr_remove_iter could potentially return error uninitialized in the
> case of XFS_DAS_RM_SHRINK state.  Fix this by initializing error.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 611dc67..d9d7d51 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1375,7 +1375,7 @@ xfs_attr_remove_iter(
>  {
>  	struct xfs_da_args		*args = dac->da_args;
>  	struct xfs_da_state		*state = dac->da_state;
> -	int				retval, error;
> +	int				retval, error = 0;
>  	struct xfs_inode		*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
> -- 
> 2.7.4
> 

