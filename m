Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EECEC48BDF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 15:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37C1261492
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 15:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhFOPkA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Jun 2021 11:40:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230076AbhFOPkA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jun 2021 11:40:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623771475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SnzVmrtghThvPBt2LUuIefPWCcvFI5rUqRZE0d6JGLg=;
        b=R7G0LEo0k7F+9Eor433IGNX/n8BMfwraG0gWaXoW6KgHTdzZFADpC0/P9/4Lyr0qfJc2sK
        RAj7AyoXL+KG4YumcvFCrc0Dqj1oKhufn4BTqZpiy1H1BKAXIacT2c2m3Pfavz/6W+g2Hb
        +1HAI+1atw/Ob8lhPzTlX+LpsCks/J0=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-P8NJche1PYygkMHZRtZRpg-1; Tue, 15 Jun 2021 11:37:53 -0400
X-MC-Unique: P8NJche1PYygkMHZRtZRpg-1
Received: by mail-oi1-f200.google.com with SMTP id f84-20020aca38570000b02901f424a672b7so7858950oia.18
        for <linux-xfs@vger.kernel.org>; Tue, 15 Jun 2021 08:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SnzVmrtghThvPBt2LUuIefPWCcvFI5rUqRZE0d6JGLg=;
        b=DUvmjeKQy9WLc/TVx5C8pa36+G0azBPQzxhx90nGDqwGCfBS4W3MvpwRF4Vn74GwEb
         n+On6FlW2FRsgqgMbx9A9utZLYDw9TNZE1gkNzTeNXQaCJTqC2APxgXsVp6pM9PUBQWS
         /UXkU5U2TwqtsG/R39trHnnzHArCnUMEyN030ySQKujFnpPeak7ju9NO+OnjZVvx3vW0
         cP3zeZTS1gvF5edOsfq5OGV0e8ptJWwNsrnnxe8bBcH8D9yugxUY/c6sEK1BT7KRHMk7
         /ayAHmNqz8tNjjaXul0S5khhAG9ydt2bEbKPCM1im/oGtcK6wKv/AKEQQ3tZiMFWcBvN
         sFBw==
X-Gm-Message-State: AOAM5322uGJkgQSIeLxHVFTZwOnRTlMkB6Ql1hxuHpUhh3FZmJAM43Dc
        BCcTYNA5LxFbd8se9jXz1DQCJVXMtaydCpSRMIm18wQquMry51UlGYSfmVK8Si0pOJH0huH64kV
        rh7oajkTtwlzpLYMKSW8W
X-Received: by 2002:a05:6830:907:: with SMTP id v7mr10137238ott.170.1623771472765;
        Tue, 15 Jun 2021 08:37:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzWITjgR/f2S7WjjTHzPQPQL61Y9ZiHpg2OUlHNHt2j4aj09D/GNUJwdR3laa9vpZ/5LhI4A==
X-Received: by 2002:a05:6830:907:: with SMTP id v7mr10137222ott.170.1623771472504;
        Tue, 15 Jun 2021 08:37:52 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id l19sm3880569oou.2.2021.06.15.08.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:37:52 -0700 (PDT)
