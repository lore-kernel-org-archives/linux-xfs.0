Return-Path: <SRS0=mWNF=DI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7976C4727E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 17:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9687F20897
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 17:41:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q+wKXtW/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732213AbgJARli (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 13:41:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37528 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732096AbgJARli (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 13:41:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091Hd9Fe074279;
        Thu, 1 Oct 2020 17:41:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3fT5huce4as7QK8YZ6HIGRHnf1Am72GLxyNq44LBdfw=;
 b=q+wKXtW/EiSu+r+CFkJCKrkdhOZA/bOJ4avJim5goxp5c3H7HCaynJelSMQXeBT1YFiT
 9Q4WaO/DivTOCd3oVnJHdtBEWsE6pswzm1r8QeHxyj3W68G53BXQMdYtCHKq4XxaqQRO
 LS9T+u6aVFEBBJbuDZ2xFloQRTmMeaNM+cqLpAzg8z65BfzBF9Z9aFY/JV+KRcoSxXjZ
 45ZVYKudCqLWvMi4OQWTtlCEJROIgWd03xpuqTCxMH79jldBnpo5S6rcy7U0H2IrxBK3
 7oivJIZKwplO0X54CJkr7QYjfOY4Orl0hxRhEu5+eWBMOY5YPqw9SQTPZAKrUivDELym Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33sx9nfb0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 01 Oct 2020 17:41:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091HeqUq126168;
        Thu, 1 Oct 2020 17:41:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33tfdw6d3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Oct 2020 17:41:29 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 091HfS1X031315;
        Thu, 1 Oct 2020 17:41:28 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 10:41:28 -0700
Date:   Thu, 1 Oct 2020 10:41:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH 3/5] xfs: proper replay of deferred ops queued during log
 recovery
Message-ID: <20201001174126.GQ49547@magnolia>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
 <160140141157.830233.8230232141442784711.stgit@magnolia>
 <20201001173142.GE112884@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001173142.GE112884@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=5
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 01:31:42PM -0400, Brian Foster wrote:
> On Tue, Sep 29, 2020 at 10:43:31AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we replay unfinished intent items that have been recovered from the
> > log, it's possible that the replay will cause the creation of more
> > deferred work items.  As outlined in commit 509955823cc9c ("xfs: log
> > recovery should replay deferred ops in order"), later work items have an
> > implicit ordering dependency on earlier work items.  Therefore, recovery
> > must replay the items (both recovered and created) in the same order
> > that they would have been during normal operation.
> > 
> > For log recovery, we enforce this ordering by using an empty transaction
> > to collect deferred ops that get created in the process of recovering a
> > log intent item to prevent them from being committed before the rest of
> > the recovered intent items.  After we finish committing all the
> > recovered log items, we allocate a transaction with an enormous block
> > reservation, splice our huge list of created deferred ops into that
> > transaction, and commit it, thereby finishing all those ops.
> > 
> > This is /really/ hokey -- it's the one place in XFS where we allow
> > nested transactions; the splicing of the defer ops list is is inelegant
> > and has to be done twice per recovery function; and the broken way we
> > handle inode pointers and block reservations cause subtle use-after-free
> > and allocator problems that will be fixed by this patch and the two
> > patches after it.
> > 
> > Therefore, replace the hokey empty transaction with a structure designed
> > to capture each chain of deferred ops that are created as part of
> > recovering a single unfinished log intent.  Finally, refactor the loop
> > that replays those chains to do so using one transaction per chain.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c  |   89 +++++++++++++++++++++++++++++++--
> >  fs/xfs/libxfs/xfs_defer.h  |   19 +++++++
> >  fs/xfs/xfs_bmap_item.c     |   16 +-----
> >  fs/xfs/xfs_extfree_item.c  |    7 +--
> >  fs/xfs/xfs_log_recover.c   |  118 +++++++++++++++++++++++++-------------------
> >  fs/xfs/xfs_refcount_item.c |   16 +-----
> >  fs/xfs/xfs_rmap_item.c     |    7 +--
> >  fs/xfs/xfs_trans.h         |    3 +
> >  8 files changed, 184 insertions(+), 91 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 84f876c6d498..550d0fa8057a 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2434,37 +2434,62 @@ xlog_recover_process_data(
> >  /* Take all the collected deferred ops and finish them in order. */
> >  static int
> >  xlog_finish_defer_ops(
> > -	struct xfs_trans	*parent_tp)
> > +	struct xfs_mount	*mp,
> > +	struct list_head	*capture_list)
> >  {
> > -	struct xfs_mount	*mp = parent_tp->t_mountp;
> > +	struct xfs_defer_capture *dfc, *next;
> >  	struct xfs_trans	*tp;
> >  	int64_t			freeblks;
> > -	uint			resblks;
> > -	int			error;
> > +	uint64_t		resblks;
> > +	int			error = 0;
> >  
> > -	/*
> > -	 * We're finishing the defer_ops that accumulated as a result of
> > -	 * recovering unfinished intent items during log recovery.  We
> > -	 * reserve an itruncate transaction because it is the largest
> > -	 * permanent transaction type.  Since we're the only user of the fs
> > -	 * right now, take 93% (15/16) of the available free blocks.  Use
> > -	 * weird math to avoid a 64-bit division.
> > -	 */
> > -	freeblks = percpu_counter_sum(&mp->m_fdblocks);
> > -	if (freeblks <= 0)
> > -		return -ENOSPC;
> > -	resblks = min_t(int64_t, UINT_MAX, freeblks);
> > -	resblks = (resblks * 15) >> 4;
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
> > -			0, XFS_TRANS_RESERVE, &tp);
> > -	if (error)
> > -		return error;
> > -	/* transfer all collected dfops to this transaction */
> > -	xfs_defer_move(tp, parent_tp);
> > +	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
> > +		/*
> > +		 * We're finishing the defer_ops that accumulated as a result
> > +		 * of recovering unfinished intent items during log recovery.
> > +		 * We reserve an itruncate transaction because it is the
> > +		 * largest permanent transaction type.  Since we're the only
> > +		 * user of the fs right now, take 93% (15/16) of the available
> > +		 * free blocks.  Use weird math to avoid a 64-bit division.
> > +		 */
> > +		freeblks = percpu_counter_sum(&mp->m_fdblocks);
> > +		if (freeblks <= 0)
> > +			return -ENOSPC;
> >  
> > -	return xfs_trans_commit(tp);
> > +		resblks = min_t(uint64_t, UINT_MAX, freeblks);
> > +		resblks = (resblks * 15) >> 4;
> > +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
> > +				0, XFS_TRANS_RESERVE, &tp);
> > +		if (error)
> > +			return error;
> > +
> > +		/* Transfer all collected dfops to this transaction. */
> 
> This old comment is a little misleading now that we have per-intent
> capture lists. That nit aside, this looks good to me and the updated
> factoring is easier to follow:

I'll change it to:

		/*
		 * Transfer to this new transaction all the dfops we captured
		 * from recovering a single intent item.
		 */

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for the review!

--D

> 
> > +		list_del_init(&dfc->dfc_list);
> > +		xfs_defer_ops_continue(dfc, tp);
> > +
> > +		error = xfs_trans_commit(tp);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	ASSERT(list_empty(capture_list));
> > +	return 0;
> >  }
> >  
> > +/* Release all the captured defer ops and capture structures in this list. */
> > +static void
> > +xlog_abort_defer_ops(
> > +	struct xfs_mount		*mp,
> > +	struct list_head		*capture_list)
> > +{
> > +	struct xfs_defer_capture	*dfc;
> > +	struct xfs_defer_capture	*next;
> > +
> > +	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
> > +		list_del_init(&dfc->dfc_list);
> > +		xfs_defer_ops_release(mp, dfc);
> > +	}
> > +}
> >  /*
> >   * When this is called, all of the log intent items which did not have
> >   * corresponding log done items should be in the AIL.  What we do now
> > @@ -2485,35 +2510,23 @@ STATIC int
> >  xlog_recover_process_intents(
> >  	struct xlog		*log)
> >  {
> > -	struct xfs_trans	*parent_tp;
> > +	LIST_HEAD(capture_list);
> >  	struct xfs_ail_cursor	cur;
> >  	struct xfs_log_item	*lip;
> >  	struct xfs_ail		*ailp;
> > -	int			error;
> > +	int			error = 0;
> >  #if defined(DEBUG) || defined(XFS_WARN)
> >  	xfs_lsn_t		last_lsn;
> >  #endif
> >  
> > -	/*
> > -	 * The intent recovery handlers commit transactions to complete recovery
> > -	 * for individual intents, but any new deferred operations that are
> > -	 * queued during that process are held off until the very end. The
> > -	 * purpose of this transaction is to serve as a container for deferred
> > -	 * operations. Each intent recovery handler must transfer dfops here
> > -	 * before its local transaction commits, and we'll finish the entire
> > -	 * list below.
> > -	 */
> > -	error = xfs_trans_alloc_empty(log->l_mp, &parent_tp);
> > -	if (error)
> > -		return error;
> > -
> >  	ailp = log->l_ailp;
> >  	spin_lock(&ailp->ail_lock);
> > -	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> >  #if defined(DEBUG) || defined(XFS_WARN)
> >  	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
> >  #endif
> > -	while (lip != NULL) {
> > +	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> > +	     lip != NULL;
> > +	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
> >  		/*
> >  		 * We're done when we see something other than an intent.
> >  		 * There should be no intents left in the AIL now.
> > @@ -2535,24 +2548,29 @@ xlog_recover_process_intents(
> >  
> >  		/*
> >  		 * NOTE: If your intent processing routine can create more
> > -		 * deferred ops, you /must/ attach them to the transaction in
> > -		 * this routine or else those subsequent intents will get
> > +		 * deferred ops, you /must/ attach them to the capture list in
> > +		 * the recover routine or else those subsequent intents will be
> >  		 * replayed in the wrong order!
> >  		 */
> >  		spin_unlock(&ailp->ail_lock);
> > -		error = lip->li_ops->iop_recover(lip, parent_tp);
> > +		error = lip->li_ops->iop_recover(lip, &capture_list);
> >  		spin_lock(&ailp->ail_lock);
> >  		if (error)
> > -			goto out;
> > -		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> > +			break;
> >  	}
> > -out:
> > +
> >  	xfs_trans_ail_cursor_done(&cur);
> >  	spin_unlock(&ailp->ail_lock);
> > -	if (!error)
> > -		error = xlog_finish_defer_ops(parent_tp);
> > -	xfs_trans_cancel(parent_tp);
> > +	if (error)
> > +		goto err;
> >  
> > +	error = xlog_finish_defer_ops(log->l_mp, &capture_list);
> > +	if (error)
> > +		goto err;
> > +
> > +	return 0;
> > +err:
> > +	xlog_abort_defer_ops(log->l_mp, &capture_list);
> >  	return error;
> >  }
> >  
> > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > index 3e34b7662361..0478374add64 100644
> > --- a/fs/xfs/xfs_refcount_item.c
> > +++ b/fs/xfs/xfs_refcount_item.c
> > @@ -424,7 +424,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
> >  STATIC int
> >  xfs_cui_item_recover(
> >  	struct xfs_log_item		*lip,
> > -	struct xfs_trans		*parent_tp)
> > +	struct list_head		*capture_list)
> >  {
> >  	struct xfs_bmbt_irec		irec;
> >  	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
> > @@ -432,7 +432,7 @@ xfs_cui_item_recover(
> >  	struct xfs_cud_log_item		*cudp;
> >  	struct xfs_trans		*tp;
> >  	struct xfs_btree_cur		*rcur = NULL;
> > -	struct xfs_mount		*mp = parent_tp->t_mountp;
> > +	struct xfs_mount		*mp = lip->li_mountp;
> >  	xfs_fsblock_t			startblock_fsb;
> >  	xfs_fsblock_t			new_fsb;
> >  	xfs_extlen_t			new_len;
> > @@ -487,12 +487,7 @@ xfs_cui_item_recover(
> >  			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
> >  	if (error)
> >  		return error;
> > -	/*
> > -	 * Recovery stashes all deferred ops during intent processing and
> > -	 * finishes them on completion. Transfer current dfops state to this
> > -	 * transaction and transfer the result back before we return.
> > -	 */
> > -	xfs_defer_move(tp, parent_tp);
> > +
> >  	cudp = xfs_trans_get_cud(tp, cuip);
> >  
> >  	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
> > @@ -549,13 +544,10 @@ xfs_cui_item_recover(
> >  	}
> >  
> >  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> > -	xfs_defer_capture(parent_tp, tp);
> > -	error = xfs_trans_commit(tp);
> > -	return error;
> > +	return xfs_defer_ops_capture_and_commit(tp, capture_list);
> >  
> >  abort_error:
> >  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> > -	xfs_defer_move(parent_tp, tp);
> >  	xfs_trans_cancel(tp);
> >  	return error;
> >  }
> > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > index e38ec5d736be..0d8fa707f079 100644
> > --- a/fs/xfs/xfs_rmap_item.c
> > +++ b/fs/xfs/xfs_rmap_item.c
> > @@ -467,14 +467,14 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
> >  STATIC int
> >  xfs_rui_item_recover(
> >  	struct xfs_log_item		*lip,
> > -	struct xfs_trans		*parent_tp)
> > +	struct list_head		*capture_list)
> >  {
> >  	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
> >  	struct xfs_map_extent		*rmap;
> >  	struct xfs_rud_log_item		*rudp;
> >  	struct xfs_trans		*tp;
> >  	struct xfs_btree_cur		*rcur = NULL;
> > -	struct xfs_mount		*mp = parent_tp->t_mountp;
> > +	struct xfs_mount		*mp = lip->li_mountp;
> >  	xfs_fsblock_t			startblock_fsb;
> >  	enum xfs_rmap_intent_type	type;
> >  	xfs_exntst_t			state;
> > @@ -567,8 +567,7 @@ xfs_rui_item_recover(
> >  	}
> >  
> >  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> > -	error = xfs_trans_commit(tp);
> > -	return error;
> > +	return xfs_defer_ops_capture_and_commit(tp, capture_list);
> >  
> >  abort_error:
> >  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index ced62a35a62b..186e77d08cc1 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -72,7 +72,8 @@ struct xfs_item_ops {
> >  	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
> >  	void (*iop_release)(struct xfs_log_item *);
> >  	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
> > -	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
> > +	int (*iop_recover)(struct xfs_log_item *lip,
> > +			   struct list_head *capture_list);
> >  	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
> >  };
> >  
> > 
> 
