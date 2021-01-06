Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AACC433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 22:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFB092332A
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 22:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbhAFWvf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 17:51:35 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53624 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbhAFWve (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 17:51:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106MmuaC121937;
        Wed, 6 Jan 2021 22:50:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=gf7VS48aJmEik6cT+Yd8j2tATXOZ5AwD2YjQaWed4P8=;
 b=eFG0MYnSf6yj3HSM+ecxrYBb26KHohJOdvBIYecQFx3xepm+AatGXrPm7sfISMTVx/pH
 np2sRKzyzu0rabTh3bS+7MI+An2MuhEaBWcETT6ummQuVIyEVbCDae6yKxyzlqTJqxSE
 1pDGhjT2dAJn6ZJNDRGaPbPlCzNbwHq5edacFli4GQ/Gfd+7/bJNA9UKyFPZlxsG+EdM
 S7Vo7otawiLgh0gN/MxHqSh5Qjm85au2FninJEIApX2U4aqYzthcSR0wMH9xZb+hoW4e
 QKuxQeLcpb3y0KMltBF47EwRhZlwD+Whr7OY98445mv3aN+FzYOIk01KdeeD1C4B41ef Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35wepma6rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 22:50:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106MfWcY051429;
        Wed, 6 Jan 2021 22:50:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35w3g1pgf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 22:50:51 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 106Mooms029449;
        Wed, 6 Jan 2021 22:50:50 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 22:50:50 +0000
Subject: Re: [PATCH 3/9] xfs: separate log cleaning from log quiesce
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-4-bfoster@redhat.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <f2f524bc-3657-aaea-8d97-eaf234384ac3@oracle.com>
Date:   Wed, 6 Jan 2021 15:50:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210106174127.805660-4-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9856 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060129
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/6/21 10:41 AM, Brian Foster wrote:
> Log quiesce is currently associated with cleaning the log, which is
> accomplished by writing an unmount record as the last step of the
> quiesce sequence. The quiesce codepath is a bit convoluted in this
> regard due to how it is reused from various contexts. In preparation
> to create separate log cleaning and log covering interfaces, lift
> the write of the unmount record into a new cleaning helper and call
> that wherever xfs_log_quiesce() is currently invoked. No functional
> changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
Looks ok to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_log.c   | 8 +++++++-
>   fs/xfs/xfs_log.h   | 1 +
>   fs/xfs/xfs_super.c | 2 +-
>   3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4137ed007111..1b3227a033ad 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -957,7 +957,13 @@ xfs_log_quiesce(
>   	xfs_wait_buftarg(mp->m_ddev_targp);
>   	xfs_buf_lock(mp->m_sb_bp);
>   	xfs_buf_unlock(mp->m_sb_bp);
> +}
>   
> +void
> +xfs_log_clean(
> +	struct xfs_mount	*mp)
> +{
> +	xfs_log_quiesce(mp);
>   	xfs_log_unmount_write(mp);
>   }
>   
> @@ -972,7 +978,7 @@ void
>   xfs_log_unmount(
>   	struct xfs_mount	*mp)
>   {
> -	xfs_log_quiesce(mp);
> +	xfs_log_clean(mp);
>   
>   	xfs_trans_ail_destroy(mp);
>   
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 98c913da7587..b0400589f824 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -139,6 +139,7 @@ bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
>   
>   void	xfs_log_work_queue(struct xfs_mount *mp);
>   void	xfs_log_quiesce(struct xfs_mount *mp);
> +void	xfs_log_clean(struct xfs_mount *mp);
>   bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
>   bool	xfs_log_in_recovery(struct xfs_mount *);
>   
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 813be879a5e5..09d956e30fd8 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -897,7 +897,7 @@ xfs_quiesce_attr(
>   	if (error)
>   		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
>   				"Frozen image may not be consistent.");
> -	xfs_log_quiesce(mp);
> +	xfs_log_clean(mp);
>   }
>   
>   /*
> 
