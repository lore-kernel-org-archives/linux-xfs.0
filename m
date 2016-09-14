Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E6D87CA0
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 13:20:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0EB5F8F8039
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 11:20:52 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Bm6ukn4kivIpK1aY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 14 Sep 2016 11:20:49 -0700 (PDT)
Date: Wed, 14 Sep 2016 11:20:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/6] xfs: automatically fix up AGFL size issues
Message-ID: <20160914182044.GG9314@birch.djwong.org>
References: <1472783257-15941-1-git-send-email-david@fromorbit.com>
	<1472783257-15941-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1472783257-15941-5-git-send-email-david@fromorbit.com>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Sep 02, 2016 at 12:27:35PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we can safely detect whether we have a screwed up AGFL
> size, we need to automatically fix it up. We do this by modifying
> the AGFL index and/or count values in the AGF. This will only ever
> lead to reducing the size of the AGFL, leaving a free block in the
> unused slot to remain there if a problem is corrected. WHile this is
> a leak, it should only occur once and it will be corrected the next
> time the filesystem is repaired.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 105 +++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 99 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 31a18fe..8deb736 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2417,10 +2417,7 @@ xfs_agf_verify(
>  
>  	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
>  	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
> -	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
> -	      be32_to_cpu(agf->agf_flfirst) < agfl_size &&
> -	      be32_to_cpu(agf->agf_fllast) < agfl_size &&
> -	      be32_to_cpu(agf->agf_flcount) <= agfl_size))
> +	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length)))
>  		return false;
>  
>  	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
> @@ -2440,10 +2437,18 @@ xfs_agf_verify(
>  	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
>  		return false;
>  
> -	if (!xfs_sb_version_hascrc(&mp->m_sb))
> +	/*
> +	 * AGFL parameters are strict only for non-CRC filesystems now.
> +	 * See the comment below in the v5 format section for details
> +	 */
> +	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> +		if (!(flfirst < agfl_size && fllast < agfl_size &&
> +		      flcount <= agfl_size))
> +			return false;
>  		return true;
> +	}
>  
> -	/* CRC format checks only from here */
> +	/* v5 format checks only from here */
>  
>  	if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
>  		return false;
> @@ -2575,6 +2580,92 @@ xfs_read_agf(
>  }
>  
>  /*
> + * Detect and fixup a screwup in the struct xfs_agfl definition that results in
> + * different free list sizes depending on the compiler padding added to the
> + * xfs_agfl. This will only matter on v5 filesystems that have the freelist
> + * wrapping around the end of the AGFL. The changes fixup changes will be logged
> + * in the first free list modification done to the AGF.
> + */
> +static void
> +xfs_agf_fixup_freelist_count(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag,
> +	struct xfs_agf		*agf)
> +{
> +	int32_t			agfl_size = xfs_agfl_size(mp);
> +	int32_t			active;
> +
> +	ASSERT(pag->pagf_fllast <= agfl_size);
> +	ASSERT(pag->pagf_flfirst <= agfl_size);
> +
> +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> +		return;
> +
> +	/* if not wrapped or completely within range, nothing to do */
> +	if (pag->pagf_fllast < agfl_size &&
> +	    pag->pagf_flfirst <= pag->pagf_fllast)
> +		return;
> +
> +	/* if last is invalid, pull it back and return */
> +	if (pag->pagf_fllast == agfl_size) {
> +		xfs_notice(mp, "AGF %d: last index fixup being performed",
> +			   pag->pag_agno);
> +		if (pag->pagf_flcount) {
> +			pag->pagf_flcount--;
> +			be32_add_cpu(&agf->agf_flcount, -1);
> +			be32_add_cpu(&agf->agf_fllast, -1);
> +			pag->pagf_fllast--;
> +		} else {
> +			/* empty free list, move the both pointers back one */
> +			ASSERT(pag->pagf_flfirst == pag->pagf_fllast);
> +			be32_add_cpu(&agf->agf_fllast, -1);
> +			be32_add_cpu(&agf->agf_flfirst, -1);
> +			pag->pagf_flfirst--;
> +			pag->pagf_fllast--;
> +		}
> +		return;
> +	}
> +
> +	/* if first is invalid, wrap it, reset count and return */
> +	if (pag->pagf_flfirst == agfl_size) {
> +		xfs_notice(mp, "AGF %d: first index fixup being performed",
> +			   pag->pag_agno);
> +		ASSERT(pag->pagf_flfirst != pag->pagf_fllast);
> +		ASSERT(pag->pagf_flcount);
> +		pag->pagf_flcount = pag->pagf_fllast + 1;
> +		agf->agf_flcount = cpu_to_be32(pag->pagf_flcount);
> +		agf->agf_flfirst = 0;
> +		pag->pagf_flfirst = 0;
> +		return;
> +	}
> +
> +	/*
> +	 * Pure wrap, first and last are valid.
> +	 *			  flfirst
> +	 *			     |
> +	 *	+oo------------------oo+
> +	 *	  |
> +	 *      fllast
> +	 *
> +	 * We need to determine if the count includes the last slot in the AGFL
> +	 * which we no longer use. If the flcount does not match the expected
> +	 * size based on the first/last indexes, we need to fix it up.
> +	 */
> +	active = pag->pagf_fllast - pag->pagf_flfirst + 1;
> +	if (active <= 0)
> +		active += agfl_size;
> +	if (active == pag->pagf_flcount)
> +		return;
> +
> +	/* should only be off by one */
> +	ASSERT(active + 1 == pag->pagf_flcount);
> +	xfs_notice(mp, "AGF %d: wrapped count fixup being performed",
> +		   pag->pag_agno);
> +	pag->pagf_flcount--;
> +	be32_add_cpu(&agf->agf_flcount, -1);

I've been wondering whether we need to take the extra step of clearing
that last slot in the AGFL.  Prior to 4.5, 32-bit kernels thought
XFS_AGFL_SIZE was 119 (4k blocks, 512b sectors) and 64-bit kernels
thought it was 118.  Since then, both 32b and 64b think it's 119; with
this patchset we're making it 118 everywhere.  My initial fear was that
the following could happen:

1. Mount with an agfl-119 kernel, beat on the fs until the agfl wraps
around the end.  The last agfl pointer is set to something.

2. Remount with a patched agfl-118 kernel that makes this correction.
The last agfl pointer remains set to whatever.  Exercise the fs until
the agfl active list wraps around again.

3. Remount with the old agfl-119 kernel.  It is now working with flcount
values that don't add up in its worldview, but will it notice?  In any
case, it will end up using that last agfl pointer.  Can we guarantee
that block is not owned by something else?

I /think/ the answer to #2 is that a block only ends up on the AGFL
after it's been removed from the freespace btrees, so the block pointed
to in that last slot is still free and in fact can be used.  Therefore,
the patch is correct and we don't need to write NULLAGBLOCK to the that
last AGFL slot that we're never going to use again, and I'm worrying
about nothing.

xfs_repair writes 0xFF to the entire sector, rebuilds the freesp btrees,
and moves the agfl to the start of the sector, so we're covered for that
case.

As for the question of whether or not an old kernel will notice flcount
not fitting its world view w.r.t. fllast - flfirst + 1, I don't know if
old kernels will notice; the current verifiers don't seem to check.
If we wanted to be really heavy handed I suppose we could set that last
slot to sb_agblocks to stop all the agfl-119 kernels dead in their
tracks, but I don't know that's necessary.

--D

> +}
> +
> +/*
>   * Read in the allocation group header (free/alloc section).
>   */
>  int					/* error */
> @@ -2620,6 +2711,8 @@ xfs_alloc_read_agf(
>  		pag->pagb_count = 0;
>  		pag->pagb_tree = RB_ROOT;
>  		pag->pagf_init = 1;
> +
> +		xfs_agf_fixup_freelist_count(mp, pag, agf);
>  	}
>  #ifdef DEBUG
>  	else if (!XFS_FORCED_SHUTDOWN(mp)) {
> -- 
> 2.8.0.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
