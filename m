Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3445C47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 23:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B67B3206B8
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 23:35:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lODVl3/c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgEEXfi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 19:35:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40740 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbgEEXfh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 19:35:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045NYcmc018049;
        Tue, 5 May 2020 23:35:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EMNZ+xViK703pR2VOw/QTp1fJqkT28lIibgNWSCVkNY=;
 b=lODVl3/c5nGlHmk4tUVak46haGDDdY5Mmllb+SQSDFyDR2LUl+aiDod0jB1ANhG+PSu1
 sJb1g05Pp64/xtBiwWIWeJOjRF+l9wqYSBUjCCLUC6KL8aMTbOMLtmoaUTNrGNT6SYSF
 UaCMwYWTigOdd1fa9tQPjePVmgzHMgPx6zqlXAnN2cCstXXT3KFHFX6/7kUWonnWg9Oj
 0Xs5KEesIgTLDenZBLnd/R3xHIvxgi62GVo2nGkH9X6vzQSBhvGrCSgUMfkkBavUEhoV
 cKjdS15QIVLBAm1W8O8NrHA0aKzb27Ypy9p8/xKCwZJpr9rJ0GSAoeVbbQfZfr4O79WB lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r7jmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 23:35:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045NZWMD180215;
        Tue, 5 May 2020 23:35:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30sjng63wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 23:35:33 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 045NZQWw012532;
        Tue, 5 May 2020 23:35:26 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 16:35:25 -0700
Subject: Re: [PATCH v4 13/17] xfs: combine xfs_trans_ail_[remove|delete]()
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200504141154.55887-1-bfoster@redhat.com>
 <20200504141154.55887-14-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <9ff19ee3-a310-186a-d567-ba0b554eea62@oracle.com>
Date:   Tue, 5 May 2020 16:35:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504141154.55887-14-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=2
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050177
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 7:11 AM, Brian Foster wrote:
> Now that the functions and callers of
> xfs_trans_ail_[remove|delete]() have been fixed up appropriately,
> the only difference between the two is the shutdown behavior. There
> are only a few callers of the _remove() variant, so make the
> shutdown conditional on the parameter and combine the two functions.
> 
> Suggested-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Ok, looks ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_buf_item.c   |  2 +-
>   fs/xfs/xfs_dquot.c      |  2 +-
>   fs/xfs/xfs_dquot_item.c |  2 +-
>   fs/xfs/xfs_inode_item.c |  2 +-
>   fs/xfs/xfs_trans_ail.c  | 24 ++----------------------
>   fs/xfs/xfs_trans_priv.h | 17 -----------------
>   6 files changed, 6 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 47c547aca1f1..9e75e8d6042e 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -558,7 +558,7 @@ xfs_buf_item_put(
>   	 * state.
>   	 */
>   	if (aborted)
> -		xfs_trans_ail_remove(lip);
> +		xfs_trans_ail_delete(lip, 0);
>   	xfs_buf_item_relse(bip->bli_buf);
>   	return true;
>   }
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 497a9dbef1c9..52e0f7245afc 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1162,7 +1162,7 @@ xfs_qm_dqflush(
>   
>   out_abort:
>   	dqp->dq_flags &= ~XFS_DQ_DIRTY;
> -	xfs_trans_ail_remove(lip);
> +	xfs_trans_ail_delete(lip, 0);
>   	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>   out_unlock:
>   	xfs_dqfunlock(dqp);
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 8bd46810d5db..349c92d26570 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -343,7 +343,7 @@ xfs_qm_qoff_logitem_relse(
>   	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
>   	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
>   	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
> -	xfs_trans_ail_remove(lip);
> +	xfs_trans_ail_delete(lip, 0);
>   	kmem_free(lip->li_lv_shadow);
>   	kmem_free(qoff);
>   }
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 0e449d0a3d5c..1a02058178d1 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -768,7 +768,7 @@ xfs_iflush_abort(
>   	xfs_inode_log_item_t	*iip = ip->i_itemp;
>   
>   	if (iip) {
> -		xfs_trans_ail_remove(&iip->ili_item);
> +		xfs_trans_ail_delete(&iip->ili_item, 0);
>   		iip->ili_logged = 0;
>   		/*
>   		 * Clear the ili_last_fields bits now that we know that the
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index cfba691664c7..bf09d4b4df58 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -841,27 +841,6 @@ xfs_ail_delete_one(
>   	return 0;
>   }
>   
> -/**
> - * Remove a log items from the AIL
> - *
> - * @xfs_trans_ail_delete_bulk takes an array of log items that all need to
> - * removed from the AIL. The caller is already holding the AIL lock, and done
> - * all the checks necessary to ensure the items passed in via @log_items are
> - * ready for deletion. This includes checking that the items are in the AIL.
> - *
> - * For each log item to be removed, unlink it  from the AIL, clear the IN_AIL
> - * flag from the item and reset the item's lsn to 0. If we remove the first
> - * item in the AIL, update the log tail to match the new minimum LSN in the
> - * AIL.
> - *
> - * This function will not drop the AIL lock until all items are removed from
> - * the AIL to minimise the amount of lock traffic on the AIL. This does not
> - * greatly increase the AIL hold time, but does significantly reduce the amount
> - * of traffic on the lock, especially during IO completion.
> - *
> - * This function must be called with the AIL lock held.  The lock is dropped
> - * before returning.
> - */
>   void
>   xfs_trans_ail_delete(
>   	struct xfs_log_item	*lip,
> @@ -874,7 +853,7 @@ xfs_trans_ail_delete(
>   	spin_lock(&ailp->ail_lock);
>   	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>   		spin_unlock(&ailp->ail_lock);
> -		if (!XFS_FORCED_SHUTDOWN(mp)) {
> +		if (shutdown_type && !XFS_FORCED_SHUTDOWN(mp)) {
>   			xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
>   	"%s: attempting to delete a log item that is not in the AIL",
>   					__func__);
> @@ -883,6 +862,7 @@ xfs_trans_ail_delete(
>   		return;
>   	}
>   
> +	/* xfs_ail_update_finish() drops the AIL lock */
>   	tail_lsn = xfs_ail_delete_one(ailp, lip);
>   	xfs_ail_update_finish(ailp, tail_lsn);
>   }
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index ab0a82e90825..cc046d9557ae 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -96,23 +96,6 @@ void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
>   			__releases(ailp->ail_lock);
>   void xfs_trans_ail_delete(struct xfs_log_item *lip, int shutdown_type);
>   
> -static inline void
> -xfs_trans_ail_remove(
> -	struct xfs_log_item	*lip)
> -{
> -	struct xfs_ail		*ailp = lip->li_ailp;
> -	xfs_lsn_t		tail_lsn;
> -
> -	spin_lock(&ailp->ail_lock);
> -	/* xfs_ail_update_finish() drops the AIL lock */
> -	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
> -		tail_lsn = xfs_ail_delete_one(ailp, lip);
> -		xfs_ail_update_finish(ailp, tail_lsn);
> -	} else {
> -		spin_unlock(&ailp->ail_lock);
> -	}
> -}
> -
>   void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
>   void			xfs_ail_push_all(struct xfs_ail *);
>   void			xfs_ail_push_all_sync(struct xfs_ail *);
> 
