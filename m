Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8354CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CDD420B7C
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:45:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jv2Jn1Db"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfKDUpJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:45:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52956 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfKDUpJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:45:09 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KiGS0134378;
        Mon, 4 Nov 2019 20:45:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=fbJZ7Vm33z4J6VNYvTGkV+98swSn49GBuO2dtgx+lQo=;
 b=jv2Jn1DbBM8gsO1D3kGxVavl3aRsAjrqZwRYI4f4pwFsU8txQQyyf+6Myy6PUsuVo8zm
 /SieUxh+P0QvP2wyys3UtD7z5BoYzv0jtL3B0PnXWAg1uEcDHy1IzYT1Qjk/Uh5ltHV1
 r9ccizU7uDHlm6E25SUPk4r/BGu9/bgsKsLnUYGBgzBG6dPML2GXzeOnsn/93DOvEx83
 z6cPSKGFn7FYWeHJY06j8p3nnpe8FxAklNlipHxTHaujdthd3eB/2o2FyVMWlGESfGaG
 rtpJaqpLbmSPfti+63L9JCnDUapXdRCGnqN5ceiXDgFBEre2lMf9KC5MLfuoDwOpWm7b ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w11rpt0af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:45:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4Kh8uf177763;
        Mon, 4 Nov 2019 20:45:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w1kacag86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:45:05 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4Kj3Zq010813;
        Mon, 4 Nov 2019 20:45:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:45:02 -0800
Date:   Mon, 4 Nov 2019 12:45:01 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/34] xfs: devirtualize ->data_entsize
Message-ID: <20191104204501.GB4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-27-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-27-hch@lst.de>
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

On Fri, Nov 01, 2019 at 03:07:11PM -0700, Christoph Hellwig wrote:
> Replace the ->data_entsize dir ops method with a directly called
> xfs_dir2_data_entsize helper that takes care of the differences between
> the directory format with and without the file type field.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_da_format.c  | 22 ++++++++--------------
>  fs/xfs/libxfs/xfs_dir2.h       |  3 +--
>  fs/xfs/libxfs/xfs_dir2_block.c |  5 +++--
>  fs/xfs/libxfs/xfs_dir2_data.c  | 13 ++++++-------
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |  5 +++--
>  fs/xfs/libxfs/xfs_dir2_node.c  |  7 ++++---
>  fs/xfs/libxfs/xfs_dir2_priv.h  |  2 ++
>  fs/xfs/libxfs/xfs_dir2_sf.c    | 14 +++++++-------
>  fs/xfs/scrub/dir.c             |  4 ++--
>  fs/xfs/xfs_dir2_readdir.c      |  9 +++++----
>  10 files changed, 41 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 47c56f6dd872..bbff0e7822b8 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -41,18 +41,15 @@
>  		 sizeof(xfs_dir2_data_off_t) + sizeof(uint8_t)),	\
>  		XFS_DIR2_DATA_ALIGN)
>  
> -static int
> +int
>  xfs_dir2_data_entsize(
> +	struct xfs_mount	*mp,
>  	int			n)

@namelen, not just @n?

