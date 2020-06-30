Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0807C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 21:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9BF32065D
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 21:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZkmiYpZ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgF3VfI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:35:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58196 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgF3VfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 17:35:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05ULHQ17122221
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:35:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6Txsh+1y5hVBRl4UvmVA+Vx72xN/wS6im2Ox6mSWnJw=;
 b=ZkmiYpZ06BxpevEYlpG/CHbZTKltofnZYrYmg+NhpxhMh3Y/jgDrwW2p+PmETeouaVke
 7j1oRZHw2kC4ntNHvKQEcnqTDhAcAkO1sgYdKRx01OOANnf+duRaDAeR2P+urK1WKHxm
 PRDnuPbZi4jnOJU87Ia8pvCJQhxKAU6Jz3bDbQpWR4as/ZBLBMsN3Rd+Z5t/e/8AoDJ8
 Fx+N4tgPs2GiWBFR1GgY+YJ8aVIKZV1bheTVghncejUTvzII+St5XPNJW6WxNRtVhiGA
 k8zYCXD4DVkKDeo+qSd5tUGb+aFxSwWXBvLgK5Ye6yrvtftoLQWDdF1Nz+cb0IJiWmBD /A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31ywrbn8ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:35:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05ULCdQS195230
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:35:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31y52jeua1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:35:06 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05ULZ5jS015496
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:35:05 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 21:35:04 +0000
Subject: Re: [PATCH 01/18] xfs: clear XFS_DQ_FREEING if we can't lock the
 dquot buffer to flush
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353171640.2864738.7967439700762859129.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <fd21eae2-3d47-7150-8436-b4f5328c1d96@oracle.com>
Date:   Tue, 30 Jun 2020 14:35:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159353171640.2864738.7967439700762859129.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/30/20 8:41 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit 8d3d7e2b35ea, we changed xfs_qm_dqpurge to bail out if we
> can't lock the dquot buf to flush the dquot.  This prevents the AIL from
> blocking on the dquot, but it also forgets to clear the FREEING flag on
> its way out.  A subsequent purge attempt will see the FREEING flag is
> set and bail out, which leads to dqpurge_all failing to purge all the
> dquots.  This causes unmounts and quotaoff operations to hang.
> 
> Fixes: 8d3d7e2b35ea ("xfs: trylock underlying buffer on dquot flush")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_qm.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index d6cd83317344..938023dd8ce5 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -148,6 +148,7 @@ xfs_qm_dqpurge(
>   			error = xfs_bwrite(bp);
>   			xfs_buf_relse(bp);
>   		} else if (error == -EAGAIN) {
> +			dqp->dq_flags &= ~XFS_DQ_FREEING;
>   			goto out_unlock;
>   		}
>   		xfs_dqflock(dqp);
> 
