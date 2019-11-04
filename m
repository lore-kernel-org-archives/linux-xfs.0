Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC60CA9ED4
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 101542084D
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:09:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NC6p39BR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbfKDUJQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:09:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38666 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729403AbfKDUJK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:09:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4JxYl5096685;
        Mon, 4 Nov 2019 20:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3ZHpi9jieniZwTHtJEmbI6HDDu8f1yal0jgMb07mxoI=;
 b=NC6p39BR5F7kJF9Iv1zZeGghJPXZJx3rphFMgiGLmy5k7FRVVXy5afDBLTz5jcLVGk5e
 hPI6uQPO6gM5jUo24I7nWZyQUADGIQfQ3YUFX/lw/GlFYLjjB0g5TrsgGFBdrMrPY+fd
 flbevY3zc94EGKZaTfQjIWIP6aSC0Y99Wz6e1DnuNjUCksNteLupKXuStLLkbUvz4P14
 sNXqKYAo7HREDYPLlZ6Xgvr3pmDuvIeulah3/opKbgsFZ93Ojim/bjh7gFaBWfygh5FN
 wqS2E3rts1VOJRn2Of/gvBtgjYtLLZIKZvzXLfNMUt9L55tdc33vbwYcmSC+/biytuai cQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w11rpst97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:09:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4K8ttQ051550;
        Mon, 4 Nov 2019 20:09:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w1kxmygxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:09:03 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4K8XZm024255;
        Mon, 4 Nov 2019 20:08:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:08:32 -0800
