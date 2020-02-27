Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF9AC11D3D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03E29246A1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:49:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="t1uXo4Rx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgB0Utb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:49:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46836 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgB0Utb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 15:49:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RKlRHg187369;
        Thu, 27 Feb 2020 20:49:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Ml6TXIfaJukoCodSRNhhXvtGs8Mq0FaNxODI0KOBYSw=;
 b=t1uXo4RxHelLaTuGJBWlcUZkuu2vl2uejzHJwza0j3PXAiDVqpChduwtpcUJR6n18sX6
 lA9w9bDJpFPQcfmVPkGCziMXIshr3DBHBjG35q/01WwVNrDbFMmt6wkjCrlfnWTxGpcM
 tUoU993HN+1x390BwSl9OxzPFRl9EntOxNjoxp7AFDOLhqdyUhynOkbdmFwvs+m7BTYd
 E+vznsZ3Q3lVvj1c4CeZ7AFSqoAIdYYLH3jnv97zWfmoJwRuMD4hxOteHwIUEv2vRxCp
 D/90nddUHhLhnyWxSJpXc0zq9f0lFHH8ZPO241vU6aUS0RW7sV+9kq9pkVsoZvs3z8uR zQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ydcsnnkn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 20:49:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RKmHLr084841;
        Thu, 27 Feb 2020 20:49:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ydcs69h9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 20:49:26 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01RKnPgf009003;
        Thu, 27 Feb 2020 20:49:25 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 12:49:25 -0800
