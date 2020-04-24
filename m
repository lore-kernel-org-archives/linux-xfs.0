Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC4CC54FCB
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5EAD2075A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T0BTf9M/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgDXOCk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 10:02:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24143 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728411AbgDXOCj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 10:02:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587736956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/s208LYkKmOnd8D+c6d5v4sH13LrbFF6NVYVayesfZo=;
        b=T0BTf9M/n7gv/Mib1apx/0Q1TAJRIkNJre6mJrkfYImGyTAp8kBNgAAKfpvEekNitSF+NI
        WybKaABo9b+fAvAaKrsHtImXHJ2ltm2/KTiqUVhqryeACzDx46wEqAITh8f4LL8iE4qtc9
        I1e7mrrEkilNTQr7NXFDEO95GX/Vq1g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-wiUWECZJM7uKiS-DYHcrZQ-1; Fri, 24 Apr 2020 10:02:34 -0400
X-MC-Unique: wiUWECZJM7uKiS-DYHcrZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDA57835BC6;
        Fri, 24 Apr 2020 14:02:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 35F6860C05;
        Fri, 24 Apr 2020 14:02:24 +0000 (UTC)
Date:   Fri, 24 Apr 2020 10:02:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: proper replay of deferred ops queued during log
 recovery
Message-ID: <20200424140222.GD53690@bfoster>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
 <158752129392.2142108.12700892024217396471.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752129392.2142108.12700892024217396471.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 07:08:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we replay unfinished intent items that have been recovered from the
