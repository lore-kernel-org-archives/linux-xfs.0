Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22C2CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9333B20848
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:24:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z2v7KngI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfKDUYR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:24:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34848 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfKDUYQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:24:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KNogI127260;
        Mon, 4 Nov 2019 20:24:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=i/5KtP+PmvL3nA2yBV8APuwjn5olNZUe2wTWuUYzd2s=;
 b=Z2v7KngIIUsmS3r94Cr4fbXFS4zAUju7p+nDX9Hnkbo7DFUylt2FsarOOG2tlElZWnQ7
 /Lb8Nl8MiTJXpuDThLUYlYFe0sOj6FAOVtJNZ52Ha1kInxpDLgVdSt+H9dVgis1MNWqc
 qQjEWBFHSvoE1leV9qOwb9Dz0BdN9hPS3ewHNAMkdciL+rh1C8woGHrv/4ocTQPNgNmV
 fefybdeONWRj7iniZ9CNfphOTaFWV7W0lXA5XMPdNManinitkJVyCH28ojTR7d5/x+BG
 Uxu9ML+9Z0t0rJ9dIm5JMkIu42hRjIaJwW+m9ihk0I9igzO8IuCs3bO2k/dRca8jNkGy nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w117tswy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:24:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KOCW6055722;
        Mon, 4 Nov 2019 20:24:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w1k8vev9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:24:11 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4KN8bQ002015;
        Mon, 4 Nov 2019 20:23:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:23:08 -0800
Date:   Mon, 4 Nov 2019 12:23:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/34] xfs: move the max dir2 free bests count to struct
 xfs_da_geometry