Subject: Re: [RFC v5 PATCH 3/9] xfs: automatic relogging reservation
 management
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-4-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a55da635-513b-2d94-5f44-db8ba450428b@oracle.com>
Date:   Thu, 27 Feb 2020 13:49:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200227134321.7238-4-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=2 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=2 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/27/20 6:43 AM, Brian Foster wrote:
> Automatic item relogging will occur from xfsaild context. xfsaild
> cannot acquire log reservation itself because it is also responsible
> for writeback and thus making used log reservation available again.
> Since there is no guarantee log reservation is available by the time
> a relogged item reaches the AIL, this is prone to deadlock.
> 
> To guarantee log reservation for automatic relogging, implement a
> reservation management scheme where a transaction that is capable of
> enabling relogging of an item must contribute the necessary
> reservation to the relog mechanism up front. Use reference counting
> to associate the lifetime of pending relog reservation to the
> lifetime of in-core log items with relogging enabled.
> 
> The basic log reservation sequence for a relog enabled transaction
> is as follows:
> 
> - A transaction that uses relogging specifies XFS_TRANS_RELOG at
>    allocation time.
> - Once initialized, RELOG transactions check for the existence of
>    the global relog log ticket. If it exists, grab a reference and
>    return. If not, allocate an empty ticket and install into the relog
>    subsystem. Seed the relog ticket from reservation of the current
>    transaction. Roll the current transaction to replenish its
>    reservation and return to the caller.
> - The transaction is used as normal. If an item is relogged in the
>    transaction, that item acquires a reference on the global relog
>    ticket currently held open by the transaction. The item's reference
>    persists until relogging is disabled on the item.
> - The RELOG transaction commits and releases its reference to the
>    global relog ticket. The global relog ticket is released once its
>    reference count drops to zero.
> 
> This provides a central relog log ticket that guarantees reservation
> availability for relogged items, avoids log reservation deadlocks
> and is allocated and released on demand.
> 
Ok, I followed it through and didn't see any obvious errors
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/libxfs/xfs_shared.h |  1 +
>   fs/xfs/xfs_trans.c         | 37 +++++++++++++---
>   fs/xfs/xfs_trans.h         |  3 ++
>   fs/xfs/xfs_trans_ail.c     | 89 ++++++++++++++++++++++++++++++++++++++
>   fs/xfs/xfs_trans_priv.h    |  1 +
>   5 files changed, 126 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index c45acbd3add9..0a10ca0853ab 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -77,6 +77,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>    * made then this algorithm will eventually find all the space it needs.
>    */
>   #define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
> +#define XFS_TRANS_RELOG		0x200	/* enable automatic relogging */
>   
>   /*
>    * Field values for xfs_trans_mod_sb.
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 3b208f9a865c..8ac05ed8deda 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -107,9 +107,14 @@ xfs_trans_dup(
>   
>   	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
>   		       (tp->t_flags & XFS_TRANS_RESERVE) |
> -		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
> -	/* We gave our writer reference to the new transaction */
> +		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
> +		       (tp->t_flags & XFS_TRANS_RELOG);
> +	/*
> +	 * The writer reference and relog reference transfer to the new
> +	 * transaction.
> +	 */
>   	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
> +	tp->t_flags &= ~XFS_TRANS_RELOG;
>   	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
>   
>   	ASSERT(tp->t_blk_res >= tp->t_blk_res_used);
> @@ -284,15 +289,25 @@ xfs_trans_alloc(
>   	tp->t_firstblock = NULLFSBLOCK;
>   
>   	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
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
>   	}
>   
>   	trace_xfs_trans_alloc(tp, _RET_IP_);
>   
>   	*tpp = tp;
>   	return 0;
> +
> +error:
> +	/* clear relog flag if we haven't acquired a ref */
> +	tp->t_flags &= ~XFS_TRANS_RELOG;
> +	xfs_trans_cancel(tp);
> +	return error;
>   }
>   
>   /*
> @@ -973,6 +988,10 @@ __xfs_trans_commit(
>   
>   	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
>   
> +	/* release the relog ticket reference if this transaction holds one */
> +	if (tp->t_flags & XFS_TRANS_RELOG)
> +		xfs_trans_ail_relog_put(mp);
> +
>   	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
>   	xfs_trans_free(tp);
>   
> @@ -1004,6 +1023,10 @@ __xfs_trans_commit(
>   			error = -EIO;
>   		tp->t_ticket = NULL;
>   	}
> +	/* release the relog ticket reference if this transaction holds one */
> +	/* XXX: handle RELOG items on transaction abort */
> +	if (tp->t_flags & XFS_TRANS_RELOG)
> +		xfs_trans_ail_relog_put(mp);
>   	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
>   	xfs_trans_free_items(tp, !!error);
>   	xfs_trans_free(tp);
> @@ -1064,6 +1087,10 @@ xfs_trans_cancel(
>   		tp->t_ticket = NULL;
>   	}
>   
> +	/* release the relog ticket reference if this transaction holds one */
> +	if (tp->t_flags & XFS_TRANS_RELOG)
> +		xfs_trans_ail_relog_put(mp);
> +
>   	/* mark this thread as no longer being in a transaction */
>   	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
>   
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 752c7fef9de7..a032989943bd 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -236,6 +236,9 @@ int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
>   void		xfs_trans_cancel(xfs_trans_t *);
>   int		xfs_trans_ail_init(struct xfs_mount *);
>   void		xfs_trans_ail_destroy(struct xfs_mount *);
> +int		xfs_trans_ail_relog_reserve(struct xfs_trans **);
> +bool		xfs_trans_ail_relog_get(struct xfs_mount *);
> +int		xfs_trans_ail_relog_put(struct xfs_mount *);
>   
>   void		xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
>   				       enum xfs_blft);
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 00cc5b8734be..a3fb64275baa 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -17,6 +17,7 @@
>   #include "xfs_errortag.h"
>   #include "xfs_error.h"
>   #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>   
>   #ifdef DEBUG
>   /*
> @@ -818,6 +819,93 @@ xfs_trans_ail_delete(
>   		xfs_log_space_wake(ailp->ail_mount);
>   }
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
>   int
>   xfs_trans_ail_init(
>   	xfs_mount_t	*mp)
> @@ -854,6 +942,7 @@ xfs_trans_ail_destroy(
>   {
>   	struct xfs_ail	*ailp = mp->m_ail;
>   
> +	ASSERT(ailp->ail_relog_tic == NULL);
>   	kthread_stop(ailp->ail_task);
>   	kmem_free(ailp);
>   }
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 2e073c1c4614..839df6559b9f 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -61,6 +61,7 @@ struct xfs_ail {
>   	int			ail_log_flush;
>   	struct list_head	ail_buf_list;
>   	wait_queue_head_t	ail_empty;
> +	struct xlog_ticket	*ail_relog_tic;
>   };
>   
>   /*
> 
