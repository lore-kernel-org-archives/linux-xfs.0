Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD69CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 140AF204FD
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:26:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ezjF9bMr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbfKDU0z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:26:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59464 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfKDU0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:26:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KOJZW117279;
        Mon, 4 Nov 2019 20:26:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Fft5oYs0YPLKYhGiHOAb5iJZ+G3CZpvdg1GbJ0q2kto=;
 b=ezjF9bMrieWFOExTsBSnTa4Ktw8PYAP9toIp88PxUWcQljs3uNY8BmeN4hC8D31TgtAO
 gOGNZO0XXEZ6y8O4/OlIUDtbqqqk+hV3GjU1qW/5ab9zUvDqfJfuXDSQDTjIEfhglt8S
 eAp0FrvPKGfD9LD0TxpJFMHY94BcWx1uZspJLFNbEP3ZhJVzgQsceBjZ/xvx3npTgDa5
 7L5MQnbKrVQaiCEs5L5VHSNAkkvBRyFiNDUMZU/Kog5oF2ZIi+LGJzDd/W0NuvmTtcEB
 /2y0F7f+P/1oqB8Sd/Y8c6LR8NBRK0caje4j3ocp46nboCzcXwHvG/aFPERHwdhS7WkM nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w11rpsw3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:26:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4KOGB6129662;
        Mon, 4 Nov 2019 20:26:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w1kxdws3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:26:50 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4KQoM4032280;
        Mon, 4 Nov 2019 20:26:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:26:49 -0800
Date:   Mon, 4 Nov 2019 12:26:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/34] xfs: devirtualize ->sf_get_parent_ino and
 ->sf_put_parent_ino
Message-ID: <20191104202648.GU4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-20-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-20-hch@lst.de>
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

