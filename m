Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4B6457F50
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 16:05:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1C4268F8066
	for <xfs@oss.sgi.com>; Wed, 25 Mar 2015 14:05:28 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	G4jHPHSPBpf6EiE0 for <xfs@oss.sgi.com>;
	Wed, 25 Mar 2015 14:05:25 -0700 (PDT)
Date: Thu, 26 Mar 2015 08:04:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: use larger in-core attr firstused field and
	detect overflow
Message-ID: <20150325210448.GA28621@dastard>
References: <1424811024-24839-1-git-send-email-bfoster@redhat.com>
	<1424811024-24839-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424811024-24839-3-git-send-email-bfoster@redhat.com>
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

On Tue, Feb 24, 2015 at 03:50:24PM -0500, Brian Foster wrote:
> The on-disk xfs_attr3_leaf_hdr structure firstused field is 16-bit and
> subject to overflow when fs block size is 64k. The field is typically
> initialized to block size when an attr leaf block is initialized. This
> problem is demonstrated by assert failures when running xfstests
> generic/117 on an fs with 64k blocks.
> 
> To support the existing attr leaf block algorithms for insertion,
> rebalance and entry movement, increase the size of the in-core firstused
> field to 32-bit and handle the potential overflow on conversion to/from
> the on-disk structure. If the overflow condition occurs, set a special
> value in the firstused field that is translated back on header read. The
> special value is only required in the case of an empty 64k attr block. A
> value of zero is used because firstused is initialized to the block size
> and grows backwards from there. Furthermore, the attribute block header
> occupies the first bytes of the block. Thus, a value of zero has no
> other legitimate meaning for this structure.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 36 +++++++++++++++++++++++++++++++++---
>  fs/xfs/libxfs/xfs_da_format.h |  8 +++++++-
>  2 files changed, 40 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 3337516..3277b40 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -106,6 +106,12 @@ xfs_attr3_leaf_hdr_from_disk(
>  		to->count = be16_to_cpu(hdr3->count);
>  		to->usedbytes = be16_to_cpu(hdr3->usedbytes);
>  		to->firstused = be16_to_cpu(hdr3->firstused);
> +		if (to->firstused == XFS_ATTR3_LEAF_NULLOFF) {
> +			/* only empty blocks when size overflows firstused! */
> +			ASSERT(!to->count && !to->usedbytes &&
> +			       geo->blksize > USHRT_MAX);
> +			to->firstused = geo->blksize;
> +		}
>  		to->holes = hdr3->holes;

So if it's already zero on disk, we set it to the block size....

>  		for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
> @@ -120,6 +126,12 @@ xfs_attr3_leaf_hdr_from_disk(
>  	to->count = be16_to_cpu(from->hdr.count);
>  	to->usedbytes = be16_to_cpu(from->hdr.usedbytes);
>  	to->firstused = be16_to_cpu(from->hdr.firstused);
> +	if (to->firstused == XFS_ATTR3_LEAF_NULLOFF) {
> +		/* only empty blocks when size overflows firstused! */
> +		ASSERT(!to->count && !to->usedbytes &&
> +		       geo->blksize > USHRT_MAX);
> +		to->firstused = geo->blksize;
> +	}
>  	to->holes = from->hdr.holes;

And duplicate the code here as well.

>  	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
> @@ -134,11 +146,29 @@ xfs_attr3_leaf_hdr_to_disk(
>  	struct xfs_attr_leafblock	*to,
>  	struct xfs_attr3_icleaf_hdr	*from)
>  {
> -	int	i;
> +	int				i;
> +	uint16_t			firstused;
>  
>  	ASSERT(from->magic == XFS_ATTR_LEAF_MAGIC ||
>  	       from->magic == XFS_ATTR3_LEAF_MAGIC);
>  
> +	/*
> +	 * Handle overflow of the on-disk firstused field. firstused is
> +	 * typically initialized to block size, but we only have 2-bytes in the
> +	 * on-disk structure. This means a 64k block size overflows the field.
> +	 *
> +	 * firstused should only match block size for an empty attr block so set
> +	 * a special value that the from_disk() variant can convert back to
> +	 * blocksize in the in-core structure.
> +	 */
> +	if (from->firstused > USHRT_MAX) {
> +		ASSERT(from->firstused == geo->blksize);
> +		firstused = XFS_ATTR3_LEAF_NULLOFF;
> +	} else {
> +		ASSERT(from->firstused != 0);
> +		firstused = from->firstused;
> +	}

Ok, that makes this a non-trivial sized function now :P

I think helpers might be appropriate...

> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 0a49b02..d2d0498 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -725,7 +725,7 @@ struct xfs_attr3_icleaf_hdr {
>  	__uint16_t	magic;
>  	__uint16_t	count;
>  	__uint16_t	usedbytes;
> -	__uint16_t	firstused;
> +	__uint32_t	firstused;

Needs a comment explaining why it's different to the on-disk
structure.

>  	__u8		holes;
>  	struct {
>  		__uint16_t	base;
> @@ -734,6 +734,12 @@ struct xfs_attr3_icleaf_hdr {
>  };
>  
>  /*
> + * Special value to represent fs block size in the leaf header firstused field.
> + * Only used when block size overflows the 2-bytes available on disk.
> + */
> +#define XFS_ATTR3_LEAF_NULLOFF	0
> +

I think declaring a pair of helper functions (e.g.
xfs_attr3_leaf_firstused_to/from_disk) here would be a good idea.
That way all the coversions, magic numbers and comments documenting
the behaviour are in the one place in the on-disk format
specification....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
