Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF4DC4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 16:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC9CE2399A
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 16:21:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="s//9Kgd9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgIVQVH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:21:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44844 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgIVQVH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 12:21:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MGIfPV008289;
        Tue, 22 Sep 2020 16:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=yII/Qa3MzC8gYpzSECJFVHuTLZLB9qMa7fpquLFmhxU=;
 b=s//9Kgd92S5lNqWfEjlhPuZKfSN6mcP6a9FdsWE7lugInVRfcnZ9RYnJcT4szaLYXv1Q
 nElJV93XJHiDJ8vipiGaF1vUkNkdoxp6T9Iciqoyb3nBQwd93VV1/X8/4+hbKNI6QZSH
 8DKOZ9QZpoHQIahx5BVmXS7mW+qrFjlHtW234BbUDQpy/NnyQe3q6/dkxUJtIwSOD2Xy
 K6gHkCyVNSyrVMdRF6XtpSz6mqG9KYMH5f48t3cWKyPVhqGfVG10sx0cHztkMjlD86Z3
 sz4cZ2jCPR+K9eLNoZmQFZUnjxycXY455w4Nw0wOApXBdbamlWRdDsLtljA0TuLjFLWw 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33ndnudueq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 16:19:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MGJsUW156235;
        Tue, 22 Sep 2020 16:19:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33nuw4b35r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 16:19:55 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08MGJhTV017809;
        Tue, 22 Sep 2020 16:19:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 09:19:43 -0700
Date:   Tue, 22 Sep 2020 09:19:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH 1/3] xfs: directly return if the delta equal to zero
Message-ID: <20200922161942.GI7955@magnolia>
References: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
 <1600765442-12146-2-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600765442-12146-2-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=3 adultscore=0 mlxlogscore=857 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=3 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=841 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220125
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 05:04:00PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> It is useless to go on when the variable delta equal to zero in
> xfs_trans_mod_dquot(), so just return if the value equal to zero.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Yeah, that makes sense.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans_dquot.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 133fc6fc3edd..23c34af71825 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -215,10 +215,11 @@ xfs_trans_mod_dquot(
>  	if (qtrx->qt_dquot == NULL)
>  		qtrx->qt_dquot = dqp;
>  
> -	if (delta) {
> -		trace_xfs_trans_mod_dquot_before(qtrx);
> -		trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
> -	}
> +	if (!delta)
> +		return;
> +
> +	trace_xfs_trans_mod_dquot_before(qtrx);
> +	trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
>  
>  	switch (field) {
>  
> @@ -284,8 +285,7 @@ xfs_trans_mod_dquot(
>  		ASSERT(0);
>  	}
>  
> -	if (delta)
> -		trace_xfs_trans_mod_dquot_after(qtrx);
> +	trace_xfs_trans_mod_dquot_after(qtrx);
>  
>  	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
>  }
> -- 
> 2.20.0
> 
