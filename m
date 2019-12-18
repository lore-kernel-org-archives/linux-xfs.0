Return-Path: <SRS0=QbY/=2I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F89C3F68F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4654A21D7D
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Dec 2019 21:31:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IkJCxMyA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfLRVbP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Dec 2019 16:31:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55326 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfLRVbP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 16:31:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBILTrjp015956;
        Wed, 18 Dec 2019 21:31:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=O2cLJHd34AqpHGMDMsYPh8JGJkOsXdv92ZBrHpBu5zU=;
 b=IkJCxMyA+Tt9L1Mu7YT7CjWZsAZGXXEc2oZbmRFIhVJ6Hg0021D9QHRoX+FgVSS3H+NA
 W9qlafMeq/p9W27OzonltVLYfcWF4NIyu/M5THQu4fChutCLtY3BQ361aW5v4g/E8Pig
 xmiXyg5C+y7sNhQPc1shcJkaJ6ycHAA0oVJxBvNwsr4POppR8E7RPgk2IezNBlBbofjS
 kuzF+xH3GHde0W0KyruTuhIw/Ry8gB2rbiMeqsoSxo7ot60X0QE8mFGm2q7RJbf+A1YD
 qZKn9BLAZR34o3j9IW76VQLxj0LmwvuAJCBNS4Fw9t7uwIO/dIMHmhtW1UKTWR4sNbJy NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2wvrcrg6c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:31:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBILTepE024140;
        Wed, 18 Dec 2019 21:31:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2wyp4yjbvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Dec 2019 21:31:11 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBILV94E017456;
        Wed, 18 Dec 2019 21:31:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Dec 2019 13:31:09 -0800
Date:   Wed, 18 Dec 2019 13:31:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 03/33] xfs: also remove cached ACLs when removing the
 underlying attr
Message-ID: <20191218213108.GF7489@magnolia>
References: <20191212105433.1692-1-hch@lst.de>
 <20191212105433.1692-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212105433.1692-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912180164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9475 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912180164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 12, 2019 at 11:54:03AM +0100, Christoph Hellwig wrote:
> We should not just invalidate the ACL when setting the underlying
> attribute, but also when removing it.  The ioctl interface gets that
> right, but the normal xattr inteface skipped the xfs_forget_acl due
> to an early return.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Shouldn't someone have a testcase for this?

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
> 2.20.1
> 
