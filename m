Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF496C48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 07:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABCBE6120A
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 07:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhFRHwb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 03:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbhFRHwb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 03:52:31 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3852C061574
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 00:50:21 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id i4so556162plt.12
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 00:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=1dkfKmyFlek01HuDL8yR+4IbY8PvF6ZNyYXniD/28pE=;
        b=JTMOR31vxU9ysLsCPix1RwksnVHUJMEz74gIKB0r8YUbjqiL1ANcKxP6fyOFF9e3DL
         vXL67q7+WRKJJbcRSEGelLynZkANuyCAhQ8haK/9yERCCx1EM5a0I1GJAsGdW+65JZlF
         2H2+0inmPya0SfBBulLZarYOm3gbHC8LIY9AyVKH9+g8nCcFL1TXNSGICIof6AAZ4u4z
         Xa7uWVWNgm9LRBrL8Qn7woAtQyYvJoHOhauQFctDo/uTL23au3rBKmfRsLorNRP2nKe2
         bskFPIMUTyu7xDYLfOBIMlWX+um60u8b4bUM66T4rn3upxGy6E3PqrTpVQlCdlWzDKm8
         +8NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=1dkfKmyFlek01HuDL8yR+4IbY8PvF6ZNyYXniD/28pE=;
        b=Q1Szw3mAEZoc8bN4vcXlGvQU7yFtlelyoHOLqPj2WQQnq0f/FZyjwvYUzXT4ft+0aQ
         HhhFKWhB8HiN1HMlMqae/txDOgymnSH1rbL6lvqEJAYVcNqbJb2QQyEM2f7/Pj7iKw49
         SpYnWO4woUlPFB12yXNMh3vXOWW3VmnsjehRBMeox/RDk+gxOgtp0E99Qys12BvSKSlL
         kUXandg6SAUEouJfQ5iK4n8UTGsukSPcAAUx1xdmNr8S3uU+IMYi2qdUhWT2wCmos/2O
         ikjR0PHmQShPWKDw2jge+DZSNRsKo4BdyiBWocn0UR0O/Q/O+Pe3LR/pErrEtw6XwR29
         9/5w==
X-Gm-Message-State: AOAM532dbNurj5cGW+w3jiim9hcCVg20Qtxe4mNTLQkC0OqDo4K5bPE2
        uchOfBopC3YYWvhGpn4TOVlqWFPFrDojOQ==
X-Google-Smtp-Source: ABdhPJwz3bcfmsme7g7T5sepUvH2u4jNGjqYgvgoEwLOPVnwPFn5KkHMoxk7K88jv+6EsuVGa2CCEA==
X-Received: by 2002:a17:90a:3d0d:: with SMTP id h13mr9995578pjc.20.1624002621055;
        Fri, 18 Jun 2021 00:50:21 -0700 (PDT)
Received: from garuda ([122.167.197.147])
        by smtp.gmail.com with ESMTPSA id b16sm7453362pfr.194.2021.06.18.00.50.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 18 Jun 2021 00:50:20 -0700 (PDT)
References: <20210616163212.1480297-1-hch@lst.de> <20210616163212.1480297-5-hch@lst.de>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: remove xlog_write_adv_cnt and simplify xlog_write_partial
In-reply-to: <20210616163212.1480297-5-hch@lst.de>
Date:   Fri, 18 Jun 2021 13:20:18 +0530
Message-ID: <874kdvtxvp.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Jun 2021 at 22:02, Christoph Hellwig wrote:
> xlog_write_adv_cnt is now only used for writing the continuation ophdr.
> Remove xlog_write_adv_cnt and simplify the caller now that we don't need
> the ptr iteration variable, and don't need to increment / decrement
> len for the accounting shengians.
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
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


-- 
chandan
