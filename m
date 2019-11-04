Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B29CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3835020869
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:47:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ny0mbSn/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfKDUrj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:47:39 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60358 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728392AbfKDUrj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:47:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KiDev143998;
        Mon, 4 Nov 2019 20:47:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=hKgozsscEBnoRmL7HwLUcE1ujgIODg4ziebtPnM3yD4=;
 b=ny0mbSn/SeWVfXdNMhL4JJ50wfxRZml8KxSIzetSCQ9bqtMRDSaFYnna1zth6d+exE48
 wQLjnIuQLwwSQk/XNZz9bStGEDLqZp2AowPLUMmZSpQNlNCnFuoA6tN2giqPVt0qc8tE
 pmD5Z1GBPZZ3YFdgi8mcfYIvchubm6RotW+rZe2hgdxOatqxTlDuwFkmHrKFYl2EDy0y
 iVOT4VET3TsldaVt9nq8EQ78XhjoHrDDX5FRpzaFqVk68sdHc+bZ2x74gP1zXRudkZsb
 0yMWqYjT1PSkoI4M5WCHdgyA8tylfProo94BlKcTYyf3gDVExCxnWmU+CweXvG2LQtC2 Ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w117tt1qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:47:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4Khxji103231;
        Mon, 4 Nov 2019 20:45:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w1k8vfv9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:45:34 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4KjYjw011211;
        Mon, 4 Nov 2019 20:45:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:45:33 -0800
