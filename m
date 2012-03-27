Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RKorTY168466 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 15:50:54 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gFiP1sbgseQxXjvy for
	<xfs@oss.sgi.com>; Tue, 27 Mar 2012 13:50:52 -0700 (PDT)
Message-ID: <4F722828.4000102@redhat.com>
Date: Tue, 27 Mar 2012 15:50:48 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: check on-disk (not incore) btree root size in dfrag.c
References: <4F7225BA.40200@redhat.com>
In-Reply-To: <4F7225BA.40200@redhat.com>
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Gabriel VLASIU <gabriel@vlasiu.net>

On 3/27/12 3:40 PM, Eric Sandeen wrote:
> xfs_swap_extents_check_format() contains checks to make sure that
> original and the temporary files during defrag are compatible;
> Gabriel VLASIU ran into a case where xfs_fsr returned EINVAL
> because the tests found the btree root to be of size 120,
> while the fork offset was only 104; IOW, they overlapped.
> 
> However, this is just due to an error in the
> xfs_swap_extents_check_format() tests, because it is checking
> the in-memory btree root size against the on-disk fork offset.
> We should be checking the on-disk sizes in both cases.
> 
> This patch adds a new macro to calculate this size, and uses
> it in the tests.
> 
> With this change, the filesystem image provided by Gabriel
> allows for proper file degragmentation.

Hm, as usually happens right after finalizing this I stumbled
on something else.  xfs_iroot_realloc() does essentially the same
test, but uses a funky macro to resolve the incore/ondisk size
difference:

        ASSERT(ifp->if_broot_bytes <=
                XFS_IFORK_SIZE(ip, whichfork) + XFS_BROOT_SIZE_ADJ);

so dfrag.c could be fixed up the same way, I suppose, using
XFS_BROOT_SIZE_ADJ if desired (though I have no real love for that
undocumented macro!)

-Eric

> Reported-by: Gabriel VLASIU <gabriel@vlasiu.net>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_bmap_btree.h b/fs/xfs/xfs_bmap_btree.h
> index 0e66c4e..d9eeb64 100644
> --- a/fs/xfs/xfs_bmap_btree.h
> +++ b/fs/xfs/xfs_bmap_btree.h
> @@ -189,12 +189,14 @@ typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
>  #define XFS_BMAP_BROOT_SPACE_CALC(nrecs) \
>  	(int)(XFS_BTREE_LBLOCK_LEN + \
>  	       ((nrecs) * (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t))))
> -
>  #define XFS_BMAP_BROOT_SPACE(bb) \
>  	(XFS_BMAP_BROOT_SPACE_CALC(be16_to_cpu((bb)->bb_numrecs)))
> +
>  #define XFS_BMDR_SPACE_CALC(nrecs) \
>  	(int)(sizeof(xfs_bmdr_block_t) + \
>  	       ((nrecs) * (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t))))
> +#define XFS_BMAP_BMDR_SPACE(bb) \
> +	(XFS_BMDR_SPACE_CALC(be16_to_cpu((bb)->bb_numrecs)))
>  
>  /*
>   * Maximum number of bmap btree levels.
> diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
> index dd974a5..2707d86 100644
> --- a/fs/xfs/xfs_dfrag.c
> +++ b/fs/xfs/xfs_dfrag.c
> @@ -26,6 +26,9 @@
>  #include "xfs_ag.h"
>  #include "xfs_mount.h"
>  #include "xfs_bmap_btree.h"
> +#include "xfs_alloc_btree.h"
> +#include "xfs_ialloc_btree.h"
> +#include "xfs_btree.h"
>  #include "xfs_dinode.h"
>  #include "xfs_inode.h"
>  #include "xfs_inode_item.h"
> @@ -184,7 +187,7 @@ xfs_swap_extents_check_format(
>  	 */
>  	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
>  		if (XFS_IFORK_BOFF(ip) &&
> -		    tip->i_df.if_broot_bytes > XFS_IFORK_BOFF(ip))
> +		    XFS_BMAP_BMDR_SPACE(tip->i_df.if_broot) > XFS_IFORK_BOFF(ip))
>  			return EINVAL;
>  		if (XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) <=
>  		    XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
> @@ -194,9 +197,8 @@ xfs_swap_extents_check_format(
>  	/* Reciprocal target->temp btree format checks */
>  	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
>  		if (XFS_IFORK_BOFF(tip) &&
> -		    ip->i_df.if_broot_bytes > XFS_IFORK_BOFF(tip))
> +		    XFS_BMAP_BMDR_SPACE(ip->i_df.if_broot) > XFS_IFORK_BOFF(tip))
>  			return EINVAL;
> -
>  		if (XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) <=
>  		    XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
>  			return EINVAL;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
