Return-Path: <SRS0=mMHn=ZK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF6FC432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A373222DD
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Nov 2019 21:23:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HlbIHVzc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfKRVX4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 16:23:56 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33606 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfKRVXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Nov 2019 16:23:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILDtFK177718;
        Mon, 18 Nov 2019 21:23:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=wqWZg474qEgQnJJ2bOH1BWXiHRK8JgsPD4m+Vunf/xA=;
 b=HlbIHVzcRCoSr9+AtYgp63PqfjXT9sGjFWKbwjEK2PKf56o0KK6/9JK/EIXb2fdTQlWU
 9dGE95f7JdywfytUYu/atvFRI33hZcgXXaJh8bc8CoaFAeYge+Bzs7XbBbz9qij8ASVP
 jsb7tiUEwY6/kRnCxPhA6okiuhILN50fTdblXuhKbVoWDB0tDAC5sGGqjx7ljkLrwF7s
 jcR3gxZ5B3f05S6ELAgY0kZ8ZvOhK6/3hxTs3LBm/whjvRZAz4PoPC1r9VYYYdfEFM+6
 t48ZcTv2gOsGgpkW8yd68GCwPqncmiuOm62NOr4hZctfPPEet9mcIsF96IlObtzYbsm5 dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wa8htk1rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:23:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAILE2f2162765;
        Mon, 18 Nov 2019 21:23:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2wc0af81y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Nov 2019 21:23:51 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAILNnFJ005237;
        Mon, 18 Nov 2019 21:23:49 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Nov 2019 13:23:49 -0800
Date:   Mon, 18 Nov 2019 13:23:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 6/9] xfs: remove the mappedbno argument to
 xfs_dir3_leafn_read
Message-ID: <20191118212348.GB6219@magnolia>
References: <20191116182214.23711-1-hch@lst.de>
 <20191116182214.23711-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116182214.23711-7-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911180184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911180184
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 16, 2019 at 07:22:11PM +0100, Christoph Hellwig wrote:
> This argument is always hard coded to -1, so remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_leaf.c | 5 ++---
>  fs/xfs/libxfs/xfs_dir2_node.c | 3 +--
>  fs/xfs/libxfs/xfs_dir2_priv.h | 4 ++--
>  3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 2eee4e299e19..a1fe45db61c3 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -278,13 +278,12 @@ xfs_dir3_leafn_read(
>  	struct xfs_trans	*tp,
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		fbno,
> -	xfs_daddr_t		mappedbno,
>  	struct xfs_buf		**bpp)
>  {
>  	int			err;
>  
> -	err = xfs_da_read_buf(tp, dp, fbno, mappedbno, bpp,
> -				XFS_DATA_FORK, &xfs_dir3_leafn_buf_ops);
> +	err = xfs_da_read_buf(tp, dp, fbno, -1, bpp, XFS_DATA_FORK,
> +			&xfs_dir3_leafn_buf_ops);
>  	if (!err && tp && *bpp)
>  		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_LEAFN_BUF);
>  	return err;
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 5f30a1953a52..a5450229a7ef 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1554,8 +1554,7 @@ xfs_dir2_leafn_toosmall(
>  		/*
>  		 * Read the sibling leaf block.
>  		 */
> -		error = xfs_dir3_leafn_read(state->args->trans, dp,
> -					    blkno, -1, &bp);
> +		error = xfs_dir3_leafn_read(state->args->trans, dp, blkno, &bp);
>  		if (error)
>  			return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index ade41556901a..3001cf82baa6 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -93,8 +93,8 @@ void xfs_dir2_leaf_hdr_to_disk(struct xfs_mount *mp, struct xfs_dir2_leaf *to,
>  		struct xfs_dir3_icleaf_hdr *from);
>  int xfs_dir3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
>  		xfs_dablk_t fbno, struct xfs_buf **bpp);
> -extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
> -		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
> +int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
> +		xfs_dablk_t fbno, struct xfs_buf **bpp);
>  extern int xfs_dir2_block_to_leaf(struct xfs_da_args *args,
>  		struct xfs_buf *dbp);
>  extern int xfs_dir2_leaf_addname(struct xfs_da_args *args);
> -- 
> 2.20.1
> 
