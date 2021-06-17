Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1661C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4C04610A5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 16:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhFQQ0Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 12:26:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49130 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232426AbhFQQ0Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 12:26:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623947047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U67yNHT8RpNDIHjNFLinBJUZ+ZT60VPgnznmqdyOaqw=;
        b=J8cW2cFRkZ5xWv0ftgit0UlZO8Ps2p8/EcYFVhpKnKnN+dhibh3oZcYS3h9q+wG6IwqJS+
        zgdrtfnfFD35DjoaThXH5N9tnQz0Wn7tPttOXRhAJCA9JgaU99BODpJxOnxoCeNW2ANIEY
        2364GFTPI8YtribgSSYpbDZO6FXIOmc=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-1hTxUL_WNG6vDNzrtMzQ9A-1; Thu, 17 Jun 2021 12:24:04 -0400
X-MC-Unique: 1hTxUL_WNG6vDNzrtMzQ9A-1
Received: by mail-oi1-f199.google.com with SMTP id u6-20020aca47060000b02901ff152f8393so2612761oia.4
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 09:24:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U67yNHT8RpNDIHjNFLinBJUZ+ZT60VPgnznmqdyOaqw=;
        b=EsbnZLx3AN54pnGXcHiVcAYruC04OzGcnU+AfEVeG7tFbkEWShxP0hbqBbKkgAguRN
         nc21thEqFA/GZVdajLLYbzvT3JmBwGvoH3jPTifj4XmdlWzWBZramDOQknP3wuMW60MI
         p8hWat6gtZOtHTjR+TNNECxyyitNAV2julU0mfx2iLZVA57O2PWU4QGzFezesRi2CbOI
         ppl30ZQC3ljza3kwlK3I+BZ63mbFA+OXz6IMESFuJ3WCqhUWWOCrBhEM4CW9LoL6FPwI
         7VrTXMu9xivXg7GFm03/iTbdCqGEIFECMrrE9HlrN3tGM+E654UM/29xWthtphMiYi4d
         CEjw==
X-Gm-Message-State: AOAM530ZqObWeJW4vnVPemm809Enlny+twH8AHdeQElDUzc1bbD/1eS2
        E0rEAxMXx+FQBeL0X/iiCdAT7/a8q6QWmWm9/i1c9omknMvp/rZnivo1z9I/jqpU2zQr5JG26YY
        bfvtKycBbq8IG2ZhQbSrb
X-Received: by 2002:a05:6808:8fb:: with SMTP id d27mr11809044oic.115.1623947043767;
        Thu, 17 Jun 2021 09:24:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVewRJPBbTo9mkrHwDsZ3/y08zL51RURcHsXWY40Hxqnq2gSGu2jO8/YCrht9C9+1PSBGQZA==
X-Received: by 2002:a05:6808:8fb:: with SMTP id d27mr11809031oic.115.1623947043611;
        Thu, 17 Jun 2021 09:24:03 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id q26sm1264504ood.7.2021.06.17.09.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 09:24:03 -0700 (PDT)
Date:   Thu, 17 Jun 2021 12:24:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: remove xlog_verify_dest_ptr
Message-ID: <YMt3IaFLalxWWWGc@bfoster>
References: <20210616163212.1480297-1-hch@lst.de>
 <20210616163212.1480297-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616163212.1480297-6-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 06:32:09PM +0200, Christoph Hellwig wrote:
