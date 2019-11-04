Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6FDCA9ED3
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E63120869
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q6WzlcrG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfKDUtn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:49:43 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34478 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbfKDUtm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:49:42 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KnICn148119;
        Mon, 4 Nov 2019 20:49:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=+gvp4cpjojVzVIBdXKDKmFzPSix1YH42Cg4G5RdTBPM=;
 b=q6WzlcrGbT0FnhLZ1XHiD1QN58+1A+Z1DxzSxRh4aI+VUswhJtivT4Zi4/XZ5WPt7wjx
 oLGpZTDtYPtMokVr+cQbK9RN7y7OfsAVo0IKuYTBaBKk54hqwP6jYJ1ziefUgHJFU9Ic
 WnQzeNxrIIhSzgzZbgarUuAq7YGymcDiJ+Tnw/0K+y486vrONyi8SJMVuvvEJc9Juf43
 pQBZuxm09V978chYRg/WvVWvHon+d3s7WHZKfx8bsNxImQrYStVSJjlXtWSg1Y00xd99
 2mmjfLqyx8Rj/dSY6DwNXnBqLdUyW7Qd6FLfbqaLLAXxbnX9gvd1AZjVkwC3G5COjEp+ vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w117tt22c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:49:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KnZGL190918;
        Mon, 4 Nov 2019 20:49:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w1kacat6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:49:34 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4KnPs9013374;
        Mon, 4 Nov 2019 20:49:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:49:25 -0800