Date:   Mon, 4 Nov 2019 12:08:31 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/34] xfs: devirtualize ->free_hdr_to_disk
Message-ID: <20191104200831.GN4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-14-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040193
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:06:58PM -0700, Christoph Hellwig wrote:
> Replace the ->free_hdr_to_disk dir ops method with a directly called
> xfs_dir2_free_hdr_to_disk helper that takes care of the differences
> between the v4 and v5 on-disk format.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c | 31 -------------------------------
>  fs/xfs/libxfs/xfs_dir2.h      |  2 --
>  fs/xfs/libxfs/xfs_dir2_node.c | 33 +++++++++++++++++++++++++++++----
>  3 files changed, 29 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index d0e541d9d335..b943d9443d55 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -468,34 +468,6 @@ xfs_dir3_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
>  	return db % xfs_dir3_free_max_bests(geo);
>  }
>  
> -static void
> -xfs_dir2_free_hdr_to_disk(
> -	struct xfs_dir2_free		*to,
> -	struct xfs_dir3_icfree_hdr	*from)
> -{
> -	ASSERT(from->magic == XFS_DIR2_FREE_MAGIC);
> -
> -	to->hdr.magic = cpu_to_be32(from->magic);
> -	to->hdr.firstdb = cpu_to_be32(from->firstdb);
> -	to->hdr.nvalid = cpu_to_be32(from->nvalid);
> -	to->hdr.nused = cpu_to_be32(from->nused);
> -}
> -
> -static void
> -xfs_dir3_free_hdr_to_disk(
> -	struct xfs_dir2_free		*to,
> -	struct xfs_dir3_icfree_hdr	*from)
> -{
> -	struct xfs_dir3_free_hdr *hdr3 = (struct xfs_dir3_free_hdr *)to;
> -
> -	ASSERT(from->magic == XFS_DIR3_FREE_MAGIC);
> -
> -	hdr3->hdr.magic = cpu_to_be32(from->magic);
> -	hdr3->firstdb = cpu_to_be32(from->firstdb);
> -	hdr3->nvalid = cpu_to_be32(from->nvalid);
> -	hdr3->nused = cpu_to_be32(from->nused);
> -}
> -
>  static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.sf_entsize = xfs_dir2_sf_entsize,
>  	.sf_nextentry = xfs_dir2_sf_nextentry,
> @@ -527,7 +499,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
> -	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
>  	.free_max_bests = xfs_dir2_free_max_bests,
>  	.free_bests_p = xfs_dir2_free_bests_p,
>  	.db_to_fdb = xfs_dir2_db_to_fdb,
> @@ -565,7 +536,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
> -	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
>  	.free_max_bests = xfs_dir2_free_max_bests,
>  	.free_bests_p = xfs_dir2_free_bests_p,
>  	.db_to_fdb = xfs_dir2_db_to_fdb,
> @@ -603,7 +573,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.data_unused_p = xfs_dir3_data_unused_p,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
> -	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
>  	.free_max_bests = xfs_dir3_free_max_bests,
>  	.free_bests_p = xfs_dir3_free_bests_p,
>  	.db_to_fdb = xfs_dir3_db_to_fdb,
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index c3e6a6fb7e37..613a78281d03 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -73,8 +73,6 @@ struct xfs_dir_ops {
>  		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
>  
>  	int	free_hdr_size;
> -	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
> -				    struct xfs_dir3_icfree_hdr *from);
>  	int	(*free_max_bests)(struct xfs_da_geometry *geo);
>  	__be16 * (*free_bests_p)(struct xfs_dir2_free *free);
>  	xfs_dir2_db_t (*db_to_fdb)(struct xfs_da_geometry *geo,
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 9e22710bb772..26032eba1e32 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -244,6 +244,31 @@ xfs_dir2_free_hdr_from_disk(
>  	}
>  }
>  
> +static void
> +xfs_dir2_free_hdr_to_disk(
> +	struct xfs_mount		*mp,
> +	struct xfs_dir2_free		*to,
> +	struct xfs_dir3_icfree_hdr	*from)
> +{
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		struct xfs_dir3_free	*to3 = (struct xfs_dir3_free *)to;
> +
> +		ASSERT(from->magic == XFS_DIR3_FREE_MAGIC);
> +
> +		to3->hdr.hdr.magic = cpu_to_be32(from->magic);
> +		to3->hdr.firstdb = cpu_to_be32(from->firstdb);
> +		to3->hdr.nvalid = cpu_to_be32(from->nvalid);
> +		to3->hdr.nused = cpu_to_be32(from->nused);
> +	} else {
> +		ASSERT(from->magic == XFS_DIR2_FREE_MAGIC);
> +
> +		to->hdr.magic = cpu_to_be32(from->magic);
> +		to->hdr.firstdb = cpu_to_be32(from->firstdb);
> +		to->hdr.nvalid = cpu_to_be32(from->nvalid);
> +		to->hdr.nused = cpu_to_be32(from->nused);
> +	}
> +}
> +
>  int
>  xfs_dir2_free_read(
>  	struct xfs_trans	*tp,
> @@ -302,7 +327,7 @@ xfs_dir3_free_get_buf(
>  		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_meta_uuid);
>  	} else
>  		hdr.magic = XFS_DIR2_FREE_MAGIC;
> -	dp->d_ops->free_hdr_to_disk(bp->b_addr, &hdr);
> +	xfs_dir2_free_hdr_to_disk(mp, bp->b_addr, &hdr);
>  	*bpp = bp;
>  	return 0;
>  }
> @@ -418,7 +443,7 @@ xfs_dir2_leaf_to_node(
>  	freehdr.nused = n;
>  	freehdr.nvalid = be32_to_cpu(ltp->bestcount);
>  
> -	dp->d_ops->free_hdr_to_disk(fbp->b_addr, &freehdr);
> +	xfs_dir2_free_hdr_to_disk(dp->i_mount, fbp->b_addr, &freehdr);
>  	xfs_dir2_free_log_bests(args, fbp, 0, freehdr.nvalid - 1);
>  	xfs_dir2_free_log_header(args, fbp);
>  
> @@ -1176,7 +1201,7 @@ xfs_dir3_data_block_free(
>  		logfree = 1;
>  	}
>  
> -	dp->d_ops->free_hdr_to_disk(free, &freehdr);
> +	xfs_dir2_free_hdr_to_disk(dp->i_mount, free, &freehdr);
>  	xfs_dir2_free_log_header(args, fbp);
>  
>  	/*
> @@ -1733,7 +1758,7 @@ xfs_dir2_node_add_datablk(
>  	 */
>  	if (bests[*findex] == cpu_to_be16(NULLDATAOFF)) {
>  		freehdr.nused++;
> -		dp->d_ops->free_hdr_to_disk(fbp->b_addr, &freehdr);
> +		xfs_dir2_free_hdr_to_disk(mp, fbp->b_addr, &freehdr);
>  		xfs_dir2_free_log_header(args, fbp);
>  	}
>  
> -- 
> 2.20.1
> 
