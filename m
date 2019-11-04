Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16C5CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E7602067D
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:52:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UOwwfM6L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbfKDUwP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:52:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59138 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728519AbfKDUwP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:52:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KmsrN121138;
        Mon, 4 Nov 2019 20:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=j/NvCUz3OwMafUlSTYl9xVIaNR9Ug+gaCipd9SdIEms=;
 b=UOwwfM6LQy0KQeHg1EElIK1v5jPgOeB21+OyzDwZFDdEkHSun/DWitI272dzOglzAUS1
 J3dkVmsPN1gdHljkpSp8VWHo7l+HAaetuB45/w7YkgmiMrdG5sG9xRe9Pfnqmxs/9rP4
 R9xIMPEMI1IsY33qHHZewjOBMCzYxMCOgWz9hST39tWWme/9ecBFdbQH3EP8aP/xUwjI
 xl9X2EGPpUXMgft5uiPvjWNioZn4qcbGbILiKr7VaDznG1fkXX5JN+Wmnx+dO7e2xpAd
 YMUgZQ0XiCRe0mAiwiLsrRDwaON4L7R0qgjUjTqEG9xUqBtuypCj6WE5RRttwqHdXiUh mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w12er1ubp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:52:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KnVgf115085;
        Mon, 4 Nov 2019 20:50:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w1k8vg2ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:50:09 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4Ko8eH018687;
        Mon, 4 Nov 2019 20:50:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:50:07 -0800
Date:   Mon, 4 Nov 2019 12:50:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/34] xfs: devirtualize ->data_get_ftype and
 ->data_put_ftype
Message-ID: <20191104205007.GG4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-32-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-32-hch@lst.de>
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

