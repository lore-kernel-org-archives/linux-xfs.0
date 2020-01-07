Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F28C282DD
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 23:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22AD02077B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 23:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iS9gtH2W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgAGXXS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 18:23:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49670 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727225AbgAGXXS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 18:23:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007NJHTk048779;
        Tue, 7 Jan 2020 23:23:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=mAQvSR2wAoE+fqhAh+wyynbruLaL84z9+DDWjt7x0Ho=;
 b=iS9gtH2Wlv1mxsoMolImQSj64+iCtlichX9LnpmxCFENtY2jJJPDvCQCLJj701mFZxH3
 iGfkmdH5xxkXeKSDh50AWYwK1GbnKVo+X0PI4fCYz80OQt5bCZB9tq1nWqU1kxuxQqP5
 9P14dW5nwWkKQlqK7AW7v9MtA2Y5fKmckQfVgj1VacjSa3//zuQy8T94XdxL2FrMoaXG
 q+pgD2u4VgnGvUTVj9SDy2BH8BiddLRjum99ObLDFzJToJTNViKxqsH1YlkSVfTbmDfq
 EFFiN4ve1cECxcxrsUvKcCRlCQoS4mK3lj2uwYzmYKaQ8bPCgDs0GRRtL+p+pYM399dr iQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xaj4u0t06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 23:23:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007NJCvd153337;
        Tue, 7 Jan 2020 23:23:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xcpanhvd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 23:23:13 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 007NNBDN003439;
        Tue, 7 Jan 2020 23:23:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 15:23:11 -0800
Date:   Tue, 7 Jan 2020 15:23:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: also remove cached ACLs when removing the
 underlying attr
Message-ID: <20200107232309.GG917713@magnolia>
References: <20200107165442.262020-1-hch@lst.de>
 <20200107165442.262020-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107165442.262020-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 05:54:41PM +0100, Christoph Hellwig wrote:
> We should not just invalidate the ACL when setting the underlying
> attribute, but also when removing it.  The ioctl interface gets that
> right, but the normal xattr inteface skipped the xfs_forget_acl due
> to an early return.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_xattr.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 383f0203d103..2288f20ae282 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -74,10 +74,11 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  	if (flags & XATTR_REPLACE)
>  		xflags |= ATTR_REPLACE;
>  
> -	if (!value)
> -		return xfs_attr_remove(ip, (unsigned char *)name, xflags);
> -	error = xfs_attr_set(ip, (unsigned char *)name,
> +	if (value)
> +		error = xfs_attr_set(ip, (unsigned char *)name,
>  				(void *)value, size, xflags);
> +	else
> +		error = xfs_attr_remove(ip, (unsigned char *)name, xflags);
>  	if (!error)
>  		xfs_forget_acl(inode, name, xflags);
>  
> -- 
> 2.24.1
> 