Date:   Tue, 15 Jun 2021 11:37:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: add iclog state trace events
Message-ID: <YMjJTQfDQ3muz2YQ@bfoster>
References: <20210615064658.854029-1-david@fromorbit.com>
 <20210615064658.854029-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615064658.854029-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 15, 2021 at 04:46:57PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For the DEBUGS!
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c   | 18 ++++++++++++++++
>  fs/xfs/xfs_trace.h | 52 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 70 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e921b554b683..54fd6a695bb5 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -524,6 +524,7 @@ __xlog_state_release_iclog(
>  		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
>  		xlog_verify_tail_lsn(log, iclog, tail_lsn);
>  		/* cycle incremented when incrementing curr_block */
> +		trace_xlog_iclog_syncing(iclog, _RET_IP_);
>  		return true;
>  	}
>  
> @@ -543,6 +544,7 @@ xlog_state_release_iclog(
>  {
>  	lockdep_assert_held(&log->l_icloglock);
>  
> +	trace_xlog_iclog_release(iclog, _RET_IP_);
>  	if (iclog->ic_state == XLOG_STATE_IOERROR)
>  		return -EIO;
>  
> @@ -804,6 +806,7 @@ xlog_wait_on_iclog(
>  {
>  	struct xlog		*log = iclog->ic_log;
>  
> +	trace_xlog_iclog_wait_on(iclog, _RET_IP_);

Seems like this might be more informative if we actually wait.

>  	if (!XLOG_FORCED_SHUTDOWN(log) &&
>  	    iclog->ic_state != XLOG_STATE_ACTIVE &&
>  	    iclog->ic_state != XLOG_STATE_DIRTY) {
> @@ -1804,6 +1807,7 @@ xlog_write_iclog(
>  	unsigned int		count)
>  {
>  	ASSERT(bno < log->l_logBBsize);
> +	trace_xlog_iclog_write(iclog, _RET_IP_);
>  
>  	/*
>  	 * We lock the iclogbufs here so that we can serialise against I/O
> @@ -1950,6 +1954,7 @@ xlog_sync(
>  	unsigned int		size;
>  
>  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
> +	trace_xlog_iclog_sync(iclog, _RET_IP_);
>  
>  	count = xlog_calc_iclog_size(log, iclog, &roundoff);
>  
> @@ -2488,6 +2493,7 @@ xlog_state_activate_iclog(
>  	int			*iclogs_changed)
>  {
>  	ASSERT(list_empty_careful(&iclog->ic_callbacks));
> +	trace_xlog_iclog_activate(iclog, _RET_IP_);
>  

I wonder a bit whether these state change oriented tracepoints could be
served by a single trace_ixlog_iclog_state() or some such, since the
tracepoint already prints the state. That wouldn't show the before ->
state in each tracepoint, but that should reflect in the full log.

>  	/*
>  	 * If the number of ops in this iclog indicate it just contains the
> @@ -2577,6 +2583,8 @@ xlog_state_clean_iclog(
>  {
>  	int			iclogs_changed = 0;
>  
> +	trace_xlog_iclog_clean(dirty_iclog, _RET_IP_);
> +
>  	dirty_iclog->ic_state = XLOG_STATE_DIRTY;
>  
>  	xlog_state_activate_iclogs(log, &iclogs_changed);
> @@ -2636,6 +2644,7 @@ xlog_state_set_callback(
>  	struct xlog_in_core	*iclog,
>  	xfs_lsn_t		header_lsn)
>  {
> +	trace_xlog_iclog_callback(iclog, _RET_IP_);
>  	iclog->ic_state = XLOG_STATE_CALLBACK;
>  
>  	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> @@ -2717,6 +2726,7 @@ xlog_state_do_iclog_callbacks(
>  		__releases(&log->l_icloglock)
>  		__acquires(&log->l_icloglock)
>  {
> +	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
>  	spin_unlock(&log->l_icloglock);
>  	spin_lock(&iclog->ic_callback_lock);
>  	while (!list_empty(&iclog->ic_callbacks)) {
> @@ -2736,6 +2746,7 @@ xlog_state_do_iclog_callbacks(
>  	 */
>  	spin_lock(&log->l_icloglock);
>  	spin_unlock(&iclog->ic_callback_lock);
> +	trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
>  }
>  
>  STATIC void
> @@ -2827,6 +2838,7 @@ xlog_state_done_syncing(
>  
>  	spin_lock(&log->l_icloglock);
>  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
> +	trace_xlog_iclog_sync_done(iclog, _RET_IP_);
>  
>  	/*
>  	 * If we got an error, either on the first buffer, or in the case of
> @@ -2899,6 +2911,8 @@ xlog_state_get_iclog_space(
>  	atomic_inc(&iclog->ic_refcnt);	/* prevents sync */
>  	log_offset = iclog->ic_offset;
>  
> +	trace_xlog_iclog_get_space(iclog, _RET_IP_);
> +
>  	/* On the 1st write to an iclog, figure out lsn.  This works
>  	 * if iclogs marked XLOG_STATE_WANT_SYNC always write out what they are
>  	 * committing to.  If the offset is set, that's how many blocks
> @@ -3056,6 +3070,7 @@ xlog_state_switch_iclogs(
>  {
>  	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
>  	assert_spin_locked(&log->l_icloglock);
> +	trace_xlog_iclog_switch(iclog, _RET_IP_);
>  
>  	if (!eventual_size)
>  		eventual_size = iclog->ic_offset;
> @@ -3138,6 +3153,8 @@ xfs_log_force(
>  	if (iclog->ic_state == XLOG_STATE_IOERROR)
>  		goto out_error;
>  
> +	trace_xlog_iclog_force(iclog, _RET_IP_);
> +

We have a log force tracepoint a few lines up. Do we need both?

>  	if (iclog->ic_state == XLOG_STATE_DIRTY ||
>  	    (iclog->ic_state == XLOG_STATE_ACTIVE &&
>  	     atomic_read(&iclog->ic_refcnt) == 0 && iclog->ic_offset == 0)) {
> @@ -3225,6 +3242,7 @@ xlog_force_lsn(
>  		goto out_error;
>  
>  	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
> +		trace_xlog_iclog_force_lsn(iclog, _RET_IP_);
>  		iclog = iclog->ic_next;
>  		if (iclog == log->l_iclog)
>  			goto out_unlock;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 71dca776c110..79ee973ba1ed 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -24,6 +24,7 @@ struct xlog_ticket;
>  struct xlog_recover;
>  struct xlog_recover_item;
>  struct xlog_rec_header;
> +struct xlog_in_core;
>  struct xfs_buf_log_format;
>  struct xfs_inode_log_format;
>  struct xfs_bmbt_irec;
> @@ -3927,6 +3928,57 @@ DEFINE_EVENT(xfs_icwalk_class, name,	\
>  DEFINE_ICWALK_EVENT(xfs_ioc_free_eofblocks);
>  DEFINE_ICWALK_EVENT(xfs_blockgc_free_space);
>  
> +DECLARE_EVENT_CLASS(xlog_iclog_class,
> +	TP_PROTO(struct xlog_in_core *iclog, unsigned long caller_ip),
> +	TP_ARGS(iclog, caller_ip),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(uint32_t, state)
> +		__field(int32_t, refcount)
> +		__field(uint32_t, offset)
> +		__field(unsigned long long, lsn)
> +		__field(unsigned long, caller_ip)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = iclog->ic_log->l_mp->m_super->s_dev;
> +		__entry->state = iclog->ic_state;
> +		__entry->refcount = atomic_read(&iclog->ic_refcnt);
> +		__entry->offset = iclog->ic_offset;
> +		__entry->lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +		__entry->caller_ip = caller_ip;
> +	),
> +	TP_printk("dev %d:%d state 0x%x refcnt %d offset %u lsn 0x%llx caller %pS",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->state,

It might be nice to see a string representation of the state like we do
for other things like log item type, etc.

Brian

> +		  __entry->refcount,
> +		  __entry->offset,
> +		  __entry->lsn,
> +		  (char *)__entry->caller_ip)
> +
> +);
> +
> +#define DEFINE_ICLOG_EVENT(name)	\
> +DEFINE_EVENT(xlog_iclog_class, name,	\
> +	TP_PROTO(struct xlog_in_core *iclog, unsigned long caller_ip), \
> +	TP_ARGS(iclog, caller_ip))
> +
> +DEFINE_ICLOG_EVENT(xlog_iclog_activate);
> +DEFINE_ICLOG_EVENT(xlog_iclog_clean);
> +DEFINE_ICLOG_EVENT(xlog_iclog_callback);
> +DEFINE_ICLOG_EVENT(xlog_iclog_callbacks_start);
> +DEFINE_ICLOG_EVENT(xlog_iclog_callbacks_done);
> +DEFINE_ICLOG_EVENT(xlog_iclog_force);
> +DEFINE_ICLOG_EVENT(xlog_iclog_force_lsn);
> +DEFINE_ICLOG_EVENT(xlog_iclog_get_space);
> +DEFINE_ICLOG_EVENT(xlog_iclog_release);
> +DEFINE_ICLOG_EVENT(xlog_iclog_switch);
> +DEFINE_ICLOG_EVENT(xlog_iclog_sync);
> +DEFINE_ICLOG_EVENT(xlog_iclog_syncing);
> +DEFINE_ICLOG_EVENT(xlog_iclog_sync_done);
> +DEFINE_ICLOG_EVENT(xlog_iclog_want_sync);
> +DEFINE_ICLOG_EVENT(xlog_iclog_wait_on);
> +DEFINE_ICLOG_EVENT(xlog_iclog_write);
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> -- 
> 2.31.1
> 

