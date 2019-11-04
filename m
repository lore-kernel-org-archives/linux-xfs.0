Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34037CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0FD6206BA
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 20:41:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CLQLxRVV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbfKDUlj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:41:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48554 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbfKDUlj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 15:41:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4Kcvbd129385;
        Mon, 4 Nov 2019 20:41:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qaHo5sWW/YU9SiBBn14xKlnvDbuJ8ER2+JwqrNGmag0=;
 b=CLQLxRVVl3P/ovENQeIePSZvk9J4+KOWFawSkdBeVg4nHsmeMaDFdg83zeA+v5sJ/fRl
 IsX5xX1Oz4ok4aOM6dKInFWd+Wb8Jiwk8fTpX80VXKsAeVlWtIPUOjDppILZ3izPLiXZ
 pmIoZ44yQPEPiI7KUxpyEhYiUxSKw+t8W5GbW7FrpIeSt6SrLvGLZzpHLuE2xZEj4HMB
 CoU9SRlo57d8h/bsOItNPgOUvNRK8wYGo6fKkyOLJXOKnMHEWBz8GI9C/4pJR+97q2Nq
 62FoGM8O/L4p3zqznySJwGwYhBitcElIDR63LLPnnbzGoe0PDZCzTEyTQQSnfNXB95FV +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w11rpsyq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:41:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4Kc0UP163385;
        Mon, 4 Nov 2019 20:41:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w1kaca4w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 20:41:34 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA4KfXNw012834;
        Mon, 4 Nov 2019 20:41:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 12:41:33 -0800
