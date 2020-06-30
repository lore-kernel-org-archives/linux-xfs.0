Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A6ACC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 18:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09637206C0
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 18:06:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qJEp2R8N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389733AbgF3SGl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 14:06:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56484 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729105AbgF3SGl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 14:06:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UI3iGi185845;
        Tue, 30 Jun 2020 18:06:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=+QvEUiP7OJhp7RCrdbtEcvp3KVPq0i3nYkgvpvJvcLA=;
 b=qJEp2R8Nv9uaS8CTkOtb0yqvzfEhCQ/qPxmFZeOdtx7t9X9LHPL1wstsZBz68N556Qcq
 lnv/0DRRDxSqeNAR/JM/D6HEimHp61D74h3EOFDtnI5I3hWVrw4l/r+qMTbsg69Nmo4V
 EV+f/zwAvgbI6mka75ptdZ2/6qjrG/79siBs2sVVGjSYkBLWEkiRxgeU+rzqPI4vHCT7
 ZlB6naKVlcItSXzkTJEoAOvpZEdWEyhmdxRELPhyAsjyecjmxd/x276nEe46GOto8WvO
 BU057gNqyIBL5O4tvGYkaZn0fu91KB3YeWS6xOhBGODHOlgIl8rC5S07TAHJkptGmmMN yQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31ywrbmbhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 18:06:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UI2grj038929;
        Tue, 30 Jun 2020 18:06:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31xg141rqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 18:06:31 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UI6Uev026145;
        Tue, 30 Jun 2020 18:06:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 18:06:29 +0000
