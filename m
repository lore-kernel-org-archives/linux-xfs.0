Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC0DC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 18:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E0072220A
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 18:23:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nUvjSryu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgIQSXe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 14:23:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38616 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgIQSWz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 14:22:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HIERsQ159139;
        Thu, 17 Sep 2020 18:21:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=XVCf/plt0dFIKu3BFOaH7VvtIo7Dz8AwwBInafQb4yI=;
 b=nUvjSryuKEv58ilvh1tHZlQQKiBh3Z98HSqtS6fVoVI0UYfsfzpCC83/gh8zgZ+XKbtt
 vNLyvGicpLnEFZFJoXmKfO1l1tOIiFWHzKG5Hv0ePzMsoXWIId3SRaGlZh9b8Ya0KjzN
 HwEhrCxR8N6b9RL0xOFpnYy5DKwREkg9jN8eM4e9R8bpVNfx5fVB+2KBvFMNPmcATnfz
 OzYZY0w7TMiudG/02ZfMl4Ob+YWFKuk8NDhscwiC2ycAHdQVoHew/lcFSGN+6tqLG8GS
 NDOijvqll/SNRml8SO/s3Jzw/qnDdJS/8yzBVgeqOawefxpMdd9wZOx1BUKw1ursBjSn vw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33j91dvnct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 18:21:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HI9wDV046822;
        Thu, 17 Sep 2020 18:19:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33hm35a9a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 18:19:43 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08HIJgPQ032400;
        Thu, 17 Sep 2020 18:19:42 GMT
Received: from localhost (/10.159.138.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 18:19:41 +0000
Date:   Thu, 17 Sep 2020 11:19:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2 6/7] xfs: code cleanup in
 xfs_attr_leaf_entsize_{remote,local}
Message-ID: <20200917181940.GM7955@magnolia>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
 <1600342728-21149-7-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600342728-21149-7-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=3 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170136
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 07:38:47PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Cleanup the typedef usage, the unnecessary parentheses, the unnecessary
> backslash and use the open-coded round_up call in
> xfs_attr_leaf_entsize_{remote,local}.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Seems alright,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index b40a4e80f5ee..09f0f5d42728 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -746,14 +746,14 @@ xfs_attr3_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
>   */
>  static inline int xfs_attr_leaf_entsize_remote(int nlen)
>  {
> -	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) + \
> -		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
> +	return round_up(sizeof(struct xfs_attr_leaf_name_remote) - 1 + nlen,
> +			XFS_ATTR_LEAF_NAME_ALIGN);
>  }
>  
>  static inline int xfs_attr_leaf_entsize_local(int nlen, int vlen)
>  {
> -	return ((uint)sizeof(xfs_attr_leaf_name_local_t) - 1 + (nlen) + (vlen) +
> -		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
> +	return round_up(sizeof(struct xfs_attr_leaf_name_local) - 1 + nlen + vlen,
> +			XFS_ATTR_LEAF_NAME_ALIGN);
>  }
>  
>  static inline int xfs_attr_leaf_entsize_local_max(int bsize)
> -- 
> 2.20.0
> 
