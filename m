Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E91AC3F2C0
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 21:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 686FF24650
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 21:20:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XtNULk6Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgB0VUt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 16:20:49 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54018 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgB0VUt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 16:20:49 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RLIkVh026788;
        Thu, 27 Feb 2020 21:20:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=67QJDEwV2NdXoCOnJd/DH4v+Ba0Hv2+hA2B5vTF/Ygc=;
 b=XtNULk6Zhsar4+YZiIsDnZ5PB357fJacff3b6dAufBwz8+OEjbCajBv5iALrnhV6EjzI
 BqnMA9qzsJKAGcBirLTLqPVMjzpzQ0/X9RNFJHxSD4EHD1P+yUo3kaq3HaUJuVrPji3H
 W7/3yJu2ipfgeEDe0fl5GT9Z/HjilvbB88TGQXN7f93HC5Ir05mUsX7ZvpDiGGb2izSI
 8EUxZICdN1B3h/otlxhGHPNXRdw4td0jkq7n8UTc1h4G4MeDM04EcTgm+zJz83h4nlaa
 EjSVdRcp4sKng4191jfIfS+0ksrtgUGCUURQcDQNh3jBNuxTmCM/OnXx+31mPLXp70+Q HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ydct3dq6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 21:20:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RLIH7u052016;
        Thu, 27 Feb 2020 21:18:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ydcs6b14r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 21:18:40 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01RLIdEo001107;
        Thu, 27 Feb 2020 21:18:40 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 13:18:39 -0800
Subject: Re: [RFC v5 PATCH 4/9] xfs: automatic relogging item management
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-5-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <dc23e9c3-39aa-b61d-31f6-656ead78a030@oracle.com>
Date:   Thu, 27 Feb 2020 14:18:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200227134321.7238-5-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=2 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=2 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/27/20 6:43 AM, Brian Foster wrote:
> As implemented by the previous patch, relogging can be enabled on
> any item via a relog enabled transaction (which holds a reference to
> an active relog ticket). Add a couple log item flags to track relog
> state of an arbitrary log item. The item holds a reference to the
> global relog ticket when relogging is enabled and releases the
> reference when relogging is disabled.
> 
Alrighty, I think it's ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/xfs_trace.h      |  2 ++
>   fs/xfs/xfs_trans.c      | 36 ++++++++++++++++++++++++++++++++++++
>   fs/xfs/xfs_trans.h      |  6 +++++-
>   fs/xfs/xfs_trans_priv.h |  2 ++
>   4 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a86be7f807ee..a066617ec54d 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1063,6 +1063,8 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
>   DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
>   DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
>   DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
> +DEFINE_LOG_ITEM_EVENT(xfs_relog_item);
> +DEFINE_LOG_ITEM_EVENT(xfs_relog_item_cancel);
>   
>   DECLARE_EVENT_CLASS(xfs_ail_class,
>   	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn),
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 8ac05ed8deda..f7f2411ead4e 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -778,6 +778,41 @@ xfs_trans_del_item(
>   	list_del_init(&lip->li_trans);
>   }
>   
> +void
> +xfs_trans_relog_item(
> +	struct xfs_log_item	*lip)
> +{
> +	if (!test_and_set_bit(XFS_LI_RELOG, &lip->li_flags)) {
> +		xfs_trans_ail_relog_get(lip->li_mountp);
> +		trace_xfs_relog_item(lip);
> +	}
> +}
> +
> +void
> +xfs_trans_relog_item_cancel(
> +	struct xfs_log_item	*lip,
> +	bool			drain) /* wait for relogging to cease */
> +{
> +	struct xfs_mount	*mp = lip->li_mountp;
> +
> +	if (!test_and_clear_bit(XFS_LI_RELOG, &lip->li_flags))
> +		return;
> +	xfs_trans_ail_relog_put(lip->li_mountp);
> +	trace_xfs_relog_item_cancel(lip);
> +
> +	if (!drain)
> +		return;
> +
> +	/*
> +	 * Some operations might require relog activity to cease before they can
> +	 * proceed. For example, an operation must wait before including a
> +	 * non-lockable log item (i.e. intent) in another transaction.
> +	 */
> +	while (wait_on_bit_timeout(&lip->li_flags, XFS_LI_RELOGGED,
> +				   TASK_UNINTERRUPTIBLE, HZ))
> +		xfs_log_force(mp, XFS_LOG_SYNC);
> +}
> +
>   /* Detach and unlock all of the items in a transaction */
>   static void
>   xfs_trans_free_items(
> @@ -863,6 +898,7 @@ xfs_trans_committed_bulk(
>   
>   		if (aborted)
>   			set_bit(XFS_LI_ABORTED, &lip->li_flags);
> +		clear_and_wake_up_bit(XFS_LI_RELOGGED, &lip->li_flags);
>   
>   		if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
>   			lip->li_ops->iop_release(lip);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index a032989943bd..fc4c25b6eee4 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -59,12 +59,16 @@ struct xfs_log_item {
>   #define	XFS_LI_ABORTED	1
>   #define	XFS_LI_FAILED	2
>   #define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
> +#define	XFS_LI_RELOG	4	/* automatically relog item */
> +#define	XFS_LI_RELOGGED	5	/* item relogged (not committed) */
>   
>   #define XFS_LI_FLAGS \
>   	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
>   	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
>   	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
> -	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
> +	{ (1 << XFS_LI_DIRTY),		"DIRTY" }, \
> +	{ (1 << XFS_LI_RELOG),		"RELOG" }, \
> +	{ (1 << XFS_LI_RELOGGED),	"RELOGGED" }
>   
>   struct xfs_item_ops {
>   	unsigned flags;
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 839df6559b9f..d1edec1cb8ad 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -16,6 +16,8 @@ struct xfs_log_vec;
>   void	xfs_trans_init(struct xfs_mount *);
>   void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
>   void	xfs_trans_del_item(struct xfs_log_item *);
> +void	xfs_trans_relog_item(struct xfs_log_item *);
> +void	xfs_trans_relog_item_cancel(struct xfs_log_item *, bool);
>   void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
>   
>   void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
> 
