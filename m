Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD4FC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 14:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8F6B64DF9
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 14:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhA1O70 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 09:59:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232210AbhA1O6e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 09:58:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611845828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VAcr+6nHcBViXkV7so/L0p3++uOr9Yig93hYmzTyj2I=;
        b=Rqu9sRwzxci8iolb8sYF1saVdWLuHqDniwJl8DZ5yaylFcAH3+rvXu37ovtDo7WMAxPDZp
        BLSBUAUL4PmOifXWPi/k1lwzHgHCfzabx7wCRodEjgTYOIHSYXGL/gQ6RVcZZ3XwIKIdq3
        5NHB3p85PMPmtiasGPM/kkipwrIFQ/8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-WZM-rQd5M96-4r7CwQIC6w-1; Thu, 28 Jan 2021 09:57:06 -0500
X-MC-Unique: WZM-rQd5M96-4r7CwQIC6w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F909180A094;
        Thu, 28 Jan 2021 14:57:05 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F28705D9EF;
        Thu, 28 Jan 2021 14:57:04 +0000 (UTC)
Date:   Thu, 28 Jan 2021 09:57:03 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: log stripe roundoff is a property of the log
Message-ID: <20210128145703.GA2599027@bfoster>
References: <20210128044154.806715-1-david@fromorbit.com>
 <20210128044154.806715-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128044154.806715-2-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 03:41:50PM +1100, Dave Chinner wrote:
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
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_log_format.h |  3 --
>  fs/xfs/xfs_log.c               | 60 +++++++++++++++-------------------
>  fs/xfs/xfs_log_priv.h          |  2 ++
>  3 files changed, 28 insertions(+), 37 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 58699881c100..c5f507c24577 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1400,6 +1400,12 @@ xlog_alloc_log(
>  	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
>  	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
>  
> +	/* roundoff padding for transaction data and one for commit record */

I don't follow this comment. What do you mean by "... and one for commit
record?"

> +	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1)
> +		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
> +	else
> +		log->l_iclog_roundoff = BBSIZE;
> +
>  	xlog_grant_head_init(&log->l_reserve_head);
>  	xlog_grant_head_init(&log->l_write_head);
>  
...
> @@ -3485,18 +3475,20 @@ xfs_log_calc_unit_res(
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
> +	unit_bytes += log->l_iclog_roundoff;
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

Could this be moved to the header as an inline? Otherwise looks
reasonable.

Brian

>  /*
>   * Allocate and initialise a new log ticket.
>   */
> @@ -3513,7 +3505,7 @@ xlog_ticket_alloc(
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
> -- 
> 2.28.0
> 

