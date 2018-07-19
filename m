Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727501AbeGSNmX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 09:42:23 -0400
Date: Thu, 19 Jul 2018 08:59:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/8] xfs: shorten xfs_repair_ prefix to xrep_
Message-ID: <20180719125918.GH25672@bfoster>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192911831.31685.9739086364482425982.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153192911831.31685.9739086364482425982.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 18, 2018 at 08:51:58AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Shorten all the metadata repair xfs_repair_* symbols to xrep_.
> Whitespace damage will be fixed by a subsequent patch.  There are no
> functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/agheader_repair.c |    2 
>  fs/xfs/scrub/common.c          |    2 
>  fs/xfs/scrub/repair.c          |  164 ++++++++++++++++++++--------------------
>  fs/xfs/scrub/repair.h          |   74 +++++++++---------
>  fs/xfs/scrub/scrub.c           |   54 +++++++------
>  fs/xfs/scrub/trace.h           |   40 +++++-----
>  6 files changed, 168 insertions(+), 168 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 117eedac53df..631940f3ca4d 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -28,7 +28,7 @@
>  
>  /* Repair the superblock. */
>  int
> -xfs_repair_superblock(
> +xrep_superblock(
>  	struct xfs_scrub_context	*sc)
>  {
>  	struct xfs_mount		*mp = sc->mp;
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index a4004a06f482..fa1c16063d17 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -604,7 +604,7 @@ xchk_setup_fs(
>  {
>  	uint				resblks;
>  
> -	resblks = xfs_repair_calc_ag_resblks(sc);
> +	resblks = xrep_calc_ag_resblks(sc);
>  	return xchk_trans_alloc(sc, resblks);
>  }
>  
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 5eccd89c64a8..7e6a56a5f59d 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -41,21 +41,21 @@
>   * and will set *fixed to true if it thinks it repaired anything.
>   */
>  int
> -xfs_repair_attempt(
> +xrep_attempt(
>  	struct xfs_inode		*ip,
>  	struct xfs_scrub_context	*sc,
>  	bool				*fixed)
>  {
>  	int				error = 0;
>  
> -	trace_xfs_repair_attempt(ip, sc->sm, error);
> +	trace_xrep_attempt(ip, sc->sm, error);
>  
>  	xchk_ag_btcur_free(&sc->sa);
>  
>  	/* Repair whatever's broken. */
>  	ASSERT(sc->ops->repair);
>  	error = sc->ops->repair(sc);
> -	trace_xfs_repair_done(ip, sc->sm, error);
> +	trace_xrep_done(ip, sc->sm, error);
>  	switch (error) {
>  	case 0:
>  		/*
> @@ -93,7 +93,7 @@ xfs_repair_attempt(
>   * structure to track rate limiting information.
>   */
>  void
> -xfs_repair_failure(
> +xrep_failure(
>  	struct xfs_mount		*mp)
>  {
>  	xfs_alert_ratelimited(mp,
> @@ -105,7 +105,7 @@ xfs_repair_failure(
>   * given mountpoint.
>   */
>  int
> -xfs_repair_probe(
> +xrep_probe(
>  	struct xfs_scrub_context	*sc)
>  {
>  	int				error = 0;
> @@ -121,7 +121,7 @@ xfs_repair_probe(
>   * the btree cursors.
>   */
>  int
> -xfs_repair_roll_ag_trans(
> +xrep_roll_ag_trans(
>  	struct xfs_scrub_context	*sc)
>  {
>  	int				error;
> @@ -162,7 +162,7 @@ xfs_repair_roll_ag_trans(
>   * in AG reservations) to construct a whole btree.
>   */
>  bool
> -xfs_repair_ag_has_space(
> +xrep_ag_has_space(
>  	struct xfs_perag		*pag,
>  	xfs_extlen_t			nr_blocks,
>  	enum xfs_ag_resv_type		type)
> @@ -178,7 +178,7 @@ xfs_repair_ag_has_space(
>   * any type of per-AG btree.
>   */
>  xfs_extlen_t
> -xfs_repair_calc_ag_resblks(
> +xrep_calc_ag_resblks(
>  	struct xfs_scrub_context	*sc)
>  {
>  	struct xfs_mount		*mp = sc->mp;
> @@ -231,7 +231,7 @@ xfs_repair_calc_ag_resblks(
>  	}
>  	xfs_perag_put(pag);
>  
> -	trace_xfs_repair_calc_ag_resblks(mp, sm->sm_agno, icount, aglen,
> +	trace_xrep_calc_ag_resblks(mp, sm->sm_agno, icount, aglen,
>  			freelen, usedlen);
>  
>  	/*
> @@ -270,7 +270,7 @@ xfs_repair_calc_ag_resblks(
>  		rmapbt_sz = 0;
>  	}
>  
> -	trace_xfs_repair_calc_ag_resblks_btsize(mp, sm->sm_agno, bnobt_sz,
> +	trace_xrep_calc_ag_resblks_btsize(mp, sm->sm_agno, bnobt_sz,
>  			inobt_sz, rmapbt_sz, refcbt_sz);
>  
>  	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
> @@ -278,7 +278,7 @@ xfs_repair_calc_ag_resblks(
>  
>  /* Allocate a block in an AG. */
>  int
> -xfs_repair_alloc_ag_block(
> +xrep_alloc_ag_block(
>  	struct xfs_scrub_context	*sc,
>  	struct xfs_owner_info		*oinfo,
>  	xfs_fsblock_t			*fsbno,
> @@ -329,7 +329,7 @@ xfs_repair_alloc_ag_block(
>  
>  /* Initialize a new AG btree root block with zero entries. */
>  int
> -xfs_repair_init_btblock(
> +xrep_init_btblock(
>  	struct xfs_scrub_context	*sc,
>  	xfs_fsblock_t			fsb,
>  	struct xfs_buf			**bpp,
> @@ -340,7 +340,7 @@ xfs_repair_init_btblock(
>  	struct xfs_mount		*mp = sc->mp;
>  	struct xfs_buf			*bp;
>  
> -	trace_xfs_repair_init_btblock(mp, XFS_FSB_TO_AGNO(mp, fsb),
> +	trace_xrep_init_btblock(mp, XFS_FSB_TO_AGNO(mp, fsb),
>  			XFS_FSB_TO_AGBNO(mp, fsb), btnum);
>  
>  	ASSERT(XFS_FSB_TO_AGNO(mp, fsb) == sc->sa.agno);
> @@ -384,19 +384,19 @@ xfs_repair_init_btblock(
>  
>  /* Collect a dead btree extent for later disposal. */
>  int
> -xfs_repair_collect_btree_extent(
> +xrep_collect_btree_extent(
>  	struct xfs_scrub_context	*sc,
> -	struct xfs_repair_extent_list	*exlist,
> +	struct xrep_extent_list		*exlist,
>  	xfs_fsblock_t			fsbno,
>  	xfs_extlen_t			len)
>  {
> -	struct xfs_repair_extent	*rex;
> +	struct xrep_extent		*rex;
>  
> -	trace_xfs_repair_collect_btree_extent(sc->mp,
> +	trace_xrep_collect_btree_extent(sc->mp,
>  			XFS_FSB_TO_AGNO(sc->mp, fsbno),
>  			XFS_FSB_TO_AGBNO(sc->mp, fsbno), len);
>  
> -	rex = kmem_alloc(sizeof(struct xfs_repair_extent), KM_MAYFAIL);
> +	rex = kmem_alloc(sizeof(struct xrep_extent), KM_MAYFAIL);
>  	if (!rex)
>  		return -ENOMEM;
>  
> @@ -414,14 +414,14 @@ xfs_repair_collect_btree_extent(
>   * Therefore, free all the memory associated with the list so we can die.
>   */
>  void
> -xfs_repair_cancel_btree_extents(
> +xrep_cancel_btree_extents(
>  	struct xfs_scrub_context	*sc,
> -	struct xfs_repair_extent_list	*exlist)
> +	struct xrep_extent_list		*exlist)
>  {
> -	struct xfs_repair_extent	*rex;
> -	struct xfs_repair_extent	*n;
> +	struct xrep_extent		*rex;
> +	struct xrep_extent		*n;
>  
> -	for_each_xfs_repair_extent_safe(rex, n, exlist) {
> +	for_each_xrep_extent_safe(rex, n, exlist) {
>  		list_del(&rex->list);
>  		kmem_free(rex);
>  	}
> @@ -429,16 +429,16 @@ xfs_repair_cancel_btree_extents(
>  
>  /* Compare two btree extents. */
>  static int
> -xfs_repair_btree_extent_cmp(
> +xrep_btree_extent_cmp(
>  	void				*priv,
>  	struct list_head		*a,
>  	struct list_head		*b)
>  {
> -	struct xfs_repair_extent	*ap;
> -	struct xfs_repair_extent	*bp;
> +	struct xrep_extent		*ap;
> +	struct xrep_extent		*bp;
>  
> -	ap = container_of(a, struct xfs_repair_extent, list);
> -	bp = container_of(b, struct xfs_repair_extent, list);
> +	ap = container_of(a, struct xrep_extent, list);
> +	bp = container_of(b, struct xrep_extent, list);
>  
>  	if (ap->fsbno > bp->fsbno)
>  		return 1;
> @@ -462,15 +462,15 @@ xfs_repair_btree_extent_cmp(
>  #define LEFT_ALIGNED	(1 << 0)
>  #define RIGHT_ALIGNED	(1 << 1)
>  int
> -xfs_repair_subtract_extents(
> +xrep_subtract_extents(
>  	struct xfs_scrub_context	*sc,
> -	struct xfs_repair_extent_list	*exlist,
> -	struct xfs_repair_extent_list	*sublist)
> +	struct xrep_extent_list		*exlist,
> +	struct xrep_extent_list		*sublist)
>  {
>  	struct list_head		*lp;
> -	struct xfs_repair_extent	*ex;
> -	struct xfs_repair_extent	*newex;
> -	struct xfs_repair_extent	*subex;
> +	struct xrep_extent		*ex;
> +	struct xrep_extent		*newex;
> +	struct xrep_extent		*subex;
>  	xfs_fsblock_t			sub_fsb;
>  	xfs_extlen_t			sub_len;
>  	int				state;
> @@ -480,8 +480,8 @@ xfs_repair_subtract_extents(
>  		return 0;
>  	ASSERT(!list_empty(&sublist->list));
>  
> -	list_sort(NULL, &exlist->list, xfs_repair_btree_extent_cmp);
> -	list_sort(NULL, &sublist->list, xfs_repair_btree_extent_cmp);
> +	list_sort(NULL, &exlist->list, xrep_btree_extent_cmp);
> +	list_sort(NULL, &sublist->list, xrep_btree_extent_cmp);
>  
>  	/*
>  	 * Now that we've sorted both lists, we iterate exlist once, rolling
> @@ -491,11 +491,11 @@ xfs_repair_subtract_extents(
>  	 * list traversal is similar to merge sort, but we're deleting
>  	 * instead.  In this manner we avoid O(n^2) operations.
>  	 */
> -	subex = list_first_entry(&sublist->list, struct xfs_repair_extent,
> +	subex = list_first_entry(&sublist->list, struct xrep_extent,
>  			list);
>  	lp = exlist->list.next;
>  	while (lp != &exlist->list) {
> -		ex = list_entry(lp, struct xfs_repair_extent, list);
> +		ex = list_entry(lp, struct xrep_extent, list);
>  
>  		/*
>  		 * Advance subex and/or ex until we find a pair that
> @@ -548,7 +548,7 @@ xfs_repair_subtract_extents(
>  			 * Deleting from the middle: add the new right extent
>  			 * and then shrink the left extent.
>  			 */
> -			newex = kmem_alloc(sizeof(struct xfs_repair_extent),
> +			newex = kmem_alloc(sizeof(struct xrep_extent),
>  					KM_MAYFAIL);
>  			if (!newex) {
>  				error = -ENOMEM;
> @@ -619,12 +619,12 @@ xfs_repair_subtract_extents(
>   * is not intended for use with file data repairs; we have bunmapi for that.
>   */
>  int
> -xfs_repair_invalidate_blocks(
> +xrep_invalidate_blocks(
>  	struct xfs_scrub_context	*sc,
> -	struct xfs_repair_extent_list	*exlist)
> +	struct xrep_extent_list		*exlist)
>  {
> -	struct xfs_repair_extent	*rex;
> -	struct xfs_repair_extent	*n;
> +	struct xrep_extent		*rex;
> +	struct xrep_extent		*n;
>  	struct xfs_buf			*bp;
>  	xfs_fsblock_t			fsbno;
>  	xfs_agblock_t			i;
> @@ -637,7 +637,7 @@ xfs_repair_invalidate_blocks(
>  	 * because we never own those; and if we can't TRYLOCK the buffer we
>  	 * assume it's owned by someone else.
>  	 */
> -	for_each_xfs_repair_extent_safe(rex, n, exlist) {
> +	for_each_xrep_extent_safe(rex, n, exlist) {
>  		for (fsbno = rex->fsbno, i = rex->len; i > 0; fsbno++, i--) {
>  			/* Skip AG headers and post-EOFS blocks */
>  			if (!xfs_verify_fsbno(sc->mp, fsbno))
> @@ -657,7 +657,7 @@ xfs_repair_invalidate_blocks(
>  
>  /* Ensure the freelist is the correct size. */
>  int
> -xfs_repair_fix_freelist(
> +xrep_fix_freelist(
>  	struct xfs_scrub_context	*sc,
>  	bool				can_shrink)
>  {
> @@ -677,7 +677,7 @@ xfs_repair_fix_freelist(
>   * Put a block back on the AGFL.
>   */
>  STATIC int
> -xfs_repair_put_freelist(
> +xrep_put_freelist(
>  	struct xfs_scrub_context	*sc,
>  	xfs_agblock_t			agbno)
>  {
> @@ -685,7 +685,7 @@ xfs_repair_put_freelist(
>  	int				error;
>  
>  	/* Make sure there's space on the freelist. */
> -	error = xfs_repair_fix_freelist(sc, true);
> +	error = xrep_fix_freelist(sc, true);
>  	if (error)
>  		return error;
>  
> @@ -713,7 +713,7 @@ xfs_repair_put_freelist(
>  
>  /* Dispose of a single metadata block. */
>  STATIC int
> -xfs_repair_dispose_btree_block(
> +xrep_dispose_btree_block(
>  	struct xfs_scrub_context	*sc,
>  	xfs_fsblock_t			fsbno,
>  	struct xfs_owner_info		*oinfo,
> @@ -767,7 +767,7 @@ xfs_repair_dispose_btree_block(
>  	if (has_other_rmap)
>  		error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1, oinfo);
>  	else if (resv == XFS_AG_RESV_AGFL)
> -		error = xfs_repair_put_freelist(sc, agbno);
> +		error = xrep_put_freelist(sc, agbno);
>  	else
>  		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
>  	if (agf_bp != sc->sa.agf_bp)
> @@ -777,7 +777,7 @@ xfs_repair_dispose_btree_block(
>  
>  	if (sc->ip)
>  		return xfs_trans_roll_inode(&sc->tp, sc->ip);
> -	return xfs_repair_roll_ag_trans(sc);
> +	return xrep_roll_ag_trans(sc);
>  
>  out_free:
>  	if (agf_bp != sc->sa.agf_bp)
> @@ -787,29 +787,29 @@ xfs_repair_dispose_btree_block(
>  
>  /* Dispose of btree blocks from an old per-AG btree. */
>  int
> -xfs_repair_reap_btree_extents(
> +xrep_reap_btree_extents(
>  	struct xfs_scrub_context	*sc,
> -	struct xfs_repair_extent_list	*exlist,
> +	struct xrep_extent_list		*exlist,
>  	struct xfs_owner_info		*oinfo,
>  	enum xfs_ag_resv_type		type)
>  {
> -	struct xfs_repair_extent	*rex;
> -	struct xfs_repair_extent	*n;
> +	struct xrep_extent		*rex;
> +	struct xrep_extent		*n;
>  	int				error = 0;
>  
>  	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
>  
>  	/* Dispose of every block from the old btree. */
> -	for_each_xfs_repair_extent_safe(rex, n, exlist) {
> +	for_each_xrep_extent_safe(rex, n, exlist) {
>  		ASSERT(sc->ip != NULL ||
>  		       XFS_FSB_TO_AGNO(sc->mp, rex->fsbno) == sc->sa.agno);
>  
> -		trace_xfs_repair_dispose_btree_extent(sc->mp,
> +		trace_xrep_dispose_btree_extent(sc->mp,
>  				XFS_FSB_TO_AGNO(sc->mp, rex->fsbno),
>  				XFS_FSB_TO_AGBNO(sc->mp, rex->fsbno), rex->len);
>  
>  		for (; rex->len > 0; rex->len--, rex->fsbno++) {
> -			error = xfs_repair_dispose_btree_block(sc, rex->fsbno,
> +			error = xrep_dispose_btree_block(sc, rex->fsbno,
>  					oinfo, type);
>  			if (error)
>  				goto out;
> @@ -819,7 +819,7 @@ xfs_repair_reap_btree_extents(
>  	}
>  
>  out:
> -	xfs_repair_cancel_btree_extents(sc, exlist);
> +	xrep_cancel_btree_extents(sc, exlist);
>  	return error;
>  }
>  
> @@ -831,12 +831,12 @@ xfs_repair_reap_btree_extents(
>   * btree roots.  This is not guaranteed to work if the AG is heavily damaged
>   * or the rmap data are corrupt.
>   *
> - * Callers of xfs_repair_find_ag_btree_roots must lock the AGF and AGFL
> + * Callers of xrep_find_ag_btree_roots must lock the AGF and AGFL
>   * buffers if the AGF is being rebuilt; or the AGF and AGI buffers if the
>   * AGI is being rebuilt.  It must maintain these locks until it's safe for
>   * other threads to change the btrees' shapes.  The caller provides
>   * information about the btrees to look for by passing in an array of
> - * xfs_repair_find_ag_btree with the (rmap owner, buf_ops, magic) fields set.
> + * xrep_find_ag_btree with the (rmap owner, buf_ops, magic) fields set.
>   * The (root, height) fields will be set on return if anything is found.  The
>   * last element of the array should have a NULL buf_ops to mark the end of the
>   * array.
> @@ -850,16 +850,16 @@ xfs_repair_reap_btree_extents(
>   * should be the roots.
>   */
>  
> -struct xfs_repair_findroot {
> +struct xrep_findroot {
>  	struct xfs_scrub_context	*sc;
>  	struct xfs_buf			*agfl_bp;
>  	struct xfs_agf			*agf;
> -	struct xfs_repair_find_ag_btree	*btree_info;
> +	struct xrep_find_ag_btree	*btree_info;
>  };
>  
>  /* See if our block is in the AGFL. */
>  STATIC int
> -xfs_repair_findroot_agfl_walk(
> +xrep_findroot_agfl_walk(
>  	struct xfs_mount		*mp,
>  	xfs_agblock_t			bno,
>  	void				*priv)
> @@ -871,9 +871,9 @@ xfs_repair_findroot_agfl_walk(
>  
>  /* Does this block match the btree information passed in? */
>  STATIC int
> -xfs_repair_findroot_block(
> -	struct xfs_repair_findroot	*ri,
> -	struct xfs_repair_find_ag_btree	*fab,
> +xrep_findroot_block(
> +	struct xrep_findroot		*ri,
> +	struct xrep_find_ag_btree	*fab,
>  	uint64_t			owner,
>  	xfs_agblock_t			agbno,
>  	bool				*found_it)
> @@ -894,7 +894,7 @@ xfs_repair_findroot_block(
>  	 */
>  	if (owner == XFS_RMAP_OWN_AG) {
>  		error = xfs_agfl_walk(mp, ri->agf, ri->agfl_bp,
> -				xfs_repair_findroot_agfl_walk, &agbno);
> +				xrep_findroot_agfl_walk, &agbno);
>  		if (error == XFS_BTREE_QUERY_RANGE_ABORT)
>  			return 0;
>  		if (error)
> @@ -932,7 +932,7 @@ xfs_repair_findroot_block(
>  	fab->height = xfs_btree_get_level(btblock) + 1;
>  	*found_it = true;
>  
> -	trace_xfs_repair_findroot_block(mp, ri->sc->sa.agno, agbno,
> +	trace_xrep_findroot_block(mp, ri->sc->sa.agno, agbno,
>  			be32_to_cpu(btblock->bb_magic), fab->height - 1);
>  out:
>  	xfs_trans_brelse(ri->sc->tp, bp);
> @@ -944,13 +944,13 @@ xfs_repair_findroot_block(
>   * looking for?
>   */
>  STATIC int
> -xfs_repair_findroot_rmap(
> +xrep_findroot_rmap(
>  	struct xfs_btree_cur		*cur,
>  	struct xfs_rmap_irec		*rec,
>  	void				*priv)
>  {
> -	struct xfs_repair_findroot	*ri = priv;
> -	struct xfs_repair_find_ag_btree	*fab;
> +	struct xrep_findroot		*ri = priv;
> +	struct xrep_find_ag_btree	*fab;
>  	xfs_agblock_t			b;
>  	bool				found_it;
>  	int				error = 0;
> @@ -965,7 +965,7 @@ xfs_repair_findroot_rmap(
>  		for (fab = ri->btree_info; fab->buf_ops; fab++) {
>  			if (rec->rm_owner != fab->rmap_owner)
>  				continue;
> -			error = xfs_repair_findroot_block(ri, fab,
> +			error = xrep_findroot_block(ri, fab,
>  					rec->rm_owner, rec->rm_startblock + b,
>  					&found_it);
>  			if (error)
> @@ -980,15 +980,15 @@ xfs_repair_findroot_rmap(
>  
>  /* Find the roots of the per-AG btrees described in btree_info. */
>  int
> -xfs_repair_find_ag_btree_roots(
> +xrep_find_ag_btree_roots(
>  	struct xfs_scrub_context	*sc,
>  	struct xfs_buf			*agf_bp,
> -	struct xfs_repair_find_ag_btree	*btree_info,
> +	struct xrep_find_ag_btree	*btree_info,
>  	struct xfs_buf			*agfl_bp)
>  {
>  	struct xfs_mount		*mp = sc->mp;
> -	struct xfs_repair_findroot	ri;
> -	struct xfs_repair_find_ag_btree	*fab;
> +	struct xrep_findroot		ri;
> +	struct xrep_find_ag_btree	*fab;
>  	struct xfs_btree_cur		*cur;
>  	int				error;
>  
> @@ -1007,7 +1007,7 @@ xfs_repair_find_ag_btree_roots(
>  	}
>  
>  	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.agno);
> -	error = xfs_rmap_query_all(cur, xfs_repair_findroot_rmap, &ri);
> +	error = xfs_rmap_query_all(cur, xrep_findroot_rmap, &ri);
>  	xfs_btree_del_cursor(cur, error);
>  
>  	return error;
> @@ -1015,7 +1015,7 @@ xfs_repair_find_ag_btree_roots(
>  
>  /* Force a quotacheck the next time we mount. */
>  void
> -xfs_repair_force_quotacheck(
> +xrep_force_quotacheck(
>  	struct xfs_scrub_context	*sc,
>  	uint				dqtype)
>  {
> @@ -1043,7 +1043,7 @@ xfs_repair_force_quotacheck(
>   * repair corruptions in the quota metadata.
>   */
>  int
> -xfs_repair_ino_dqattach(
> +xrep_ino_dqattach(
>  	struct xfs_scrub_context	*sc)
>  {
>  	int				error;
> @@ -1057,11 +1057,11 @@ xfs_repair_ino_dqattach(
>  "inode %llu repair encountered quota error %d, quotacheck forced.",
>  				(unsigned long long)sc->ip->i_ino, error);
>  		if (XFS_IS_UQUOTA_ON(sc->mp) && !sc->ip->i_udquot)
> -			xfs_repair_force_quotacheck(sc, XFS_DQ_USER);
> +			xrep_force_quotacheck(sc, XFS_DQ_USER);
>  		if (XFS_IS_GQUOTA_ON(sc->mp) && !sc->ip->i_gdquot)
> -			xfs_repair_force_quotacheck(sc, XFS_DQ_GROUP);
> +			xrep_force_quotacheck(sc, XFS_DQ_GROUP);
>  		if (XFS_IS_PQUOTA_ON(sc->mp) && !sc->ip->i_pdquot)
> -			xfs_repair_force_quotacheck(sc, XFS_DQ_PROJ);
> +			xrep_force_quotacheck(sc, XFS_DQ_PROJ);
>  		/* fall through */
>  	case -ESRCH:
>  		error = 0;
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index ef47826b6725..60d81294797b 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -6,7 +6,7 @@
>  #ifndef __XFS_SCRUB_REPAIR_H__
>  #define __XFS_SCRUB_REPAIR_H__
>  
> -static inline int xfs_repair_notsupported(struct xfs_scrub_context *sc)
> +static inline int xrep_notsupported(struct xfs_scrub_context *sc)
>  {
>  	return -EOPNOTSUPP;
>  }
> @@ -15,55 +15,55 @@ static inline int xfs_repair_notsupported(struct xfs_scrub_context *sc)
>  
>  /* Repair helpers */
>  
> -int xfs_repair_attempt(struct xfs_inode *ip, struct xfs_scrub_context *sc,
> +int xrep_attempt(struct xfs_inode *ip, struct xfs_scrub_context *sc,
>  		bool *fixed);
> -void xfs_repair_failure(struct xfs_mount *mp);
> -int xfs_repair_roll_ag_trans(struct xfs_scrub_context *sc);
> -bool xfs_repair_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
> +void xrep_failure(struct xfs_mount *mp);
> +int xrep_roll_ag_trans(struct xfs_scrub_context *sc);
> +bool xrep_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
>  		enum xfs_ag_resv_type type);
> -xfs_extlen_t xfs_repair_calc_ag_resblks(struct xfs_scrub_context *sc);
> -int xfs_repair_alloc_ag_block(struct xfs_scrub_context *sc,
> +xfs_extlen_t xrep_calc_ag_resblks(struct xfs_scrub_context *sc);
> +int xrep_alloc_ag_block(struct xfs_scrub_context *sc,
>  		struct xfs_owner_info *oinfo, xfs_fsblock_t *fsbno,
>  		enum xfs_ag_resv_type resv);
> -int xfs_repair_init_btblock(struct xfs_scrub_context *sc, xfs_fsblock_t fsb,
> +int xrep_init_btblock(struct xfs_scrub_context *sc, xfs_fsblock_t fsb,
>  		struct xfs_buf **bpp, xfs_btnum_t btnum,
>  		const struct xfs_buf_ops *ops);
>  
> -struct xfs_repair_extent {
> +struct xrep_extent {
>  	struct list_head		list;
>  	xfs_fsblock_t			fsbno;
>  	xfs_extlen_t			len;
>  };
>  
> -struct xfs_repair_extent_list {
> +struct xrep_extent_list {
>  	struct list_head		list;
>  };
>  
>  static inline void
> -xfs_repair_init_extent_list(
> -	struct xfs_repair_extent_list	*exlist)
> +xrep_init_extent_list(
> +	struct xrep_extent_list		*exlist)
>  {
>  	INIT_LIST_HEAD(&exlist->list);
>  }
>  
> -#define for_each_xfs_repair_extent_safe(rbe, n, exlist) \
> +#define for_each_xrep_extent_safe(rbe, n, exlist) \
>  	list_for_each_entry_safe((rbe), (n), &(exlist)->list, list)
> -int xfs_repair_collect_btree_extent(struct xfs_scrub_context *sc,
> -		struct xfs_repair_extent_list *btlist, xfs_fsblock_t fsbno,
> +int xrep_collect_btree_extent(struct xfs_scrub_context *sc,
> +		struct xrep_extent_list *btlist, xfs_fsblock_t fsbno,
>  		xfs_extlen_t len);
> -void xfs_repair_cancel_btree_extents(struct xfs_scrub_context *sc,
> -		struct xfs_repair_extent_list *btlist);
> -int xfs_repair_subtract_extents(struct xfs_scrub_context *sc,
> -		struct xfs_repair_extent_list *exlist,
> -		struct xfs_repair_extent_list *sublist);
> -int xfs_repair_fix_freelist(struct xfs_scrub_context *sc, bool can_shrink);
> -int xfs_repair_invalidate_blocks(struct xfs_scrub_context *sc,
> -		struct xfs_repair_extent_list *btlist);
> -int xfs_repair_reap_btree_extents(struct xfs_scrub_context *sc,
> -		struct xfs_repair_extent_list *exlist,
> +void xrep_cancel_btree_extents(struct xfs_scrub_context *sc,
> +		struct xrep_extent_list *btlist);
> +int xrep_subtract_extents(struct xfs_scrub_context *sc,
> +		struct xrep_extent_list *exlist,
> +		struct xrep_extent_list *sublist);
> +int xrep_fix_freelist(struct xfs_scrub_context *sc, bool can_shrink);
> +int xrep_invalidate_blocks(struct xfs_scrub_context *sc,
> +		struct xrep_extent_list *btlist);
> +int xrep_reap_btree_extents(struct xfs_scrub_context *sc,
> +		struct xrep_extent_list *exlist,
>  		struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
>  
> -struct xfs_repair_find_ag_btree {
> +struct xrep_find_ag_btree {
>  	/* in: rmap owner of the btree we're looking for */
>  	uint64_t			rmap_owner;
>  
> @@ -78,21 +78,21 @@ struct xfs_repair_find_ag_btree {
>  	unsigned int			height;
>  };
>  
> -int xfs_repair_find_ag_btree_roots(struct xfs_scrub_context *sc,
> +int xrep_find_ag_btree_roots(struct xfs_scrub_context *sc,
>  		struct xfs_buf *agf_bp,
> -		struct xfs_repair_find_ag_btree *btree_info,
> +		struct xrep_find_ag_btree *btree_info,
>  		struct xfs_buf *agfl_bp);
> -void xfs_repair_force_quotacheck(struct xfs_scrub_context *sc, uint dqtype);
> -int xfs_repair_ino_dqattach(struct xfs_scrub_context *sc);
> +void xrep_force_quotacheck(struct xfs_scrub_context *sc, uint dqtype);
> +int xrep_ino_dqattach(struct xfs_scrub_context *sc);
>  
>  /* Metadata repairers */
>  
> -int xfs_repair_probe(struct xfs_scrub_context *sc);
> -int xfs_repair_superblock(struct xfs_scrub_context *sc);
> +int xrep_probe(struct xfs_scrub_context *sc);
> +int xrep_superblock(struct xfs_scrub_context *sc);
>  
>  #else
>  
> -static inline int xfs_repair_attempt(
> +static inline int xrep_attempt(
>  	struct xfs_inode		*ip,
>  	struct xfs_scrub_context	*sc,
>  	bool				*fixed)
> @@ -100,18 +100,18 @@ static inline int xfs_repair_attempt(
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline void xfs_repair_failure(struct xfs_mount *mp) {}
> +static inline void xrep_failure(struct xfs_mount *mp) {}
>  
>  static inline xfs_extlen_t
> -xfs_repair_calc_ag_resblks(
> +xrep_calc_ag_resblks(
>  	struct xfs_scrub_context	*sc)
>  {
>  	ASSERT(!(sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR));
>  	return 0;
>  }
>  
> -#define xfs_repair_probe		xfs_repair_notsupported
> -#define xfs_repair_superblock		xfs_repair_notsupported
> +#define xrep_probe			xrep_notsupported
> +#define xrep_superblock			xrep_notsupported
>  
>  #endif /* CONFIG_XFS_ONLINE_REPAIR */
>  
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index ead97ab91a3c..a6efede6e430 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -202,150 +202,150 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
>  		.type	= ST_NONE,
>  		.setup	= xchk_setup_fs,
>  		.scrub	= xchk_probe,
> -		.repair = xfs_repair_probe,
> +		.repair = xrep_probe,
>  	},
>  	[XFS_SCRUB_TYPE_SB] = {		/* superblock */
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_fs,
>  		.scrub	= xchk_superblock,
> -		.repair	= xfs_repair_superblock,
> +		.repair	= xrep_superblock,
>  	},
>  	[XFS_SCRUB_TYPE_AGF] = {	/* agf */
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_fs,
>  		.scrub	= xchk_agf,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_AGFL]= {	/* agfl */
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_fs,
>  		.scrub	= xchk_agfl,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_AGI] = {	/* agi */
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_fs,
>  		.scrub	= xchk_agi,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_BNOBT] = {	/* bnobt */
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_ag_allocbt,
>  		.scrub	= xchk_bnobt,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_CNTBT] = {	/* cntbt */
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_ag_allocbt,
>  		.scrub	= xchk_cntbt,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_INOBT] = {	/* inobt */
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_ag_iallocbt,
>  		.scrub	= xchk_inobt,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_FINOBT] = {	/* finobt */
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_ag_iallocbt,
>  		.scrub	= xchk_finobt,
>  		.has	= xfs_sb_version_hasfinobt,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_ag_rmapbt,
>  		.scrub	= xchk_rmapbt,
>  		.has	= xfs_sb_version_hasrmapbt,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_REFCNTBT] = {	/* refcountbt */
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_ag_refcountbt,
>  		.scrub	= xchk_refcountbt,
>  		.has	= xfs_sb_version_hasreflink,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_INODE] = {	/* inode record */
>  		.type	= ST_INODE,
>  		.setup	= xchk_setup_inode,
>  		.scrub	= xchk_inode,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_BMBTD] = {	/* inode data fork */
>  		.type	= ST_INODE,
>  		.setup	= xchk_setup_inode_bmap,
>  		.scrub	= xchk_bmap_data,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_BMBTA] = {	/* inode attr fork */
>  		.type	= ST_INODE,
>  		.setup	= xchk_setup_inode_bmap,
>  		.scrub	= xchk_bmap_attr,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_BMBTC] = {	/* inode CoW fork */
>  		.type	= ST_INODE,
>  		.setup	= xchk_setup_inode_bmap,
>  		.scrub	= xchk_bmap_cow,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_DIR] = {	/* directory */
>  		.type	= ST_INODE,
>  		.setup	= xchk_setup_directory,
>  		.scrub	= xchk_directory,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_XATTR] = {	/* extended attributes */
>  		.type	= ST_INODE,
>  		.setup	= xchk_setup_xattr,
>  		.scrub	= xchk_xattr,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_SYMLINK] = {	/* symbolic link */
>  		.type	= ST_INODE,
>  		.setup	= xchk_setup_symlink,
>  		.scrub	= xchk_symlink,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_PARENT] = {	/* parent pointers */
>  		.type	= ST_INODE,
>  		.setup	= xchk_setup_parent,
>  		.scrub	= xchk_parent,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_RTBITMAP] = {	/* realtime bitmap */
>  		.type	= ST_FS,
>  		.setup	= xchk_setup_rt,
>  		.scrub	= xchk_rtbitmap,
>  		.has	= xfs_sb_version_hasrealtime,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
>  		.type	= ST_FS,
>  		.setup	= xchk_setup_rt,
>  		.scrub	= xchk_rtsummary,
>  		.has	= xfs_sb_version_hasrealtime,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */
>  		.type	= ST_FS,
>  		.setup	= xchk_setup_quota,
>  		.scrub	= xchk_quota,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_GQUOTA] = {	/* group quota */
>  		.type	= ST_FS,
>  		.setup	= xchk_setup_quota,
>  		.scrub	= xchk_quota,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_PQUOTA] = {	/* project quota */
>  		.type	= ST_FS,
>  		.setup	= xchk_setup_quota,
>  		.scrub	= xchk_quota,
> -		.repair	= xfs_repair_notsupported,
> +		.repair	= xrep_notsupported,
>  	},
>  };
>  
> @@ -457,7 +457,7 @@ static inline void xchk_postmortem(struct xfs_scrub_context *sc)
>  	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
>  	    (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
>  				 XFS_SCRUB_OFLAG_XCORRUPT)))
> -		xfs_repair_failure(sc->mp);
> +		xrep_failure(sc->mp);
>  }
>  #else
>  static inline void xchk_postmortem(struct xfs_scrub_context *sc)
> @@ -555,13 +555,13 @@ xfs_scrub_metadata(
>  		 * If it's broken, userspace wants us to fix it, and we haven't
>  		 * already tried to fix it, then attempt a repair.
>  		 */
> -		error = xfs_repair_attempt(ip, &sc, &already_fixed);
> +		error = xrep_attempt(ip, &sc, &already_fixed);
>  		if (error == -EAGAIN) {
>  			if (sc.try_harder)
>  				try_harder = true;
>  			error = xchk_teardown(&sc, ip, 0);
>  			if (error) {
> -				xfs_repair_failure(mp);
> +				xrep_failure(mp);
>  				goto out;
>  			}
>  			goto retry_op;
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index 11967d3942ac..96f3edda3e91 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -55,8 +55,8 @@ DEFINE_EVENT(xchk_class, name, \
>  DEFINE_SCRUB_EVENT(xchk_start);
>  DEFINE_SCRUB_EVENT(xchk_done);
>  DEFINE_SCRUB_EVENT(xchk_deadlock_retry);
> -DEFINE_SCRUB_EVENT(xfs_repair_attempt);
> -DEFINE_SCRUB_EVENT(xfs_repair_done);
> +DEFINE_SCRUB_EVENT(xrep_attempt);
> +DEFINE_SCRUB_EVENT(xrep_done);
>  
>  TRACE_EVENT(xchk_op_error,
>  	TP_PROTO(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
> @@ -483,7 +483,7 @@ TRACE_EVENT(xchk_xref_error,
>  /* repair tracepoints */
>  #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
>  
> -DECLARE_EVENT_CLASS(xfs_repair_extent_class,
> +DECLARE_EVENT_CLASS(xrep_extent_class,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
>  		 xfs_agblock_t agbno, xfs_extlen_t len),
>  	TP_ARGS(mp, agno, agbno, len),
> @@ -506,15 +506,15 @@ DECLARE_EVENT_CLASS(xfs_repair_extent_class,
>  		  __entry->len)
>  );
>  #define DEFINE_REPAIR_EXTENT_EVENT(name) \
> -DEFINE_EVENT(xfs_repair_extent_class, name, \
> +DEFINE_EVENT(xrep_extent_class, name, \
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
>  		 xfs_agblock_t agbno, xfs_extlen_t len), \
>  	TP_ARGS(mp, agno, agbno, len))
> -DEFINE_REPAIR_EXTENT_EVENT(xfs_repair_dispose_btree_extent);
> -DEFINE_REPAIR_EXTENT_EVENT(xfs_repair_collect_btree_extent);
> -DEFINE_REPAIR_EXTENT_EVENT(xfs_repair_agfl_insert);
> +DEFINE_REPAIR_EXTENT_EVENT(xrep_dispose_btree_extent);
> +DEFINE_REPAIR_EXTENT_EVENT(xrep_collect_btree_extent);
> +DEFINE_REPAIR_EXTENT_EVENT(xrep_agfl_insert);
>  
> -DECLARE_EVENT_CLASS(xfs_repair_rmap_class,
> +DECLARE_EVENT_CLASS(xrep_rmap_class,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
>  		 xfs_agblock_t agbno, xfs_extlen_t len,
>  		 uint64_t owner, uint64_t offset, unsigned int flags),
> @@ -547,17 +547,17 @@ DECLARE_EVENT_CLASS(xfs_repair_rmap_class,
>  		  __entry->flags)
>  );
>  #define DEFINE_REPAIR_RMAP_EVENT(name) \
> -DEFINE_EVENT(xfs_repair_rmap_class, name, \
> +DEFINE_EVENT(xrep_rmap_class, name, \
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
>  		 xfs_agblock_t agbno, xfs_extlen_t len, \
>  		 uint64_t owner, uint64_t offset, unsigned int flags), \
>  	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
> -DEFINE_REPAIR_RMAP_EVENT(xfs_repair_alloc_extent_fn);
> -DEFINE_REPAIR_RMAP_EVENT(xfs_repair_ialloc_extent_fn);
> -DEFINE_REPAIR_RMAP_EVENT(xfs_repair_rmap_extent_fn);
> -DEFINE_REPAIR_RMAP_EVENT(xfs_repair_bmap_extent_fn);
> +DEFINE_REPAIR_RMAP_EVENT(xrep_alloc_extent_fn);
> +DEFINE_REPAIR_RMAP_EVENT(xrep_ialloc_extent_fn);
> +DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
> +DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_extent_fn);
>  
> -TRACE_EVENT(xfs_repair_refcount_extent_fn,
> +TRACE_EVENT(xrep_refcount_extent_fn,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
>  		 struct xfs_refcount_irec *irec),
>  	TP_ARGS(mp, agno, irec),
> @@ -583,7 +583,7 @@ TRACE_EVENT(xfs_repair_refcount_extent_fn,
>  		  __entry->refcount)
>  )
>  
> -TRACE_EVENT(xfs_repair_init_btblock,
> +TRACE_EVENT(xrep_init_btblock,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
>  		 xfs_btnum_t btnum),
>  	TP_ARGS(mp, agno, agbno, btnum),
> @@ -605,7 +605,7 @@ TRACE_EVENT(xfs_repair_init_btblock,
>  		  __entry->agbno,
>  		  __entry->btnum)
>  )
> -TRACE_EVENT(xfs_repair_findroot_block,
> +TRACE_EVENT(xrep_findroot_block,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
>  		 uint32_t magic, uint16_t level),
>  	TP_ARGS(mp, agno, agbno, magic, level),
> @@ -630,7 +630,7 @@ TRACE_EVENT(xfs_repair_findroot_block,
>  		  __entry->magic,
>  		  __entry->level)
>  )
> -TRACE_EVENT(xfs_repair_calc_ag_resblks,
> +TRACE_EVENT(xrep_calc_ag_resblks,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
>  		 xfs_agino_t icount, xfs_agblock_t aglen, xfs_agblock_t freelen,
>  		 xfs_agblock_t usedlen),
> @@ -659,7 +659,7 @@ TRACE_EVENT(xfs_repair_calc_ag_resblks,
>  		  __entry->freelen,
>  		  __entry->usedlen)
>  )
> -TRACE_EVENT(xfs_repair_calc_ag_resblks_btsize,
> +TRACE_EVENT(xrep_calc_ag_resblks_btsize,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
>  		 xfs_agblock_t bnobt_sz, xfs_agblock_t inobt_sz,
>  		 xfs_agblock_t rmapbt_sz, xfs_agblock_t refcbt_sz),
> @@ -688,7 +688,7 @@ TRACE_EVENT(xfs_repair_calc_ag_resblks_btsize,
>  		  __entry->rmapbt_sz,
>  		  __entry->refcbt_sz)
>  )
> -TRACE_EVENT(xfs_repair_reset_counters,
> +TRACE_EVENT(xrep_reset_counters,
>  	TP_PROTO(struct xfs_mount *mp),
>  	TP_ARGS(mp),
>  	TP_STRUCT__entry(
> @@ -701,7 +701,7 @@ TRACE_EVENT(xfs_repair_reset_counters,
>  		  MAJOR(__entry->dev), MINOR(__entry->dev))
>  )
>  
> -TRACE_EVENT(xfs_repair_ialloc_insert,
> +TRACE_EVENT(xrep_ialloc_insert,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
>  		 xfs_agino_t startino, uint16_t holemask, uint8_t count,
>  		 uint8_t freecount, uint64_t freemask),
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
