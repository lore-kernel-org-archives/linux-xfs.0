Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6CD1C3F2CD
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 00:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 916B1246A3
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 00:02:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fLNxBbuh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbgB1ACZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 19:02:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34338 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729987AbgB1ACY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 19:02:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RNwxsG140167;
        Fri, 28 Feb 2020 00:02:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6/Cq0GKKJ2gbAkPWpv/KJK+ore39H5gGfAop4MNw8IE=;
 b=fLNxBbuhzdX9W2FgTKR9pr7lfYQZHRIngXRuarGfFKp5obTyDHOiAJ/ys9XbJF06EQlL
 NGqR2jx0+SURbcO+NIZc+S9OpEYMq544XbfCoUW36J6B7YSgkIj3f+vX5pp0SNhGu+l3
 og0OFbVdzfjfzKCsU15Z2KaMonQAoxsPcA6EpPeYY1XwSO27GmQIsZ2QFxOkh1jVCCDI
 9wFTc8258eeQrj75i/qSGVd46BYpSroZKOJxla03b/zZJSxd2m3KfGUhiRwgswQpJgoo
 UAI+FIpM1gl/2K5Qnf2YkL6q4ZAeGAeX4eUVE5809nlQs3EL7bbzMcRi57kvxCtYtg4r wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ydct3ea9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 00:02:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RNwLDv180324;
        Fri, 28 Feb 2020 00:02:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ydcsbcsry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Feb 2020 00:02:20 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01S02JAe011883;
        Fri, 28 Feb 2020 00:02:19 GMT
Received: from localhost (/10.145.179.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 16:02:19 -0800
Date:   Thu, 27 Feb 2020 16:02:18 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 3/9] xfs: automatic relogging reservation
 management
Message-ID: <20200228000218.GR8045@magnolia>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227134321.7238-4-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=2 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=2 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 08:43:15AM -0500, Brian Foster wrote:
> Automatic item relogging will occur from xfsaild context. xfsaild
> cannot acquire log reservation itself because it is also responsible
> for writeback and thus making used log reservation available again.
> Since there is no guarantee log reservation is available by the time
> a relogged item reaches the AIL, this is prone to deadlock.
> 
> To guarantee log reservation for automatic relogging, implement a
> reservation management scheme where a transaction that is capable of
> enabling relogging of an item must contribute the necessary
> reservation to the relog mechanism up front.

Ooooh, I had wondered where I was going to find that hook. :)

What does it mean to be capable of enabling relogging of an item?

For the quotaoff example, does this mean that all the transactions that
happen on behalf of a quotaoff operation must specify TRANS_RELOG?

What if the relog thread grinds to a halt while other non-RELOG threads
continue to push things into the log?  Can we starve and/or livelock
waiting around?  Or should the log be able to kick some higher level
thread to inject a TRANS_RELOG transaction to move things along?

> Use reference counting
> to associate the lifetime of pending relog reservation to the
> lifetime of in-core log items with relogging enabled.

Ok, so we only have to pay the relog reservation while there are
reloggable items floating around in the system.

> The basic log reservation sequence for a relog enabled transaction
> is as follows:
> 
> - A transaction that uses relogging specifies XFS_TRANS_RELOG at
>   allocation time.
> - Once initialized, RELOG transactions check for the existence of
>   the global relog log ticket. If it exists, grab a reference and
>   return. If not, allocate an empty ticket and install into the relog
>   subsystem. Seed the relog ticket from reservation of the current
>   transaction. Roll the current transaction to replenish its
>   reservation and return to the caller.

I guess we'd have to be careful that the transaction we're stealing from
actually has enough reservation to re-log a pending item, but that
shouldn't be difficult.

I worry that there might be some operation somewhere that Just Works
because tr_logcount * tr_logres is enough space for it to run without
having to get more reseration, but (tr_logcount - 1) * tr_logres isn't
enough.  Though that might not be a big issue seeing how bloated the
log reservations become when reflink and rmap are turned on. <cough>

> - The transaction is used as normal. If an item is relogged in the
>   transaction, that item acquires a reference on the global relog
>   ticket currently held open by the transaction. The item's reference
>   persists until relogging is disabled on the item.
> - The RELOG transaction commits and releases its reference to the
>   global relog ticket. The global relog ticket is released once its
>   reference count drops to zero.
> 
> This provides a central relog log ticket that guarantees reservation
> availability for relogged items, avoids log reservation deadlocks
> and is allocated and released on demand.