> Just check that the offset in xlog_write_vec is smaller than the iclog
> size and remove the expensive cycling through all iclogs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c      | 35 +----------------------------------
>  fs/xfs/xfs_log_priv.h |  4 ----
>  2 files changed, 1 insertion(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 1bc32f056a5bcf..5d55d4fff63035 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -59,10 +59,6 @@ xlog_sync(
>  	struct xlog_ticket	*ticket);
>  #if defined(DEBUG)
>  STATIC void
> -xlog_verify_dest_ptr(
> -	struct xlog		*log,
> -	void			*ptr);
> -STATIC void
>  xlog_verify_grant_tail(
>  	struct xlog *log);
>  STATIC void
> @@ -76,7 +72,6 @@ xlog_verify_tail_lsn(
>  	struct xlog_in_core	*iclog,
>  	xfs_lsn_t		tail_lsn);
>  #else
> -#define xlog_verify_dest_ptr(a,b)
>  #define xlog_verify_grant_tail(a)
>  #define xlog_verify_iclog(a,b,c)
>  #define xlog_verify_tail_lsn(a,b,c)
> @@ -1501,9 +1496,6 @@ xlog_alloc_log(
>  						KM_MAYFAIL | KM_ZERO);
>  		if (!iclog->ic_data)
>  			goto out_free_iclog;
> -#ifdef DEBUG
> -		log->l_iclog_bak[i] = &iclog->ic_header;
> -#endif
>  		head = &iclog->ic_header;
>  		memset(head, 0, sizeof(xlog_rec_header_t));
>  		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
> @@ -2134,6 +2126,7 @@ xlog_write_iovec(
>  	uint32_t		*record_cnt,
>  	uint32_t		*data_cnt)
>  {
> +	ASSERT(*log_offset < iclog->ic_log->l_iclog_size);
>  	ASSERT(*log_offset % sizeof(int32_t) == 0);
>  	ASSERT(write_len % sizeof(int32_t) == 0);
>  
> @@ -2258,7 +2251,6 @@ xlog_write_partial(
>  	struct xfs_log_vec	*lv = log_vector;
>  	struct xfs_log_iovec	*reg;
>  	struct xlog_op_header	*ophdr;
> -	void			*ptr;
>  	int			index = 0;
>  	uint32_t		rlen;
>  	int			error;
> @@ -2297,7 +2289,6 @@ xlog_write_partial(
>  		if (rlen != reg->i_len)
>  			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
>  
> -		xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
>  		xlog_write_iovec(iclog, log_offset, reg->i_addr, rlen, len,
>  				 record_cnt, data_cnt);
>  
> @@ -2363,7 +2354,6 @@ xlog_write_partial(
>  			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
>  			ophdr->oh_len = cpu_to_be32(rlen);
>  
> -			xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
>  			xlog_write_iovec(iclog, log_offset,
>  					 reg->i_addr + reg_offset, rlen, len,
>  					 record_cnt, data_cnt);
> @@ -3466,29 +3456,6 @@ xlog_ticket_alloc(
>  }
>  
>  #if defined(DEBUG)
> -/*
> - * Make sure that the destination ptr is within the valid data region of
> - * one of the iclogs.  This uses backup pointers stored in a different
> - * part of the log in case we trash the log structure.
> - */
> -STATIC void
> -xlog_verify_dest_ptr(
> -	struct xlog	*log,
> -	void		*ptr)
> -{
> -	int i;
> -	int good_ptr = 0;
> -
> -	for (i = 0; i < log->l_iclog_bufs; i++) {
> -		if (ptr >= log->l_iclog_bak[i] &&
> -		    ptr <= log->l_iclog_bak[i] + log->l_iclog_size)
> -			good_ptr++;
> -	}
> -
> -	if (!good_ptr)
> -		xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
> -}
> -
>  /*
>   * Check to make sure the grant write head didn't just over lap the tail.  If
>   * the cycles are the same, we can't be overlapping.  Otherwise, make sure that
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 1b3b3d2bb8a5d1..b829d8ba5c6a3f 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -434,10 +434,6 @@ struct xlog {
>  
>  	struct xfs_kobj		l_kobj;
>  
> -	/* The following field are used for debugging; need to hold icloglock */
> -#ifdef DEBUG
> -	void			*l_iclog_bak[XLOG_MAX_ICLOGS];
> -#endif
>  	/* log recovery lsn tracking (for buffer submission */
>  	xfs_lsn_t		l_recovery_lsn;
>  
> -- 
> 2.30.2
> 

