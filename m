Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB917C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D042222D3
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 04:22:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nZHWhGaq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfKMEW4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 23:22:56 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60840 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfKMEW4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 23:22:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4JBbh135257;
        Wed, 13 Nov 2019 04:22:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=HedKHMIuZOLaUQwbFi/ltCNU0s8UIfFNUqQ1SbcMDcs=;
 b=nZHWhGaqZs71H/MJc/MVMUE47eu2HHRmq5UFFeTiWYzzwkXfu3NpgxVtGlIGLILsWkfA
 piDk9Nm3TRo4+TyihxN8/PjeVsxBUfpjwn0+qtKvVcejXDbNhvjl0aE+sk4HUZaHY80b
 IyvGvq9W1A2tIVs0nIx2z9UaN7ldcTaIauOXPR+7XDUE1LqF3fbXbutUw+ZY8Lgqqcf7
 ggqqQ2KPUskvELkRiOvObNQwPiPgMA2lwq/itCDOxRB20HYCet4poVQRvuslT9CNEwQx
 kT/bSBBSpJYYeKl0Hb/e/IVVWMTlVwpqBy8v1NQlJaDJVwTAq16TGAkXOGrKEFdYV3/+ JA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w5p3qsdeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:22:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4JRoX046155;
        Wed, 13 Nov 2019 04:22:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w7khmkgen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:22:49 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAD4Mm6S010318;
        Wed, 13 Nov 2019 04:22:48 GMT
