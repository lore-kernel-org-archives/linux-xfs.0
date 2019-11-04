Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4966ECA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1101D206BA
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:34:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FdQ6uz32"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfKDUeS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:34:18 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45978 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729509AbfKDUeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:34:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KTWZQ131915;
        Mon, 4 Nov 2019 20:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Wk4lt8nA+Y7WLbkUtbMJo5WwmO7pscb4NkzbxdzJ6eI=;
 b=FdQ6uz321bQs2yFC7V4JT2HVcCO6NtfydIVEjFGDR61Z9pNmte2DnG0OHmeHfofceYEf
 KyVwSdgLra3xo1jNMp+OUmeVC1pKWtNrLTI9zzdmsVHS/V2g+loVEMjHw6Xvlqd8I/aU
 D4LGAhkQegfL5f2gPK9i94kTteP6T+ROQhzEH7QjIFe+GAWD694koaLsGNaWWpDHuy6I
 YgQRdZS2g3gDVWQGn4UAW0dKMp9JjBxdAUagMXdxjhOamu+Cd1E04sGjIsGHEdT9neHi
 Ff3hekGV2UeZk78gcHyfTl330un4VL+q0R+4vf+1aCqIiBSUESdG/nAFURoCHPgS5B0f oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w117tsypf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:34:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KXwJe153081;
        Mon, 4 Nov 2019 20:34:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w1kac9c9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:34:12 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4KYAYG004591;
        Mon, 4 Nov 2019 20:34:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:34:10 -0800