> log, it's possible that the replay will cause the creation of more
> deferred work items.  As outlined in commit 509955823cc9c ("xfs: log
> recovery should replay deferred ops in order"), later work items have an
> implicit ordering dependency on earlier work items.  Therefore, recovery
> must replay the items (both recovered and created) in the same order
> that they would have been during normal operation.
> 
> For log recovery, we enforce this ordering by using an empty transaction
> to collect deferred ops that get created in the process of recovering a
> log intent item to prevent them from being committed before the rest of
> the recovered intent items.  After we finish committing all the
> recovered log items, we allocate a transaction with an enormous block
> reservation, splice our huge list of created deferred ops into that
> transaction, and commit it, thereby finishing all those ops.
> 
> This is /really/ hokey -- it's the one place in XFS where we allow
> nested transactions; the splicing of the defer ops list is is inelegant
> and has to be done twice per recovery function; and the broken way we
> handle inode pointers and block reservations cause subtle use-after-free
> and allocator problems that will be fixed by this patch and the two
> patches after it.
> 
> Therefore, replace the hokey empty transaction with a structure designed
> to capture each chain of deferred ops that are created as part of
> recovering a single unfinished log intent.  Finally, refactor the loop
> that replays those chains to do so using one transaction per chain.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Just high level thoughts on a first look...

>  fs/xfs/libxfs/xfs_defer.c       |  100 ++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_defer.h       |   25 ++++++++
>  fs/xfs/libxfs/xfs_log_recover.h |    6 ++
>  fs/xfs/xfs_bmap_item.c          |   19 ++----
>  fs/xfs/xfs_extfree_item.c       |    4 +
>  fs/xfs/xfs_log_recover.c        |  122 +++++++++++++++++++++++++--------------
>  fs/xfs/xfs_refcount_item.c      |   20 ++----
>  fs/xfs/xfs_rmap_item.c          |   11 ++--
>  8 files changed, 228 insertions(+), 79 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 22557527cfdb..33e0f246e181 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -552,3 +552,103 @@ xfs_defer_move(
>  
>  	xfs_defer_reset(stp);
>  }
> +
> +/*
> + * Freeze a chain of deferred ops that are attached to a transaction.  The
> + * entire deferred ops state is transferred to the freezer, and each dfops
> + * item will be prepared for freezing.
> + */
> +int
> +xfs_defer_freeze(
> +	struct xfs_trans		*tp,
> +	struct xfs_defer_freezer	**dffp)
> +{
> +	struct xfs_defer_freezer	*dff;
> +	struct xfs_defer_pending	*dfp;
> +	int				error;
> +
> +	*dffp = NULL;
> +	if (list_empty(&tp->t_dfops))
> +		return 0;
> +
> +	dff = kmem_zalloc(sizeof(*dff), KM_NOFS);
> +	if (!dff)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&dff->dff_list);
> +	INIT_LIST_HEAD(&dff->dff_dfops);
> +
> +	/* Freeze all of the dfops items attached to the transaction. */
> +	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
> +		const struct xfs_defer_op_type *ops;
> +		struct list_head	*li;
> +
> +		ops = defer_op_types[dfp->dfp_type];
> +		if (!ops->freeze_item)
> +			continue;
> +
> +		list_for_each(li, &dfp->dfp_work) {
> +			error = ops->freeze_item(dff, li);
> +			if (error)
> +				break;
> +		}
> +		if (error)
> +			break;
> +	}
> +	if (error) {
> +		kmem_free(dff);
> +		return error;
> +	}
> +
> +	/* Move all the dfops items to the freezer. */
> +	list_splice_init(&tp->t_dfops, &dff->dff_dfops);
> +	dff->dff_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
> +	xfs_defer_reset(tp);
> +
> +	*dffp = dff;
> +	return 0;
> +}
> +
> +/* Thaw a chain of deferred ops that are attached to a transaction. */
> +int
> +xfs_defer_thaw(
> +	struct xfs_defer_freezer	*dff,
> +	struct xfs_trans		*tp)
> +{

A little confused by the freeze/thaw naming because I associate that
with filesystem freeze. I don't have a better suggestion atm though so
I'll go with it for now..

Also I find switching the parameters around between freeze/thaw to be
annoying, but that's just me. ;P

> +	struct xfs_defer_pending	*dfp;
> +	int				error;
> +
> +	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> +
> +	/* Thaw each of the items. */
> +	list_for_each_entry(dfp, &dff->dff_dfops, dfp_list) {
> +		const struct xfs_defer_op_type *ops;
> +		struct list_head	*li;
> +
> +		ops = defer_op_types[dfp->dfp_type];
> +		if (!ops->thaw_item)
> +			continue;
> +
> +		list_for_each(li, &dfp->dfp_work) {
> +			error = ops->thaw_item(dff, li);
> +			if (error)
> +				return error;
> +		}

Hmm.. so the purpose of the freeze_item() and thaw_item() callbacks is
not clear to me from this patch because they don't appear to be used
yet. Is this patch still intended to be functional before these
callbacks are implemented? If so, it might make sense to leave these
parts out and emphasize that this patch is laying foundation for this
new aggregation approach (trans per dfops chain) and otherwise plumbing
in this new freezer container thing. Then a subsequent patch can
introduce the freeze/thaw bits and emphasize what problem that actually
fixes..

> +	}
> +
> +	/* Add the dfops items to the transaction. */
> +	list_splice_init(&dff->dff_dfops, &tp->t_dfops);
> +	tp->t_flags |= dff->dff_tpflags;
> +
> +	return 0;
> +}
> +
> +/* Release a deferred op freezer and all resources associated with it. */
> +void
> +xfs_defer_freeezer_finish(
> +	struct xfs_mount		*mp,
> +	struct xfs_defer_freezer	*dff)
> +{
> +	xfs_defer_cancel_list(mp, &dff->dff_dfops);
> +	kmem_free(dff);
> +}
...
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 53160172c36b..5c22a902d8ca 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
...
> @@ -499,12 +499,7 @@ xfs_bui_recover(
>  			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
>  	if (error)
>  		return error;
> -	/*
> -	 * Recovery stashes all deferred ops during intent processing and
> -	 * finishes them on completion. Transfer current dfops state to this
> -	 * transaction and transfer the result back before we return.
> -	 */
> -	xfs_defer_move(tp, parent_tp);
> +

Is there any particular reason current code moves the list back and
forth like this, or is that just an implementation detail that allows us
to continue to aggregate dfops in order with our little xfs_defer_move()
helper?

Brian

>  	budp = xfs_trans_get_bud(tp, buip);
>  
>  	/* Grab the inode. */
> @@ -549,15 +544,13 @@ xfs_bui_recover(
>  	}
>  
>  	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
> -	xfs_defer_move(parent_tp, tp);
> -	error = xfs_trans_commit(tp);
> +	error = xlog_recover_trans_commit(tp, dffp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	xfs_irele(ip);
>  
>  	return error;
>  
>  err_inode:
> -	xfs_defer_move(parent_tp, tp);
>  	xfs_trans_cancel(tp);
>  	if (ip) {
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -678,7 +671,7 @@ xlog_recover_bud(
>  STATIC int
>  xlog_recover_process_bui(
>  	struct xlog			*log,
> -	struct xfs_trans		*parent_tp,
> +	struct xfs_defer_freezer	**dffp,
>  	struct xfs_log_item		*lip)
>  {
>  	struct xfs_ail			*ailp = log->l_ailp;
> @@ -692,7 +685,7 @@ xlog_recover_process_bui(
>  		return 0;
>  
>  	spin_unlock(&ailp->ail_lock);
> -	error = xfs_bui_recover(parent_tp, buip);
> +	error = xfs_bui_recover(log->l_mp, dffp, buip);
>  	spin_lock(&ailp->ail_lock);
>  
>  	return error;
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index a15ede29244a..5675062ad436 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -739,7 +739,7 @@ xlog_recover_efd(
>  STATIC int
>  xlog_recover_process_efi(
>  	struct xlog			*log,
> -	struct xfs_trans		*tp,
> +	struct xfs_defer_freezer	**dffp,
>  	struct xfs_log_item		*lip)
>  {
>  	struct xfs_ail			*ailp = log->l_ailp;
> @@ -753,7 +753,7 @@ xlog_recover_process_efi(
>  		return 0;
>  
>  	spin_unlock(&ailp->ail_lock);
> -	error = xfs_efi_recover(tp->t_mountp, efip);
> +	error = xfs_efi_recover(log->l_mp, efip);
>  	spin_lock(&ailp->ail_lock);
>  
>  	return error;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 5a20a95c5dad..e9b3e901d009 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1814,6 +1814,26 @@ xlog_recover_insert_ail(
>  	xfs_trans_ail_update(log->l_ailp, lip, lsn);
>  }
>  
> +/*
> + * Freeze any deferred ops and commit the transaction.  This is the last step
> + * needed to finish a log intent item that we recovered from the log.
> + */
> +int
> +xlog_recover_trans_commit(
> +	struct xfs_trans		*tp,
> +	struct xfs_defer_freezer	**dffp)
> +{
> +	int				error;
> +
> +	error = xfs_defer_freeze(tp, dffp);
> +	if (error) {
> +		xfs_trans_cancel(tp);
> +		return error;
> +	}
> +
> +	return xfs_trans_commit(tp);
> +}
> +
>  static inline const struct xlog_recover_intent_type *
>  xlog_intent_for_type(
>  	unsigned short			type)
> @@ -2652,35 +2672,59 @@ xlog_recover_process_data(
>  /* Take all the collected deferred ops and finish them in order. */
>  static int
>  xlog_finish_defer_ops(
> -	struct xfs_trans	*parent_tp)
> +	struct xfs_mount	*mp,
> +	struct list_head	*dfops_freezers)
>  {
> -	struct xfs_mount	*mp = parent_tp->t_mountp;
> +	struct xfs_defer_freezer *dff, *next;
>  	struct xfs_trans	*tp;
>  	int64_t			freeblks;
>  	uint			resblks;
> -	int			error;
> +	int			error = 0;
>  
> -	/*
> -	 * We're finishing the defer_ops that accumulated as a result of
> -	 * recovering unfinished intent items during log recovery.  We
> -	 * reserve an itruncate transaction because it is the largest
> -	 * permanent transaction type.  Since we're the only user of the fs
> -	 * right now, take 93% (15/16) of the available free blocks.  Use
> -	 * weird math to avoid a 64-bit division.
> -	 */
> -	freeblks = percpu_counter_sum(&mp->m_fdblocks);
> -	if (freeblks <= 0)
> -		return -ENOSPC;
> -	resblks = min_t(int64_t, UINT_MAX, freeblks);
> -	resblks = (resblks * 15) >> 4;
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
> -			0, XFS_TRANS_RESERVE, &tp);
> -	if (error)
> -		return error;
> -	/* transfer all collected dfops to this transaction */
> -	xfs_defer_move(tp, parent_tp);
> +	list_for_each_entry_safe(dff, next, dfops_freezers, dff_list) {
> +		/*
> +		 * We're finishing the defer_ops that accumulated as a result
> +		 * of recovering unfinished intent items during log recovery.
> +		 * We reserve an itruncate transaction because it is the
> +		 * largest permanent transaction type.  Since we're the only
> +		 * user of the fs right now, take 93% (15/16) of the available
> +		 * free blocks.  Use weird math to avoid a 64-bit division.
> +		 */
> +		freeblks = percpu_counter_sum(&mp->m_fdblocks);
> +		if (freeblks <= 0) {
> +			error = -ENOSPC;
> +			break;
> +		}
>  
> -	return xfs_trans_commit(tp);
> +		resblks = min_t(int64_t, UINT_MAX, freeblks);
> +		resblks = (resblks * 15) >> 4;
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
> +				0, XFS_TRANS_RESERVE, &tp);
> +		if (error)
> +			break;
> +
> +		/* transfer all collected dfops to this transaction */
> +		list_del_init(&dff->dff_list);
> +		error = xfs_defer_thaw(dff, tp);
> +		if (error) {
> +			xfs_trans_cancel(tp);
> +			xfs_defer_freeezer_finish(mp, dff);
> +			break;
> +		}
> +
> +		error = xfs_trans_commit(tp);
> +		xfs_defer_freeezer_finish(mp, dff);
> +		if (error)
> +			break;
> +	}
> +
> +	/* Kill any remaining freezers. */
> +	list_for_each_entry_safe(dff, next, dfops_freezers, dff_list) {
> +		list_del_init(&dff->dff_list);
> +		xfs_defer_freeezer_finish(mp, dff);
> +	}
> +
> +	return error;
>  }
>  
>  /*
> @@ -2703,8 +2747,9 @@ STATIC int
>  xlog_recover_process_intents(
>  	struct xlog		*log)
>  {
> -	struct xfs_trans	*parent_tp;
> +	LIST_HEAD(dfops_freezers);
>  	struct xfs_ail_cursor	cur;
> +	struct xfs_defer_freezer *freezer = NULL;
>  	struct xfs_log_item	*lip;
>  	struct xfs_ail		*ailp;
>  	int			error;
> @@ -2712,19 +2757,6 @@ xlog_recover_process_intents(
>  	xfs_lsn_t		last_lsn;
>  #endif
>  
> -	/*
> -	 * The intent recovery handlers commit transactions to complete recovery
> -	 * for individual intents, but any new deferred operations that are
> -	 * queued during that process are held off until the very end. The
> -	 * purpose of this transaction is to serve as a container for deferred
> -	 * operations. Each intent recovery handler must transfer dfops here
> -	 * before its local transaction commits, and we'll finish the entire
> -	 * list below.
> -	 */
> -	error = xfs_trans_alloc_empty(log->l_mp, &parent_tp);
> -	if (error)
> -		return error;
> -
>  	ailp = log->l_ailp;
>  	spin_lock(&ailp->ail_lock);
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> @@ -2756,23 +2788,27 @@ xlog_recover_process_intents(
>  
>  		/*
>  		 * NOTE: If your intent processing routine can create more
> -		 * deferred ops, you /must/ attach them to the transaction in
> +		 * deferred ops, you /must/ attach them to the freezer in
>  		 * this routine or else those subsequent intents will get
>  		 * replayed in the wrong order!
>  		 */
> -		error = type->process_intent(log, parent_tp, lip);
> +		error = type->process_intent(log, &freezer, lip);
>  		if (error)
>  			goto out;
> +		if (freezer) {
> +			list_add_tail(&freezer->dff_list, &dfops_freezers);
> +			freezer = NULL;
> +		}
> +
>  		lip = xfs_trans_ail_cursor_next(ailp, &cur);
>  	}
>  out:
>  	xfs_trans_ail_cursor_done(&cur);
>  	spin_unlock(&ailp->ail_lock);
> -	if (!error)
> -		error = xlog_finish_defer_ops(parent_tp);
> -	xfs_trans_cancel(parent_tp);
> +	if (error)
> +		return error;
>  
> -	return error;
> +	return xlog_finish_defer_ops(log->l_mp, &dfops_freezers);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 01a393727a1e..18b1fbc276fc 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -447,7 +447,8 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
>   */
>  STATIC int
>  xfs_cui_recover(
> -	struct xfs_trans		*parent_tp,
> +	struct xfs_mount		*mp,
> +	struct xfs_defer_freezer	**dffp,
>  	struct xfs_cui_log_item		*cuip)
>  {
>  	int				i;
> @@ -464,7 +465,6 @@ xfs_cui_recover(
>  	xfs_extlen_t			new_len;
>  	struct xfs_bmbt_irec		irec;
>  	bool				requeue_only = false;
> -	struct xfs_mount		*mp = parent_tp->t_mountp;
>  
>  	ASSERT(!test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags));
>  
> @@ -519,12 +519,7 @@ xfs_cui_recover(
>  			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		return error;
> -	/*
> -	 * Recovery stashes all deferred ops during intent processing and
> -	 * finishes them on completion. Transfer current dfops state to this
> -	 * transaction and transfer the result back before we return.
> -	 */
> -	xfs_defer_move(tp, parent_tp);
> +
>  	cudp = xfs_trans_get_cud(tp, cuip);
>  
>  	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
> @@ -582,13 +577,10 @@ xfs_cui_recover(
>  
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
>  	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
> -	xfs_defer_move(parent_tp, tp);
> -	error = xfs_trans_commit(tp);
> -	return error;
> +	return xlog_recover_trans_commit(tp, dffp);
>  
>  abort_error:
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> -	xfs_defer_move(parent_tp, tp);
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> @@ -701,7 +693,7 @@ xlog_recover_cud(
>  STATIC int
>  xlog_recover_process_cui(
>  	struct xlog			*log,
> -	struct xfs_trans		*parent_tp,
> +	struct xfs_defer_freezer	**dffp,
>  	struct xfs_log_item		*lip)
>  {
>  	struct xfs_ail			*ailp = log->l_ailp;
> @@ -715,7 +707,7 @@ xlog_recover_process_cui(
>  		return 0;
>  
>  	spin_unlock(&ailp->ail_lock);
> -	error = xfs_cui_recover(parent_tp, cuip);
> +	error = xfs_cui_recover(log->l_mp, dffp, cuip);
>  	spin_lock(&ailp->ail_lock);
>  
>  	return error;
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 69a2d23eedda..7291fac7c6d1 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -491,7 +491,8 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
>   */
>  STATIC int
>  xfs_rui_recover(
> -	struct xfs_trans		*parent_tp,
> +	struct xfs_mount		*mp,
> +	struct xfs_defer_freezer	**dffp,
>  	struct xfs_rui_log_item		*ruip)
>  {
>  	int				i;
> @@ -505,7 +506,6 @@ xfs_rui_recover(
>  	xfs_exntst_t			state;
>  	struct xfs_trans		*tp;
>  	struct xfs_btree_cur		*rcur = NULL;
> -	struct xfs_mount		*mp = parent_tp->t_mountp;
>  
>  	ASSERT(!test_bit(XFS_RUI_RECOVERED, &ruip->rui_flags));
>  
> @@ -601,8 +601,7 @@ xfs_rui_recover(
>  
>  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
>  	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
> -	error = xfs_trans_commit(tp);
> -	return error;
> +	return xlog_recover_trans_commit(tp, dffp);
>  
>  abort_error:
>  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> @@ -691,7 +690,7 @@ xlog_recover_rud(
>  STATIC int
>  xlog_recover_process_rui(
>  	struct xlog			*log,
> -	struct xfs_trans		*parent_tp,
> +	struct xfs_defer_freezer	**dffp,
>  	struct xfs_log_item		*lip)
>  {
>  	struct xfs_ail			*ailp = log->l_ailp;
> @@ -705,7 +704,7 @@ xlog_recover_process_rui(
>  		return 0;
>  
>  	spin_unlock(&ailp->ail_lock);
> -	error = xfs_rui_recover(parent_tp, ruip);
> +	error = xfs_rui_recover(log->l_mp, dffp, ruip);
>  	spin_lock(&ailp->ail_lock);
>  
>  	return error;
> 

