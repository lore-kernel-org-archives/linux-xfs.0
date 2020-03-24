Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2379FC43331
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D835320735
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 20:41:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E0LG2AP5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgCXUlU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 16:41:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44806 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727613AbgCXUlU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 16:41:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKdJLV056021;
        Tue, 24 Mar 2020 20:41:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0c+YdJnJiroP9vJemQjL22pZ+xWQbox7ckdLaBbSBSw=;
 b=E0LG2AP5qUa7uItAvfQcP0zBzRVWa7Hjyc08ZaM5k8CLtWpsj7lXLfZi9u9z1YsOi5Ci
 z6/CCTwqsOU8TPF5rcCt0ASujqUNUr5osB7kCe14Q83vMWa1KIus2mtFYDgLDS0hXjyo
 thGtrYOXSwvMAu5zU9lOg3zTg7E6rOaXWAGIJcg53d/swT/nRAl/r8tlduvqtb158C/6
 2LEVjCvAuaSODgvmWeiR5rcBdWBEfvRU+/zk45Dj3AHv+L7muy/Qxm/0NxuM/BVO1CNr
 xbO7AK0o0sPYvNCoyURPzqeEdj4SXcG4TewCJoJwDjy+GOUcqPEsw+TytKl7UNXokc78 4w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ywabr6km5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:41:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02OKcNQu037703;
        Tue, 24 Mar 2020 20:41:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yxw4q0t3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 20:41:12 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02OKfBeY022762;
        Tue, 24 Mar 2020 20:41:11 GMT
Received: from localhost (/10.159.142.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 13:41:11 -0700
Date:   Tue, 24 Mar 2020 13:41:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 5/8] xfs: split xlog_ticket_done
Message-ID: <20200324204110.GL29339@magnolia>
References: <20200324174459.770999-1-hch@lst.de>
 <20200324174459.770999-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324174459.770999-6-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240103
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240103
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 06:44:56PM +0100, Christoph Hellwig wrote:
> Split the regrant case out of xlog_ticket_done and into a new
> xlog_ticket_regrant helper.  Merge both functions with the low-level
> functions implementing the actual functionality and adjust the
> tracepoints.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

