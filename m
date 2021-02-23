Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95CA1C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 10:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A51064E4B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 10:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhBWKa0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 05:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhBWKaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 05:30:16 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84200C06178A
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 02:29:36 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 23so3966837pgg.4
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 02:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=WG7t8GuRKfrGFhwkLfb+5COavjStpY7UuQ7ZNCUSCjU=;
        b=EhW/MqaomNuIpnIPzEepMX/HzbUrEAlMkgE3Ex8jnEuXMEfWls48Bn8k8FVQ/slpL9
         edKpb7SUkVbWy1DVaxZeMWvNFluu6QhCME57l9nWVVaEw7iJa7DlkDvmoejILpj20Yj5
         GLteVrhwmREE0VhP2xu+fp92v8v32JQp9gg0H099AGn1932LklJctIkjdHvhZwY9QzJp
         ttLlwZpajsXVq68/jn4Icm/9R7VYFwnOoRglhhmqy3ZQr9vpk/qyeWUvN9fNBWoC+1+o
         Zwx0yL9f8bDgGMRVqhYRkqMb/C6XydAYLynVpCMcqzkKkL6mYjTS8sqrPKl69KNaV27/
         lk1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=WG7t8GuRKfrGFhwkLfb+5COavjStpY7UuQ7ZNCUSCjU=;
        b=Qb+LZyc00apAR5z3LVESNtaZo+Jvj0u1MNkpBIa2xgh1VYFc0d/gvymy+DQDHe7zKm
         eyodg953tdkycKKQPIyqmESoyHCi83lZRYEFqErJ4je4+VnsK8WIgw8IM2NtxqfqgT2h
         yvManNH3urnEKAnLlgwxH6Z7GgYJC9FlXKGFkCmvXvJ1kos6+iOv/SIv0ltAnEPQe5MU
         +j8uvBPYXax97qe8VsrgVEWvCX225iwj7l6I/OVmoFu0iuKr2TNGwUVOrLSlWF2qBQT3
         VGHtN3WFPOxnVyDt04C0BFeLTzP52voz33fGCRiNbUp7DLFps9x5QkWuq5lnQEcWx44v
         5yPQ==
X-Gm-Message-State: AOAM531nYLSyyyBRhkLi69wg2TT395hQJV7M+eugr+2xH5kbQmh+2Ppc
        wn0e4FaXI2K2NIOqPoW7d2Q9G2uK0+o=
X-Google-Smtp-Source: ABdhPJxtd28goPImlZRhrzk9EA0+kzlYoxCQZsmvmGV+rKYYDBf/ZvnO47bVZpHNfxFzzAwtEMl8PQ==
X-Received: by 2002:a63:8c0b:: with SMTP id m11mr16248334pgd.306.1614076175840;
        Tue, 23 Feb 2021 02:29:35 -0800 (PST)
Received: from garuda ([122.171.216.250])
        by smtp.gmail.com with ESMTPSA id d27sm8026110pfq.40.2021.02.23.02.29.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Feb 2021 02:29:35 -0800 (PST)