Sounds cool.  /me jumps in.

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_shared.h |  1 +
>  fs/xfs/xfs_trans.c         | 37 +++++++++++++---
>  fs/xfs/xfs_trans.h         |  3 ++
>  fs/xfs/xfs_trans_ail.c     | 89 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trans_priv.h    |  1 +
>  5 files changed, 126 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index c45acbd3add9..0a10ca0853ab 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -77,6 +77,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>   * made then this algorithm will eventually find all the space it needs.
>   */
>  #define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
> +#define XFS_TRANS_RELOG		0x200	/* enable automatic relogging */
>  
>  /*
>   * Field values for xfs_trans_mod_sb.
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 3b208f9a865c..8ac05ed8deda 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -107,9 +107,14 @@ xfs_trans_dup(
>  
>  	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
>  		       (tp->t_flags & XFS_TRANS_RESERVE) |
> -		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
> -	/* We gave our writer reference to the new transaction */
> +		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
> +		       (tp->t_flags & XFS_TRANS_RELOG);
> +	/*
> +	 * The writer reference and relog reference transfer to the new
> +	 * transaction.
> +	 */
>  	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
> +	tp->t_flags &= ~XFS_TRANS_RELOG;
>  	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
>  
>  	ASSERT(tp->t_blk_res >= tp->t_blk_res_used);
> @@ -284,15 +289,25 @@ xfs_trans_alloc(
>  	tp->t_firstblock = NULLFSBLOCK;
>  
>  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> -	if (error) {
> -		xfs_trans_cancel(tp);
> -		return error;
> +	if (error)
> +		goto error;
> +
> +	if (flags & XFS_TRANS_RELOG) {
> +		error = xfs_trans_ail_relog_reserve(&tp);
> +		if (error)
> +			goto error;
>  	}
>  
>  	trace_xfs_trans_alloc(tp, _RET_IP_);
>  
>  	*tpp = tp;
>  	return 0;
> +
> +error:
> +	/* clear relog flag if we haven't acquired a ref */
> +	tp->t_flags &= ~XFS_TRANS_RELOG;
> +	xfs_trans_cancel(tp);
> +	return error;
>  }
>  
>  /*
> @@ -973,6 +988,10 @@ __xfs_trans_commit(
>  
>  	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
>  
> +	/* release the relog ticket reference if this transaction holds one */
> +	if (tp->t_flags & XFS_TRANS_RELOG)
> +		xfs_trans_ail_relog_put(mp);
> +
>  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
>  	xfs_trans_free(tp);
>  
> @@ -1004,6 +1023,10 @@ __xfs_trans_commit(
>  			error = -EIO;
>  		tp->t_ticket = NULL;
>  	}
> +	/* release the relog ticket reference if this transaction holds one */
> +	/* XXX: handle RELOG items on transaction abort */

"Handle"?  Hm.  Do the reloggable items end up attached in some way to
this new transaction, or are we purely stealing the reservation so that
the ail can use it to relog the items on its own?  If it's the second,
then I wonder what handling do we need to do?

Or maybe you meant handling the relog items that the caller attached to
this relog transaction?  Won't those get cancelled the same way they do
now?

Mechanically this looks reasonable.

--D

> +	if (tp->t_flags & XFS_TRANS_RELOG)
> +		xfs_trans_ail_relog_put(mp);
>  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
>  	xfs_trans_free_items(tp, !!error);
>  	xfs_trans_free(tp);
> @@ -1064,6 +1087,10 @@ xfs_trans_cancel(
>  		tp->t_ticket = NULL;
>  	}
>  
> +	/* release the relog ticket reference if this transaction holds one */
> +	if (tp->t_flags & XFS_TRANS_RELOG)
> +		xfs_trans_ail_relog_put(mp);
> +
>  	/* mark this thread as no longer being in a transaction */
>  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
>  
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 752c7fef9de7..a032989943bd 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -236,6 +236,9 @@ int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
>  void		xfs_trans_cancel(xfs_trans_t *);
>  int		xfs_trans_ail_init(struct xfs_mount *);
>  void		xfs_trans_ail_destroy(struct xfs_mount *);
> +int		xfs_trans_ail_relog_reserve(struct xfs_trans **);
> +bool		xfs_trans_ail_relog_get(struct xfs_mount *);
> +int		xfs_trans_ail_relog_put(struct xfs_mount *);
>  
>  void		xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
>  				       enum xfs_blft);
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 00cc5b8734be..a3fb64275baa 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -17,6 +17,7 @@
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>  
>  #ifdef DEBUG
>  /*
> @@ -818,6 +819,93 @@ xfs_trans_ail_delete(
>  		xfs_log_space_wake(ailp->ail_mount);
>  }
>  
> +bool
> +xfs_trans_ail_relog_get(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_ail		*ailp = mp->m_ail;
> +	bool			ret = false;
> +
> +	spin_lock(&ailp->ail_lock);
> +	if (ailp->ail_relog_tic) {
> +		xfs_log_ticket_get(ailp->ail_relog_tic);
> +		ret = true;
> +	}
> +	spin_unlock(&ailp->ail_lock);
> +	return ret;
> +}
> +
> +/*
> + * Reserve log space for the automatic relogging ->tr_relog ticket. This
> + * requires a clean, permanent transaction from the caller. Pull reservation
> + * for the relog ticket and roll the caller's transaction back to its fully
> + * reserved state. If the AIL relog ticket is already initialized, grab a
> + * reference and return.
> + */
> +int
> +xfs_trans_ail_relog_reserve(
> +	struct xfs_trans	**tpp)
> +{
> +	struct xfs_trans	*tp = *tpp;
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_ail		*ailp = mp->m_ail;
> +	struct xlog_ticket	*tic;
> +	uint32_t		logres = M_RES(mp)->tr_relog.tr_logres;
> +
> +	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> +	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
> +
> +	if (xfs_trans_ail_relog_get(mp))
> +		return 0;
> +
> +	/* no active ticket, fall into slow path to allocate one.. */
> +	tic = xlog_ticket_alloc(mp->m_log, logres, 1, XFS_TRANSACTION, true, 0);
> +	if (!tic)
> +		return -ENOMEM;
> +	ASSERT(tp->t_ticket->t_curr_res >= tic->t_curr_res);
> +
> +	/* check again since we dropped the lock for the allocation */
> +	spin_lock(&ailp->ail_lock);
> +	if (ailp->ail_relog_tic) {
> +		xfs_log_ticket_get(ailp->ail_relog_tic);
> +		spin_unlock(&ailp->ail_lock);
> +		xfs_log_ticket_put(tic);
> +		return 0;
> +	}
> +
> +	/* attach and reserve space for the ->tr_relog ticket */
> +	ailp->ail_relog_tic = tic;
> +	tp->t_ticket->t_curr_res -= tic->t_curr_res;
> +	spin_unlock(&ailp->ail_lock);
> +
> +	return xfs_trans_roll(tpp);
> +}
> +
> +/*
> + * Release a reference to the relog ticket.
> + */
> +int
> +xfs_trans_ail_relog_put(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_ail		*ailp = mp->m_ail;
> +	struct xlog_ticket	*tic;
> +
> +	spin_lock(&ailp->ail_lock);
> +	if (atomic_add_unless(&ailp->ail_relog_tic->t_ref, -1, 1)) {
> +		spin_unlock(&ailp->ail_lock);
> +		return 0;
> +	}
> +
> +	ASSERT(atomic_read(&ailp->ail_relog_tic->t_ref) == 1);
> +	tic = ailp->ail_relog_tic;
> +	ailp->ail_relog_tic = NULL;
> +	spin_unlock(&ailp->ail_lock);
> +
> +	xfs_log_done(mp, tic, NULL, false);
> +	return 0;
> +}
> +
>  int
>  xfs_trans_ail_init(
>  	xfs_mount_t	*mp)
> @@ -854,6 +942,7 @@ xfs_trans_ail_destroy(
>  {
>  	struct xfs_ail	*ailp = mp->m_ail;
>  
> +	ASSERT(ailp->ail_relog_tic == NULL);
>  	kthread_stop(ailp->ail_task);
>  	kmem_free(ailp);
>  }
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 2e073c1c4614..839df6559b9f 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -61,6 +61,7 @@ struct xfs_ail {
>  	int			ail_log_flush;
>  	struct list_head	ail_buf_list;
>  	wait_queue_head_t	ail_empty;
> +	struct xlog_ticket	*ail_relog_tic;
>  };
>  
>  /*
> -- 
> 2.21.1
> 
