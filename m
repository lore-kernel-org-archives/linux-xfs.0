Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96F0C3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0F2F23407
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:07:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pm7upAlh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfH3PHe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 11:07:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52086 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbfH3PHd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 11:07:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UF42VA130602;
        Fri, 30 Aug 2019 15:07:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=6l1pm7hkVFBsDVeRqlypZEImZ4oFH81XzowR1Acls9I=;
 b=Pm7upAlheyXLR1pEeddn1mqcGElNGiwSzqkVng9Tn75srSKgKakY440Ra74SKNKHWLoz
 /ZBg3U/R6tBbFVW3IYizw69YhXkTzJdmYdn6kUtcQF+ylwLPzvhrNKr4Bg2VdgFn/FKQ
 cHAnFPYYCIsyru09jrs1nxdiaAkKwgh2JPUO30dprKMxtb/gsLUov1ZjOtSaxgR/V+JJ
 bFKPvBcTxWhdpQrRYBtcsFtI7OcQxgWyD7uH1iU5EKamgIcChEPXr42d6LrCG1VdvXJF
 gVVdQ5gX+icOmZVwupLk4FK0ZICWpLROPoWBMJFgYIaP6dgNlwjWDdOaF7j/7w/WqVvA CQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uq5s6061c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 15:07:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UF32UX188071;
        Fri, 30 Aug 2019 15:07:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uphavb0ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 15:07:28 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7UF7RL5007277;
        Fri, 30 Aug 2019 15:07:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 08:07:26 -0700
Date:   Fri, 30 Aug 2019 08:07:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: cleanup xfs_fsb_to_db
Message-ID: <20190830150726.GB5354@magnolia>
References: <20190830102411.519-1-hch@lst.de>
 <20190830102411.519-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830102411.519-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 12:24:10PM +0200, Christoph Hellwig wrote:
> This function isn't a macro anymore, so remove various superflous braces,
> and explicit cast that is done implicitly due to the return value, use
> a normal if statement instead of trying to squeeze everything together.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index e12f0ba7f2eb..0910cb75b65d 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -39,9 +39,9 @@
>  xfs_daddr_t
>  xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
>  {
> -	return (XFS_IS_REALTIME_INODE(ip) ? \
> -		 (xfs_daddr_t)XFS_FSB_TO_BB((ip)->i_mount, (fsb)) : \
> -		 XFS_FSB_TO_DADDR((ip)->i_mount, (fsb)));
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		return XFS_FSB_TO_BB(ip->i_mount, fsb);
> +	return XFS_FSB_TO_DADDR(ip->i_mount, fsb);
>  }
>  
>  /*
> -- 
> 2.20.1
> 
