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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04908C49361
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 07:42:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFA3F6120A
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 07:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbhFRHpC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 03:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhFRHpC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 03:45:02 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C17FC061574
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 00:42:52 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t19-20020a17090ae513b029016f66a73701so247270pjy.3
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 00:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=rdAxlKF1K4JjVjB1guHf1CLiZJfbEytc3OXBFxe7PyM=;
        b=BcjUt34qTOx9tVMnN4+lXDSV0GqTsjxx49Ed4hNeXc7RbOaRZ7x7qk4hUKkjAHTM91
         j8YqUV/YOuvu4OKZLUz34P3FwCUVd709qyoVxkcViwYhJVxEbgqOrepoGDmadEY5d5n3
         HsUd3kZ9yqv2eW93sScA+DfxI6PxsrXfA0vlGwnUPieWrjkzD7prpMPs9EcEIXFjs3A1
         OvdMs2aPD79CCbtoBS9clYmNhbbf4Yo+NPwMNhqKuNXZzevYW3lz54V//LDRFYa9jhTq
         UMc8t2eY798Ro6ta9eRaHeXqtI3BSP9LJ6gyN4dfBbi7NoQAYfADrLFUWR2zAUyr8IdH
         XCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=rdAxlKF1K4JjVjB1guHf1CLiZJfbEytc3OXBFxe7PyM=;
        b=dV6mwJ/anasA+AGt8WVtXXH28tJwcbrRuuVfekrtjuTW4Sy9qnqHDqMfwmUm0CzOMy
         sx4d5eLsI9oRCRoXTdyplsAvjXSE92GhFDPQUrAGr2AxfRH1TAb+GHIwsnnOzUicRk7a
         0qcJABLyXCOKZG2XG2KYjTpZlLnlL/Kyc9Oxr/4YS3alTL0bjYxp0WV/gkZCOX26T9Fk
         1kQynejqhhYPlvufEWSUfc7M8XS4gUt2nUs+SRXyEl/XyUD2kSIr96wWdNV5KpOJpXA2
         jQeuMPb6p6RAf78s+K1Ng67tvC1Kmb2ihOY0e48Ux+0Ez0+h0NjKTszU3bk/annkNKFU
         ts1g==
X-Gm-Message-State: AOAM531IqlrPR8XsdvRaHgz5UYM0/9LQvo2pAcJmyJMrRPspQk3MiBnw
        t7T39VtJvoBeZsZ8SP5kB8xV4NGpavLVVQ==
X-Google-Smtp-Source: ABdhPJxMtN6Uxm5AqWZ110hwHGTLihm06LN5lMIhM+kJBNmokrbzbRi7RxcErPwNq7f660CRv9Y9cQ==
X-Received: by 2002:a17:90a:6d43:: with SMTP id z61mr9656421pjj.73.1624002171773;
        Fri, 18 Jun 2021 00:42:51 -0700 (PDT)
Received: from garuda ([122.167.197.147])
        by smtp.gmail.com with ESMTPSA id m126sm7665566pfb.15.2021.06.18.00.42.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 18 Jun 2021 00:42:51 -0700 (PDT)
