Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F029C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 195B9206C0
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:32:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eJjnwS6q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732721AbgCPVcb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:32:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49330 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732685AbgCPVcb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 17:32:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GL96Ee051349;
        Mon, 16 Mar 2020 21:32:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0/eki/2kDnQr579RXH8SdYNMnsugoAokolfWOr7Bpcg=;
 b=eJjnwS6q6fJewuUV2fbO0P4kXnKLGYqHK6ROCI5I8Z6xnYFs37yEaaRDAEYUXzk5bzC6
 2zsW1jWwXGen+hH+JyEvBQFrMrHX951ceYbBQ77l+PAa6CVrkN1JR0SOdaZNWtx9fQr4
 F3sYJQsKLKOLJPqjhCtzlH+C+FoaTD9RNbm7rm88s4Y7OF4DWCP1Xo0OsE1iRaTk3VbV
 6PL7/o7e3yvXBbSD5zyLjTlVLxZQmRQElhFRPF30gQS5WRfVNiyAjb2O4phZp0aJce9J
 Thc8W8yVJkvuCteCotr92JIde0oi0XVcSEt9J9le22Cf85IMkoBxTAGCiaf7OHjsU4as QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yrq7ksd3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:32:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GLKdVl050527;
        Mon, 16 Mar 2020 21:32:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ys8ywms2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:32:25 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02GLWOuY013204;
        Mon, 16 Mar 2020 21:32:24 GMT
Received: from localhost (/10.159.132.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 14:32:24 -0700
Date:   Mon, 16 Mar 2020 14:32:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix unmount hang and memory leak on shutdown
 during quotaoff
Message-ID: <20200316213223.GU256767@magnolia>
References: <20200316170032.19552-1-bfoster@redhat.com>
 <20200316170032.19552-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316170032.19552-3-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=2
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003160088
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 01:00:32PM -0400, Brian Foster wrote:
> AIL removal of the quotaoff start intent and free of both quotaoff
> intents is currently limited to the ->iop_committed() handler of the
> end intent. This executes when the end intent is committed to the
> on-disk log and marks the completion of the operation. The problem
> with this is it assumes the success of the operation. If a shutdown
> or other error occurs during the quotaoff, it's possible for the
> quotaoff task to exit without removing the start intent from the
> AIL. This results in an unmount hang as the AIL cannot be emptied.
> Further, no other codepath frees the intents and so this is also a
> memory leak vector.

And I'm guessing that you'd rather we taught the quota items to be
self-releasing under error rather than making the quotaoff code be smart
enough to free the quotaoff-start item?

> First, update the high level quotaoff error path to directly remove
> and free the quotaoff start intent if it still exists in the AIL at
> the time of the error. Next, update both of the start and end
> quotaoff intents with an ->iop_release() callback to properly handle
> transaction abort.

I wonder, does this mean that we can drop the if (->io_release) check in
xfs_trans_free_items?  ISTR we were wondering at one point if there ever
was a real use case for items that don't have a release function.

> This means that If the quotaoff start transaction aborts, it frees
> the start intent in the transaction commit path. If the filesystem
> shuts down before the end transaction allocates, the quotaoff
> sequence removes and frees the start intent. If the end transaction
> aborts, it removes the start intent and frees both. This ensures
> that a shutdown does not result in a hung unmount and that memory is
> not leaked regardless of when a quotaoff error occurs.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

FWIW, the code looks reasonable.

--D

> ---
>  fs/xfs/xfs_dquot_item.c  | 15 +++++++++++++++
>  fs/xfs/xfs_qm_syscalls.c | 13 +++++++------
>  2 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 2b816e9b4465..cf65e2e43c6e 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -315,17 +315,32 @@ xfs_qm_qoffend_logitem_committed(
>  	return (xfs_lsn_t)-1;
>  }
>  
> +STATIC void
> +xfs_qm_qoff_logitem_release(
> +	struct xfs_log_item	*lip)
> +{
> +	struct xfs_qoff_logitem	*qoff = QOFF_ITEM(lip);
> +
> +	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
> +		if (qoff->qql_start_lip)
> +			xfs_qm_qoff_logitem_relse(qoff->qql_start_lip);
> +		xfs_qm_qoff_logitem_relse(qoff);
> +	}
> +}
> +
>  static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
>  	.iop_size	= xfs_qm_qoff_logitem_size,
>  	.iop_format	= xfs_qm_qoff_logitem_format,
>  	.iop_committed	= xfs_qm_qoffend_logitem_committed,
>  	.iop_push	= xfs_qm_qoff_logitem_push,
> +	.iop_release	= xfs_qm_qoff_logitem_release,
>  };
>  
>  static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
>  	.iop_size	= xfs_qm_qoff_logitem_size,
>  	.iop_format	= xfs_qm_qoff_logitem_format,
>  	.iop_push	= xfs_qm_qoff_logitem_push,
> +	.iop_release	= xfs_qm_qoff_logitem_release,
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 1ea82764bf89..5d5ac65aa1cc 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -29,8 +29,6 @@ xfs_qm_log_quotaoff(
>  	int			error;
>  	struct xfs_qoff_logitem	*qoffi;
>  
> -	*qoffstartp = NULL;
> -
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
>  	if (error)
>  		goto out;
> @@ -62,7 +60,7 @@ xfs_qm_log_quotaoff(
>  STATIC int
>  xfs_qm_log_quotaoff_end(
>  	struct xfs_mount	*mp,
> -	struct xfs_qoff_logitem	*startqoff,
> +	struct xfs_qoff_logitem	**startqoff,
>  	uint			flags)
>  {
>  	struct xfs_trans	*tp;
> @@ -73,9 +71,10 @@ xfs_qm_log_quotaoff_end(
>  	if (error)
>  		return error;
>  
> -	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
> +	qoffi = xfs_trans_get_qoff_item(tp, *startqoff,
>  					flags & XFS_ALL_QUOTA_ACCT);
>  	xfs_trans_log_quotaoff_item(tp, qoffi);
> +	*startqoff = NULL;
>  
>  	/*
>  	 * We have to make sure that the transaction is secure on disk before we
> @@ -103,7 +102,7 @@ xfs_qm_scall_quotaoff(
>  	uint			dqtype;
>  	int			error;
>  	uint			inactivate_flags;
> -	struct xfs_qoff_logitem	*qoffstart;
> +	struct xfs_qoff_logitem	*qoffstart = NULL;
>  
>  	/*
>  	 * No file system can have quotas enabled on disk but not in core.
> @@ -228,7 +227,7 @@ xfs_qm_scall_quotaoff(
>  	 * So, we have QUOTAOFF start and end logitems; the start
>  	 * logitem won't get overwritten until the end logitem appears...
>  	 */
> -	error = xfs_qm_log_quotaoff_end(mp, qoffstart, flags);
> +	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
>  	if (error) {
>  		/* We're screwed now. Shutdown is the only option. */
>  		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> @@ -261,6 +260,8 @@ xfs_qm_scall_quotaoff(
>  	}
>  
>  out_unlock:
> +	if (error && qoffstart)
> +		xfs_qm_qoff_logitem_relse(qoffstart);
>  	mutex_unlock(&q->qi_quotaofflock);
>  	return error;
>  }
> -- 
> 2.21.1
> 
