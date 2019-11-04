Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A516CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C67D12084D
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:05:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I8vAP0FU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfKDUFk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:05:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35054 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfKDUFk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:05:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4JxKXs096503;
        Mon, 4 Nov 2019 20:05:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=RgapTtuRQ68+BPSfviw+wlTZ4oG4+0ZHBkSmBf6fWEQ=;
 b=I8vAP0FUPB7WR2TR3xBfoYIy4bNlsPeLpzGTEQmQcYMHXgFi4e3H2j49F4KzajqN7v4r
 6/IzXny7HA6n2XmI4DjjBa3hRWokE/E8y45i+NwN6EYM1EaJm5S+EpH6KwQEdhOjZPps
 FctAgDGlj8GJLhbL9cjGxphjUR1GTLhxjqLBSwMteJnlAHVqYE9OYUr3v38rrG9cEthF
 ZzmejmkMlhKi20Pc3nWWwwN9asu2u/PLDQlwskZ40h25cB07Fyw9IrZLcLK5ttz/o4SQ
 fBjKnnVX6Pa9dlZ9ITH/ExIfs1vgV5/4pH4SjdZn4Dq7ntdGkitK0jjg+FPzqNnEA7t5 vA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w11rpsst8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:05:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4K3EVu195380;
        Mon, 4 Nov 2019 20:05:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w1k8vdy5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:05:35 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4K5YBG026070;
        Mon, 4 Nov 2019 20:05:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:05:34 -0800
Date:   Mon, 4 Nov 2019 12:05:33 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/34] xfs: move the dir2 leaf header size to struct
 xfs_da_geometry
Message-ID: <20191104200533.GK4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-11-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040192
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

On Fri, Nov 01, 2019 at 03:06:55PM -0700, Christoph Hellwig wrote:
> Move the leaf header size towards our structure for dir/attr geometry
> parameters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_btree.h  | 1 +
>  fs/xfs/libxfs/xfs_da_format.c | 3 ---
>  fs/xfs/libxfs/xfs_dir2.c      | 7 +++++--
>  fs/xfs/libxfs/xfs_dir2.h      | 1 -
>  fs/xfs/libxfs/xfs_dir2_leaf.c | 2 +-
>  fs/xfs/libxfs/xfs_dir2_node.c | 4 ++--
>  6 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 11b2d75f83ad..5e3e954fee77 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -26,6 +26,7 @@ struct xfs_da_geometry {
>  	uint		node_ents;	/* # of entries in a danode */
>  	int		magicpct;	/* 37% of block size in bytes */
>  	xfs_dablk_t	datablk;	/* blockno of dir data v2 */
> +	int		leaf_hdr_size;	/* dir2 leaf header size */
>  	xfs_dablk_t	leafblk;	/* blockno of leaf data v2 */
>  	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
>  };
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index ed21ce01502f..a3e87f4788e0 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -570,7 +570,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  
> -	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
>  	.leaf_max_ents = xfs_dir2_max_leaf_ents,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
> @@ -612,7 +611,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  
> -	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
>  	.leaf_max_ents = xfs_dir2_max_leaf_ents,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
> @@ -654,7 +652,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.data_entry_p = xfs_dir3_data_entry_p,
>  	.data_unused_p = xfs_dir3_data_unused_p,
>  
> -	.leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr),
>  	.leaf_max_ents = xfs_dir3_max_leaf_ents,
>  
>  	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index aef20ec6e140..94badb28fd1a 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -122,10 +122,13 @@ xfs_da_mount(
>  	dageo->fsblog = mp->m_sb.sb_blocklog;
>  	dageo->blksize = xfs_dir2_dirblock_bytes(&mp->m_sb);
>  	dageo->fsbcount = 1 << mp->m_sb.sb_dirblklog;
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		dageo->node_hdr_size = sizeof(struct xfs_da3_node_hdr);
> -	else
> +		dageo->leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr);
> +	} else {
>  		dageo->node_hdr_size = sizeof(struct xfs_da_node_hdr);
> +		dageo->leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr);
> +	}
>  
>  	/*
>  	 * Now we've set up the block conversion variables, we can calculate the
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index b46657974134..544adee5dd12 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -72,7 +72,6 @@ struct xfs_dir_ops {
>  	struct xfs_dir2_data_unused *
>  		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
>  
> -	int	leaf_hdr_size;
>  	int	(*leaf_max_ents)(struct xfs_da_geometry *geo);
>  
>  	int	free_hdr_size;
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index d6581f40f0a4..f72fd8182223 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -1132,7 +1132,7 @@ xfs_dir3_leaf_log_header(
>  
>  	xfs_trans_log_buf(args->trans, bp,
>  			  (uint)((char *)&leaf->hdr - (char *)leaf),
> -			  args->dp->d_ops->leaf_hdr_size - 1);
> +			  args->geo->leaf_hdr_size - 1);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 76c896da8352..76f31909376e 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1334,7 +1334,7 @@ xfs_dir2_leafn_remove(
>  	 * Return indication of whether this leaf block is empty enough
>  	 * to justify trying to join it with a neighbor.
>  	 */
> -	*rval = (dp->d_ops->leaf_hdr_size +
> +	*rval = (args->geo->leaf_hdr_size +
>  		 (uint)sizeof(leafhdr.ents) * (leafhdr.count - leafhdr.stale)) <
>  		args->geo->magicpct;
>  	return 0;
> @@ -1440,7 +1440,7 @@ xfs_dir2_leafn_toosmall(
>  	xfs_dir3_leaf_check(dp, blk->bp);
>  
>  	count = leafhdr.count - leafhdr.stale;
> -	bytes = dp->d_ops->leaf_hdr_size + count * sizeof(ents[0]);
> +	bytes = state->args->geo->leaf_hdr_size + count * sizeof(ents[0]);
>  	if (bytes > (state->args->geo->blksize >> 1)) {
>  		/*
>  		 * Blk over 50%, don't try to join.
> -- 
> 2.20.1
> 
