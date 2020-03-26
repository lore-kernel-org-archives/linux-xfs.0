Return-Path: <SRS0=JvtZ=5L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9589C43331
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 05:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6A8520772
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 05:14:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ck9e5Edg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgCZFOX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 01:14:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45126 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgCZFOX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 01:14:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02Q5EKJg145927;
        Thu, 26 Mar 2020 05:14:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=b+/7wE5k8geYhhvFTW6dk7CrMLxZn10EOdXkdARppxc=;
 b=Ck9e5Edg8e0/9+CBQ3IYd9bcXFdIaCv0e1PWQvIFo6nG2btlFiupFh///fCFcvX1e8Sr
 M1J/shnm+ztnQHal+gcygHmPswOfsiN0/2+7SLf+b38MVDniOgEly17Dah2D7PA6WxO5
 hs7CczbriyXzhS/lOuZOxh80rnqjyWFaflwk2AzaOn1bDGP1+vUej/iL4QNiYG9IzIKz
 WoT1WgObzZnq3NO05rWrCkyDKssi8IoTUawpERgs0dbZJehn7Ps7JZi3gP+ZBpNXGIel
 n0x70Uc2qfJch82ipy0zRIua0M9OPi738UigwyESHcUDChwwYQsGfs+UjCYiQ1HN/xxg /Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3005kvchm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 05:14:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02Q5Cr72094176;
        Thu, 26 Mar 2020 05:14:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30073c9a76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Mar 2020 05:14:19 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02Q5EJlj027081;
        Thu, 26 Mar 2020 05:14:19 GMT
Received: from localhost (/10.159.237.96)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Mar 2020 22:14:18 -0700
Date:   Wed, 25 Mar 2020 22:14:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: tail updates only need to occur when LSN changes
Message-ID: <20200326051417.GC29339@magnolia>
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325014205.11843-8-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9571 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003260033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9571 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 impostorscore=0 spamscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003260033
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 12:42:04PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently wake anything waiting on the log tail to move whenever
> the log item at the tail of the log is removed. Historically this
> was fine behaviour because there were very few items at any given
> LSN. But with delayed logging, there may be thousands of items at
> any given LSN, and we can't move the tail until they are all gone.
> 
> Hence if we are removing them in near tail-first order, we might be
> waking up processes waiting on the tail LSN to change (e.g. log
> space waiters) repeatedly without them being able to make progress.
> This also occurs with the new sync push waiters, and can result in
> thousands of spurious wakeups every second when under heavy direct
> reclaim pressure.
> 
> To fix this, check that the tail LSN has actually changed on the
> AIL before triggering wakeups. This will reduce the number of
> spurious wakeups when doing bulk AIL removal and make this code much
> more efficient.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