On Fri, Nov 01, 2019 at 03:07:16PM -0700, Christoph Hellwig wrote:
> Replace the ->data_get_ftype and ->data_put_ftype dir ops methods with
> directly called xfs_dir2_data_get_ftype and xfs_dir2_data_put_ftype
> helpers that takes care of the differences between the directory format
> with and without the file type field.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c  | 47 ----------------------------------
>  fs/xfs/libxfs/xfs_dir2.h       |  3 ---
>  fs/xfs/libxfs/xfs_dir2_block.c | 13 +++++-----
>  fs/xfs/libxfs/xfs_dir2_data.c  | 47 +++++++++++++++++++++++-----------
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |  6 ++---
>  fs/xfs/libxfs/xfs_dir2_node.c  |  6 ++---
>  fs/xfs/libxfs/xfs_dir2_priv.h  |  4 +++
>  fs/xfs/libxfs/xfs_dir2_sf.c    |  2 +-
>  fs/xfs/xfs_dir2_readdir.c      |  4 +--
>  9 files changed, 52 insertions(+), 80 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index b9f9fbf7eee2..498363ac193d 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -15,60 +15,13 @@
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
>  
> -/*
> - * Directory data block operations
> - */
> -
> -static uint8_t
> -xfs_dir2_data_get_ftype(
> -	struct xfs_dir2_data_entry *dep)
> -{
> -	return XFS_DIR3_FT_UNKNOWN;
> -}
> -
> -static void
> -xfs_dir2_data_put_ftype(
> -	struct xfs_dir2_data_entry *dep,
> -	uint8_t			ftype)
> -{
> -	ASSERT(ftype < XFS_DIR3_FT_MAX);
> -}
> -
> -static uint8_t
> -xfs_dir3_data_get_ftype(
> -	struct xfs_dir2_data_entry *dep)
> -{
> -	uint8_t		ftype = dep->name[dep->namelen];
> -
> -	if (ftype >= XFS_DIR3_FT_MAX)
> -		return XFS_DIR3_FT_UNKNOWN;
> -	return ftype;
> -}
> -
> -static void
> -xfs_dir3_data_put_ftype(
> -	struct xfs_dir2_data_entry *dep,
> -	uint8_t			type)
> -{
> -	ASSERT(type < XFS_DIR3_FT_MAX);
> -	ASSERT(dep->namelen != 0);
> -
> -	dep->name[dep->namelen] = type;
> -}
> -
>  static const struct xfs_dir_ops xfs_dir2_ops = {
> -	.data_get_ftype = xfs_dir2_data_get_ftype,
> -	.data_put_ftype = xfs_dir2_data_put_ftype,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
> -	.data_get_ftype = xfs_dir3_data_get_ftype,
> -	.data_put_ftype = xfs_dir3_data_put_ftype,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir3_ops = {
> -	.data_get_ftype = xfs_dir3_data_get_ftype,
> -	.data_put_ftype = xfs_dir3_data_put_ftype,
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 76d6d38154fb..f869ee01a381 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -32,9 +32,6 @@ extern unsigned char xfs_mode_to_ftype(int mode);
>   * directory operations vector for encode/decode routines
>   */
>  struct xfs_dir_ops {
> -	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
> -	void	(*data_put_ftype)(struct xfs_dir2_data_entry *dep,
> -				uint8_t ftype);
>  };
>  
>  extern const struct xfs_dir_ops *
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 50b4f1bf25a3..94d32e515478 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -541,7 +541,7 @@ xfs_dir2_block_addname(
>  	dep->inumber = cpu_to_be64(args->inumber);
>  	dep->namelen = args->namelen;
>  	memcpy(dep->name, args->name, args->namelen);
> -	dp->d_ops->data_put_ftype(dep, args->filetype);
> +	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
>  	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>  	/*
> @@ -633,7 +633,7 @@ xfs_dir2_block_lookup(
>  	 * Fill in inode number, CI name if appropriate, release the block.
>  	 */
>  	args->inumber = be64_to_cpu(dep->inumber);
> -	args->filetype = dp->d_ops->data_get_ftype(dep);
> +	args->filetype = xfs_dir2_data_get_ftype(dp->i_mount, dep);
>  	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
>  	xfs_trans_brelse(args->trans, bp);
>  	return error;
> @@ -865,7 +865,7 @@ xfs_dir2_block_replace(
>  	 * Change the inode number to the new value.
>  	 */
>  	dep->inumber = cpu_to_be64(args->inumber);
> -	dp->d_ops->data_put_ftype(dep, args->filetype);
> +	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
>  	xfs_dir2_data_log_entry(args, bp, dep);
>  	xfs_dir3_data_check(dp, bp);
>  	return 0;
> @@ -1154,7 +1154,7 @@ xfs_dir2_sf_to_block(
>  	dep->inumber = cpu_to_be64(dp->i_ino);
>  	dep->namelen = 1;
>  	dep->name[0] = '.';
> -	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
> +	xfs_dir2_data_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
>  	tagp = xfs_dir2_data_entry_tag_p(mp, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>  	xfs_dir2_data_log_entry(args, bp, dep);
> @@ -1168,7 +1168,7 @@ xfs_dir2_sf_to_block(
>  	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
>  	dep->namelen = 2;
>  	dep->name[0] = dep->name[1] = '.';
> -	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
> +	xfs_dir2_data_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
>  	tagp = xfs_dir2_data_entry_tag_p(mp, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>  	xfs_dir2_data_log_entry(args, bp, dep);
> @@ -1218,7 +1218,8 @@ xfs_dir2_sf_to_block(
>  		dep = (xfs_dir2_data_entry_t *)((char *)hdr + newoffset);
>  		dep->inumber = cpu_to_be64(xfs_dir2_sf_get_ino(mp, sfp, sfep));
>  		dep->namelen = sfep->namelen;
> -		dp->d_ops->data_put_ftype(dep, xfs_dir2_sf_get_ftype(mp, sfep));
> +		xfs_dir2_data_put_ftype(mp, dep,
> +				xfs_dir2_sf_get_ftype(mp, sfep));
>  		memcpy(dep->name, sfep->name, dep->namelen);
>  		tagp = xfs_dir2_data_entry_tag_p(mp, dep);
>  		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 353629c3a1e8..9752a0da5b95 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -60,6 +60,34 @@ xfs_dir2_data_entry_tag_p(
>  		xfs_dir2_data_entsize(mp, dep->namelen) - sizeof(__be16));
>  }
>  
> +uint8_t
> +xfs_dir2_data_get_ftype(
> +	struct xfs_mount		*mp,
> +	struct xfs_dir2_data_entry	*dep)
> +{
> +	if (xfs_sb_version_hasftype(&mp->m_sb)) {
> +		uint8_t			ftype = dep->name[dep->namelen];
> +
> +		if (likely(ftype < XFS_DIR3_FT_MAX))
> +			return ftype;
> +	}
> +
> +	return XFS_DIR3_FT_UNKNOWN;
> +}
> +
> +void
> +xfs_dir2_data_put_ftype(
> +	struct xfs_mount		*mp,
> +	struct xfs_dir2_data_entry	*dep,
> +	uint8_t				ftype)
> +{
> +	ASSERT(ftype < XFS_DIR3_FT_MAX);
> +	ASSERT(dep->namelen != 0);
> +
> +	if (xfs_sb_version_hasftype(&mp->m_sb))
> +		dep->name[dep->namelen] = ftype;
> +}
> +
>  /*
>   * Check the consistency of the data block.
>   * The input can also be a block-format directory.
> @@ -88,23 +116,12 @@ __xfs_dir3_data_check(
>  	char			*p;		/* current data position */
>  	int			stale;		/* count of stale leaves */
>  	struct xfs_name		name;
> -	const struct xfs_dir_ops *ops;
> -	struct xfs_da_geometry	*geo;
> -
> -	geo = mp->m_dir_geo;
> -
> -	/*
> -	 * We can be passed a null dp here from a verifier, so we need to go the
> -	 * hard way to get them.
> -	 */
> -	ops = xfs_dir_get_ops(mp, dp);
> +	struct xfs_da_geometry	*geo = mp->m_dir_geo;
>  
>  	/*
> -	 * If this isn't a directory, or we don't get handed the dir ops,
> -	 * something is seriously wrong.  Bail out.
> +	 * If this isn't a directory, something is seriously wrong.  Bail out.
>  	 */
> -	if ((dp && !S_ISDIR(VFS_I(dp)->i_mode)) ||
> -	    ops != xfs_dir_get_ops(mp, NULL))
> +	if (dp && !S_ISDIR(VFS_I(dp)->i_mode))
>  		return __this_address;
>  
>  	hdr = bp->b_addr;
> @@ -215,7 +232,7 @@ __xfs_dir3_data_check(
>  		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) !=
>  		    (char *)dep - (char *)hdr)
>  			return __this_address;
> -		if (ops->data_get_ftype(dep) >= XFS_DIR3_FT_MAX)
> +		if (xfs_dir2_data_get_ftype(mp, dep) >= XFS_DIR3_FT_MAX)
>  			return __this_address;
>  		count++;
>  		lastfree = 0;
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 30ccf44d817a..ff54c8f08ded 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -865,7 +865,7 @@ xfs_dir2_leaf_addname(
>  	dep->inumber = cpu_to_be64(args->inumber);
>  	dep->namelen = args->namelen;
>  	memcpy(dep->name, args->name, dep->namelen);
> -	dp->d_ops->data_put_ftype(dep, args->filetype);
> +	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
>  	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>  	/*
> @@ -1195,7 +1195,7 @@ xfs_dir2_leaf_lookup(
>  	 * Return the found inode number & CI name if appropriate
>  	 */
>  	args->inumber = be64_to_cpu(dep->inumber);
> -	args->filetype = dp->d_ops->data_get_ftype(dep);
> +	args->filetype = xfs_dir2_data_get_ftype(dp->i_mount, dep);
>  	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
>  	xfs_trans_brelse(tp, dbp);
>  	xfs_trans_brelse(tp, lbp);
> @@ -1524,7 +1524,7 @@ xfs_dir2_leaf_replace(
>  	 * Put the new inode number in, log it.
>  	 */
>  	dep->inumber = cpu_to_be64(args->inumber);
> -	dp->d_ops->data_put_ftype(dep, args->filetype);
> +	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
>  	tp = args->trans;
>  	xfs_dir2_data_log_entry(args, dbp, dep);
>  	xfs_dir3_leaf_check(dp, lbp);
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index d4a1d2455e72..e51b103fd429 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -878,7 +878,7 @@ xfs_dir2_leafn_lookup_for_entry(
>  				xfs_trans_brelse(tp, state->extrablk.bp);
>  			args->cmpresult = cmp;
>  			args->inumber = be64_to_cpu(dep->inumber);
> -			args->filetype = dp->d_ops->data_get_ftype(dep);
> +			args->filetype = xfs_dir2_data_get_ftype(mp, dep);
>  			*indexp = index;
>  			state->extravalid = 1;
>  			state->extrablk.bp = curbp;
> @@ -1963,7 +1963,7 @@ xfs_dir2_node_addname_int(
>  	dep->inumber = cpu_to_be64(args->inumber);
>  	dep->namelen = args->namelen;
>  	memcpy(dep->name, args->name, dep->namelen);
> -	dp->d_ops->data_put_ftype(dep, args->filetype);
> +	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
>  	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
>  	xfs_dir2_data_log_entry(args, dbp, dep);
> @@ -2247,7 +2247,7 @@ xfs_dir2_node_replace(
>  		 * Fill in the new inode number and log the entry.
>  		 */
>  		dep->inumber = cpu_to_be64(inum);
> -		args->dp->d_ops->data_put_ftype(dep, ftype);
> +		xfs_dir2_data_put_ftype(state->mp, dep, ftype);
>  		xfs_dir2_data_log_entry(args, state->extrablk.bp, dep);
>  		rval = 0;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 436693514c7c..5258d9da5f12 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -52,6 +52,10 @@ struct xfs_dir2_data_free *xfs_dir2_data_bestfree_p(struct xfs_mount *mp,
>  int xfs_dir2_data_entsize(struct xfs_mount *mp, int n);
>  __be16 *xfs_dir2_data_entry_tag_p(struct xfs_mount *mp,
>  		struct xfs_dir2_data_entry *dep);
> +uint8_t xfs_dir2_data_get_ftype(struct xfs_mount *mp,
> +		struct xfs_dir2_data_entry *dep);
> +void xfs_dir2_data_put_ftype(struct xfs_mount *mp,
> +		struct xfs_dir2_data_entry *dep, uint8_t ftype);
>  
>  #ifdef DEBUG
>  extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 8ecbb0828e42..9a3958aee9f2 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -337,7 +337,7 @@ xfs_dir2_block_to_sf(
>  			xfs_dir2_sf_put_ino(mp, sfp, sfep,
>  					      be64_to_cpu(dep->inumber));
>  			xfs_dir2_sf_put_ftype(mp, sfep,
> -					dp->d_ops->data_get_ftype(dep));
> +					xfs_dir2_data_get_ftype(mp, dep));
>  
>  			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
>  		}
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 7519317d7a21..7885616bdfe5 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -208,7 +208,7 @@ xfs_dir2_block_getdents(
>  					    (char *)dep - (char *)hdr);
>  
>  		ctx->pos = cook & 0x7fffffff;
> -		filetype = dp->d_ops->data_get_ftype(dep);
> +		filetype = xfs_dir2_data_get_ftype(dp->i_mount, dep);
>  		/*
>  		 * If it didn't fit, set the final offset to here & return.
>  		 */
> @@ -463,7 +463,7 @@ xfs_dir2_leaf_getdents(
>  
>  		dep = (xfs_dir2_data_entry_t *)ptr;
>  		length = xfs_dir2_data_entsize(mp, dep->namelen);
> -		filetype = dp->d_ops->data_get_ftype(dep);
> +		filetype = xfs_dir2_data_get_ftype(mp, dep);
>  
>  		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
>  		if (!xfs_dir2_namecheck(dep->name, dep->namelen)) {
> -- 
> 2.20.1
> 
