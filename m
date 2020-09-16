Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B990C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 01:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8907206F7
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 01:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OrhPKxWl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgIQBOn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 21:14:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39790 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQBOk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 21:14:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GLOP86062238;
        Wed, 16 Sep 2020 21:33:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PL2hsI7nrsPCJKpuHwYNsvuRWqaxNWFXMqyV2Om4eLk=;
 b=OrhPKxWlrE54j9lPi9wM3dGCk39D7zChH9RAmAbh6Dz3kBHr9uDYKZTcq2RCzCV99Qee
 DljsVxt3Aii9wzTyAYgijqYtjDLJZxXJp0iQLxzJeAPxtlkypqxOwUzzMprWuQ4xojEK
 xoS+uDjck/If3VD/a5LzCMIg9Hsnbh+jVL2/DbniTGN3fWOV7UKD7wqMWLT8NZLM0p6G
 0gDVUHFzOtLnHNa28aMSsR2KyiuAU9MrDGH+L4DlkrAri63qyEgl9Xx/h1d2gB2NbY44
 MVpQ3LmJ6dbD0beW9pWA+DV5c2XFsSNCcFWpQkH6Zs7LOsdr61KvOXjLxn6tY3hXyA2V WA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91dq9mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 21:33:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GLOkMC182569;
        Wed, 16 Sep 2020 21:31:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33h892f8xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 21:31:49 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08GLVmHY001524;
        Wed, 16 Sep 2020 21:31:48 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 21:31:48 +0000
Date:   Wed, 16 Sep 2020 14:31:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: fix some comments
Message-ID: <20200916213147.GO7955@magnolia>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
 <1600255152-16086-10-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600255152-16086-10-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=3 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=3 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160156
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 07:19:12PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Fix the comments to help people understand the code.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.h | 4 ++--
>  fs/xfs/xfs_dquot.c            | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 4fe974773d85..b58943f2eb41 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -35,8 +35,8 @@ typedef struct xfs_da_blkinfo {
>   */
>  #define XFS_DA3_NODE_MAGIC	0x3ebe	/* magic number: non-leaf blocks */
>  #define XFS_ATTR3_LEAF_MAGIC	0x3bee	/* magic number: attribute leaf blks */
> -#define	XFS_DIR3_LEAF1_MAGIC	0x3df1	/* magic number: v2 dirlf single blks */
> -#define	XFS_DIR3_LEAFN_MAGIC	0x3dff	/* magic number: v2 dirlf multi blks */
> +#define	XFS_DIR3_LEAF1_MAGIC	0x3df1	/* magic number: v3 dirlf single blks */
> +#define	XFS_DIR3_LEAFN_MAGIC	0x3dff	/* magic number: v3 dirlf multi blks */
>  
>  struct xfs_da3_blkinfo {
>  	/*
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 3072814e407d..1d95ed387d66 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -831,8 +831,8 @@ xfs_qm_dqget_checks(
>  }
>  
>  /*
> - * Given the file system, id, and type (UDQUOT/GDQUOT), return a locked
> - * dquot, doing an allocation (if requested) as needed.
> + * Given the file system, id, and type (UDQUOT/GDQUOT/PDQUOT), return a
> + * locked dquot, doing an allocation (if requested) as needed.
>   */
>  int
>  xfs_qm_dqget(
> -- 
> 2.20.0
> 
