Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09EFFC41604
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B95BD2075A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:37:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RQU/UOkY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbgJFEhf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:37:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56548 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJFEhf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:37:35 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964PO3e094748;
        Tue, 6 Oct 2020 04:36:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EyTakHRC92Ub3ZV50uFbRDndnnkQnhvnBZSyj+KXuZs=;
 b=RQU/UOkYaY4eJfr9jO1EzS8bbSNvOz/73cOb99r4MJSZvXlA2lCL2oRd3rKy8TSfa33l
 yjBvb0wY6SSrwG/TGyWYVHOaV75FBqw9uHLKvLWoOq71SkYsFQdj1BehFks5tGFMXcQb
 emp/CVBhhp+h6cRxsMzo85ZRQNsLzJxtiRug8/4zaWI/qCFS7xX8CVdMb8IRPOL/9Kdc
 GnslhTdhwK9yBGG9m3f1UGP0/wupW81XbNv2QmaYCunb/YiT0miwKyXQlV1Kp0UqYWzo
 MY3U6cV46TjwIr4cjwjmqH6tVT8/Kde5PqCFwPEg54x9cPxJfhmPaUsbyNS0YGVM7uil yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33xetasy77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:36:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964P6Wk190516;
        Tue, 6 Oct 2020 04:36:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33yyjexmt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:36:11 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0964aADD022371;
        Tue, 6 Oct 2020 04:36:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:36:10 -0700
Date:   Mon, 5 Oct 2020 21:36:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2 2/4] xfs: fix the indent in xfs_trans_mod_dquot
Message-ID: <20201006043609.GU49547@magnolia>
References: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
 <1601126073-32453-3-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601126073-32453-3-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=3 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060025
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 26, 2020 at 09:14:31PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The formatting is strange in xfs_trans_mod_dquot, so do a reindent.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

"strange".  I can just picture the Papyrus font now... :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans_dquot.c | 43 ++++++++++++++--------------------------
>  1 file changed, 15 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 133fc6fc3edd..fe45b0c3970c 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -221,36 +221,27 @@ xfs_trans_mod_dquot(
>  	}
>  
>  	switch (field) {
> -
> -		/*
> -		 * regular disk blk reservation
> -		 */
> -	      case XFS_TRANS_DQ_RES_BLKS:
> +	/* regular disk blk reservation */
> +	case XFS_TRANS_DQ_RES_BLKS:
>  		qtrx->qt_blk_res += delta;
>  		break;
>  
> -		/*
> -		 * inode reservation
> -		 */
> -	      case XFS_TRANS_DQ_RES_INOS:
> +	/* inode reservation */
> +	case XFS_TRANS_DQ_RES_INOS:
>  		qtrx->qt_ino_res += delta;
>  		break;
>  
> -		/*
> -		 * disk blocks used.
> -		 */
> -	      case XFS_TRANS_DQ_BCOUNT:
> +	/* disk blocks used. */
> +	case XFS_TRANS_DQ_BCOUNT:
>  		qtrx->qt_bcount_delta += delta;
>  		break;
>  
> -	      case XFS_TRANS_DQ_DELBCOUNT:
> +	case XFS_TRANS_DQ_DELBCOUNT:
>  		qtrx->qt_delbcnt_delta += delta;
>  		break;
>  
> -		/*
> -		 * Inode Count
> -		 */
> -	      case XFS_TRANS_DQ_ICOUNT:
> +	/* Inode Count */
> +	case XFS_TRANS_DQ_ICOUNT:
>  		if (qtrx->qt_ino_res && delta > 0) {
>  			qtrx->qt_ino_res_used += delta;
>  			ASSERT(qtrx->qt_ino_res >= qtrx->qt_ino_res_used);
> @@ -258,17 +249,13 @@ xfs_trans_mod_dquot(
>  		qtrx->qt_icount_delta += delta;
>  		break;
>  
> -		/*
> -		 * rtblk reservation
> -		 */
> -	      case XFS_TRANS_DQ_RES_RTBLKS:
> +	/* rtblk reservation */
> +	case XFS_TRANS_DQ_RES_RTBLKS:
>  		qtrx->qt_rtblk_res += delta;
>  		break;
>  
> -		/*
> -		 * rtblk count
> -		 */
> -	      case XFS_TRANS_DQ_RTBCOUNT:
> +	/* rtblk count */
> +	case XFS_TRANS_DQ_RTBCOUNT:
>  		if (qtrx->qt_rtblk_res && delta > 0) {
>  			qtrx->qt_rtblk_res_used += delta;
>  			ASSERT(qtrx->qt_rtblk_res >= qtrx->qt_rtblk_res_used);
> @@ -276,11 +263,11 @@ xfs_trans_mod_dquot(
>  		qtrx->qt_rtbcount_delta += delta;
>  		break;
>  
> -	      case XFS_TRANS_DQ_DELRTBCOUNT:
> +	case XFS_TRANS_DQ_DELRTBCOUNT:
>  		qtrx->qt_delrtb_delta += delta;
>  		break;
>  
> -	      default:
> +	default:
>  		ASSERT(0);
>  	}
>  
> -- 
> 2.20.0
> 