Date:   Mon, 4 Nov 2019 12:41:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/34] xfs: remove the ->data_entry_entry_p method
Message-ID: <20191104204132.GA4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-26-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-26-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040199
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040199
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:07:10PM -0700, Christoph Hellwig wrote:
> Replace the users of the ->data_entry_entry_p dir ops method with a
> direct calculation using ->data_entry_offset.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_da_format.c  | 37 ----------------------------------
>  fs/xfs/libxfs/xfs_dir2.h       |  5 -----
>  fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
>  fs/xfs/libxfs/xfs_dir2_data.c  |  6 +++---
>  fs/xfs/libxfs/xfs_dir2_sf.c    |  2 +-
>  fs/xfs/scrub/dir.c             |  4 ++--
>  fs/xfs/xfs_dir2_readdir.c      |  4 ++--
>  7 files changed, 9 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index 35edf470efc8..47c56f6dd872 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -123,34 +123,6 @@ xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
>  	return ((struct xfs_dir3_data_hdr *)hdr)->best_free;
>  }
>  
> -static struct xfs_dir2_data_entry *
> -xfs_dir2_data_entry_p(struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
> -}
> -
> -static struct xfs_dir2_data_unused *
> -xfs_dir2_data_unused_p(struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_unused *)
> -		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
> -}
> -
> -static struct xfs_dir2_data_entry *
> -xfs_dir3_data_entry_p(struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_entry *)
> -		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
> -}
> -
> -static struct xfs_dir2_data_unused *
> -xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
> -{
> -	return (struct xfs_dir2_data_unused *)
> -		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
> -}
> -
>  static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_entsize = xfs_dir2_data_entsize,
>  	.data_get_ftype = xfs_dir2_data_get_ftype,
> @@ -165,9 +137,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  				XFS_DIR2_DATA_ENTSIZE(1) +
>  				XFS_DIR2_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
> -
> -	.data_entry_p = xfs_dir2_data_entry_p,
> -	.data_unused_p = xfs_dir2_data_unused_p,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
> @@ -184,9 +153,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  				XFS_DIR3_DATA_ENTSIZE(1) +
>  				XFS_DIR3_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
> -
> -	.data_entry_p = xfs_dir2_data_entry_p,
> -	.data_unused_p = xfs_dir2_data_unused_p,
>  };
>  
>  static const struct xfs_dir_ops xfs_dir3_ops = {
> @@ -203,9 +169,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  				XFS_DIR3_DATA_ENTSIZE(1) +
>  				XFS_DIR3_DATA_ENTSIZE(2),
>  	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
> -
> -	.data_entry_p = xfs_dir3_data_entry_p,
> -	.data_unused_p = xfs_dir3_data_unused_p,
>  };
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 20417c42ca6f..e9de15e62630 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -44,11 +44,6 @@ struct xfs_dir_ops {
>  	xfs_dir2_data_aoff_t data_dotdot_offset;
>  	xfs_dir2_data_aoff_t data_first_offset;
>  	size_t	data_entry_offset;
> -
> -	struct xfs_dir2_data_entry *
> -		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
> -	struct xfs_dir2_data_unused *
> -		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
>  };
>  
>  extern const struct xfs_dir_ops *
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 34e0cdf03950..b32beb71b7b2 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -1122,7 +1122,7 @@ xfs_dir2_sf_to_block(
>  	 * The whole thing is initialized to free by the init routine.
>  	 * Say we're using the leaf and tail area.
>  	 */
> -	dup = dp->d_ops->data_unused_p(hdr);
> +	dup = (void *)hdr + dp->d_ops->data_entry_offset;
>  	needlog = needscan = 0;
>  	error = xfs_dir2_data_use_free(args, bp, dup, args->geo->blksize - i,
>  			i, &needlog, &needscan);
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 2c79be4c3153..edb3fe5c9174 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -71,7 +71,7 @@ __xfs_dir3_data_check(
>  		return __this_address;
>  
>  	hdr = bp->b_addr;
> -	p = (char *)ops->data_entry_p(hdr);
> +	p = (char *)hdr + ops->data_entry_offset;
>  
>  	switch (hdr->magic) {
>  	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
> @@ -587,7 +587,7 @@ xfs_dir2_data_freescan_int(
>  	/*
>  	 * Set up pointers.
>  	 */
> -	p = (char *)ops->data_entry_p(hdr);
> +	p = (char *)hdr + ops->data_entry_offset;
>  	endp = xfs_dir3_data_endp(geo, hdr);
>  	/*
>  	 * Loop over the block's entries.
> @@ -685,7 +685,7 @@ xfs_dir3_data_init(
>  	/*
>  	 * Set up an unused entry for the block's body.
>  	 */
> -	dup = dp->d_ops->data_unused_p(hdr);
> +	dup = (void *)hdr + dp->d_ops->data_entry_offset;
>  	dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
>  
>  	t = args->geo->blksize - (uint)dp->d_ops->data_entry_offset;
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 10199261c94c..b2c6c492b09d 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -296,7 +296,7 @@ xfs_dir2_block_to_sf(
>  	/*
>  	 * Set up to loop over the block's entries.
>  	 */
> -	ptr = (char *)dp->d_ops->data_entry_p(hdr);
> +	ptr = (char *)hdr + dp->d_ops->data_entry_offset;
>  	endptr = xfs_dir3_data_endp(args->geo, hdr);
>  	sfep = xfs_dir2_sf_firstentry(sfp);
>  	/*
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index dfaa0fca617e..8d6ecfe09611 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -241,7 +241,7 @@ xchk_dir_rec(
>  	dent = (struct xfs_dir2_data_entry *)(((char *)bp->b_addr) + off);
>  
>  	/* Make sure we got a real directory entry. */
> -	p = (char *)mp->m_dir_inode_ops->data_entry_p(bp->b_addr);
> +	p = bp->b_addr + mp->m_dir_inode_ops->data_entry_offset;
>  	endp = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
>  	if (!endp) {
>  		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
> @@ -391,7 +391,7 @@ xchk_directory_data_bestfree(
>  	}
>  
>  	/* Make sure the bestfrees are actually the best free spaces. */
> -	ptr = (char *)d_ops->data_entry_p(bp->b_addr);
> +	ptr = bp->b_addr + d_ops->data_entry_offset;
>  	endptr = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
>  
>  	/* Iterate the entries, stopping when we hit or go past the end. */
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index e18045465455..04f8c2451b93 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -176,7 +176,7 @@ xfs_dir2_block_getdents(
>  	/*
>  	 * Set up values for the loop.
>  	 */
> -	ptr = (char *)dp->d_ops->data_entry_p(hdr);
> +	ptr = (char *)hdr + dp->d_ops->data_entry_offset;
>  	endptr = xfs_dir3_data_endp(geo, hdr);
>  
>  	/*
> @@ -410,7 +410,7 @@ xfs_dir2_leaf_getdents(
>  			/*
>  			 * Find our position in the block.
>  			 */
> -			ptr = (char *)dp->d_ops->data_entry_p(hdr);
> +			ptr = (char *)hdr + dp->d_ops->data_entry_offset;

/me thinks we're open-coding this calculation enough to warrant a static
inline helper...

--D

>  			byteoff = xfs_dir2_byte_to_off(geo, curoff);
>  			/*
>  			 * Skip past the header.
> -- 
> 2.20.1
> 
