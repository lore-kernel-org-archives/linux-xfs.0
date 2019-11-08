Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E654C5DF61
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 147B4222C4
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:51:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RUNaXp1Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfKHAva (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:51:30 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44292 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHAva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:51:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80dHld146737;
        Fri, 8 Nov 2019 00:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=UyW03tJfwn72TjsFYCna+gFi3lAIzoJh6bo5VMIs5Yg=;
 b=RUNaXp1QafALZ2fhdRi4o6NdZeNm2535uXQlPqxNOyB0yUqIT1UrsMH/o//lhkTxRpZQ
 oJwKhu0PuYKwAhmxpj1uwNOup7//Oujv8OTDOmWu9ADBIRJS3R/YbfaJzUq15xpmkupz
 3z9X4HlrgSWCIbB9jf5DzffyD1Ih4dZl5HVLX6GRDBXd9+7JUQygknK4gvjK8I12CLy7
 EVbXIQ9o9KoGUVHl3IZJaZvfyw686s07atbYydytiPxucxa7QL+tiqQxponu5RVRbeva
 suOceRThqNszsC0UTnzqye23X8I24r4jsH7OOA9Kg54KybtnXr1dcvLuz3d+Y4h+Bk9D dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w41w11xr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:51:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80dCZX134973;
        Fri, 8 Nov 2019 00:49:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w41wg9xwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:49:23 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA80nMpC031161;
        Fri, 8 Nov 2019 00:49:22 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:49:22 -0800
Date:   Thu, 7 Nov 2019 16:49:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/46] xfs: remove the ->data_dot_entry_p and
 ->data_dotdot_entry_p methods