References: <20210223033442.3267258-1-david@fromorbit.com> <20210223033442.3267258-2-david@fromorbit.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: log stripe roundoff is a property of the log
In-reply-to: <20210223033442.3267258-2-david@fromorbit.com>
Date:   Tue, 23 Feb 2021 15:59:30 +0530
Message-ID: <87im6jm60l.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Feb 2021 at 09:04, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> We don't need to look at the xfs_mount and superblock every time we
> need to do an iclog roundoff calculation. The property is fixed for
> the life of the log, so store the roundoff in the log at mount time
> and use that everywhere.
>
> On a debug build:
>
> $ size fs/xfs/xfs_log.o.*
>    text	   data	    bss	    dec	    hex	filename
>   27360	    560	      8	  27928	   6d18	fs/xfs/xfs_log.o.orig
>   27219	    560	      8	  27787	   6c8b	fs/xfs/xfs_log.o.patched
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_log_format.h |  3 --
>  fs/xfs/xfs_log.c               | 59 ++++++++++++++--------------------
>  fs/xfs/xfs_log_priv.h          |  2 ++
>  3 files changed, 27 insertions(+), 37 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 8bd00da6d2a4..16587219549c 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -34,9 +34,6 @@ typedef uint32_t xlog_tid_t;
>  #define XLOG_MIN_RECORD_BSHIFT	14		/* 16384 == 1 << 14 */
>  #define XLOG_BIG_RECORD_BSHIFT	15		/* 32k == 1 << 15 */
>  #define XLOG_MAX_RECORD_BSHIFT	18		/* 256k == 1 << 18 */
> -#define XLOG_BTOLSUNIT(log, b)  (((b)+(log)->l_mp->m_sb.sb_logsunit-1) / \
> -                                 (log)->l_mp->m_sb.sb_logsunit)
> -#define XLOG_LSUNITTOB(log, su) ((su) * (log)->l_mp->m_sb.sb_logsunit)
>  
>  #define XLOG_HEADER_SIZE	512
>  
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 06041834daa3..fa284f26d10e 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1399,6 +1399,11 @@ xlog_alloc_log(
>  	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
>  	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
>  
> +	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1)
> +		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
> +	else
> +		log->l_iclog_roundoff = BBSIZE;
> +
>  	xlog_grant_head_init(&log->l_reserve_head);
>  	xlog_grant_head_init(&log->l_write_head);
>  
> @@ -1852,29 +1857,15 @@ xlog_calc_iclog_size(
>  	uint32_t		*roundoff)
>  {
>  	uint32_t		count_init, count;
> -	bool			use_lsunit;
> -
> -	use_lsunit = xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
> -			log->l_mp->m_sb.sb_logsunit > 1;
>  
>  	/* Add for LR header */
>  	count_init = log->l_iclog_hsize + iclog->ic_offset;
> +	count = roundup(count_init, log->l_iclog_roundoff);
>  
> -	/* Round out the log write size */
> -	if (use_lsunit) {
> -		/* we have a v2 stripe unit to use */
> -		count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));
> -	} else {
> -		count = BBTOB(BTOBB(count_init));
> -	}
> -
> -	ASSERT(count >= count_init);
>  	*roundoff = count - count_init;
>  
> -	if (use_lsunit)
> -		ASSERT(*roundoff < log->l_mp->m_sb.sb_logsunit);
> -	else
> -		ASSERT(*roundoff < BBTOB(1));
> +	ASSERT(count >= count_init);
> +	ASSERT(*roundoff < log->l_iclog_roundoff);
>  	return count;
>  }
>  
> @@ -3149,10 +3140,9 @@ xlog_state_switch_iclogs(
>  	log->l_curr_block += BTOBB(eventual_size)+BTOBB(log->l_iclog_hsize);
>  
>  	/* Round up to next log-sunit */
> -	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
> -	    log->l_mp->m_sb.sb_logsunit > 1) {
> -		uint32_t sunit_bb = BTOBB(log->l_mp->m_sb.sb_logsunit);
> -		log->l_curr_block = roundup(log->l_curr_block, sunit_bb);
> +	if (log->l_iclog_roundoff > BBSIZE) {
> +		log->l_curr_block = roundup(log->l_curr_block,
> +						BTOBB(log->l_iclog_roundoff));
>  	}
>  
>  	if (log->l_curr_block >= log->l_logBBsize) {
> @@ -3404,12 +3394,11 @@ xfs_log_ticket_get(
>   * Figure out the total log space unit (in bytes) that would be
>   * required for a log ticket.
>   */
> -int
> -xfs_log_calc_unit_res(
> -	struct xfs_mount	*mp,
> +static int
> +xlog_calc_unit_res(
> +	struct xlog		*log,
>  	int			unit_bytes)
>  {
> -	struct xlog		*log = mp->m_log;
>  	int			iclog_space;
>  	uint			num_headers;
>  
> @@ -3485,18 +3474,20 @@ xfs_log_calc_unit_res(
>  	/* for commit-rec LR header - note: padding will subsume the ophdr */
>  	unit_bytes += log->l_iclog_hsize;
>  
> -	/* for roundoff padding for transaction data and one for commit record */
> -	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1) {
> -		/* log su roundoff */
> -		unit_bytes += 2 * mp->m_sb.sb_logsunit;
> -	} else {
> -		/* BB roundoff */
> -		unit_bytes += 2 * BBSIZE;
> -        }
> +	/* roundoff padding for transaction data and one for commit record */
> +	unit_bytes += 2 * log->l_iclog_roundoff;
>  
>  	return unit_bytes;
>  }
>  
> +int
> +xfs_log_calc_unit_res(
> +	struct xfs_mount	*mp,
> +	int			unit_bytes)
> +{
> +	return xlog_calc_unit_res(mp->m_log, unit_bytes);
> +}
> +
>  /*
>   * Allocate and initialise a new log ticket.
>   */
> @@ -3513,7 +3504,7 @@ xlog_ticket_alloc(
>  
>  	tic = kmem_cache_zalloc(xfs_log_ticket_zone, GFP_NOFS | __GFP_NOFAIL);
>  
> -	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
> +	unit_res = xlog_calc_unit_res(log, unit_bytes);
>  
>  	atomic_set(&tic->t_ref, 1);
>  	tic->t_task		= current;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 1c6fdbf3d506..037950cf1061 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -436,6 +436,8 @@ struct xlog {
>  #endif
>  	/* log recovery lsn tracking (for buffer submission */
>  	xfs_lsn_t		l_recovery_lsn;
> +
> +	uint32_t		l_iclog_roundoff;/* padding roundoff */
>  };
>  
>  #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \


-- 
chandan
