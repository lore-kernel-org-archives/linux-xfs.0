Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489A2C3F2CD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 23:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F98E2469B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 23:49:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gq1X38OM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgB0XtF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 18:49:05 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46912 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728993AbgB0XtF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 18:49:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RNmeiE027989;
        Thu, 27 Feb 2020 23:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5PCJLqxKiNvdWvFDWNcdCBZEWJvic1ULcWwNWeMOKrM=;
 b=Gq1X38OMActuf0j5n50ZRkJLUST+n/FlVoOLv2MVplQjnenkmovkAeYhZvvfHmRxVS5O
 RN1+pvom9pxEAePZPq+NFff24mhROrSwVC6u+8d3AtxLG3A/FxTMwVontT5bfjgXlG9P
 8x5a0ULZXCL2K2oAldZ5pyqc0uT6yjficvabR60IMG+b42IFagI/NeK3ztR89jNyYeSH
 FFZZsch2GpurG2mDp5uE1zJSh82SG1mkC/1AoHpqHbxHWtxus++NYnT0zLWT5zpSj4H9
 6ymultfFWtIVg6zqo5ChvK9IjmRKv0RPVIrhrtucXuMQ8myW+yiC0GHANTcJkgWidkDy yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ydct3e8xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 23:49:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RNmK3e144566;
        Thu, 27 Feb 2020 23:49:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ydcs6nk7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 23:49:02 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01RNn1UK005016;
        Thu, 27 Feb 2020 23:49:01 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 15:49:01 -0800
Subject: Re: [RFC v5 PATCH 9/9] xfs: relog random buffers based on errortag
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-10-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <677810e5-2e4f-66a0-5f20-51c14fabfcc4@oracle.com>
Date:   Thu, 27 Feb 2020 16:48:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200227134321.7238-10-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/27/20 6:43 AM, Brian Foster wrote:
> Since there is currently no specific use case for buffer relogging,
> add some hacky and experimental code to relog random buffers when
> the associated errortag is enabled. Update the relog reservation
> calculation appropriately and use fixed termination logic to help
> ensure that the relog queue doesn't grow indefinitely.
> 
> Note that this patch was useful in causing log reservation deadlocks
> on an fsstress workload if the relog mechanism code is modified to
> acquire its own log reservation rather than rely on the relog
> pre-reservation mechanism. In other words, this helps prove that the
> relog reservation management code effectively avoids log reservation
> deadlocks.
> 

Oh i see, so the last three are sort of an internal test case.  They 
look like they are good sand box tools for testing though.  I guess they 
dont really get RVBs since they dont apply?  Otherwise looks good for 
the purpose they are meant for.  :-)

Allison

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/libxfs/xfs_trans_resv.c |  8 +++++++-
>   fs/xfs/xfs_trans.h             |  4 +++-
>   fs/xfs/xfs_trans_ail.c         | 11 +++++++++++
>   fs/xfs/xfs_trans_buf.c         | 13 +++++++++++++
>   4 files changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index f49b20c9ca33..59a328a0dec6 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -840,7 +840,13 @@ STATIC uint
>   xfs_calc_relog_reservation(
>   	struct xfs_mount	*mp)
>   {
> -	return xfs_calc_qm_quotaoff_reservation(mp);
> +	uint			res;
> +
> +	res = xfs_calc_qm_quotaoff_reservation(mp);
> +#ifdef DEBUG
> +	res = max(res, xfs_calc_buf_res(4, XFS_FSB_TO_B(mp, 1)));
> +#endif
> +	return res;
>   }
>   
>   void
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 81cb42f552d9..1783441f6d03 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -61,6 +61,7 @@ struct xfs_log_item {
>   #define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
>   #define	XFS_LI_RELOG	4	/* automatically relog item */
>   #define	XFS_LI_RELOGGED	5	/* item relogged (not committed) */
> +#define	XFS_LI_RELOG_RAND 6
>   
>   #define XFS_LI_FLAGS \
>   	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
> @@ -68,7 +69,8 @@ struct xfs_log_item {
>   	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
>   	{ (1 << XFS_LI_DIRTY),		"DIRTY" }, \
>   	{ (1 << XFS_LI_RELOG),		"RELOG" }, \
> -	{ (1 << XFS_LI_RELOGGED),	"RELOGGED" }
> +	{ (1 << XFS_LI_RELOGGED),	"RELOGGED" }, \
> +	{ (1 << XFS_LI_RELOG_RAND),	"RELOG_RAND" }
>   
>   struct xfs_item_ops {
>   	unsigned flags;
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 103ab62e61be..9b1d7c8df6d8 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -188,6 +188,17 @@ xfs_ail_relog(
>   			xfs_log_ticket_put(ailp->ail_relog_tic);
>   		spin_unlock(&ailp->ail_lock);
>   
> +		/*
> +		 * Terminate random/debug relogs at a fixed, aggressive rate to
> +		 * avoid building up too much relog activity.
> +		 */
> +		if (test_bit(XFS_LI_RELOG_RAND, &lip->li_flags) &&
> +		    ((prandom_u32() & 1) ||
> +		     (mp->m_flags & XFS_MOUNT_UNMOUNTING))) {
> +			clear_bit(XFS_LI_RELOG_RAND, &lip->li_flags);
> +			xfs_trans_relog_item_cancel(lip, false);
> +		}
> +
>   		/*
>   		 * TODO: Ideally, relog transaction management would be pushed
>   		 * down into the ->iop_push() callbacks rather than playing
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index e17715ac23fc..de7b9a68fe38 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -14,6 +14,8 @@
>   #include "xfs_buf_item.h"
>   #include "xfs_trans_priv.h"
>   #include "xfs_trace.h"
> +#include "xfs_error.h"
> +#include "xfs_errortag.h"
>   
>   /*
>    * Check to see if a buffer matching the given parameters is already
> @@ -527,6 +529,17 @@ xfs_trans_log_buf(
>   
>   	trace_xfs_trans_log_buf(bip);
>   	xfs_buf_item_log(bip, first, last);
> +
> +	/*
> +	 * Relog random buffers so long as the transaction is relog enabled and
> +	 * the buffer wasn't already relogged explicitly.
> +	 */
> +	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_RELOG) &&
> +	    (tp->t_flags & XFS_TRANS_RELOG) &&
> +	    !test_bit(XFS_LI_RELOG, &bip->bli_item.li_flags)) {
> +		if (xfs_trans_relog_buf(tp, bp))
> +			set_bit(XFS_LI_RELOG_RAND, &bip->bli_item.li_flags);
> +	}
>   }
>   
>   
> 
