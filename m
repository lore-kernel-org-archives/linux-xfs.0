Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD85C43463
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 20:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A627620838
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 20:51:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aVa0JkqO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgIQUvP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 16:51:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:32804 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgIQUvP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 16:51:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HIEvXE036041;
        Thu, 17 Sep 2020 18:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=AnR8+X73CwJa8CPFcNUOHFHBKQudS1+AEj7xF7L6GuQ=;
 b=aVa0JkqOoie4+oZuBgMTsGf3Ln5AE6hkRjmW2XTQrtiysjLegLXi6gkV/nw6E1hOhYRH
 iXpXea39JoFL7EpMnIbVYgdCIsAXKRMcTgDmqPFxoqC4i7tqdrx6ix9tb1XOJR0GztgA
 NRlwz+WqywccCIp4UkYXJQFfEKPT0kvPx84o8hWLBYifr/j5LCWn2A1nukdUUZMDzAEE
 saVOrwp9UoYhRv012iQ19W/eNQRtFZgJZ8NLgD8zBw8OEz9fNn5gUL5lOCYbe+Kqqc1+
 neWxAzW8r+WvZPfT+BajuT14ZjXpyCAJbzCsDv47tIsYuq/0hpkC6jgM6Sfte70tpE8o BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33gp9mjxnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 18:18:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HIAoti132951;
        Thu, 17 Sep 2020 18:18:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33h8948jnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 18:18:39 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08HIIcG7029873;
        Thu, 17 Sep 2020 18:18:38 GMT
Received: from localhost (/10.159.138.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 18:18:38 +0000
Date:   Thu, 17 Sep 2020 11:18:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2 4/7] xfs: do the assert for all the log done items in
 xfs_trans_cancel
Message-ID: <20200917181837.GK7955@magnolia>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
 <1600342728-21149-5-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600342728-21149-5-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=10 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=10 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170136
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 07:38:45PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> We should do the assert for all the log intent-done items if they appear
> here. This patch detect intent-done items by the fact that their item ops
> don't have iop_unpin and iop_push methods.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Seems ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index ca18a040336a..0d5d5a53fa5a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -925,6 +925,13 @@ xfs_trans_commit(
>  	return __xfs_trans_commit(tp, false);
>  }
>  
> +/* Is this a log intent-done item? */
> +static inline bool xlog_item_is_intent_done(struct xfs_log_item *lip)
> +{
> +	return lip->li_ops->iop_unpin == NULL &&
> +	       lip->li_ops->iop_push == NULL;
> +}
> +
>  /*
>   * Unlock all of the transaction's items and free the transaction.
>   * The transaction must not have modified any of its items, because
> @@ -959,7 +966,7 @@ xfs_trans_cancel(
>  		struct xfs_log_item *lip;
>  
>  		list_for_each_entry(lip, &tp->t_items, li_trans)
> -			ASSERT(!(lip->li_type == XFS_LI_EFD));
> +			ASSERT(!xlog_item_is_intent_done(lip));
>  	}
>  #endif
>  	xfs_trans_unreserve_and_mod_sb(tp);
> -- 
> 2.20.0
> 