Date:   Tue, 30 Jun 2020 11:06:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: add log item precommit operation
Message-ID: <20200630180628.GO7606@magnolia>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623095015.1934171-3-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=1 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=1 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 07:50:13PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For inodes that are dirty, we have an attached cluster buffer that
> we want to use to track the dirty inode through the AIL.
> Unfortunately, locking the cluster buffer and adding it to the
> transaction when the inode is first logged in a transaction leads to
> buffer lock ordering inversions.
> 
> The specific problem is ordering against the AGI buffer. When
> modifying unlinked lists, the buffer lock order is AGI -> inode
> cluster buffer as the AGI buffer lock serialises all access to the
> unlinked lists. Unfortunately, functionality like xfs_droplink()
> logs the inode before calling xfs_iunlink(), as do various directory
> manipulation functions. The inode can be logged way down in the
> stack as far as the bmapi routines and hence, without a major
> rewrite of lots of APIs there's no way we can avoid the inode being
> logged by something until after the AGI has been logged.
> 
> As we are going to be using ordered buffers for inode AIL tracking,
> there isn't a need to actually lock that buffer against modification
> as all the modifications are captured by logging the inode item
> itself. Hence we don't actually need to join the cluster buffer into
> the transaction until just before it is committed. This means we do
> not perturb any of the existing buffer lock orders in transactions,
> and the inode cluster buffer is always locked last in a transaction
> that doesn't otherwise touch inode cluster buffers.
> 
> We do this by introducing a precommit log item method. A log item
> method is used because it is likely dquots will be moved to this
> same ordered buffer tracking scheme and hence will need a similar
> callout. This commit just introduces the mechanism; the inode item
> implementation is in followup commits.
> 
> The precommit items need to be sorted into consistent order as we
> may be locking multiple items here. Hence if we have two dirty
> inodes in cluster buffers A and B, and some other transaction has
> two separate dirty inodes in the same cluster buffers, locking them
> in different orders opens us up to ABBA deadlocks. Hence we sort the
> items on the transaction based on the presence of a sort log item
> method.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c |  1 +
>  fs/xfs/xfs_trans.c  | 90 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trans.h  |  6 ++-
>  3 files changed, 95 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0d73559f2d58..1c744dbb313f 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1077,6 +1077,7 @@ xfs_reclaim_inode(
>  	ip->i_ino = 0;
>  	spin_unlock(&ip->i_flags_lock);
>  
> +	ASSERT(!ip->i_itemp || ip->i_itemp->ili_item.li_buf == NULL);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  
>  	XFS_STATS_INC(ip->i_mount, xs_ig_reclaims);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 3c94e5ff4316..6f350490f84b 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -799,6 +799,89 @@ xfs_trans_committed_bulk(
>  	spin_unlock(&ailp->ail_lock);
>  }
>  
> +/*
> + * Sort transaction items prior to running precommit operations. This will
> + * attempt to order the items such that they will always be locked in the same
> + * order. Items that have no sort function are moved to the end of the list
> + * and so are locked last (XXX: need to check the logic matches the comment).
> + *
> + * This may need refinement as different types of objects add sort functions.
> + *
> + * Function is more complex than it needs to be because we are comparing 64 bit
> + * values and the function only returns 32 bit values.
> + */
> +static int
> +xfs_trans_precommit_sort(
> +	void			*unused_arg,
> +	struct list_head	*a,
> +	struct list_head	*b)
> +{
> +	struct xfs_log_item	*lia = container_of(a,
> +					struct xfs_log_item, li_trans);
> +	struct xfs_log_item	*lib = container_of(b,
> +					struct xfs_log_item, li_trans);
> +	int64_t			diff;
> +
> +	if (!lia->li_ops->iop_sort && !lib->li_ops->iop_sort)
> +		return 0;
> +	if (!lia->li_ops->iop_sort)
> +		return 1;
> +	if (!lib->li_ops->iop_sort)
> +		return -1;
> +
> +	diff = lia->li_ops->iop_sort(lia) - lib->li_ops->iop_sort(lib);
> +	if (diff < 0)
> +		return -1;
> +	if (diff > 0)
> +		return 1;
> +	return 0;
> +}
> +
> +/*
> + * Run transaction precommit functions.
> + *
> + * If there is an error in any of the callouts, then stop immediately and
> + * trigger a shutdown to abort the transaction. There is no recovery possible
> + * from errors at this point as the transaction is dirty....
> + */
> +static int
> +xfs_trans_run_precommits(
> +	struct xfs_trans	*tp)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_log_item	*lip, *n;
> +	int			error = 0;
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return -EIO;
> +
> +	/*
> +	 * Sort the item list to avoid ABBA deadlocks with other transactions
> +	 * running precommit operations that lock multiple shared items such as
> +	 * inode cluster buffers.
> +	 */
> +	list_sort(NULL, &tp->t_items, xfs_trans_precommit_sort);
> +
> +	/*
> +	 * Precommit operations can remove the log item from the transaction
> +	 * if the log item exists purely to delay modifications until they
> +	 * can be ordered against other operations. Hence we have to use
> +	 * list_for_each_entry_safe() here.
> +	 */
> +	list_for_each_entry_safe(lip, n, &tp->t_items, li_trans) {
> +		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
> +			continue;
> +		if (lip->li_ops->iop_precommit) {
> +			error = lip->li_ops->iop_precommit(tp, lip);
> +			if (error)
> +				break;
> +		}
> +	}
> +	if (error)
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +	return error;
> +}
> +
>  /*
>   * Commit the given transaction to the log.
>   *
> @@ -823,6 +906,13 @@ __xfs_trans_commit(
>  
>  	trace_xfs_trans_commit(tp, _RET_IP_);
>  
> +	error = xfs_trans_run_precommits(tp);
> +	if (error) {
> +		if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
> +			xfs_defer_cancel(tp);
> +		goto out_unreserve;
> +	}
> +
>  	/*
>  	 * Finish deferred items on final commit. Only permanent transactions
>  	 * should ever have deferred ops.
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index b752501818d2..26ea19bd0621 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -70,10 +70,12 @@ struct xfs_item_ops {
>  	void (*iop_format)(struct xfs_log_item *, struct xfs_log_vec *);
>  	void (*iop_pin)(struct xfs_log_item *);
>  	void (*iop_unpin)(struct xfs_log_item *, int remove);
> -	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
> +	uint64_t (*iop_sort)(struct xfs_log_item *);

Shouldn't the return value be signed, since this is a comparison
function...?  Or does the ->iop_sort function itself do sorting??

--D

> +	int (*iop_precommit)(struct xfs_trans *, struct xfs_log_item *);
>  	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
> -	void (*iop_release)(struct xfs_log_item *);
>  	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
> +	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
> +	void (*iop_release)(struct xfs_log_item *);
>  	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
>  	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
>  };
> -- 
> 2.26.2.761.g0e0b3e54be
> 
