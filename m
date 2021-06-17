Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BFEBC2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BC6A613BF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbhFQQ0p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 12:26:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60831 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232478AbhFQQ0k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 12:26:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623947071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/5E/oYmrF1kzpaoyP2qGEYVPtA9K1NW+noj9ASiBSkM=;
        b=HYqSsnzbty+zYxo16c9858z5CNW1KPnnT/kuuO42Qj1tYCZuTjkJj3bKB96ywQinCTUzZW
        cpEzRq8xFmyRrF2VbQltxlkAhkPMhojcDZBFQI7tTCkGjXHdUy0euBhvnmlD9VHnwMbVtF
        L2k+7nJ5aHnKjqG24wzOI5hhMCd0cwc=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-sVXLQEwGMS-eXOCe_AhrIA-1; Thu, 17 Jun 2021 12:24:30 -0400
X-MC-Unique: sVXLQEwGMS-eXOCe_AhrIA-1
Received: by mail-ot1-f71.google.com with SMTP id e28-20020a9d491c0000b02903daf90867beso4205553otf.11
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 09:24:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/5E/oYmrF1kzpaoyP2qGEYVPtA9K1NW+noj9ASiBSkM=;
        b=ayWSXcsEhKbvBep2cTiuFjIl5lydwMV/H0lSiRQJ79LPt55K1VSkiB1zXzPFOkDZaq
         +Jndh1/zuKalqWHhCfD0J9Fmc7rJQyPq/Bp4skx/LGJAzqGNNZoj5oW4lW50Yzu2/IFF
         u9HfcE19E2lYpxTE+esZxLwPaL4Ef6z+UNTRY01K55pFuMMPPa/iDeMmhdey0z4ZpreJ
         /Bue8+8SENO+ofI0S3CSsr+JOU1MEHWaiA1SKa5LqoduVbPyULltZhSqVVWaYcwNkHz0
         YGLuikG4EbwBKQKhDYFV80uDwuU/NVzKHlTHUxpbk9d4kWjicUsU1elR14Gcn4OmHbJ7
         Q49w==
X-Gm-Message-State: AOAM531r7VSRDQpE+vgJ7UzN5eAj1CuOvIRx6xAMy7RUlnXF/5+SbfQN
        TBPUswyV9vCvlq2wj+ExoTiCxxl8PRxkU10KibxlOOtB4Y3UeCuT7m4hphbl/ajoHzbNOPf+Zfd
        8Rz+paCrYIH5WkO8qzrkU
X-Received: by 2002:a05:6830:168a:: with SMTP id k10mr5423804otr.203.1623947069395;
        Thu, 17 Jun 2021 09:24:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+d0NprwHzFE2jPaz/a4/wCK/BMHIucz+o69xVDaiCB3KMDUH7NMupJ7nscIkQHSD4f6yNqQ==
X-Received: by 2002:a05:6830:168a:: with SMTP id k10mr5423790otr.203.1623947069190;
        Thu, 17 Jun 2021 09:24:29 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id w4sm1356698otm.31.2021.06.17.09.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 09:24:28 -0700 (PDT)
Date:   Thu, 17 Jun 2021 12:24:26 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: factor out a xlog_write_full_log_vec helper
Message-ID: <YMt3OpN3M95p4qHe@bfoster>
References: <20210616163212.1480297-1-hch@lst.de>
 <20210616163212.1480297-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616163212.1480297-8-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 06:32:11PM +0200, Christoph Hellwig wrote:
> Add a helper to write out an entire log_vec to prepare for additional
> cleanups.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 61 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 40 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4afa8ff1a82076..f8df09f37c3b84 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2137,6 +2137,44 @@ xlog_write_iovec(
>  	*data_cnt += write_len;
>  }
>  
> +/*
> + * Write a whole log vector into a single iclog which is guaranteed to have
> + * either sufficient space for the entire log vector chain to be written or
> + * exclusive access to the remaining space in the iclog.
> + *
> + * Return the number of iovecs and data written into the iclog.
> + */
> +static void
> +xlog_write_full(
> +	struct xfs_log_vec	*lv,
> +	struct xlog_ticket	*ticket,
> +	struct xlog_in_core	*iclog,
> +	uint32_t		*log_offset,
> +	uint32_t		*len,
> +	uint32_t		*record_cnt,
> +	uint32_t		*data_cnt)
> +{
> +	int			i;
> +
> +	ASSERT(*log_offset + *len <= iclog->ic_size ||
> +		iclog->ic_state == XLOG_STATE_WANT_SYNC);

I suspect this could be lifted into the original caller (xlog_write())
since it doesn't have much to do with the current lv (and this is
eventually no longer called for each lv in the chain)..? Otherwise the
patch LGTM.

Brian

> +
> +	/*
> +	 * Ordered log vectors have no regions to write so this loop will
> +	 * naturally skip them.
> +	 */
> +	for (i = 0; i < lv->lv_niovecs; i++) {
> +		struct xfs_log_iovec	*reg = &lv->lv_iovecp[i];
> +		struct xlog_op_header	*ophdr = reg->i_addr;
> +
> +		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> +		ophdr->oh_len =
> +			cpu_to_be32(reg->i_len - sizeof(struct xlog_op_header));
> +		xlog_write_iovec(iclog, log_offset, reg->i_addr, reg->i_len,
> +				 len, record_cnt, data_cnt);
> +	}
> +}
> +
>  /*
>   * Write whole log vectors into a single iclog which is guaranteed to have
>   * either sufficient space for the entire log vector chain to be written or
> @@ -2158,10 +2196,6 @@ xlog_write_single(
>  	uint32_t		*data_cnt)
>  {
>  	struct xfs_log_vec	*lv;
> -	int			index;
> -
> -	ASSERT(*log_offset + *len <= iclog->ic_size ||
> -		iclog->ic_state == XLOG_STATE_WANT_SYNC);
>  
>  	for (lv = log_vector;
>  	     !list_entry_is_head(lv, lv_chain, lv_list);
> @@ -2173,23 +2207,8 @@ xlog_write_single(
>  		if (lv->lv_niovecs &&
>  		    lv->lv_bytes > iclog->ic_size - *log_offset)
>  			break;
> -
> -		/*
> -		 * Ordered log vectors have no regions to write so this
> -		 * loop will naturally skip them.
> -		 */
> -		for (index = 0; index < lv->lv_niovecs; index++) {
> -			struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
> -			struct xlog_op_header	*ophdr = reg->i_addr;
> -
> -			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> -			ophdr->oh_len = cpu_to_be32(reg->i_len -
> -						sizeof(struct xlog_op_header));
> -
> -			xlog_write_iovec(iclog, log_offset, reg->i_addr,
> -					 reg->i_len, len, record_cnt,
> -					 data_cnt);
> -		}
> +		xlog_write_full(lv, ticket, iclog, log_offset, len, record_cnt,
> +				data_cnt);
>  	}
>  	if (list_entry_is_head(lv, lv_chain, lv_list))
>  		lv = NULL;
> -- 
> 2.30.2
> 

