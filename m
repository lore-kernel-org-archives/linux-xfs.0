Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38702 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727752AbeLQS3w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Dec 2018 13:29:52 -0500
Date: Mon, 17 Dec 2018 10:29:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/10] xfs: pass a verifier context down verifier
 callchains
Message-ID: <20181217182939.GM24487@magnolia>
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
 <f3783a1e-55d1-d9da-63c7-f9d496c7db55@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3783a1e-55d1-d9da-63c7-f9d496c7db55@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Dec 05, 2018 at 03:03:56PM -0600, Eric Sandeen wrote:
> In order to get more context about a verifier failure, create a new
> xfs verifier context (xfs_vc) type and pass it all the way down verifier
> callchains to where we might return a failaddr_t.  This will eventually
> let us return more information, for example line number or buffer offset,
> etc.
> 
> At this point it contains only a failaddr member which is not yet used.
> 
> struct xfs_vc {
>        xfs_failaddr_t  fa;
> };
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c          | 14 +++++++---
>  fs/xfs/libxfs/xfs_alloc_btree.c    | 15 ++++++-----
>  fs/xfs/libxfs/xfs_attr_leaf.c      |  8 ++++--
>  fs/xfs/libxfs/xfs_attr_leaf.h      |  2 +-
>  fs/xfs/libxfs/xfs_attr_remote.c    | 13 ++++++---
>  fs/xfs/libxfs/xfs_bmap.c           |  4 ++-
>  fs/xfs/libxfs/xfs_bmap.h           |  2 +-
>  fs/xfs/libxfs/xfs_bmap_btree.c     | 11 +++++---
>  fs/xfs/libxfs/xfs_btree.c          | 13 +++++++--
>  fs/xfs/libxfs/xfs_btree.h          | 14 +++++-----
>  fs/xfs/libxfs/xfs_da_btree.c       | 20 ++++++++------
>  fs/xfs/libxfs/xfs_dir2_block.c     |  9 ++++---
>  fs/xfs/libxfs/xfs_dir2_data.c      | 31 +++++++++++++++-------
>  fs/xfs/libxfs/xfs_dir2_leaf.c      | 42 +++++++++++++++++++-----------
>  fs/xfs/libxfs/xfs_dir2_node.c      | 17 ++++++++----
>  fs/xfs/libxfs/xfs_dir2_priv.h      |  6 ++---
>  fs/xfs/libxfs/xfs_dir2_sf.c        |  1 +
>  fs/xfs/libxfs/xfs_dquot_buf.c      | 19 +++++++++-----
>  fs/xfs/libxfs/xfs_ialloc.c         |  7 +++--
>  fs/xfs/libxfs/xfs_ialloc_btree.c   | 13 +++++----
>  fs/xfs/libxfs/xfs_inode_buf.c      | 28 +++++++++++++-------
>  fs/xfs/libxfs/xfs_inode_buf.h      |  6 ++---
>  fs/xfs/libxfs/xfs_inode_fork.c     | 13 +++++----
>  fs/xfs/libxfs/xfs_inode_fork.h     |  6 ++---
>  fs/xfs/libxfs/xfs_quota_defs.h     |  4 +--
>  fs/xfs/libxfs/xfs_refcount_btree.c | 13 +++++----
>  fs/xfs/libxfs/xfs_rmap_btree.c     | 13 +++++----
>  fs/xfs/libxfs/xfs_rtbitmap.c       |  2 ++
>  fs/xfs/libxfs/xfs_sb.c             |  5 +++-
>  fs/xfs/libxfs/xfs_shared.h         |  2 +-
>  fs/xfs/libxfs/xfs_symlink_remote.c |  8 ++++--
>  fs/xfs/libxfs/xfs_types.h          |  4 +++
>  fs/xfs/scrub/btree.c               |  5 ++--
>  fs/xfs/scrub/common.c              |  3 ++-
>  fs/xfs/scrub/dabtree.c             | 15 ++++++-----
>  fs/xfs/scrub/inode.c               |  6 +++--
>  fs/xfs/scrub/repair.c              |  4 ++-
>  fs/xfs/xfs_buf.c                   | 12 ++++++---
>  fs/xfs/xfs_buf.h                   |  6 ++---
>  fs/xfs/xfs_dquot.c                 |  3 ++-
>  fs/xfs/xfs_inode.c                 |  5 ++--
>  fs/xfs/xfs_log_recover.c           |  6 +++--
>  fs/xfs/xfs_qm.c                    |  3 ++-
>  43 files changed, 284 insertions(+), 149 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index e1c0c0d2f1b0..59b8ab08dabd 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -553,6 +553,7 @@ xfs_alloc_fixup_trees(
>  
>  static xfs_failaddr_t
>  xfs_agfl_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> @@ -594,6 +595,7 @@ xfs_agfl_verify(
>  
>  static void
>  xfs_agfl_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> @@ -611,7 +613,7 @@ xfs_agfl_read_verify(
>  	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_agfl_verify(bp);
> +		fa = xfs_agfl_verify(vc, bp);
>  		if (fa)
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -619,6 +621,7 @@ xfs_agfl_read_verify(
>  
>  static void
>  xfs_agfl_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -629,7 +632,7 @@ xfs_agfl_write_verify(
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		return;
>  
> -	fa = xfs_agfl_verify(bp);
> +	fa = xfs_agfl_verify(vc, bp);
>  	if (fa) {
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  		return;
> @@ -2575,6 +2578,7 @@ xfs_alloc_put_freelist(
>  
>  static xfs_failaddr_t
>  xfs_agf_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -2631,6 +2635,7 @@ xfs_agf_verify(
>  
>  static void
>  xfs_agf_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> @@ -2640,7 +2645,7 @@ xfs_agf_read_verify(
>  	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_agf_verify(bp);
> +		fa = xfs_agf_verify(vc, bp);
>  		if (XFS_TEST_ERROR(fa, mp, XFS_ERRTAG_ALLOC_READ_AGF))
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -2648,13 +2653,14 @@ xfs_agf_read_verify(
>  
>  static void
>  xfs_agf_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_agf_verify(bp);
> +	fa = xfs_agf_verify(vc, bp);
>  	if (fa) {
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  		return;
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 4e59cc8a2802..2e9353a76a58 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -290,6 +290,7 @@ xfs_cntbt_diff_two_keys(
>  
>  static xfs_failaddr_t
>  xfs_allocbt_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -313,7 +314,7 @@ xfs_allocbt_verify(
>  	level = be16_to_cpu(block->bb_level);
>  	switch (block->bb_magic) {
>  	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
> -		fa = xfs_btree_sblock_v5hdr_verify(bp);
> +		fa = xfs_btree_sblock_v5hdr_verify(vc, bp);
>  		if (fa)
>  			return fa;
>  		/* fall through */
> @@ -325,7 +326,7 @@ xfs_allocbt_verify(
>  			return __this_address;
>  		break;
>  	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
> -		fa = xfs_btree_sblock_v5hdr_verify(bp);
> +		fa = xfs_btree_sblock_v5hdr_verify(vc, bp);
>  		if (fa)
>  			return fa;
>  		/* fall through */
> @@ -340,19 +341,20 @@ xfs_allocbt_verify(
>  		return __this_address;
>  	}
>  
> -	return xfs_btree_sblock_verify(bp, mp->m_alloc_mxr[level != 0]);
> +	return xfs_btree_sblock_verify(vc, bp, mp->m_alloc_mxr[level != 0]);
>  }
>  
>  static void
>  xfs_allocbt_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	xfs_failaddr_t	fa;
>  
> -	if (!xfs_btree_sblock_verify_crc(bp))
> +	if (!xfs_btree_sblock_verify_crc(vc, bp))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_allocbt_verify(bp);
> +		fa = xfs_allocbt_verify(vc, bp);
>  		if (fa)
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -363,11 +365,12 @@ xfs_allocbt_read_verify(
>  
>  static void
>  xfs_allocbt_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	xfs_failaddr_t	fa;
>  
> -	fa = xfs_allocbt_verify(bp);
> +	fa = xfs_allocbt_verify(vc, bp);
>  	if (fa) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 2652d00842d6..5b146c909389 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -237,6 +237,7 @@ xfs_attr3_leaf_hdr_to_disk(
>  
>  static xfs_failaddr_t
>  xfs_attr3_leaf_verify(
> +	struct xfs_vc			*vc,
>  	struct xfs_buf			*bp)
>  {
>  	struct xfs_attr3_icleaf_hdr	ichdr;
> @@ -322,6 +323,7 @@ xfs_attr3_leaf_verify(
>  
>  static void
>  xfs_attr3_leaf_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -329,7 +331,7 @@ xfs_attr3_leaf_write_verify(
>  	struct xfs_attr3_leaf_hdr *hdr3 = bp->b_addr;
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_attr3_leaf_verify(bp);
> +	fa = xfs_attr3_leaf_verify(vc, bp);
>  	if (fa) {
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  		return;
> @@ -352,6 +354,7 @@ xfs_attr3_leaf_write_verify(
>   */
>  static void
>  xfs_attr3_leaf_read_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -361,7 +364,7 @@ xfs_attr3_leaf_read_verify(
>  	     !xfs_buf_verify_cksum(bp, XFS_ATTR3_LEAF_CRC_OFF))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_attr3_leaf_verify(bp);
> +		fa = xfs_attr3_leaf_verify(vc, bp);
>  		if (fa)
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -905,6 +908,7 @@ xfs_attr_shortform_allfit(
>  /* Verify the consistency of an inline attribute fork. */
>  xfs_failaddr_t
>  xfs_attr_shortform_verify(
> +	struct xfs_vc			*vc,
>  	struct xfs_inode		*ip)
>  {
>  	struct xfs_attr_shortform	*sfp;
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 7b74e18becff..afe09eec66aa 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -41,7 +41,7 @@ int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>  int	xfs_attr_shortform_remove(struct xfs_da_args *args);
>  int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>  int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
> -xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
> +xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_vc *vc, struct xfs_inode *ip);
>  void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index f86680e08613..e8d629de2cf5 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -78,6 +78,7 @@ xfs_attr3_rmt_hdr_ok(
>  
>  static xfs_failaddr_t
>  xfs_attr3_rmt_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_mount	*mp,
>  	void			*ptr,
>  	int			fsbsize,
> @@ -106,6 +107,7 @@ xfs_attr3_rmt_verify(
>  
>  static int
>  __xfs_attr3_rmt_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp,
>  	bool		check_crc,
>  	xfs_failaddr_t	*failaddr)
> @@ -131,7 +133,7 @@ __xfs_attr3_rmt_read_verify(
>  			*failaddr = __this_address;
>  			return -EFSBADCRC;
>  		}
> -		*failaddr = xfs_attr3_rmt_verify(mp, ptr, blksize, bno);
> +		*failaddr = xfs_attr3_rmt_verify(vc, mp, ptr, blksize, bno);
>  		if (*failaddr)
>  			return -EFSCORRUPTED;
>  		len -= blksize;
> @@ -149,29 +151,32 @@ __xfs_attr3_rmt_read_verify(
>  
>  static void
>  xfs_attr3_rmt_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	xfs_failaddr_t	fa;
>  	int		error;
>  
> -	error = __xfs_attr3_rmt_read_verify(bp, true, &fa);
> +	error = __xfs_attr3_rmt_read_verify(vc, bp, true, &fa);
>  	if (error)
>  		xfs_verifier_error(bp, error, fa);
>  }
>  
>  static xfs_failaddr_t
>  xfs_attr3_rmt_verify_struct(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	xfs_failaddr_t	fa;
>  	int		error;
>  
> -	error = __xfs_attr3_rmt_read_verify(bp, false, &fa);
> +	error = __xfs_attr3_rmt_read_verify(vc, bp, false, &fa);
>  	return error ? fa : NULL;
>  }
>  
>  static void
>  xfs_attr3_rmt_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> @@ -193,7 +198,7 @@ xfs_attr3_rmt_write_verify(
>  	while (len > 0) {
>  		struct xfs_attr3_rmt_hdr *rmt = (struct xfs_attr3_rmt_hdr *)ptr;
>  
> -		fa = xfs_attr3_rmt_verify(mp, ptr, blksize, bno);
> +		fa = xfs_attr3_rmt_verify(vc, mp, ptr, blksize, bno);
>  		if (fa) {
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  			return;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 19e921d1586f..fe0e0a1df5b1 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1249,10 +1249,11 @@ xfs_iread_extents(
>  		 */
>  		frp = XFS_BMBT_REC_ADDR(mp, block, 1);
>  		for (j = 0; j < num_recs; j++, frp++, i++) {
> +			struct xfs_vc	vc = { 0 };

The sole field in xfs_vc is a pointer; is this going to trigger gcc
warnings about typecasting zero to a pointer?

(Which is silly and annoying, but I'm tired of getting patches to
swizzle back and forth between NULL and 0...)

>  			xfs_failaddr_t	fa;
>  
>  			xfs_bmbt_disk_get_all(frp, &new);
> -			fa = xfs_bmap_validate_extent(ip, whichfork, &new);
> +			fa = xfs_bmap_validate_extent(&vc, ip, whichfork, &new);
>  			if (fa) {
>  				error = -EFSCORRUPTED;
>  				xfs_inode_verifier_error(ip, error,
> @@ -6101,6 +6102,7 @@ xfs_bmap_finish_one(
>  /* Check that an inode's extent does not have invalid flags or bad ranges. */
>  xfs_failaddr_t
>  xfs_bmap_validate_extent(
> +	struct xfs_vc		*vc,
>  	struct xfs_inode	*ip,
>  	int			whichfork,
>  	struct xfs_bmbt_irec	*irec)
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 488dc8860fd7..a586568cdfb9 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -273,7 +273,7 @@ static inline int xfs_bmap_fork_to_state(int whichfork)
>  	}
>  }
>  
> -xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
> +xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_vc *vc, struct xfs_inode *ip, int whichfork,
>  		struct xfs_bmbt_irec *irec);
>  
>  int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index cdb74d2e2a43..4c8e97709704 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -409,6 +409,7 @@ xfs_bmbt_diff_two_keys(
>  
>  static xfs_failaddr_t
>  xfs_bmbt_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -422,7 +423,7 @@ xfs_bmbt_verify(
>  		 * XXX: need a better way of verifying the owner here. Right now
>  		 * just make sure there has been one set.
>  		 */
> -		fa = xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
> +		fa = xfs_btree_lblock_v5hdr_verify(vc, bp, XFS_RMAP_OWN_UNKNOWN);
>  		if (fa)
>  			return fa;
>  		/* fall through */
> @@ -443,11 +444,12 @@ xfs_bmbt_verify(
>  	if (level > max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]))
>  		return __this_address;
>  
> -	return xfs_btree_lblock_verify(bp, mp->m_bmap_dmxr[level != 0]);
> +	return xfs_btree_lblock_verify(vc, bp, mp->m_bmap_dmxr[level != 0]);
>  }
>  
>  static void
>  xfs_bmbt_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	xfs_failaddr_t	fa;
> @@ -455,7 +457,7 @@ xfs_bmbt_read_verify(
>  	if (!xfs_btree_lblock_verify_crc(bp))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_bmbt_verify(bp);
> +		fa = xfs_bmbt_verify(vc, bp);
>  		if (fa)
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -466,11 +468,12 @@ xfs_bmbt_read_verify(
>  
>  static void
>  xfs_bmbt_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	xfs_failaddr_t	fa;
>  
> -	fa = xfs_bmbt_verify(bp);
> +	fa = xfs_bmbt_verify(vc, bp);
>  	if (fa) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index bbdae2b4559f..755ac16e90c5 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -58,6 +58,7 @@ xfs_btree_magic(
>   */
>  xfs_failaddr_t
>  __xfs_btree_check_lblock(
> +	struct xfs_vc		*vc,
>  	struct xfs_btree_cur	*cur,
>  	struct xfs_btree_block	*block,
>  	int			level,
> @@ -105,9 +106,10 @@ xfs_btree_check_lblock(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = cur->bc_mp;
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  
> -	fa = __xfs_btree_check_lblock(cur, block, level, bp);
> +	fa = __xfs_btree_check_lblock(&vc, cur, block, level, bp);
>  	if (unlikely(XFS_TEST_ERROR(fa != NULL, mp,
>  			XFS_ERRTAG_BTREE_CHECK_LBLOCK))) {
>  		if (bp)
> @@ -124,6 +126,7 @@ xfs_btree_check_lblock(
>   */
>  xfs_failaddr_t
>  __xfs_btree_check_sblock(
> +	struct xfs_vc		*vc,
>  	struct xfs_btree_cur	*cur,
>  	struct xfs_btree_block	*block,
>  	int			level,
> @@ -169,9 +172,10 @@ xfs_btree_check_sblock(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = cur->bc_mp;
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  
> -	fa = __xfs_btree_check_sblock(cur, block, level, bp);
> +	fa = __xfs_btree_check_sblock(&vc, cur, block, level, bp);
>  	if (unlikely(XFS_TEST_ERROR(fa != NULL, mp,
>  			XFS_ERRTAG_BTREE_CHECK_SBLOCK))) {
>  		if (bp)
> @@ -323,6 +327,7 @@ xfs_btree_sblock_calc_crc(
>  
>  bool
>  xfs_btree_sblock_verify_crc(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
> @@ -4430,6 +4435,7 @@ xfs_btree_change_owner(
>  /* Verify the v5 fields of a long-format btree block. */
>  xfs_failaddr_t
>  xfs_btree_lblock_v5hdr_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp,
>  	uint64_t		owner)
>  {
> @@ -4451,6 +4457,7 @@ xfs_btree_lblock_v5hdr_verify(
>  /* Verify a long-format btree block. */
>  xfs_failaddr_t
>  xfs_btree_lblock_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp,
>  	unsigned int		max_recs)
>  {
> @@ -4482,6 +4489,7 @@ xfs_btree_lblock_verify(
>   */
>  xfs_failaddr_t
>  xfs_btree_sblock_v5hdr_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -4507,6 +4515,7 @@ xfs_btree_sblock_v5hdr_verify(
>   */
>  xfs_failaddr_t
>  xfs_btree_sblock_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp,
>  	unsigned int		max_recs)
>  {
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index e3b3e9dce5da..86cc17f1bf3f 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -243,9 +243,9 @@ typedef struct xfs_btree_cur
>   * Internal long and short btree block checks.  They return NULL if the
>   * block is ok or the address of the failed check otherwise.
>   */
> -xfs_failaddr_t __xfs_btree_check_lblock(struct xfs_btree_cur *cur,
> +xfs_failaddr_t __xfs_btree_check_lblock(struct xfs_vc *vc, struct xfs_btree_cur *cur,
>  		struct xfs_btree_block *block, int level, struct xfs_buf *bp);
> -xfs_failaddr_t __xfs_btree_check_sblock(struct xfs_btree_cur *cur,
> +xfs_failaddr_t __xfs_btree_check_sblock(struct xfs_vc *vc, struct xfs_btree_cur *cur,
>  		struct xfs_btree_block *block, int level, struct xfs_buf *bp);
>  
>  /*
> @@ -417,7 +417,7 @@ int xfs_btree_change_owner(struct xfs_btree_cur *cur, uint64_t new_owner,
>  void xfs_btree_lblock_calc_crc(struct xfs_buf *);
>  bool xfs_btree_lblock_verify_crc(struct xfs_buf *);
>  void xfs_btree_sblock_calc_crc(struct xfs_buf *);
> -bool xfs_btree_sblock_verify_crc(struct xfs_buf *);
> +bool xfs_btree_sblock_verify_crc(struct xfs_vc *vc, struct xfs_buf *);
>  
>  /*
>   * Internal btree helpers also used by xfs_bmap.c.
> @@ -457,12 +457,12 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
>  #define	XFS_FILBLKS_MIN(a,b)	min_t(xfs_filblks_t, (a), (b))
>  #define	XFS_FILBLKS_MAX(a,b)	max_t(xfs_filblks_t, (a), (b))
>  
> -xfs_failaddr_t xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
> -xfs_failaddr_t xfs_btree_sblock_verify(struct xfs_buf *bp,
> +xfs_failaddr_t xfs_btree_sblock_v5hdr_verify(struct xfs_vc *vc, struct xfs_buf *bp);
> +xfs_failaddr_t xfs_btree_sblock_verify(struct xfs_vc *vc, struct xfs_buf *bp,
>  		unsigned int max_recs);
> -xfs_failaddr_t xfs_btree_lblock_v5hdr_verify(struct xfs_buf *bp,
> +xfs_failaddr_t xfs_btree_lblock_v5hdr_verify(struct xfs_vc *vc, struct xfs_buf *bp,
>  		uint64_t owner);
> -xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
> +xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_vc *vc, struct xfs_buf *bp,
>  		unsigned int max_recs);
>  
>  uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 376bee94b5dd..38862a0990d4 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -118,6 +118,7 @@ xfs_da_state_free(xfs_da_state_t *state)
>  
>  static xfs_failaddr_t
>  xfs_da3_node_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -167,14 +168,15 @@ xfs_da3_node_verify(
>  
>  static void
>  xfs_da3_node_write_verify(
> -	struct xfs_buf	*bp)
> +	struct xfs_vc		*vc,
> +	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  	struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_da3_node_verify(bp);
> +	fa = xfs_da3_node_verify(vc, bp);
>  	if (fa) {
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  		return;
> @@ -197,6 +199,7 @@ xfs_da3_node_write_verify(
>   */
>  static void
>  xfs_da3_node_read_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_da_blkinfo	*info = bp->b_addr;
> @@ -211,19 +214,19 @@ xfs_da3_node_read_verify(
>  			}
>  			/* fall through */
>  		case XFS_DA_NODE_MAGIC:
> -			fa = xfs_da3_node_verify(bp);
> +			fa = xfs_da3_node_verify(vc, bp);
>  			if (fa)
>  				xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  			return;
>  		case XFS_ATTR_LEAF_MAGIC:
>  		case XFS_ATTR3_LEAF_MAGIC:
>  			bp->b_ops = &xfs_attr3_leaf_buf_ops;
> -			bp->b_ops->verify_read(bp);
> +			bp->b_ops->verify_read(vc, bp);
>  			return;
>  		case XFS_DIR2_LEAFN_MAGIC:
>  		case XFS_DIR3_LEAFN_MAGIC:
>  			bp->b_ops = &xfs_dir3_leafn_buf_ops;
> -			bp->b_ops->verify_read(bp);
> +			bp->b_ops->verify_read(vc, bp);
>  			return;
>  		default:
>  			xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
> @@ -234,6 +237,7 @@ xfs_da3_node_read_verify(
>  /* Verify the structure of a da3 block. */
>  static xfs_failaddr_t
>  xfs_da3_node_verify_struct(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_da_blkinfo	*info = bp->b_addr;
> @@ -241,15 +245,15 @@ xfs_da3_node_verify_struct(
>  	switch (be16_to_cpu(info->magic)) {
>  	case XFS_DA3_NODE_MAGIC:
>  	case XFS_DA_NODE_MAGIC:
> -		return xfs_da3_node_verify(bp);
> +		return xfs_da3_node_verify(vc, bp);
>  	case XFS_ATTR_LEAF_MAGIC:
>  	case XFS_ATTR3_LEAF_MAGIC:
>  		bp->b_ops = &xfs_attr3_leaf_buf_ops;
> -		return bp->b_ops->verify_struct(bp);
> +		return bp->b_ops->verify_struct(vc, bp);
>  	case XFS_DIR2_LEAFN_MAGIC:
>  	case XFS_DIR3_LEAFN_MAGIC:
>  		bp->b_ops = &xfs_dir3_leafn_buf_ops;
> -		return bp->b_ops->verify_struct(bp);
> +		return bp->b_ops->verify_struct(vc, bp);
>  	default:
>  		return __this_address;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
> index 30ed5919da72..65ba4eccce8b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_block.c
> +++ b/fs/xfs/libxfs/xfs_dir2_block.c
> @@ -48,6 +48,7 @@ xfs_dir_startup(void)
>  
>  static xfs_failaddr_t
>  xfs_dir3_block_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -66,11 +67,12 @@ xfs_dir3_block_verify(
>  		if (hdr3->magic != cpu_to_be32(XFS_DIR2_BLOCK_MAGIC))
>  			return __this_address;
>  	}
> -	return __xfs_dir3_data_check(NULL, bp);
> +	return __xfs_dir3_data_check(vc, NULL, bp);
>  }
>  
>  static void
>  xfs_dir3_block_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -80,7 +82,7 @@ xfs_dir3_block_read_verify(
>  	     !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_dir3_block_verify(bp);
> +		fa = xfs_dir3_block_verify(vc, bp);
>  		if (fa)
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -88,6 +90,7 @@ xfs_dir3_block_read_verify(
>  
>  static void
>  xfs_dir3_block_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -95,7 +98,7 @@ xfs_dir3_block_write_verify(
>  	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_dir3_block_verify(bp);
> +	fa = xfs_dir3_block_verify(vc, bp);
>  	if (fa) {
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  		return;
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 01162c62ec8f..6530621d8144 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -22,6 +22,7 @@
>  #include "xfs_log.h"
>  
>  static xfs_failaddr_t xfs_dir2_data_freefind_verify(
> +		struct xfs_vc *vc,
>  		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
>  		struct xfs_dir2_data_unused *dup,
>  		struct xfs_dir2_data_free **bf_ent);
> @@ -33,6 +34,7 @@ static xfs_failaddr_t xfs_dir2_data_freefind_verify(
>   */
>  xfs_failaddr_t
>  __xfs_dir3_data_check(
> +	struct xfs_vc		*vc,		/* verifier context */
>  	struct xfs_inode	*dp,		/* incore inode pointer */
>  	struct xfs_buf		*bp)		/* data block's buffer */
>  {
> @@ -149,7 +151,7 @@ __xfs_dir3_data_check(
>  			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
>  			    (char *)dup - (char *)hdr)
>  				return __this_address;
> -			fa = xfs_dir2_data_freefind_verify(hdr, bf, dup, &dfp);
> +			fa = xfs_dir2_data_freefind_verify(vc, hdr, bf, dup, &dfp);
>  			if (fa)
>  				return fa;
>  			if (dfp) {
> @@ -233,9 +235,10 @@ xfs_dir3_data_check(
>  	struct xfs_inode	*dp,
>  	struct xfs_buf		*bp)
>  {
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  
> -	fa = __xfs_dir3_data_check(dp, bp);
> +	fa = __xfs_dir3_data_check(&vc, dp, bp);
>  	if (!fa)
>  		return;
>  	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, dp->i_mount,
> @@ -247,6 +250,7 @@ xfs_dir3_data_check(
>  
>  static xfs_failaddr_t
>  xfs_dir3_data_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -265,7 +269,7 @@ xfs_dir3_data_verify(
>  		if (hdr3->magic != cpu_to_be32(XFS_DIR2_DATA_MAGIC))
>  			return __this_address;
>  	}
> -	return __xfs_dir3_data_check(NULL, bp);
> +	return __xfs_dir3_data_check(vc, NULL, bp);
>  }
>  
>  /*
> @@ -275,6 +279,7 @@ xfs_dir3_data_verify(
>   */
>  static void
>  xfs_dir3_data_reada_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
> @@ -283,12 +288,12 @@ xfs_dir3_data_reada_verify(
>  	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
>  	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
>  		bp->b_ops = &xfs_dir3_block_buf_ops;
> -		bp->b_ops->verify_read(bp);
> +		bp->b_ops->verify_read(vc, bp);
>  		return;
>  	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
>  	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
>  		bp->b_ops = &xfs_dir3_data_buf_ops;
> -		bp->b_ops->verify_read(bp);
> +		bp->b_ops->verify_read(vc, bp);
>  		return;
>  	default:
>  		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
> @@ -298,6 +303,7 @@ xfs_dir3_data_reada_verify(
>  
>  static void
>  xfs_dir3_data_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -307,7 +313,7 @@ xfs_dir3_data_read_verify(
>  	    !xfs_buf_verify_cksum(bp, XFS_DIR3_DATA_CRC_OFF))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_dir3_data_verify(bp);
> +		fa = xfs_dir3_data_verify(vc, bp);
>  		if (fa)
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -315,6 +321,7 @@ xfs_dir3_data_read_verify(
>  
>  static void
>  xfs_dir3_data_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -322,7 +329,7 @@ xfs_dir3_data_write_verify(
>  	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_dir3_data_verify(bp);
> +	fa = xfs_dir3_data_verify(vc, bp);
>  	if (fa) {
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  		return;
> @@ -384,6 +391,7 @@ xfs_dir3_data_readahead(
>   */
>  static xfs_failaddr_t
>  xfs_dir2_data_freefind_verify(
> +	struct xfs_vc			*vc,
>  	struct xfs_dir2_data_hdr	*hdr,
>  	struct xfs_dir2_data_free	*bf,
>  	struct xfs_dir2_data_unused	*dup,
> @@ -957,6 +965,7 @@ xfs_dir2_data_make_free(
>  /* Check our free data for obvious signs of corruption. */
>  static inline xfs_failaddr_t
>  xfs_dir2_data_check_free(
> +	struct xfs_vc			*vc,
>  	struct xfs_dir2_data_hdr	*hdr,
>  	struct xfs_dir2_data_unused	*dup,
>  	xfs_dir2_data_aoff_t		offset,
> @@ -982,6 +991,7 @@ xfs_dir2_data_check_free(
>  /* Sanity-check a new bestfree entry. */
>  static inline xfs_failaddr_t
>  xfs_dir2_data_check_new_free(
> +	struct xfs_vc			*vc,
>  	struct xfs_dir2_data_hdr	*hdr,
>  	struct xfs_dir2_data_free	*dfp,
>  	struct xfs_dir2_data_unused	*newdup)
> @@ -1013,6 +1023,7 @@ xfs_dir2_data_use_free(
>  	xfs_dir2_data_unused_t	*newdup;	/* new unused entry */
>  	xfs_dir2_data_unused_t	*newdup2;	/* another new unused entry */
>  	struct xfs_dir2_data_free *bf;
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  	int			matchback;	/* matches end of freespace */
>  	int			matchfront;	/* matches start of freespace */
> @@ -1020,7 +1031,7 @@ xfs_dir2_data_use_free(
>  	int			oldlen;		/* old unused entry's length */
>  
>  	hdr = bp->b_addr;
> -	fa = xfs_dir2_data_check_free(hdr, dup, offset, len);
> +	fa = xfs_dir2_data_check_free(&vc, hdr, dup, offset, len);
>  	if (fa)
>  		goto corrupt;
>  	/*
> @@ -1067,7 +1078,7 @@ xfs_dir2_data_use_free(
>  			xfs_dir2_data_freeremove(hdr, bf, dfp, needlogp);
>  			dfp = xfs_dir2_data_freeinsert(hdr, bf, newdup,
>  						       needlogp);
> -			fa = xfs_dir2_data_check_new_free(hdr, dfp, newdup);
> +			fa = xfs_dir2_data_check_new_free(&vc, hdr, dfp, newdup);
>  			if (fa)
>  				goto corrupt;
>  			/*
> @@ -1095,7 +1106,7 @@ xfs_dir2_data_use_free(
>  			xfs_dir2_data_freeremove(hdr, bf, dfp, needlogp);
>  			dfp = xfs_dir2_data_freeinsert(hdr, bf, newdup,
>  						       needlogp);
> -			fa = xfs_dir2_data_check_new_free(hdr, dfp, newdup);
> +			fa = xfs_dir2_data_check_new_free(&vc, hdr, dfp, newdup);
>  			if (fa)
>  				goto corrupt;
>  			/*
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index 1728a3e6f5cf..1122a639b603 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -40,6 +40,7 @@ static void xfs_dir3_leaf_log_tail(struct xfs_da_args *args,
>  #ifdef DEBUG
>  static xfs_failaddr_t
>  xfs_dir3_leaf1_check(
> +	struct xfs_vc		*vc,
>  	struct xfs_inode	*dp,
>  	struct xfs_buf		*bp)
>  {
> @@ -55,7 +56,7 @@ xfs_dir3_leaf1_check(
>  	} else if (leafhdr.magic != XFS_DIR2_LEAF1_MAGIC)
>  		return __this_address;
>  
> -	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf);
> +	return xfs_dir3_leaf_check_int(vc, dp->i_mount, dp, &leafhdr, leaf);
>  }
>  
>  static inline void
> @@ -63,9 +64,10 @@ xfs_dir3_leaf_check(
>  	struct xfs_inode	*dp,
>  	struct xfs_buf		*bp)
>  {
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_dir3_leaf1_check(dp, bp);
> +	fa = xfs_dir3_leaf1_check(&vc, dp, bp);
>  	if (!fa)
>  		return;
>  	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, dp->i_mount,
> @@ -79,6 +81,7 @@ xfs_dir3_leaf_check(
>  
>  xfs_failaddr_t
>  xfs_dir3_leaf_check_int(
> +	struct xfs_vc		*vc,
>  	struct xfs_mount	*mp,
>  	struct xfs_inode	*dp,
>  	struct xfs_dir3_icleaf_hdr *hdr,
> @@ -142,6 +145,7 @@ xfs_dir3_leaf_check_int(
>   */
>  static xfs_failaddr_t
>  xfs_dir3_leaf_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp,
>  	uint16_t		magic)
>  {
> @@ -170,13 +174,14 @@ xfs_dir3_leaf_verify(
>  			return __this_address;
>  	}
>  
> -	return xfs_dir3_leaf_check_int(mp, NULL, NULL, leaf);
> +	return xfs_dir3_leaf_check_int(vc, mp, NULL, NULL, leaf);
>  }
>  
>  static void
>  __read_verify(
> -	struct xfs_buf  *bp,
> -	uint16_t	magic)
> +	struct xfs_vc		*vc,
> +	struct xfs_buf  	*bp,
> +	uint16_t		magic)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	xfs_failaddr_t		fa;
> @@ -185,7 +190,7 @@ __read_verify(
>  	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_dir3_leaf_verify(bp, magic);
> +		fa = xfs_dir3_leaf_verify(vc, bp, magic);
>  		if (fa)
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -193,15 +198,16 @@ __read_verify(
>  
>  static void
>  __write_verify(
> -	struct xfs_buf  *bp,
> -	uint16_t	magic)
> +	struct xfs_vc		*vc,
> +	struct xfs_buf  	*bp,
> +	uint16_t		magic)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_dir3_leaf_verify(bp, magic);
> +	fa = xfs_dir3_leaf_verify(vc, bp, magic);
>  	if (fa) {
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  		return;
> @@ -218,44 +224,50 @@ __write_verify(
>  
>  static xfs_failaddr_t
>  xfs_dir3_leaf1_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
> -	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAF1_MAGIC);
> +	return xfs_dir3_leaf_verify(vc, bp, XFS_DIR2_LEAF1_MAGIC);
>  }
>  
>  static void
>  xfs_dir3_leaf1_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
> -	__read_verify(bp, XFS_DIR2_LEAF1_MAGIC);
> +	__read_verify(vc, bp, XFS_DIR2_LEAF1_MAGIC);
>  }
>  
>  static void
>  xfs_dir3_leaf1_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
> -	__write_verify(bp, XFS_DIR2_LEAF1_MAGIC);
> +	__write_verify(vc, bp, XFS_DIR2_LEAF1_MAGIC);
>  }
>  
>  static xfs_failaddr_t
>  xfs_dir3_leafn_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
> -	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAFN_MAGIC);
> +	return xfs_dir3_leaf_verify(vc, bp, XFS_DIR2_LEAFN_MAGIC);
>  }
>  
>  static void
>  xfs_dir3_leafn_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
> -	__read_verify(bp, XFS_DIR2_LEAFN_MAGIC);
> +	__read_verify(vc, bp, XFS_DIR2_LEAFN_MAGIC);
>  }
>  
>  static void
>  xfs_dir3_leafn_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
> -	__write_verify(bp, XFS_DIR2_LEAFN_MAGIC);
> +	__write_verify(vc, bp, XFS_DIR2_LEAFN_MAGIC);
>  }
>  
>  const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index f1bb3434f51c..70f54145d0b0 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -43,6 +43,7 @@ static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
>  #ifdef DEBUG
>  static xfs_failaddr_t
>  xfs_dir3_leafn_check(
> +	struct xfs_vc		*vc,
>  	struct xfs_inode	*dp,
>  	struct xfs_buf		*bp)
>  {
> @@ -58,7 +59,7 @@ xfs_dir3_leafn_check(
>  	} else if (leafhdr.magic != XFS_DIR2_LEAFN_MAGIC)
>  		return __this_address;
>  
> -	return xfs_dir3_leaf_check_int(dp->i_mount, dp, &leafhdr, leaf);
> +	return xfs_dir3_leaf_check_int(vc, dp->i_mount, dp, &leafhdr, leaf);
>  }
>  
>  static inline void
> @@ -66,9 +67,10 @@ xfs_dir3_leaf_check(
>  	struct xfs_inode	*dp,
>  	struct xfs_buf		*bp)
>  {
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_dir3_leafn_check(dp, bp);
> +	fa = xfs_dir3_leafn_check(&vc, dp, bp);
>  	if (!fa)
>  		return;
>  	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, dp->i_mount,
> @@ -82,6 +84,7 @@ xfs_dir3_leaf_check(
>  
>  static xfs_failaddr_t
>  xfs_dir3_free_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -110,6 +113,7 @@ xfs_dir3_free_verify(
>  
>  static void
>  xfs_dir3_free_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -119,7 +123,7 @@ xfs_dir3_free_read_verify(
>  	    !xfs_buf_verify_cksum(bp, XFS_DIR3_FREE_CRC_OFF))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_dir3_free_verify(bp);
> +		fa = xfs_dir3_free_verify(vc, bp);
>  		if (fa)
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -127,6 +131,7 @@ xfs_dir3_free_read_verify(
>  
>  static void
>  xfs_dir3_free_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -134,7 +139,7 @@ xfs_dir3_free_write_verify(
>  	struct xfs_dir3_blk_hdr	*hdr3 = bp->b_addr;
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_dir3_free_verify(bp);
> +	fa = xfs_dir3_free_verify(vc, bp);
>  	if (fa) {
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  		return;
> @@ -159,6 +164,7 @@ const struct xfs_buf_ops xfs_dir3_free_buf_ops = {
>  /* Everything ok in the free block header? */
>  static xfs_failaddr_t
>  xfs_dir3_free_header_check(
> +	struct xfs_vc		*vc,
>  	struct xfs_inode	*dp,
>  	xfs_dablk_t		fbno,
>  	struct xfs_buf		*bp)
> @@ -201,6 +207,7 @@ __xfs_dir3_free_read(
>  	xfs_daddr_t		mappedbno,
>  	struct xfs_buf		**bpp)
>  {
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  	int			err;
>  
> @@ -210,7 +217,7 @@ __xfs_dir3_free_read(
>  		return err;
>  
>  	/* Check things that we can't do in the verifier. */
> -	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
> +	fa = xfs_dir3_free_header_check(&vc, dp, fbno, *bpp);
>  	if (fa) {
>  		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
>  		xfs_trans_brelse(tp, *bpp);
> diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
> index 59f9fb2241a5..c8d5dc67e02b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_priv.h
> +++ b/fs/xfs/libxfs/xfs_dir2_priv.h
> @@ -32,7 +32,7 @@ extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
>  #define	xfs_dir3_data_check(dp,bp)
>  #endif
>  
> -extern xfs_failaddr_t __xfs_dir3_data_check(struct xfs_inode *dp,
> +extern xfs_failaddr_t __xfs_dir3_data_check(struct xfs_vc *vc, struct xfs_inode *dp,
>  		struct xfs_buf *bp);
>  extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
>  		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
> @@ -78,7 +78,7 @@ xfs_dir3_leaf_find_entry(struct xfs_dir3_icleaf_hdr *leafhdr,
>  		int lowstale, int highstale, int *lfloglow, int *lfloghigh);
>  extern int xfs_dir2_node_to_leaf(struct xfs_da_state *state);
>  
> -extern xfs_failaddr_t xfs_dir3_leaf_check_int(struct xfs_mount *mp,
> +extern xfs_failaddr_t xfs_dir3_leaf_check_int(struct xfs_vc *vc, struct xfs_mount *mp,
>  		struct xfs_inode *dp, struct xfs_dir3_icleaf_hdr *hdr,
>  		struct xfs_dir2_leaf *leaf);
>  
> @@ -117,7 +117,7 @@ extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
>  extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
>  extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
>  extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
> -extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_inode *ip);
> +extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_vc *vc, struct xfs_inode *ip);
>  
>  /* xfs_dir2_readdir.c */
>  extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 585dfdb7b6b6..ea47b403c1c1 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -618,6 +618,7 @@ xfs_dir2_sf_check(
>  /* Verify the consistency of an inline directory. */
>  xfs_failaddr_t
>  xfs_dir2_sf_verify(
> +	struct xfs_vc			*vc,
>  	struct xfs_inode		*ip)
>  {
>  	struct xfs_mount		*mp = ip->i_mount;
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index d293f371dd54..0dc0a8d7ffc4 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -37,6 +37,7 @@ xfs_calc_dquots_per_chunk(
>  
>  xfs_failaddr_t
>  xfs_dquot_verify(
> +	struct xfs_vc	 *vc,
>  	struct xfs_mount *mp,
>  	xfs_disk_dquot_t *ddq,
>  	xfs_dqid_t	 id,
> @@ -95,6 +96,7 @@ xfs_dquot_verify(
>  
>  xfs_failaddr_t
>  xfs_dqblk_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_mount	*mp,
>  	struct xfs_dqblk	*dqb,
>  	xfs_dqid_t	 	id,
> @@ -104,7 +106,7 @@ xfs_dqblk_verify(
>  	    !uuid_equal(&dqb->dd_uuid, &mp->m_sb.sb_meta_uuid))
>  		return __this_address;
>  
> -	return xfs_dquot_verify(mp, &dqb->dd_diskdq, id, type);
> +	return xfs_dquot_verify(vc, mp, &dqb->dd_diskdq, id, type);
>  }
>  
>  /*
> @@ -174,6 +176,7 @@ xfs_dquot_buf_verify_crc(
>  
>  STATIC xfs_failaddr_t
>  xfs_dquot_buf_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_mount	*mp,
>  	struct xfs_buf		*bp,
>  	bool			readahead)
> @@ -209,7 +212,7 @@ xfs_dquot_buf_verify(
>  		if (i == 0)
>  			id = be32_to_cpu(ddq->d_id);
>  
> -		fa = xfs_dqblk_verify(mp, &dqb[i], id + i, 0);
> +		fa = xfs_dqblk_verify(vc, mp, &dqb[i], id + i, 0);
>  		if (fa) {
>  			if (!readahead)
>  				xfs_buf_verifier_error(bp, -EFSCORRUPTED,
> @@ -224,22 +227,24 @@ xfs_dquot_buf_verify(
>  
>  static xfs_failaddr_t
>  xfs_dquot_buf_verify_struct(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
> -	return xfs_dquot_buf_verify(mp, bp, false);
> +	return xfs_dquot_buf_verify(vc, mp, bp, false);
>  }
>  
>  static void
>  xfs_dquot_buf_read_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
>  	if (!xfs_dquot_buf_verify_crc(mp, bp, false))
>  		return;
> -	xfs_dquot_buf_verify(mp, bp, false);
> +	xfs_dquot_buf_verify(vc, mp, bp, false);
>  }
>  
>  /*
> @@ -250,12 +255,13 @@ xfs_dquot_buf_read_verify(
>   */
>  static void
>  xfs_dquot_buf_readahead_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
>  	if (!xfs_dquot_buf_verify_crc(mp, bp, true) ||
> -	    xfs_dquot_buf_verify(mp, bp, true) != NULL) {
> +	    xfs_dquot_buf_verify(vc, mp, bp, true) != NULL) {
>  		xfs_buf_ioerror(bp, -EIO);
>  		bp->b_flags &= ~XBF_DONE;
>  	}
> @@ -268,11 +274,12 @@ xfs_dquot_buf_readahead_verify(
>   */
>  static void
>  xfs_dquot_buf_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
> -	xfs_dquot_buf_verify(mp, bp, false);
> +	xfs_dquot_buf_verify(vc, mp, bp, false);
>  }
>  
>  const struct xfs_buf_ops xfs_dquot_buf_ops = {
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index a8f6db735d5d..1b2b3b63b207 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2497,6 +2497,7 @@ xfs_ialloc_log_agi(
>  
>  static xfs_failaddr_t
>  xfs_agi_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> @@ -2549,6 +2550,7 @@ xfs_agi_verify(
>  
>  static void
>  xfs_agi_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> @@ -2558,7 +2560,7 @@ xfs_agi_read_verify(
>  	    !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_agi_verify(bp);
> +		fa = xfs_agi_verify(vc, bp);
>  		if (XFS_TEST_ERROR(fa, mp, XFS_ERRTAG_IALLOC_READ_AGI))
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -2566,13 +2568,14 @@ xfs_agi_read_verify(
>  
>  static void
>  xfs_agi_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_agi_verify(bp);
> +	fa = xfs_agi_verify(vc, bp);
>  	if (fa) {
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  		return;
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 7fbf8af0b159..02d7dd5c265c 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -256,6 +256,7 @@ xfs_inobt_diff_two_keys(
>  
>  static xfs_failaddr_t
>  xfs_inobt_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -276,7 +277,7 @@ xfs_inobt_verify(
>  	switch (block->bb_magic) {
>  	case cpu_to_be32(XFS_IBT_CRC_MAGIC):
>  	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
> -		fa = xfs_btree_sblock_v5hdr_verify(bp);
> +		fa = xfs_btree_sblock_v5hdr_verify(vc, bp);
>  		if (fa)
>  			return fa;
>  		/* fall through */
> @@ -292,19 +293,20 @@ xfs_inobt_verify(
>  	if (level >= mp->m_in_maxlevels)
>  		return __this_address;
>  
> -	return xfs_btree_sblock_verify(bp, mp->m_inobt_mxr[level != 0]);
> +	return xfs_btree_sblock_verify(vc, bp, mp->m_inobt_mxr[level != 0]);
>  }
>  
>  static void
>  xfs_inobt_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	xfs_failaddr_t	fa;
>  
> -	if (!xfs_btree_sblock_verify_crc(bp))
> +	if (!xfs_btree_sblock_verify_crc(vc, bp))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_inobt_verify(bp);
> +		fa = xfs_inobt_verify(vc, bp);
>  		if (fa)
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -315,11 +317,12 @@ xfs_inobt_read_verify(
>  
>  static void
>  xfs_inobt_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	xfs_failaddr_t	fa;
>  
> -	fa = xfs_inobt_verify(bp);
> +	fa = xfs_inobt_verify(vc, bp);
>  	if (fa) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 09d9c8cfa4a0..7d9b4ea6eba9 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -77,6 +77,7 @@ xfs_dinode_good_version(
>   */
>  static void
>  xfs_inode_buf_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp,
>  	bool		readahead)
>  {
> @@ -126,23 +127,26 @@ xfs_inode_buf_verify(
>  
>  static void
>  xfs_inode_buf_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
> -	xfs_inode_buf_verify(bp, false);
> +	xfs_inode_buf_verify(vc, bp, false);
>  }
>  
>  static void
>  xfs_inode_buf_readahead_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
> -	xfs_inode_buf_verify(bp, true);
> +	xfs_inode_buf_verify(vc, bp, true);
>  }
>  
>  static void
>  xfs_inode_buf_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
> -	xfs_inode_buf_verify(bp, false);
> +	xfs_inode_buf_verify(vc, bp, false);
>  }
>  
>  const struct xfs_buf_ops xfs_inode_buf_ops = {
> @@ -376,6 +380,7 @@ xfs_log_dinode_to_disk(
>  
>  static xfs_failaddr_t
>  xfs_dinode_verify_fork(
> +	struct xfs_vc		*vc,
>  	struct xfs_dinode	*dip,
>  	struct xfs_mount	*mp,
>  	int			whichfork)
> @@ -417,6 +422,7 @@ xfs_dinode_verify_fork(
>  
>  static xfs_failaddr_t
>  xfs_dinode_verify_forkoff(
> +	struct xfs_vc		*vc,
>  	struct xfs_dinode	*dip,
>  	struct xfs_mount	*mp)
>  {
> @@ -442,6 +448,7 @@ xfs_dinode_verify_forkoff(
>  
>  xfs_failaddr_t
>  xfs_dinode_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_mount	*mp,
>  	xfs_ino_t		ino,
>  	struct xfs_dinode	*dip)
> @@ -496,7 +503,7 @@ xfs_dinode_verify(
>  		return __this_address;
>  
>  	/* check for illegal values of forkoff */
> -	fa = xfs_dinode_verify_forkoff(dip, mp);
> +	fa = xfs_dinode_verify_forkoff(vc, dip, mp);
>  	if (fa)
>  		return fa;
>  
> @@ -512,7 +519,7 @@ xfs_dinode_verify(
>  	case S_IFREG:
>  	case S_IFLNK:
>  	case S_IFDIR:
> -		fa = xfs_dinode_verify_fork(dip, mp, XFS_DATA_FORK);
> +		fa = xfs_dinode_verify_fork(vc, dip, mp, XFS_DATA_FORK);
>  		if (fa)
>  			return fa;
>  		break;
> @@ -524,7 +531,7 @@ xfs_dinode_verify(
>  	}
>  
>  	if (XFS_DFORK_Q(dip)) {
> -		fa = xfs_dinode_verify_fork(dip, mp, XFS_ATTR_FORK);
> +		fa = xfs_dinode_verify_fork(vc, dip, mp, XFS_ATTR_FORK);
>  		if (fa)
>  			return fa;
>  	} else {
> @@ -546,7 +553,7 @@ xfs_dinode_verify(
>  	}
>  
>  	/* extent size hint validation */
> -	fa = xfs_inode_validate_extsize(mp, be32_to_cpu(dip->di_extsize),
> +	fa = xfs_inode_validate_extsize(vc, mp, be32_to_cpu(dip->di_extsize),
>  			mode, flags);
>  	if (fa)
>  		return fa;
> @@ -575,7 +582,7 @@ xfs_dinode_verify(
>  		return __this_address;
>  
>  	/* COW extent size hint validation */
> -	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
> +	fa = xfs_inode_validate_cowextsize(vc, mp, be32_to_cpu(dip->di_cowextsize),
>  			mode, flags, flags2);
>  	if (fa)
>  		return fa;
> @@ -620,6 +627,7 @@ xfs_iread(
>  {
>  	xfs_buf_t	*bp;
>  	xfs_dinode_t	*dip;
> +	struct xfs_vc	vc = { 0 };
>  	xfs_failaddr_t	fa;
>  	int		error;
>  
> @@ -649,7 +657,7 @@ xfs_iread(
>  		return error;
>  
>  	/* even unallocated inodes are verified */
> -	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
> +	fa = xfs_dinode_verify(&vc, mp, ip->i_ino, dip);
>  	if (fa) {
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "dinode", dip,
>  				sizeof(*dip), fa);
> @@ -728,6 +736,7 @@ xfs_iread(
>   */
>  xfs_failaddr_t
>  xfs_inode_validate_extsize(
> +	struct xfs_vc			*vc,
>  	struct xfs_mount		*mp,
>  	uint32_t			extsize,
>  	uint16_t			mode,
> @@ -785,6 +794,7 @@ xfs_inode_validate_extsize(
>   */
>  xfs_failaddr_t
>  xfs_inode_validate_cowextsize(
> +	struct xfs_vc			*vc,
>  	struct xfs_mount		*mp,
>  	uint32_t			cowextsize,
>  	uint16_t			mode,
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index ab0f84165317..fceea886275f 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -70,11 +70,11 @@ void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
>  #define	xfs_inobp_check(mp, bp)
>  #endif /* DEBUG */
>  
> -xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
> +xfs_failaddr_t xfs_dinode_verify(struct xfs_vc *vc, struct xfs_mount *mp, xfs_ino_t ino,
>  			   struct xfs_dinode *dip);
> -xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
> +xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_vc *vc, struct xfs_mount *mp,
>  		uint32_t extsize, uint16_t mode, uint16_t flags);
> -xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
> +xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_vc *vc, struct xfs_mount *mp,
>  		uint32_t cowextsize, uint16_t mode, uint16_t flags,
>  		uint64_t flags2);
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index f9acf1d436f6..49dd81b0728f 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -233,10 +233,11 @@ xfs_iformat_extents(
>  
>  		xfs_iext_first(ifp, &icur);
>  		for (i = 0; i < nex; i++, dp++) {
> +			struct xfs_vc	vc = { 0 };
>  			xfs_failaddr_t	fa;
>  
>  			xfs_bmbt_disk_get_all(dp, &new);
> -			fa = xfs_bmap_validate_extent(ip, whichfork, &new);
> +			fa = xfs_bmap_validate_extent(&vc, ip, whichfork, &new);
>  			if (fa) {
>  				xfs_inode_verifier_error(ip, -EFSCORRUPTED,
>  						"xfs_iformat_extents(2)",
> @@ -562,7 +563,7 @@ xfs_iextents_copy(
>  	for_each_xfs_iext(ifp, &icur, &rec) {
>  		if (isnullstartblock(rec.br_startblock))
>  			continue;
> -		ASSERT(xfs_bmap_validate_extent(ip, whichfork, &rec) == NULL);
> +		ASSERT(xfs_bmap_validate_extent(NULL, ip, whichfork, &rec) == NULL);
>  		xfs_bmbt_disk_set_all(dp, &rec);
>  		trace_xfs_write_extent(ip, &icur, state, _RET_IP_);
>  		copied += sizeof(struct xfs_bmbt_rec);
> @@ -701,6 +702,7 @@ struct xfs_ifork_ops xfs_default_ifork_ops = {
>  /* Verify the inline contents of the data fork of an inode. */
>  xfs_failaddr_t
>  xfs_ifork_verify_data(
> +	struct xfs_vc		*vc,
>  	struct xfs_inode	*ip,
>  	struct xfs_ifork_ops	*ops)
>  {
> @@ -711,9 +713,9 @@ xfs_ifork_verify_data(
>  	/* Check the inline data fork if there is one. */
>  	switch (VFS_I(ip)->i_mode & S_IFMT) {
>  	case S_IFDIR:
> -		return ops->verify_dir(ip);
> +		return ops->verify_dir(vc, ip);
>  	case S_IFLNK:
> -		return ops->verify_symlink(ip);
> +		return ops->verify_symlink(vc, ip);
>  	default:
>  		return NULL;
>  	}
> @@ -722,6 +724,7 @@ xfs_ifork_verify_data(
>  /* Verify the inline contents of the attr fork of an inode. */
>  xfs_failaddr_t
>  xfs_ifork_verify_attr(
> +	struct xfs_vc		*vc,
>  	struct xfs_inode	*ip,
>  	struct xfs_ifork_ops	*ops)
>  {
> @@ -730,5 +733,5 @@ xfs_ifork_verify_attr(
>  		return NULL;
>  	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
>  		return __this_address;
> -	return ops->verify_attr(ip);
> +	return ops->verify_attr(vc, ip);
>  }
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 60361d2d74a1..b2f67389304c 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -174,7 +174,7 @@ extern struct kmem_zone	*xfs_ifork_zone;
>  
>  extern void xfs_ifork_init_cow(struct xfs_inode *ip);
>  
> -typedef xfs_failaddr_t (*xfs_ifork_verifier_t)(struct xfs_inode *);
> +typedef xfs_failaddr_t (*xfs_ifork_verifier_t)(struct xfs_vc *vc, struct xfs_inode *);
>  
>  struct xfs_ifork_ops {
>  	xfs_ifork_verifier_t	verify_symlink;
> @@ -183,9 +183,9 @@ struct xfs_ifork_ops {
>  };
>  extern struct xfs_ifork_ops	xfs_default_ifork_ops;
>  
> -xfs_failaddr_t xfs_ifork_verify_data(struct xfs_inode *ip,
> +xfs_failaddr_t xfs_ifork_verify_data(struct xfs_vc *vc, struct xfs_inode *ip,
>  		struct xfs_ifork_ops *ops);
> -xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_inode *ip,
> +xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_vc *vc, struct xfs_inode *ip,
>  		struct xfs_ifork_ops *ops);
>  
>  #endif	/* __XFS_INODE_FORK_H__ */
> diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
> index 4bfdd5f4c6af..d6af05e0a6f1 100644
> --- a/fs/xfs/libxfs/xfs_quota_defs.h
> +++ b/fs/xfs/libxfs/xfs_quota_defs.h
> @@ -137,9 +137,9 @@ typedef uint16_t	xfs_qwarncnt_t;
>  		(XFS_QMOPT_UQUOTA | XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)
>  #define XFS_QMOPT_RESBLK_MASK	(XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_RES_RTBLKS)
>  
> -extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
> +extern xfs_failaddr_t xfs_dquot_verify(struct xfs_vc *vc, struct xfs_mount *mp,
>  		struct xfs_disk_dquot *ddq, xfs_dqid_t id, uint type);
> -extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
> +extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_vc *vc, struct xfs_mount *mp,
>  		struct xfs_dqblk *dqb, xfs_dqid_t id, uint type);
>  extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
>  extern int xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 1aaa01c97517..125b536538ec 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -203,6 +203,7 @@ xfs_refcountbt_diff_two_keys(
>  
>  STATIC xfs_failaddr_t
>  xfs_refcountbt_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -216,7 +217,7 @@ xfs_refcountbt_verify(
>  
>  	if (!xfs_sb_version_hasreflink(&mp->m_sb))
>  		return __this_address;
> -	fa = xfs_btree_sblock_v5hdr_verify(bp);
> +	fa = xfs_btree_sblock_v5hdr_verify(vc, bp);
>  	if (fa)
>  		return fa;
>  
> @@ -227,19 +228,20 @@ xfs_refcountbt_verify(
>  	} else if (level >= mp->m_refc_maxlevels)
>  		return __this_address;
>  
> -	return xfs_btree_sblock_verify(bp, mp->m_refc_mxr[level != 0]);
> +	return xfs_btree_sblock_verify(vc, bp, mp->m_refc_mxr[level != 0]);
>  }
>  
>  STATIC void
>  xfs_refcountbt_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	xfs_failaddr_t	fa;
>  
> -	if (!xfs_btree_sblock_verify_crc(bp))
> +	if (!xfs_btree_sblock_verify_crc(vc, bp))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_refcountbt_verify(bp);
> +		fa = xfs_refcountbt_verify(vc, bp);
>  		if (fa)
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -250,11 +252,12 @@ xfs_refcountbt_read_verify(
>  
>  STATIC void
>  xfs_refcountbt_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	xfs_failaddr_t	fa;
>  
> -	fa = xfs_refcountbt_verify(bp);
> +	fa = xfs_refcountbt_verify(vc, bp);
>  	if (fa) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index f79cf040d745..f8828854ca2f 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -290,6 +290,7 @@ xfs_rmapbt_diff_two_keys(
>  
>  static xfs_failaddr_t
>  xfs_rmapbt_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -315,7 +316,7 @@ xfs_rmapbt_verify(
>  
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		return __this_address;
> -	fa = xfs_btree_sblock_v5hdr_verify(bp);
> +	fa = xfs_btree_sblock_v5hdr_verify(vc, bp);
>  	if (fa)
>  		return fa;
>  
> @@ -326,19 +327,20 @@ xfs_rmapbt_verify(
>  	} else if (level >= mp->m_rmap_maxlevels)
>  		return __this_address;
>  
> -	return xfs_btree_sblock_verify(bp, mp->m_rmap_mxr[level != 0]);
> +	return xfs_btree_sblock_verify(vc, bp, mp->m_rmap_mxr[level != 0]);
>  }
>  
>  static void
>  xfs_rmapbt_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	xfs_failaddr_t	fa;
>  
> -	if (!xfs_btree_sblock_verify_crc(bp))
> +	if (!xfs_btree_sblock_verify_crc(vc, bp))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_rmapbt_verify(bp);
> +		fa = xfs_rmapbt_verify(vc, bp);
>  		if (fa)
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -349,11 +351,12 @@ xfs_rmapbt_read_verify(
>  
>  static void
>  xfs_rmapbt_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	xfs_failaddr_t	fa;
>  
> -	fa = xfs_rmapbt_verify(bp);
> +	fa = xfs_rmapbt_verify(vc, bp);
>  	if (fa) {
>  		trace_xfs_btree_corrupt(bp, _RET_IP_);
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index b228c821bae6..6a0a953553b9 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -36,6 +36,7 @@
>   */
>  static void
>  xfs_rtbuf_verify_read(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	return;
> @@ -43,6 +44,7 @@ xfs_rtbuf_verify_read(
>  
>  static void
>  xfs_rtbuf_verify_write(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	return;
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index b5a82acd7dfe..0f8197c368a9 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -681,6 +681,7 @@ xfs_sb_to_disk(
>   */
>  static void
>  xfs_sb_read_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_sb		sb;
> @@ -732,13 +733,14 @@ xfs_sb_read_verify(
>   */
>  static void
>  xfs_sb_quiet_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
>  
>  	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC)) {
>  		/* XFS filesystem, verify noisily! */
> -		xfs_sb_read_verify(bp);
> +		xfs_sb_read_verify(vc, bp);
>  		return;
>  	}
>  	/* quietly fail */
> @@ -747,6 +749,7 @@ xfs_sb_quiet_read_verify(
>  
>  static void
>  xfs_sb_write_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_sb		sb;
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 1c5debe748f0..c10d02addaa1 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -132,6 +132,6 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
>  			uint32_t size, struct xfs_buf *bp);
>  void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
>  				 struct xfs_inode *ip, struct xfs_ifork *ifp);
> -xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
> +xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_vc *vc, struct xfs_inode *ip);
>  
>  #endif /* __XFS_SHARED_H__ */
> diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> index 95374ab2dee7..e0ff80797942 100644
> --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> @@ -88,6 +88,7 @@ xfs_symlink_hdr_ok(
>  
>  static xfs_failaddr_t
>  xfs_symlink_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> @@ -114,6 +115,7 @@ xfs_symlink_verify(
>  
>  static void
>  xfs_symlink_read_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> @@ -126,7 +128,7 @@ xfs_symlink_read_verify(
>  	if (!xfs_buf_verify_cksum(bp, XFS_SYMLINK_CRC_OFF))
>  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
>  	else {
> -		fa = xfs_symlink_verify(bp);
> +		fa = xfs_symlink_verify(vc, bp);
>  		if (fa)
>  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
> @@ -134,6 +136,7 @@ xfs_symlink_read_verify(
>  
>  static void
>  xfs_symlink_write_verify(
> +	struct xfs_vc	*vc,
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> @@ -144,7 +147,7 @@ xfs_symlink_write_verify(
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		return;
>  
> -	fa = xfs_symlink_verify(bp);
> +	fa = xfs_symlink_verify(vc, bp);
>  	if (fa) {
>  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  		return;
> @@ -202,6 +205,7 @@ xfs_symlink_local_to_remote(
>  /* Verify the consistency of an inline symlink. */
>  xfs_failaddr_t
>  xfs_symlink_shortform_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_inode	*ip)
>  {
>  	char			*sfp;
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index b9e6c89284c3..6c27103522a9 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -41,6 +41,10 @@ typedef int64_t		xfs_sfiloff_t;	/* signed block number in a file */
>   */
>  typedef void *		xfs_failaddr_t;
>  
> +struct xfs_vc {
> +	xfs_failaddr_t	fa;
> +};
> +
>  /*
>   * Null values for the types.
>   */
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index 4ae959f7ad2c..8780dcb479de 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -490,6 +490,7 @@ xchk_btree_get_block(
>  	struct xfs_btree_block	**pblock,
>  	struct xfs_buf		**pbp)
>  {
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		failed_at;
>  	int			error;
>  
> @@ -503,10 +504,10 @@ xchk_btree_get_block(
>  
>  	xfs_btree_get_block(bs->cur, level, pbp);
>  	if (bs->cur->bc_flags & XFS_BTREE_LONG_PTRS)
> -		failed_at = __xfs_btree_check_lblock(bs->cur, *pblock,
> +		failed_at = __xfs_btree_check_lblock(&vc, bs->cur, *pblock,
>  				level, *pbp);
>  	else
> -		failed_at = __xfs_btree_check_sblock(bs->cur, *pblock,
> +		failed_at = __xfs_btree_check_sblock(&vc, bs->cur, *pblock,
>  				 level, *pbp);
>  	if (failed_at) {
>  		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 346b02abccf7..1571e66e657a 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -791,6 +791,7 @@ xchk_buffer_recheck(
>  	struct xfs_scrub	*sc,
>  	struct xfs_buf		*bp)
>  {
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  
>  	if (bp->b_ops == NULL) {
> @@ -801,7 +802,7 @@ xchk_buffer_recheck(
>  		xchk_set_incomplete(sc);
>  		return;
>  	}
> -	fa = bp->b_ops->verify_struct(bp);
> +	fa = bp->b_ops->verify_struct(&vc, bp);
>  	if (!fa)
>  		return;
>  	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> index f1260b4bfdee..4626a208d132 100644
> --- a/fs/xfs/scrub/dabtree.c
> +++ b/fs/xfs/scrub/dabtree.c
> @@ -177,6 +177,7 @@ xchk_da_btree_ptr_ok(
>   */
>  static void
>  xchk_da_btree_read_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_da_blkinfo	*info = bp->b_addr;
> @@ -185,7 +186,7 @@ xchk_da_btree_read_verify(
>  	case XFS_DIR2_LEAF1_MAGIC:
>  	case XFS_DIR3_LEAF1_MAGIC:
>  		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
> -		bp->b_ops->verify_read(bp);
> +		bp->b_ops->verify_read(vc, bp);
>  		return;
>  	default:
>  		/*
> @@ -193,12 +194,13 @@ xchk_da_btree_read_verify(
>  		 * DA*_NODE, ATTR*_LEAF, and DIR*_LEAFN blocks.
>  		 */
>  		bp->b_ops = &xfs_da3_node_buf_ops;
> -		bp->b_ops->verify_read(bp);
> +		bp->b_ops->verify_read(vc, bp);
>  		return;
>  	}
>  }
>  static void
>  xchk_da_btree_write_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_da_blkinfo	*info = bp->b_addr;
> @@ -207,7 +209,7 @@ xchk_da_btree_write_verify(
>  	case XFS_DIR2_LEAF1_MAGIC:
>  	case XFS_DIR3_LEAF1_MAGIC:
>  		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
> -		bp->b_ops->verify_write(bp);
> +		bp->b_ops->verify_write(vc, bp);
>  		return;
>  	default:
>  		/*
> @@ -215,12 +217,13 @@ xchk_da_btree_write_verify(
>  		 * DA*_NODE, ATTR*_LEAF, and DIR*_LEAFN blocks.
>  		 */
>  		bp->b_ops = &xfs_da3_node_buf_ops;
> -		bp->b_ops->verify_write(bp);
> +		bp->b_ops->verify_write(vc, bp);
>  		return;
>  	}
>  }
>  static void *
>  xchk_da_btree_verify(
> +	struct xfs_vc		*vc,
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_da_blkinfo	*info = bp->b_addr;
> @@ -229,10 +232,10 @@ xchk_da_btree_verify(
>  	case XFS_DIR2_LEAF1_MAGIC:
>  	case XFS_DIR3_LEAF1_MAGIC:
>  		bp->b_ops = &xfs_dir3_leaf1_buf_ops;
> -		return bp->b_ops->verify_struct(bp);
> +		return bp->b_ops->verify_struct(vc, bp);
>  	default:
>  		bp->b_ops = &xfs_da3_node_buf_ops;
> -		return bp->b_ops->verify_struct(bp);
> +		return bp->b_ops->verify_struct(vc, bp);
>  	}
>  }
>  
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index e386c9b0b4ab..f8c6869b8fc6 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -83,9 +83,10 @@ xchk_inode_extsize(
>  	uint16_t		mode,
>  	uint16_t		flags)
>  {
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_inode_validate_extsize(sc->mp, be32_to_cpu(dip->di_extsize),
> +	fa = xfs_inode_validate_extsize(&vc, sc->mp, be32_to_cpu(dip->di_extsize),
>  			mode, flags);
>  	if (fa)
>  		xchk_ino_set_corrupt(sc, ino);
> @@ -106,9 +107,10 @@ xchk_inode_cowextsize(
>  	uint16_t		flags,
>  	uint64_t		flags2)
>  {
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_inode_validate_cowextsize(sc->mp,
> +	fa = xfs_inode_validate_cowextsize(&vc, sc->mp,
>  			be32_to_cpu(dip->di_cowextsize), mode, flags,
>  			flags2);
>  	if (fa)
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 4fc0a5ea7673..dc9b5762d1ac 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -766,11 +766,13 @@ xrep_findroot_block(
>  		if (bp->b_ops != fab->buf_ops)
>  			goto out;
>  	} else {
> +		struct xfs_vc	vc = { 0 };
> +
>  		ASSERT(!xfs_trans_buf_is_dirty(bp));
>  		if (!uuid_equal(&btblock->bb_u.s.bb_uuid,
>  				&mp->m_sb.sb_meta_uuid))
>  			goto out;
> -		fab->buf_ops->verify_read(bp);
> +		fab->buf_ops->verify_read(&vc, bp);
>  		if (bp->b_error) {
>  			bp->b_error = 0;
>  			goto out;
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index b21ea2ba768d..b46e22c7a8c8 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -786,6 +786,8 @@ xfs_buf_ensure_ops(
>  	struct xfs_buf		*bp,
>  	const struct xfs_buf_ops *ops)
>  {
> +	struct xfs_vc	vc = { 0 };

Indentation?

--D

> +
>  	ASSERT(bp->b_flags & XBF_DONE);
>  	ASSERT(bp->b_error == 0);
>  
> @@ -793,7 +795,7 @@ xfs_buf_ensure_ops(
>  		return 0;
>  
>  	bp->b_ops = ops;
> -	bp->b_ops->verify_read(bp);
> +	bp->b_ops->verify_read(&vc, bp);
>  	if (bp->b_error)
>  		bp->b_flags &= ~XBF_DONE;
>  	return bp->b_error;
> @@ -1228,8 +1230,10 @@ xfs_buf_ioend(
>  
>  	/* Only validate buffers that were read without errors */
>  	if (read && !bp->b_error && bp->b_ops) {
> +		struct xfs_vc	vc = { 0 };
> +
>  		ASSERT(!bp->b_iodone);
> -		bp->b_ops->verify_read(bp);
> +		bp->b_ops->verify_read(&vc, bp);
>  	}
>  
>  	if (!bp->b_error)
> @@ -1447,7 +1451,9 @@ _xfs_buf_ioapply(
>  		 * the IO should not be dispatched.
>  		 */
>  		if (bp->b_ops) {
> -			bp->b_ops->verify_write(bp);
> +			struct xfs_vc	vc = { 0 };
> +
> +			bp->b_ops->verify_write(&vc, bp);
>  			if (bp->b_error) {
>  				xfs_force_shutdown(bp->b_target->bt_mount,
>  						   SHUTDOWN_CORRUPT_INCORE);
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 5015255b5ede..d1c6c92b7104 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -125,9 +125,9 @@ struct xfs_buf_map {
>  
>  struct xfs_buf_ops {
>  	char *name;
> -	void (*verify_read)(struct xfs_buf *);
> -	void (*verify_write)(struct xfs_buf *);
> -	xfs_failaddr_t (*verify_struct)(struct xfs_buf *bp);
> +	void (*verify_read)(struct xfs_vc *vc, struct xfs_buf *);
> +	void (*verify_write)(struct xfs_vc *vc, struct xfs_buf *);
> +	xfs_failaddr_t (*verify_struct)(struct xfs_vc *vc, struct xfs_buf *bp);
>  };
>  
>  typedef struct xfs_buf {
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 87e6dd5326d5..14b386c584b6 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1074,6 +1074,7 @@ xfs_qm_dqflush(
>  	struct xfs_buf		*bp;
>  	struct xfs_dqblk	*dqb;
>  	struct xfs_disk_dquot	*ddqp;
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  	int			error;
>  
> @@ -1122,7 +1123,7 @@ xfs_qm_dqflush(
>  	/*
>  	 * A simple sanity check in case we got a corrupted dquot.
>  	 */
> -	fa = xfs_dqblk_verify(mp, dqb, be32_to_cpu(ddqp->d_id), 0);
> +	fa = xfs_dqblk_verify(&vc, mp, dqb, be32_to_cpu(ddqp->d_id), 0);
>  	if (fa) {
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
>  				be32_to_cpu(ddqp->d_id), fa);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 05db9540e459..d2fd4d4b7864 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3416,9 +3416,10 @@ xfs_inode_verify_forks(
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_ifork	*ifp;
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  
> -	fa = xfs_ifork_verify_data(ip, &xfs_default_ifork_ops);
> +	fa = xfs_ifork_verify_data(&vc, ip, &xfs_default_ifork_ops);
>  	if (fa) {
>  		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
> @@ -3426,7 +3427,7 @@ xfs_inode_verify_forks(
>  		return false;
>  	}
>  
> -	fa = xfs_ifork_verify_attr(ip, &xfs_default_ifork_ops);
> +	fa = xfs_ifork_verify_attr(&vc, ip, &xfs_default_ifork_ops);
>  	if (fa) {
>  		ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
>  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1fc9e9042e0e..bcafd3961d20 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2650,6 +2650,7 @@ xlog_recover_do_reg_buffer(
>  	int			i;
>  	int			bit;
>  	int			nbits;
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  
>  	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
> @@ -2699,7 +2700,7 @@ xlog_recover_do_reg_buffer(
>  					item->ri_buf[i].i_len, __func__);
>  				goto next;
>  			}
> -			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr,
> +			fa = xfs_dquot_verify(&vc, mp, item->ri_buf[i].i_addr,
>  					       -1, 0);
>  			if (fa) {
>  				xfs_alert(mp,
> @@ -3308,6 +3309,7 @@ xlog_recover_dquot_pass2(
>  	xfs_mount_t		*mp = log->l_mp;
>  	xfs_buf_t		*bp;
>  	struct xfs_disk_dquot	*ddq, *recddq;
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  	int			error;
>  	xfs_dq_logformat_t	*dq_f;
> @@ -3351,7 +3353,7 @@ xlog_recover_dquot_pass2(
>  	 */
>  	dq_f = item->ri_buf[0].i_addr;
>  	ASSERT(dq_f);
> -	fa = xfs_dquot_verify(mp, recddq, dq_f->qlf_id, 0);
> +	fa = xfs_dquot_verify(&vc, mp, recddq, dq_f->qlf_id, 0);
>  	if (fa) {
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
>  				dq_f->qlf_id, fa);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 52ed7904df10..09cd6e971074 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -833,6 +833,7 @@ xfs_qm_reset_dqcounts(
>  {
>  	struct xfs_dqblk	*dqb;
>  	int			j;
> +	struct xfs_vc		vc = { 0 };
>  	xfs_failaddr_t		fa;
>  
>  	trace_xfs_reset_dqcounts(bp, _RET_IP_);
> @@ -858,7 +859,7 @@ xfs_qm_reset_dqcounts(
>  		 * find uninitialised dquot blks. See comment in
>  		 * xfs_dquot_verify.
>  		 */
> -		fa = xfs_dqblk_verify(mp, &dqb[j], id + j, type);
> +		fa = xfs_dqblk_verify(&vc, mp, &dqb[j], id + j, type);
>  		if (fa)
>  			xfs_dqblk_repair(mp, &dqb[j], id + j, type);
>  
> -- 
> 2.17.0
> 
> 
