Return-Path: <SRS0=mG4f=AP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC93C433E0
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Jul 2020 20:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36655208E4
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Jul 2020 20:43:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cN0iXnDm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgGDUnP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 4 Jul 2020 16:43:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52232 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbgGDUnP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Jul 2020 16:43:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 064Kb2fX019618
        for <linux-xfs@vger.kernel.org>; Sat, 4 Jul 2020 20:43:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cgqNlRGh5uZ0Pm+Tpuh6PPTqJMH4yAkmR4eX0vW3YgA=;
 b=cN0iXnDmGyNPAiKYk9wx32ar1Q4mtjZVilCV5S5AHIkWbfanY3abPylyGPE35uvnVSyd
 fuqtm83syZzG9TNhecMgyByFS+F6NsCaeTmGTEPIIPADBORRzMvO0/lHCcxhm7af6+N5
 fz9bh6ex1lFZbwZF4VctBSCtk7z3z8VZxdTUv+0A967Ljn2ZJEBJ4PKWLmm8V8ZK0Z25
 /rrCzd+WKXsAKKDRWsrNVOACwLhFMP/wFFJMMufaEzr9Gnna/fQWKHRrU7HvZFP8//Zx
 pDxf1mjG80Eq47oziyvSsZ0kpN07nXyt1VNZiw8MPGCe5eEyU6BGus5wCUH+JwTygfSL 2g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 322jdn1g7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 04 Jul 2020 20:43:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 064Kc37W182028
        for <linux-xfs@vger.kernel.org>; Sat, 4 Jul 2020 20:41:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 322evrj86d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 04 Jul 2020 20:41:13 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 064KfCjW006373
        for <linux-xfs@vger.kernel.org>; Sat, 4 Jul 2020 20:41:12 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 04 Jul 2020 13:41:12 -0700
