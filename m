Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7905FC11D3D
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 387FB246A0
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 20:49:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LUtezC9a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbgB0UtF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 15:49:05 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40636 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgB0UtF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 15:49:05 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RKmgJZ022924;
        Thu, 27 Feb 2020 20:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=L7MHeIQxWh8pa0en1KGoCFHbTge7lUoe8Zl70qOKI3g=;
 b=LUtezC9a0NMStNOnmZ0H4msi8pAiXX1+RGlje5zoOjANyIZmoabCrfgJyxYw9mptNRm5
 assBuBsWZQWhNbbRPKLZMrf1txWPq12qdpUbwwuCjbd/qOb4Q708/jmdJdk6l5VH2BqT
 +g87QUN8bAHZDA31H1rb0UBpFayL4RzTbKvQqiYedeGLLGKXiH++yzBT40vZloTKC0Wo
 5HJmBMfLGUvVCDdEtUKzn0qh4rFOHZJ1y6DHxJbaC90H3lWQ0jJ/h5ST9wivUstGHi27
 Zc53i3bkCXjKkHdxGqhu9cw9AoZNyBG4FVMYus+WVKp7YYp0i3G3aMeQ+R/CQtIAP5NN Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ydct3djhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 20:49:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RKmKkJ071865;
        Thu, 27 Feb 2020 20:49:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ydcsapmfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 20:49:01 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01RKn00Z013008;
        Thu, 27 Feb 2020 20:49:00 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 12:49:00 -0800
Subject: Re: [RFC v5 PATCH 2/9] xfs: introduce ->tr_relog transaction
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-3-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <547972f5-de18-3fe3-f31e-0fcf2fc393fd@oracle.com>
Date:   Thu, 27 Feb 2020 13:49:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200227134321.7238-3-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/27/20 6:43 AM, Brian Foster wrote:
> Create a transaction reservation specifically for relog
> transactions. For now it only supports the quotaoff intent, so use
> the associated reservation.
> 

Alrighty, looks ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/libxfs/xfs_trans_resv.c | 15 +++++++++++++++
>   fs/xfs/libxfs/xfs_trans_resv.h |  1 +
>   2 files changed, 16 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 7a9c04920505..1f5c9e6e1afc 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -832,6 +832,17 @@ xfs_calc_sb_reservation(
>   	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
>   }
>   
> +/*
> + * Internal relog transaction.
> + *   quotaoff intent
> + */
> +STATIC uint
> +xfs_calc_relog_reservation(
> +	struct xfs_mount	*mp)
> +{
> +	return xfs_calc_qm_quotaoff_reservation(mp);
> +}
> +
>   void
>   xfs_trans_resv_calc(
>   	struct xfs_mount	*mp,
> @@ -946,4 +957,8 @@ xfs_trans_resv_calc(
>   	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
>   	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
>   	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
> +
> +	resp->tr_relog.tr_logres = xfs_calc_relog_reservation(mp);
> +	resp->tr_relog.tr_logcount = XFS_DEFAULT_PERM_LOG_COUNT;
> +	resp->tr_relog.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
>   }
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> index 7241ab28cf84..b723979cad09 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.h
> +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> @@ -50,6 +50,7 @@ struct xfs_trans_resv {
>   	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
>   	struct xfs_trans_res	tr_sb;		/* modify superblock */
>   	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
> +	struct xfs_trans_res	tr_relog;	/* internal relog transaction */
>   };
>   
>   /* shorthand way of accessing reservation structure */
> 
