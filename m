Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FCC2C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13ECB20673
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 01:01:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kSrB4c6P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfKHBBo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 20:01:44 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHBBo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 20:01:44 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80woN8160871;
        Fri, 8 Nov 2019 01:01:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=DFm1zBGKjSafqQIF38fVbjIZxpuORrdjrZsRL33oAKg=;
 b=kSrB4c6PynkWh4B+eyQkL2R2E2JvlVUSn2hf7PcpbQDkRpT0n+1VHE6POpekq6D7O4L6
 atAc+S84ioauNyYHrVQI4fOpoa18Js7aW8g0lvE4jGw2dNZQkfisVcdYCUlpwzzGdrPC
 YyAvk5GDPdfHk2NUyXecVPYHTtZVB0JaNUfD9J2q6MRr0oqegAOkfuC9wh54IEHdbnfi
 OgKiY9cFwllyhLIuIMtAHqtUyXBWuXQSCyHbBcGN1cC9WFbfdEgeptZIRU/pce8fWPQn
 5/pEK7ZCbkYwlW2Edt0rV4pznx+gt3GbdccmPhC5qWi5H/1yyA83J78dBeIT/RFuC+ky SQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w41w12037-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 01:01:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA80s7UU033593;
        Fri, 8 Nov 2019 01:01:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w4k2xyccg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 01:01:39 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA811dmc022871;
        Fri, 8 Nov 2019 01:01:39 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 17:01:39 -0800
Date:   Thu, 7 Nov 2019 17:01:39 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/46] xfs: cleanup __xfs_dir3_data_check
Message-ID: <20191108010139.GF6219@magnolia>
References: <20191107182410.12660-1-hch@lst.de>
 <20191107182410.12660-36-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107182410.12660-36-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 07:23:59PM +0100, Christoph Hellwig wrote:
