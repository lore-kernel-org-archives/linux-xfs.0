Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E8D457F4E
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 14:32:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D56B2304032
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 12:32:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ao7cwy0djqYYfnzs for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 12:32:30 -0800 (PST)
Message-ID: <54EB8E5D.8080905@sandeen.net>
Date: Mon, 23 Feb 2015 14:32:29 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: avoid firstused overflow in attr3 leaf header with
	64k blocks
References: <1424722050-24149-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 2/23/15 2:07 PM, Brian Foster wrote:
> The attr3 leaf header has a 16-bit firstused field that tracks the first
> used entry offset. This field is initialized to the block size in
> xfs_attr3_leaf_create() and updated accordingly in
> xfs_attr3_leaf_add_work() when new attributes are added.
> 
> The initialization of firstused overflows if the block size exceeds
> 16-bits. E.g., xfstests test generic/117 causes assert failures on a
> -bsize=64k fs on ppc64 because ichdr.firstused evaluates to 0.

cool :)

> Update the firstused initialization to not exceed the maximum value of
> an unsigned short. This avoids the overflow to 0 and allows firstused to
> be updated appropriately on subsequent xattr addition. Also update the
> freemap size calculation to use the actual block size rather than the
> potentially minimized version stored in firstused.

I'm a little scared by this; does this truncated value risk going to disk?
(Yes, I think so.)  Is that ok?	 Does that ... mean we lose a byte of space
we'd otherwise have?  Maybe that's ok ...

FWIW, I think the same problem exists in xfs_attr3_leaf_compact():

        /* Initialise the incore headers */
        ichdr_src = *ichdr_dst; /* struct copy */
        ichdr_dst->firstused = args->geo->blksize;

and xfs_attr3_leaf_unbalance():

                tmphdr.firstused = state->args->geo->blksize;

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
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		struct xfs_da3_blkinfo *hdr3 = bp->b_addr;
> @@ -986,7 +987,7 @@ xfs_attr3_leaf_create(
>  		ichdr.magic = XFS_ATTR_LEAF_MAGIC;
>  		ichdr.freemap[0].base = sizeof(struct xfs_attr_leaf_hdr);
>  	}
> -	ichdr.freemap[0].size = ichdr.firstused - ichdr.freemap[0].base;
> +	ichdr.freemap[0].size = args->geo->blksize - ichdr.freemap[0].base;

But now freemap.size is out of sync with firstused; is that ok?

-Eric
 
>  	xfs_attr3_leaf_hdr_to_disk(leaf, &ichdr);
>  	xfs_trans_log_buf(args->trans, bp, 0, args->geo->blksize - 1);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
