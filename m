Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21383C4724C
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBFD22073E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 18:54:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EXYzYfJt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgD3Sy4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 14:54:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52876 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3Sy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 14:54:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UInJfT079539;
        Thu, 30 Apr 2020 18:54:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LZIDWcze+N2FQ8E5j7VBDtgQl+bHuiuiYJ9w2JtEAFg=;
 b=EXYzYfJtbSP2nkENNL06Au8fKjYVKbwADAMc/jOuOlUvXbESEADlaOrLUFisxwMzIkZu
 YWVrZpo7Nc/OlnPq1YdmadQU5qoVEwzApSsoTXV8Q3843em+8RjcUV+MqihzaM2IeMy/
 3Tk5JK00XL1Nv070grxQxg56LaAkEA12ItsIRx4IANOFwPMyG/5Gpz34HDhRXCFDytPK
 pBUILU5MnDn6LN+FmC3gJiB9XzQ6zs2uORBtzBvYplB33V9WrJt9eDPbDFwwyzfSkORx
 uQjHPonOVOj4da2yMXXpwXh8SztzC7QExZq7nrznrkRDX1FY0Xvc74k0fN+JhVpOAcLJ VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01p3td2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:54:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UIkt9T112534;
        Thu, 30 Apr 2020 18:52:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30qtf88s7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 18:52:51 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UIqpSm013584;
        Thu, 30 Apr 2020 18:52:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 11:52:51 -0700
Date:   Thu, 30 Apr 2020 11:52:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 10/17] xfs: acquire ->ail_lock from
 xfs_trans_ail_delete()
Message-ID: <20200430185250.GK6742@magnolia>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-11-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-11-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=2 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:46PM -0400, Brian Foster wrote:
> Several callers acquire the lock just prior to the call. Callers
> that require ->ail_lock for other purposes already check IN_AIL
> state and thus don't require the additional shutdown check in the
> helper. Push the lock down into xfs_trans_ail_delete(), open code
> the instances that still acquire it, and remove the unnecessary ailp
> parameter.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Ahh, this and the next few patches are a split of a larger patch from
the last posting.  So I guess the point of this is to reduce parameter
passing and get rid of the SHUTDOWN_* flags?

