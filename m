Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A93A37F57
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 12:40:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7A75E8F8035
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 10:40:05 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4rBcHHC9hXHJFO7w (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 10:40:04 -0800 (PST)
Date: Mon, 1 Dec 2014 13:40:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix premature enospc on inode allocation
Message-ID: <20141201184000.GD23055@bfoster.bfoster>
References: <1417393928-30497-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1417393928-30497-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Dec 01, 2014 at 11:32:08AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> =

> After growing a filesystem, XFS can fail to allocate inodes even
> though there is a large amount of space available in the filesystem
> for inodes. The issue is caused by a nearly full allocation group
> having enough free space in it to be considered for inode
> allocation, but not enough contiguous free space to actually
> allocation inodes.  This situation results in successful selection
> of the AG for allocation, then failure of the allocation resulting
> in ENOSPC being reported to the caller.
> =

> It is caused by two possible issues. Firstly, we only consider the
> lognest free extent and whether it would fit an inode chunk. If the
> extent is not correctly aligned, then we can't allocate an inode
> chunk in it regardless of the fact that it is large enough. This
> tends to be a permanent error until space in the AG is freed.
> =

> The second issue is that we don't actually lock the AGI or AGF when
> we are doing these checks, and so by the time we get to actually
> allocating the inode chunk the space we thought we had in the AG may
> have been allocated. This tends to be a spurious error as it
> requires a race to trigger. Hence this case is ignored in this patch
> as the reported problem is for permanent errors.
> =

> The first issue could be addressed by simply taking into account the
> alignment when checking the longest extent. This, however, would
> prevent allocation in AGs that have aligned, exact sized extents
> free. However, this case should be fairly rare compared to the
> number of allocations that occur near ENOSPC that would trigger this
> condition.
> =


I think the allocation of aligned and exact size extents is already
prevented in the inode chunk allocation code (where it sets the
alignment requirement of the alloc.) and the associated checks in
xfs_alloc_fix_freelist() (in particular, the couple bits of logic there
that consider args->alignment and args->minalignslop).

This is an interesting observation made from early tests of the sparse
inode chunk work. At the point where an AG no longer satisfies inode
chunk allocations, the sparse chunk mechanism actually leads to behavior
where full inode chunks are allocated a sparse chunk at a time in
regions of free space that were technically capable of supporting inode
chunks before resorting to sparse allocs, but that the pre-allocation
checks were not granular enough to allow to proceed. Note that this
behavior assumes a workload that sequentially allocates inodes so as to
not compete with allocations for other purposes, of course.

This patch seems to make the higher level AG selection more consistent
with the lower level allocation attempt, which seems reasonable to me
because it shouldn't introduce any allocation failures that aren't going
to end up as failures anyways.

> Hence, when selecting the inode AG, take into account the inode
> cluster alignment when checking the lognest free extent in the AG.
> If we can't find any AGs with a contiguous free space large
> enough to be aligned, drop the alignment addition and just try for
> an AG that has enough contiguous free space available for an inode
> chunk. This won't prevent issues from occurring, but should avoid
> situations where other AGs have lots of free space but the selected
> AG can't allocate due to alignment constraints.
> =

> Reported-by: Arkadiusz Mi=BFkiewicz <arekm@maven.pl>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

(minor comment nit in the last hunk)

>  fs/xfs/libxfs/xfs_ialloc.c | 34 ++++++++++++++++++++++++----------
>  1 file changed, 24 insertions(+), 10 deletions(-)
> =

> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index d1dc590..53757bd 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -45,12 +45,12 @@
>   */
>  static inline int
>  xfs_ialloc_cluster_alignment(
> -	xfs_alloc_arg_t	*args)
> +	struct xfs_mount	*mp)
>  {
> -	if (xfs_sb_version_hasalign(&args->mp->m_sb) &&
> -	    args->mp->m_sb.sb_inoalignmt >=3D
> -	     XFS_B_TO_FSBT(args->mp, args->mp->m_inode_cluster_size))
> -		return args->mp->m_sb.sb_inoalignmt;
> +	if (xfs_sb_version_hasalign(&mp->m_sb) &&
> +	    mp->m_sb.sb_inoalignmt >=3D
> +			XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size))
> +		return mp->m_sb.sb_inoalignmt;
>  	return 1;
>  }
>  =

> @@ -409,7 +409,7 @@ xfs_ialloc_ag_alloc(
>  		 * but not to use them in the actual exact allocation.
>  		 */
>  		args.alignment =3D 1;
> -		args.minalignslop =3D xfs_ialloc_cluster_alignment(&args) - 1;
> +		args.minalignslop =3D xfs_ialloc_cluster_alignment(args.mp) - 1;
>  =

>  		/* Allow space for the inode btree to split. */
>  		args.minleft =3D args.mp->m_in_maxlevels - 1;
> @@ -445,7 +445,7 @@ xfs_ialloc_ag_alloc(
>  			args.alignment =3D args.mp->m_dalign;
>  			isaligned =3D 1;
>  		} else
> -			args.alignment =3D xfs_ialloc_cluster_alignment(&args);
> +			args.alignment =3D xfs_ialloc_cluster_alignment(args.mp);
>  		/*
>  		 * Need to figure out where to allocate the inode blocks.
>  		 * Ideally they should be spaced out through the a.g.
> @@ -474,7 +474,7 @@ xfs_ialloc_ag_alloc(
>  		args.type =3D XFS_ALLOCTYPE_NEAR_BNO;
>  		args.agbno =3D be32_to_cpu(agi->agi_root);
>  		args.fsbno =3D XFS_AGB_TO_FSB(args.mp, agno, args.agbno);
> -		args.alignment =3D xfs_ialloc_cluster_alignment(&args);
> +		args.alignment =3D xfs_ialloc_cluster_alignment(args.mp);
>  		if ((error =3D xfs_alloc_vextent(&args)))
>  			return error;
>  	}
> @@ -629,10 +629,24 @@ xfs_ialloc_ag_select(
>  		}
>  =

>  		/*
> -		 * Is there enough free space for the file plus a block of
> -		 * inodes? (if we need to allocate some)?
> +		 * Check that there enough free space for the file plus a chunk
				   is

> +		 * of inodes if we need to allocate some. If this is the first
> +		 * pass across the AGs, take into account the potential space
> +		 * needed for alignment of inode chunks when checking the
> +		 * longest contiguous free space in the AG - this prevents us
> +		 * from getting ENOSPC because we have free space larger than
> +		 * m_ialloc_blks but alignment constraints prevent us from using
> +		 * it.
> +		 *
> +		 * If we can't find an AG with space for full alignment slack to
> +		 * be taken into account, we must be near ENOSPC in all AGs.
> +		 * Hence we don't include alignment for the second pass and so
> +		 * if we fail allocation due to alignment issues then it is most
> +		 * likely a real ENOSPC condition.
>  		 */
>  		ineed =3D mp->m_ialloc_blks;
> +		if (flags && ineed > 1)
> +			ineed +=3D xfs_ialloc_cluster_alignment(mp);
>  		longest =3D pag->pagf_longest;
>  		if (!longest)
>  			longest =3D pag->pagf_flcount > 0;
> -- =

> 2.0.0
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