Date:   Mon, 4 Nov 2019 12:45:31 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/34] xfs: devirtualize ->data_entry_tag_p
Message-ID: <20191104204531.GC4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-28-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-28-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040200
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:07:12PM -0700, Christoph Hellwig wrote:
> Replace the ->data_entry_tag_p dir ops method with a directly called
> xfs_dir2_data_entry_tag_p helper that takes care of the differences
> between the directory format with and without the file type field.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c  | 22 ----------------------
>  fs/xfs/libxfs/xfs_dir2.h       |  1 -
>  fs/xfs/libxfs/xfs_dir2_block.c |  8 ++++----
>  fs/xfs/libxfs/xfs_dir2_data.c  | 21 ++++++++++++++++++---
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |  2 +-
>  fs/xfs/libxfs/xfs_dir2_node.c  |  2 +-
>  fs/xfs/libxfs/xfs_dir2_priv.h  |  2 ++
>  fs/xfs/scrub/dir.c             |  2 +-
>  8 files changed, 27 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index bbff0e7822b8..9c247223326f 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -89,25 +89,6 @@ xfs_dir3_data_put_ftype(
>  	dep->name[dep->namelen] = type;
>  }
>  
> -/*
> - * Pointer to an entry's tag word.
> - */
> -static __be16 *
> -xfs_dir2_data_entry_tag_p(
> -	struct xfs_dir2_data_entry *dep)
> -{
> -	return (__be16 *)((char *)dep +
> -		XFS_DIR2_DATA_ENTSIZE(dep->namelen) - sizeof(__be16));
> -}
> -
> -static __be16 *
> -xfs_dir3_data_entry_tag_p(
> -	struct xfs_dir2_data_entry *dep)
> -{
> -	return (__be16 *)((char *)dep +
> -		XFS_DIR3_DATA_ENTSIZE(dep->namelen) - sizeof(__be16));
> -}
> -
>  static struct xfs_dir2_data_free *
>  xfs_dir2_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
>  {
> @@ -123,7 +104,6 @@ xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
>  static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_get_ftype = xfs_dir2_data_get_ftype,
>  	.data_put_ftype = xfs_dir2_data_put_ftype,
> -	.data_entry_tag_p = xfs_dir2_data_entry_tag_p,
>  	.data_bestfree_p = xfs_dir2_data_bestfree_p,
>  
>  	.data_dot_offset = sizeof(struct xfs_dir2_data_hdr),
> @@ -138,7 +118,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.data_get_ftype = xfs_dir3_data_get_ftype,
>  	.data_put_ftype = xfs_dir3_data_put_ftype,
> -	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
>  	.data_bestfree_p = xfs_dir2_data_bestfree_p,
>  
>  	.data_dot_offset = sizeof(struct xfs_dir2_data_hdr),
> @@ -153,7 +132,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.data_get_ftype = xfs_dir3_data_get_ftype,
>  	.data_put_ftype = xfs_dir3_data_put_ftype,
> -	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
>  	.data_bestfree_p = xfs_dir3_data_bestfree_p,
>  
>  	.data_dot_offset = sizeof(struct xfs_dir3_data_hdr),
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 3fb2c514437a..8397e35d6b82 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -35,7 +35,6 @@ struct xfs_dir_ops {
>  	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
>  	void	(*data_put_ftype)(struct xfs_dir2_data_entry *dep,
>  				uint8_t ftype);
> -	__be16 * (*data_entry_tag_p)(struct xfs_dir2_data_entry *dep);
>  	struct xfs_dir2_data_free *
>  		(*data_bestfree_p)(struct xfs_dir2_data_hdr *hdr);
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 709423199369..4230ea945bc4 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -542,7 +542,7 @@ xfs_dir2_block_addname(
>  	dep->namelen = args->namelen;
>  	memcpy(dep->name, args->name, args->namelen);
>  	dp->d_ops->data_put_ftype(dep, args->filetype);
> -	tagp = dp->d_ops->data_entry_tag_p(dep);
> +	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>  	/*
>  	 * Clean up the bestfree array and log the header, tail, and entry.
> @@ -1154,7 +1154,7 @@ xfs_dir2_sf_to_block(
>  	dep->namelen = 1;
>  	dep->name[0] = '.';
>  	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
> -	tagp = dp->d_ops->data_entry_tag_p(dep);
> +	tagp = xfs_dir2_data_entry_tag_p(mp, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>  	xfs_dir2_data_log_entry(args, bp, dep);
>  	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
> @@ -1168,7 +1168,7 @@ xfs_dir2_sf_to_block(
>  	dep->namelen = 2;
>  	dep->name[0] = dep->name[1] = '.';
>  	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
> -	tagp = dp->d_ops->data_entry_tag_p(dep);
> +	tagp = xfs_dir2_data_entry_tag_p(mp, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>  	xfs_dir2_data_log_entry(args, bp, dep);
>  	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
> @@ -1219,7 +1219,7 @@ xfs_dir2_sf_to_block(
>  		dep->namelen = sfep->namelen;
>  		dp->d_ops->data_put_ftype(dep, xfs_dir2_sf_get_ftype(mp, sfep));
>  		memcpy(dep->name, sfep->name, dep->namelen);
> -		tagp = dp->d_ops->data_entry_tag_p(dep);
> +		tagp = xfs_dir2_data_entry_tag_p(mp, dep);
>  		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>  		xfs_dir2_data_log_entry(args, bp, dep);
>  		name.name = sfep->name;
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 7e3d35f0cdb5..750e95997d8c 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -17,12 +17,25 @@
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> +#include "xfs_dir2_priv.h"
>  
>  static xfs_failaddr_t xfs_dir2_data_freefind_verify(
>  		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
>  		struct xfs_dir2_data_unused *dup,
>  		struct xfs_dir2_data_free **bf_ent);
>  
> +/*
> + * Pointer to an entry's tag word.
> + */
> +__be16 *
> +xfs_dir2_data_entry_tag_p(
> +	struct xfs_mount		*mp,
> +	struct xfs_dir2_data_entry	*dep)
> +{
> +	return (__be16 *)((char *)dep +
> +		xfs_dir2_data_entsize(mp, dep->namelen) - sizeof(__be16));
> +}
> +
>  /*
>   * Check the consistency of the data block.
>   * The input can also be a block-format directory.
> @@ -175,7 +188,7 @@ __xfs_dir3_data_check(
>  			return __this_address;
>  		if (endp < p + xfs_dir2_data_entsize(mp, dep->namelen))
>  			return __this_address;
> -		if (be16_to_cpu(*ops->data_entry_tag_p(dep)) !=
> +		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) !=
>  		    (char *)dep - (char *)hdr)
>  			return __this_address;
>  		if (ops->data_get_ftype(dep) >= XFS_DIR3_FT_MAX)
> @@ -609,7 +622,8 @@ xfs_dir2_data_freescan_int(
>  		else {
>  			dep = (xfs_dir2_data_entry_t *)p;
>  			ASSERT((char *)dep - (char *)hdr ==
> -			       be16_to_cpu(*ops->data_entry_tag_p(dep)));
> +			       be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp,
> +					   dep)));
>  			p += xfs_dir2_data_entsize(mp, dep->namelen);
>  		}
>  	}
> @@ -709,6 +723,7 @@ xfs_dir2_data_log_entry(
>  	struct xfs_buf		*bp,
>  	xfs_dir2_data_entry_t	*dep)		/* data entry pointer */
>  {
> +	struct xfs_mount	*mp = bp->b_mount;
>  	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
>  
>  	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
> @@ -717,7 +732,7 @@ xfs_dir2_data_log_entry(
>  	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
>  
>  	xfs_trans_log_buf(args->trans, bp, (uint)((char *)dep - (char *)hdr),
> -		(uint)((char *)(args->dp->d_ops->data_entry_tag_p(dep) + 1) -
> +		(uint)((char *)(xfs_dir2_data_entry_tag_p(mp, dep) + 1) -
>  		       (char *)hdr - 1));
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 2f7eda3008a6..3a65b7c8aa83 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -866,7 +866,7 @@ xfs_dir2_leaf_addname(
>  	dep->namelen = args->namelen;
>  	memcpy(dep->name, args->name, dep->namelen);
>  	dp->d_ops->data_put_ftype(dep, args->filetype);
> -	tagp = dp->d_ops->data_entry_tag_p(dep);
> +	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>  	/*
>  	 * Need to scan fix up the bestfree table.
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index d08a11121dee..7534e35d8aa2 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -1966,7 +1966,7 @@ xfs_dir2_node_addname_int(
>  	dep->namelen = args->namelen;
>  	memcpy(dep->name, args->name, dep->namelen);
>  	dp->d_ops->data_put_ftype(dep, args->filetype);
> -	tagp = dp->d_ops->data_entry_tag_p(dep);
> +	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>  	xfs_dir2_data_log_entry(args, dbp, dep);
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 585b7b42c204..750344407f27 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -48,6 +48,8 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
>  
>  /* xfs_dir2_data.c */
>  int xfs_dir2_data_entsize(struct xfs_mount *mp, int n);
> +__be16 *xfs_dir2_data_entry_tag_p(struct xfs_mount *mp,
> +		struct xfs_dir2_data_entry *dep);
>  
>  #ifdef DEBUG
>  extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 5ddd95f12b85..d7ac9423ed86 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -269,7 +269,7 @@ xchk_dir_rec(
>  	/* Retrieve the entry, sanity check it, and compare hashes. */
>  	ino = be64_to_cpu(dent->inumber);
>  	hash = be32_to_cpu(ent->hashval);
> -	tag = be16_to_cpup(dp->d_ops->data_entry_tag_p(dent));
> +	tag = be16_to_cpup(xfs_dir2_data_entry_tag_p(mp, dent));
>  	if (!xfs_verify_dir_ino(mp, ino) || tag != off)
>  		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
>  	if (dent->namelen == 0) {
> -- 
> 2.20.1
> 
