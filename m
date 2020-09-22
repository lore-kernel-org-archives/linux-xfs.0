Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47433C4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 16:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0C8323A1B
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 16:21:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WdL+d73r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgIVQVP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:21:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44934 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgIVQVP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 12:21:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MGItIj008441;
        Tue, 22 Sep 2020 16:20:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=wu/LNYdW8+9pStZwc8aXxX3cns6/YYpsi98Tgq3Ma/c=;
 b=WdL+d73rA1+/S2jLCjHKhbOrcpuW8TC09iuqXa0VEisuTxH/GyrPSM7R660SHfQgs2kH
 VgL7317sGusIJVxHFEWHCzfHPILuaBCkujSeApzo2s6nCFsXpvEJapwi4Eb4150oXgGl
 3xXsw3SYt7RbBz22OP9FVuKB0DMSxT0KRL98mxbCEYHHLI0fvI3v39mDmRWgmyREflL3
 OFxdx7aFH//0w1fGhATzwB8/qg0W1hk1mWdqpgvxrx3hlvcQDCrTcshPwQ4H18MRjXG3
 wJi4P5wIPsiDV1LCKxX4sRZM+Tkbk4iCCQRYmzvALRj/1RVFUXSBVM2/YMp/TXKTcIh0 qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33ndnudug9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 16:20:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MGJs49156256;
        Tue, 22 Sep 2020 16:20:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33nuw4b3ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 16:20:03 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08MGK2XZ019585;
        Tue, 22 Sep 2020 16:20:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 09:20:01 -0700
Date:   Tue, 22 Sep 2020 09:20:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH 2/3] xfs: remove the unused parameter id from
 xfs_qm_dqattach_one
Message-ID: <20200922162000.GJ7955@magnolia>
References: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
 <1600765442-12146-3-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600765442-12146-3-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=3 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=3 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220125
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 05:04:01PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Since we never use the second parameter id, so remove it from
> xfs_qm_dqattach_one() function.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Heh, yep.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_qm.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 41a459ffd1f2..44509decb4cd 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -249,7 +249,6 @@ xfs_qm_unmount_quotas(
>  STATIC int
>  xfs_qm_dqattach_one(
>  	struct xfs_inode	*ip,
> -	xfs_dqid_t		id,
>  	xfs_dqtype_t		type,
>  	bool			doalloc,
>  	struct xfs_dquot	**IO_idqpp)
> @@ -330,23 +329,23 @@ xfs_qm_dqattach_locked(
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
>  	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
> -		error = xfs_qm_dqattach_one(ip, i_uid_read(VFS_I(ip)),
> -				XFS_DQTYPE_USER, doalloc, &ip->i_udquot);
> +		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_USER,
> +				doalloc, &ip->i_udquot);
>  		if (error)
>  			goto done;
>  		ASSERT(ip->i_udquot);
>  	}
>  
>  	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
> -		error = xfs_qm_dqattach_one(ip, i_gid_read(VFS_I(ip)),
> -				XFS_DQTYPE_GROUP, doalloc, &ip->i_gdquot);
> +		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_GROUP,
> +				doalloc, &ip->i_gdquot);
>  		if (error)
>  			goto done;
>  		ASSERT(ip->i_gdquot);
>  	}
>  
>  	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
> -		error = xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQTYPE_PROJ,
> +		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_PROJ,
>  				doalloc, &ip->i_pdquot);
>  		if (error)
>  			goto done;
> -- 
> 2.20.0
> 
