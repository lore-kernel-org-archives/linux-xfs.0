Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p662JeT9061151 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 21:19:40 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E7074E9BA
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 19:19:38 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EsPT8HkouMcm4g4o for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 19:19:38 -0700 (PDT)
Date: Wed, 6 Jul 2011 12:19:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/27] xfs: avoid usage of struct xfs_dir2_block
Message-ID: <20110706021935.GK1026@dastard>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094605.621819832@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701094605.621819832@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Jul 01, 2011 at 05:43:37AM -0400, Christoph Hellwig wrote:
> In most places we can simply pass around and use the struct xfs_dir2_data_hdr,
> which is the first and most important member of struct xfs_dir2_block instead
> of the full structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
....
> @@ -105,13 +105,13 @@ xfs_dir2_block_addname(
>  		return error;
>  	}
>  	ASSERT(bp != NULL);
> -	block = bp->data;
> +	hdr = bp->data;
>  	/*
>  	 * Check the magic number, corrupted if wrong.
>  	 */
> -	if (unlikely(be32_to_cpu(block->hdr.magic) != XFS_DIR2_BLOCK_MAGIC)) {
> +	if (unlikely(hdr->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))) {

Took me a moment to realise what this does - turns the byte swap
into a compile-time operation rather than a runtime operation.
Nice.

Perhaps we should do that same optimisation in other magic number
checks around the place?

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
