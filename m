Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13907CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D851D20B7C
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:22:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lT79bHML"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfKDUWl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:22:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:33226 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfKDUWl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:22:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KJYiI124033;
        Mon, 4 Nov 2019 20:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=LXpYLjrVYrWj2ZRACB1BWWZdsu5W1exLP1I8iNgJcWA=;
 b=lT79bHMLJOksOQjknYp1ooe5ak1yRTRF88yNioa4V9VtKRVqX4SSuKwktGMDvJZEqYev
 ZjwckRsYkz0zQbgH5YWiz9X9goQ0/s+J3GMIw1py40fovQtMG/2LmhPPZ+XIfRNd/839
 nwiWIGRblKpoboJ5CWi674LyngjQ2eywNyWEweBBDyOnDs4aUu50y2SnKaMrDK9S7AjL
 nCLjhjWAOEJKsmo04vHD+6/M+aXK20VI9zhN3Q8B/JumZZ/RPyW5RQ3w8y/4kCqoCvaN
 086+Rp1ZGta1OzKIcgAA15J+UyTH3oe0rkQOH9PYuUSFGEfLs3UcnykEEmdLEpIO/uWz Nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w117tsws2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:22:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KISn1042096;
        Mon, 4 Nov 2019 20:22:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w1k8veufg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:22:36 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4KMZaD030260;
        Mon, 4 Nov 2019 20:22:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:22:35 -0800
Date:   Mon, 4 Nov 2019 12:22:34 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/34] xfs: move the dir2 free header size to struct
 xfs_da_geometry
Message-ID: <20191104202234.GQ4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-17-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-17-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040195
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040195
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:07:01PM -0700, Christoph Hellwig wrote:
> Move the free header size towards our structure for dir/attr geometry
> parameters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_da_btree.h  | 1 +
>  fs/xfs/libxfs/xfs_da_format.c | 3 ---
>  fs/xfs/libxfs/xfs_dir2.c      | 2 ++
>  fs/xfs/libxfs/xfs_dir2.h      | 1 -
>  fs/xfs/libxfs/xfs_dir2_node.c | 2 +-
>  5 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index c8b137685ca7..3d0b1e97bf43 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -29,6 +29,7 @@ struct xfs_da_geometry {
>  	int		leaf_hdr_size;	/* dir2 leaf header size */
>  	unsigned int	leaf_max_ents;	/* # of entries in dir2 leaf */
>  	xfs_dablk_t	leafblk;	/* blockno of leaf data v2 */
> +	int		free_hdr_size;	/* dir2 free header size */

Shouldn't this be unsigned?  Even if the original code wasn't this way?

Looks fine otherwise,

--D

>  	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
>  };
>  
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 7263b6d6a135..1fc8982c830f 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -486,7 +486,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  
> -	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_max_bests = xfs_dir2_free_max_bests,
>  	.db_to_fdb = xfs_dir2_db_to_fdb,
>  	.db_to_fdindex = xfs_dir2_db_to_fdindex,
> @@ -522,7 +521,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  
> -	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_max_bests = xfs_dir2_free_max_bests,
>  	.db_to_fdb = xfs_dir2_db_to_fdb,
>  	.db_to_fdindex = xfs_dir2_db_to_fdindex,
> @@ -558,7 +556,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.data_entry_p = xfs_dir3_data_entry_p,
>  	.data_unused_p = xfs_dir3_data_unused_p,
>  
> -	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
>  	.free_max_bests = xfs_dir3_free_max_bests,
>  	.db_to_fdb = xfs_dir3_db_to_fdb,
>  	.db_to_fdindex = xfs_dir3_db_to_fdindex,
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 9f88b9885747..13ac228bfc86 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -125,9 +125,11 @@ xfs_da_mount(
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		dageo->node_hdr_size = sizeof(struct xfs_da3_node_hdr);
>  		dageo->leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr);
> +		dageo->free_hdr_size = sizeof(struct xfs_dir3_free_hdr);
>  	} else {
>  		dageo->node_hdr_size = sizeof(struct xfs_da_node_hdr);
>  		dageo->leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr);
> +		dageo->free_hdr_size = sizeof(struct xfs_dir2_free_hdr);
>  	}
>  	dageo->leaf_max_ents = (dageo->blksize - dageo->leaf_hdr_size) /
>  			sizeof(struct xfs_dir2_leaf_entry);
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 402f00326b64..d87cd71e3cf1 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -72,7 +72,6 @@ struct xfs_dir_ops {
>  	struct xfs_dir2_data_unused *
>  		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
>  
> -	int	free_hdr_size;
>  	int	(*free_max_bests)(struct xfs_da_geometry *geo);
>  	xfs_dir2_db_t (*db_to_fdb)(struct xfs_da_geometry *geo,
>  				   xfs_dir2_db_t db);
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index eff7cfeb19b9..7047d1e066f9 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -372,7 +372,7 @@ xfs_dir2_free_log_header(
>  	       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
>  #endif
>  	xfs_trans_log_buf(args->trans, bp, 0,
> -			  args->dp->d_ops->free_hdr_size - 1);
> +			  args->geo->free_hdr_size - 1);
>  }
>  
>  /*
> -- 
> 2.20.1
> 
