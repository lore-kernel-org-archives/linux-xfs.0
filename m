Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C90EC47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 21:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 181F520661
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 21:23:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LkCC/b/e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgEEVXC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 17:23:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60646 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgEEVXC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 17:23:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045LJEkc144732;
        Tue, 5 May 2020 21:22:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8IykeGT+GW+0afRcRvrAOZ2z5PWWeoVpgm/qhOmXczA=;
 b=LkCC/b/eaYQDf/7Z12/Ve3mOoGej8antsikoBImrr9o0h/h64znKeKlB/f5qswcFlOSW
 Usmd9K6r5qXH4Av6vDvPhB/xcje276/D+TOoGi9dGT+7P9ysdTx+rMs5rsTAgrcXyOcg
 1HxPnS5VGkENFPMN9tKjLRYgb/or+WylyEi/1loiB67K+FZcqU0jD1GArR1DWIYw3Nj3
 eltZkvWM8QAcEjkmfa7tcYQeYBVlelrydVr/yGfV0zRXUZc9ezAZLJsihyTgdY7B90bq
 FSQzJHlXoISUDigv89Swadbi3HZ+OtrfeiAxjtHnTgxZWCTf4fgRVSasIDRr6hRu3OBS Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30s0tmf6d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 21:22:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045LHiIl175576;
        Tue, 5 May 2020 21:22:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30t1r60sdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 21:22:58 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 045LMvtr004143;
        Tue, 5 May 2020 21:22:57 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 14:22:57 -0700
Subject: Re: [PATCH v4 08/17] xfs: fix duplicate verification from
 xfs_qm_dqflush()
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200504141154.55887-1-bfoster@redhat.com>
 <20200504141154.55887-9-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <242a07ff-b325-72f6-46f1-67d4a225e88a@oracle.com>
Date:   Tue, 5 May 2020 14:22:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504141154.55887-9-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 7:11 AM, Brian Foster wrote:
> The pre-flush dquot verification in xfs_qm_dqflush() duplicates the
> read verifier by checking the dquot in the on-disk buffer. Instead,
> verify the in-core variant before it is flushed to the buffer.
> 
> Fixes: 7224fa482a6d ("xfs: add full xfs_dqblk verifier")
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, looks good:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_dquot.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index af2c8e5ceea0..265feb62290d 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1116,13 +1116,12 @@ xfs_qm_dqflush(
>   	dqb = bp->b_addr + dqp->q_bufoffset;
>   	ddqp = &dqb->dd_diskdq;
>   
> -	/*
> -	 * A simple sanity check in case we got a corrupted dquot.
> -	 */
> -	fa = xfs_dqblk_verify(mp, dqb, be32_to_cpu(ddqp->d_id), 0);
> +	/* sanity check the in-core structure before we flush */
> +	fa = xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(dqp->q_core.d_id),
> +			      0);
>   	if (fa) {
>   		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> -				be32_to_cpu(ddqp->d_id), fa);
> +				be32_to_cpu(dqp->q_core.d_id), fa);
>   		xfs_buf_relse(bp);
>   		xfs_dqfunlock(dqp);
>   		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> 