Message-ID: <20191108004922.GX6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-28-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-28-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:23:51PM +0100, Christoph Hellwig wrote:
> The only user of the ->data_dot_entry_p and ->data_dotdot_entry_p
> methods is the xfs_dir2_sf_to_block function that builds block format
> directorys from a short form directory.  It already uses pointer
> arithmetics with a offset variable to do so for the real entries in
> the directory, so switch the generation of the . and .. entries to
> the same scheme, and clean up some of the later pointer arithmetics
> to use bp->b_addr directly as well and avoid some casts.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_da_format.c  | 52 --------------------------------
>  fs/xfs/libxfs/xfs_dir2.h       |  4 ---
>  fs/xfs/libxfs/xfs_dir2_block.c | 54 ++++++++++++++++------------------
>  3 files changed, 26 insertions(+), 84 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 7b783b11790d..711faff4aea2 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -111,52 +111,6 @@ xfs_dir3_data_entry_tag_p(
>  		xfs_dir3_data_entsize(dep->namelen) - sizeof(__be16));
>  }
>  
> -/*
> - * location of . and .. in data space (always block 0)
> - */
> -static struct xfs_dir2_data_entry *
> -xfs_dir2_data_dot_entry_p(
> -	struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
> -}
> -
> -static struct xfs_dir2_data_entry *
> -xfs_dir2_data_dotdot_entry_p(
> -	struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
> -				XFS_DIR2_DATA_ENTSIZE(1));
> -}
> -
> -static struct xfs_dir2_data_entry *
> -xfs_dir2_ftype_data_dotdot_entry_p(
> -	struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
> -				XFS_DIR3_DATA_ENTSIZE(1));
> -}
> -
> -static struct xfs_dir2_data_entry *
> -xfs_dir3_data_dot_entry_p(
> -	struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
> -}
> -
> -static struct xfs_dir2_data_entry *
> -xfs_dir3_data_dotdot_entry_p(
> -	struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir3_data_hdr) +
> -				XFS_DIR3_DATA_ENTSIZE(1));
> -}
> -
>  static struct xfs_dir2_data_free *
>  xfs_dir2_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
>  {
> @@ -209,8 +163,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  				XFS_DIR2_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
>  
> -	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
> -	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  };
> @@ -227,8 +179,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  				XFS_DIR3_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
>  
> -	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
> -	.data_dotdot_entry_p = xfs_dir2_ftype_data_dotdot_entry_p,
>  	.data_entry_p = xfs_dir2_data_entry_p,
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  };
> @@ -245,8 +195,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  				XFS_DIR3_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
>  
> -	.data_dot_entry_p = xfs_dir3_data_dot_entry_p,
> -	.data_dotdot_entry_p = xfs_dir3_data_dotdot_entry_p,
>  	.data_entry_p = xfs_dir3_data_entry_p,
>  	.data_unused_p = xfs_dir3_data_unused_p,
>  };
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 8b937993263d..8bfcf4c1b9c4 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -43,10 +43,6 @@ struct xfs_dir_ops {
>  	xfs_dir2_data_aoff_t data_first_offset;
>  	size_t	data_entry_offset;
>  
> -	struct xfs_dir2_data_entry *
> -		(*data_dot_entry_p)(struct xfs_dir2_data_hdr *hdr);
> -	struct xfs_dir2_data_entry *
> -		(*data_dotdot_entry_p)(struct xfs_dir2_data_hdr *hdr);
>  	struct xfs_dir2_data_entry *
>  		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
>  	struct xfs_dir2_data_unused *
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 6bc82a02b228..e7719356829d 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1038,39 +1038,35 @@ xfs_dir2_leaf_to_block(
>   */
>  int						/* error */
>  xfs_dir2_sf_to_block(
> -	xfs_da_args_t		*args)		/* operation arguments */
> +	struct xfs_da_args	*args)
>  {
> +	struct xfs_trans	*tp = args->trans;
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(dp, XFS_DATA_FORK);
>  	xfs_dir2_db_t		blkno;		/* dir-relative block # (0) */
>  	xfs_dir2_data_hdr_t	*hdr;		/* block header */
>  	xfs_dir2_leaf_entry_t	*blp;		/* block leaf entries */
>  	struct xfs_buf		*bp;		/* block buffer */
>  	xfs_dir2_block_tail_t	*btp;		/* block tail pointer */
>  	xfs_dir2_data_entry_t	*dep;		/* data entry pointer */
> -	xfs_inode_t		*dp;		/* incore directory inode */
>  	int			dummy;		/* trash */
>  	xfs_dir2_data_unused_t	*dup;		/* unused entry pointer */
>  	int			endoffset;	/* end of data objects */
>  	int			error;		/* error return value */
>  	int			i;		/* index */
> -	xfs_mount_t		*mp;		/* filesystem mount point */
>  	int			needlog;	/* need to log block header */
>  	int			needscan;	/* need to scan block freespc */
>  	int			newoffset;	/* offset from current entry */
> -	int			offset;		/* target block offset */
> +	unsigned int		offset = dp->d_ops->data_entry_offset;
>  	xfs_dir2_sf_entry_t	*sfep;		/* sf entry pointer */
>  	xfs_dir2_sf_hdr_t	*oldsfp;	/* old shortform header  */
>  	xfs_dir2_sf_hdr_t	*sfp;		/* shortform header  */
>  	__be16			*tagp;		/* end of data entry */
> -	xfs_trans_t		*tp;		/* transaction pointer */
>  	struct xfs_name		name;
> -	struct xfs_ifork	*ifp;
>  
>  	trace_xfs_dir2_sf_to_block(args);
>  
> -	dp = args->dp;
> -	tp = args->trans;
> -	mp = dp->i_mount;
> -	ifp = XFS_IFORK_PTR(dp, XFS_DATA_FORK);
>  	ASSERT(ifp->if_flags & XFS_IFINLINE);
>  	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
>  
> @@ -1139,35 +1135,37 @@ xfs_dir2_sf_to_block(
>  			be16_to_cpu(dup->length), &needlog, &needscan);
>  	if (error)
>  		goto out_free;
> +
>  	/*
>  	 * Create entry for .
>  	 */
> -	dep = dp->d_ops->data_dot_entry_p(hdr);
> +	dep = bp->b_addr + offset;
>  	dep->inumber = cpu_to_be64(dp->i_ino);
>  	dep->namelen = 1;
>  	dep->name[0] = '.';
>  	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
>  	tagp = dp->d_ops->data_entry_tag_p(dep);
> -	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> +	*tagp = cpu_to_be16(offset);
>  	xfs_dir2_data_log_entry(args, bp, dep);
>  	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
> -	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
> -				(char *)dep - (char *)hdr));
> +	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(offset));
> +	offset += dp->d_ops->data_entsize(dep->namelen);
> +
>  	/*
>  	 * Create entry for ..
>  	 */
> -	dep = dp->d_ops->data_dotdot_entry_p(hdr);
> +	dep = bp->b_addr + offset;