On Fri, Nov 01, 2019 at 03:07:04PM -0700, Christoph Hellwig wrote:
> The parent inode handling is the same for all directory format variants,
> just use direct calls instead of going through a pointless indirect
> call.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_format.c  | 10 ++--------
>  fs/xfs/libxfs/xfs_dir2.h       |  3 ---
>  fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
>  fs/xfs/libxfs/xfs_dir2_priv.h  |  2 ++
>  fs/xfs/libxfs/xfs_dir2_sf.c    | 20 ++++++++++----------
>  fs/xfs/xfs_dir2_readdir.c      |  2 +-
>  6 files changed, 16 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 2b708b9fae1a..7858469c09e4 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -132,14 +132,14 @@ xfs_dir2_sf_put_ino(
>  		put_unaligned_be32(ino, to);
>  }
>  
> -static xfs_ino_t
> +xfs_ino_t
>  xfs_dir2_sf_get_parent_ino(
>  	struct xfs_dir2_sf_hdr	*hdr)
>  {
>  	return xfs_dir2_sf_get_ino(hdr, hdr->parent);
>  }
>  
> -static void
> +void
>  xfs_dir2_sf_put_parent_ino(
>  	struct xfs_dir2_sf_hdr	*hdr,
>  	xfs_ino_t		ino)
> @@ -407,8 +407,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.sf_put_ftype = xfs_dir2_sfe_put_ftype,
>  	.sf_get_ino = xfs_dir2_sfe_get_ino,
>  	.sf_put_ino = xfs_dir2_sfe_put_ino,
> -	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
> -	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
>  
>  	.data_entsize = xfs_dir2_data_entsize,
>  	.data_get_ftype = xfs_dir2_data_get_ftype,
> @@ -438,8 +436,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
>  	.sf_get_ino = xfs_dir3_sfe_get_ino,
>  	.sf_put_ino = xfs_dir3_sfe_put_ino,
> -	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
> -	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
>  
>  	.data_entsize = xfs_dir3_data_entsize,
>  	.data_get_ftype = xfs_dir3_data_get_ftype,
> @@ -469,8 +465,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.sf_put_ftype = xfs_dir3_sfe_put_ftype,
>  	.sf_get_ino = xfs_dir3_sfe_get_ino,
>  	.sf_put_ino = xfs_dir3_sfe_put_ino,
> -	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
> -	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
>  
>  	.data_entsize = xfs_dir3_data_entsize,
>  	.data_get_ftype = xfs_dir3_data_get_ftype,
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index e302679d8c80..d3a0b8daab5f 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -44,9 +44,6 @@ struct xfs_dir_ops {
>  	void	(*sf_put_ino)(struct xfs_dir2_sf_hdr *hdr,
>  			      struct xfs_dir2_sf_entry *sfep,
>  			      xfs_ino_t ino);
> -	xfs_ino_t (*sf_get_parent_ino)(struct xfs_dir2_sf_hdr *hdr);
> -	void	(*sf_put_parent_ino)(struct xfs_dir2_sf_hdr *hdr,
> -				     xfs_ino_t ino);
>  
>  	int	(*data_entsize)(int len);
>  	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 38886b9c7b48..2ee9fdd182e1 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1163,7 +1163,7 @@ xfs_dir2_sf_to_block(
>  	 * Create entry for ..
>  	 */
>  	dep = dp->d_ops->data_dotdot_entry_p(hdr);
> -	dep->inumber = cpu_to_be64(dp->d_ops->sf_get_parent_ino(sfp));
> +	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
>  	dep->namelen = 2;
>  	dep->name[0] = dep->name[1] = '.';
>  	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index b73cf38c6969..d5104fdb8543 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -135,6 +135,8 @@ extern int xfs_dir2_free_read(struct xfs_trans *tp, struct xfs_inode *dp,
>  		xfs_dablk_t fbno, struct xfs_buf **bpp);
>  
>  /* xfs_dir2_sf.c */
> +xfs_ino_t xfs_dir2_sf_get_parent_ino(struct xfs_dir2_sf_hdr *hdr);
> +void xfs_dir2_sf_put_parent_ino(struct xfs_dir2_sf_hdr *hdr, xfs_ino_t ino);
>  extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
>  		struct xfs_dir2_data_hdr *block, struct xfs_dir2_sf_hdr *sfhp);
>  extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index ae16ca7c422a..1d7c26d0157c 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -125,7 +125,7 @@ xfs_dir2_block_sfsize(
>  	 */
>  	sfhp->count = count;
>  	sfhp->i8count = i8count;
> -	dp->d_ops->sf_put_parent_ino(sfhp, parent);
> +	xfs_dir2_sf_put_parent_ino(sfhp, parent);
>  	return size;
>  }
>  
> @@ -204,7 +204,7 @@ xfs_dir2_block_to_sf(
>  		else if (dep->namelen == 2 &&
>  			 dep->name[0] == '.' && dep->name[1] == '.')
>  			ASSERT(be64_to_cpu(dep->inumber) ==
> -			       dp->d_ops->sf_get_parent_ino(sfp));
> +			       xfs_dir2_sf_get_parent_ino(sfp));
>  		/*
>  		 * Normal entry, copy it into shortform.
>  		 */
> @@ -590,7 +590,7 @@ xfs_dir2_sf_check(
>  
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>  	offset = dp->d_ops->data_first_offset;
> -	ino = dp->d_ops->sf_get_parent_ino(sfp);
> +	ino = xfs_dir2_sf_get_parent_ino(sfp);
>  	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
>  
>  	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
> @@ -653,7 +653,7 @@ xfs_dir2_sf_verify(
>  	endp = (char *)sfp + size;
>  
>  	/* Check .. entry */
> -	ino = dops->sf_get_parent_ino(sfp);
> +	ino = xfs_dir2_sf_get_parent_ino(sfp);
>  	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
>  	error = xfs_dir_ino_validate(mp, ino);
>  	if (error)
> @@ -763,7 +763,7 @@ xfs_dir2_sf_create(
>  	/*
>  	 * Now can put in the inode number, since i8count is set.
>  	 */
> -	dp->d_ops->sf_put_parent_ino(sfp, pino);
> +	xfs_dir2_sf_put_parent_ino(sfp, pino);
>  	sfp->count = 0;
>  	dp->i_d.di_size = size;
>  	xfs_dir2_sf_check(args);
> @@ -818,7 +818,7 @@ xfs_dir2_sf_lookup(
>  	 */
>  	if (args->namelen == 2 &&
>  	    args->name[0] == '.' && args->name[1] == '.') {
> -		args->inumber = dp->d_ops->sf_get_parent_ino(sfp);
> +		args->inumber = xfs_dir2_sf_get_parent_ino(sfp);
>  		args->cmpresult = XFS_CMP_EXACT;
>  		args->filetype = XFS_DIR3_FT_DIR;
>  		return -EEXIST;
> @@ -1008,9 +1008,9 @@ xfs_dir2_sf_replace(
>  	 */
>  	if (args->namelen == 2 &&
>  	    args->name[0] == '.' && args->name[1] == '.') {
> -		ino = dp->d_ops->sf_get_parent_ino(sfp);
> +		ino = xfs_dir2_sf_get_parent_ino(sfp);
>  		ASSERT(args->inumber != ino);
> -		dp->d_ops->sf_put_parent_ino(sfp, args->inumber);
> +		xfs_dir2_sf_put_parent_ino(sfp, args->inumber);
>  	}
>  	/*
>  	 * Normal entry, look for the name.
> @@ -1116,7 +1116,7 @@ xfs_dir2_sf_toino4(
>  	 */
>  	sfp->count = oldsfp->count;
>  	sfp->i8count = 0;
> -	dp->d_ops->sf_put_parent_ino(sfp, dp->d_ops->sf_get_parent_ino(oldsfp));
> +	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
>  	/*
>  	 * Copy the entries field by field.
>  	 */
> @@ -1189,7 +1189,7 @@ xfs_dir2_sf_toino8(
>  	 */
>  	sfp->count = oldsfp->count;
>  	sfp->i8count = 1;
> -	dp->d_ops->sf_put_parent_ino(sfp, dp->d_ops->sf_get_parent_ino(oldsfp));
> +	xfs_dir2_sf_put_parent_ino(sfp, xfs_dir2_sf_get_parent_ino(oldsfp));
>  	/*
>  	 * Copy the entries field by field.
>  	 */
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index a0bec0931f3b..6f94d2a45174 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -92,7 +92,7 @@ xfs_dir2_sf_getdents(
>  	 * Put .. entry unless we're starting past it.
>  	 */
>  	if (ctx->pos <= dotdot_offset) {
> -		ino = dp->d_ops->sf_get_parent_ino(sfp);
> +		ino = xfs_dir2_sf_get_parent_ino(sfp);
>  		ctx->pos = dotdot_offset & 0x7fffffff;
>  		if (!dir_emit(ctx, "..", 2, ino, DT_DIR))
>  			return 0;
> -- 
> 2.20.1
> 
