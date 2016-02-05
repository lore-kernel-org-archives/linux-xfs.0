Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F1A77CA2
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 08:20:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C8DE1AC002
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 06:20:51 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2DdiWrNWCHGMxYBl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2016 06:20:50 -0800 (PST)
Date: Fri, 5 Feb 2016 09:20:48 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] metadump: bounds check btree block regions being
	zeroed
Message-ID: <20160205142047.GA52478@bfoster.bfoster>
References: <1454626858-17823-1-git-send-email-david@fromorbit.com>
	<1454626858-17823-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454626858-17823-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 05, 2016 at 10:00:57AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Arkadiusz Miskiewicz reported that metadump was crashing on one of
> his corrupted filesystems, and the trace indicated that it was
> zeroing unused regions in inode btree blocks when it failed. The
> btree block had a corrupt nrecs field, which was resulting in an out
> of bounds memset() occurring.  Ensure that the region being
> generated for zeroing is within bounds before executing the zeroing.
> 
> Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  db/metadump.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index a185da5..26a3bd5 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -246,6 +246,11 @@ write_buf(
>  	return seenint() ? -EINTR : 0;
>  }
>  
> +/*
> + * We could be processing a corrupt block, so we can't trust any of
> + * the offsets or lengths to be within the buffer range. Hence check
> + * carefully!
> + */
>  static void
>  zero_btree_node(
>  	struct xfs_btree_block	*block,
> @@ -262,10 +267,15 @@ zero_btree_node(
>  	char			*key_end;
>  
>  	nrecs = be16_to_cpu(block->bb_numrecs);
> +	if (nrecs < 0)
> +		return;
>  
>  	switch (btype) {
>  	case TYP_BMAPBTA:
>  	case TYP_BMAPBTD:
> +		if (nrecs > mp->m_bmap_dmxr[1])
> +			return;
> +
>  		bkp = XFS_BMBT_KEY_ADDR(mp, block, 1);
>  		bpp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
>  		zp1 = (char *)&bkp[nrecs];
> @@ -274,6 +284,9 @@ zero_btree_node(
>  		break;
>  	case TYP_INOBT:
>  	case TYP_FINOBT:
> +		if (nrecs > mp->m_inobt_mxr[1])
> +			return;
> +
>  		ikp = XFS_INOBT_KEY_ADDR(mp, block, 1);
>  		ipp = XFS_INOBT_PTR_ADDR(mp, block, 1, mp->m_inobt_mxr[1]);
>  		zp1 = (char *)&ikp[nrecs];
> @@ -282,6 +295,9 @@ zero_btree_node(
>  		break;
>  	case TYP_BNOBT:
>  	case TYP_CNTBT:
> +		if (nrecs > mp->m_alloc_mxr[1])
> +			return;
> +
>  		akp = XFS_ALLOC_KEY_ADDR(mp, block, 1);
>  		app = XFS_ALLOC_PTR_ADDR(mp, block, 1, mp->m_alloc_mxr[1]);
>  		zp1 = (char *)&akp[nrecs];
> @@ -300,6 +316,11 @@ zero_btree_node(
>  	memset(zp2, 0, (char *)block + mp->m_sb.sb_blocksize - zp2);
>  }
>  
> +/*
> + * We could be processing a corrupt block, so we can't trust any of
> + * the offsets or lengths to be within the buffer range. Hence check
> + * carefully!
> + */
>  static void
>  zero_btree_leaf(
>  	struct xfs_btree_block	*block,
> @@ -312,20 +333,31 @@ zero_btree_leaf(
>  	char			*zp;
>  
>  	nrecs = be16_to_cpu(block->bb_numrecs);
> +	if (nrecs < 0)
> +		return;
>  
>  	switch (btype) {
>  	case TYP_BMAPBTA:
>  	case TYP_BMAPBTD:
> +		if (nrecs > mp->m_bmap_dmxr[0])
> +			return;
> +
>  		brp = XFS_BMBT_REC_ADDR(mp, block, 1);
>  		zp = (char *)&brp[nrecs];
>  		break;
>  	case TYP_INOBT:
>  	case TYP_FINOBT:
> +		if (nrecs > mp->m_inobt_mxr[0])
> +			return;
> +
>  		irp = XFS_INOBT_REC_ADDR(mp, block, 1);
>  		zp = (char *)&irp[nrecs];
>  		break;
>  	case TYP_BNOBT:
>  	case TYP_CNTBT:
> +		if (nrecs > mp->m_alloc_mxr[0])
> +			return;
> +
>  		arp = XFS_ALLOC_REC_ADDR(mp, block, 1);
>  		zp = (char *)&arp[nrecs];
>  		break;
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
