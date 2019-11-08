Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5B8C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:52:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD8012084D
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 00:52:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MZaaffvY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfKHAwe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 19:52:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57678 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfKHAwe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 19:52:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80d6iS159251;
        Fri, 8 Nov 2019 00:52:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=TmqekMXD0ZUC6Q+prYwTe4CsM4q/ByKHXGM5pbCRuGo=;
 b=MZaaffvYzgnbhXFt8fEbQQbbxFsKsglRWS1nTjX5tQ2MHW+xk5uv3vYinOAYK6L6g2RL
 P9ESCvjYofWI2gbGAO455hjimhNAVso+tOSkFhs2SR7fgzvgBetyMuaksWbV76XxJ3Nm
 wRBQegvKFxi0pSQ+FvtG2Kz2EoHKmKzEe49Qjt9iJPSqG8T5Au8XALTHbJNRQCcsyfNl
 R5YXsA/EoUlDjtzfbBXicQCZowPjRQhNcvEKKHarJB0aKPzRbm4iMF8PvhsuMqZPWVuv
 xt6AwZT2x4yo8ufXOvqFB2rfk7vRa1qQ1/nVET3xFOpzDb09J3OmvrtITUpgrPhHWSh/ Rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w41w11wv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:52:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80dR0Y130204;
        Fri, 8 Nov 2019 00:52:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w41wjmqqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 00:52:29 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA80qToT021257;
        Fri, 8 Nov 2019 00:52:29 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 16:52:29 -0800
Date:   Thu, 7 Nov 2019 16:52:28 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/46] xfs: cleanup xfs_dir2_block_getdents
Message-ID: <20191108005228.GA6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-30-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-30-hch@lst.de>
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

On Thu, Nov 07, 2019 at 07:23:53PM +0100, Christoph Hellwig wrote:
> Use an offset as the main means for iteration, and only do pointer
> arithmetics to find the data/unused entries.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_dir2_readdir.c | 32 ++++++++++++--------------------
>  1 file changed, 12 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 187bb51875c2..0d234b649d65 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -142,17 +142,14 @@ xfs_dir2_block_getdents(
>  	struct dir_context	*ctx)
>  {
>  	struct xfs_inode	*dp = args->dp;	/* incore directory inode */
> -	xfs_dir2_data_hdr_t	*hdr;		/* block header */
>  	struct xfs_buf		*bp;		/* buffer for block */
> -	xfs_dir2_data_entry_t	*dep;		/* block data entry */
> -	xfs_dir2_data_unused_t	*dup;		/* block unused entry */
> -	char			*endptr;	/* end of the data entries */
>  	int			error;		/* error return value */
> -	char			*ptr;		/* current data entry */
>  	int			wantoff;	/* starting block offset */
>  	xfs_off_t		cook;
>  	struct xfs_da_geometry	*geo = args->geo;
>  	int			lock_mode;
> +	unsigned int		offset;
> +	unsigned int		end;
>  
>  	/*
>  	 * If the block number in the offset is out of range, we're done.
> @@ -171,44 +168,39 @@ xfs_dir2_block_getdents(
>  	 * We'll skip entries before this.
>  	 */
>  	wantoff = xfs_dir2_dataptr_to_off(geo, ctx->pos);
> -	hdr = bp->b_addr;
>  	xfs_dir3_data_check(dp, bp);
> -	/*
> -	 * Set up values for the loop.
> -	 */
> -	ptr = (char *)dp->d_ops->data_entry_p(hdr);
> -	endptr = xfs_dir3_data_endp(geo, hdr);
>  
>  	/*
>  	 * Loop over the data portion of the block.
>  	 * Each object is a real entry (dep) or an unused one (dup).
>  	 */
> -	while (ptr < endptr) {
> +	offset = dp->d_ops->data_entry_offset;
> +	end = xfs_dir3_data_endp(geo, bp->b_addr) - bp->b_addr;
> +	while (offset < end) {
> +		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
> +		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
>  		uint8_t filetype;
>  
> -		dup = (xfs_dir2_data_unused_t *)ptr;
>  		/*
>  		 * Unused, skip it.
>  		 */
>  		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
> -			ptr += be16_to_cpu(dup->length);
> +			offset += be16_to_cpu(dup->length);
>  			continue;
>  		}
>  
> -		dep = (xfs_dir2_data_entry_t *)ptr;
> -
>  		/*
>  		 * Bump pointer for the next iteration.
>  		 */
> -		ptr += dp->d_ops->data_entsize(dep->namelen);
> +		offset += dp->d_ops->data_entsize(dep->namelen);
> +
>  		/*
>  		 * The entry is before the desired starting point, skip it.
>  		 */
> -		if ((char *)dep - (char *)hdr < wantoff)
> +		if (offset < wantoff)
>  			continue;
>  
> -		cook = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
> -					    (char *)dep - (char *)hdr);
> +		cook = xfs_dir2_db_off_to_dataptr(geo, geo->datablk, offset);
>  
>  		ctx->pos = cook & 0x7fffffff;
>  		filetype = dp->d_ops->data_get_ftype(dep);
> -- 
> 2.20.1
> 
