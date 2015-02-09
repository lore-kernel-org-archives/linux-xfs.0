Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0728A7F85
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 19:25:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E880B304032
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 17:25:25 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vPurYI6tnEiOyake for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2015 17:25:22 -0800 (PST)
Date: Mon, 9 Feb 2015 12:25:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 10/18] xfs: allocate sparse inode chunks on full chunk
	allocation failure
Message-ID: <20150209012519.GK4251@dastard>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-11-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423252385-3063-11-git-send-email-bfoster@redhat.com>
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

On Fri, Feb 06, 2015 at 02:52:57PM -0500, Brian Foster wrote:
> xfs_ialloc_ag_alloc() makes several attempts to allocate a full inode
> chunk. If all else fails, reduce the allocation to the minimum sparse
> granularity and attempt to allocate a sparse inode chunk.
> 
> If sparse chunk allocation succeeds, check whether an inobt record
> already exists that can track the chunk. If so, inherit and update the
> existing record. Otherwise, insert a new record for the sparse chunk.
> 
> Update xfs_inobt_insert_rec() to take the holemask as a parameter and
> set the associated field on disk. Create the xfs_inobt_update_insert()
> helper to handle the sparse chunk allocation case - insert or update an
> existing record depending on whether it already exists.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 397 +++++++++++++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_trace.h         |  47 ++++++
>  2 files changed, 426 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index fc001d9..090d114 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -122,12 +122,16 @@ xfs_inobt_get_rec(
>  STATIC int
>  xfs_inobt_insert_rec(
>  	struct xfs_btree_cur	*cur,
> +	__uint16_t		holemask,
> +	__uint8_t		count,
>  	__int32_t		freecount,
>  	xfs_inofree_t		free,
>  	int			*stat)
>  {
> -	cur->bc_rec.i.ir_holemask = 0;
> -	cur->bc_rec.i.ir_count = 0; /* zero for backwards compatibility */
> +	ASSERT(count == 0 || xfs_sb_version_hassparseinodes(&cur->bc_mp->m_sb));
> +
> +	cur->bc_rec.i.ir_holemask = holemask;
> +	cur->bc_rec.i.ir_count = count;
>  	cur->bc_rec.i.ir_freecount = freecount;
>  	cur->bc_rec.i.ir_free = free;
>  	return xfs_btree_insert(cur, stat);

Ok, so I'd definitely prefer two separate helpers here so that we
don't need asserts or validity checking....

> @@ -151,6 +155,19 @@ xfs_inobt_insert(
>  	xfs_agino_t		thisino;
>  	int			i;
>  	int			error;
> +	uint8_t			count;
> +
> +	/*
> +	 * Only set ir_count in the inobt record if the sparse inodes feature is
> +	 * enabled. If disabled, we must maintain backwards compatibility with
> +	 * the older inobt record format where the current count and holemask
> +	 * fields map to the higher order bytes of freecount and thus must be
> +	 * zeroed.
> +	 */
> +	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
> +		count = XFS_INODES_PER_CHUNK;
> +	else
> +		count = 0;

I'd strongly suggest that we pass the holemask, count and freecount
from the caller, for reasons that will become obvious later.

> @@ -164,7 +181,7 @@ xfs_inobt_insert(
>  		}
>  		ASSERT(i == 0);
>  
> -		error = xfs_inobt_insert_rec(cur, XFS_INODES_PER_CHUNK,
> +		error = xfs_inobt_insert_rec(cur, 0, count, XFS_INODES_PER_CHUNK,
>  					     XFS_INOBT_ALL_FREE, &i);
>  		if (error) {
>  			xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);

And this hunk would become:

		if (xfs_sb_version_hassparseinodes(&mp->m_sb)) {
			error = xfs_inobt_insert_sprec(cur, holemask, count,
						       freecount, &i);
						       holemask,
		else
			error = xfs_inobt_insert_rec(cur, count,
						     freecount, &i);

> @@ -174,8 +191,58 @@ xfs_inobt_insert(
>  	}
>  
>  	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> +	return 0;
> +}
>  
> +/*
> + * Update or insert a new record based on a sparse inode chunk allocation.
> + *
> + * If a record already exists, the new record is an updated version of that
> + * record based on a merge of sparse inode chunks. Update the record in place.
> + * Otherwise, insert a new record in the tree. Note that the record to insert
> + * must already have been aligned and merged, if necessary.
> + */
> +STATIC int
> +xfs_inobt_update_insert(
> +	struct xfs_mount		*mp,
> +	struct xfs_trans		*tp,
> +	struct xfs_buf			*agbp,
> +	struct xfs_inobt_rec_incore	*rec,
> +	xfs_btnum_t			btnum)
> +{
> +	struct xfs_btree_cur		*cur;
> +	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
> +	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
> +	int				i;
> +	int				error;
> +
> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
> +
> +	error = xfs_inobt_lookup(cur, rec->ir_startino, XFS_LOOKUP_EQ, &i);
> +	if (error)
> +		goto error;
> +	if (i == 1) {
> +		/* found a record, update it with the merged record */
> +		error = xfs_inobt_update(cur, rec);
> +		if (error)
> +			goto error;
> +		goto out;
> +	}
> +
> +	/* no existing record, insert a new one */
> +	error = xfs_inobt_insert_rec(cur, rec->ir_holemask, rec->ir_count,
> +				     rec->ir_freecount, rec->ir_free, &i);
> +	if (error)
> +		goto error;
> +	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
> +
> +out:
> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>  	return 0;
> +
> +error:
> +	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> +	return error;
>  }

I think that the way you've factored out the sparse inode record
update code can do with some work. I'll come back to this.

> @@ -358,6 +453,183 @@ xfs_ialloc_inode_init(
>  }
>  
>  /*
> + * Align a record for a recently allocated sparse chunk. The input is a record
> + * that describes the unaligned chunk. The record is aligned such that it is fit
> + * for insertion (or merge) into the on-disk inode btrees.
> + */
> +STATIC void
> +xfs_align_sparse_rec(
> +	struct xfs_mount		*mp,
> +	struct xfs_inobt_rec_incore	*rec)
> +{
> +	xfs_agblock_t			agbno;
> +	xfs_agblock_t			mod;
> +	int				offset;
> +	uint16_t			allocmask;
> +
> +	agbno = XFS_AGINO_TO_AGBNO(mp, rec->ir_startino);
> +	mod = agbno % mp->m_sb.sb_inoalignmt;
> +	if (!mod)
> +		return;
> +
> +	/* calculate the inode offset and align startino */
> +	offset = mod << mp->m_sb.sb_inopblog;
> +	rec->ir_startino -= offset;
> +
> +	/*
> +	 * Since startino has been aligned down, we have to left shift
> +	 * ir_holemask such that it continues to represent the same physical
> +	 * inodes as the unaligned record. The unaligned record by definition
> +	 * tracks the allocated inodes with the lowest order bits.
> +	 *
> +	 * ir_holemask is inverted before the shift such that set bits represent
> +	 * allocated inodes. This makes it safe for the bit-shift to introduce
> +	 * zeroes in the lower order bits without corrupting the record.
> +	 *
> +	 * Note that no change is required for ir_count, ir_freecount or
> +	 * ir_free. The count values are not affected by alignment and ir_free
> +	 * is initialized to 1s for all inodes, sparse or otherwise.
> +	 */
> +	allocmask = ~rec->ir_holemask;
> +	allocmask <<= offset / XFS_INODES_PER_HOLEMASK_BIT;
> +	rec->ir_holemask = ~allocmask;
> +}

I don't understand why the holemask would need changing. I would
have expected this to be done before the hole mask has been placed
inside the record. Indeed, putting it into the record first means we
have to deal with inversions and jump through other hoops.

static void
xfs_align_sparse_ino(
	struct xfs_mount	*mp,
	xfs_agino_t		*startino,
	uint16_t		*allocmask)
{
	agbno = XFS_AGINO_TO_AGBNO(mp, *startino);
	mod = agbno % mp->m_sb.sb_inoalignmt;
	if (!mod)
		return;

	offset = mod << mp->m_sb.sb_inopblog;
	*startino -= offset;
	*allocmask <<= offset / XFS_INODES_PER_HOLEMASK_BIT;
}

And then place the result in the irec....

> +/*
> + * Determine whether a sparse inode records can be merged. The inode ranges
> + * must match and there must be no allocation overlap between the records.
> + */

Hmmm - src + target is not great for an operation where both records
are a source. Perhaps be explict in the comment? e.g.

/*
 * Determine whether the source inode record can be merged into a
 * target record. Both records must be sparse, the inode ranges
 * must match and there must be no allocation overlap between the
 * records.
 */

> +STATIC bool
> +__xfs_inobt_can_merge(
> +	struct xfs_inobt_rec_incore	*trec,	/* tgt record */
> +	struct xfs_inobt_rec_incore	*srec)	/* src record */

If we detect overlap, isn't that an indication of corruption?

> +{
> +	DECLARE_BITMAP(talloc, 64);
> +	DECLARE_BITMAP(salloc, 64);
> +	DECLARE_BITMAP(tmp, 64);
> +
> +	/* records must cover the same inode range */
> +	if (trec->ir_startino != srec->ir_startino)
> +		return false;
> +
> +	/* both records must be sparse */
> +	if (!xfs_inobt_issparse(trec->ir_holemask) ||
> +	    !xfs_inobt_issparse(srec->ir_holemask))
> +		return false;
> +
> +	/* can't exceed capacity of a full record */
> +	if (trec->ir_count + srec->ir_count > XFS_INODES_PER_CHUNK)
> +		return false;

probably also need to check that both records have inodes allocated
in them. ir_count == 0 is indicative of a corrupt record, right?

> +
> +	/* verify there is no allocation overlap */
> +	xfs_inobt_ialloc_bitmap(talloc, trec);
> +	xfs_inobt_ialloc_bitmap(salloc, srec);
> +
> +	bitmap_and(tmp, salloc, talloc, 64);
> +	if (!bitmap_empty(tmp, 64))
> +		return false;

And if one has an ir_count of zero, the bitmap will always be
zero....

> +/*
> + * Merge two sparse inode records. The caller must call __xfs_inobt_can_merge()
> + * to ensure the merge is valid.
> + */

same thing about src/target here.

> +STATIC void
> +__xfs_inobt_rec_merge(
> +	struct xfs_inobt_rec_incore	*trec,	/* target */
> +	struct xfs_inobt_rec_incore	*srec)	/* src */
> +{
> +	ASSERT(trec->ir_startino == srec->ir_startino);
> +
> +	/* combine the counts */
> +	trec->ir_count += srec->ir_count;
> +	trec->ir_freecount += srec->ir_freecount;
> +
> +	/* merge the holemask */
> +	trec->ir_holemask &= srec->ir_holemask;

Comments in this function are not very useful. Please remind me:
does the holemask use bit value of 1 as allocated or as a hole?
My head is full of allocmask stuff and so I can't tell if a merge
should use |= or &= to get the correct value.

> +	/* merge the free mask */
> +	trec->ir_free &= srec->ir_free;

Same here.

> +}
> +
> +/*
> + * Determine whether a newly allocated sparse inode chunk record overlaps with
> + * an existing sparse record in the inobt. When sparse inode chunks are enabled,
> + * all inode chunk alignment is increased from cluster size to physical inode
> + * chunk size. This means that the smallest, non-zero gap between two inode
> + * chunks is at least one full inode chunk. When a sparse inode chunk is
> + * allocated, the containing record is also aligned in this manner such that
> + * future sparse allocations within that same range all align to the same record
> + * startino. This alignment policy supports the ability to merge sparse chunks
> + * into complete chunks over time.
> + *
> + * Given an newly allocated/aligned sparse inode record, look up whether a
> + * sparse record already exists at this startino. If so, merge the two records
> + * and return the merged record in nrec.
> + *
> + * An error is returned if records overlap but a merge is not possible. Given
> + * the alignment constraints described above, this should never happen and thus
> + * is treated as fs corruption.
> + */
> +STATIC int
> +xfs_inobt_rec_merge(
> +	struct xfs_mount		*mp,
> +	struct xfs_trans		*tp,
> +	struct xfs_buf			*agbp,
> +	xfs_btnum_t			btnum,
> +	struct xfs_inobt_rec_incore	*nrec)	/* in/out: new/merged rec. */
> +{
> +	struct xfs_btree_cur		*cur;
> +	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
> +	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
> +	int				error;
> +	int				i;
> +	struct xfs_inobt_rec_incore	rec;
> +
> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
> +
> +	/* the new record is pre-aligned so we know where to look */
> +	error = xfs_inobt_lookup(cur, nrec->ir_startino, XFS_LOOKUP_EQ, &i);
> +	if (error)
> +		goto error;
> +	/* if nothing there, we're done */
> +	if (i == 0)
> +		goto out;
> +
> +	error = xfs_inobt_get_rec(cur, &rec, &i);
> +	if (error)
> +		goto error;
> +	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
> +	ASSERT(rec.ir_startino == nrec->ir_startino);

XFS_WANT_CORRUPTED_GOTO() is better than an assert here. On a debug
kernel, it will still assert, but on a production kernel it will
trigger a corruption error rather than potentially propagating a
corruption further.

> +	/*
> +	 * This should never happen. If we have coexisting records that cannot
> +	 * merge, something is seriously wrong.
> +	 */
> +	if (!__xfs_inobt_can_merge(nrec, &rec)) {
> +		error = -EFSCORRUPTED;
> +		goto error;
> +	}

Ah, so it is a corruption issue if merges can't occur. ;)

	XFS_WANT_CORRUPTED_GOTO(!__xfs_inobt_can_merge(nrec, &rec));

> @@ -514,6 +828,65 @@ xfs_ialloc_ag_alloc(
>  	 * Convert the results.
>  	 */
>  	newino = XFS_OFFBNO_TO_AGINO(args.mp, args.agbno, 0);
> +
> +	if (xfs_inobt_issparse(~allocmask)) {
> +		/*
> +		 * We've allocated a sparse chunk...
> +		 */
> +		rec.ir_startino = newino;
> +		rec.ir_holemask = ~allocmask;
> +		rec.ir_count = newlen;
> +		rec.ir_freecount = newlen;
> +		rec.ir_free = XFS_INOBT_ALL_FREE;
> +
> +		/* align record and update newino for agi_newino */
> +		xfs_align_sparse_rec(args.mp, &rec);
> +		newino = rec.ir_startino;

See my earlier comments about aligning before putting stuff into
the record, especially as you are having to pull modified
information straight back out of the record.


> +		error = xfs_inobt_rec_merge(args.mp, tp, agbp, XFS_BTNUM_INO,
> +					    &rec);
> +		if (!error)
> +			error = xfs_inobt_rec_check_count(args.mp, &rec);
> +		if (error == -EFSCORRUPTED) {
> +			xfs_alert(args.mp,
> +	"invalid sparse inode record: ino 0x%llx holemask 0x%x count %u",
> +				  XFS_AGINO_TO_INO(args.mp, agno,
> +						   rec.ir_startino),
> +				  rec.ir_holemask, rec.ir_count);
> +			xfs_force_shutdown(args.mp, SHUTDOWN_CORRUPT_INCORE);
> +		}
> +		if (error)
> +			return error;
> +
> +		error = xfs_inobt_update_insert(args.mp, tp, agbp, &rec,
> +						XFS_BTNUM_INO);
> +		if (error)
> +			return error;
> +
> +		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
> +			error = xfs_inobt_update_insert(args.mp, tp, agbp, &rec,
> +							XFS_BTNUM_FINO);
> +			if (error)
> +				return error;
> +		}

I think this needs to become a helper function, and the
implementation refactored. The reason I say this is that the
xfs_inobt_rec_merge() function already looks up the record that is
to be updated, and if it exists if calculates the merged record
value. If then drops all that state and returns the merged record.

Then we call xfs_inobt_update_insert() to determine if we have to
update the existing record with the merged record (i.e. build all
the state again), and then call xfs_inobt_update() on that record.

Essentially, if xfs_inobt_rec_merge() determines we have a merge
candidate, we should do the btree update there immediately, as well
as fix up the finobt record.

If we aren't doing a record merge and update, then it's just an
insert operation, and we can use the modified xfs_inobt_insert()
function I mentioned earlier to pass the partial chunk record
information for insertion. Perhaps even just pass the irec
structure...

> +	} else {
> +		/* full chunk - insert new records to both btrees */
> +		error = xfs_inobt_insert(args.mp, tp, agbp, newino, newlen,
> +					 XFS_BTNUM_INO);
> +		if (error)
> +			return error;
> +
> +		if (xfs_sb_version_hasfinobt(&args.mp->m_sb)) {
> +			error = xfs_inobt_insert(args.mp, tp, agbp, newino,
> +						 newlen, XFS_BTNUM_FINO);
> +			if (error)
> +				return error;
> +		}

And this could pass an irec that indicates a full inode chunk rather
than just the subset of inofmration needed to describe a full inode
chunk.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
