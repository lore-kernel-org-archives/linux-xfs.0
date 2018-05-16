Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47544 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbeEPSCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 14:02:44 -0400
Subject: Re: [PATCH 04/22] xfs: add helpers to dispose of old btree blocks
 after a repair
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642364418.1556.17533271717583168316.stgit@magnolia>
 <20180516083232.GS23861@dastard>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <6b396c78-a921-e1ed-1358-926fcb07ba8c@oracle.com>
Date: Wed, 16 May 2018 11:02:39 -0700
MIME-Version: 1.0
In-Reply-To: <20180516083232.GS23861@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Alrighty, with Daves concerns addressed:
Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 05/16/2018 01:32 AM, Dave Chinner wrote:
> On Tue, May 15, 2018 at 03:34:04PM -0700, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Now that we've plumbed in the ability to construct a list of dead btree
>> blocks following a repair, add more helpers to dispose of them.  This is
>> done by examining the rmapbt -- if the btree was the only owner we can
>> free the block, otherwise it's crosslinked and we can only remove the
>> rmapbt record.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>   fs/xfs/scrub/repair.c |  200 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/scrub/repair.h |    3 +
>>   2 files changed, 202 insertions(+), 1 deletion(-)
>>
>>
>> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
>> index 8e8ecddd7537..d820e01d1146 100644
>> --- a/fs/xfs/scrub/repair.c
>> +++ b/fs/xfs/scrub/repair.c
>> @@ -362,6 +362,173 @@ xfs_repair_init_btblock(
>>   	return 0;
>>   }
>>   
>> +/* Ensure the freelist is the correct size. */
>> +int
>> +xfs_repair_fix_freelist(
>> +	struct xfs_scrub_context	*sc,
>> +	bool				can_shrink)
>> +{
>> +	struct xfs_alloc_arg		args = {0};
>> +	int				error;
>> +
>> +	args.mp = sc->mp;
>> +	args.tp = sc->tp;
>> +	args.agno = sc->sa.agno;
>> +	args.alignment = 1;
>> +	args.pag = xfs_perag_get(args.mp, sc->sa.agno);
>> +
>> +	error = xfs_alloc_fix_freelist(&args,
>> +			can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
>> +	xfs_perag_put(args.pag);
> with all these pag lookups, I'm starting to wonder if you should
> just add a lookup and store the pag in the scrub context? That'd
> save a lot of lookups - the pag structures never go away and i never
> really intended them to be used like this in single, very short use
> contexts. Grab once per operation, hold the reference across the
> entire operation context, then release it....
>
>> +	return error;
>> +}
>> +
>> +/*
>> + * Put a block back on the AGFL.
>> + */
>> +STATIC int
>> +xfs_repair_put_freelist(
>> +	struct xfs_scrub_context	*sc,
>> +	xfs_agblock_t			agbno)
>> +{
>> +	struct xfs_owner_info		oinfo;
>> +	struct xfs_perag		*pag;
>> +	int				error;
>> +
>> +	/* Make sure there's space on the freelist. */
>> +	error = xfs_repair_fix_freelist(sc, true);
>> +	if (error)
>> +		return error;
>> +	pag = xfs_perag_get(sc->mp, sc->sa.agno);
> Because this is how it quickly gets it gets to silly numbers of
> lookups. That's two now in this function.
>
>> +	if (pag->pagf_flcount == 0) {
>> +		xfs_perag_put(pag);
>> +		return -EFSCORRUPTED;
> Why is having an empty freelist a problem here? It's an AG thatis
> completely out of space, but it isn't corruption? And I don't see
> why an empty freelist prevents us from adding a backs back onto the
> AGFL?
>
>> +	}
>> +	xfs_perag_put(pag);
>> +
>> +	/*
>> +	 * Since we're "freeing" a lost block onto the AGFL, we have to
>> +	 * create an rmap for the block prior to merging it or else other
>> +	 * parts will break.
>> +	 */
>> +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
>> +	error = xfs_rmap_alloc(sc->tp, sc->sa.agf_bp, sc->sa.agno, agbno, 1,
>> +			&oinfo);
>> +	if (error)
>> +		return error;
>> +
>> +	/* Put the block on the AGFL. */
>> +	error = xfs_alloc_put_freelist(sc->tp, sc->sa.agf_bp, sc->sa.agfl_bp,
>> +			agbno, 0);
> There's another pag lookup in here.
>
>> +	if (error)
>> +		return error;
>> +	xfs_extent_busy_insert(sc->tp, sc->sa.agno, agbno, 1,
>> +			XFS_EXTENT_BUSY_SKIP_DISCARD);
> And another in here, so 4 perag lookups for the same structure in
> one simple operation. The code here in the function is fine, but I
> really think we need to rethink how we use the perag in our
> allocation code...
>
>> +
>> +	return 0;
>> +}
>> +
>> +/* Dispose of a single metadata block. */
>> +STATIC int
>> +xfs_repair_dispose_btree_block(
>> +	struct xfs_scrub_context	*sc,
>> +	xfs_fsblock_t			fsbno,
>> +	struct xfs_owner_info		*oinfo,
>> +	enum xfs_ag_resv_type		resv)
>> +{
>> +	struct xfs_btree_cur		*cur;
>> +	struct xfs_buf			*agf_bp = NULL;
>> +	xfs_agnumber_t			agno;
>> +	xfs_agblock_t			agbno;
>> +	bool				has_other_rmap;
>> +	int				error;
>> +
>> +	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
>> +	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
>> +
>> +	if (sc->ip) {
>> +		/* Repairing per-inode metadata, read in the AGF. */
> This would be better with a comment above saying:
>
> 	/*
> 	 * If we are repairing per-inode metadata, we need to read
> 	 * in the AGF buffer. Otherwise we can re-use the existing
> 	 * AGF buffer we set up for repairing the per-AG btrees.
> 	 */
>> +		error = xfs_alloc_read_agf(sc->mp, sc->tp, agno, 0, &agf_bp);
>> +		if (error)
>> +			return error;
>> +		if (!agf_bp)
>> +			return -ENOMEM;
>> +	} else {
>> +		/* Repairing per-AG btree, reuse existing AGF buffer. */
>> +		agf_bp = sc->sa.agf_bp;
>> +	}
>> +	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf_bp, agno);
>> +
>> +	/* Can we find any other rmappings? */
>> +	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
>> +	if (error)
>> +		goto out_cur;
>> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>> +
>> +	/*
>> +	 * If there are other rmappings, this block is cross linked and must
>> +	 * not be freed.  Remove the reverse mapping and move on.  Otherwise,
> Why do we just remove the reverse mapping if the block cannot be
> freed? I have my suspicions that this is removing cross-links one by
> one until there's only one reference left to the extent, but then I
> ask "how do we know which one is the correct mapping"?
>
> i.e. this comment raised more questions about the algorithm for
> dealing with cross-linked blocks - which doesn't appear to be
> explained anywhere - than it answers....
>
>> +	 * we were the only owner of the block, so free the extent, which will
>> +	 * also remove the rmap.
>> +	 */
>> +	if (has_other_rmap)
>> +		error = xfs_rmap_free(sc->tp, agf_bp, agno, agbno, 1, oinfo);
>> +	else if (resv == XFS_AG_RESV_AGFL)
>> +		error = xfs_repair_put_freelist(sc, agbno);
>> +	else
>> +		error = xfs_free_extent(sc->tp, fsbno, 1, oinfo, resv);
>> +	if (agf_bp != sc->sa.agf_bp)
>> +		xfs_trans_brelse(sc->tp, agf_bp);
>> +	if (error)
>> +		return error;
>> +
>> +	if (sc->ip)
>> +		return xfs_trans_roll_inode(&sc->tp, sc->ip);
>> +	return xfs_repair_roll_ag_trans(sc);
>> +
>> +out_cur:
>> +	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
>> +	if (agf_bp != sc->sa.agf_bp)
>> +		xfs_trans_brelse(sc->tp, agf_bp);
>> +	return error;
>> +}
>> +
>> +/*
>> + * Dispose of a given metadata extent.
>> + *
>> + * If the rmapbt says the extent has multiple owners, we simply remove the
>> + * rmap associated with this owner hoping that we'll eventually disentangle
>> + * the crosslinked metadata.  Otherwise, there's one owner, so call the
>> + * regular free code to remove the rmap and free the extent.  Any existing
>> + * buffers for the blocks in the extent must have been _binval'd previously.
> Ok, so there's a little more detail about cross-linked files. Seems
> my suspicions of "remove and hope" were close to the mark :P
>
> Perhaps we need a document that describes the various algorithms we
> use for resolving these problems, so they can be discussed and
> improved without having to troll through the code to understand?
>
>> + */
>> +STATIC int
>> +xfs_repair_dispose_btree_extent(
>> +	struct xfs_scrub_context	*sc,
>> +	xfs_fsblock_t			fsbno,
>> +	xfs_extlen_t			len,
>> +	struct xfs_owner_info		*oinfo,
>> +	enum xfs_ag_resv_type		resv)
>> +{
>> +	struct xfs_mount		*mp = sc->mp;
>> +	int				error = 0;
>> +
>> +	ASSERT(xfs_sb_version_hasrmapbt(&mp->m_sb));
>> +	ASSERT(sc->ip != NULL || XFS_FSB_TO_AGNO(mp, fsbno) == sc->sa.agno);
>> +
>> +	trace_xfs_repair_dispose_btree_extent(mp, XFS_FSB_TO_AGNO(mp, fsbno),
>> +			XFS_FSB_TO_AGBNO(mp, fsbno), len);
>> +
>> +	for (; len > 0; len--, fsbno++) {
>> +		error = xfs_repair_dispose_btree_block(sc, fsbno, oinfo, resv);
>> +		if (error)
>> +			return error;
> So why do we do this one block at a time, rather than freeing it
> as an entire extent in one go? And if there is only a single caller,
> why not just open code the loop in the caller?
>
>
>> +/*
>> + * Invalidate buffers for per-AG btree blocks we're dumping.  We assume that
>> + * exlist points only to metadata blocks.
>> + */
>> +int
>> +xfs_repair_invalidate_blocks(
>> +	struct xfs_scrub_context	*sc,
>> +	struct xfs_repair_extent_list	*exlist)
>> +{
>> +	struct xfs_repair_extent	*rex;
>> +	struct xfs_repair_extent	*n;
>> +	struct xfs_buf			*bp;
>> +	xfs_agnumber_t			agno;
>> +	xfs_agblock_t			agbno;
>> +	xfs_agblock_t			i;
>> +
>> +	for_each_xfs_repair_extent_safe(rex, n, exlist) {
>> +		agno = XFS_FSB_TO_AGNO(sc->mp, rex->fsbno);
>> +		agbno = XFS_FSB_TO_AGBNO(sc->mp, rex->fsbno);
>> +		for (i = 0; i < rex->len; i++) {
>> +			bp = xfs_btree_get_bufs(sc->mp, sc->tp, agno,
>> +					agbno + i, 0);
>> +			xfs_trans_binval(sc->tp, bp);
>> +		}
> Again, this is doing things by single blocks. We do have multi-block
> metadata (inodes, directory blocks, remote attrs) that, if it
> is already in memory, needs to be treated as multi-block extents. If
> we don't do that, we'll cause aliasing problems in the buffer cache
> (see _xfs_buf_obj_cmp()) and it's all downhill from there.
>
> That's why I get worried when I see assumptions that we can process
> contiguous metadata ranges in single block buffers....
>
> Cheers,
>
> Dave.

