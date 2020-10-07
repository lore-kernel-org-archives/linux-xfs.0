Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6852EC4363D
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 22:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BF4F20872
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 22:03:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kggbdBZE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgJGWDK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 18:03:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59774 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728649AbgJGWDK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 18:03:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097LnxeD028432;
        Wed, 7 Oct 2020 22:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=30VPA9wkzflEsFt9m0b5R5LM0QqP+9K7EhqzCJxo6DM=;
 b=kggbdBZEb78BltCY3sSnVn8Ua5mMu+JSrW6G7VntVTROEA4Wa+KXqlZf+EkkUHhqM3QF
 a4hmVxG4+v7FDhWiGuprtRGCu2Id0GPXse4VMgdcjPqzx+MX1egTPJNVh2opctJtbC0n
 /lNJ2hpaDpBixVNbC87/Q22KC+VwQrzdkeWUbQLS19sTJR7BpglRsMe3MFXVaqyvkYl0
 YGdC6T2/lSTwi3qyjLCELl6CdUs/WAv3adn6lH69zwA+yQ0vaIQtYnZGzrdsK0GuP0aW
 PUJaV47Hi7jezijKLsPCG/MTVvL2TQ4SnzA1/BqAcMB8zMy5zgX1MolqjRmA/dSDhU8Q 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33ym34sq26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 22:02:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097LpKRp146353;
        Wed, 7 Oct 2020 22:02:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vq1yvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 22:02:02 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 097M1was016694;
        Wed, 7 Oct 2020 22:01:58 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 15:01:58 -0700
Date:   Wed, 7 Oct 2020 15:01:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v3 3/5] xfs: delete duplicated tp->t_dqinfo null check
 and allocation
Message-ID: <20201007220157.GB6540@magnolia>
References: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
 <1602082272-20242-4-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602082272-20242-4-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=3 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=3 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070139
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 10:51:10PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The function xfs_trans_mod_dquot_byino() wrap around xfs_trans_mod_dquot()
> to account for quotas, both of them do the null check and allocation. Thus
> we can delete the duplicated operation in xfs_trans_mod_dquot_byino().
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans_dquot.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index fe45b0c3970c..1b56065c9ff1 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -143,9 +143,6 @@ xfs_trans_mod_dquot_byino(
>  	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
>  		return;
>  
> -	if (tp->t_dqinfo == NULL)
> -		xfs_trans_alloc_dqinfo(tp);
> -
>  	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
>  		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
>  	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
> -- 
> 2.20.0
> 
