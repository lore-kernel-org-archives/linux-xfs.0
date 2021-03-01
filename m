Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE20C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 15:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0472764E56
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 15:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbhCAPQI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 10:16:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48605 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237024AbhCAPPG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 10:15:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614611616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d7XMxNLabizf9SPbxpnTMNqWKy0o3FQ3EMRNX6U51Jg=;
        b=gPgMIwnQ+XibNA2oX2sIgCoxWwRoIwuZU0q5+XoiRWLyNTGSx5BIayeZDRFRX08jyJF5eK
        HvVfSd0PP1IwgjYqF3xP7glj8GW//OdKLLW52PjjSOZXaXLEdSyLSa4Y/waYNqHHm7Gbf7
        kqrhtmwaoJzL+7LmjIfNCtY9m9GL0o4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-1FCgDFwyPxel4k2YkgjRcA-1; Mon, 01 Mar 2021 10:13:35 -0500
X-MC-Unique: 1FCgDFwyPxel4k2YkgjRcA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33AE5814301;
        Mon,  1 Mar 2021 15:13:34 +0000 (UTC)
Received: from bfoster (ovpn-113-120.rdu2.redhat.com [10.10.113.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CCA7D5C1D1;
        Mon,  1 Mar 2021 15:13:33 +0000 (UTC)
Date:   Mon, 1 Mar 2021 10:13:31 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: log stripe roundoff is a property of the log
Message-ID: <YD0Emze0LNf3F9BB@bfoster>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223033442.3267258-2-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 02:34:35PM +1100, Dave Chinner wrote:
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

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
> -- 
> 2.28.0
> 

