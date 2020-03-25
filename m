Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46A6C1975A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 05:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F7AE20714
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 05:10:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d3Cc3qZg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgCYFKy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 01:10:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37404 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgCYFKx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 01:10:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P59dWk177046;
        Wed, 25 Mar 2020 05:10:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6ilfgFPFAWQKz88I92D87lDCJQ/gtFDxYLoxvxTbJDw=;
 b=d3Cc3qZgjgllZhZzToeSpCGz57oBMsc9+UsK6xrDJo1ITmnpYbNVxuY90Oigxj14C20O
 dc+IzthAZ9pY0PGln4jQBEszuzBiwQXCruXqppXvSYvT8U2TFgIThfkL8dFORT5teGj/
 s6i5CULt/k2SlBowCpWP0KORzQh15US4g8rT4PpeFsAuvJUbYjmR4RCDI0Ky3mX5sQXJ
 H9J2xVYuwNCfq95sT2f67Vma8UDBHyyf+wAYB5v/I/JLKhSDhC2ozGbblJzBxw0J2ow9
 sDT/urljsW9eMKXdS1n+vhWfc36KIIx3TKvKGx+fD5ABUcAApQVC4KULGajmJSFynS6B Og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ywabr7tqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 05:10:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P57gJw171027;
        Wed, 25 Mar 2020 05:10:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2yxw6p4m6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 05:10:50 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02P5Alnl002484;
        Wed, 25 Mar 2020 05:10:50 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 22:10:47 -0700
