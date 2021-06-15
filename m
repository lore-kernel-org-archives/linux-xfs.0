Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56901C48BE5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 15:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C9B60FF4
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 15:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhFOP3C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Jun 2021 11:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230463AbhFOP2u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Jun 2021 11:28:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F19A960FE6;
        Tue, 15 Jun 2021 15:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623770806;
        bh=tE+KkAt3Syz+Dbx9+Op+oI+sKkxVxmwYzMZvNw7QTbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KDdobmNBdzYOP2+3rpQb6wK7RMBPTX0Ch2VogNoMdnHAoAgFwaefG7oVZr4KNnlJ5
         4t/krzr7jMkPjfGw0P35mxja3a6mEAA6CUdQhmOGPGf2yheEJvC6X2zEU1X2mxfGkx
         tu1fK1kr2JaZQEk+DsPH4we8xqeVbm2vUxvx/8vX6Mr4wcqOTBWFmFUW8WWSazogk2
         Y4VzyeXd9JMWAHJQxE9IPzq3YnI0OJBcueC/5N3Kit4TnSjQYQXivgSes/o/0pYKcg
         Em1qYOxnXYab/m61AW9n6llrIbAqJSezAlDRtOKMYc26r/SoTYeaXIb/k6pIlDoNPv
         2GQakA5MxxLzg==
Date:   Tue, 15 Jun 2021 08:26:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: add iclog state trace events
Message-ID: <20210615152645.GB158209@locust>
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

Any chance you want to embed XLOG_STATE_* decoding instead of dumping
the raw value here?

Otherwise, looks fine to me,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


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
