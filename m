Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbfCOMaD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Mar 2019 08:30:03 -0400
Date: Fri, 15 Mar 2019 08:30:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: trace transaction reservation logcount overflow
Message-ID: <20190315123000.GC5182@bfoster>
References: <155259893433.30230.6566995969675098053.stgit@magnolia>
 <155259895225.30230.16620449818865521574.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155259895225.30230.16620449818865521574.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 14, 2019 at 02:29:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This is a debugging patch to keep track of cases where transaction
> reservations with permanent reservations do not reserve enough logcount
> to handle the entire workflow.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_log.c      |   11 +++++++++++
>  fs/xfs/xfs_log_priv.h |    3 +++
>  fs/xfs/xfs_trace.h    |   10 +++++++++-
>  3 files changed, 23 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c3b610b687d1..8832cc86566f 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -385,6 +385,9 @@ xfs_log_regrant(
>  
>  	if (tic->t_cnt > 0)
>  		return 0;
> +#ifdef DEBUG
> +	tic->t_spillcnt++;
> +#endif
>  
>  	trace_xfs_log_regrant(log, tic);
>  

Don't we already kind of have this contextual information with the
xfs_log_regrant* tracepoints? I guess we don't have the count
information explicitly, but it seems it can be deduced from a trace
dump.

We also already have an 'xs_try_logspace' stat in the reservation cases.
I wonder if a similar regrant stat for the exhausted reservation case
might be useful enough (and not require debug code) to determine whether
a particular workload is experiencing this problem.

Brian

> @@ -3124,6 +3127,9 @@ xlog_regrant_reserve_log_space(
>  	/* just return if we still have some of the pre-reserved space */
>  	if (ticket->t_cnt > 0)
>  		return;
> +#ifdef DEBUG
> +	ticket->t_spillcnt++;
> +#endif
>  
>  	xlog_grant_add_space(log, &log->l_reserve_head.grant,
>  					ticket->t_unit_res);
> @@ -3159,6 +3165,11 @@ xlog_ungrant_log_space(
>  	if (ticket->t_cnt > 0)
>  		ticket->t_cnt--;
>  
> +#ifdef DEBUG
> +	if (ticket->t_spillcnt > 0)
> +		trace_xfs_log_ungrant_spill(log, ticket);
> +#endif
> +
>  	trace_xfs_log_ungrant_enter(log, ticket);
>  	trace_xfs_log_ungrant_sub(log, ticket);
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b5f82cb36202..37302d2ad288 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -161,6 +161,9 @@ typedef struct xlog_ticket {
>  	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
>  	char		   t_ocnt;	 /* original count		 : 1  */
>  	char		   t_cnt;	 /* current count		 : 1  */
> +#ifdef DEBUG
> +	char		   t_spillcnt;	 /* underestimation of ocnt	 : 1  */
> +#endif
>  	char		   t_clientid;	 /* who does this belong to;	 : 1  */
>  	char		   t_flags;	 /* properties of reservation	 : 1  */
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index bd9a48fa80ba..b765b2761382 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -937,6 +937,7 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
>  		__field(dev_t, dev)
>  		__field(char, ocnt)
>  		__field(char, cnt)
> +		__field(int, spillcnt)
>  		__field(int, curr_res)
>  		__field(int, unit_res)
>  		__field(unsigned int, flags)
> @@ -954,6 +955,11 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
>  		__entry->dev = log->l_mp->m_super->s_dev;
>  		__entry->ocnt = tic->t_ocnt;
>  		__entry->cnt = tic->t_cnt;
> +#ifdef DEBUG
> +		__entry->spillcnt = tic->t_spillcnt;
> +#else
> +		__entry->spillcnt = -1;
> +#endif
>  		__entry->curr_res = tic->t_curr_res;
>  		__entry->unit_res = tic->t_unit_res;
>  		__entry->flags = tic->t_flags;
> @@ -969,7 +975,7 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
>  		__entry->curr_block = log->l_curr_block;
>  		__entry->tail_lsn = atomic64_read(&log->l_tail_lsn);
>  	),
> -	TP_printk("dev %d:%d t_ocnt %u t_cnt %u t_curr_res %u "
> +	TP_printk("dev %d:%d t_ocnt %u t_cnt %u spill %u t_curr_res %u "
>  		  "t_unit_res %u t_flags %s reserveq %s "
>  		  "writeq %s grant_reserve_cycle %d "
>  		  "grant_reserve_bytes %d grant_write_cycle %d "
> @@ -978,6 +984,7 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ocnt,
>  		  __entry->cnt,
> +		  __entry->spillcnt,
>  		  __entry->curr_res,
>  		  __entry->unit_res,
>  		  __print_flags(__entry->flags, "|", XLOG_TIC_FLAGS),
> @@ -1014,6 +1021,7 @@ DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
>  DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
>  DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
>  DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
> +DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_spill);
>  
>  DECLARE_EVENT_CLASS(xfs_log_item_class,
>  	TP_PROTO(struct xfs_log_item *lip),
> 
