Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC576C4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 16:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99A9A239D2
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 16:19:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D3qDKnR6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgIVQTx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:19:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39840 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIVQTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 12:19:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MGFQZE055628;
        Tue, 22 Sep 2020 16:18:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=C6a1akbLp1E+Kb+02PPXpfAWlALZyVZQzr+Z2SUxidI=;
 b=D3qDKnR62Cxt6obaz9vbC0O5OGlYad0IjTUbRFUtfexf4zYopRPWN+dfvoXw8Ve+5vBS
 176RdqVylBFziiymX7c2pMBVTLFHRrXVK8ZlHKUOIP1848kUPlGBIT+zh9veW3j/NANC
 mp3Gp5tJLUs8fmOXX/1sbw4es1VkmXWp8ZoyKaAdUSo9P3RjKAWPmMJtHcbcZ72P7ENX
 lDSxjYeOeY0IkTz/S+dQAh6uEdbAjtxaT38p+y+C9xU3DWOVinajrvh4mR0WUL7ya/4o
 FCWq2fPVKH6WnDhAD6Pvb9N0HZfHxfN5LxJD3HxPmmca9Y8VB7ltBMQ6Fmnz/23ijbY1 Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33q5rgc4vu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 16:18:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MGFtgg143646;
        Tue, 22 Sep 2020 16:18:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33nuw4b0y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 16:18:46 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08MGIisY002352;
        Tue, 22 Sep 2020 16:18:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 09:18:44 -0700
Date:   Tue, 22 Sep 2020 09:18:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH 3/3] xfs: only do dqget or dqhold for the specified dquots
Message-ID: <20200922161843.GH7955@magnolia>
References: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
 <1600765442-12146-4-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600765442-12146-4-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=3 adultscore=0 mlxlogscore=832 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=3 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=836 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220124
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 05:04:02PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> We attach the dquot(s) to the given inode and return udquot, gdquot
> or pdquot with references taken by dqget or dqhold in xfs_qm_vop_dqalloc()
> funciton. Actually, we only need to do dqget or dqhold for the specified
> dquots, it is unnecessary if the passed-in O_{u,g,p}dqpp value is NULL.

When would a caller pass in (for example) XFS_QMOPT_UQUOTA, a different
uid than the one currently associated with the inode, but a null
O_udqpp?  It doesn't make sense to say "Prepare to change this file's
uid, but don't give me the dquot of the new uid."

None of the callers do that today, so I don't see the point of this
patch.  Perhaps the function could ASSERT the arguments a little more
closely?

--D

> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_qm.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 44509decb4cd..38380fc29b4d 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1661,7 +1661,7 @@ xfs_qm_vop_dqalloc(
>  		}
>  	}
>  
> -	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
> +	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp) && O_udqpp) {
>  		if (!uid_eq(inode->i_uid, uid)) {
>  			/*
>  			 * What we need is the dquot that has this uid, and
> @@ -1694,7 +1694,7 @@ xfs_qm_vop_dqalloc(
>  			uq = xfs_qm_dqhold(ip->i_udquot);
>  		}
>  	}
> -	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
> +	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp) && O_gdqpp) {
>  		if (!gid_eq(inode->i_gid, gid)) {
>  			xfs_iunlock(ip, lockflags);
>  			error = xfs_qm_dqget(mp, from_kgid(user_ns, gid),
> @@ -1711,7 +1711,7 @@ xfs_qm_vop_dqalloc(
>  			gq = xfs_qm_dqhold(ip->i_gdquot);
>  		}
>  	}
> -	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
> +	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp) && O_pdqpp) {
>  		if (ip->i_d.di_projid != prid) {
>  			xfs_iunlock(ip, lockflags);
>  			error = xfs_qm_dqget(mp, prid,
> @@ -1733,16 +1733,11 @@ xfs_qm_vop_dqalloc(
>  	xfs_iunlock(ip, lockflags);
>  	if (O_udqpp)
>  		*O_udqpp = uq;
> -	else
> -		xfs_qm_dqrele(uq);
>  	if (O_gdqpp)
>  		*O_gdqpp = gq;
> -	else
> -		xfs_qm_dqrele(gq);
>  	if (O_pdqpp)
>  		*O_pdqpp = pq;
> -	else
> -		xfs_qm_dqrele(pq);
> +
>  	return 0;
>  
>  error_rele:
> -- 
> 2.20.0
> 
