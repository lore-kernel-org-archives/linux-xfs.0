Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0488FC2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7705610A5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhFQQZP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 12:25:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229671AbhFQQZP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 12:25:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623946986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pkLiYLrpFmv6L4CzT9J7pcXGMJ1fHSnNPZFhGdhrUOY=;
        b=M/keaPZLgjSoVqFU2E8/f5vDT2Vcao1IN0NfXAgtiRwdWrrXe7We3EP+xDrTZZV3zQbiX2
        RnfGD/RQPgepyLblimplQyi2W/W2RRwvWtL7NG+QC+E6ZWnRDrwZbENoEHwiCFWo1yxMGW
        /jXFY3wS8rxto9dU2Z1XwDBM/Nv5FfE=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-aKpJbVXMPpaBacfxvgJbGA-1; Thu, 17 Jun 2021 12:23:05 -0400
X-MC-Unique: aKpJbVXMPpaBacfxvgJbGA-1
Received: by mail-oo1-f70.google.com with SMTP id v8-20020a0568200048b0290249f46c70eeso4186901oob.22
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 09:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pkLiYLrpFmv6L4CzT9J7pcXGMJ1fHSnNPZFhGdhrUOY=;
        b=p2kygpy3UieaDjn9WIVXQvuhKJtU46hkBGUFAXolUkT02JyO3SOFDAjah1hGvwVByc
         an1eKcXAbuKVebvRbcpFBUFoJA/HVdyBTOToG0nk4T5YAGNAfQvwgc0Fu3kda4txsDap
         eqt29XY5mKwsMSDwvXALw+bNnMNUeyWVk+sEdWki1Kb9PVsJDs0+w7GhWvaPytQubSXd
         4sEsCcyFMryPZImLmdcU5eNdai8qz6ZHQ1Sfsp9JG+S5pSbtzPlZNJ7YxUxTtka+cXMp
         k7gxYDBDHcOKgfZz2WjB3R57l1p5IgavHlj32dRhwo+ulFYoFW4MIflT+By0LC/qcxxB
         Pu5w==
X-Gm-Message-State: AOAM533eMt2I1ZXfw83N72NcDIm62DYHWoNQlVcGDmXCgyWcTa8k50ou
        NGZ5iRWzAhVN+7oc/ukM9p7dmZM/A6LEZCryW30gIswEeULzY7RpzsWPPqxIn53lkvDWIZ5khJ8
        9Eaa9nvrBfe2P37ZNvsxv
X-Received: by 2002:a05:6808:4b:: with SMTP id v11mr1779670oic.3.1623946984855;
        Thu, 17 Jun 2021 09:23:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLD0t/3I9mHL9Qm6yet3IlJVfDhOGNR8gWv37kgE1sLqlgWps4Nnuc4Gu5UxR8fd3Bx8zbFw==
X-Received: by 2002:a05:6808:4b:: with SMTP id v11mr1779663oic.3.1623946984736;
        Thu, 17 Jun 2021 09:23:04 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id q26sm497110ota.20.2021.06.17.09.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 09:23:04 -0700 (PDT)
Date:   Thu, 17 Jun 2021 12:23:02 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: list entry elements don't need to be initialized
Message-ID: <YMt25uPfkj4kebCc@bfoster>
References: <20210616163212.1480297-1-hch@lst.de>
 <20210616163212.1480297-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616163212.1480297-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 06:32:06PM +0200, Christoph Hellwig wrote:
> list_add does not require the added element to be initialized.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 8999c78f3ac6d9..32cb0fc459a364 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -851,7 +851,7 @@ xlog_write_unmount_record(
>  		.lv_iovecp = &reg,
>  	};
>  	LIST_HEAD(lv_chain);
> -	INIT_LIST_HEAD(&vec.lv_list);
> +
>  	list_add(&vec.lv_list, &lv_chain);
>  
>  	BUILD_BUG_ON((sizeof(struct xlog_op_header) +
> @@ -1587,7 +1587,7 @@ xlog_commit_record(
>  	};
>  	int	error;
>  	LIST_HEAD(lv_chain);
> -	INIT_LIST_HEAD(&vec.lv_list);
> +
>  	list_add(&vec.lv_list, &lv_chain);
>  
>  	if (XLOG_FORCED_SHUTDOWN(log))
> -- 
> 2.30.2
> 

