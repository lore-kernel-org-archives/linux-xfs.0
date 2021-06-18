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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB5B2C48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 10:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B569961175
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 10:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhFRKdQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 06:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhFRKdQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jun 2021 06:33:16 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220BBC061574
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 03:31:06 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id q192so798503pfc.7
        for <linux-xfs@vger.kernel.org>; Fri, 18 Jun 2021 03:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=5g9jwv8hzvQurzwfaoMaGYFYEBehGTJdwv/zpq5r2HM=;
        b=MSVEylQsoctJgyd5nrv/kO09wwkiKmoquSCBA7TKEPSdi9Cu6RnZ+RV75oQKMpchIH
         AypbGfgfZVMxcVNM93uI2EJ4BpmYNcMxD96WgoNGFKwDjkdfJI6xsdHwLN87mY/4Kn67
         1gO8ceMaIXEYB6IhsUhL2JHPN9fqVxjR7Lqh9DN2CiT9GAauJqj+h4/3aMfVfjumAPIy
         6z6LWkW0GH8fYzR+RQqhQWRPs8IP4kgxjiY9NZMzgIVPSpKzigiIB+pJoUSkFE8cJGHB
         oQHQIuoiCrFvxG1F2PScZb6jzRtKRC0DB5QC8B2RNDw/kZQB4jeYL71BHjk5WbPLyoId
         4oPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=5g9jwv8hzvQurzwfaoMaGYFYEBehGTJdwv/zpq5r2HM=;
        b=UyLN/kh89+lcZoGfxE+pKpxuOit/QHKdZ9bx4mvK06BzNhdI/zXcGqPG9191BbSoHe
         PiyQjv+smZ7f3bJ7QQufxrI+f1gKamDCOUCgHy1DLLsdbbm9Z6JwYBWYcEui8jGAKZ0P
         Yb50h/1fad9Z8Y48WWSMep8A7dJ+KTmb9m2+R6ic27CeSqLbOO0eCbgS3k8++wVdCxBs
         yQX4I60u34gWBf2aipkOYaY3r/BacKUrAUOuZEVeWTEmHwTvb6gFDV14I4iIP2RuinUz
         SHUwCQ0ZKqmM+03FiOCklx6l9DAehKCnMIb1fabTS6Zs9zmlAf61DPdPwwbHiEu66LOU
         FLgw==
X-Gm-Message-State: AOAM530nE+Fs0CshO7EvXf6QW+RsU2xBOW0aK9aMOAlkWqFi9GemPgoI
        Ud+S0B3O52jJyRfwvZ03MsLOWBkoOuH9qA==
X-Google-Smtp-Source: ABdhPJwEyhu0CnJX9VH3yktJovLJeNEnA+R48nd3kUqIIGKalIB1bJrZOnq/inAJ1/bX8EmiZpbRCg==
X-Received: by 2002:a62:e404:0:b029:2ee:f086:726f with SMTP id r4-20020a62e4040000b02902eef086726fmr4519335pfh.7.1624012265526;
        Fri, 18 Jun 2021 03:31:05 -0700 (PDT)
Received: from garuda ([122.167.197.147])
        by smtp.gmail.com with ESMTPSA id m126sm8254595pfb.15.2021.06.18.03.31.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 18 Jun 2021 03:31:05 -0700 (PDT)
References: <20210616163212.1480297-1-hch@lst.de> <20210616163212.1480297-6-hch@lst.de>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: remove xlog_verify_dest_ptr
In-reply-to: <20210616163212.1480297-6-hch@lst.de>
Date:   Fri, 18 Jun 2021 16:01:02 +0530
Message-ID: <8735tftqft.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 16 Jun 2021 at 22:02, Christoph Hellwig wrote:
> Just check that the offset in xlog_write_vec is smaller than the iclog
> size and remove the expensive cycling through all iclogs.
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
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


-- 
chandan
