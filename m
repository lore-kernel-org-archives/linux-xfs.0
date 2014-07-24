Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E3C8D7F5D
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 18:21:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D17F8304067
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 16:21:39 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	AbYuhFqtEi74kBtr for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 16:21:37 -0700 (PDT)
Date: Fri, 25 Jul 2014 09:21:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/18] xfs: helper to convert inobt record holemask to
	inode alloc. bitmap
Message-ID: <20140724232134.GU20518@dastard>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-13-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406211788-63206-13-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 24, 2014 at 10:23:02AM -0400, Brian Foster wrote:
> The inobt record holemask field is a condensed data type designed to fit
> into the existing on-disk record and is zero based (allocated regions
> are set to 0, sparse regions are set to 1) to provide backwards
> compatibility. Thus the type is unnecessarily complex for use in higher
> level inode manipulations such as individual inode allocations, etc.
> 
> Rather than foist the complexity of dealing with this field to every bit
> of logic that requires inode chunk allocation information, create the
> xfs_inobt_ialloc_bitmap() helper to convert the inobt record holemask to
> an inode allocation bitmap. The inode allocation bitmap is inode
> granularity similar to the inobt record free mask and indicates which
> inodes of the chunk are physically allocated on disk irrespective of
> whether the inode is considered allocated or free by the filesystem.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |  1 +
>  fs/xfs/libxfs/xfs_ialloc.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 68 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 0baad50..cbc3296 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -206,6 +206,7 @@ typedef __be32 xfs_alloc_ptr_t;
>  #define	XFS_FIBT_CRC_MAGIC	0x46494233	/* 'FIB3' */
>  
>  typedef	__uint64_t	xfs_inofree_t;
> +typedef	__uint64_t	xfs_inoalloc_t;
>  #define	XFS_INODES_PER_CHUNK		(NBBY * sizeof(xfs_inofree_t))
>  #define	XFS_INODES_PER_CHUNK_LOG	(XFS_NBBYLOG + 3)
>  #define	XFS_INOBT_ALL_FREE		((xfs_inofree_t)-1)
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 4e98a21..166602e 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -863,6 +863,73 @@ xfs_ialloc_get_rec(
>  }
>  
>  /*
> + * Convert the inode record holemask to an inode allocation bitmap. The inode
> + * allocation bitmap is inode granularity and specifies whether an inode is
> + * physically allocated on disk (not whether the inode is considered allocated
> + * or free by the fs).
> + */
> +STATIC xfs_inoalloc_t
> +xfs_inobt_ialloc_bitmap(
> +	struct xfs_inobt_rec_incore	*rec)
> +{
> +	xfs_inofree_t	bitmap = 0;
> +	xfs_inofree_t	sparsebits;
> +	int		nextbit;
> +	int		shift;
> +	__uint16_t	allocmask;
> +	uint		allocbitmap;

allocbitmap should be a 64 bit value?

> +
> +	/*
> +	 * Each holemask bit represents XFS_INODES_PER_SPCHUNK inodes. Determine
> +	 * the inode bits per holemask bit.
> +	 */
> +	sparsebits = xfs_mask64lo(XFS_INODES_PER_SPCHUNK);

Can we just open code that?

	sparsebits = (1ULL << XFS_INODES_PER_SPCHUNK) - 1;


> +	/*
> +	 * The bit flip and type conversion are intentionally done separately
> +	 * here to zero-extend the bitmask.
> +	 */
> +	allocmask = ~rec->ir_holemask;
> +	allocbitmap = allocmask;

urk. That's a landmine.

> +
> +	/*
> +	 * Each bit of allocbitmap represents an allocated region of the inode
> +	 * chunk. Thus, each bit represents XFS_INODES_PER_SPCHUNK physical
> +	 * inodes. Walk through allocbitmap and set the associated individual
> +	 * inode bits in the inode bitmap for each allocated chunk.
> +	 *
> +	 * For example, consider a 512b inode fs with a cluster size of 16k.
> +	 * Each holemask bit represents 4 inodes and each cluster contains 32
> +	 * inodes. Since sparse chunks are allocated at cluster granularity, a
> +	 * valid 16-bit holemask (and negated allocbitmap) with this geometry
> +	 * might look as follows:
> +	 *
> +	 * 	holemask		~	allocbitmap
> +	 * 	0000 0000 1111 1111	=>	1111 1111 0000 0000
> +	 *
> +	 * At 4 inodes per bit, this indicates that the first 32 inodes of the
> +	 * chunk are not physically allocated inodes. This is a hole from the
> +	 * perspective of the inode record. Converting the allocbitmap to a
> +	 * 64-bit inode allocation bitmap yields:
> +	 *
> +	 * 	0xFFFFFFFF00000000
> +	 *
> +	 * ... where any of the 32 inodes defined by the higher order 32 bits of
> +	 * the map could be in use or free. Logically AND this bitmap with the
> +	 * record ir_free map to identify which of the physically allocated
> +	 * inodes are in use.
> +	 */
> +	nextbit = xfs_next_bit(&allocbitmap, 1, 0);
> +	while (nextbit != -1) {
> +		shift = nextbit * XFS_INODES_PER_SPCHUNK;
> +		bitmap |= (sparsebits << shift);
> +		nextbit = xfs_next_bit(&allocbitmap, 1, nextbit + 1);
> +	}

We need to get rid of xfs_next_bit() and friends, not add more
users. The generic bitmap functionality is better suited to this,
I think. A cleaned up version of something like this, perhaps:


	DECLARE_BITMAP(allocmask, 16);
	DECLARE_BITMAP(bitmap, 64);

	bitmap_complement(&allocmask, &rec->ir_holemask, 16);
	bitmap_full(&bitmap, 64);
	for (i = 0; i < 16; i++) {
		if (!test_bit(&allocmask, i)) {
			bitmap_release_region(&bitmap, i * 4,
					      ilog2(XFS_INODES_PER_SPCHUNK));
		}
	}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
