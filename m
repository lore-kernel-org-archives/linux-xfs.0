Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0392BC49EA2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEA91613AA
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhFQQ0r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 12:26:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32989 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232483AbhFQQ0q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 12:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623947078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eZFJJE7ztZRhf5fjsH/vBaQh6li+raFenRokypBxdLQ=;
        b=JsNmAobYGIpp4r9HeZiXpcJNuZQ91a/kcUyD8KidR7lKd4WyAHlK//MVkCGoVDFl+njckj
        mZEww2zNnnGSHdtcoWCopYgu//3tBcD/WSmPCUW7sPdWCWATxlYYyXzOYSqR3/R308DX29
        elkS4uwm5ivsTBkLPZ1MsGlN1QViG1o=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-n-KoZnpsP2ebvql7nF-Odw-1; Thu, 17 Jun 2021 12:24:37 -0400
X-MC-Unique: n-KoZnpsP2ebvql7nF-Odw-1
Received: by mail-ot1-f70.google.com with SMTP id l18-20020a9d70920000b029044977534021so3213525otj.12
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 09:24:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eZFJJE7ztZRhf5fjsH/vBaQh6li+raFenRokypBxdLQ=;
        b=D6FuqNKPk/5F+aI0JjbrdwuZApoMHghyDshD1QHSapVKGj0fNVH3+87JV8JrAnPi1E
         1bRKak01Ud80B0C+z6oC8h6wN0T8wGlVKThrli1XsFwuolUogkmCDg+JshRbTV3kucxc
         qmclF0xUNTJhvvW2MdIWShBbM+n7+G3uT5g/MwdEFRe+6GFPkjGkDsTb3mdoTBLqv7fH
         q+uX9VdN1Ige4nTZJ5mIh4hb9aVP5LJ15Hymv70i0kVbbu5yB4vLwqFqZDCE2Bmd/t0/
         D2VVc098HHr78ze1p5H3GW+l3UOFsPMs6GGnlcHs6Z38MWqOYxvV2w26NdozruVZqaMP
         yd2w==
X-Gm-Message-State: AOAM5331MGQgZzx578899jSjv2x62XXVDXySggdDINrZDpspWHVs5QDn
        zUC8dwsmdhWLRzsb8rnxkvyS9VnrAYYzfgjDmw3py5F9PkPnmdvu3TvGbQD8NR8ZLbRAxpJfPh8
        edAQVVknvE0dZkILYt6Jz
X-Received: by 2002:a05:6808:605:: with SMTP id y5mr8345199oih.74.1623947076863;
        Thu, 17 Jun 2021 09:24:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVj/P6YnOIsuLmZirKHTxdPGHDLMXBimagaF0kPc6he4gItlfsS0sluToOUa2seDqSpM01Kg==
X-Received: by 2002:a05:6808:605:: with SMTP id y5mr8345188oih.74.1623947076724;
        Thu, 17 Jun 2021 09:24:36 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id l18sm1340238otr.50.2021.06.17.09.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 09:24:36 -0700 (PDT)
Date:   Thu, 17 Jun 2021 12:24:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: simplify the list iteration in xlog_write
Message-ID: <YMt3Qqseo/rjTxU+@bfoster>
References: <20210616163212.1480297-1-hch@lst.de>
 <20210616163212.1480297-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616163212.1480297-9-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 06:32:12PM +0200, Christoph Hellwig wrote:
> Just use a single list_for_each_entry in xlog_write which then
> dispatches to the simple or partial cases instead of using nested
> loops.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 73 +++++++++++-------------------------------------
>  1 file changed, 17 insertions(+), 56 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f8df09f37c3b84..365914c25ff0f0 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2175,47 +2175,6 @@ xlog_write_full(
>  	}
>  }
>  
> -/*
> - * Write whole log vectors into a single iclog which is guaranteed to have
> - * either sufficient space for the entire log vector chain to be written or
> - * exclusive access to the remaining space in the iclog.
> - *
> - * Return the number of iovecs and data written into the iclog, as well as
> - * a pointer to the logvec that doesn't fit in the log (or NULL if we hit the
> - * end of the chain.
> - */
> -static struct xfs_log_vec *
> -xlog_write_single(
> -	struct list_head	*lv_chain,
> -	struct xfs_log_vec	*log_vector,
> -	struct xlog_ticket	*ticket,
> -	struct xlog_in_core	*iclog,
> -	uint32_t		*log_offset,
> -	uint32_t		*len,
> -	uint32_t		*record_cnt,
> -	uint32_t		*data_cnt)
> -{
> -	struct xfs_log_vec	*lv;
> -
> -	for (lv = log_vector;
> -	     !list_entry_is_head(lv, lv_chain, lv_list);
> -	     lv = list_next_entry(lv, lv_list)) {
> -		/*
> -		 * If the entire log vec does not fit in the iclog, punt it to
> -		 * the partial copy loop which can handle this case.
> -		 */
> -		if (lv->lv_niovecs &&
> -		    lv->lv_bytes > iclog->ic_size - *log_offset)
> -			break;
> -		xlog_write_full(lv, ticket, iclog, log_offset, len, record_cnt,
> -				data_cnt);
> -	}
> -	if (list_entry_is_head(lv, lv_chain, lv_list))
> -		lv = NULL;
> -	ASSERT(*len == 0 || lv);
> -	return lv;
> -}
> -
>  static int
>  xlog_write_get_more_iclog_space(
>  	struct xlog		*log,
> @@ -2454,22 +2413,24 @@ xlog_write(
>  	if (start_lsn)
>  		*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  
> -	lv = list_first_entry_or_null(lv_chain, struct xfs_log_vec, lv_list);
> -	while (lv) {
> -		lv = xlog_write_single(lv_chain, lv, ticket, iclog, &log_offset,
> -					&len, &record_cnt, &data_cnt);
> -		if (!lv)
> -			break;
> -
> -		error = xlog_write_partial(lv, ticket, &iclog, &log_offset,
> -					   &len, &record_cnt, &data_cnt);
> -		if (error)
> -			break;
> -		lv = list_next_entry(lv, lv_list);
> -		if (list_entry_is_head(lv, lv_chain, lv_list))
> -			break;
> +	list_for_each_entry(lv, lv_chain, lv_list) {
> +		/*
> +		 * If the entire log vec does not fit in the iclog, punt it to
> +		 * the partial copy loop which can handle this case.
> +		 */
> +		if (lv->lv_niovecs &&
> +		    lv->lv_bytes > iclog->ic_size - log_offset) {
> +			error = xlog_write_partial(lv, ticket, &iclog,
> +						   &log_offset, &len,
> +						   &record_cnt, &data_cnt);
> +			if (error)
> +				break;
> +		} else {
> +			xlog_write_full(lv, ticket, iclog, &log_offset, &len,
> +					&record_cnt, &data_cnt);
> +		}
>  	}
> -	ASSERT((len == 0 && !lv) || error);
> +	ASSERT(len == 0 || error);
>  
>  	/*
>  	 * We've already been guaranteed that the last writes will fit inside
> -- 
> 2.30.2
> 