Message-ID: <20191104202307.GR4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-18-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-18-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040196
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040196
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:07:02PM -0700, Christoph Hellwig wrote:
> Move the max free bests count towards our structure for dir/attr
> geometry parameters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_btree.h  |  1 +
>  fs/xfs/libxfs/xfs_da_format.c | 29 ++++-------------------------
>  fs/xfs/libxfs/xfs_dir2.c      |  2 ++
>  fs/xfs/libxfs/xfs_dir2.h      |  1 -
>  fs/xfs/libxfs/xfs_dir2_node.c | 12 +++++-------
>  5 files changed, 12 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 3d0b1e97bf43..e3f4329ab882 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -30,6 +30,7 @@ struct xfs_da_geometry {
>  	unsigned int	leaf_max_ents;	/* # of entries in dir2 leaf */
>  	xfs_dablk_t	leafblk;	/* blockno of leaf data v2 */
>  	int		free_hdr_size;	/* dir2 free header size */
> +	unsigned int	free_max_bests;	/* # of bests entries in dir2 free */
>  	xfs_dablk_t	freeblk;	/* blockno of free data v2 */
>  };
>  
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 1fc8982c830f..d2d3144c1598 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -400,17 +400,6 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
>  		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
>  }
>  
> -
> -/*
> - * Directory free space block operations
> - */
> -static int
> -xfs_dir2_free_max_bests(struct xfs_da_geometry *geo)
> -{
> -	return (geo->blksize - sizeof(struct xfs_dir2_free_hdr)) /
> -		sizeof(xfs_dir2_data_off_t);
> -}
> -
>  /*
>   * Convert data space db to the corresponding free db.
>   */
> @@ -418,7 +407,7 @@ static xfs_dir2_db_t
>  xfs_dir2_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
>  {
>  	return xfs_dir2_byte_to_db(geo, XFS_DIR2_FREE_OFFSET) +
> -			(db / xfs_dir2_free_max_bests(geo));
> +			(db / geo->free_max_bests);
>  }
>  
>  /*
> @@ -427,14 +416,7 @@ xfs_dir2_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
>  static int
>  xfs_dir2_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
>  {
> -	return db % xfs_dir2_free_max_bests(geo);
> -}
> -
> -static int
> -xfs_dir3_free_max_bests(struct xfs_da_geometry *geo)
> -{
> -	return (geo->blksize - sizeof(struct xfs_dir3_free_hdr)) /
> -		sizeof(xfs_dir2_data_off_t);
> +	return db % geo->free_max_bests;
>  }
>  
>  /*
> @@ -444,7 +426,7 @@ static xfs_dir2_db_t
>  xfs_dir3_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
>  {
>  	return xfs_dir2_byte_to_db(geo, XFS_DIR2_FREE_OFFSET) +
> -			(db / xfs_dir3_free_max_bests(geo));
> +			(db / geo->free_max_bests);
>  }
>  
>  /*
> @@ -453,7 +435,7 @@ xfs_dir3_db_to_fdb(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
>  static int
>  xfs_dir3_db_to_fdindex(struct xfs_da_geometry *geo, xfs_dir2_db_t db)
>  {
> -	return db % xfs_dir3_free_max_bests(geo);
> +	return db % geo->free_max_bests;
>  }
>  
>  static const struct xfs_dir_ops xfs_dir2_ops = {
> @@ -486,7 +468,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  
> -	.free_max_bests = xfs_dir2_free_max_bests,
>  	.db_to_fdb = xfs_dir2_db_to_fdb,
>  	.db_to_fdindex = xfs_dir2_db_to_fdindex,
>  };
> @@ -521,7 +502,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  
> -	.free_max_bests = xfs_dir2_free_max_bests,
>  	.db_to_fdb = xfs_dir2_db_to_fdb,
>  	.db_to_fdindex = xfs_dir2_db_to_fdindex,
>  };
> @@ -556,7 +536,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.data_entry_p = xfs_dir3_data_entry_p,
>  	.data_unused_p = xfs_dir3_data_unused_p,
>  
> -	.free_max_bests = xfs_dir3_free_max_bests,
>  	.db_to_fdb = xfs_dir3_db_to_fdb,
>  	.db_to_fdindex = xfs_dir3_db_to_fdindex,
>  };
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 13ac228bfc86..6c46893af17e 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -133,6 +133,8 @@ xfs_da_mount(
>  	}
>  	dageo->leaf_max_ents = (dageo->blksize - dageo->leaf_hdr_size) /
>  			sizeof(struct xfs_dir2_leaf_entry);
> +	dageo->free_max_bests = (dageo->blksize - dageo->free_hdr_size) /
> +			sizeof(xfs_dir2_data_off_t);
>  
>  	/*
>  	 * Now we've set up the block conversion variables, we can calculate the
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index d87cd71e3cf1..e3c1385d1522 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -72,7 +72,6 @@ struct xfs_dir_ops {
>  	struct xfs_dir2_data_unused *
>  		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
>  
> -	int	(*free_max_bests)(struct xfs_da_geometry *geo);
>  	xfs_dir2_db_t (*db_to_fdb)(struct xfs_da_geometry *geo,
>  				   xfs_dir2_db_t db);
>  	int	(*db_to_fdindex)(struct xfs_da_geometry *geo,
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 7047d1e066f9..0fcd7351038e 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -160,10 +160,9 @@ xfs_dir3_free_header_check(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
> +	int			maxbests = mp->m_dir_geo->free_max_bests;
>  	unsigned int		firstdb;
> -	int			maxbests;
>  
> -	maxbests = dp->d_ops->free_max_bests(mp->m_dir_geo);
>  	firstdb = (xfs_dir2_da_to_db(mp->m_dir_geo, fbno) -
>  		   xfs_dir2_byte_to_db(mp->m_dir_geo, XFS_DIR2_FREE_OFFSET)) *
>  			maxbests;
> @@ -558,8 +557,7 @@ xfs_dir2_free_hdr_check(
>  
>  	xfs_dir2_free_hdr_from_disk(dp->i_mount, &hdr, bp->b_addr);
>  
> -	ASSERT((hdr.firstdb %
> -		dp->d_ops->free_max_bests(dp->i_mount->m_dir_geo)) == 0);
> +	ASSERT((hdr.firstdb % dp->i_mount->m_dir_geo->free_max_bests) == 0);
>  	ASSERT(hdr.firstdb <= db);
>  	ASSERT(db < hdr.firstdb + hdr.nvalid);
>  }
> @@ -1334,7 +1332,7 @@ xfs_dir2_leafn_remove(
>  		struct xfs_dir3_icfree_hdr freehdr;
>  
>  		xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
> -		ASSERT(freehdr.firstdb == dp->d_ops->free_max_bests(args->geo) *
> +		ASSERT(freehdr.firstdb == args->geo->free_max_bests *
>  			(fdb - xfs_dir2_byte_to_db(args->geo,
>  						   XFS_DIR2_FREE_OFFSET)));
>  	}
> @@ -1727,7 +1725,7 @@ xfs_dir2_node_add_datablk(
>  		/* Remember the first slot as our empty slot. */
>  		hdr->firstdb = (fbno - xfs_dir2_byte_to_db(args->geo,
>  							XFS_DIR2_FREE_OFFSET)) *
> -				dp->d_ops->free_max_bests(args->geo);
> +				args->geo->free_max_bests;
>  	} else {
>  		xfs_dir2_free_hdr_from_disk(mp, hdr, fbp->b_addr);
>  	}
> @@ -1737,7 +1735,7 @@ xfs_dir2_node_add_datablk(
>  
>  	/* Extend the freespace table if the new data block is off the end. */
>  	if (*findex >= hdr->nvalid) {
> -		ASSERT(*findex < dp->d_ops->free_max_bests(args->geo));
> +		ASSERT(*findex < args->geo->free_max_bests);
>  		hdr->nvalid = *findex + 1;
>  		hdr->bests[*findex] = cpu_to_be16(NULLDATAOFF);
>  	}
> -- 
> 2.20.1
> 
