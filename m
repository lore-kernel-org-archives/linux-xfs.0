Return-Path: <SRS0=Awhw=ZE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380D5C43331
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 16:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BF1320679
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Nov 2019 16:24:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A+mri5SQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfKLQY2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 11:24:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfKLQY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 11:24:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACGOO0M150564;
        Tue, 12 Nov 2019 16:24:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=tihcr7NnmnyUOs6K3RY9ymdBCKCmejnDKks3L4E8Np0=;
 b=A+mri5SQ30oEWJiyHPxCaktClYc1MrVtmUbRZfKv6ApEF/zrAk7H/hKqhRY83WROZy7M
 rpdmgdKkp/Hj7N6lMr/ulaVkbr8QZzff5cT9wSkcECSVUvtv666srYK+GYmcrdT/+Zev
 5uzt1iGCVCJXsx/f0D7M+gMr0vHrtN2tyTpOeH4sxk52w4pXImYh9sti+WPghhLOT7Kw
 hyL5Q78HGlph+X7OrzAYllbhXpqAIV/bZuYUxzQnWmMUqpE10p3XZAmU3Y0jIh/HsM3D
 IklGAgqAWQ8U3ipD6o4OBxDK2i/S+uaqkH/1kD3rXg9NI3P42ktNDUT0PbqcaQhFVS1p Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w5ndq606c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 16:24:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xACGNmdx182188;
        Tue, 12 Nov 2019 16:24:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w7j01jd8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Nov 2019 16:24:23 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xACGOMYh019979;
        Tue, 12 Nov 2019 16:24:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 08:24:22 -0800
Date:   Tue, 12 Nov 2019 08:24:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: don't reset the "inode core" in xfs_iread
Message-ID: <20191112162421.GZ6219@magnolia>
References: <20191020082145.32515-1-hch@lst.de>
 <20191020082145.32515-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020082145.32515-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911120139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911120139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 20, 2019 at 10:21:44AM +0200, Christoph Hellwig wrote:
> We have the exact same memset in xfs_inode_alloc, which is always called
> just before xfs_iread.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine on its own, but then I looked at all the zero initializers
and memsets in xfs_inode_alloc and wondered why we don't just
kmem_zone_zalloc the inode?

Anyways,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 019c9be677cc..8afacfe4be0a 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -631,8 +631,6 @@ xfs_iread(
>  	if ((iget_flags & XFS_IGET_CREATE) &&
>  	    xfs_sb_version_hascrc(&mp->m_sb) &&
>  	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
> -		/* initialise the on-disk inode core */
> -		memset(&ip->i_d, 0, sizeof(ip->i_d));
>  		VFS_I(ip)->i_generation = prandom_u32();
>  		ip->i_d.di_version = 3;
>  		return 0;
> -- 
> 2.20.1
> 