Subject: Re: [PATCH 17/18] xfs: refactor xfs_trans_apply_dquot_deltas
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353181889.2864738.7577728127911412217.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a4570ea7-ea98-af5f-b248-1b71ef8105de@oracle.com>
Date:   Sat, 4 Jul 2020 13:41:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159353181889.2864738.7577728127911412217.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9672 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007040146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9672 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 impostorscore=0 spamscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007040146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/30/20 8:43 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hoist the code that adjusts the incore quota reservation count
> adjustments into a separate function, both to reduce the level of
> indentation and also to reduce the amount of open-coded logic.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, it's a bit of a hoist and a simplification, but I think it's a good 
clean up.

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_trans_dquot.c |  103 +++++++++++++++++++++-------------------------
>   1 file changed, 46 insertions(+), 57 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 30a011dc9828..701923ea6c04 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -293,6 +293,37 @@ xfs_trans_dqlockedjoin(
>   	}
>   }
>   
> +/* Apply dqtrx changes to the quota reservation counters. */
> +static inline void
> +xfs_apply_quota_reservation_deltas(
> +	struct xfs_dquot_res	*res,
> +	uint64_t		reserved,
> +	int64_t			res_used,
> +	int64_t			count_delta)
> +{
> +	if (reserved != 0) {
> +		/*
> +		 * Subtle math here: If reserved > res_used (the normal case),
> +		 * we're simply subtracting the unused transaction quota
> +		 * reservation from the dquot reservation.
> +		 *
> +		 * If, however, res_used > reserved, then we have allocated
> +		 * more quota blocks than were reserved for the transaction.
> +		 * We must add that excess to the dquot reservation since it
> +		 * tracks (usage + resv) and by definition we didn't reserve
> +		 * that excess.
> +		 */
> +		res->reserved -= abs(reserved - res_used);
> +	} else if (count_delta != 0) {
> +		/*
> +		 * These blks were never reserved, either inside a transaction
> +		 * or outside one (in a delayed allocation). Also, this isn't
> +		 * always a negative number since we sometimes deliberately
> +		 * skip quota reservations.
> +		 */
> +		res->reserved += count_delta;
> +	}
> +}
>   
>   /*
>    * Called by xfs_trans_commit() and similar in spirit to
> @@ -327,6 +358,8 @@ xfs_trans_apply_dquot_deltas(
>   		xfs_trans_dqlockedjoin(tp, qa);
>   
>   		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
> +			uint64_t	blk_res_used;
> +
>   			qtrx = &qa[i];
>   			/*
>   			 * The array of dquots is filled
> @@ -396,71 +429,27 @@ xfs_trans_apply_dquot_deltas(
>   			 * In case of delayed allocations, there's no
>   			 * reservation that a transaction structure knows of.
>   			 */
> -			if (qtrx->qt_blk_res != 0) {
> -				uint64_t	blk_res_used = 0;
> +			blk_res_used = max_t(int64_t, 0, qtrx->qt_bcount_delta);
> +			xfs_apply_quota_reservation_deltas(&dqp->q_blk,
> +					qtrx->qt_blk_res, blk_res_used,
> +					qtrx->qt_bcount_delta);
>   
> -				if (qtrx->qt_bcount_delta > 0)
> -					blk_res_used = qtrx->qt_bcount_delta;
> -
> -				if (qtrx->qt_blk_res != blk_res_used) {
> -					if (qtrx->qt_blk_res > blk_res_used)
> -						dqp->q_blk.reserved -= (xfs_qcnt_t)
> -							(qtrx->qt_blk_res -
> -							 blk_res_used);
> -					else
> -						dqp->q_blk.reserved -= (xfs_qcnt_t)
> -							(blk_res_used -
> -							 qtrx->qt_blk_res);
> -				}
> -			} else {
> -				/*
> -				 * These blks were never reserved, either inside
> -				 * a transaction or outside one (in a delayed
> -				 * allocation). Also, this isn't always a
> -				 * negative number since we sometimes
> -				 * deliberately skip quota reservations.
> -				 */
> -				if (qtrx->qt_bcount_delta) {
> -					dqp->q_blk.reserved +=
> -					      (xfs_qcnt_t)qtrx->qt_bcount_delta;
> -				}
> -			}
>   			/*
>   			 * Adjust the RT reservation.
>   			 */
> -			if (qtrx->qt_rtblk_res != 0) {
> -				if (qtrx->qt_rtblk_res != qtrx->qt_rtblk_res_used) {
> -					if (qtrx->qt_rtblk_res >
> -					    qtrx->qt_rtblk_res_used)
> -					       dqp->q_rtb.reserved -= (xfs_qcnt_t)
> -						       (qtrx->qt_rtblk_res -
> -							qtrx->qt_rtblk_res_used);
> -					else
> -					       dqp->q_rtb.reserved -= (xfs_qcnt_t)
> -						       (qtrx->qt_rtblk_res_used -
> -							qtrx->qt_rtblk_res);
> -				}
> -			} else {
> -				if (qtrx->qt_rtbcount_delta)
> -					dqp->q_rtb.reserved +=
> -					    (xfs_qcnt_t)qtrx->qt_rtbcount_delta;
> -			}
> +			xfs_apply_quota_reservation_deltas(&dqp->q_rtb,
> +					qtrx->qt_rtblk_res,
> +					qtrx->qt_rtblk_res_used,
> +					qtrx->qt_rtbcount_delta);
>   
>   			/*
>   			 * Adjust the inode reservation.
>   			 */
> -			if (qtrx->qt_ino_res != 0) {
> -				ASSERT(qtrx->qt_ino_res >=
> -				       qtrx->qt_ino_res_used);
> -				if (qtrx->qt_ino_res > qtrx->qt_ino_res_used)
> -					dqp->q_ino.reserved -= (xfs_qcnt_t)
> -						(qtrx->qt_ino_res -
> -						 qtrx->qt_ino_res_used);
> -			} else {
> -				if (qtrx->qt_icount_delta)
> -					dqp->q_ino.reserved +=
> -					    (xfs_qcnt_t)qtrx->qt_icount_delta;
> -			}
> +			ASSERT(qtrx->qt_ino_res >= qtrx->qt_ino_res_used);
> +			xfs_apply_quota_reservation_deltas(&dqp->q_ino,
> +					qtrx->qt_ino_res,
> +					qtrx->qt_ino_res_used,
> +					qtrx->qt_icount_delta);
>   
>   			ASSERT(dqp->q_blk.reserved >= dqp->q_blk.count);
>   			ASSERT(dqp->q_ino.reserved >= dqp->q_ino.count);
> 
