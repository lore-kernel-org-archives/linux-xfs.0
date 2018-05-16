Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40872 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbeEPTS1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 15:18:27 -0400
Subject: Re: [PATCH 05/22] xfs: recover AG btree roots from rmap data
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642365045.1556.6221144971800322852.stgit@magnolia>
 <20180516085151.GT23861@dastard> <20180516183729.GL23858@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <70116e34-736d-b089-e89b-a9242ee0c80e@oracle.com>
Date: Wed, 16 May 2018 12:18:22 -0700
MIME-Version: 1.0
In-Reply-To: <20180516183729.GL23858@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Ok, you can add my review here as well:
Reviewed by: Allison Henderson <allison.henderson@oracle.com>

Thx!
On 05/16/2018 11:37 AM, Darrick J. Wong wrote:
> On Wed, May 16, 2018 at 06:51:52PM +1000, Dave Chinner wrote:
>> On Tue, May 15, 2018 at 03:34:10PM -0700, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Add a helper function to help us recover btree roots from the rmap data.
>>> Callers pass in a list of rmap owner codes, buffer ops, and magic
>>> numbers.  We iterate the rmap records looking for owner matches, and
>>> then read the matching blocks to see if the magic number & uuid match.
>>> If so, we then read-verify the block, and if that passes then we retain
>>> a pointer to the block with the highest level, assuming that by the end
>>> of the call we will have found the root.  This will be used to reset the
>>> AGF/AGI btree root fields during their rebuild procedures.
>>>
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> ---
>>>   fs/xfs/scrub/repair.c |  178 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>   fs/xfs/scrub/repair.h |   20 ++++++
>>>   2 files changed, 198 insertions(+)
>>>
>>>
>>> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
>>> index d820e01d1146..06c84f76d7ff 100644
>>> --- a/fs/xfs/scrub/repair.c
>>> +++ b/fs/xfs/scrub/repair.c
>>> @@ -766,3 +766,181 @@ xfs_repair_invalidate_blocks(
>>>   
>>>   	return 0;
>>>   }
>>> +
>>> +/* See if our block is in the AGFL. */
>>> +STATIC int
>>> +xfs_repair_findroot_agfl_walk(
>>> +	struct xfs_mount		*mp,
>>> +	xfs_agblock_t			bno,
>>> +	void				*priv)
>>> +{
>>> +	xfs_agblock_t			*agbno = priv;
>>> +
>>> +	return (*agbno == bno) ? XFS_BTREE_QUERY_RANGE_ABORT : 0;
>>> +}
>>> +
>>> +struct xfs_repair_findroot {
>>> +	struct xfs_scrub_context	*sc;
>>> +	struct xfs_buf			*agfl_bp;
>>> +	struct xfs_agf			*agf;
>>> +	struct xfs_repair_find_ag_btree	*btree_info;
>>> +};
>>> +
>>> +/* Does this block match the btree information passed in? */
>>> +STATIC int
>>> +xfs_repair_findroot_block(
>>> +	struct xfs_repair_findroot	*ri,
>>> +	struct xfs_repair_find_ag_btree	*fab,
>>> +	uint64_t			owner,
>>> +	xfs_agblock_t			agbno,
>>> +	bool				*found_it)
>>> +{
>>> +	struct xfs_mount		*mp = ri->sc->mp;
>>> +	struct xfs_buf			*bp;
>>> +	struct xfs_btree_block		*btblock;
>>> +	xfs_daddr_t			daddr;
>>> +	int				error;
>>> +
>>> +	/* rmap owner match? */
>>> +	if (owner != fab->rmap_owner)
>>> +		return 0;
>>
>> I'd put that in the caller - it's iterating the fab array and it
>> knows the owner it is looking for, so I think it makes more sense to
>> go there....
> 
> Ok.
> 
>>> +
>>> +	daddr = XFS_AGB_TO_DADDR(mp, ri->sc->sa.agno, agbno);
>>> +
>>> +	/*
>>> +	 * Blocks in the AGFL have stale contents that might just happen to
>>> +	 * have a matching magic and uuid.  We don't want to pull these blocks
>>> +	 * in as part of a tree root, so we have to filter out the AGFL stuff
>>> +	 * here.  If the AGFL looks insane we'll just refuse to repair.
>>> +	 */
>>> +	if (owner == XFS_RMAP_OWN_AG) {
>>> +		error = xfs_agfl_walk(mp, ri->agf, ri->agfl_bp,
>>> +				xfs_repair_findroot_agfl_walk, &agbno);
>>> +		if (error == XFS_BTREE_QUERY_RANGE_ABORT)
>>> +			return 0;
>>> +		if (error)
>>> +			return error;
>>> +	}
>>> +
>>> +	error = xfs_trans_read_buf(mp, ri->sc->tp, mp->m_ddev_targp, daddr,
>>> +			mp->m_bsize, 0, &bp, NULL);
>>> +	if (error)
>>> +		return error;
>>> +
>>> +	/*
>>> +	 * Does this look like a block matching our fs and higher than any
>>> +	 * other block we've found so far?  If so, reattach buffer verifiers
>>> +	 * so the AIL won't complain if the buffer is also dirty.
>>> +	 */
>>> +	btblock = XFS_BUF_TO_BLOCK(bp);
>>> +	if (be32_to_cpu(btblock->bb_magic) != fab->magic)
>>> +		goto out;
>>> +	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>>> +	    !uuid_equal(&btblock->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
>>> +		goto out;
>>> +	bp->b_ops = fab->buf_ops;
>>> +
>>> +	/* Ignore this block if it's lower in the tree than we've seen. */
>>> +	if (fab->root != NULLAGBLOCK &&
>>> +	    xfs_btree_get_level(btblock) < fab->height)
>>> +		goto out;
>>> +
>>> +	/* Make sure we pass the verifiers. */
>>> +	bp->b_ops->verify_read(bp);
>>> +	if (bp->b_error)
>>> +		goto out;
>>> +	fab->root = agbno;
>>> +	fab->height = xfs_btree_get_level(btblock) + 1;
>>> +	*found_it = true;
>>> +
>>> +	trace_xfs_repair_findroot_block(mp, ri->sc->sa.agno, agbno,
>>> +			be32_to_cpu(btblock->bb_magic), fab->height - 1);
>>> +out:
>>> +	xfs_trans_brelse(ri->sc->tp, bp);
>>
>> So we release the buffer once we've found it, which also unlocks it.
>> That means when we come back to it later, it may have been accessed
>> and changed by something else and no longer be the block we are
>> looking for. How do you protect against this sort of race given we
>> are unlocking the buffer? Perhaps it should be held on the fab
>> structure, and released when a better candidate is found?
> 
> The two callers of this function are the AGF and AGI repair functions.
> AGF repair holds the locked AGF buffer, and AGI repair holds the locked
> AGF & AGI buffers, which should be enough to prevent anyone else from
> accessing the AG btrees.  They keep the all the AG header buffers locked
> until they're completely finished with rebuilding the headers (i.e.
> xfs_scrub_teardown) and it's safe for the shape to change.
> 
> How about I add to the comment for this function:
> 
> /*
>   * The caller must lock the applicable per-AG header buffers (AGF, AGI)
>   * to prevent other threads from changing the shape of the btrees that
>   * we are looking for.  It must maintain those locks until it's safe for
>   * other threads to change the btrees' shapes.
>   */
> 
> --D
> 
>>> +	return error;
>>> +}
>>> +
>>> +/*
>>> + * Do any of the blocks in this rmap record match one of the btrees we're
>>> + * looking for?
>>> + */
>>> +STATIC int
>>> +xfs_repair_findroot_rmap(
>>> +	struct xfs_btree_cur		*cur,
>>> +	struct xfs_rmap_irec		*rec,
>>> +	void				*priv)
>>> +{
>>> +	struct xfs_repair_findroot	*ri = priv;
>>> +	struct xfs_repair_find_ag_btree	*fab;
>>> +	xfs_agblock_t			b;
>>> +	bool				found_it;
>>> +	int				error = 0;
>>> +
>>> +	/* Ignore anything that isn't AG metadata. */
>>> +	if (!XFS_RMAP_NON_INODE_OWNER(rec->rm_owner))
>>> +		return 0;
>>> +
>>> +	/* Otherwise scan each block + btree type. */
>>> +	for (b = 0; b < rec->rm_blockcount; b++) {
>>> +		found_it = false;
>>> +		for (fab = ri->btree_info; fab->buf_ops; fab++) {
>>> +			error = xfs_repair_findroot_block(ri, fab,
>>> +					rec->rm_owner, rec->rm_startblock + b,
>>> +					&found_it);
>>
>> This loop is where I think the fab->owner/rec->rm_owner check
>> should go....
>>
>> Cheers,
>>
>> Dave.
>> -- 
>> Dave Chinner
>> david@fromorbit.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=rBPwCYkOfcA0Ljv7VWlTAZN8EPqKEvw5_1z9fzrl1S4&s=9iowSgTX47PO1FTR1YOuG2QOVgfa2kVqnVNbwqcqsI8&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=rBPwCYkOfcA0Ljv7VWlTAZN8EPqKEvw5_1z9fzrl1S4&s=9iowSgTX47PO1FTR1YOuG2QOVgfa2kVqnVNbwqcqsI8&e=
> 
