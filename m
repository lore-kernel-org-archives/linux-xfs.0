Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67838C4361B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CECD23120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgLFXNk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:13:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57970 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgLFXNk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:13:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N5tbi182066;
        Sun, 6 Dec 2020 23:12:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=x9j/sE0+k/cWmGi+MR8Mykl3IdH5kgLf+BRWC1YDhp4=;
 b=DR12WGPKfWATnVptOR0iUbPapryTcBsJZ3kpy1xDHWm1kUccOd2weTjIvCQH7yrwUpMs
 g2cbpXrCGi7rnf6EkMgTI53f/ejCCNgckTVMAIUhLmJPkOKYFPeS/uYOHpQZHRiKMRlM
 0enPG0R86cGlLYrz16trGLn0vg4uU6SAOB+5IF3RmW+uePCzDYmkSHTmGnHtjDbdJYXq
 iWIXjore0FLmpF99ZYcr6pHm9HunQjOyWfVLq6y74kdRSybyf1HNOTrK+wzLE+nlihBq
 20MtUD/fL4mvNIOPTxLS77qjOQ2Grcu7eLe1P+OfnIu+mdDvb82LNMEXJg5n2EV9km48 ZA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825ktujn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 23:12:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6NAMXl005647;
        Sun, 6 Dec 2020 23:12:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 358m3vpewy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 23:12:06 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B6NC2Sv007723;
        Sun, 6 Dec 2020 23:12:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:12:02 -0800
Date:   Sun, 6 Dec 2020 15:12:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: show the proper user quota options
Message-ID: <20201206231201.GJ629293@magnolia>
References: <1606124332-22100-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606124332-22100-1-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=3 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 23, 2020 at 05:38:52PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The quota option 'usrquota' should be shown if both the XFS_UQUOTA_ACCT
> and XFS_UQUOTA_ENFD flags are set. The option 'uqnoenforce' should be
> shown when only the XFS_UQUOTA_ACCT flag is set. The current code logic
> seems wrong, Fix it and show proper options.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

FWIW this causes a regression in xfs/513 since mount option uqnoenforce
no longer causes 'usrquota' to be emitted in /proc/mounts.  Do you have
a patch to fix fstests?

--D

> ---
>  fs/xfs/xfs_super.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e3e229e52512..5ebd6cdc44a7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -199,10 +199,12 @@ xfs_fs_show_options(
>  		seq_printf(m, ",swidth=%d",
>  				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
>  
> -	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
> -		seq_puts(m, ",usrquota");
> -	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
> -		seq_puts(m, ",uqnoenforce");
> +	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
> +		if (mp->m_qflags & XFS_UQUOTA_ENFD)
> +			seq_puts(m, ",usrquota");
> +		else
> +			seq_puts(m, ",uqnoenforce");
> +	}
>  
>  	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
>  		if (mp->m_qflags & XFS_PQUOTA_ENFD)
> -- 
> 2.20.0
> 
