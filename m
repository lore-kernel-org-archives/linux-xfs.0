Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4073AC2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23349610A5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhFQQZZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 12:25:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232424AbhFQQZY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 12:25:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623946996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gjKkRTTrUJEGMeNzBsTUhUaby1eqw2qEJBmJBVMBdhg=;
        b=WvGrFE4duBauNFlNWgJ1+VP+6TwzxcV2Z/3futSMR7fL1cSng+UQhxmNWfcoBajQSaQiYp
        kveXNDyInNXtZ4fieqF3HdWiduFu3u1ygxznuvijNMdFgH8zDGbvJOBJcdWlGs5kkauc24
        fTQmkxq8dRHNP+RqcvcEL0aoy9M99k0=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-NVihvCsEPRqnS8DQ6rV_mg-1; Thu, 17 Jun 2021 12:23:15 -0400
X-MC-Unique: NVihvCsEPRqnS8DQ6rV_mg-1
Received: by mail-ot1-f70.google.com with SMTP id e14-20020a0568301f2eb0290405cba3beedso4203862oth.13
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 09:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gjKkRTTrUJEGMeNzBsTUhUaby1eqw2qEJBmJBVMBdhg=;
        b=hx+YV2eZFruVCHDbihxJpdJLTawKluAZsjeslXkFhOfwn+lhB4dOvpjYqBwRTClEdb
         6gzThXWJFK3yIzcqe4ZWXzYl3MrYJEp52aL+TtO5tkE56pxJAVbedF8CMfd3JfR2A09B
         Olm2GWG39S3k0lMxISJFg0BWO9xYvnxBaX+mJ6mGUB9u/CFOHEIunGaqFNf6jx4IMJCe
         eKDaRJoPFUe0D93gqiOxz13MlrLX4OxoPvLZLYdLH+2vOOearFywtRczFsfPtGW2viVW
         RUOcVgvn84YGx2UcvaZ0ffTBc5E9llpcXpxjVpWzKIhtwLNGFy5iSGFvlKmgfxQReU88
         DiCA==
X-Gm-Message-State: AOAM533+/cj8rLSmfTJAxv/vVKZUhtpHPWkCiOd2EUvmvz9Brp2nEJPx
        cWZXjMY0/BH7DVjcu7ZyXDW3OjDxYdDyP4iUfrIUFI8F6rvQCGfEnnFpiiCUevQ6kU2wNIAf5VI
        LmyWUvnLjZFzoZhirheEn
X-Received: by 2002:a9d:6b83:: with SMTP id b3mr5401524otq.325.1623946994962;
        Thu, 17 Jun 2021 09:23:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4yJfKco0tWpRabScHA5eW/54yOcThkwK6KrB01qFNna6GFXwHybUjVYYJ4q5orXS+VO+MTw==
X-Received: by 2002:a9d:6b83:: with SMTP id b3mr5401515otq.325.1623946994797;
        Thu, 17 Jun 2021 09:23:14 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id l18sm1339355otr.50.2021.06.17.09.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 09:23:14 -0700 (PDT)
Date:   Thu, 17 Jun 2021 12:23:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: factor out a helper to write a log_iovec into
 the iclog
Message-ID: <YMt28LSgI5XCllQx@bfoster>
References: <20210616163212.1480297-1-hch@lst.de>
 <20210616163212.1480297-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616163212.1480297-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 06:32:07PM +0200, Christoph Hellwig wrote:
> Add a new helper to copy the log iovec into the in-core log buffer,
> and open code the handling continuation opheader as a special case.
> 

What do you mean by "open code the handling continuation opheader?"

Otherwise looks reasonable to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
>  
> -- 
> 2.30.2
> 

