Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05637C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 22:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B79A620780
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 22:53:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sFSi62s5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394855AbgJZWx2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 18:53:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36204 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394854AbgJZWx1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 18:53:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QMixGi099300;
        Mon, 26 Oct 2020 22:52:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Mpyn+dm++ye0eQKP3GY97JmfPOS2Xa4zOLz7z5pPfkU=;
 b=sFSi62s5jsefSXMcwslsiEqU10UnQ/nBSciiBdNIal1j173herY/GnCk27EkGGf7cvQV
 kKr02Un1w3jEuIJTWk44onqkptFENkHVfY04ByH6uX52GKCPKex0xrqJbyMt+SfVvDf4
 zyTp8BcpQUpiORazKxNgakP7XuHslkh+aW5XvDiW13ExzjQXBZ9T4I4zbrPh2MtgOrd7
 G5nF40CIgnOrhF6Vf6xIYmeBqpnrvWJG7yhUwFP4BlEYRJYLk0tRF5cY9MOU/pYe6Cm6
 MbhL6femeOAoWG4p9IfFJgt2uapnB2aTBHiX/Mtx99e8iFwrV2lVkKZh0RsAF4pB976M wQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7kq54b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 22:52:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QMkM6i158136;
        Mon, 26 Oct 2020 22:52:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwukqce8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 22:52:27 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QMqRuE026595;
        Mon, 26 Oct 2020 22:52:27 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 15:52:27 -0700
Date:   Mon, 26 Oct 2020 15:52:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v6 1/3] xfs: delete duplicated tp->t_dqinfo null check
 and allocation
Message-ID: <20201026225226.GF347246@magnolia>
References: <1602819508-29033-1-git-send-email-kaixuxia@tencent.com>
 <1602819508-29033-2-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602819508-29033-2-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=3
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 16, 2020 at 11:38:26AM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The function xfs_trans_mod_dquot_byino() wraps around
> xfs_trans_mod_dquot() to account for quotas, and also there is the
> function call chain xfs_trans_reserve_quota_bydquots -> xfs_trans_dqresv
> -> xfs_trans_mod_dquot, both of them do the duplicated null check and
> allocation. Thus we can delete the duplicated operation from them.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

HAH this got all the way to v6, sorry I suck. :(

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans_dquot.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index fe45b0c3970c..67f1e275b34d 100644
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
> @@ -698,7 +695,6 @@ xfs_trans_dqresv(
>  	 * because we don't have the luxury of a transaction envelope then.
>  	 */
>  	if (tp) {
> -		ASSERT(tp->t_dqinfo);
>  		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>  		if (nblks != 0)
>  			xfs_trans_mod_dquot(tp, dqp,
> @@ -752,9 +748,6 @@ xfs_trans_reserve_quota_bydquots(
>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>  		return 0;
>  
> -	if (tp && tp->t_dqinfo == NULL)
> -		xfs_trans_alloc_dqinfo(tp);
> -
>  	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>  
>  	if (udqp) {
> -- 
> 2.20.0
> 