I don't think this changed since I RVB'd the last submission, right?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode_item.c | 18 ++++++++++----
>  fs/xfs/xfs_trans_ail.c  | 52 ++++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_trans_priv.h |  4 ++--
>  3 files changed, 51 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index bd8c368098707..a627cb951dc61 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -730,19 +730,27 @@ xfs_iflush_done(
>  	 * holding the lock before removing the inode from the AIL.
>  	 */
>  	if (need_ail) {
> -		bool			mlip_changed = false;
> +		xfs_lsn_t	tail_lsn = 0;
>  
>  		/* this is an opencoded batch version of xfs_trans_ail_delete */
>  		spin_lock(&ailp->ail_lock);
>  		list_for_each_entry(blip, &tmp, li_bio_list) {
>  			if (INODE_ITEM(blip)->ili_logged &&
> -			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn)
> -				mlip_changed |= xfs_ail_delete_one(ailp, blip);
> -			else {
> +			    blip->li_lsn == INODE_ITEM(blip)->ili_flush_lsn) {
> +				/*
> +				 * xfs_ail_update_finish() only cares about the
> +				 * lsn of the first tail item removed, any
> +				 * others will be at the same or higher lsn so
> +				 * we just ignore them.
> +				 */
> +				xfs_lsn_t lsn = xfs_ail_delete_one(ailp, blip);
> +				if (!tail_lsn && lsn)
> +					tail_lsn = lsn;
> +			} else {
>  				xfs_clear_li_failed(blip);
>  			}
>  		}
> -		xfs_ail_update_finish(ailp, mlip_changed);
> +		xfs_ail_update_finish(ailp, tail_lsn);
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 26d2e7928121c..564253550b754 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -109,17 +109,25 @@ xfs_ail_next(
>   * We need the AIL lock in order to get a coherent read of the lsn of the last
>   * item in the AIL.
>   */
> +static xfs_lsn_t
> +__xfs_ail_min_lsn(
> +	struct xfs_ail		*ailp)
> +{
> +	struct xfs_log_item	*lip = xfs_ail_min(ailp);
> +
> +	if (lip)
> +		return lip->li_lsn;
> +	return 0;
> +}
> +
>  xfs_lsn_t
>  xfs_ail_min_lsn(
>  	struct xfs_ail		*ailp)
>  {
> -	xfs_lsn_t		lsn = 0;
> -	struct xfs_log_item	*lip;
> +	xfs_lsn_t		lsn;
>  
>  	spin_lock(&ailp->ail_lock);
> -	lip = xfs_ail_min(ailp);
> -	if (lip)
> -		lsn = lip->li_lsn;
> +	lsn = __xfs_ail_min_lsn(ailp);
>  	spin_unlock(&ailp->ail_lock);
>  
>  	return lsn;
> @@ -684,11 +692,12 @@ xfs_ail_push_all_sync(
>  void
>  xfs_ail_update_finish(
>  	struct xfs_ail		*ailp,
> -	bool			do_tail_update) __releases(ailp->ail_lock)
> +	xfs_lsn_t		old_lsn) __releases(ailp->ail_lock)
>  {
>  	struct xfs_mount	*mp = ailp->ail_mount;
>  
> -	if (!do_tail_update) {
> +	/* if the tail lsn hasn't changed, don't do updates or wakeups. */
> +	if (!old_lsn || old_lsn == __xfs_ail_min_lsn(ailp)) {
>  		spin_unlock(&ailp->ail_lock);
>  		return;
>  	}
> @@ -733,7 +742,7 @@ xfs_trans_ail_update_bulk(
>  	xfs_lsn_t		lsn) __releases(ailp->ail_lock)
>  {
>  	struct xfs_log_item	*mlip;
> -	int			mlip_changed = 0;
> +	xfs_lsn_t		tail_lsn = 0;
>  	int			i;
>  	LIST_HEAD(tmp);
>  
> @@ -748,9 +757,10 @@ xfs_trans_ail_update_bulk(
>  				continue;
>  
>  			trace_xfs_ail_move(lip, lip->li_lsn, lsn);
> +			if (mlip == lip && !tail_lsn)
> +				tail_lsn = lip->li_lsn;
> +
>  			xfs_ail_delete(ailp, lip);
> -			if (mlip == lip)
> -				mlip_changed = 1;
>  		} else {
>  			trace_xfs_ail_insert(lip, 0, lsn);
>  		}
> @@ -761,15 +771,23 @@ xfs_trans_ail_update_bulk(
>  	if (!list_empty(&tmp))
>  		xfs_ail_splice(ailp, cur, &tmp, lsn);
>  
> -	xfs_ail_update_finish(ailp, mlip_changed);
> +	xfs_ail_update_finish(ailp, tail_lsn);
>  }
>  
> -bool
> +/*
> + * Delete one log item from the AIL.
> + *
> + * If this item was at the tail of the AIL, return the LSN of the log item so
> + * that we can use it to check if the LSN of the tail of the log has moved
> + * when finishing up the AIL delete process in xfs_ail_update_finish().
> + */
> +xfs_lsn_t
>  xfs_ail_delete_one(
>  	struct xfs_ail		*ailp,
>  	struct xfs_log_item	*lip)
>  {
>  	struct xfs_log_item	*mlip = xfs_ail_min(ailp);
> +	xfs_lsn_t		lsn = lip->li_lsn;
>  
>  	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
>  	xfs_ail_delete(ailp, lip);
> @@ -777,7 +795,9 @@ xfs_ail_delete_one(
>  	clear_bit(XFS_LI_IN_AIL, &lip->li_flags);
>  	lip->li_lsn = 0;
>  
> -	return mlip == lip;
> +	if (mlip == lip)
> +		return lsn;
> +	return 0;
>  }
>  
>  /**
> @@ -808,7 +828,7 @@ xfs_trans_ail_delete(
>  	int			shutdown_type)
>  {
>  	struct xfs_mount	*mp = ailp->ail_mount;
> -	bool			need_update;
> +	xfs_lsn_t		tail_lsn;
>  
>  	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>  		spin_unlock(&ailp->ail_lock);
> @@ -821,8 +841,8 @@ xfs_trans_ail_delete(
>  		return;
>  	}
>  
> -	need_update = xfs_ail_delete_one(ailp, lip);
> -	xfs_ail_update_finish(ailp, need_update);
> +	tail_lsn = xfs_ail_delete_one(ailp, lip);
> +	xfs_ail_update_finish(ailp, tail_lsn);
>  }
>  
>  int
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 64ffa746730e4..35655eac01a65 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -91,8 +91,8 @@ xfs_trans_ail_update(
>  	xfs_trans_ail_update_bulk(ailp, NULL, &lip, 1, lsn);
>  }
>  
> -bool xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
> -void xfs_ail_update_finish(struct xfs_ail *ailp, bool do_tail_update)
> +xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
> +void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
>  			__releases(ailp->ail_lock);
>  void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
>  		int shutdown_type);
> -- 
> 2.26.0.rc2
> 
