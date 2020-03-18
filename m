Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D12C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 15:30:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B11520724
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 15:30:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gN5N3+dZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgCRPav (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 11:30:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60470 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCRPav (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 11:30:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IFMwK4105617;
        Wed, 18 Mar 2020 15:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=yhEwCFGpiAMCpCo4ux/xOtf6GmhKURbdskOSVi67/c0=;
 b=gN5N3+dZEAP5iUPk+DM/1Ek1bxuXptBf9cCSBrW1pbqsW522ETK3OrN3QAIALmexJDlv
 vQhheYoQhLMdX/Cn2qLOgNxjVt78dZDk8+kWfOCw0k9ENXy6AcwOQtqEmAcc0jbIx08d
 wxnAtuh1Ydt+BhIyw21csb1QeX0O8iRtxFITxH4RPMD9C0PznBwqVapLMU4CQcljW5EC
 PTxrJzlsq0pOJH92NYkRVRXv3krerWEmrbLPRQo2X0WURzKzsWpj2IykjIfi/WLm928H
 HJroKj1m74S/SnUv5f5C8cLw6DidW+jgy/TuwXmS7N28ql80mazK+hyt3+Ap0daF3uk/ HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2yrpprbcbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 15:30:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IFLnjE133941;
        Wed, 18 Mar 2020 15:30:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ys92gqakd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 15:30:40 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02IFUcTX032254;
        Wed, 18 Mar 2020 15:30:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Mar 2020 08:30:38 -0700
Date:   Wed, 18 Mar 2020 08:30:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: Re: [PATCH 4/5] xfs: simplify a check in
 xfs_ioctl_setattr_check_cowextsize
Message-ID: <20200318153038.GY256767@magnolia>
References: <20200317185756.1063268-1-hch@lst.de>
 <20200317185756.1063268-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317185756.1063268-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180073
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003180073
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 17, 2020 at 07:57:55PM +0100, Christoph Hellwig wrote:
> Only v5 file systems can have the reflink feature, and those will
> always use the large dinode format.  Remove the extra check for the
> inode version.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 5a1d2b9cb05a..ad825ffa7e4c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1473,8 +1473,7 @@ xfs_ioctl_setattr_check_cowextsize(
>  	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
>  		return 0;
>  
> -	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
> -	    ip->i_d.di_version != 3)
> +	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
>  		return -EINVAL;
>  
>  	if (fa->fsx_cowextsize == 0)
> -- 
> 2.24.1
> 
