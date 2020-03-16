Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C858BC18E5B
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D9D7206C0
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 21:27:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IbqH4VEe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732675AbgCPV1n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 17:27:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45460 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732567AbgCPV1m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 17:27:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GL8jew051006;
        Mon, 16 Mar 2020 21:27:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=6R00kHRJBmUPw/cYfM/cRUb8jbJSXHMiB9zeBlW2GCU=;
 b=IbqH4VEeIFcHOnLTNmxg4wCfkPx2dQ7WB6zEqakri+3xOXgNyTlNUJuf1mlEtGNRlggQ
 f2yIen7jTxnKjREWiFYNAis5/oRaly6sQ1Gs9KtS5KQSOF1ghW/ol+nVv07Ni6KywXHn
 LH0OleKIkSBknXmQzFsDCuIdYokNWHbP0Jg3mZ67J9O2B5HwEw/+5dhI3t8jwQdLkVmA
 BI17Rq7yvPrAhcieBgPvI3Gv6jD9KBSpwywWzJZQQHUirOKLV2PB1p7HN8E9KPNdFf/P
 W6cmmRhnfhpRgDttFP/W/DaPIyufHMWFNOUuMYV7PZDstYSOfWwNTsi0i1tSx9k/jrG7 8A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yrq7kschu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:27:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02GLKY8E149631;
        Mon, 16 Mar 2020 21:27:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ys8rd8mek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Mar 2020 21:27:38 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02GLRb6x010378;
        Mon, 16 Mar 2020 21:27:37 GMT
Received: from localhost (/10.159.132.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 14:27:37 -0700
Date:   Mon, 16 Mar 2020 14:27:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: factor out quotaoff intent AIL removal and
 memory free
Message-ID: <20200316212736.GT256767@magnolia>
References: <20200316170032.19552-1-bfoster@redhat.com>
 <20200316170032.19552-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316170032.19552-2-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=2
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

On Mon, Mar 16, 2020 at 01:00:31PM -0400, Brian Foster wrote:
> AIL removal of the quotaoff start intent and free of both intents is
> hardcoded to the ->iop_committed() handler of the end intent. Factor
> out the start intent handling code so it can be used in a future
> patch to properly handle quotaoff errors. Use xfs_trans_ail_remove()
> instead of the _delete() variant to acquire the AIL lock and also
> handle cases where an intent might not reside in the AIL at the
> time of a failure.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks like a straightforward hoist...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_dquot_item.c | 29 ++++++++++++++++++++---------
>  fs/xfs/xfs_dquot_item.h |  1 +
>  2 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index d60647d7197b..2b816e9b4465 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -307,18 +307,10 @@ xfs_qm_qoffend_logitem_committed(
>  {
>  	struct xfs_qoff_logitem	*qfe = QOFF_ITEM(lip);
>  	struct xfs_qoff_logitem	*qfs = qfe->qql_start_lip;
> -	struct xfs_ail		*ailp = qfs->qql_item.li_ailp;
>  
> -	/*
> -	 * Delete the qoff-start logitem from the AIL.
> -	 * xfs_trans_ail_delete() drops the AIL lock.
> -	 */
> -	spin_lock(&ailp->ail_lock);
> -	xfs_trans_ail_delete(ailp, &qfs->qql_item, SHUTDOWN_LOG_IO_ERROR);
> +	xfs_qm_qoff_logitem_relse(qfs);
>  
> -	kmem_free(qfs->qql_item.li_lv_shadow);
>  	kmem_free(lip->li_lv_shadow);
> -	kmem_free(qfs);
>  	kmem_free(qfe);
>  	return (xfs_lsn_t)-1;
>  }
> @@ -336,6 +328,25 @@ static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
>  	.iop_push	= xfs_qm_qoff_logitem_push,
>  };
>  
> +/*
> + * Delete the quotaoff intent from the AIL and free it. On success,
> + * this should only be called for the start item. It can be used for
> + * either on shutdown or abort.
> + */
> +void
> +xfs_qm_qoff_logitem_relse(
> +	struct xfs_qoff_logitem	*qoff)
> +{
> +	struct xfs_log_item	*lip = &qoff->qql_item;
> +
> +	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
> +	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
> +	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
> +	xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
> +	kmem_free(lip->li_lv_shadow);
> +	kmem_free(qoff);
> +}
> +
>  /*
>   * Allocate and initialize an quotaoff item of the correct quota type(s).
>   */
> diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
> index 3bb19e556ade..2b86a43d7ce2 100644
> --- a/fs/xfs/xfs_dquot_item.h
> +++ b/fs/xfs/xfs_dquot_item.h
> @@ -28,6 +28,7 @@ void xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
>  struct xfs_qoff_logitem	*xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
>  		struct xfs_qoff_logitem *start,
>  		uint flags);
> +void xfs_qm_qoff_logitem_relse(struct xfs_qoff_logitem *);
>  struct xfs_qoff_logitem	*xfs_trans_get_qoff_item(struct xfs_trans *tp,
>  		struct xfs_qoff_logitem *startqoff,
>  		uint flags);
> -- 
> 2.21.1
> 
