Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CAFC1975A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 04:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3975206F6
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 04:54:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z5zZveuv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgCYEyl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 00:54:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41938 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgCYEyl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 00:54:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P4sGct026238;
        Wed, 25 Mar 2020 04:54:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5geF+CxaqCvj988STd/cnK7pYeV0mvppj2DCmqtEAZE=;
 b=Z5zZveuvVuXtoqA1RSOqYGUDekNCegTfcRPTBs9274ueTXHQsBB0TPTbrLxbQTxMqoHc
 puSTfwhZtTNLZnLljVFaPgu/ruDEny+iSGLnWPkhA3Iamz9dZiC6RiTM5lAz6WBzW1Tc
 3tumHVlaYCUKZAbPFAxMNtRpJVNcgzABuIT1wjmJEUP7c0OUVtfm25S8p8ylEbUC3PSQ
 cgu2/B8Slc/jORQ+ty104o+PxpgqnHzU0p8sI1UN/btcgh6KYaT3r2Td0M+iZ0ytODFk
 s09jO8dHCkiZqtVlFM0hrw31Qfoo5d83JsLhtAc1gOdMecfWyezEz5pXrbs6O/6JS6e5 Yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yx8ac4qxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 04:54:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P4sbbp144820;
        Wed, 25 Mar 2020 04:54:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yymbvf6k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 04:54:37 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02P4sbV2017281;
        Wed, 25 Mar 2020 04:54:37 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 21:54:36 -0700
Subject: Re: [PATCH 6/8] xfs: factor common AIL item deletion code
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-7-david@fromorbit.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <b2e17929-b4e5-e585-feeb-5c5099e419a8@oracle.com>
Date:   Tue, 24 Mar 2020 21:54:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200325014205.11843-7-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/24/20 6:42 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Factor the common AIL deletion code that does all the wakeups into a
> helper so we only have one copy of this somewhat tricky code to
> interface with all the wakeups necessary when the LSN of the log
> tail changes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Ok, the hoisted code looks equivalent
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_inode_item.c | 12 +----------
>   fs/xfs/xfs_trans_ail.c  | 48 ++++++++++++++++++++++-------------------
>   fs/xfs/xfs_trans_priv.h |  4 +++-
>   3 files changed, 30 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 4a3d13d4a0228..bd8c368098707 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -742,17 +742,7 @@ xfs_iflush_done(
>   				xfs_clear_li_failed(blip);
>   			}
>   		}
> -
> -		if (mlip_changed) {
> -			if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
> -				xlog_assign_tail_lsn_locked(ailp->ail_mount);
> -			if (list_empty(&ailp->ail_head))
> -				wake_up_all(&ailp->ail_empty);
> -		}
> -		spin_unlock(&ailp->ail_lock);
> -
> -		if (mlip_changed)
> -			xfs_log_space_wake(ailp->ail_mount);
> +		xfs_ail_update_finish(ailp, mlip_changed);
>   	}
>   
>   	/*
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 2ef0dfbfb303d..26d2e7928121c 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -681,6 +681,27 @@ xfs_ail_push_all_sync(
>   	finish_wait(&ailp->ail_empty, &wait);
>   }
>   
> +void
> +xfs_ail_update_finish(
> +	struct xfs_ail		*ailp,
> +	bool			do_tail_update) __releases(ailp->ail_lock)
> +{
> +	struct xfs_mount	*mp = ailp->ail_mount;
> +
> +	if (!do_tail_update) {
> +		spin_unlock(&ailp->ail_lock);
> +		return;
> +	}
> +
> +	if (!XFS_FORCED_SHUTDOWN(mp))
> +		xlog_assign_tail_lsn_locked(mp);
> +
> +	if (list_empty(&ailp->ail_head))
> +		wake_up_all(&ailp->ail_empty);
> +	spin_unlock(&ailp->ail_lock);
> +	xfs_log_space_wake(mp);
> +}
> +
>   /*
>    * xfs_trans_ail_update - bulk AIL insertion operation.
>    *
> @@ -740,15 +761,7 @@ xfs_trans_ail_update_bulk(
>   	if (!list_empty(&tmp))
>   		xfs_ail_splice(ailp, cur, &tmp, lsn);
>   
> -	if (mlip_changed) {
> -		if (!XFS_FORCED_SHUTDOWN(ailp->ail_mount))
> -			xlog_assign_tail_lsn_locked(ailp->ail_mount);
> -		spin_unlock(&ailp->ail_lock);
> -
> -		xfs_log_space_wake(ailp->ail_mount);
> -	} else {
> -		spin_unlock(&ailp->ail_lock);
> -	}
> +	xfs_ail_update_finish(ailp, mlip_changed);
>   }
>   
>   bool
> @@ -792,10 +805,10 @@ void
>   xfs_trans_ail_delete(
>   	struct xfs_ail		*ailp,
>   	struct xfs_log_item	*lip,
> -	int			shutdown_type) __releases(ailp->ail_lock)
> +	int			shutdown_type)
>   {
>   	struct xfs_mount	*mp = ailp->ail_mount;
> -	bool			mlip_changed;
> +	bool			need_update;
>   
>   	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>   		spin_unlock(&ailp->ail_lock);
> @@ -808,17 +821,8 @@ xfs_trans_ail_delete(
>   		return;
>   	}
>   
> -	mlip_changed = xfs_ail_delete_one(ailp, lip);
> -	if (mlip_changed) {
> -		if (!XFS_FORCED_SHUTDOWN(mp))
> -			xlog_assign_tail_lsn_locked(mp);
> -		if (list_empty(&ailp->ail_head))
> -			wake_up_all(&ailp->ail_empty);
> -	}
> -
> -	spin_unlock(&ailp->ail_lock);
> -	if (mlip_changed)
> -		xfs_log_space_wake(ailp->ail_mount);
> +	need_update = xfs_ail_delete_one(ailp, lip);
> +	xfs_ail_update_finish(ailp, need_update);
>   }
>   
>   int
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 2e073c1c4614f..64ffa746730e4 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -92,8 +92,10 @@ xfs_trans_ail_update(
>   }
>   
>   bool xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *lip);
> +void xfs_ail_update_finish(struct xfs_ail *ailp, bool do_tail_update)
> +			__releases(ailp->ail_lock);
>   void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip,
> -		int shutdown_type) __releases(ailp->ail_lock);
> +		int shutdown_type);
>   
>   static inline void
>   xfs_trans_ail_remove(
> 
