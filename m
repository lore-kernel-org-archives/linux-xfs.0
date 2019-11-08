Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC85C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A3BA20674
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:34:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PhLZctxK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfKHAeZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:34:25 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55874 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKHAeY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:34:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80XmZP142812;
        Fri, 8 Nov 2019 00:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Qp8Z7vQWK0J/2oKYKmSZFC5boPpj/v1qCfdYmytT/ww=;
 b=PhLZctxKrQYzeNr5U/g22m9WpiHZgVCfzGu+dIcZDUekDYI0g6Gx+g1hx7ejcc9Hx2jF
 48tDH2vBOoV85riaYXSVjTzEntH7yOfoNyNsGQnLch6p2jLOFHngZzoahCZKk0ucXoZ7
 160Kqcr+kMTOo7O8xw+o9BATblbTYdxCGSEJeyB3JCYulAmj+7du0hK1REX4N1AN0sU4
 u85iprOoyDcA8A58PkR3fZFofY4P+BiVa9xswwRub+D4BPDjgFuogM2w/72SrSeQ512q
 lFw/cUYouKQWRlhg/6asHIA2BPLj3aOd5UkBbIvC6q/1i4I7iukB4nugkYSHZpAIQddS RA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w41w11w0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:34:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80XUNO114637;
        Fri, 8 Nov 2019 00:34:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w41wjkmfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:34:13 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA80YCLh027749;
        Fri, 8 Nov 2019 00:34:12 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:34:12 -0800
Date:   Thu, 7 Nov 2019 16:34:11 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/46] xfs: add a bests pointer to struct
 xfs_dir3_icfree_hdr
Message-ID: <20191108003411.GT6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-17-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-17-hch@lst.de>
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