References: <20210616163212.1480297-1-hch@lst.de> <20210616163212.1480297-4-hch@lst.de>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: factor out a helper to write a log_iovec into the iclog
In-reply-to: <20210616163212.1480297-4-hch@lst.de>
Date:   Fri, 18 Jun 2021 13:12:47 +0530
Message-ID: <875yybty88.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Jun 2021 at 22:02, Christoph Hellwig wrote:
> Add a new helper to copy the log iovec into the in-core log buffer,
> and open code the handling continuation opheader as a special case.
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 55 +++++++++++++++++++++++++++---------------------
>  1 file changed, 31 insertions(+), 24 deletions(-)
>
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 32cb0fc459a364..5b431d53287d2c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2124,6 +2124,26 @@ xlog_print_trans(
>  	}
>  }
>  
> +static inline void
> +xlog_write_iovec(
> +	struct xlog_in_core	*iclog,
> +	uint32_t		*log_offset,
> +	void			*data,
> +	uint32_t		write_len,
> +	int			*bytes_left,
> +	uint32_t		*record_cnt,
> +	uint32_t		*data_cnt)
> +{
> +	ASSERT(*log_offset % sizeof(int32_t) == 0);
> +	ASSERT(write_len % sizeof(int32_t) == 0);
> +
> +	memcpy(iclog->ic_datap + *log_offset, data, write_len);
> +	*log_offset += write_len;
> +	*bytes_left -= write_len;
> +	(*record_cnt)++;
> +	*data_cnt += write_len;
> +}
> +
>  /*
>   * Write whole log vectors into a single iclog which is guaranteed to have
>   * either sufficient space for the entire log vector chain to be written or
> @@ -2145,13 +2165,11 @@ xlog_write_single(
>  	uint32_t		*data_cnt)
>  {
>  	struct xfs_log_vec	*lv;
> -	void			*ptr;
>  	int			index;
>  
>  	ASSERT(*log_offset + *len <= iclog->ic_size ||
>  		iclog->ic_state == XLOG_STATE_WANT_SYNC);
>  
> -	ptr = iclog->ic_datap + *log_offset;
>  	for (lv = log_vector;
>  	     !list_entry_is_head(lv, lv_chain, lv_list);
>  	     lv = list_next_entry(lv, lv_list)) {
> @@ -2171,16 +2189,13 @@ xlog_write_single(
>  			struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
>  			struct xlog_op_header	*ophdr = reg->i_addr;
>  
> -			ASSERT(reg->i_len % sizeof(int32_t) == 0);
> -			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
> -
>  			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
>  			ophdr->oh_len = cpu_to_be32(reg->i_len -
>  						sizeof(struct xlog_op_header));
> -			memcpy(ptr, reg->i_addr, reg->i_len);
> -			xlog_write_adv_cnt(&ptr, len, log_offset, reg->i_len);
> -			(*record_cnt)++;
> -			*data_cnt += reg->i_len;
> +
> +			xlog_write_iovec(iclog, log_offset, reg->i_addr,
> +					 reg->i_len, len, record_cnt,
> +					 data_cnt);
>  		}
>  	}
>  	if (list_entry_is_head(lv, lv_chain, lv_list))
> @@ -2249,12 +2264,10 @@ xlog_write_partial(
>  	int			error;
>  
>  	/* walk the logvec, copying until we run out of space in the iclog */
> -	ptr = iclog->ic_datap + *log_offset;
>  	for (index = 0; index < lv->lv_niovecs; index++) {
>  		uint32_t	reg_offset = 0;
>  
>  		reg = &lv->lv_iovecp[index];
> -		ASSERT(reg->i_len % sizeof(int32_t) == 0);
>  
>  		/*
>  		 * The first region of a continuation must have a non-zero
> @@ -2274,7 +2287,6 @@ xlog_write_partial(
>  					data_cnt);
>  			if (error)
>  				return ERR_PTR(error);
> -			ptr = iclog->ic_datap + *log_offset;
>  		}
>  
>  		ophdr = reg->i_addr;
> @@ -2285,12 +2297,9 @@ xlog_write_partial(
>  		if (rlen != reg->i_len)
>  			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
>  
> -		ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
> -		xlog_verify_dest_ptr(log, ptr);
> -		memcpy(ptr, reg->i_addr, rlen);
> -		xlog_write_adv_cnt(&ptr, len, log_offset, rlen);
> -		(*record_cnt)++;
> -		*data_cnt += rlen;
> +		xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
> +		xlog_write_iovec(iclog, log_offset, reg->i_addr, rlen, len,
> +				 record_cnt, data_cnt);
>  
>  		/* If we wrote the whole region, move to the next. */
>  		if (rlen == reg->i_len)
> @@ -2356,12 +2365,10 @@ xlog_write_partial(
>  			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
>  			ophdr->oh_len = cpu_to_be32(rlen);
>  
> -			xlog_verify_dest_ptr(log, ptr);
> -			memcpy(ptr, reg->i_addr + reg_offset, rlen);
> -			xlog_write_adv_cnt(&ptr, len, log_offset, rlen);
> -			(*record_cnt)++;
> -			*data_cnt += rlen;
> -
> +			xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
> +			xlog_write_iovec(iclog, log_offset,
> +					 reg->i_addr + reg_offset, rlen, len,
> +					 record_cnt, data_cnt);
>  		} while (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
>  	}


-- 
chandan