More cohesive functions FTW,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c      | 84 ++++++++++++++-----------------------------
>  fs/xfs/xfs_log_cil.c  |  9 +++--
>  fs/xfs/xfs_log_priv.h |  4 +--
>  fs/xfs/xfs_trace.h    | 14 ++++----
>  fs/xfs/xfs_trans.c    |  9 +++--
>  5 files changed, 47 insertions(+), 73 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b30bb6452494..9a26ee8db238 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -66,14 +66,6 @@ xlog_grant_push_ail(
>  	struct xlog		*log,
>  	int			need_bytes);
>  STATIC void
> -xlog_regrant_reserve_log_space(
> -	struct xlog		*log,
> -	struct xlog_ticket	*ticket);
> -STATIC void
> -xlog_ungrant_log_space(
> -	struct xlog		*log,
> -	struct xlog_ticket	*ticket);
> -STATIC void
>  xlog_sync(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog);
> @@ -502,27 +494,6 @@ xlog_write_done(
>  	return xlog_commit_record(log, ticket, iclog, lsn);
>  }
>  
> -/*
> - * Release or regrant the ticket reservation now the transaction is done with
> - * it depending on caller context. Rolling transactions need the ticket
> - * regranted, otherwise we release it completely.
> - */
> -void
> -xlog_ticket_done(
> -	struct xlog		*log,
> -	struct xlog_ticket	*ticket,
> -	bool			regrant)
> -{
> -	if (!regrant || XLOG_FORCED_SHUTDOWN(log)) {
> -		trace_xfs_log_done_nonperm(log, ticket);
> -		xlog_ungrant_log_space(log, ticket);
> -	} else {
> -		trace_xfs_log_done_perm(log, ticket);
> -		xlog_regrant_reserve_log_space(log, ticket);
> -	}
> -	xfs_log_ticket_put(ticket);
> -}
> -
>  static bool
>  __xlog_state_release_iclog(
>  	struct xlog		*log,
> @@ -921,8 +892,7 @@ xfs_log_write_unmount_record(
>  
>  	if (tic) {
>  		trace_xfs_log_umount_write(log, tic);
> -		xlog_ungrant_log_space(log, tic);
> -		xfs_log_ticket_put(tic);
> +		xlog_ticket_done(log, tic);
>  	}
>  }
>  
> @@ -2987,19 +2957,18 @@ xlog_state_get_iclog_space(
>  	return 0;
>  }	/* xlog_state_get_iclog_space */
>  
> -/* The first cnt-1 times through here we don't need to
> - * move the grant write head because the permanent
> - * reservation has reserved cnt times the unit amount.
> - * Release part of current permanent unit reservation and
> - * reset current reservation to be one units worth.  Also
> - * move grant reservation head forward.
> +/*
> + * The first cnt-1 times through here we don't need to move the grant write head
> + * because the permanent reservation has reserved cnt times the unit amount.
> + * Release part of current permanent unit reservation and reset current
> + * reservation to be one units worth.  Also move grant reservation head forward.
>   */
> -STATIC void
> -xlog_regrant_reserve_log_space(
> +void
> +xlog_ticket_regrant(
>  	struct xlog		*log,
>  	struct xlog_ticket	*ticket)
>  {
> -	trace_xfs_log_regrant_reserve_enter(log, ticket);
> +	trace_xfs_log_ticket_regrant(log, ticket);
>  
>  	if (ticket->t_cnt > 0)
>  		ticket->t_cnt--;
> @@ -3011,21 +2980,20 @@ xlog_regrant_reserve_log_space(
>  	ticket->t_curr_res = ticket->t_unit_res;
>  	xlog_tic_reset_res(ticket);
>  
> -	trace_xfs_log_regrant_reserve_sub(log, ticket);
> +	trace_xfs_log_ticket_regrant_sub(log, ticket);
>  
>  	/* just return if we still have some of the pre-reserved space */
> -	if (ticket->t_cnt > 0)
> -		return;
> +	if (!ticket->t_cnt) {
> +		xlog_grant_add_space(log, &log->l_reserve_head.grant,
> +				     ticket->t_unit_res);
> +		trace_xfs_log_ticket_regrant_exit(log, ticket);
>  
> -	xlog_grant_add_space(log, &log->l_reserve_head.grant,
> -					ticket->t_unit_res);
> -
> -	trace_xfs_log_regrant_reserve_exit(log, ticket);
> -
> -	ticket->t_curr_res = ticket->t_unit_res;
> -	xlog_tic_reset_res(ticket);
> -}	/* xlog_regrant_reserve_log_space */
> +		ticket->t_curr_res = ticket->t_unit_res;
> +		xlog_tic_reset_res(ticket);
> +	}
>  
> +	xfs_log_ticket_put(ticket);
> +}
>  
>  /*
>   * Give back the space left from a reservation.
> @@ -3041,18 +3009,19 @@ xlog_regrant_reserve_log_space(
>   * space, the count will stay at zero and the only space remaining will be
>   * in the current reservation field.
>   */
> -STATIC void
> -xlog_ungrant_log_space(
> +void
> +xlog_ticket_done(
>  	struct xlog		*log,
>  	struct xlog_ticket	*ticket)
>  {
> -	int	bytes;
> +	int			bytes;
> +
> +	trace_xfs_log_ticket_done(log, ticket);
>  
>  	if (ticket->t_cnt > 0)
>  		ticket->t_cnt--;
>  
> -	trace_xfs_log_ungrant_enter(log, ticket);
> -	trace_xfs_log_ungrant_sub(log, ticket);
> +	trace_xfs_log_ticket_done_sub(log, ticket);
>  
>  	/*
>  	 * If this is a permanent reservation ticket, we may be able to free
> @@ -3067,9 +3036,10 @@ xlog_ungrant_log_space(
>  	xlog_grant_sub_space(log, &log->l_reserve_head.grant, bytes);
>  	xlog_grant_sub_space(log, &log->l_write_head.grant, bytes);
>  
> -	trace_xfs_log_ungrant_exit(log, ticket);
> +	trace_xfs_log_ticket_done_exit(log, ticket);
>  
>  	xfs_log_space_wake(log->l_mp);
> +	xfs_log_ticket_put(ticket);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 880de1aa4288..1189c8cfa525 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -843,7 +843,7 @@ xlog_cil_push_work(
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> -	xlog_ticket_done(log, tic, false);
> +	xlog_ticket_done(log, tic);
>  
>  	spin_lock(&commit_iclog->ic_callback_lock);
>  	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
> @@ -876,7 +876,7 @@ xlog_cil_push_work(
>  	return;
>  
>  out_abort_free_ticket:
> -	xlog_ticket_done(log, tic, false);
> +	xlog_ticket_done(log, tic);
>  out_abort:
>  	ASSERT(XLOG_FORCED_SHUTDOWN(log));
>  	xlog_cil_committed(ctx);
> @@ -1008,7 +1008,10 @@ xfs_log_commit_cil(
>  	if (commit_lsn)
>  		*commit_lsn = xc_commit_lsn;
>  
> -	xlog_ticket_done(log, tp->t_ticket, regrant);
> +	if (regrant && !XLOG_FORCED_SHUTDOWN(log))
> +		xlog_ticket_regrant(log, tp->t_ticket);
> +	else
> +		xlog_ticket_done(log, tp->t_ticket);
>  	tp->t_ticket = NULL;
>  	xfs_trans_unreserve_and_mod_sb(tp);
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index cfe5295ef4e3..cfcf3f02e30a 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -443,8 +443,8 @@ int xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
>  			struct xlog_in_core **commit_iclog, uint flags);
>  int xlog_write_done(struct xlog *log, struct xlog_ticket *ticket,
>  			struct xlog_in_core **iclog, xfs_lsn_t *lsn);
> -void xlog_ticket_done(struct xlog *log, struct xlog_ticket *ticket,
> -			bool regrant);
> +void xlog_ticket_done(struct xlog *log, struct xlog_ticket *ticket);
> +void xlog_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
>  
>  /*
>   * When we crack an atomic LSN, we sample it first so that the value will not
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index efc7751550d9..fbfdd9cf160d 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1001,8 +1001,6 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
>  DEFINE_EVENT(xfs_loggrant_class, name, \
>  	TP_PROTO(struct xlog *log, struct xlog_ticket *tic), \
>  	TP_ARGS(log, tic))
> -DEFINE_LOGGRANT_EVENT(xfs_log_done_nonperm);
> -DEFINE_LOGGRANT_EVENT(xfs_log_done_perm);
>  DEFINE_LOGGRANT_EVENT(xfs_log_umount_write);
>  DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep);
>  DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake);
> @@ -1011,12 +1009,12 @@ DEFINE_LOGGRANT_EVENT(xfs_log_reserve);
>  DEFINE_LOGGRANT_EVENT(xfs_log_reserve_exit);
>  DEFINE_LOGGRANT_EVENT(xfs_log_regrant);
>  DEFINE_LOGGRANT_EVENT(xfs_log_regrant_exit);
> -DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
> -DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
> -DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
> -DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
> -DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
> -DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
> +DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant);
> +DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant_exit);
> +DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant_sub);
> +DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done);
> +DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done_sub);
> +DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done_exit);
>  
>  DECLARE_EVENT_CLASS(xfs_log_item_class,
>  	TP_PROTO(struct xfs_log_item *lip),
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 123ecc8435f6..d7c66c3331ec 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -231,7 +231,7 @@ xfs_trans_reserve(
>  	 */
>  undo_log:
>  	if (resp->tr_logres > 0) {
> -		xlog_ticket_done(mp->m_log, tp->t_ticket, false);
> +		xlog_ticket_done(mp->m_log, tp->t_ticket);
>  		tp->t_ticket = NULL;
>  		tp->t_log_res = 0;
>  		tp->t_flags &= ~XFS_TRANS_PERM_LOG_RES;
> @@ -1001,7 +1001,10 @@ __xfs_trans_commit(
>  	 */
>  	xfs_trans_unreserve_and_mod_dquots(tp);
>  	if (tp->t_ticket) {
> -		xlog_ticket_done(mp->m_log, tp->t_ticket, regrant);
> +		if (regrant && !XLOG_FORCED_SHUTDOWN(mp->m_log))
> +			xlog_ticket_regrant(mp->m_log, tp->t_ticket);
> +		else
> +			xlog_ticket_done(mp->m_log, tp->t_ticket);
>  		tp->t_ticket = NULL;
>  	}
>  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> @@ -1060,7 +1063,7 @@ xfs_trans_cancel(
>  	xfs_trans_unreserve_and_mod_dquots(tp);
>  
>  	if (tp->t_ticket) {
> -		xlog_ticket_done(mp->m_log, tp->t_ticket, false);
> +		xlog_ticket_done(mp->m_log, tp->t_ticket);
>  		tp->t_ticket = NULL;
>  	}
>  
> -- 
> 2.25.1
> 