Oh, you do change that later.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  {
> -	return XFS_DIR2_DATA_ENTSIZE(n);
> -}
> -
> -static int
> -xfs_dir3_data_entsize(
> -	int			n)
> -{
> -	return XFS_DIR3_DATA_ENTSIZE(n);
> +	if (xfs_sb_version_hasftype(&mp->m_sb))
> +		return XFS_DIR3_DATA_ENTSIZE(n);
> +	else
> +		return XFS_DIR2_DATA_ENTSIZE(n);
>  }
>  
>  static uint8_t
> @@ -100,7 +97,7 @@ xfs_dir2_data_entry_tag_p(
>  	struct xfs_dir2_data_entry *dep)
>  {
>  	return (__be16 *)((char *)dep +
> -		xfs_dir2_data_entsize(dep->namelen) - sizeof(__be16));
> +		XFS_DIR2_DATA_ENTSIZE(dep->namelen) - sizeof(__be16));
>  }
>  
>  static __be16 *
> @@ -108,7 +105,7 @@ xfs_dir3_data_entry_tag_p(
>  	struct xfs_dir2_data_entry *dep)
>  {
>  	return (__be16 *)((char *)dep +
> -		xfs_dir3_data_entsize(dep->namelen) - sizeof(__be16));
> +		XFS_DIR3_DATA_ENTSIZE(dep->namelen) - sizeof(__be16));
>  }
>  
>  static struct xfs_dir2_data_free *
> @@ -124,7 +121,6 @@ xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
>  }
>  
>  static const struct xfs_dir_ops xfs_dir2_ops = {
> -	.data_entsize = xfs_dir2_data_entsize,
>  	.data_get_ftype = xfs_dir2_data_get_ftype,
>  	.data_put_ftype = xfs_dir2_data_put_ftype,
>  	.data_entry_tag_p = xfs_dir2_data_entry_tag_p,
> @@ -140,7 +136,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  };
>  
>  static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
> -	.data_entsize = xfs_dir3_data_entsize,
>  	.data_get_ftype = xfs_dir3_data_get_ftype,
>  	.data_put_ftype = xfs_dir3_data_put_ftype,
>  	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
> @@ -156,7 +151,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  };
>  
>  static const struct xfs_dir_ops xfs_dir3_ops = {
> -	.data_entsize = xfs_dir3_data_entsize,
>  	.data_get_ftype = xfs_dir3_data_get_ftype,
>  	.data_put_ftype = xfs_dir3_data_put_ftype,
>  	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index e9de15e62630..3fb2c514437a 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -32,7 +32,6 @@ extern unsigned char xfs_mode_to_ftype(int mode);
>   * directory operations vector for encode/decode routines
>   */
>  struct xfs_dir_ops {
> -	int	(*data_entsize)(int len);
>  	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
>  	void	(*data_put_ftype)(struct xfs_dir2_data_entry *dep,
>  				uint8_t ftype);
> @@ -87,7 +86,7 @@ extern int xfs_dir2_isleaf(struct xfs_da_args *args, int *r);
>  extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
>  				struct xfs_buf *bp);
>  
> -extern void xfs_dir2_data_freescan_int(struct xfs_da_geometry *geo,
> +extern void xfs_dir2_data_freescan_int(struct xfs_mount *mp,
>  		const struct xfs_dir_ops *ops,
>  		struct xfs_dir2_data_hdr *hdr, int *loghead);
>  extern void xfs_dir2_data_freescan(struct xfs_inode *dp,
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index b32beb71b7b2..709423199369 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -355,7 +355,7 @@ xfs_dir2_block_addname(
>  	if (error)
>  		return error;
>  
> -	len = dp->d_ops->data_entsize(args->namelen);
> +	len = xfs_dir2_data_entsize(dp->i_mount, args->namelen);
>  
>  	/*
>  	 * Set up pointers to parts of the block.
> @@ -791,7 +791,8 @@ xfs_dir2_block_removename(
>  	needlog = needscan = 0;
>  	xfs_dir2_data_make_free(args, bp,
>  		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
> -		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
> +		xfs_dir2_data_entsize(dp->i_mount, dep->namelen), &needlog,
> +		&needscan);
>  	/*
>  	 * Fix up the block tail.
>  	 */
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index edb3fe5c9174..7e3d35f0cdb5 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -173,7 +173,7 @@ __xfs_dir3_data_check(
>  			return __this_address;
>  		if (xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)))
>  			return __this_address;
> -		if (endp < p + ops->data_entsize(dep->namelen))
> +		if (endp < p + xfs_dir2_data_entsize(mp, dep->namelen))
>  			return __this_address;
>  		if (be16_to_cpu(*ops->data_entry_tag_p(dep)) !=
>  		    (char *)dep - (char *)hdr)
> @@ -198,7 +198,7 @@ __xfs_dir3_data_check(
>  			if (i >= be32_to_cpu(btp->count))
>  				return __this_address;
>  		}
> -		p += ops->data_entsize(dep->namelen);
> +		p += xfs_dir2_data_entsize(mp, dep->namelen);
>  	}
>  	/*
>  	 * Need to have seen all the entries and all the bestfree slots.
> @@ -562,7 +562,7 @@ xfs_dir2_data_freeremove(
>   */
>  void
>  xfs_dir2_data_freescan_int(
> -	struct xfs_da_geometry	*geo,
> +	struct xfs_mount	*mp,
>  	const struct xfs_dir_ops *ops,
>  	struct xfs_dir2_data_hdr *hdr,
>  	int			*loghead)
> @@ -588,7 +588,7 @@ xfs_dir2_data_freescan_int(
>  	 * Set up pointers.
>  	 */
>  	p = (char *)hdr + ops->data_entry_offset;
> -	endp = xfs_dir3_data_endp(geo, hdr);
> +	endp = xfs_dir3_data_endp(mp->m_dir_geo, hdr);
>  	/*
>  	 * Loop over the block's entries.
>  	 */
> @@ -610,7 +610,7 @@ xfs_dir2_data_freescan_int(
>  			dep = (xfs_dir2_data_entry_t *)p;
>  			ASSERT((char *)dep - (char *)hdr ==
>  			       be16_to_cpu(*ops->data_entry_tag_p(dep)));
> -			p += ops->data_entsize(dep->namelen);
> +			p += xfs_dir2_data_entsize(mp, dep->namelen);
>  		}
>  	}
>  }
> @@ -621,8 +621,7 @@ xfs_dir2_data_freescan(
>  	struct xfs_dir2_data_hdr *hdr,
>  	int			*loghead)
>  {
> -	return xfs_dir2_data_freescan_int(dp->i_mount->m_dir_geo, dp->d_ops,
> -			hdr, loghead);
> +	return xfs_dir2_data_freescan_int(dp->i_mount, dp->d_ops, hdr, loghead);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 3770107c0695..2f7eda3008a6 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -660,7 +660,7 @@ xfs_dir2_leaf_addname(
>  	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
>  	ents = leafhdr.ents;
>  	bestsp = xfs_dir2_leaf_bests_p(ltp);
> -	length = dp->d_ops->data_entsize(args->namelen);
> +	length = xfs_dir2_data_entsize(dp->i_mount, args->namelen);
>  
>  	/*
>  	 * See if there are any entries with the same hash value
> @@ -1395,7 +1395,8 @@ xfs_dir2_leaf_removename(
>  	 */
>  	xfs_dir2_data_make_free(args, dbp,
>  		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
> -		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
> +		xfs_dir2_data_entsize(dp->i_mount, dep->namelen), &needlog,
> +		&needscan);
>  	/*
>  	 * We just mark the leaf entry stale by putting a null in it.
>  	 */
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index ceb5936b58dd..d08a11121dee 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -662,7 +662,7 @@ xfs_dir2_leafn_lookup_for_addname(
>  		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
>  		       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
>  	}
> -	length = dp->d_ops->data_entsize(args->namelen);
> +	length = xfs_dir2_data_entsize(mp, args->namelen);
>  	/*
>  	 * Loop over leaf entries with the right hash value.
>  	 */
> @@ -1314,7 +1314,8 @@ xfs_dir2_leafn_remove(
>  	longest = be16_to_cpu(bf[0].length);
>  	needlog = needscan = 0;
>  	xfs_dir2_data_make_free(args, dbp, off,
> -		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
> +		xfs_dir2_data_entsize(dp->i_mount, dep->namelen), &needlog,
> +		&needscan);
>  	/*
>  	 * Rescan the data block freespaces for bestfree.
>  	 * Log the data block header if needed.
> @@ -1907,7 +1908,7 @@ xfs_dir2_node_addname_int(
>  	int			needscan = 0;	/* need to rescan data frees */
>  	__be16			*tagp;		/* data entry tag pointer */
>  
> -	length = dp->d_ops->data_entsize(args->namelen);
> +	length = xfs_dir2_data_entsize(dp->i_mount, args->namelen);
>  	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &freehdr,
>  					   &findex, length);
>  	if (error)
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index a92d9f0f83e0..585b7b42c204 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -47,6 +47,8 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
>  		struct xfs_buf *lbp, struct xfs_buf *dbp);
>  
>  /* xfs_dir2_data.c */
> +int xfs_dir2_data_entsize(struct xfs_mount *mp, int n);
> +
>  #ifdef DEBUG
>  extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
>  #else
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index b2c6c492b09d..4885a0e920c5 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -341,7 +341,7 @@ xfs_dir2_block_to_sf(
>  
>  			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
>  		}
> -		ptr += dp->d_ops->data_entsize(dep->namelen);
> +		ptr += xfs_dir2_data_entsize(mp, dep->namelen);
>  	}
>  	ASSERT((char *)sfep - (char *)sfp == size);
>  
> @@ -564,10 +564,10 @@ xfs_dir2_sf_addname_hard(
>  	 */
>  	for (offset = dp->d_ops->data_first_offset,
>  	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
> -	      add_datasize = dp->d_ops->data_entsize(args->namelen),
> +	      add_datasize = xfs_dir2_data_entsize(mp, args->namelen),
>  	      eof = (char *)oldsfep == &buf[old_isize];
>  	     !eof;
> -	     offset = new_offset + dp->d_ops->data_entsize(oldsfep->namelen),
> +	     offset = new_offset + xfs_dir2_data_entsize(mp, oldsfep->namelen),
>  	      oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep),
>  	      eof = (char *)oldsfep == &buf[old_isize]) {
>  		new_offset = xfs_dir2_sf_get_offset(oldsfep);
> @@ -639,7 +639,7 @@ xfs_dir2_sf_addname_pick(
>  	int			used;		/* data bytes used */
>  
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
> -	size = dp->d_ops->data_entsize(args->namelen);
> +	size = xfs_dir2_data_entsize(mp, args->namelen);
>  	offset = dp->d_ops->data_first_offset;
>  	sfep = xfs_dir2_sf_firstentry(sfp);
>  	holefit = 0;
> @@ -652,7 +652,7 @@ xfs_dir2_sf_addname_pick(
>  		if (!holefit)
>  			holefit = offset + size <= xfs_dir2_sf_get_offset(sfep);
>  		offset = xfs_dir2_sf_get_offset(sfep) +
> -			 dp->d_ops->data_entsize(sfep->namelen);
> +			 xfs_dir2_data_entsize(mp, sfep->namelen);
>  		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
>  	}
>  	/*
> @@ -717,7 +717,7 @@ xfs_dir2_sf_check(
>  		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
>  		offset =
>  			xfs_dir2_sf_get_offset(sfep) +
> -			dp->d_ops->data_entsize(sfep->namelen);
> +			xfs_dir2_data_entsize(mp, sfep->namelen);
>  		ASSERT(xfs_dir2_sf_get_ftype(mp, sfep) < XFS_DIR3_FT_MAX);
>  	}
>  	ASSERT(i8count == sfp->i8count);
> @@ -817,7 +817,7 @@ xfs_dir2_sf_verify(
>  			return __this_address;
>  
>  		offset = xfs_dir2_sf_get_offset(sfep) +
> -				dops->data_entsize(sfep->namelen);
> +				xfs_dir2_data_entsize(mp, sfep->namelen);
>  
>  		sfep = next_sfep;
>  	}
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 8d6ecfe09611..5ddd95f12b85 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -259,7 +259,7 @@ xchk_dir_rec(
>  		dep = (struct xfs_dir2_data_entry *)p;
>  		if (dep == dent)
>  			break;
> -		p += mp->m_dir_inode_ops->data_entsize(dep->namelen);
> +		p += xfs_dir2_data_entsize(mp, dep->namelen);
>  	}
>  	if (p >= endp) {
>  		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
> @@ -402,7 +402,7 @@ xchk_directory_data_bestfree(
>  			struct xfs_dir2_data_entry	*dep;
>  
>  			dep = (struct xfs_dir2_data_entry *)ptr;
> -			newlen = d_ops->data_entsize(dep->namelen);
> +			newlen = xfs_dir2_data_entsize(mp, dep->namelen);
>  			if (newlen <= 0) {
>  				xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
>  						lblk);
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 04f8c2451b93..4cc4102c85f0 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -200,7 +200,7 @@ xfs_dir2_block_getdents(
>  		/*
>  		 * Bump pointer for the next iteration.
>  		 */
> -		ptr += dp->d_ops->data_entsize(dep->namelen);
> +		ptr += xfs_dir2_data_entsize(dp->i_mount, dep->namelen);
>  		/*
>  		 * The entry is before the desired starting point, skip it.
>  		 */
> @@ -355,6 +355,7 @@ xfs_dir2_leaf_getdents(
>  	size_t			bufsize)
>  {
>  	struct xfs_inode	*dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_buf		*bp = NULL;	/* data block buffer */
>  	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
>  	xfs_dir2_data_entry_t	*dep;		/* data entry */
> @@ -432,8 +433,8 @@ xfs_dir2_leaf_getdents(
>  						continue;
>  					}
>  					dep = (xfs_dir2_data_entry_t *)ptr;
> -					length =
> -					   dp->d_ops->data_entsize(dep->namelen);
> +					length = xfs_dir2_data_entsize(mp,
> +							dep->namelen);
>  					ptr += length;
>  				}
>  				/*
> @@ -464,7 +465,7 @@ xfs_dir2_leaf_getdents(
>  		}
>  
>  		dep = (xfs_dir2_data_entry_t *)ptr;
> -		length = dp->d_ops->data_entsize(dep->namelen);
> +		length = xfs_dir2_data_entsize(mp, dep->namelen);
>  		filetype = dp->d_ops->data_get_ftype(dep);
>  
>  		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
> -- 
> 2.20.1
> 
