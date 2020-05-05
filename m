Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79405C47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 23:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C3E2206FA
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 23:20:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bL1TSwGd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgEEXUN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 19:20:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44886 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgEEXUN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 19:20:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045NHpXN137310;
        Tue, 5 May 2020 23:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lDzd8+fislGA4/v+nEvq/6nylr6vTRATmFnDKdwuRPM=;
 b=bL1TSwGdNhmbD4BDv8t+htW2QkAzwsnRhpFKX3gw3DU2aJTpYWlFJqi0QCfnIYdfphcE
 4FkcsUWW1Vm8MdCIhLj6avj11yYjpUPXHEQQZQNO6+lfVx1xzV4GohVmizB8WLcIqgUC
 ZZTn6XjKWdC2i7Or6YK2awmSkWD1O48PvZI+v12MfBEWkFtFfRds6RwTGLJw7C9ovLmm
 grj263EkltjQqXieTtd6hjvKa/P8yrK/9n/NVknY2Jdjn00dNCC+Q5ttU/dZQI69nGZB
 EcxvBBhjvZmSvkS4njB7q3byy0pkEkXo7YAweSRZoKgboXFr2IynyHxMkTOJnb2VVQ3a zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30s1gn7bcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 23:20:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045NGj8S172250;
        Tue, 5 May 2020 23:20:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30sjdu2e3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 23:20:10 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 045NK8Mc022515;
        Tue, 5 May 2020 23:20:08 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 16:20:08 -0700
Subject: Re: [PATCH v4 12/17] xfs: drop unused shutdown parameter from
 xfs_trans_ail_remove()
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200504141154.55887-1-bfoster@redhat.com>
 <20200504141154.55887-13-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <ce3dba54-7c4d-ec8a-4853-ce895a5499e0@oracle.com>
Date:   Tue, 5 May 2020 16:20:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504141154.55887-13-bfoster@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 7:11 AM, Brian Foster wrote:
> The shutdown parameter of xfs_trans_ail_remove() is no longer used.
> The remaining callers use it for items that legitimately might not
> be in the AIL or from contexts where AIL state has already been
> checked. Remove the unnecessary parameter and fix up the callers.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Looks ok to me:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_buf_item.c   | 2 +-
>   fs/xfs/xfs_dquot.c      | 2 +-
>   fs/xfs/xfs_dquot_item.c | 2 +-
>   fs/xfs/xfs_inode_item.c | 6 +-----
>   fs/xfs/xfs_trans_priv.h | 3 +--
>   5 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 06e306b49283..47c547aca1f1 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -558,7 +558,7 @@ xfs_buf_item_put(
>   	 * state.
>   	 */
>   	if (aborted)
> -		xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_trans_ail_remove(lip);
>   	xfs_buf_item_relse(bip->bli_buf);
>   	return true;
>   }
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 5fb65f43b980..497a9dbef1c9 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1162,7 +1162,7 @@ xfs_qm_dqflush(
>   
>   out_abort:
>   	dqp->dq_flags &= ~XFS_DQ_DIRTY;
> -	xfs_trans_ail_remove(lip, SHUTDOWN_CORRUPT_INCORE);
> +	xfs_trans_ail_remove(lip);
>   	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>   out_unlock:
>   	xfs_dqfunlock(dqp);
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 5a7808299a32..8bd46810d5db 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -343,7 +343,7 @@ xfs_qm_qoff_logitem_relse(
>   	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
>   	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
>   	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
> -	xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
> +	xfs_trans_ail_remove(lip);
>   	kmem_free(lip->li_lv_shadow);
>   	kmem_free(qoff);
>   }
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 1d4d256a2e96..0e449d0a3d5c 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -768,11 +768,7 @@ xfs_iflush_abort(
>   	xfs_inode_log_item_t	*iip = ip->i_itemp;
>   
>   	if (iip) {
> -		if (test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags)) {
> -			xfs_trans_ail_remove(&iip->ili_item,
> -					     stale ? SHUTDOWN_LOG_IO_ERROR :
> -						     SHUTDOWN_CORRUPT_INCORE);
> -		}
> +		xfs_trans_ail_remove(&iip->ili_item);
>   		iip->ili_logged = 0;
>   		/*
>   		 * Clear the ili_last_fields bits now that we know that the
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index e4362fb8d483..ab0a82e90825 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -98,8 +98,7 @@ void xfs_trans_ail_delete(struct xfs_log_item *lip, int shutdown_type);
>   
>   static inline void
>   xfs_trans_ail_remove(
> -	struct xfs_log_item	*lip,
> -	int			shutdown_type)
> +	struct xfs_log_item	*lip)
>   {
>   	struct xfs_ail		*ailp = lip->li_ailp;
>   	xfs_lsn_t		tail_lsn;
> 