Date:   Mon, 4 Nov 2019 12:34:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/34] xfs: devirtualize ->sf_get_ftype and ->sf_put_ftype
Message-ID: <20191104203409.GX4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-23-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-23-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040197
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:07:07PM -0700, Christoph Hellwig wrote:
> Replace the ->sf_get_ftype and ->sf_put_ftype dir ops methods with
> directly called xfs_dir2_sf_get_ftype and xfs_dir2_sf_put_ftype helpers
> that takes care of the differences between the directory format with and
> without the file type field.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems reasonable to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c  | 52 -----------------------------
>  fs/xfs/libxfs/xfs_dir2.h       |  4 ---
>  fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
>  fs/xfs/libxfs/xfs_dir2_priv.h  |  2 ++
>  fs/xfs/libxfs/xfs_dir2_sf.c    | 60 ++++++++++++++++++++++++++--------
>  fs/xfs/xfs_dir2_readdir.c      |  2 +-
>  6 files changed, 50 insertions(+), 72 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index f427f141d001..1c72b46344d6 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -15,49 +15,6 @@
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
>  
> -/*
> - * For filetype enabled shortform directories, the file type field is stored at
> - * the end of the name.  Because it's only a single byte, endian conversion is
> - * not necessary. For non-filetype enable directories, the type is always
> - * unknown and we never store the value.
> - */
> -static uint8_t
> -xfs_dir2_sfe_get_ftype(
> -	struct xfs_dir2_sf_entry *sfep)
> -{
> -	return XFS_DIR3_FT_UNKNOWN;
> -}
> -
> -static void
> -xfs_dir2_sfe_put_ftype(
> -	struct xfs_dir2_sf_entry *sfep,
> -	uint8_t			ftype)
> -{
> -	ASSERT(ftype < XFS_DIR3_FT_MAX);
> -}
> -
> -static uint8_t
> -xfs_dir3_sfe_get_ftype(
> -	struct xfs_dir2_sf_entry *sfep)
> -{
> -	uint8_t		ftype;
> -
> -	ftype = sfep->name[sfep->namelen];
> -	if (ftype >= XFS_DIR3_FT_MAX)
> -		return XFS_DIR3_FT_UNKNOWN;
> -	return ftype;
> -}
> -
> -static void
> -xfs_dir3_sfe_put_ftype(
> -	struct xfs_dir2_sf_entry *sfep,
> -	uint8_t			ftype)
> -{
> -	ASSERT(ftype < XFS_DIR3_FT_MAX);
> -
> -	sfep->name[sfep->namelen] = ftype;
> -}
> -
>  /*
>   * Directory data block operations
>   */
> @@ -271,9 +228,6 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
>  }
>  
>  static const struct xfs_dir_ops xfs_dir2_ops = {
> -	.sf_get_ftype = xfs_dir2_sfe_get_ftype,
> -	.sf_put_ftype = xfs_dir2_sfe_put_ftype,
> -
>  	.data_entsize = xfs_dir2_data_entsize,
>  	.data_get_ftype = xfs_dir2_data_get_ftype,
>  	.data_put_ftype = xfs_dir2_data_put_ftype,
> @@ -296,9 +250,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  };
>  
>  static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
> -	.sf_get_ftype = xfs_dir3_sfe_get_ftype,
> -	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
> -
>  	.data_entsize = xfs_dir3_data_entsize,
>  	.data_get_ftype = xfs_dir3_data_get_ftype,
>  	.data_put_ftype = xfs_dir3_data_put_ftype,
> @@ -321,9 +272,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  };
>  
>  static const struct xfs_dir_ops xfs_dir3_ops = {
> -	.sf_get_ftype = xfs_dir3_sfe_get_ftype,
> -	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
> -
>  	.data_entsize = xfs_dir3_data_entsize,
>  	.data_get_ftype = xfs_dir3_data_get_ftype,
>  	.data_put_ftype = xfs_dir3_data_put_ftype,
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 049d844d6a18..61cc9ae837d5 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -32,10 +32,6 @@ extern unsigned char xfs_mode_to_ftype(int mode);
>   * directory operations vector for encode/decode routines
>   */
>  struct xfs_dir_ops {
> -	uint8_t (*sf_get_ftype)(struct xfs_dir2_sf_entry *sfep);
> -	void	(*sf_put_ftype)(struct xfs_dir2_sf_entry *sfep,
> -				uint8_t ftype);
> -
>  	int	(*data_entsize)(int len);
>  	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
>  	void	(*data_put_ftype)(struct xfs_dir2_data_entry *dep,
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 0f3024386a5c..5877272dc63e 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1216,7 +1216,7 @@ xfs_dir2_sf_to_block(
>  		dep = (xfs_dir2_data_entry_t *)((char *)hdr + newoffset);
>  		dep->inumber = cpu_to_be64(xfs_dir2_sf_get_ino(mp, sfp, sfep));
>  		dep->namelen = sfep->namelen;
> -		dp->d_ops->data_put_ftype(dep, dp->d_ops->sf_get_ftype(sfep));
> +		dp->d_ops->data_put_ftype(dep, xfs_dir2_sf_get_ftype(mp, sfep));
>  		memcpy(dep->name, sfep->name, dep->namelen);
>  		tagp = dp->d_ops->data_entry_tag_p(dep);
>  		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 57c0f7aee7a4..a92d9f0f83e0 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -139,6 +139,8 @@ xfs_ino_t xfs_dir2_sf_get_ino(struct xfs_mount *mp, struct xfs_dir2_sf_hdr *hdr,
>  		struct xfs_dir2_sf_entry *sfep);
>  xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *hdr);
>  void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *hdr, xfs_ino_t ino);
> +uint8_t xfs_dir2_sf_get_ftype(struct xfs_mount *mp,
> +		struct xfs_dir2_sf_entry *sfep);
>  struct xfs_dir2_sf_entry *xfs_dir2_sf_nextentry(struct xfs_mount *mp,
>  		struct xfs_dir2_sf_hdr *hdr, struct xfs_dir2_sf_entry *sfep);
>  extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index c33d838b1a5c..10199261c94c 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -126,6 +126,37 @@ xfs_dir2_sf_put_parent_ino(
>  		put_unaligned_be32(ino, hdr->parent);
>  }
>  
> +/*
> + * The file type field is stored at the end of the name for filetype enabled
> + * shortform directories, or not at all otherwise.
> + */
> +uint8_t
> +xfs_dir2_sf_get_ftype(
> +	struct xfs_mount		*mp,
> +	struct xfs_dir2_sf_entry	*sfep)
> +{
> +	if (xfs_sb_version_hasftype(&mp->m_sb)) {
> +		uint8_t			ftype = sfep->name[sfep->namelen];
> +
> +		if (ftype < XFS_DIR3_FT_MAX)
> +			return ftype;
> +	}
> +
> +	return XFS_DIR3_FT_UNKNOWN;
> +}
> +
> +static void
> +xfs_dir2_sf_put_ftype(
> +	struct xfs_mount	*mp,
> +	struct xfs_dir2_sf_entry *sfep,
> +	uint8_t			ftype)
> +{
> +	ASSERT(ftype < XFS_DIR3_FT_MAX);
> +
> +	if (xfs_sb_version_hasftype(&mp->m_sb))
> +		sfep->name[sfep->namelen] = ftype;
> +}
> +
>  /*
>   * Given a block directory (dp/block), calculate its size as a shortform (sf)
>   * directory and a header for the sf directory, if it will fit it the
> @@ -305,7 +336,7 @@ xfs_dir2_block_to_sf(
>  			memcpy(sfep->name, dep->name, dep->namelen);
>  			xfs_dir2_sf_put_ino(mp, sfp, sfep,
>  					      be64_to_cpu(dep->inumber));
> -			dp->d_ops->sf_put_ftype(sfep,
> +			xfs_dir2_sf_put_ftype(mp, sfep,
>  					dp->d_ops->data_get_ftype(dep));
>  
>  			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
> @@ -477,7 +508,7 @@ xfs_dir2_sf_addname_easy(
>  	xfs_dir2_sf_put_offset(sfep, offset);
>  	memcpy(sfep->name, args->name, sfep->namelen);
>  	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
> -	dp->d_ops->sf_put_ftype(sfep, args->filetype);
> +	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
>  
>  	/*
>  	 * Update the header and inode.
> @@ -567,7 +598,7 @@ xfs_dir2_sf_addname_hard(
>  	xfs_dir2_sf_put_offset(sfep, offset);
>  	memcpy(sfep->name, args->name, sfep->namelen);
>  	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
> -	dp->d_ops->sf_put_ftype(sfep, args->filetype);
> +	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
>  	sfp->count++;
>  	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
>  		sfp->i8count++;
> @@ -664,7 +695,8 @@ static void
>  xfs_dir2_sf_check(
>  	xfs_da_args_t		*args)		/* operation arguments */
>  {
> -	xfs_inode_t		*dp;		/* incore directory inode */
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
>  	int			i;		/* entry number */
>  	int			i8count;	/* number of big inode#s */
>  	xfs_ino_t		ino;		/* entry inode number */
> @@ -672,8 +704,6 @@ xfs_dir2_sf_check(
>  	xfs_dir2_sf_entry_t	*sfep;		/* shortform dir entry */
>  	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
>  
> -	dp = args->dp;
> -
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>  	offset = dp->d_ops->data_first_offset;
>  	ino = xfs_dir2_sf_get_parent_ino(sfp);
> @@ -681,14 +711,14 @@ xfs_dir2_sf_check(
>  
>  	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
>  	     i < sfp->count;
> -	     i++, sfep = xfs_dir2_sf_nextentry(dp->i_mount, sfp, sfep)) {
> +	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep)) {
>  		ASSERT(xfs_dir2_sf_get_offset(sfep) >= offset);
> -		ino = xfs_dir2_sf_get_ino(dp->i_mount, sfp, sfep);
> +		ino = xfs_dir2_sf_get_ino(mp, sfp, sfep);
>  		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
>  		offset =
>  			xfs_dir2_sf_get_offset(sfep) +
>  			dp->d_ops->data_entsize(sfep->namelen);
> -		ASSERT(dp->d_ops->sf_get_ftype(sfep) < XFS_DIR3_FT_MAX);
> +		ASSERT(xfs_dir2_sf_get_ftype(mp, sfep) < XFS_DIR3_FT_MAX);
>  	}
>  	ASSERT(i8count == sfp->i8count);
>  	ASSERT((char *)sfep - (char *)sfp == dp->i_d.di_size);
> @@ -782,7 +812,7 @@ xfs_dir2_sf_verify(
>  			return __this_address;
>  
>  		/* Check the file type. */
> -		filetype = dops->sf_get_ftype(sfep);
> +		filetype = xfs_dir2_sf_get_ftype(mp, sfep);
>  		if (filetype >= XFS_DIR3_FT_MAX)
>  			return __this_address;
>  
> @@ -925,7 +955,7 @@ xfs_dir2_sf_lookup(
>  		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
>  			args->cmpresult = cmp;
>  			args->inumber = xfs_dir2_sf_get_ino(mp, sfp, sfep);
> -			args->filetype = dp->d_ops->sf_get_ftype(sfep);
> +			args->filetype = xfs_dir2_sf_get_ftype(mp, sfep);
>  			if (cmp == XFS_CMP_EXACT)
>  				return -EEXIST;
>  			ci_sfep = sfep;
> @@ -1108,7 +1138,7 @@ xfs_dir2_sf_replace(
>  				ASSERT(args->inumber != ino);
>  				xfs_dir2_sf_put_ino(mp, sfp, sfep,
>  						args->inumber);
> -				dp->d_ops->sf_put_ftype(sfep, args->filetype);
> +				xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
>  				break;
>  			}
>  		}
> @@ -1214,7 +1244,8 @@ xfs_dir2_sf_toino4(
>  		memcpy(sfep->name, oldsfep->name, sfep->namelen);
>  		xfs_dir2_sf_put_ino(mp, sfp, sfep,
>  				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
> -		dp->d_ops->sf_put_ftype(sfep, dp->d_ops->sf_get_ftype(oldsfep));
> +		xfs_dir2_sf_put_ftype(mp, sfep,
> +				xfs_dir2_sf_get_ftype(mp, oldsfep));
>  	}
>  	/*
>  	 * Clean up the inode.
> @@ -1286,7 +1317,8 @@ xfs_dir2_sf_toino8(
>  		memcpy(sfep->name, oldsfep->name, sfep->namelen);
>  		xfs_dir2_sf_put_ino(mp, sfp, sfep,
>  				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
> -		dp->d_ops->sf_put_ftype(sfep, dp->d_ops->sf_get_ftype(oldsfep));
> +		xfs_dir2_sf_put_ftype(mp, sfep,
> +				xfs_dir2_sf_get_ftype(mp, oldsfep));
>  	}
>  	/*
>  	 * Clean up the inode.
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 9d318f091a73..e18045465455 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -115,7 +115,7 @@ xfs_dir2_sf_getdents(
>  		}
>  
>  		ino = xfs_dir2_sf_get_ino(mp, sfp, sfep);
> -		filetype = dp->d_ops->sf_get_ftype(sfep);
> +		filetype = xfs_dir2_sf_get_ftype(mp, sfep);
>  		ctx->pos = off & 0x7fffffff;
>  		if (!xfs_dir2_namecheck(sfep->name, sfep->namelen)) {
>  			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
> -- 
> 2.20.1
> 