Received: from localhost (/10.159.254.5)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 20:22:48 -0800
Date:   Tue, 12 Nov 2019 20:22:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: devirtualize ->m_dirnameops
Message-ID: <20191113042247.GH6219@magnolia>
References: <20191111180415.22975-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111180415.22975-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130036
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130036
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 11, 2019 at 07:04:15PM +0100, Christoph Hellwig wrote:
> Instead of causing a relatively expensive indirect call for each
> hashing and comparism of a file name in a directory just use an
> inline function and a simple branch on the ASCII CI bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c   | 14 +-------------
>  fs/xfs/libxfs/xfs_da_btree.h   | 11 -----------
>  fs/xfs/libxfs/xfs_dir2.c       | 33 +++++++++++----------------------
>  fs/xfs/libxfs/xfs_dir2_block.c |  5 ++---
>  fs/xfs/libxfs/xfs_dir2_data.c  |  2 +-
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |  2 +-
>  fs/xfs/libxfs/xfs_dir2_node.c  |  2 +-
>  fs/xfs/libxfs/xfs_dir2_priv.h  | 24 ++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_dir2_sf.c    |  3 +--
>  fs/xfs/xfs_mount.h             |  2 --
>  10 files changed, 42 insertions(+), 56 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 46b1c3fb305c..bbe883f04bda 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -12,9 +12,9 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
>  #include "xfs_mount.h"
> +#include "xfs_inode.h"
>  #include "xfs_dir2.h"
>  #include "xfs_dir2_priv.h"
> -#include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_bmap.h"
>  #include "xfs_attr_leaf.h"
> @@ -2098,18 +2098,6 @@ xfs_da_compname(
>  					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
>  }
>  
> -static xfs_dahash_t
> -xfs_default_hashname(
> -	struct xfs_name	*name)
> -{
> -	return xfs_da_hashname(name->name, name->len);
> -}
> -
> -const struct xfs_nameops xfs_default_nameops = {
> -	.hashname	= xfs_default_hashname,
> -	.compname	= xfs_da_compname
> -};
> -
>  int
>  xfs_da_grow_inode_int(
>  	struct xfs_da_args	*args,
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 5af4df71e92b..ed3b558a9c1a 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -158,16 +158,6 @@ struct xfs_da3_icnode_hdr {
>  		(uint)(XFS_DA_LOGOFF(BASE, ADDR)), \
>  		(uint)(XFS_DA_LOGOFF(BASE, ADDR)+(SIZE)-1)
>  
> -/*
> - * Name ops for directory and/or attr name operations
> - */
> -struct xfs_nameops {
> -	xfs_dahash_t	(*hashname)(struct xfs_name *);
> -	enum xfs_dacmp	(*compname)(struct xfs_da_args *,
> -					const unsigned char *, int);
> -};
> -
> -
>  /*========================================================================
>   * Function prototypes.
>   *========================================================================*/
> @@ -234,6 +224,5 @@ void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
>  		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
>  
>  extern struct kmem_zone *xfs_da_state_zone;
> -extern const struct xfs_nameops xfs_default_nameops;
>  
>  #endif	/* __XFS_DA_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 624c05e77ab4..05182f2ebef4 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -52,7 +52,7 @@ xfs_mode_to_ftype(
>   * ASCII case-insensitive (ie. A-Z) support for directories that was
>   * used in IRIX.
>   */
> -STATIC xfs_dahash_t
> +xfs_dahash_t
>  xfs_ascii_ci_hashname(
>  	struct xfs_name	*name)
>  {
> @@ -65,14 +65,14 @@ xfs_ascii_ci_hashname(
>  	return hash;
>  }
>  
> -STATIC enum xfs_dacmp
> +enum xfs_dacmp
>  xfs_ascii_ci_compname(
> -	struct xfs_da_args *args,
> -	const unsigned char *name,
> -	int		len)
> +	struct xfs_da_args	*args,
> +	const unsigned char	*name,
> +	int			len)
>  {
> -	enum xfs_dacmp	result;
> -	int		i;
> +	enum xfs_dacmp		result;
> +	int			i;
>  
>  	if (args->namelen != len)
>  		return XFS_CMP_DIFFERENT;
> @@ -89,11 +89,6 @@ xfs_ascii_ci_compname(
>  	return result;
>  }
>  
> -static const struct xfs_nameops xfs_ascii_ci_nameops = {
> -	.hashname	= xfs_ascii_ci_hashname,
> -	.compname	= xfs_ascii_ci_compname,
> -};
> -
>  int
>  xfs_da_mount(
>  	struct xfs_mount	*mp)
> @@ -163,12 +158,6 @@ xfs_da_mount(
>  	dageo->node_ents = (dageo->blksize - dageo->node_hdr_size) /
>  				(uint)sizeof(xfs_da_node_entry_t);
>  	dageo->magicpct = (dageo->blksize * 37) / 100;
> -
> -	if (xfs_sb_version_hasasciici(&mp->m_sb))
> -		mp->m_dirnameops = &xfs_ascii_ci_nameops;
> -	else
> -		mp->m_dirnameops = &xfs_default_nameops;
> -
>  	return 0;
>  }
>  
> @@ -279,7 +268,7 @@ xfs_dir_createname(
>  	args->name = name->name;
>  	args->namelen = name->len;
>  	args->filetype = name->type;
> -	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
> +	args->hashval = xfs_dir2_hashname(dp->i_mount, name);
>  	args->inumber = inum;
>  	args->dp = dp;
>  	args->total = total;
> @@ -375,7 +364,7 @@ xfs_dir_lookup(
>  	args->name = name->name;
>  	args->namelen = name->len;
>  	args->filetype = name->type;
> -	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
> +	args->hashval = xfs_dir2_hashname(dp->i_mount, name);
>  	args->dp = dp;
>  	args->whichfork = XFS_DATA_FORK;
>  	args->trans = tp;
> @@ -447,7 +436,7 @@ xfs_dir_removename(
>  	args->name = name->name;
>  	args->namelen = name->len;
>  	args->filetype = name->type;
> -	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
> +	args->hashval = xfs_dir2_hashname(dp->i_mount, name);
>  	args->inumber = ino;
>  	args->dp = dp;
>  	args->total = total;
> @@ -508,7 +497,7 @@ xfs_dir_replace(
>  	args->name = name->name;
>  	args->namelen = name->len;
>  	args->filetype = name->type;
> -	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
> +	args->hashval = xfs_dir2_hashname(dp->i_mount, name);
>  	args->inumber = inum;
>  	args->dp = dp;
>  	args->total = total;
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 358151ddfa75..f9d83205659e 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -718,7 +718,7 @@ xfs_dir2_block_lookup_int(
>  		 * and buffer. If it's the first case-insensitive match, store
>  		 * the index and buffer and continue looking for an exact match.
>  		 */
> -		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
> +		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);

gcc complains about the unused @mp variable here.  With that fixed the
rest looks ok, so:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
>  			args->cmpresult = cmp;
>  			*bpp = bp;
> @@ -1218,8 +1218,7 @@ xfs_dir2_sf_to_block(
>  		xfs_dir2_data_log_entry(args, bp, dep);
>  		name.name = sfep->name;
>  		name.len = sfep->namelen;
> -		blp[2 + i].hashval =
> -			cpu_to_be32(mp->m_dirnameops->hashname(&name));
> +		blp[2 + i].hashval = cpu_to_be32(xfs_dir2_hashname(mp, &name));
>  		blp[2 + i].address =
>  			cpu_to_be32(xfs_dir2_byte_to_dataptr(newoffset));
>  		offset = (int)((char *)(tagp + 1) - (char *)hdr);
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 9e471a28b6c6..11b1f3021e66 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -236,7 +236,7 @@ __xfs_dir3_data_check(
>  						((char *)dep - (char *)hdr));
>  			name.name = dep->name;
>  			name.len = dep->namelen;
> -			hash = mp->m_dirnameops->hashname(&name);
> +			hash = xfs_dir2_hashname(mp, &name);
>  			for (i = 0; i < be32_to_cpu(btp->count); i++) {
>  				if (be32_to_cpu(lep[i].address) == addr &&
>  				    be32_to_cpu(lep[i].hashval) == hash)
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index e2e4b2c6d6c2..73edd96ce0ac 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -1288,7 +1288,7 @@ xfs_dir2_leaf_lookup_int(
>  		 * and buffer. If it's the first case-insensitive match, store
>  		 * the index and buffer and continue looking for an exact match.
>  		 */
> -		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
> +		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);
>  		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
>  			args->cmpresult = cmp;
>  			*indexp = index;
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index 5f30a1953a52..f0f67b7eb171 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -876,7 +876,7 @@ xfs_dir2_leafn_lookup_for_entry(
>  		 * EEXIST immediately. If it's the first case-insensitive
>  		 * match, store the block & inode number and continue looking.
>  		 */
> -		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
> +		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);
>  		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
>  			/* If there is a CI match block, drop it */
>  			if (args->cmpresult != XFS_CMP_DIFFERENT &&
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index a22222df4bf2..eb6af7daf803 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -40,6 +40,9 @@ struct xfs_dir3_icfree_hdr {
>  };
>  
>  /* xfs_dir2.c */
> +xfs_dahash_t xfs_ascii_ci_hashname(struct xfs_name *name);
> +enum xfs_dacmp xfs_ascii_ci_compname(struct xfs_da_args *args,
> +		const unsigned char *name, int len);
>  extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
>  				xfs_dir2_db_t *dbp);
>  extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
> @@ -191,4 +194,25 @@ xfs_dir2_data_entsize(
>  	return round_up(len, XFS_DIR2_DATA_ALIGN);
>  }
>  
> +static inline xfs_dahash_t
> +xfs_dir2_hashname(
> +	struct xfs_mount	*mp,
> +	struct xfs_name		*name)
> +{
> +	if (unlikely(xfs_sb_version_hasasciici(&mp->m_sb)))
> +		return xfs_ascii_ci_hashname(name);
> +	return xfs_da_hashname(name->name, name->len);
> +}
> +
> +static inline enum xfs_dacmp
> +xfs_dir2_compname(
> +	struct xfs_da_args	*args,
> +	const unsigned char	*name,
> +	int			len)
> +{
> +	if (unlikely(xfs_sb_version_hasasciici(&args->dp->i_mount->m_sb)))
> +		return xfs_ascii_ci_compname(args, name, len);
> +	return xfs_da_compname(args, name, len);
> +}
> +
>  #endif /* __XFS_DIR2_PRIV_H__ */
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index db1a82972d9e..41eb8a676bf3 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -914,8 +914,7 @@ xfs_dir2_sf_lookup(
>  		 * number. If it's the first case-insensitive match, store the
>  		 * inode number and continue looking for an exact match.
>  		 */
> -		cmp = dp->i_mount->m_dirnameops->compname(args, sfep->name,
> -								sfep->namelen);
> +		cmp = xfs_dir2_compname(args, sfep->name, sfep->namelen);
>  		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
>  			args->cmpresult = cmp;
>  			args->inumber = xfs_dir2_sf_get_ino(mp, sfp, sfep);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 43145a4ab690..247c2b15a22c 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -9,7 +9,6 @@
>  struct xlog;
>  struct xfs_inode;
>  struct xfs_mru_cache;
> -struct xfs_nameops;
>  struct xfs_ail;
>  struct xfs_quotainfo;
>  struct xfs_da_geometry;
> @@ -154,7 +153,6 @@ typedef struct xfs_mount {
>  	int			m_dalign;	/* stripe unit */
>  	int			m_swidth;	/* stripe width */
>  	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
> -	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
>  	atomic_t		m_active_trans;	/* number trans frozen */
>  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
>  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
> -- 
> 2.20.1
> 