Date:   Mon, 4 Nov 2019 12:49:24 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 30/34] xfs: devirtualize ->data_bestfree_p
Message-ID: <20191104204924.GF4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-31-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-31-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040201
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040201
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:07:15PM -0700, Christoph Hellwig wrote:
> Replace the ->data_bestfree_p dir ops method with a directly called
> xfs_dir2_data_bestfree_p helper that takes care of the differences
> between the v4 and v5 on-disk format.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Woot!
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c  | 15 ---------------
>  fs/xfs/libxfs/xfs_dir2.h       |  3 ---
>  fs/xfs/libxfs/xfs_dir2_block.c |  6 +++---
>  fs/xfs/libxfs/xfs_dir2_data.c  | 23 ++++++++++++++++-------
>  fs/xfs/libxfs/xfs_dir2_leaf.c  | 11 ++++++-----
>  fs/xfs/libxfs/xfs_dir2_node.c  |  6 +++---
>  fs/xfs/libxfs/xfs_dir2_priv.h  |  2 ++
>  fs/xfs/scrub/dir.c             |  7 ++-----
>  8 files changed, 32 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index dd2389748672..b9f9fbf7eee2 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -56,34 +56,19 @@ xfs_dir3_data_put_ftype(
>  	dep->name[dep->namelen] = type;
>  }
>  
> -static struct xfs_dir2_data_free *
> -xfs_dir2_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
> -{
> -	return hdr->bestfree;
> -}
> -
> -static struct xfs_dir2_data_free *
> -xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
> -{
> -	return ((struct xfs_dir3_data_hdr *)hdr)->best_free;
> -}
> -
>  static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_get_ftype = xfs_dir2_data_get_ftype,
>  	.data_put_ftype = xfs_dir2_data_put_ftype,
> -	.data_bestfree_p = xfs_dir2_data_bestfree_p,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.data_get_ftype = xfs_dir3_data_get_ftype,
>  	.data_put_ftype = xfs_dir3_data_put_ftype,
> -	.data_bestfree_p = xfs_dir2_data_bestfree_p,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.data_get_ftype = xfs_dir3_data_get_ftype,
>  	.data_put_ftype = xfs_dir3_data_put_ftype,
> -	.data_bestfree_p = xfs_dir3_data_bestfree_p,
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 11dba3874da0..76d6d38154fb 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -35,8 +35,6 @@ struct xfs_dir_ops {
>  	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
>  	void	(*data_put_ftype)(struct xfs_dir2_data_entry *dep,
>  				uint8_t ftype);
> -	struct xfs_dir2_data_free *
> -		(*data_bestfree_p)(struct xfs_dir2_data_hdr *hdr);
>  };
>  
>  extern const struct xfs_dir_ops *
> @@ -81,7 +79,6 @@ extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
>  				struct xfs_buf *bp);
>  
>  extern void xfs_dir2_data_freescan_int(struct xfs_mount *mp,
> -		const struct xfs_dir_ops *ops,
>  		struct xfs_dir2_data_hdr *hdr, int *loghead);
>  extern void xfs_dir2_data_freescan(struct xfs_inode *dp,
>  		struct xfs_dir2_data_hdr *hdr, int *loghead);
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index d5f4b7187b72..50b4f1bf25a3 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -172,7 +172,7 @@ xfs_dir2_block_need_space(
>  	struct xfs_dir2_data_unused	*enddup = NULL;
>  
>  	*compact = 0;
> -	bf = dp->d_ops->data_bestfree_p(hdr);
> +	bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
>  
>  	/*
>  	 * If there are stale entries we'll use one for the leaf.
> @@ -1207,8 +1207,8 @@ xfs_dir2_sf_to_block(
>  				((char *)dup - (char *)hdr));
>  			xfs_dir2_data_log_unused(args, bp, dup);
>  			xfs_dir2_data_freeinsert(hdr,
> -						 dp->d_ops->data_bestfree_p(hdr),
> -						 dup, &dummy);
> +					xfs_dir2_data_bestfree_p(mp, hdr),
> +					dup, &dummy);
>  			offset += be16_to_cpu(dup->length);
>  			continue;
>  		}
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index c44c455b961f..353629c3a1e8 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -24,6 +24,16 @@ static xfs_failaddr_t xfs_dir2_data_freefind_verify(
>  		struct xfs_dir2_data_unused *dup,
>  		struct xfs_dir2_data_free **bf_ent);
>  
> +struct xfs_dir2_data_free *
> +xfs_dir2_data_bestfree_p(
> +	struct xfs_mount		*mp,
> +	struct xfs_dir2_data_hdr	*hdr)
> +{
> +	if (xfs_sb_version_hascrc(&mp->m_sb))
> +		return ((struct xfs_dir3_data_hdr *)hdr)->best_free;
> +	return hdr->bestfree;
> +}
> +
>  int
>  xfs_dir2_data_entsize(
>  	struct xfs_mount	*mp,
> @@ -130,7 +140,7 @@ __xfs_dir3_data_check(
>  	/*
>  	 * Account for zero bestfree entries.
>  	 */
> -	bf = ops->data_bestfree_p(hdr);
> +	bf = xfs_dir2_data_bestfree_p(mp, hdr);
>  	count = lastfree = freeseen = 0;
>  	if (!bf[0].length) {
>  		if (bf[0].offset)
> @@ -590,7 +600,6 @@ xfs_dir2_data_freeremove(
>  void
>  xfs_dir2_data_freescan_int(
>  	struct xfs_mount	*mp,
> -	const struct xfs_dir_ops *ops,
>  	struct xfs_dir2_data_hdr *hdr,
>  	int			*loghead)
>  {
> @@ -609,7 +618,7 @@ xfs_dir2_data_freescan_int(
>  	/*
>  	 * Start by clearing the table.
>  	 */
> -	bf = ops->data_bestfree_p(hdr);
> +	bf = xfs_dir2_data_bestfree_p(mp, hdr);
>  	memset(bf, 0, sizeof(*bf) * XFS_DIR2_DATA_FD_COUNT);
>  	*loghead = 1;
>  	/*
> @@ -650,7 +659,7 @@ xfs_dir2_data_freescan(
>  	struct xfs_dir2_data_hdr *hdr,
>  	int			*loghead)
>  {
> -	return xfs_dir2_data_freescan_int(dp->i_mount, dp->d_ops, hdr, loghead);
> +	return xfs_dir2_data_freescan_int(dp->i_mount, hdr, loghead);
>  }
>  
>  /*
> @@ -703,7 +712,7 @@ xfs_dir3_data_init(
>  	} else
>  		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);
>  
> -	bf = dp->d_ops->data_bestfree_p(hdr);
> +	bf = xfs_dir2_data_bestfree_p(mp, hdr);
>  	bf[0].offset = cpu_to_be16(args->geo->data_entry_offset);
>  	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
>  		bf[i].length = 0;
> @@ -862,7 +871,7 @@ xfs_dir2_data_make_free(
>  	 * Previous and following entries are both free,
>  	 * merge everything into a single free entry.
>  	 */
> -	bf = args->dp->d_ops->data_bestfree_p(hdr);
> +	bf = xfs_dir2_data_bestfree_p(args->dp->i_mount, hdr);
>  	if (prevdup && postdup) {
>  		xfs_dir2_data_free_t	*dfp2;	/* another bestfree pointer */
>  
> @@ -1053,7 +1062,7 @@ xfs_dir2_data_use_free(
>  	 * Look up the entry in the bestfree table.
>  	 */
>  	oldlen = be16_to_cpu(dup->length);
> -	bf = args->dp->d_ops->data_bestfree_p(hdr);
> +	bf = xfs_dir2_data_bestfree_p(args->dp->i_mount, hdr);
>  	dfp = xfs_dir2_data_freefind(hdr, bf, dup);
>  	ASSERT(dfp || oldlen <= be16_to_cpu(bf[2].length));
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index c228ff66b3f0..30ccf44d817a 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -425,7 +425,7 @@ xfs_dir2_block_to_leaf(
>  	xfs_dir3_data_check(dp, dbp);
>  	btp = xfs_dir2_block_tail_p(args->geo, hdr);
>  	blp = xfs_dir2_block_leaf_p(btp);
> -	bf = dp->d_ops->data_bestfree_p(hdr);
> +	bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
>  
>  	/*
>  	 * Set the counts in the leaf header.
> @@ -823,7 +823,7 @@ xfs_dir2_leaf_addname(
>  		else
>  			xfs_dir3_leaf_log_bests(args, lbp, use_block, use_block);
>  		hdr = dbp->b_addr;
> -		bf = dp->d_ops->data_bestfree_p(hdr);
> +		bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
>  		bestsp[use_block] = bf[0].length;
>  		grown = 1;
>  	} else {
> @@ -839,7 +839,7 @@ xfs_dir2_leaf_addname(
>  			return error;
>  		}
>  		hdr = dbp->b_addr;
> -		bf = dp->d_ops->data_bestfree_p(hdr);
> +		bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
>  		grown = 0;
>  	}
>  	/*
> @@ -1376,7 +1376,7 @@ xfs_dir2_leaf_removename(
>  	leaf = lbp->b_addr;
>  	hdr = dbp->b_addr;
>  	xfs_dir3_data_check(dp, dbp);
> -	bf = dp->d_ops->data_bestfree_p(hdr);
> +	bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
>  
>  	/*
>  	 * Point to the leaf entry, use that to point to the data entry.
> @@ -1618,7 +1618,8 @@ xfs_dir2_leaf_trim_data(
>  #ifdef DEBUG
>  {
>  	struct xfs_dir2_data_hdr *hdr = dbp->b_addr;
> -	struct xfs_dir2_data_free *bf = dp->d_ops->data_bestfree_p(hdr);
> +	struct xfs_dir2_data_free *bf =
> +		xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
>  
>  	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
>  	       hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 58362169aa57..d4a1d2455e72 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1311,7 +1311,7 @@ xfs_dir2_leafn_remove(
>  	dbp = dblk->bp;
>  	hdr = dbp->b_addr;
>  	dep = (xfs_dir2_data_entry_t *)((char *)hdr + off);
> -	bf = dp->d_ops->data_bestfree_p(hdr);
> +	bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
>  	longest = be16_to_cpu(bf[0].length);
>  	needlog = needscan = 0;
>  	xfs_dir2_data_make_free(args, dbp, off,
> @@ -1769,7 +1769,7 @@ xfs_dir2_node_add_datablk(
>  	}
>  
>  	/* Update the freespace value for the new block in the table. */
> -	bf = dp->d_ops->data_bestfree_p(dbp->b_addr);
> +	bf = xfs_dir2_data_bestfree_p(mp, dbp->b_addr);
>  	hdr->bests[*findex] = bf[0].length;
>  
>  	*dbpp = dbp;
> @@ -1942,7 +1942,7 @@ xfs_dir2_node_addname_int(
>  
>  	/* setup for data block up now */
>  	hdr = dbp->b_addr;
> -	bf = dp->d_ops->data_bestfree_p(hdr);
> +	bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
>  	ASSERT(be16_to_cpu(bf[0].length) >= length);
>  
>  	/* Point to the existing unused space. */
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 750344407f27..436693514c7c 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -47,6 +47,8 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
>  		struct xfs_buf *lbp, struct xfs_buf *dbp);
>  
>  /* xfs_dir2_data.c */
> +struct xfs_dir2_data_free *xfs_dir2_data_bestfree_p(struct xfs_mount *mp,
> +		struct xfs_dir2_data_hdr *hdr);
>  int xfs_dir2_data_entsize(struct xfs_mount *mp, int n);
>  __be16 *xfs_dir2_data_entry_tag_p(struct xfs_mount *mp,
>  		struct xfs_dir2_data_entry *dep);
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index d13c863d72a5..54772ad9a431 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -327,7 +327,6 @@ xchk_directory_data_bestfree(
>  	struct xfs_buf			*bp;
>  	struct xfs_dir2_data_free	*bf;
>  	struct xfs_mount		*mp = sc->mp;
> -	const struct xfs_dir_ops	*d_ops;
>  	char				*ptr;
>  	char				*endptr;
>  	u16				tag;
> @@ -338,8 +337,6 @@ xchk_directory_data_bestfree(
>  	int				offset;
>  	int				error;
>  
> -	d_ops = sc->ip->d_ops;
> -
>  	if (is_block) {
>  		/* dir block format */
>  		if (lblk != XFS_B_TO_FSBT(mp, XFS_DIR2_DATA_OFFSET))
> @@ -359,7 +356,7 @@ xchk_directory_data_bestfree(
>  		goto out_buf;
>  
>  	/* Do the bestfrees correspond to actual free space? */
> -	bf = d_ops->data_bestfree_p(bp->b_addr);
> +	bf = xfs_dir2_data_bestfree_p(mp, bp->b_addr);
>  	smallest_bestfree = UINT_MAX;
>  	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
>  		offset = be16_to_cpu(dfp->offset);
> @@ -466,7 +463,7 @@ xchk_directory_check_freesp(
>  {
>  	struct xfs_dir2_data_free	*dfp;
>  
> -	dfp = sc->ip->d_ops->data_bestfree_p(dbp->b_addr);
> +	dfp = xfs_dir2_data_bestfree_p(sc->mp, dbp->b_addr);
>  
>  	if (len != be16_to_cpu(dfp->length))
>  		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
> -- 
> 2.20.1
> 
