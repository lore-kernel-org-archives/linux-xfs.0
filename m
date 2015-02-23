Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4EF747F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 15:53:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DEF96AC001
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 13:53:04 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	w101YOKGaHJ7WDfE for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 13:53:02 -0800 (PST)
Date: Tue, 24 Feb 2015 08:53:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid firstused overflow in attr3 leaf header with
	64k blocks
Message-ID: <20150223215300.GU4251@dastard>
References: <1424722050-24149-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424722050-24149-1-git-send-email-bfoster@redhat.com>
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

On Mon, Feb 23, 2015 at 03:07:30PM -0500, Brian Foster wrote:
> The attr3 leaf header has a 16-bit firstused field that tracks the first
> used entry offset. This field is initialized to the block size in
> xfs_attr3_leaf_create() and updated accordingly in
> xfs_attr3_leaf_add_work() when new attributes are added.
> 
> The initialization of firstused overflows if the block size exceeds
> 16-bits. E.g., xfstests test generic/117 causes assert failures on a
> -bsize=64k fs on ppc64 because ichdr.firstused evaluates to 0.
> 
> Update the firstused initialization to not exceed the maximum value of
> an unsigned short. This avoids the overflow to 0 and allows firstused to
> be updated appropriately on subsequent xattr addition. Also update the
> freemap size calculation to use the actual block size rather than the
> potentially minimized version stored in firstused.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 15105db..dc7bda3 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -970,7 +970,8 @@ xfs_attr3_leaf_create(
>  	memset(leaf, 0, args->geo->blksize);
>  
>  	memset(&ichdr, 0, sizeof(ichdr));
> -	ichdr.firstused = args->geo->blksize;
> +	/* firstused is 16-bit */
> +	ichdr.firstused = min_t(int, USHRT_MAX, args->geo->blksize);

Needs a better comment.

>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		struct xfs_da3_blkinfo *hdr3 = bp->b_addr;
> @@ -986,7 +987,7 @@ xfs_attr3_leaf_create(
>  		ichdr.magic = XFS_ATTR_LEAF_MAGIC;
>  		ichdr.freemap[0].base = sizeof(struct xfs_attr_leaf_hdr);
>  	}
> -	ichdr.freemap[0].size = ichdr.firstused - ichdr.freemap[0].base;
> +	ichdr.freemap[0].size = args->geo->blksize - ichdr.freemap[0].base;

And that also needs an explanation, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
