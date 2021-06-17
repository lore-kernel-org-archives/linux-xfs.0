Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FE5C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F78861166
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhFQQ00 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 12:26:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47088 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232466AbhFQQ00 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 12:26:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623947058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aYCVhKQfTkURi1N0oI+y1ybVEivR+3h/dXa/8taYsfU=;
        b=HXfVIX6W90DKsvQmRN7LaQNwZdbLGVhG9Oasn2LGDEp+FKTtHViXfjeT6CBQAqfdxATXkD
        JQJVmbTb+4klqdyhHuXW9EJKqSh86W7RloDS+EV6YYxIHt/IywznyEMz1OYlIbHUKzr+zV
        HqzQPWDJtjRCXf1sBKusy0VJq3djfns=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444--_k7NqCDOJ-Nl9CaEsBsTQ-1; Thu, 17 Jun 2021 12:24:16 -0400
X-MC-Unique: -_k7NqCDOJ-Nl9CaEsBsTQ-1
Received: by mail-oi1-f199.google.com with SMTP id j20-20020aca17140000b02901f3ef48ce7dso3252444oii.12
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 09:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aYCVhKQfTkURi1N0oI+y1ybVEivR+3h/dXa/8taYsfU=;
        b=DduKxeP7EN+KDNG0XNn7f/mS3fouYq/NkKk/AbZZVlR8NUdIF19HzH7MhMVDIWel3L
         tFb8VSPkXBSvv2N2unFeLz9tchBUD2cKojBk850WvacjFU1+IjsYLWP5CZY1uIfUGxSI
         ZRPpZ3FBS3PEMuK5rnmafDD2wMTPnmayumMrl9YaC09QL23dZ30g9Oi7RCJXn7o2/LyL
         unGEUeg1Z/Gc1camiRIFxRaALEAoEb4v1QB9x+4m/4DhXwUViCMPyNENqC5B7tNGP8aV
         0RGQJcUh6LKqMHn+TikKwgO3BS3N6FtElB1xuppjTFIj44/DXntPJs3HPR2yL2a9m6tf
         tbdw==
X-Gm-Message-State: AOAM531VaUgx5FcjqLjndfkVf//pxbo8DT/96NEQzJVYgkGDxdclExQI
        cyQLE7zVoTqu0Q9OJOcwt+QAhWdUX4y8huchZPXxJe10/eU33hwRp6gNGIuHRcscnPy3YZ074VR
        EBCuDc/5AAh9jdT6WqZak
X-Received: by 2002:a9d:226c:: with SMTP id o99mr5099845ota.134.1623947056195;
        Thu, 17 Jun 2021 09:24:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLuptc/pHU7M8LmPoAqolBkBUrUiqHsPXIEdzXfo5qPDja1GBMkwb49exKuGiQT968lIn4Sg==
X-Received: by 2002:a9d:226c:: with SMTP id o99mr5099835ota.134.1623947056065;
        Thu, 17 Jun 2021 09:24:16 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id c22sm997596otp.80.2021.06.17.09.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 09:24:15 -0700 (PDT)
Date:   Thu, 17 Jun 2021 12:24:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: simplify the xlog_write_partial calling
 conventions
Message-ID: <YMt3LVRwLEwS6kuq@bfoster>
References: <20210616163212.1480297-1-hch@lst.de>
 <20210616163212.1480297-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616163212.1480297-7-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 06:32:10PM +0200, Christoph Hellwig wrote:
> Lift the iteration to the next log_vec into the callers, and drop
> the pointless log argument that can be trivially derived.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Heh, I actually had patches in my local tree very similar to these last
few to fix up the xlog_write() iteration logic. Nice cleanup overall:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 38 +++++++++++++++-----------------------
>  1 file changed, 15 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 5d55d4fff63035..4afa8ff1a82076 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2232,14 +2232,11 @@ xlog_write_get_more_iclog_space(
>  /*
>   * Write log vectors into a single iclog which is smaller than the current chain
>   * length. We write until we cannot fit a full record into the remaining space
> - * and then stop. We return the log vector that is to be written that cannot
> - * wholly fit in the iclog.
> + * and then stop.
>   */
> -static struct xfs_log_vec *
> +static int
>  xlog_write_partial(
> -	struct xlog		*log,
> -	struct list_head	*lv_chain,
> -	struct xfs_log_vec	*log_vector,
> +	struct xfs_log_vec	*lv,
>  	struct xlog_ticket	*ticket,
>  	struct xlog_in_core	**iclogp,
>  	uint32_t		*log_offset,
> @@ -2248,8 +2245,7 @@ xlog_write_partial(
>  	uint32_t		*data_cnt)
>  {
>  	struct xlog_in_core	*iclog = *iclogp;
> -	struct xfs_log_vec	*lv = log_vector;
> -	struct xfs_log_iovec	*reg;
> +	struct xlog		*log = iclog->ic_log;
>  	struct xlog_op_header	*ophdr;
>  	int			index = 0;
>  	uint32_t		rlen;
> @@ -2257,9 +2253,8 @@ xlog_write_partial(
>  
>  	/* walk the logvec, copying until we run out of space in the iclog */
>  	for (index = 0; index < lv->lv_niovecs; index++) {
> -		uint32_t	reg_offset = 0;
> -
> -		reg = &lv->lv_iovecp[index];
> +		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
> +		uint32_t		reg_offset = 0;
>  
>  		/*
>  		 * The first region of a continuation must have a non-zero
> @@ -2278,7 +2273,7 @@ xlog_write_partial(
>  					&iclog, log_offset, *len, record_cnt,
>  					data_cnt);
>  			if (error)
> -				return ERR_PTR(error);
> +				return error;
>  		}
>  
>  		ophdr = reg->i_addr;
> @@ -2329,7 +2324,7 @@ xlog_write_partial(
>  					*len + sizeof(struct xlog_op_header),
>  					record_cnt, data_cnt);
>  			if (error)
> -				return ERR_PTR(error);
> +				return error;
>  
>  			ophdr = iclog->ic_datap + *log_offset;
>  			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> @@ -2365,10 +2360,7 @@ xlog_write_partial(
>  	 * the caller so it can go back to fast path copying.
>  	 */
>  	*iclogp = iclog;
> -	lv = list_next_entry(lv, lv_list);
> -	if (list_entry_is_head(lv, lv_chain, lv_list))
> -		return NULL;
> -	return lv;
> +	return 0;
>  }
>  
>  /*
> @@ -2450,13 +2442,13 @@ xlog_write(
>  		if (!lv)
>  			break;
>  
> -		lv = xlog_write_partial(log, lv_chain, lv, ticket, &iclog,
> -					&log_offset, &len, &record_cnt,
> -					&data_cnt);
> -		if (IS_ERR_OR_NULL(lv)) {
> -			error = PTR_ERR_OR_ZERO(lv);
> +		error = xlog_write_partial(lv, ticket, &iclog, &log_offset,
> +					   &len, &record_cnt, &data_cnt);
> +		if (error)
> +			break;
> +		lv = list_next_entry(lv, lv_list);
> +		if (list_entry_is_head(lv, lv_chain, lv_list))
>  			break;
> -		}
>  	}
>  	ASSERT((len == 0 && !lv) || error);
>  
> -- 
> 2.30.2
> 

