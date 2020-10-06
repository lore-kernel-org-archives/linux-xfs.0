Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FBDC41604
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCD4A20760
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 04:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="grFaoAkU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgJFEgn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:36:43 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55950 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgJFEgn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 00:36:43 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964POOm094745;
        Tue, 6 Oct 2020 04:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OGfe2QzXjOz7aHKk1g+HYPgZ1cBjA15kTxZGWJaBkhw=;
 b=grFaoAkUJqVAdR2iHHRYttytxofKSyEE+fxjKOdgcPzs5AxIwti7VLcu4HVFZvCubRHv
 20NH1FLVNBy8aDxbTWNnKYV+zxB9Sgqr8nYf/K5rVNkgis63Hzr1ODUGV/P7nR2ExNvI
 DGmeF37XXC4BwmkAOLFgGQN2lCLy5EtSGE/LDmHFAqSP1m5CnR3cwJX4eZkN44YU0OwP
 8PxXeSfIvdXIxnCeVSs2NQcjn1ZaxspVIhxzQneRcoINlcrFaY9ytkq8FjUOyVU9io0h
 Mcvxn5wGFDLYGX9oJkO/RIxWEJ3o4K8IQAlfwHi0b2MffpNfJeVxHIGplPO0qGTHyuGk hA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetasy69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 04:35:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0964OlPg063422;
        Tue, 6 Oct 2020 04:35:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33y36xesu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 04:35:33 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0964ZQ1T010736;
        Tue, 6 Oct 2020 04:35:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 21:35:26 -0700
Date:   Mon, 5 Oct 2020 21:35:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2 1/4] xfs: do the ASSERT for the arguments O_{u,g,p}dqpp
Message-ID: <20201006043525.GT49547@magnolia>
References: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
 <1601126073-32453-2-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601126073-32453-2-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=903 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=3 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=891 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=3 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060025
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 26, 2020 at 09:14:30PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> If we pass in XFS_QMOPT_{U,G,P}QUOTA flags and different uid/gid/prid
> than them currently associated with the inode, the arguments
> O_{u,g,p}dqpp shouldn't be NULL, so add the ASSERT for them.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Ok, seems fine to me...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_qm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 44509decb4cd..b2a9abee8b2b 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1662,6 +1662,7 @@ xfs_qm_vop_dqalloc(
>  	}
>  
>  	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
> +		ASSERT(O_udqpp);
>  		if (!uid_eq(inode->i_uid, uid)) {
>  			/*
>  			 * What we need is the dquot that has this uid, and
> @@ -1695,6 +1696,7 @@ xfs_qm_vop_dqalloc(
>  		}
>  	}
>  	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
> +		ASSERT(O_gdqpp);
>  		if (!gid_eq(inode->i_gid, gid)) {
>  			xfs_iunlock(ip, lockflags);
>  			error = xfs_qm_dqget(mp, from_kgid(user_ns, gid),
> @@ -1712,6 +1714,7 @@ xfs_qm_vop_dqalloc(
>  		}
>  	}
>  	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
> +		ASSERT(O_pdqpp);
>  		if (ip->i_d.di_projid != prid) {
>  			xfs_iunlock(ip, lockflags);
>  			error = xfs_qm_dqget(mp, prid,
> -- 
> 2.20.0
> 
