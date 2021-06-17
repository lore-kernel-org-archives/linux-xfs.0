Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB12C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47ECB61249
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhFQQZe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 12:25:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38164 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232426AbhFQQZd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 12:25:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623947005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZARfzkY7aoy8TJU8Q/821l3dUm8X4oNLkXTacE6aFyU=;
        b=PvxgYSzPIUqyYNmOU8b2K2wF/xXSh7bIPzqubgvUdxAXMvTr8WFUv/yB2BufmSG5REj92w
        yrgoQlELTBDZ6cxicQpQSUQ20/MG635ny0gfrX/U8dlNkx/UA7zAQY5dr3OtKm0eyE+xIM
        4S2qtOy3KirzAcx6QyBXHrF26Gzf6u8=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-FwqQBEAZO-OvTbq_yV1cLQ-1; Thu, 17 Jun 2021 12:23:24 -0400
X-MC-Unique: FwqQBEAZO-OvTbq_yV1cLQ-1
Received: by mail-ot1-f71.google.com with SMTP id q12-20020a9d664c0000b02903ec84bc44bbso4203439otm.5
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 09:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZARfzkY7aoy8TJU8Q/821l3dUm8X4oNLkXTacE6aFyU=;
        b=OYdwvMnrvZ89JyO6DKeO29PqrI+ArvHLZHsx5AU3Z7SZ3jNp1vNiw1kfXr98yyvoMt
         ps4T35lqfzlA32g/Wzm85N8aR2hLEP5U5aFkguVqTsX2OEPS5XZDvmErabeLTqUDWzAo
         8BX2rB6QV8L2UBu8yOCRQPYwB0DqNzBLkRv+vNMfPiQCr+pBV1xmN3gCj2Z3jVxJrqjw
         umq2DS2A4Um3dZA8Eb2fmEpYpTzqDFSoqR04MXKHhVAPMB9W/yx77iEMzyBvSZMKBq/d
         ZRr7PLXl/t3mwfiEjIKel/adm6SJU5FJ6Pggi1hAbnVr+O9J9ZJKd3G7H6/ko9di2oSP
         2xKQ==
X-Gm-Message-State: AOAM531W5pUzuiKIu+KcAgeWbmJIwfGB92p4Ycm2C4xJ/b8FF/SCjkWx
        jlMproXjjJ0fO0hXiWy+SQQpLkXF8zcfQxETcZY3QVHrWTrvBwL0ghgpDk8PlDqRWGIxUjgyPEZ
        c4HDAtx7JgVJ9jrdjpe58
X-Received: by 2002:aca:4fd7:: with SMTP id d206mr11132615oib.16.1623947003580;
        Thu, 17 Jun 2021 09:23:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZVKYmNfpPERA16ZCKiTiSLmEmmohulSsIkkaxJgmjs2GGBacPdvdWIe/SWrC38W8ol8Bicg==
X-Received: by 2002:aca:4fd7:: with SMTP id d206mr11132607oib.16.1623947003456;
        Thu, 17 Jun 2021 09:23:23 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id p5sm1173677oip.35.2021.06.17.09.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 09:23:23 -0700 (PDT)
Date:   Thu, 17 Jun 2021 12:23:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: remove xlog_write_adv_cnt and simplify
 xlog_write_partial
Message-ID: <YMt2+UeYHozGG9oM@bfoster>
References: <20210616163212.1480297-1-hch@lst.de>
 <20210616163212.1480297-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210616163212.1480297-5-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 06:32:08PM +0200, Christoph Hellwig wrote:
> xlog_write_adv_cnt is now only used for writing the continuation ophdr.
> Remove xlog_write_adv_cnt and simplify the caller now that we don't need
> the ptr iteration variable, and don't need to increment / decrement
> len for the accounting shengians.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

fs/xfs/xfs_log.c: In function ‘xlog_write_partial’:
fs/xfs/xfs_log.c:2261:10: warning: unused variable ‘ptr’ [-Wunused-variable]

With that fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c      | 12 +++++-------
>  fs/xfs/xfs_log_priv.h |  8 --------
>  2 files changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 5b431d53287d2c..1bc32f056a5bcf 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2331,24 +2331,22 @@ xlog_write_partial(
>  			 * a new iclog. This is necessary so that we reserve
>  			 * space in the iclog for it.
>  			 */
> -			*len += sizeof(struct xlog_op_header);
>  			ticket->t_curr_res -= sizeof(struct xlog_op_header);
>  
>  			error = xlog_write_get_more_iclog_space(log, ticket,
> -					&iclog, log_offset, *len, record_cnt,
> -					data_cnt);
> +					&iclog, log_offset,
> +					*len + sizeof(struct xlog_op_header),
> +					record_cnt, data_cnt);
>  			if (error)
>  				return ERR_PTR(error);
> -			ptr = iclog->ic_datap + *log_offset;
>  
> -			ophdr = ptr;
> +			ophdr = iclog->ic_datap + *log_offset;
>  			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
>  			ophdr->oh_clientid = XFS_TRANSACTION;
>  			ophdr->oh_res2 = 0;
>  			ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
>  
> -			xlog_write_adv_cnt(&ptr, len, log_offset,
> -						sizeof(struct xlog_op_header));
> +			*log_offset += sizeof(struct xlog_op_header);
>  			*data_cnt += sizeof(struct xlog_op_header);
>  
>  			/*
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 96dbe713954f7e..1b3b3d2bb8a5d1 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -467,14 +467,6 @@ extern kmem_zone_t *xfs_log_ticket_zone;
>  struct xlog_ticket *xlog_ticket_alloc(struct xlog *log, int unit_bytes,
>  		int count, bool permanent);
>  
> -static inline void
> -xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
> -{
> -	*ptr += bytes;
> -	*len -= bytes;
> -	*off += bytes;
> -}
> -
>  void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>  void	xlog_print_trans(struct xfs_trans *);
>  int	xlog_write(struct xlog *log, struct list_head *lv_chain,
> -- 
> 2.30.2
> 

