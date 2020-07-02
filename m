Return-Path: <SRS0=cy20=AN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FEDC433E1
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 18:58:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2034207CD
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jul 2020 18:58:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f4g/vNck"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgGBS6D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jul 2020 14:58:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47158 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgGBS6C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jul 2020 14:58:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062IqPPU172503
        for <linux-xfs@vger.kernel.org>; Thu, 2 Jul 2020 18:58:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=e5+rOdBnVkdXsKuH+oVdISs8hTtovXp24DKtIR54fMQ=;
 b=f4g/vNckGwLXjLq5ncozK8JaYiv7DtuK7tRa704ZlnhtdKsDVrzJ9kyQeUcQRm8ismD1
 fit7jXyaqxMMTLA+52uhMI4utpSTFW6YcHF3wNo/2P48PrHeUZZeSIAxnr/1CBzsdb0S
 83qm7TDWqSnACmwLGUo9Tk8af+EbsSY8QLuRWMNQMoadGLOftLGzmAEDPB8Jc8ToaGVR
 SxbNXjEm9JjcXVc7CBQZjbg4OgTiui+dgCtRyuD4fVJV8PHlVJXwuY5ffkJLs7HzCNIc
 C1quLZ8kz5ZDE/e3zeJ2PjtD88SknjWxcDTzAL+v+PaCNjkSGUnmIHHmyUYluJM4ytzH Mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31xx1e6yye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2020 18:58:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 062IqsTs189513
        for <linux-xfs@vger.kernel.org>; Thu, 2 Jul 2020 18:58:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31y52n5yng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2020 18:58:00 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 062IvxIV000874
        for <linux-xfs@vger.kernel.org>; Thu, 2 Jul 2020 18:57:59 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 18:57:59 +0000
Subject: Re: [PATCH 14/18] xfs: refactor quota exceeded test
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353180004.2864738.3571543752803090361.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <6998b092-1a38-411c-5615-34a69b33df3d@oracle.com>
Date:   Thu, 2 Jul 2020 11:57:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159353180004.2864738.3571543752803090361.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9670 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/30/20 8:43 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the open-coded test for whether or not we're over quota.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, the changes look correct.  I do not have a preference on the if/else 
logic mentioned in some of the other reviews.  At first glance they both 
require a bit of a pause, but I didn't find either to be too unsightly 
to read through.  I am amicable to either solution folks prefer.

Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_dquot.c |   95 ++++++++++++++++------------------------------------
>   1 file changed, 30 insertions(+), 65 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 35a113d1b42b..ef34c82c28a0 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -97,6 +97,33 @@ xfs_qm_adjust_dqlimits(
>   		xfs_dquot_set_prealloc_limits(dq);
>   }
>   
> +/*
> + * Determine if this quota counter is over either limit and set the quota
> + * timers as appropriate.
> + */
> +static inline void
> +xfs_qm_adjust_res_timer(
> +	struct xfs_dquot_res	*res,
> +	struct xfs_def_qres	*dres)
> +{
> +	bool			over;
> +
> +#ifdef DEBUG
> +	if (res->hardlimit)
> +		ASSERT(res->softlimit <= res->hardlimit);
> +#endif
> +
> +	over = (res->softlimit && res->count > res->softlimit) ||
> +	       (res->hardlimit && res->count > res->hardlimit);
> +
> +	if (over && res->timer == 0)
> +		res->timer = ktime_get_real_seconds() + dres->timelimit;
> +	else if (!over && res->timer != 0)
> +		res->timer = 0;
> +	else if (!over && res->timer == 0)
> +		res->warnings = 0;
> +}
> +
>   /*
>    * Check the limits and timers of a dquot and start or reset timers
>    * if necessary.
> @@ -121,71 +148,9 @@ xfs_qm_adjust_dqtimers(
>   	ASSERT(dq->q_id);
>   	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
>   
> -#ifdef DEBUG
> -	if (dq->q_blk.hardlimit)
> -		ASSERT(dq->q_blk.softlimit <= dq->q_blk.hardlimit);
> -	if (dq->q_ino.hardlimit)
> -		ASSERT(dq->q_ino.softlimit <= dq->q_ino.hardlimit);
> -	if (dq->q_rtb.hardlimit)
> -		ASSERT(dq->q_rtb.softlimit <= dq->q_rtb.hardlimit);
> -#endif
> -
> -	if (!dq->q_blk.timer) {
> -		if ((dq->q_blk.softlimit &&
> -		     (dq->q_blk.count > dq->q_blk.softlimit)) ||
> -		    (dq->q_blk.hardlimit &&
> -		     (dq->q_blk.count > dq->q_blk.hardlimit))) {
> -			dq->q_blk.timer = ktime_get_real_seconds() +
> -					defq->dfq_blk.timelimit;
> -		} else {
> -			dq->q_blk.warnings = 0;
> -		}
> -	} else {
> -		if ((!dq->q_blk.softlimit ||
> -		     (dq->q_blk.count <= dq->q_blk.softlimit)) &&
> -		    (!dq->q_blk.hardlimit ||
> -		    (dq->q_blk.count <= dq->q_blk.hardlimit))) {
> -			dq->q_blk.timer = 0;
> -		}
> -	}
> -
> -	if (!dq->q_ino.timer) {
> -		if ((dq->q_ino.softlimit &&
> -		     (dq->q_ino.count > dq->q_ino.softlimit)) ||
> -		    (dq->q_ino.hardlimit &&
> -		     (dq->q_ino.count > dq->q_ino.hardlimit))) {
> -			dq->q_ino.timer = ktime_get_real_seconds() +
> -					defq->dfq_ino.timelimit;
> -		} else {
> -			dq->q_ino.warnings = 0;
> -		}
> -	} else {
> -		if ((!dq->q_ino.softlimit ||
> -		     (dq->q_ino.count <= dq->q_ino.softlimit))  &&
> -		    (!dq->q_ino.hardlimit ||
> -		     (dq->q_ino.count <= dq->q_ino.hardlimit))) {
> -			dq->q_ino.timer = 0;
> -		}
> -	}
> -
> -	if (!dq->q_rtb.timer) {
> -		if ((dq->q_rtb.softlimit &&
> -		     (dq->q_rtb.count > dq->q_rtb.softlimit)) ||
> -		    (dq->q_rtb.hardlimit &&
> -		     (dq->q_rtb.count > dq->q_rtb.hardlimit))) {
> -			dq->q_rtb.timer = ktime_get_real_seconds() +
> -					defq->dfq_rtb.timelimit;
> -		} else {
> -			dq->q_rtb.warnings = 0;
> -		}
> -	} else {
> -		if ((!dq->q_rtb.softlimit ||
> -		     (dq->q_rtb.count <= dq->q_rtb.softlimit)) &&
> -		    (!dq->q_rtb.hardlimit ||
> -		     (dq->q_rtb.count <= dq->q_rtb.hardlimit))) {
> -			dq->q_rtb.timer = 0;
> -		}
> -	}
> +	xfs_qm_adjust_res_timer(&dq->q_blk, &defq->dfq_blk);
> +	xfs_qm_adjust_res_timer(&dq->q_ino, &defq->dfq_ino);
> +	xfs_qm_adjust_res_timer(&dq->q_rtb, &defq->dfq_rtb);
>   }
>   
>   /*
> 