> Use an offset as the main means for iteration, and only do pointer
> arithmetics to find the data/unused entries.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_data.c | 59 ++++++++++++++++++++---------------
>  1 file changed, 33 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 50e3fa092ff9..8c729270f9f1 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -23,6 +23,22 @@ static xfs_failaddr_t xfs_dir2_data_freefind_verify(
>  		struct xfs_dir2_data_unused *dup,
>  		struct xfs_dir2_data_free **bf_ent);
>  
> +/*
> + * The number of leaf entries is limited by the size of the block and the amount
> + * of space used by the data entries.  We don't know how much space is used by
> + * the data entries yet, so just ensure that the count falls somewhere inside
> + * the block right now.
> + */
> +static inline unsigned int
> +xfs_dir2_data_max_leaf_entries(
> +	const struct xfs_dir_ops	*ops,
> +	struct xfs_da_geometry		*geo)
> +{
> +	return (geo->blksize - sizeof(struct xfs_dir2_block_tail) -
> +		ops->data_entry_offset) /
> +			sizeof(struct xfs_dir2_leaf_entry);
> +}
> +
>  /*
>   * Check the consistency of the data block.
>   * The input can also be a block-format directory.
> @@ -38,23 +54,20 @@ __xfs_dir3_data_check(
>  	xfs_dir2_block_tail_t	*btp=NULL;	/* block tail */
>  	int			count;		/* count of entries found */
>  	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
> -	xfs_dir2_data_entry_t	*dep;		/* data entry */
>  	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
> -	xfs_dir2_data_unused_t	*dup;		/* unused entry */
> -	char			*endp;		/* end of useful data */
> +	void			*endp;		/* end of useful data */
>  	int			freeseen;	/* mask of bestfrees seen */
>  	xfs_dahash_t		hash;		/* hash of current name */
>  	int			i;		/* leaf index */
>  	int			lastfree;	/* last entry was unused */
>  	xfs_dir2_leaf_entry_t	*lep=NULL;	/* block leaf entries */
>  	struct xfs_mount	*mp = bp->b_mount;
> -	char			*p;		/* current data position */
>  	int			stale;		/* count of stale leaves */
>  	struct xfs_name		name;
> +	unsigned int		offset;
> +	unsigned int		end;
>  	const struct xfs_dir_ops *ops;
> -	struct xfs_da_geometry	*geo;
> -
> -	geo = mp->m_dir_geo;
> +	struct xfs_da_geometry	*geo = mp->m_dir_geo;
>  
>  	/*
>  	 * We can be passed a null dp here from a verifier, so we need to go the
> @@ -71,7 +84,7 @@ __xfs_dir3_data_check(
>  		return __this_address;
>  
>  	hdr = bp->b_addr;
> -	p = (char *)ops->data_entry_p(hdr);
> +	offset = ops->data_entry_offset;
>  
>  	switch (hdr->magic) {
>  	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
> @@ -79,15 +92,8 @@ __xfs_dir3_data_check(
>  		btp = xfs_dir2_block_tail_p(geo, hdr);
>  		lep = xfs_dir2_block_leaf_p(btp);
>  
> -		/*
> -		 * The number of leaf entries is limited by the size of the
> -		 * block and the amount of space used by the data entries.
> -		 * We don't know how much space is used by the data entries yet,
> -		 * so just ensure that the count falls somewhere inside the
> -		 * block right now.
> -		 */
>  		if (be32_to_cpu(btp->count) >=
> -		    ((char *)btp - p) / sizeof(struct xfs_dir2_leaf_entry))
> +		    xfs_dir2_data_max_leaf_entries(ops, geo))
>  			return __this_address;
>  		break;
>  	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
> @@ -99,6 +105,7 @@ __xfs_dir3_data_check(
>  	endp = xfs_dir3_data_endp(geo, hdr);
>  	if (!endp)
>  		return __this_address;
> +	end = endp - bp->b_addr;
>  
>  	/*
>  	 * Account for zero bestfree entries.
> @@ -128,8 +135,10 @@ __xfs_dir3_data_check(
>  	/*
>  	 * Loop over the data/unused entries.
>  	 */
> -	while (p < endp) {
> -		dup = (xfs_dir2_data_unused_t *)p;
> +	while (offset < end) {
> +		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
> +		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
> +
>  		/*
>  		 * If it's unused, look for the space in the bestfree table.
>  		 * If we find it, account for that, else make sure it
> @@ -140,10 +149,10 @@ __xfs_dir3_data_check(
>  
>  			if (lastfree != 0)
>  				return __this_address;
> -			if (endp < p + be16_to_cpu(dup->length))
> +			if (offset + be16_to_cpu(dup->length) > end)
>  				return __this_address;
>  			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
> -			    (char *)dup - (char *)hdr)
> +			    offset)
>  				return __this_address;
>  			fa = xfs_dir2_data_freefind_verify(hdr, bf, dup, &dfp);
>  			if (fa)
> @@ -158,7 +167,7 @@ __xfs_dir3_data_check(
>  				    be16_to_cpu(bf[2].length))
>  					return __this_address;
>  			}
> -			p += be16_to_cpu(dup->length);
> +			offset += be16_to_cpu(dup->length);
>  			lastfree = 1;
>  			continue;
>  		}
> @@ -168,15 +177,13 @@ __xfs_dir3_data_check(
>  		 * in the leaf section of the block.
>  		 * The linear search is crude but this is DEBUG code.
>  		 */
> -		dep = (xfs_dir2_data_entry_t *)p;
>  		if (dep->namelen == 0)
>  			return __this_address;
>  		if (xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)))
>  			return __this_address;
> -		if (endp < p + ops->data_entsize(dep->namelen))
> +		if (offset + ops->data_entsize(dep->namelen) > end)
>  			return __this_address;
> -		if (be16_to_cpu(*ops->data_entry_tag_p(dep)) !=
> -		    (char *)dep - (char *)hdr)
> +		if (be16_to_cpu(*ops->data_entry_tag_p(dep)) != offset)
>  			return __this_address;
>  		if (ops->data_get_ftype(dep) >= XFS_DIR3_FT_MAX)
>  			return __this_address;
> @@ -198,7 +205,7 @@ __xfs_dir3_data_check(
>  			if (i >= be32_to_cpu(btp->count))
>  				return __this_address;
>  		}
> -		p += ops->data_entsize(dep->namelen);
> +		offset += ops->data_entsize(dep->namelen);
>  	}
>  	/*
>  	 * Need to have seen all the entries and all the bestfree slots.
> -- 
> 2.20.1
> 
