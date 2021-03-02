Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C00BDC43381
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F17C61494
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245333AbhCCDPT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:15:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37041 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349608AbhCBS1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 13:27:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614709502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B1VrpTdqTfTzT6aALMZ6lH9DcDODoD5rH6mGWm6rnu0=;
        b=blnkAZGZoXIaaDtF2mCDn73DuJR+tGuFlqWAPYqOwT0YLh/YQGWasPDsCLZovtr5Hd3Hrj
        D5T3mF2WXHRnmFVqS4JMDN5vfaI5lEfihi2vQHHuSch5jaS+0RPnp5Qv9JB5UuKEYz/o1Y
        KWrw3c6PCBQEsj0hYm9rJrDveZCCLzs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-LQqMW8o4OUK6eL1FE9Vr3A-1; Tue, 02 Mar 2021 13:12:45 -0500
X-MC-Unique: LQqMW8o4OUK6eL1FE9Vr3A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F9B219611D0;
        Tue,  2 Mar 2021 18:12:38 +0000 (UTC)
Received: from bfoster (ovpn-119-215.rdu2.redhat.com [10.10.119.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AC09E169;
        Tue,  2 Mar 2021 18:12:38 +0000 (UTC)
Date:   Tue, 2 Mar 2021 13:12:36 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: xfs_log_force_lsn isn't passed a LSN
Message-ID: <YD6AFFjVkfF3Y/oo@bfoster>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223053212.3287398-2-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 04:32:10PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In doing an investigation into AIL push stalls, I was looking at the
> log force code to see if an async CIL push could be done instead.
> This lead me to xfs_log_force_lsn() and looking at how it works.
> 
> xfs_log_force_lsn() is only called from inode synchronisation
> contexts such as fsync(), and it takes the ip->i_itemp->ili_last_lsn
> value as the LSN to sync the log to. This gets passed to
> xlog_cil_force_lsn() via xfs_log_force_lsn() to flush the CIL to the
> journal, and then used by xfs_log_force_lsn() to flush the iclogs to
> the journal.
> 

As you point out just below, this ->ili_last_lsn value is not used by
xfs_log_force_lsn(). It's passed to the CIL force and that potentially
returns a LSN for the log force call.

> The problem with is that ip->i_itemp->ili_last_lsn does not store a
> log sequence number. What it stores is passed to it from the
> ->iop_committing method, which is called by xfs_log_commit_cil().
> The value this passes to the iop_committing method is the CIL
> context sequence number that the item was committed to.
> 

Ok, but what is the "problem?" It sounds like this patch is cleaning
things up vs. fixing a problem...

> As it turns out, xlog_cil_force_lsn() converts the sequence to an
> actual commit LSN for the related context and returns that to
> xfs_log_force_lsn(). xfs_log_force_lsn() overwrites it's "lsn"
> variable that contained a sequence with an actual LSN and then uses
> that to sync the iclogs.
> 
> This caused me some confusion for a while, even though I originally
> wrote all this code a decade ago. ->iop_committing is only used by
> a couple of log item types, and only inode items use the sequence
> number it is passed.
> 
> Let's clean up the API, CIL structures and inode log item to call it
> a sequence number, and make it clear that the high level code is
> using CIL sequence numbers and not on-disk LSNs for integrity
> synchronisation purposes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c   |  2 +-
>  fs/xfs/xfs_dquot_item.c |  2 +-
>  fs/xfs/xfs_file.c       | 14 +++++++-------
>  fs/xfs/xfs_inode.c      | 10 +++++-----
>  fs/xfs/xfs_inode_item.c |  4 ++--
>  fs/xfs/xfs_inode_item.h |  2 +-
>  fs/xfs/xfs_log.c        | 27 ++++++++++++++-------------
>  fs/xfs/xfs_log.h        |  4 +---
>  fs/xfs/xfs_log_cil.c    | 22 +++++++++-------------
>  fs/xfs/xfs_log_priv.h   | 15 +++++++--------
>  fs/xfs/xfs_trans.c      |  6 +++---
>  fs/xfs/xfs_trans.h      |  4 ++--
>  12 files changed, 53 insertions(+), 59 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 08d68a6161ae..84cd9b6c6d1f 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -3415,25 +3412,29 @@ __xfs_log_force_lsn(
>   * to disk, that thread will wake up all threads waiting on the queue.
>   */
>  int
> -xfs_log_force_lsn(
> +xfs_log_force_seq(
>  	struct xfs_mount	*mp,
> -	xfs_lsn_t		lsn,
> +	uint64_t		seq,
>  	uint			flags,
>  	int			*log_flushed)
>  {
> +	struct xlog		*log = mp->m_log;
> +	xfs_lsn_t		lsn;
>  	int			ret;
> -	ASSERT(lsn != 0);
> +	ASSERT(seq != 0);
>  
>  	XFS_STATS_INC(mp, xs_log_force);
> -	trace_xfs_log_force(mp, lsn, _RET_IP_);
> +	trace_xfs_log_force(mp, seq, _RET_IP_);
>  
> -	lsn = xlog_cil_force_lsn(mp->m_log, lsn);
> +	lsn = xlog_cil_force_seq(log, seq);
>  	if (lsn == NULLCOMMITLSN)
>  		return 0;
>  
> -	ret = __xfs_log_force_lsn(mp, lsn, flags, log_flushed, false);
> -	if (ret == -EAGAIN)
> -		ret = __xfs_log_force_lsn(mp, lsn, flags, log_flushed, true);
> +	ret = xlog_force_lsn(log, lsn, flags, log_flushed, false);
> +	if (ret == -EAGAIN) {
> +		XFS_STATS_INC(mp, xs_log_force_sleep);

This looks misplaced to me here. I'd just leave it where we do the sleep
and pass log->l_mp. That nit and the slightly misleading commit log
aside, the rest LGTM and seems like a nice cleanup:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		ret = xlog_force_lsn(log, lsn, flags, log_flushed, true);
> +	}
>  	return ret;
>  }
>  
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 044e02cb8921..33ae53401060 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -106,7 +106,7 @@ struct xfs_item_ops;
>  struct xfs_trans;
>  
>  int	  xfs_log_force(struct xfs_mount *mp, uint flags);
> -int	  xfs_log_force_lsn(struct xfs_mount *mp, xfs_lsn_t lsn, uint flags,
> +int	  xfs_log_force_seq(struct xfs_mount *mp, uint64_t seq, uint flags,
>  		int *log_forced);
>  int	  xfs_log_mount(struct xfs_mount	*mp,
>  			struct xfs_buftarg	*log_target,
> @@ -132,8 +132,6 @@ bool	xfs_log_writable(struct xfs_mount *mp);
>  struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
>  void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
>  
> -void	xfs_log_commit_cil(struct xfs_mount *mp, struct xfs_trans *tp,
> -				xfs_lsn_t *commit_lsn, bool regrant);
>  void	xlog_cil_process_committed(struct list_head *list);
>  bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 0a00c3c9610c..2fda8c4513b2 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -792,7 +792,7 @@ xlog_cil_push_work(
>  	 * that higher sequences will wait for us to write out a commit record
>  	 * before they do.
>  	 *
> -	 * xfs_log_force_lsn requires us to mirror the new sequence into the cil
> +	 * xfs_log_force_seq requires us to mirror the new sequence into the cil
>  	 * structure atomically with the addition of this sequence to the
>  	 * committing list. This also ensures that we can do unlocked checks
>  	 * against the current sequence in log forces without risking
> @@ -1054,16 +1054,14 @@ xlog_cil_empty(
>   * allowed again.
>   */
>  void
> -xfs_log_commit_cil(
> -	struct xfs_mount	*mp,
> +xlog_cil_commit(
> +	struct xlog		*log,
>  	struct xfs_trans	*tp,
> -	xfs_lsn_t		*commit_lsn,
> +	uint64_t		*commit_seq,
>  	bool			regrant)
>  {
> -	struct xlog		*log = mp->m_log;
>  	struct xfs_cil		*cil = log->l_cilp;
>  	struct xfs_log_item	*lip, *next;
> -	xfs_lsn_t		xc_commit_lsn;
>  
>  	/*
>  	 * Do all necessary memory allocation before we lock the CIL.
> @@ -1077,10 +1075,6 @@ xfs_log_commit_cil(
>  
>  	xlog_cil_insert_items(log, tp);
>  
> -	xc_commit_lsn = cil->xc_ctx->sequence;
> -	if (commit_lsn)
> -		*commit_lsn = xc_commit_lsn;
> -
>  	if (regrant && !XLOG_FORCED_SHUTDOWN(log))
>  		xfs_log_ticket_regrant(log, tp->t_ticket);
>  	else
> @@ -1103,8 +1097,10 @@ xfs_log_commit_cil(
>  	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
>  		xfs_trans_del_item(lip);
>  		if (lip->li_ops->iop_committing)
> -			lip->li_ops->iop_committing(lip, xc_commit_lsn);
> +			lip->li_ops->iop_committing(lip, cil->xc_ctx->sequence);
>  	}
> +	if (commit_seq)
> +		*commit_seq = cil->xc_ctx->sequence;
>  
>  	/* xlog_cil_push_background() releases cil->xc_ctx_lock */
>  	xlog_cil_push_background(log);
> @@ -1121,9 +1117,9 @@ xfs_log_commit_cil(
>   * iclog flush is necessary following this call.
>   */
>  xfs_lsn_t
> -xlog_cil_force_lsn(
> +xlog_cil_force_seq(
>  	struct xlog	*log,
> -	xfs_lsn_t	sequence)
> +	uint64_t	sequence)
>  {
>  	struct xfs_cil		*cil = log->l_cilp;
>  	struct xfs_cil_ctx	*ctx;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 24acdc54e44e..59778cd5ecdd 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -234,7 +234,7 @@ struct xfs_cil;
>  
>  struct xfs_cil_ctx {
>  	struct xfs_cil		*cil;
> -	xfs_lsn_t		sequence;	/* chkpt sequence # */
> +	uint64_t		sequence;	/* chkpt sequence # */
>  	xfs_lsn_t		start_lsn;	/* first LSN of chkpt commit */
>  	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
>  	struct xlog_ticket	*ticket;	/* chkpt ticket */
> @@ -272,10 +272,10 @@ struct xfs_cil {
>  	struct xfs_cil_ctx	*xc_ctx;
>  
>  	spinlock_t		xc_push_lock ____cacheline_aligned_in_smp;
> -	xfs_lsn_t		xc_push_seq;
> +	uint64_t		xc_push_seq;
>  	struct list_head	xc_committing;
>  	wait_queue_head_t	xc_commit_wait;
> -	xfs_lsn_t		xc_current_sequence;
> +	uint64_t		xc_current_sequence;
>  	struct work_struct	xc_push_work;
>  	wait_queue_head_t	xc_push_wait;	/* background push throttle */
>  } ____cacheline_aligned_in_smp;
> @@ -552,19 +552,18 @@ int	xlog_cil_init(struct xlog *log);
>  void	xlog_cil_init_post_recovery(struct xlog *log);
>  void	xlog_cil_destroy(struct xlog *log);
>  bool	xlog_cil_empty(struct xlog *log);
> +void	xlog_cil_commit(struct xlog *log, struct xfs_trans *tp,
> +			uint64_t *commit_seq, bool regrant);
>  
>  /*
>   * CIL force routines
>   */
> -xfs_lsn_t
> -xlog_cil_force_lsn(
> -	struct xlog *log,
> -	xfs_lsn_t sequence);
> +xfs_lsn_t xlog_cil_force_seq(struct xlog *log, uint64_t sequence);
>  
>  static inline void
>  xlog_cil_force(struct xlog *log)
>  {
> -	xlog_cil_force_lsn(log, log->l_cilp->xc_current_sequence);
> +	xlog_cil_force_seq(log, log->l_cilp->xc_current_sequence);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 44f72c09c203..697703f3be48 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -849,7 +849,7 @@ __xfs_trans_commit(
>  	bool			regrant)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	xfs_lsn_t		commit_lsn = -1;
> +	uint64_t		commit_seq = 0;
>  	int			error = 0;
>  	int			sync = tp->t_flags & XFS_TRANS_SYNC;
>  
> @@ -891,7 +891,7 @@ __xfs_trans_commit(
>  		xfs_trans_apply_sb_deltas(tp);
>  	xfs_trans_apply_dquot_deltas(tp);
>  
> -	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
> +	xlog_cil_commit(mp->m_log, tp, &commit_seq, regrant);
>  
>  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
>  	xfs_trans_free(tp);
> @@ -901,7 +901,7 @@ __xfs_trans_commit(
>  	 * log out now and wait for it.
>  	 */
>  	if (sync) {
> -		error = xfs_log_force_lsn(mp, commit_lsn, XFS_LOG_SYNC, NULL);
> +		error = xfs_log_force_seq(mp, commit_seq, XFS_LOG_SYNC, NULL);
>  		XFS_STATS_INC(mp, xs_trans_sync);
>  	} else {
>  		XFS_STATS_INC(mp, xs_trans_async);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 8b03fbfe9a1b..d223d4f4e429 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -43,7 +43,7 @@ struct xfs_log_item {
>  	struct list_head		li_cil;		/* CIL pointers */
>  	struct xfs_log_vec		*li_lv;		/* active log vector */
>  	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
> -	xfs_lsn_t			li_seq;		/* CIL commit seq */
> +	uint64_t			li_seq;		/* CIL commit seq */
>  };
>  
>  /*
> @@ -69,7 +69,7 @@ struct xfs_item_ops {
>  	void (*iop_pin)(struct xfs_log_item *);
>  	void (*iop_unpin)(struct xfs_log_item *, int remove);
>  	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
> -	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
> +	void (*iop_committing)(struct xfs_log_item *lip, uint64_t seq);
>  	void (*iop_release)(struct xfs_log_item *);
>  	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
>  	int (*iop_recover)(struct xfs_log_item *lip,
> -- 
> 2.28.0
> 

