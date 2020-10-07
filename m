Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93ACC4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 22:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8370B212CC
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 22:07:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zyWzfsUW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgJGWHx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 18:07:53 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48294 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbgJGWHw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 18:07:52 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097LmE6a137733;
        Wed, 7 Oct 2020 22:06:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ufPYo2C901L0CKVaNVEefqwO2u6mu6ynguT29NDZLMs=;
 b=zyWzfsUWDyArlK/rggpJOMoo3HfuxDYewI58XMIxYZ4YugmI4tJDoQ+WiLH+SIrfZhfG
 ol7ePaSDIZYO3Op8EPXdEklFYggMFnKAbqCQ26ffqs3zyOWzcaUK87YoGBCBc3h6yemZ
 idiclzlS4AeesjsKoPBgOXVg3eRznoEWoUiSbN0QJsA0yHVunS3FY2XFwvP9TAeydDss
 lclSZI1YVoV12owfTBqUNSQtwdjUU0+MLV1HJqMzPe6c90MFiCv1ienyKy96c4FjqqhU
 Td5REHKGgHQ7kAGYrZibMayUf3/VKf7hl/obYWp7ZtN5qpPvoekFy79fTLgJAa1a9xp9 Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33xetb4smh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 22:06:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097LpDYW005772;
        Wed, 7 Oct 2020 22:06:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33yyjhs7r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 22:06:48 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 097M6lAG025092;
        Wed, 7 Oct 2020 22:06:47 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 15:06:47 -0700
Date:   Wed, 7 Oct 2020 15:06:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v3 5/5] xfs: directly return if the delta equal to zero
Message-ID: <20201007220646.GD6540@magnolia>
References: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
 <1602082272-20242-6-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602082272-20242-6-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=950 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=971 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=3 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070139
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 10:51:12PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The xfs_trans_mod_dquot() function will allocate new tp->t_dqinfo if it is
> NULL and make the changes in the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}].
> Nowadays seems none of the callers want to join the dquots to the
> transaction and push them to device when the delta is zero. Actually,
> most of time the caller would check the delta and go on only when the
> delta value is not zero, so we should bail out when it is zero.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Looks decent now; as far as I can tell, nothing will trip over null
t_dqinfo if we're not actually changing the dquots...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans_dquot.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 0ebfd7930382..3e37501791bf 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -194,6 +194,9 @@ xfs_trans_mod_dquot(
>  	ASSERT(XFS_IS_QUOTA_RUNNING(tp->t_mountp));
>  	qtrx = NULL;
>  
> +	if (!delta)
> +		return;
> +
>  	if (tp->t_dqinfo == NULL)
>  		xfs_trans_alloc_dqinfo(tp);
>  	/*
> @@ -205,10 +208,8 @@ xfs_trans_mod_dquot(
>  	if (qtrx->qt_dquot == NULL)
>  		qtrx->qt_dquot = dqp;
>  
> -	if (delta) {
> -		trace_xfs_trans_mod_dquot_before(qtrx);
> -		trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
> -	}
> +	trace_xfs_trans_mod_dquot_before(qtrx);
> +	trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
>  
>  	switch (field) {
>  	/* regular disk blk reservation */
> @@ -261,8 +262,7 @@ xfs_trans_mod_dquot(
>  		ASSERT(0);
>  	}
>  
> -	if (delta)
> -		trace_xfs_trans_mod_dquot_after(qtrx);
> +	trace_xfs_trans_mod_dquot_after(qtrx);
>  }
>  
>  
> -- 
> 2.20.0
> 
