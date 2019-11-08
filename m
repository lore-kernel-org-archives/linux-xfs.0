Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD41C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC67220674
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:34:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sz3FbYJC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfKHAev (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:34:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38392 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKHAev (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:34:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80XtJN155570;
        Fri, 8 Nov 2019 00:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=r1VUwIks8+wL69mHBmUcJZWzeNDERHxMpOxnqCu7hWU=;
 b=Sz3FbYJC2s/qakTqNRhez94Nfyb/Pmq/IlNTAQ62zwEI/yglrXbwE8IyMBWBSdSGyT+B
 avsbKWGiltmdBtjHxyj7SD0xLYjXNzSYyeleIiPzulXvOH1N/FHlqR1djvAGzJbHQ8W+
 RYuyrH/MCB6kIWvosqLgp9na9ErAZWtRmWZu1LMSoCd6s8y8DaOHF2QYGFawnhr9MGt1
 GfC4v8+Xy5q2POeKi0H0B6PWOraUv2ak7otJH9+tcFSAGe1tzg/Hm+C98FEAhYCtSpmD
 xf8/gZxDOaHz04n0tSXGDRpyFD8T+1hokS6EXW7T1vZyOAYrXcxLaVguPeTrdbgLhG/M 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w41w11uxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:34:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80XT8d114616;
        Fri, 8 Nov 2019 00:34:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2w41wjkncj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:34:44 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA80YiB4022097;
        Fri, 8 Nov 2019 00:34:44 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:34:43 -0800
Date:   Thu, 7 Nov 2019 16:34:43 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/46] xfs: move the dir2 free header size to struct
 xfs_da_geometry
Message-ID: <20191108003443.GU6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-18-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-18-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:23:41PM +0100, Christoph Hellwig wrote:
> Move the free header size towards our structure for dir/attr geometry
> parameters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice and short,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_btree.h  | 1 +
>  fs/xfs/libxfs/xfs_da_format.c | 3 ---
>  fs/xfs/libxfs/xfs_dir2.c      | 2 ++
>  fs/xfs/libxfs/xfs_dir2.h      | 1 -
>  fs/xfs/libxfs/xfs_dir2_node.c | 2 +-
>  5 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index c6ff5329e92b..e8f0b7ac051c 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -29,6 +29,7 @@ struct xfs_da_geometry {
>  	unsigned int	leaf_hdr_size;	/* dir2 leaf header size */
>  	unsigned int	leaf_max_ents;	/* # of entries in dir2 leaf */
>  	xfs_dablk_t	leafblk;	/* blockno of leaf data v2 */
> +	unsigned int	free_hdr_size;	/* dir2 free header size */
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
> index 8093afb389a1..eee75ec9707f 100644
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
> index e9b4667faeac..c9a52e4e515d 100644
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
