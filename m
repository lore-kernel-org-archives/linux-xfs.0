Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEB8C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 20:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7BC820674
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 20:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EgGQzaWL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgFBUps (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 16:45:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35914 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgFBUpr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 16:45:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052KaRpB043148;
        Tue, 2 Jun 2020 20:45:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=f1VNO9gHEprbYcs2JmMseIIabYOW8UDgSNebPaqv7+U=;
 b=EgGQzaWLLsUdsp7lOF3n7LW+GqHs/YNIp52TL3VGg/NdabBqFkPbDaR2td7BD9lT9Akt
 AdAd9pNQy4cjJukh0ngH7u5xWXYJEUtOlEbIIlo9DOwpAEg/RqWZpQge/KAvxcsJNSho
 sI9Oq2x9gV2A5bBMUSoQOLQJ6IY1zKJG3UrEYyWoMoKzYZh/7TfzPE4pE3IV9JXqjhUD
 0/LN3qEOC4tyqN/P9VAByJebzjV0Sgwm8hoQUhMuLFUk6dTelxBaJr71oaSzOA0Nh4Ad
 e5QMlbKsYUm7dww4Gglv+/EGSQUXFAW9iatRnASGDZa/gKe9uV6L/KoRjmve5dOoDH3H rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31bfem5yw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 20:45:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052Kc0tx042714;
        Tue, 2 Jun 2020 20:45:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31dju23k66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 20:45:44 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 052KjgME028746;
        Tue, 2 Jun 2020 20:45:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 13:45:42 -0700
Date:   Tue, 2 Jun 2020 13:45:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/30] xfs: unwind log item error flagging
Message-ID: <20200602204541.GK8230@magnolia>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-15-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-15-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=5
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020150
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:35AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When an buffer IO error occurs, we want to mark all
> the log items attached to the buffer as failed. Open code
> the error handling loop so that we can modify the flagging for the
> different types of objects directly and independently of each other.
> 
> This also allows us to remove the ->iop_error method from the log
> item operations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c   | 48 ++++++++++++-----------------------------
>  fs/xfs/xfs_dquot_item.c | 18 ----------------
>  fs/xfs/xfs_inode_item.c | 18 ----------------
>  fs/xfs/xfs_trans.h      |  1 -
>  4 files changed, 14 insertions(+), 71 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index b6995719e877b..2364a9aa2d71a 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -12,6 +12,7 @@
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
>  #include "xfs_trans.h"
> +#include "xfs_trans_priv.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_inode.h"
>  #include "xfs_inode_item.h"
> @@ -955,37 +956,6 @@ xfs_buf_item_relse(
>  	xfs_buf_item_free(bip);
>  }
>  
> -/*
> - * Invoke the error state callback for each log item affected by the failed I/O.
> - *
> - * If a metadata buffer write fails with a non-permanent error, the buffer is
> - * eventually resubmitted and so the completion callbacks are not run. The error
> - * state may need to be propagated to the log items attached to the buffer,
> - * however, so the next AIL push of the item knows hot to handle it correctly.
> - */
> -STATIC void
> -xfs_buf_do_callbacks_fail(
> -	struct xfs_buf		*bp)
> -{
> -	struct xfs_ail		*ailp = bp->b_mount->m_ail;
> -	struct xfs_log_item	*lip;
> -
> -	/*
> -	 * Buffer log item errors are handled directly by xfs_buf_item_push()
> -	 * and xfs_buf_iodone_callback_error, and they have no IO error
> -	 * callbacks. Check only for items in b_li_list.
> -	 */
> -	if (list_empty(&bp->b_li_list))
> -		return;
> -
> -	spin_lock(&ailp->ail_lock);
> -	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> -		if (lip->li_ops->iop_error)
> -			lip->li_ops->iop_error(lip, bp);
> -	}
> -	spin_unlock(&ailp->ail_lock);
> -}
> -
>  static bool
>  xfs_buf_ioerror_sync(
>  	struct xfs_buf		*bp)
> @@ -1154,13 +1124,18 @@ xfs_buf_inode_iodone(
>  	struct xfs_buf		*bp)
>  {
>  	if (bp->b_error) {
> +		struct xfs_log_item *lip;
>  		int ret = xfs_buf_iodone_error(bp);
>  		if (!ret)

Hmm we probably need a blank line between these declarations and the
start of the if statements, right?  Granted, I should've put this
complaint in the previous patch.

Otherwise this looks fine,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  			goto finish_iodone;
>  		if (ret == 1)
>  			return;
>  		ASSERT(ret == 2);
> -		xfs_buf_do_callbacks_fail(bp);
> +		spin_lock(&bp->b_mount->m_ail->ail_lock);
> +		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> +			xfs_set_li_failed(lip, bp);
> +		}
> +		spin_unlock(&bp->b_mount->m_ail->ail_lock);
>  		xfs_buf_relse(bp);
>  		return;
>  	}
> @@ -1180,13 +1155,18 @@ xfs_buf_dquot_iodone(
>  	struct xfs_buf		*bp)
>  {
>  	if (bp->b_error) {
> +		struct xfs_log_item *lip;
>  		int ret = xfs_buf_iodone_error(bp);
>  		if (!ret)
>  			goto finish_iodone;
>  		if (ret == 1)
>  			return;
>  		ASSERT(ret == 2);
> -		xfs_buf_do_callbacks_fail(bp);
> +		spin_lock(&bp->b_mount->m_ail->ail_lock);
> +		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> +			xfs_set_li_failed(lip, bp);
> +		}
> +		spin_unlock(&bp->b_mount->m_ail->ail_lock);
>  		xfs_buf_relse(bp);
>  		return;
>  	}
> @@ -1216,7 +1196,7 @@ xfs_buf_iodone(
>  		if (ret == 1)
>  			return;
>  		ASSERT(ret == 2);
> -		xfs_buf_do_callbacks_fail(bp);
> +		ASSERT(list_empty(&bp->b_li_list));
>  		xfs_buf_relse(bp);
>  		return;
>  	}
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 349c92d26570c..d7e4de7151d7f 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -113,23 +113,6 @@ xfs_qm_dqunpin_wait(
>  	wait_event(dqp->q_pinwait, (atomic_read(&dqp->q_pincount) == 0));
>  }
>  
> -/*
> - * Callback used to mark a buffer with XFS_LI_FAILED when items in the buffer
> - * have been failed during writeback
> - *
> - * this informs the AIL that the dquot is already flush locked on the next push,
> - * and acquires a hold on the buffer to ensure that it isn't reclaimed before
> - * dirty data makes it to disk.
> - */
> -STATIC void
> -xfs_dquot_item_error(
> -	struct xfs_log_item	*lip,
> -	struct xfs_buf		*bp)
> -{
> -	ASSERT(!completion_done(&DQUOT_ITEM(lip)->qli_dquot->q_flush));
> -	xfs_set_li_failed(lip, bp);
> -}
> -
>  STATIC uint
>  xfs_qm_dquot_logitem_push(
>  	struct xfs_log_item	*lip,
> @@ -216,7 +199,6 @@ static const struct xfs_item_ops xfs_dquot_item_ops = {
>  	.iop_release	= xfs_qm_dquot_logitem_release,
>  	.iop_committing	= xfs_qm_dquot_logitem_committing,
>  	.iop_push	= xfs_qm_dquot_logitem_push,
> -	.iop_error	= xfs_dquot_item_error
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 7049f2ae8d186..86c783dec2bac 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -464,23 +464,6 @@ xfs_inode_item_unpin(
>  		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
>  }
>  
> -/*
> - * Callback used to mark a buffer with XFS_LI_FAILED when items in the buffer
> - * have been failed during writeback
> - *
> - * This informs the AIL that the inode is already flush locked on the next push,
> - * and acquires a hold on the buffer to ensure that it isn't reclaimed before
> - * dirty data makes it to disk.
> - */
> -STATIC void
> -xfs_inode_item_error(
> -	struct xfs_log_item	*lip,
> -	struct xfs_buf		*bp)
> -{
> -	ASSERT(xfs_isiflocked(INODE_ITEM(lip)->ili_inode));
> -	xfs_set_li_failed(lip, bp);
> -}
> -
>  STATIC uint
>  xfs_inode_item_push(
>  	struct xfs_log_item	*lip,
> @@ -619,7 +602,6 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
>  	.iop_committed	= xfs_inode_item_committed,
>  	.iop_push	= xfs_inode_item_push,
>  	.iop_committing	= xfs_inode_item_committing,
> -	.iop_error	= xfs_inode_item_error
>  };
>  
>  
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 99a9ab9cab25b..b752501818d25 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -74,7 +74,6 @@ struct xfs_item_ops {
>  	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
>  	void (*iop_release)(struct xfs_log_item *);
>  	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
> -	void (*iop_error)(struct xfs_log_item *, xfs_buf_t *);
>  	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
>  	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
>  };
> -- 
> 2.26.2.761.g0e0b3e54be
> 
