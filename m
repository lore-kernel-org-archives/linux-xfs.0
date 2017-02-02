Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43215 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751585AbdBBW4g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 17:56:36 -0500
Date: Thu, 2 Feb 2017 14:56:29 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] xfs: introduce xfs_aligned_fsb_count
Message-ID: <20170202225629.GO9134@birch.djwong.org>
References: <1485985359-971-1-git-send-email-hch@lst.de>
 <1485985359-971-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1485985359-971-3-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 01, 2017 at 10:42:37PM +0100, Christoph Hellwig wrote:
> Factor a helper to calculate the extent-size aligned block out of the
> iomap code, so that it can be reused by the upcoming reflink dio code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks like a reasonable enough code replacement, so:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_iomap.c | 11 ++---------
>  fs/xfs/xfs_iomap.h | 20 ++++++++++++++++++++
>  2 files changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index d17aa3b..9d811eb 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -162,7 +162,7 @@ xfs_iomap_write_direct(
>  	xfs_fileoff_t	last_fsb;
>  	xfs_filblks_t	count_fsb, resaligned;
>  	xfs_fsblock_t	firstfsb;
> -	xfs_extlen_t	extsz, temp;
> +	xfs_extlen_t	extsz;
>  	int		nimaps;
>  	int		quota_flag;
>  	int		rt;
> @@ -203,14 +203,7 @@ xfs_iomap_write_direct(
>  	}
>  	count_fsb = last_fsb - offset_fsb;
>  	ASSERT(count_fsb > 0);
> -
> -	resaligned = count_fsb;
> -	if (unlikely(extsz)) {
> -		if ((temp = do_mod(offset_fsb, extsz)))
> -			resaligned += temp;
> -		if ((temp = do_mod(resaligned, extsz)))
> -			resaligned += extsz - temp;
> -	}
> +	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb, extsz);
>  
>  	if (unlikely(rt)) {
>  		resrtextents = qblocks = resaligned;
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index 6d45cf0..1fef4a5 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -33,6 +33,26 @@ void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
>  		struct xfs_bmbt_irec *);
>  xfs_extlen_t xfs_eof_alignment(struct xfs_inode *ip, xfs_extlen_t extsize);
>  
> +static inline xfs_filblks_t
> +xfs_aligned_fsb_count(
> +	xfs_fileoff_t		offset_fsb,
> +	xfs_filblks_t		count_fsb,
> +	xfs_extlen_t		extsz)
> +{
> +	if (extsz) {
> +		xfs_extlen_t	align;
> +
> +		align = do_mod(offset_fsb, extsz);
> +		if (align)
> +			count_fsb += align;
> +		align = do_mod(count_fsb, extsz);
> +		if (align)
> +			count_fsb += extsz - align;
> +	}
> +
> +	return count_fsb;
> +}
> +
>  extern struct iomap_ops xfs_iomap_ops;
>  extern struct iomap_ops xfs_xattr_iomap_ops;
>  
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
