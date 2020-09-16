Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D25C433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 18:51:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20CFD20809
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 18:51:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TmEGXLG4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgIPSvb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 14:51:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32892 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbgIPSv2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 14:51:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GIhpBg191451;
        Wed, 16 Sep 2020 18:50:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=FrODlDh9V06yapK3N6r+Qcf8VQcVRTY6kWE4Unxws10=;
 b=TmEGXLG4yGJKe8qi6K8hadCyRZbNiX90hzFjFsrVX2xJC1w3bfqM55tOdN5BSg6jmJiX
 IMA9G00D4VbabyiBRogKfwsypA21fUVBY+rOjYej9yuI6fWqTTwFaN3T4w/+wBl9wsKn
 b1qyN9lggsXzybih1pbUQdUsq5D2B5tw540RHHMdWrlzD98EoMGwrZ4YQJdkCCQbzNck
 DLjlOxg+gTpwDf89rhmgSYWcN08OxPZbtcnEAbsALfnP7MQdpvgxfH0wQpi68iAoBT5W
 VltIDBn279VezdjOW9qzbntp7ioE2ikoYGLt0LaukyS6hHDt7V5AThp3X1J2zcL+WsQH AA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrr4xt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 18:50:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GIjVGu121344;
        Wed, 16 Sep 2020 18:50:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33h88918uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 18:50:30 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08GIoTq4018085;
        Wed, 16 Sep 2020 18:50:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 18:50:29 +0000
Date:   Wed, 16 Sep 2020 11:50:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: cleanup the useless backslash in
 xfs_attr_leaf_entsize_remote
Message-ID: <20200916185028.GJ7955@magnolia>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
 <1600255152-16086-9-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600255152-16086-9-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=3 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=990
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=3
 clxscore=1015 mlxlogscore=973 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160131
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 07:19:11PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The backslash is useless and remove it.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/libxfs/xfs_da_format.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index b40a4e80f5ee..4fe974773d85 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -746,7 +746,7 @@ xfs_attr3_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
>   */
>  static inline int xfs_attr_leaf_entsize_remote(int nlen)
>  {
> -	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) + \
> +	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) +
>  		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);

If you're going to go mess with these, you might as well clean up the
typedef usage, the unnecessary parentheses, and the open-coded round_up
call:

static inline int xfs_attr_leaf_entsize_remote(int nlen)
{
	return round_up(sizeof(struct xfs_attr_leaf_name_remote) - 1 + nlen,
			XFS_ATTR_LEAF_NAME_ALIGN);
}

(and similar for xfs_attr_leaf_entsize_local().)

--D

>  }
>  
> -- 
> 2.20.0
> 
