Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195CFC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 18:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB15D206D4
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 18:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZwSGGA2m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgEPSC5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 14:02:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56248 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgEPSC5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 14:02:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GI2sPr048628;
        Sat, 16 May 2020 18:02:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=7DqA1AHnOZHF13lMI6ru9nvcerrmeLQKeFPFDCcC+xs=;
 b=ZwSGGA2mgZVk931/ZmcYDfRts0HWYe7gB8roI9pFDr1y62NUikFzEjash+2BYp4y9xSl
 m29DdpnrW12h2lxmL67Y7JnGKXY6IrZVtz+G1LBWbbxyQeUciAYeg03MRiTtX9MX4uF2
 YB10MzgACLqSjzV5uT90CfcF4ZC0qhVObcMYVRKPTnDc7Jjwg45aaEgKCESMK5tpK+TZ
 D4W2gxWzwff4uiijfD+09h1KvurJ4uT6UIjXw2xMyogoReU5vOu3dsRfv4ByQrIsO/cf
 vA/Iz71NQxB/B9veh+3NJjVBsdnsUk3J9ijcmcg7JxabSgA0DpQWupYUfEE8i1ndmG6V eQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3127kqsfwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 18:02:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHwu7T049701;
        Sat, 16 May 2020 18:02:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3127gh4jhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 18:02:53 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04GI2rec013953;
        Sat, 16 May 2020 18:02:53 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 11:02:52 -0700
Date:   Sat, 16 May 2020 11:02:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: remove the XFS_DFORK_Q macro
Message-ID: <20200516180251.GD6714@magnolia>
References: <20200510072404.986627-1-hch@lst.de>
 <20200510072404.986627-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510072404.986627-3-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=1
 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 10, 2020 at 09:24:00AM +0200, Christoph Hellwig wrote:
> Just checking di_forkoff directly is a little easier to follow.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

/me hates macros
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_format.h    | 5 ++---
>  fs/xfs/libxfs/xfs_inode_buf.c | 6 +++---
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 045556e78ee2c..3cc352000b8a1 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -964,13 +964,12 @@ enum xfs_dinode_fmt {
>  /*
>   * Inode data & attribute fork sizes, per inode.
>   */
> -#define XFS_DFORK_Q(dip)		((dip)->di_forkoff != 0)
>  #define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
>  
>  #define XFS_DFORK_DSIZE(dip,mp) \
> -	(XFS_DFORK_Q(dip) ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
> +	((dip)->di_forkoff ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
>  #define XFS_DFORK_ASIZE(dip,mp) \
> -	(XFS_DFORK_Q(dip) ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
> +	((dip)->di_forkoff ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
>  #define XFS_DFORK_SIZE(dip,mp,w) \
>  	((w) == XFS_DATA_FORK ? \
>  		XFS_DFORK_DSIZE(dip, mp) : \
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 05f939adea944..5547bbb3cf945 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -265,7 +265,7 @@ xfs_inode_from_disk(
>  	error = xfs_iformat_data_fork(ip, from);
>  	if (error)
>  		return error;
> -	if (XFS_DFORK_Q(from)) {
> +	if (from->di_forkoff) {
>  		error = xfs_iformat_attr_fork(ip, from);
>  		if (error)
>  			goto out_destroy_data_fork;
> @@ -435,7 +435,7 @@ xfs_dinode_verify_forkoff(
>  	struct xfs_dinode	*dip,
>  	struct xfs_mount	*mp)
>  {
> -	if (!XFS_DFORK_Q(dip))
> +	if (!dip->di_forkoff)
>  		return NULL;
>  
>  	switch (dip->di_format)  {
> @@ -538,7 +538,7 @@ xfs_dinode_verify(
>  		return __this_address;
>  	}
>  
> -	if (XFS_DFORK_Q(dip)) {
> +	if (dip->di_forkoff) {
>  		fa = xfs_dinode_verify_fork(dip, mp, XFS_ATTR_FORK);
>  		if (fa)
>  			return fa;
> -- 
> 2.26.2
> 
