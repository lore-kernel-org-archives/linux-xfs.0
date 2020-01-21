Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60EDC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAE5120678
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 18:44:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CMuqP69U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgAUSo3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:44:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33286 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAUSo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 13:44:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LISHF7186883;
        Tue, 21 Jan 2020 18:44:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Juf5lnZE23ch6FOXoollnzD2prqVXNB+bSutTB40HNo=;
 b=CMuqP69Uxi/2+yYe+mey1MR+n13/XPNqKUv2jpbnK2H66p4THey3iGxCItDz47Epdh35
 tMSr8KyOjE6u/CDdwAqz6uiLnGZN9u8UlaHlRZo0p6ODdb5zSgonSjHwhNjM40XnZHnI
 aZmPF48eONkrCMaQf/HHvEk326J0YnUN7/HGorfQIVTM8EHKZui9v5sRH/ohSNQ2OhwZ
 pIi2qJPEdNYx4Yyd+2f7qV2DzmJ4/YkaUPY7TbDuUNdTQ5Swq7ODNXGIv5Nn9kVJ92oc
 MD2IoMfTuoy/tD3nSFm4n2I0GYK/LdxGIECp2m+HAxwZW2MQ8AHkWGWhaDq04Dk05eKi jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xktnr6w3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:44:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LIT1rc100486;
        Tue, 21 Jan 2020 18:42:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xnsa969dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 18:42:24 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00LIgOo2005259;
        Tue, 21 Jan 2020 18:42:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 10:42:23 -0800
Date:   Tue, 21 Jan 2020 10:42:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 21/29] xfs: rename xfs_attr_list_int to xfs_attr_list
Message-ID: <20200121184222.GU8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-22-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-22-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:43AM +0100, Christoph Hellwig wrote:
> The version taking the context structure is the main interface to list
> attributes, so drop the _int postfix.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.h | 4 ++--
>  fs/xfs/scrub/attr.c      | 4 ++--
>  fs/xfs/xfs_attr_list.c   | 6 +++---
>  fs/xfs/xfs_ioctl.c       | 2 +-
>  fs/xfs/xfs_xattr.c       | 2 +-
>  5 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 0e3c213f78ce..8d42f5782ff7 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -102,8 +102,8 @@ struct xfs_attr_list_context {
>   * Overall external interface routines.
>   */
>  int xfs_attr_inactive(struct xfs_inode *dp);
> -int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
> -int xfs_attr_list_int(struct xfs_attr_list_context *);
> +int xfs_attr_list_ilocked(struct xfs_attr_list_context *);
> +int xfs_attr_list(struct xfs_attr_list_context *);
>  int xfs_inode_hasattr(struct xfs_inode *ip);
>  int xfs_attr_get_ilocked(struct xfs_da_args *args);
>  int xfs_attr_get(struct xfs_da_args *args);
> diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> index 05537627211d..9e336d797616 100644
> --- a/fs/xfs/scrub/attr.c
> +++ b/fs/xfs/scrub/attr.c
> @@ -98,7 +98,7 @@ struct xchk_xattr {
>  /*
>   * Check that an extended attribute key can be looked up by hash.
>   *
> - * We use the XFS attribute list iterator (i.e. xfs_attr_list_int_ilocked)
> + * We use the XFS attribute list iterator (i.e. xfs_attr_list_ilocked)
>   * to call this function for every attribute key in an inode.  Once
>   * we're here, we load the attribute value to see if any errors happen,
>   * or if we get more or less data than we expected.
> @@ -516,7 +516,7 @@ xchk_xattr(
>  	 * iteration, which doesn't really follow the usual buffer
>  	 * locking order.
>  	 */
> -	error = xfs_attr_list_int_ilocked(&sx.context);
> +	error = xfs_attr_list_ilocked(&sx.context);
>  	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
>  		goto out;
>  
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 369ce1d3dd45..ea79219859a0 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -507,7 +507,7 @@ xfs_attr_leaf_list(
>  }
>  
>  int
> -xfs_attr_list_int_ilocked(
> +xfs_attr_list_ilocked(
>  	struct xfs_attr_list_context	*context)
>  {
>  	struct xfs_inode		*dp = context->dp;
> @@ -527,7 +527,7 @@ xfs_attr_list_int_ilocked(
>  }
>  
>  int
> -xfs_attr_list_int(
> +xfs_attr_list(
>  	struct xfs_attr_list_context	*context)
>  {
>  	struct xfs_inode		*dp = context->dp;
> @@ -540,7 +540,7 @@ xfs_attr_list_int(
>  		return -EIO;
>  
>  	lock_mode = xfs_ilock_attr_map_shared(dp);
> -	error = xfs_attr_list_int_ilocked(context);
> +	error = xfs_attr_list_ilocked(context);
>  	xfs_iunlock(dp, lock_mode);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 2e64dae3743f..639abd2bd723 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -395,7 +395,7 @@ xfs_ioc_attr_list(
>  	alist->al_more = 0;
>  	alist->al_offset[0] = context.bufsize;
>  
> -	error = xfs_attr_list_int(&context);
> +	error = xfs_attr_list(&context);
>  	ASSERT(error <= 0);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 8880dee3400f..e1951d2b878e 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -232,7 +232,7 @@ xfs_vn_listxattr(
>  	context.firstu = context.bufsize;
>  	context.put_listent = xfs_xattr_put_listent;
>  
> -	error = xfs_attr_list_int(&context);
> +	error = xfs_attr_list(&context);
>  	if (error)
>  		return error;
>  	if (context.count < 0)
> -- 
> 2.24.1
> 
