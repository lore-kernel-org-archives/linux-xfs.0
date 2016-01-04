Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C936F7F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 13:12:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B7528304062
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 11:11:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6ZF7xEFmkMmpe24q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 11:11:58 -0800 (PST)
Date: Mon, 4 Jan 2016 14:11:56 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/9] metadump: bounds check btree block regions being
	zeroed
Message-ID: <20160104191156.GB19852@bfoster.bfoster>
References: <1450733829-9319-1-git-send-email-david@fromorbit.com>
	<1450733829-9319-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1450733829-9319-3-git-send-email-david@fromorbit.com>
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

On Tue, Dec 22, 2015 at 08:37:02AM +1100, Dave Chinner wrote:
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
>  db/metadump.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index a185da5..1769fdf 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
...
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
> +		if (nrecs > mp->m_bmap_dmxr[1])
> +			return;
> +

Shouldn't we use the 0 index max recs value (for leaf blocks) throughout
this function? (e.g, mp->m_bmap_dmxr[0])

Brian

>  		brp = XFS_BMBT_REC_ADDR(mp, block, 1);
>  		zp = (char *)&brp[nrecs];
>  		break;
>  	case TYP_INOBT:
>  	case TYP_FINOBT:
> +		if (nrecs > mp->m_inobt_mxr[1])
> +			return;
> +
>  		irp = XFS_INOBT_REC_ADDR(mp, block, 1);
>  		zp = (char *)&irp[nrecs];
>  		break;
>  	case TYP_BNOBT:
>  	case TYP_CNTBT:
> +		if (nrecs > mp->m_alloc_mxr[1])
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
