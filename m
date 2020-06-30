Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0FCC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 21:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4370220656
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 21:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eU/GMaqV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgF3VhT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:37:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48006 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbgF3VhT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 17:37:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05ULIDG1188535
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=v/B3sAXnTJcfWel28PCBbaNxDokQUMS+nN99KgjR0og=;
 b=eU/GMaqV9KyviPejFAolD1SJFHD0WGH4jLTfBOB6/K8yghoMhyB2FddJvhBzhALfr9pv
 d8CmaeRtuGI9r1mdJnBAlAPGPxKnmkBQr3adcjIbfaSREmR7zL5LcWfNZ9cQBpdgijgE
 IJnQ5z3JyJopACI15B1ZVWXjv5J3dQ5MpdVisVD+1OBqSkJkHQt7wY9LCED06Yf9zhma
 jwZfA68EV6yb0QaUFoUgUARYt1dFCEONoXt/fB2u29EfiS0JKK3LRArmEmXOlXaO2FP8
 6znG0ZM687Odscf/iyxk4ERXcoMWe/y80yiNOLOQOO3Q+fnrGpfqxVxoGxHXuveQG91v Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31wxrn70ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:37:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05ULCdsj195175
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:35:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31y52jeufq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:35:17 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05ULZG6o030415
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 21:35:16 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 21:35:16 +0000
Subject: Re: [PATCH 03/18] xfs: validate ondisk/incore dquot flags
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353172899.2864738.6438709598863248951.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <7801e70e-543a-f643-ba14-da515b0a35cf@oracle.com>
Date:   Tue, 30 Jun 2020 14:35:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159353172899.2864738.6438709598863248951.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/30/20 8:42 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> While loading dquot records off disk, make sure that the quota type
> flags are the same between the incore dquot and the ondisk dquot.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_dquot.c |   23 ++++++++++++++++++++---
>   1 file changed, 20 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d5b7f03e93c8..46c8ca83c04d 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -524,13 +524,27 @@ xfs_dquot_alloc(
>   }
>   
>   /* Copy the in-core quota fields in from the on-disk buffer. */
> -STATIC void
> +STATIC int
>   xfs_dquot_from_disk(
>   	struct xfs_dquot	*dqp,
>   	struct xfs_buf		*bp)
>   {
>   	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
>   
> +	/*
> +	 * The only field the verifier didn't check was the quota type flag, so
> +	 * do that here.
> +	 */
> +	if ((dqp->dq_flags & XFS_DQ_ALLTYPES) !=
> +	    (ddqp->d_flags & XFS_DQ_ALLTYPES) ||
> +	    dqp->q_core.d_id != ddqp->d_id) {
> +		xfs_alert(bp->b_mount,
> +			  "Metadata corruption detected at %pS, quota %u",
> +			  __this_address, be32_to_cpu(dqp->q_core.d_id));
> +		xfs_alert(bp->b_mount, "Unmount and run xfs_repair");
> +		return -EFSCORRUPTED;
> +	}
> +
>   	/* copy everything from disk dquot to the incore dquot */
>   	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
>   
> @@ -544,6 +558,7 @@ xfs_dquot_from_disk(
>   
>   	/* initialize the dquot speculative prealloc thresholds */
>   	xfs_dquot_set_prealloc_limits(dqp);
> +	return 0;
>   }
>   
>   /* Allocate and initialize the dquot buffer for this in-core dquot. */
> @@ -617,9 +632,11 @@ xfs_qm_dqread(
>   	 * further.
>   	 */
>   	ASSERT(xfs_buf_islocked(bp));
> -	xfs_dquot_from_disk(dqp, bp);
> -
> +	error = xfs_dquot_from_disk(dqp, bp);
>   	xfs_buf_relse(bp);
> +	if (error)
> +		goto err;
> +
>   	*dqpp = dqp;
>   	return error;
>   
> 