On Thu, Nov 07, 2019 at 07:23:40PM +0100, Christoph Hellwig wrote:
> All but two callers of the ->free_bests_p dir operation already have a
> struct xfs_dir3_icfree_hdr from a previous call to
> xfs_dir2_free_hdr_from_disk at hand.  Add a pointer to the bests to
> struct xfs_dir3_icfree_hdr to clean up this pattern.  To optimize this
> pattern, pass the struct xfs_dir3_icfree_hdr to xfs_dir2_free_log_bests
> instead of recalculating the pointer there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, AFAICT...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c | 15 ------
>  fs/xfs/libxfs/xfs_dir2.h      |  1 -
>  fs/xfs/libxfs/xfs_dir2_leaf.c |  6 +--
>  fs/xfs/libxfs/xfs_dir2_node.c | 97 ++++++++++++++---------------------
>  fs/xfs/libxfs/xfs_dir2_priv.h |  6 +++
>  fs/xfs/scrub/dir.c            |  6 +--
>  6 files changed, 48 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index b943d9443d55..7263b6d6a135 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -411,12 +411,6 @@ xfs_dir2_free_max_bests(struct xfs_da_geometry *geo)
>  		sizeof(xfs_dir2_data_off_t);
>  }
>  
> -static __be16 *
> -xfs_dir2_free_bests_p(struct xfs_dir2_free *free)
> -{
> -	return (__be16 *)((char *)free + sizeof(struct xfs_dir2_free_hdr));
> -}
> -
>  /*
>   * Convert data space db to the corresponding free db.
>   */
> @@ -443,12 +437,6 @@ xfs_dir3_free_max_bests(struct xfs_da_geometry *geo)
>  		sizeof(xfs_dir2_data_off_t);
>  }
>  
> -static __be16 *
> -xfs_dir3_free_bests_p(struct xfs_dir2_free *free)
> -{
> -	return (__be16 *)((char *)free + sizeof(struct xfs_dir3_free_hdr));
> -}
> -
>  /*
>   * Convert data space db to the corresponding free db.
>   */
> @@ -500,7 +488,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_max_bests = xfs_dir2_free_max_bests,
> -	.free_bests_p = xfs_dir2_free_bests_p,
>  	.db_to_fdb = xfs_dir2_db_to_fdb,
>  	.db_to_fdindex = xfs_dir2_db_to_fdindex,
>  };
> @@ -537,7 +524,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_max_bests = xfs_dir2_free_max_bests,
> -	.free_bests_p = xfs_dir2_free_bests_p,
>  	.db_to_fdb = xfs_dir2_db_to_fdb,
>  	.db_to_fdindex = xfs_dir2_db_to_fdindex,
>  };
> @@ -574,7 +560,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  
>  	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
>  	.free_max_bests = xfs_dir3_free_max_bests,
> -	.free_bests_p = xfs_dir3_free_bests_p,
>  	.db_to_fdb = xfs_dir3_db_to_fdb,
>  	.db_to_fdindex = xfs_dir3_db_to_fdindex,
>  };
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 613a78281d03..402f00326b64 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -74,7 +74,6 @@ struct xfs_dir_ops {
>  
>  	int	free_hdr_size;
>  	int	(*free_max_bests)(struct xfs_da_geometry *geo);
> -	__be16 * (*free_bests_p)(struct xfs_dir2_free *free);
>  	xfs_dir2_db_t (*db_to_fdb)(struct xfs_da_geometry *geo,
>  				   xfs_dir2_db_t db);
>  	int	(*db_to_fdindex)(struct xfs_da_geometry *geo,
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index b435379ddaa2..bbbd7b96678a 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -1680,7 +1680,6 @@ xfs_dir2_node_to_leaf(
>  	int			error;		/* error return code */
>  	struct xfs_buf		*fbp;		/* buffer for freespace block */
>  	xfs_fileoff_t		fo;		/* freespace file offset */
> -	xfs_dir2_free_t		*free;		/* freespace structure */
>  	struct xfs_buf		*lbp;		/* buffer for leaf block */
>  	xfs_dir2_leaf_tail_t	*ltp;		/* tail of leaf structure */
>  	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
> @@ -1749,8 +1748,7 @@ xfs_dir2_node_to_leaf(
>  	error = xfs_dir2_free_read(tp, dp,  args->geo->freeblk, &fbp);
>  	if (error)
>  		return error;
> -	free = fbp->b_addr;
> -	xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
> +	xfs_dir2_free_hdr_from_disk(mp, &freehdr, fbp->b_addr);
>  
>  	ASSERT(!freehdr.firstdb);
>  
> @@ -1784,7 +1782,7 @@ xfs_dir2_node_to_leaf(
>  	/*
>  	 * Set up the leaf bests table.
>  	 */
> -	memcpy(xfs_dir2_leaf_bests_p(ltp), dp->d_ops->free_bests_p(free),
> +	memcpy(xfs_dir2_leaf_bests_p(ltp), freehdr.bests,
>  		freehdr.nvalid * sizeof(xfs_dir2_data_off_t));
>  
>  	xfs_dir2_leaf_hdr_to_disk(mp, leaf, &leafhdr);
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 6d67ceac48b7..e9b4667faeac 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -233,6 +233,7 @@ xfs_dir2_free_hdr_from_disk(
>  		to->firstdb = be32_to_cpu(from3->hdr.firstdb);
>  		to->nvalid = be32_to_cpu(from3->hdr.nvalid);
>  		to->nused = be32_to_cpu(from3->hdr.nused);
> +		to->bests = from3->bests;
>  
>  		ASSERT(to->magic == XFS_DIR3_FREE_MAGIC);
>  	} else {
> @@ -240,6 +241,8 @@ xfs_dir2_free_hdr_from_disk(
>  		to->firstdb = be32_to_cpu(from->hdr.firstdb);
>  		to->nvalid = be32_to_cpu(from->hdr.nvalid);
>  		to->nused = be32_to_cpu(from->hdr.nused);
> +		to->bests = from->bests;
> +
>  		ASSERT(to->magic == XFS_DIR2_FREE_MAGIC);
>  	}
>  }
> @@ -338,21 +341,19 @@ xfs_dir3_free_get_buf(
>  STATIC void
>  xfs_dir2_free_log_bests(
>  	struct xfs_da_args	*args,
> +	struct xfs_dir3_icfree_hdr *hdr,
>  	struct xfs_buf		*bp,
>  	int			first,		/* first entry to log */
>  	int			last)		/* last entry to log */
>  {
> -	xfs_dir2_free_t		*free;		/* freespace structure */
> -	__be16			*bests;
> +	struct xfs_dir2_free	*free = bp->b_addr;
>  
> -	free = bp->b_addr;
> -	bests = args->dp->d_ops->free_bests_p(free);
>  	ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
>  	       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
>  	xfs_trans_log_buf(args->trans, bp,
> -		(uint)((char *)&bests[first] - (char *)free),
> -		(uint)((char *)&bests[last] - (char *)free +
> -		       sizeof(bests[0]) - 1));
> +			  (char *)&hdr->bests[first] - (char *)free,
> +			  (char *)&hdr->bests[last] - (char *)free +
> +			   sizeof(hdr->bests[0]) - 1);
>  }
>  
>  /*
> @@ -388,14 +389,12 @@ xfs_dir2_leaf_to_node(
>  	int			error;		/* error return value */
>  	struct xfs_buf		*fbp;		/* freespace buffer */
>  	xfs_dir2_db_t		fdb;		/* freespace block number */
> -	xfs_dir2_free_t		*free;		/* freespace structure */
>  	__be16			*from;		/* pointer to freespace entry */
>  	int			i;		/* leaf freespace index */
>  	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
>  	xfs_dir2_leaf_tail_t	*ltp;		/* leaf tail structure */
>  	int			n;		/* count of live freespc ents */
>  	xfs_dir2_data_off_t	off;		/* freespace entry value */
> -	__be16			*to;		/* pointer to freespace entry */
>  	xfs_trans_t		*tp;		/* transaction pointer */
>  	struct xfs_dir3_icfree_hdr freehdr;
>  
> @@ -417,8 +416,7 @@ xfs_dir2_leaf_to_node(
>  	if (error)
>  		return error;
>  
> -	free = fbp->b_addr;
> -	xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
> +	xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, fbp->b_addr);
>  	leaf = lbp->b_addr;
>  	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
>  	if (be32_to_cpu(ltp->bestcount) >
> @@ -432,11 +430,11 @@ xfs_dir2_leaf_to_node(
>  	 * Count active entries.
>  	 */
>  	from = xfs_dir2_leaf_bests_p(ltp);
> -	to = dp->d_ops->free_bests_p(free);
> -	for (i = n = 0; i < be32_to_cpu(ltp->bestcount); i++, from++, to++) {
> -		if ((off = be16_to_cpu(*from)) != NULLDATAOFF)
> +	for (i = n = 0; i < be32_to_cpu(ltp->bestcount); i++, from++) {
> +		off = be16_to_cpu(*from);
> +		if (off != NULLDATAOFF)
>  			n++;
> -		*to = cpu_to_be16(off);
> +		freehdr.bests[i] = cpu_to_be16(off);
>  	}
>  
>  	/*
> @@ -446,7 +444,7 @@ xfs_dir2_leaf_to_node(
>  	freehdr.nvalid = be32_to_cpu(ltp->bestcount);
>  
>  	xfs_dir2_free_hdr_to_disk(dp->i_mount, fbp->b_addr, &freehdr);
> -	xfs_dir2_free_log_bests(args, fbp, 0, freehdr.nvalid - 1);
> +	xfs_dir2_free_log_bests(args, &freehdr, fbp, 0, freehdr.nvalid - 1);
>  	xfs_dir2_free_log_header(args, fbp);
>  
>  	/*
> @@ -677,7 +675,7 @@ xfs_dir2_leafn_lookup_for_addname(
>  		 * in hand, take a look at it.
>  		 */
>  		if (newdb != curdb) {
> -			__be16 *bests;
> +			struct xfs_dir3_icfree_hdr freehdr;
>  
>  			curdb = newdb;
>  			/*
> @@ -712,8 +710,9 @@ xfs_dir2_leafn_lookup_for_addname(
>  			/*
>  			 * If it has room, return it.
>  			 */
> -			bests = dp->d_ops->free_bests_p(free);
> -			if (unlikely(bests[fi] == cpu_to_be16(NULLDATAOFF))) {
> +			xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
> +			if (unlikely(freehdr.bests[fi] ==
> +				     cpu_to_be16(NULLDATAOFF))) {
>  				XFS_ERROR_REPORT("xfs_dir2_leafn_lookup_int",
>  							XFS_ERRLEVEL_LOW, mp);
>  				if (curfdb != newfdb)
> @@ -721,7 +720,7 @@ xfs_dir2_leafn_lookup_for_addname(
>  				return -EFSCORRUPTED;
>  			}
>  			curfdb = newfdb;
> -			if (be16_to_cpu(bests[fi]) >= length)
> +			if (be16_to_cpu(freehdr.bests[fi]) >= length)
>  				goto out;
>  		}
>  	}
> @@ -1168,19 +1167,17 @@ xfs_dir3_data_block_free(
>  	int			longest)
>  {
>  	int			logfree = 0;
> -	__be16			*bests;
>  	struct xfs_dir3_icfree_hdr freehdr;
>  	struct xfs_inode	*dp = args->dp;
>  
>  	xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
> -	bests = dp->d_ops->free_bests_p(free);
>  	if (hdr) {
>  		/*
>  		 * Data block is not empty, just set the free entry to the new
>  		 * value.
>  		 */
> -		bests[findex] = cpu_to_be16(longest);
> -		xfs_dir2_free_log_bests(args, fbp, findex, findex);
> +		freehdr.bests[findex] = cpu_to_be16(longest);
> +		xfs_dir2_free_log_bests(args, &freehdr, fbp, findex, findex);
>  		return 0;
>  	}
>  
> @@ -1196,14 +1193,14 @@ xfs_dir3_data_block_free(
>  		int	i;		/* free entry index */
>  
>  		for (i = findex - 1; i >= 0; i--) {
> -			if (bests[i] != cpu_to_be16(NULLDATAOFF))
> +			if (freehdr.bests[i] != cpu_to_be16(NULLDATAOFF))
>  				break;
>  		}
>  		freehdr.nvalid = i + 1;
>  		logfree = 0;
>  	} else {
>  		/* Not the last entry, just punch it out.  */
> -		bests[findex] = cpu_to_be16(NULLDATAOFF);
> +		freehdr.bests[findex] = cpu_to_be16(NULLDATAOFF);
>  		logfree = 1;
>  	}
>  
> @@ -1232,7 +1229,7 @@ xfs_dir3_data_block_free(
>  
>  	/* Log the free entry that changed, unless we got rid of it.  */
>  	if (logfree)
> -		xfs_dir2_free_log_bests(args, fbp, findex, findex);
> +		xfs_dir2_free_log_bests(args, &freehdr, fbp, findex, findex);
>  	return 0;
>  }
>  
> @@ -1673,11 +1670,9 @@ xfs_dir2_node_add_datablk(
>  	struct xfs_trans	*tp = args->trans;
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_dir2_data_free *bf;
> -	struct xfs_dir2_free	*free = NULL;
>  	xfs_dir2_db_t		fbno;
>  	struct xfs_buf		*fbp;
>  	struct xfs_buf		*dbp;
> -	__be16			*bests = NULL;
>  	int			error;
>  
>  	/* Not allowed to allocate, return failure. */
> @@ -1733,18 +1728,14 @@ xfs_dir2_node_add_datablk(
>  		error = xfs_dir3_free_get_buf(args, fbno, &fbp);
>  		if (error)
>  			return error;
> -		free = fbp->b_addr;
> -		bests = dp->d_ops->free_bests_p(free);
> -		xfs_dir2_free_hdr_from_disk(mp, hdr, free);
> +		xfs_dir2_free_hdr_from_disk(mp, hdr, fbp->b_addr);
>  
>  		/* Remember the first slot as our empty slot. */
>  		hdr->firstdb = (fbno - xfs_dir2_byte_to_db(args->geo,
>  							XFS_DIR2_FREE_OFFSET)) *
>  				dp->d_ops->free_max_bests(args->geo);
>  	} else {
> -		free = fbp->b_addr;
> -		bests = dp->d_ops->free_bests_p(free);
> -		xfs_dir2_free_hdr_from_disk(mp, hdr, free);
> +		xfs_dir2_free_hdr_from_disk(mp, hdr, fbp->b_addr);
>  	}
>  
>  	/* Set the freespace block index from the data block number. */
> @@ -1754,14 +1745,14 @@ xfs_dir2_node_add_datablk(
>  	if (*findex >= hdr->nvalid) {
>  		ASSERT(*findex < dp->d_ops->free_max_bests(args->geo));
>  		hdr->nvalid = *findex + 1;
> -		bests[*findex] = cpu_to_be16(NULLDATAOFF);
> +		hdr->bests[*findex] = cpu_to_be16(NULLDATAOFF);
>  	}
>  
>  	/*
>  	 * If this entry was for an empty data block (this should always be
>  	 * true) then update the header.
>  	 */
> -	if (bests[*findex] == cpu_to_be16(NULLDATAOFF)) {
> +	if (hdr->bests[*findex] == cpu_to_be16(NULLDATAOFF)) {
>  		hdr->nused++;
>  		xfs_dir2_free_hdr_to_disk(mp, fbp->b_addr, hdr);
>  		xfs_dir2_free_log_header(args, fbp);
> @@ -1769,7 +1760,7 @@ xfs_dir2_node_add_datablk(
>  
>  	/* Update the freespace value for the new block in the table. */
>  	bf = dp->d_ops->data_bestfree_p(dbp->b_addr);
> -	bests[*findex] = bf[0].length;
> +	hdr->bests[*findex] = bf[0].length;
>  
>  	*dbpp = dbp;
>  	*fbpp = fbp;
> @@ -1786,7 +1777,6 @@ xfs_dir2_node_find_freeblk(
>  	int			*findexp,
>  	int			length)
>  {
> -	struct xfs_dir2_free	*free = NULL;
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_trans	*tp = args->trans;
>  	struct xfs_buf		*fbp = NULL;
> @@ -1796,7 +1786,6 @@ xfs_dir2_node_find_freeblk(
>  	xfs_dir2_db_t		dbno = -1;
>  	xfs_dir2_db_t		fbno;
>  	xfs_fileoff_t		fo;
> -	__be16			*bests = NULL;
>  	int			findex = 0;
>  	int			error;
>  
> @@ -1807,16 +1796,13 @@ xfs_dir2_node_find_freeblk(
>  	 */
>  	if (fblk) {
>  		fbp = fblk->bp;
> -		free = fbp->b_addr;
>  		findex = fblk->index;
> +		xfs_dir2_free_hdr_from_disk(dp->i_mount, hdr, fbp->b_addr);
>  		if (findex >= 0) {
>  			/* caller already found the freespace for us. */
> -			bests = dp->d_ops->free_bests_p(free);
> -			xfs_dir2_free_hdr_from_disk(dp->i_mount, hdr, free);
> -
>  			ASSERT(findex < hdr->nvalid);
> -			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
> -			ASSERT(be16_to_cpu(bests[findex]) >= length);
> +			ASSERT(be16_to_cpu(hdr->bests[findex]) != NULLDATAOFF);
> +			ASSERT(be16_to_cpu(hdr->bests[findex]) >= length);
>  			dbno = hdr->firstdb + findex;
>  			goto found_block;
>  		}
> @@ -1859,14 +1845,12 @@ xfs_dir2_node_find_freeblk(
>  		if (!fbp)
>  			continue;
>  
> -		free = fbp->b_addr;
> -		bests = dp->d_ops->free_bests_p(free);
> -		xfs_dir2_free_hdr_from_disk(dp->i_mount, hdr, free);
> +		xfs_dir2_free_hdr_from_disk(dp->i_mount, hdr, fbp->b_addr);
>  
>  		/* Scan the free entry array for a large enough free space. */
>  		for (findex = hdr->nvalid - 1; findex >= 0; findex--) {
> -			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
> -			    be16_to_cpu(bests[findex]) >= length) {
> +			if (be16_to_cpu(hdr->bests[findex]) != NULLDATAOFF &&
> +			    be16_to_cpu(hdr->bests[findex]) >= length) {
>  				dbno = hdr->firstdb + findex;
>  				goto found_block;
>  			}
> @@ -1883,7 +1867,6 @@ xfs_dir2_node_find_freeblk(
>  	return 0;
>  }
>  
> -
>  /*
>   * Add the data entry for a node-format directory name addition.
>   * The leaf entry is added in xfs_dir2_leafn_add.
> @@ -1898,7 +1881,6 @@ xfs_dir2_node_addname_int(
>  	struct xfs_dir2_data_entry *dep;	/* data entry pointer */
>  	struct xfs_dir2_data_hdr *hdr;		/* data block header */
>  	struct xfs_dir2_data_free *bf;
> -	struct xfs_dir2_free	*free = NULL;	/* freespace block structure */
>  	struct xfs_trans	*tp = args->trans;
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_dir3_icfree_hdr freehdr;
> @@ -1913,7 +1895,6 @@ xfs_dir2_node_addname_int(
>  	int			needlog = 0;	/* need to log data header */
>  	int			needscan = 0;	/* need to rescan data frees */
>  	__be16			*tagp;		/* data entry tag pointer */
> -	__be16			*bests;
>  
>  	length = dp->d_ops->data_entsize(args->namelen);
>  	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &freehdr,
> @@ -1984,16 +1965,14 @@ xfs_dir2_node_addname_int(
>  		xfs_dir2_data_log_header(args, dbp);
>  
>  	/* If the freespace block entry is now wrong, update it. */
> -	free = fbp->b_addr;
> -	bests = dp->d_ops->free_bests_p(free);
> -	if (bests[findex] != bf[0].length) {
> -		bests[findex] = bf[0].length;
> +	if (freehdr.bests[findex] != bf[0].length) {
> +		freehdr.bests[findex] = bf[0].length;
>  		logfree = 1;
>  	}
>  
>  	/* Log the freespace entry if needed. */
>  	if (logfree)
> -		xfs_dir2_free_log_bests(args, fbp, findex, findex);
> +		xfs_dir2_free_log_bests(args, &freehdr, fbp, findex, findex);
>  
>  	/* Return the data block and offset in args. */
>  	args->blkno = (xfs_dablk_t)dbno;
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 2c3370a3c010..9128f7aae0be 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -31,6 +31,12 @@ struct xfs_dir3_icfree_hdr {
>  	uint32_t		firstdb;
>  	uint32_t		nvalid;
>  	uint32_t		nused;
> +
> +	/*
> +	 * Pointer to the on-disk format entries, which are behind the
> +	 * variable size (v4 vs v5) header in the on-disk block.
> +	 */
> +	__be16			*bests;
>  };
>  
>  /* xfs_dir2.c */
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index b0af252dccb3..bb08a1cbe523 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -580,7 +580,6 @@ xchk_directory_free_bestfree(
>  	struct xfs_dir3_icfree_hdr	freehdr;
>  	struct xfs_buf			*dbp;
>  	struct xfs_buf			*bp;
> -	__be16				*bestp;
>  	__u16				best;
>  	unsigned int			stale = 0;
>  	int				i;
> @@ -601,9 +600,8 @@ xchk_directory_free_bestfree(
>  
>  	/* Check all the entries. */
>  	xfs_dir2_free_hdr_from_disk(sc->ip->i_mount, &freehdr, bp->b_addr);
> -	bestp = sc->ip->d_ops->free_bests_p(bp->b_addr);
> -	for (i = 0; i < freehdr.nvalid; i++, bestp++) {
> -		best = be16_to_cpu(*bestp);
> +	for (i = 0; i < freehdr.nvalid; i++) {
> +		best = be16_to_cpu(freehdr.bests[i]);
>  		if (best == NULLDATAOFF) {
>  			stale++;
>  			continue;
> -- 
> 2.20.1
> 