Looks decent to me, regardless...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf_item.c   | 27 +++++++++++----------------
>  fs/xfs/xfs_dquot.c      |  6 ++++--
>  fs/xfs/xfs_trans_ail.c  |  3 ++-
>  fs/xfs/xfs_trans_priv.h | 14 ++++++++------
>  4 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 1f7acffc99ba..06e306b49283 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -410,7 +410,6 @@ xfs_buf_item_unpin(
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	xfs_buf_t		*bp = bip->bli_buf;
> -	struct xfs_ail		*ailp = lip->li_ailp;
>  	int			stale = bip->bli_flags & XFS_BLI_STALE;
>  	int			freed;
>  
> @@ -452,10 +451,10 @@ xfs_buf_item_unpin(
>  		}
>  
>  		/*
> -		 * If we get called here because of an IO error, we may
> -		 * or may not have the item on the AIL. xfs_trans_ail_delete()
> -		 * will take care of that situation.
> -		 * xfs_trans_ail_delete() drops the AIL lock.
> +		 * If we get called here because of an IO error, we may or may
> +		 * not have the item on the AIL. xfs_trans_ail_delete() will
> +		 * take care of that situation. xfs_trans_ail_delete() drops
> +		 * the AIL lock.
>  		 */
>  		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
>  			xfs_buf_do_callbacks(bp);
> @@ -463,8 +462,7 @@ xfs_buf_item_unpin(
>  			list_del_init(&bp->b_li_list);
>  			bp->b_iodone = NULL;
>  		} else {
> -			spin_lock(&ailp->ail_lock);
> -			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_LOG_IO_ERROR);
> +			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
>  			xfs_buf_item_relse(bp);
>  			ASSERT(bp->b_log_item == NULL);
>  		}
> @@ -1205,22 +1203,19 @@ xfs_buf_iodone(
>  	struct xfs_buf		*bp,
>  	struct xfs_log_item	*lip)
>  {
> -	struct xfs_ail		*ailp = lip->li_ailp;
> -
>  	ASSERT(BUF_ITEM(lip)->bli_buf == bp);
>  
>  	xfs_buf_rele(bp);
>  
>  	/*
> -	 * If we are forcibly shutting down, this may well be
> -	 * off the AIL already. That's because we simulate the
> -	 * log-committed callbacks to unpin these buffers. Or we may never
> -	 * have put this item on AIL because of the transaction was
> -	 * aborted forcibly. xfs_trans_ail_delete() takes care of these.
> +	 * If we are forcibly shutting down, this may well be off the AIL
> +	 * already. That's because we simulate the log-committed callbacks to
> +	 * unpin these buffers. Or we may never have put this item on AIL
> +	 * because of the transaction was aborted forcibly.
> +	 * xfs_trans_ail_delete() takes care of these.
>  	 *
>  	 * Either way, AIL is useless if we're forcing a shutdown.
>  	 */
> -	spin_lock(&ailp->ail_lock);
> -	xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
> +	xfs_trans_ail_delete(lip, SHUTDOWN_CORRUPT_INCORE);
>  	xfs_buf_item_free(BUF_ITEM(lip));
>  }
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index ffe607733c50..5fb65f43b980 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1021,6 +1021,7 @@ xfs_qm_dqflush_done(
>  	struct xfs_dq_logitem	*qip = (struct xfs_dq_logitem *)lip;
>  	struct xfs_dquot	*dqp = qip->qli_dquot;
>  	struct xfs_ail		*ailp = lip->li_ailp;
> +	xfs_lsn_t		tail_lsn;
>  
>  	/*
>  	 * We only want to pull the item from the AIL if its
> @@ -1034,10 +1035,11 @@ xfs_qm_dqflush_done(
>  	    ((lip->li_lsn == qip->qli_flush_lsn) ||
>  	     test_bit(XFS_LI_FAILED, &lip->li_flags))) {
>  
> -		/* xfs_trans_ail_delete() drops the AIL lock. */
>  		spin_lock(&ailp->ail_lock);
>  		if (lip->li_lsn == qip->qli_flush_lsn) {
> -			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
> +			/* xfs_ail_update_finish() drops the AIL lock */
> +			tail_lsn = xfs_ail_delete_one(ailp, lip);
> +			xfs_ail_update_finish(ailp, tail_lsn);
>  		} else {
>  			/*
>  			 * Clear the failed state since we are about to drop the
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 2574d01e4a83..cfba691664c7 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -864,13 +864,14 @@ xfs_ail_delete_one(
>   */
>  void
>  xfs_trans_ail_delete(
> -	struct xfs_ail		*ailp,
>  	struct xfs_log_item	*lip,
>  	int			shutdown_type)
>  {
> +	struct xfs_ail		*ailp = lip->li_ailp;
>  	struct xfs_mount	*mp = ailp->ail_mount;
>  	xfs_lsn_t		tail_lsn;
>  
> +	spin_lock(&ailp->ail_lock);
>  	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>  		spin_unlock(&ailp->ail_lock);
>  		if (!XFS_FORCED_SHUTDOWN(mp)) {
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 35655eac01a6..e4362fb8d483 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -94,8 +94,7 @@ xfs_trans_ail_update(
>  xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
>  void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
>  			__releases(ailp->ail_lock);
> -void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
> -		int shutdown_type);
> +void xfs_trans_ail_delete(struct xfs_log_item *lip, int shutdown_type);
>  
>  static inline void
>  xfs_trans_ail_remove(
> @@ -103,13 +102,16 @@ xfs_trans_ail_remove(
>  	int			shutdown_type)
>  {
>  	struct xfs_ail		*ailp = lip->li_ailp;
> +	xfs_lsn_t		tail_lsn;
>  
>  	spin_lock(&ailp->ail_lock);
> -	/* xfs_trans_ail_delete() drops the AIL lock */
> -	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags))
> -		xfs_trans_ail_delete(ailp, lip, shutdown_type);
> -	else
> +	/* xfs_ail_update_finish() drops the AIL lock */
> +	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
> +		tail_lsn = xfs_ail_delete_one(ailp, lip);
> +		xfs_ail_update_finish(ailp, tail_lsn);
> +	} else {
>  		spin_unlock(&ailp->ail_lock);
> +	}
>  }
>  
>  void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
> -- 
> 2.21.1
> 