Subject: Re: [PATCH 7/8] xfs: tail updates only need to occur when LSN changes
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-8-david@fromorbit.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <2b072ba4-aedc-a0d0-01cc-5fb8b2d32719@oracle.com>
Date:   Tue, 24 Mar 2020 22:10:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200325014205.11843-8-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/24/20 6:42 PM, Dave Chinner wrote:
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
Ok, I dont see any obvious errors
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_inode_item.c | 18 ++++++++++----
>   fs/xfs/xfs_trans_ail.c  | 52 ++++++++++++++++++++++++++++-------------
>   fs/xfs/xfs_trans_priv.h |  4 ++--
>   3 files changed, 51 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index bd8c368098707..a627cb951dc61 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -730,19 +730,27 @@ xfs_iflush_done(
>   	 * holding the lock before removing the inode from the AIL.
>   	 */
>   	if (need_ail) {
> -		bool			mlip_changed = false;
> +		xfs_lsn_t	tail_lsn = 0;
>   
>   		/* this is an opencoded batch version of xfs_trans_ail_delete */
>   		spin_lock(&ailp->ail_lock);
>   		list_for_each_entry(blip, &tmp, li_bio_list) {
>   			if (INODE_ITEM(blip)->ili_logged &&
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
>   				xfs_clear_li_failed(blip);
>   			}
>   		}
> -		xfs_ail_update_finish(ailp, mlip_changed);
> +		xfs_ail_update_finish(ailp, tail_lsn);
>   	}
>   
>   	/*
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 26d2e7928121c..564253550b754 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -109,17 +109,25 @@ xfs_ail_next(
>    * We need the AIL lock in order to get a coherent read of the lsn of the last
>    * item in the AIL.
>    */
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
>   xfs_lsn_t
>   xfs_ail_min_lsn(
>   	struct xfs_ail		*ailp)
>   {
> -	xfs_lsn_t		lsn = 0;
> -	struct xfs_log_item	*lip;
> +	xfs_lsn_t		lsn;
>   
>   	spin_lock(&ailp->ail_lock);
> -	lip = xfs_ail_min(ailp);
> -	if (lip)
> -		lsn = lip->li_lsn;
> +	lsn = __xfs_ail_min_lsn(ailp);
>   	spin_unlock(&ailp->ail_lock);
>   
>   	return lsn;
> @@ -684,11 +692,12 @@ xfs_ail_push_all_sync(
>   void
>   xfs_ail_update_finish(
>   	struct xfs_ail		*ailp,
> -	bool			do_tail_update) __releases(ailp->ail_lock)
> +	xfs_lsn_t		old_lsn) __releases(ailp->ail_lock)
>   {
>   	struct xfs_mount	*mp = ailp->ail_mount;
>   
> -	if (!do_tail_update) {
> +	/* if the tail lsn hasn't changed, don't do updates or wakeups. */
> +	if (!old_lsn || old_lsn == __xfs_ail_min_lsn(ailp)) {
>   		spin_unlock(&ailp->ail_lock);
>   		return;
>   	}
> @@ -733,7 +742,7 @@ xfs_trans_ail_update_bulk(
>   	xfs_lsn_t		lsn) __releases(ailp->ail_lock)
>   {
>   	struct xfs_log_item	*mlip;
> -	int			mlip_changed = 0;
> +	xfs_lsn_t		tail_lsn = 0;
>   	int			i;
>   	LIST_HEAD(tmp);
>   
> @@ -748,9 +757,10 @@ xfs_trans_ail_update_bulk(
>   				continue;
>   
>   			trace_xfs_ail_move(lip, lip->li_lsn, lsn);
> +			if (mlip == lip && !tail_lsn)
> +				tail_lsn = lip->li_lsn;
> +
>   			xfs_ail_delete(ailp, lip);
> -			if (mlip == lip)
> -				mlip_changed = 1;
>   		} else {
>   			trace_xfs_ail_insert(lip, 0, lsn);
>   		}
> @@ -761,15 +771,23 @@ xfs_trans_ail_update_bulk(
>   	if (!list_empty(&tmp))
>   		xfs_ail_splice(ailp, cur, &tmp, lsn);
>   
> -	xfs_ail_update_finish(ailp, mlip_changed);
> +	xfs_ail_update_finish(ailp, tail_lsn);
>   }
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
>   xfs_ail_delete_one(
>   	struct xfs_ail		*ailp,
>   	struct xfs_log_item	*lip)
>   {
>   	struct xfs_log_item	*mlip = xfs_ail_min(ailp);
> +	xfs_lsn_t		lsn = lip->li_lsn;
>   
>   	trace_xfs_ail_delete(lip, mlip->li_lsn, lip->li_lsn);
>   	xfs_ail_delete(ailp, lip);
> @@ -777,7 +795,9 @@ xfs_ail_delete_one(
>   	clear_bit(XFS_LI_IN_AIL, &lip->li_flags);
>   	lip->li_lsn = 0;
>   
> -	return mlip == lip;
> +	if (mlip == lip)
> +		return lsn;
> +	return 0;
>   }
>   
>   /**
> @@ -808,7 +828,7 @@ xfs_trans_ail_delete(
>   	int			shutdown_type)
>   {
>   	struct xfs_mount	*mp = ailp->ail_mount;
> -	bool			need_update;
> +	xfs_lsn_t		tail_lsn;
>   
>   	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>   		spin_unlock(&ailp->ail_lock);
> @@ -821,8 +841,8 @@ xfs_trans_ail_delete(
>   		return;
>   	}
>   
> -	need_update = xfs_ail_delete_one(ailp, lip);
> -	xfs_ail_update_finish(ailp, need_update);
> +	tail_lsn = xfs_ail_delete_one(ailp, lip);
> +	xfs_ail_update_finish(ailp, tail_lsn);
>   }
>   
>   int
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 64ffa746730e4..35655eac01a65 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -91,8 +91,8 @@ xfs_trans_ail_update(
>   	xfs_trans_ail_update_bulk(ailp, NULL, &lip, 1, lsn);
>   }
>   
> -bool xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
> -void xfs_ail_update_finish(struct xfs_ail *ailp, bool do_tail_update)
> +xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
> +void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
>   			__releases(ailp->ail_lock);
>   void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
>   		int shutdown_type);
> 