This is kind of a lot of open-coded void pointer arithmetic for my
tastes, but OTOH I guess there's not much of a way around that for
variable length records...

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
>  	dep->namelen = 2;
>  	dep->name[0] = dep->name[1] = '.';
>  	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
>  	tagp = dp->d_ops->data_entry_tag_p(dep);
> -	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> +	*tagp = cpu_to_be16(offset);
>  	xfs_dir2_data_log_entry(args, bp, dep);
>  	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
> -	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
> -				(char *)dep - (char *)hdr));
> -	offset = dp->d_ops->data_first_offset;
> +	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(offset));
> +	offset += dp->d_ops->data_entsize(dep->namelen);
> +
>  	/*
>  	 * Loop over existing entries, stuff them in.
>  	 */
> @@ -1176,6 +1174,7 @@ xfs_dir2_sf_to_block(
>  		sfep = NULL;
>  	else
>  		sfep = xfs_dir2_sf_firstentry(sfp);
> +
>  	/*
>  	 * Need to preserve the existing offset values in the sf directory.
>  	 * Insert holes (unused entries) where necessary.
> @@ -1192,11 +1191,10 @@ xfs_dir2_sf_to_block(
>  		 * There should be a hole here, make one.
>  		 */
>  		if (offset < newoffset) {
> -			dup = (xfs_dir2_data_unused_t *)((char *)hdr + offset);
> +			dup = bp->b_addr + offset;
>  			dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
>  			dup->length = cpu_to_be16(newoffset - offset);
> -			*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16(
> -				((char *)dup - (char *)hdr));
> +			*xfs_dir2_data_unused_tag_p(dup) = cpu_to_be16(offset);
>  			xfs_dir2_data_log_unused(args, bp, dup);
>  			xfs_dir2_data_freeinsert(hdr,
>  						 dp->d_ops->data_bestfree_p(hdr),
> @@ -1207,20 +1205,20 @@ xfs_dir2_sf_to_block(
>  		/*
>  		 * Copy a real entry.
>  		 */
> -		dep = (xfs_dir2_data_entry_t *)((char *)hdr + newoffset);
> +		dep = bp->b_addr + newoffset;
>  		dep->inumber = cpu_to_be64(xfs_dir2_sf_get_ino(mp, sfp, sfep));
>  		dep->namelen = sfep->namelen;
>  		dp->d_ops->data_put_ftype(dep, xfs_dir2_sf_get_ftype(mp, sfep));
>  		memcpy(dep->name, sfep->name, dep->namelen);
>  		tagp = dp->d_ops->data_entry_tag_p(dep);
> -		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
> +		*tagp = cpu_to_be16(newoffset);
>  		xfs_dir2_data_log_entry(args, bp, dep);
>  		name.name = sfep->name;
>  		name.len = sfep->namelen;
> -		blp[2 + i].hashval = cpu_to_be32(mp->m_dirnameops->
> -							hashname(&name));
> -		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
> -						 (char *)dep - (char *)hdr));
> +		blp[2 + i].hashval =
> +			cpu_to_be32(mp->m_dirnameops->hashname(&name));
> +		blp[2 + i].address =
> +			cpu_to_be32(xfs_dir2_byte_to_dataptr(newoffset));
>  		offset = (int)((char *)(tagp + 1) - (char *)hdr);
>  		if (++i == sfp->count)
>  			sfep = NULL;
> -- 
> 2.20.1
> 
