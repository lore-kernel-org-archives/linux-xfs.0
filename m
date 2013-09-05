Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 678D07F5D
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 21:54:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28B65304051
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 19:54:28 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	SInDm9xOWrr2g2aG for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 19:54:26 -0700 (PDT)
Date: Thu, 5 Sep 2013 12:54:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 10/11] xfs: update the finobt on inode free
Message-ID: <20130905025421.GX23571@dastard>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-11-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378232708-57156-11-git-send-email-bfoster@redhat.com>
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

On Tue, Sep 03, 2013 at 02:25:07PM -0400, Brian Foster wrote:
> An inode free operation can have several effects on the finobt. If
> all inodes have been freed and the chunk deallocated, we remove the
> finobt record. If the inode chunk was previously full, we must
> insert a new record based on the existing inobt record. Otherwise,
> we modify the record in place.
> 
> Create the xfs_ifree_finobt() function to identify the potential
> scenarios and update the finobt appropriately.

The first thing I'd do is factor all the inobt manipulation
code xfs_difree() into a xfs_difree_inobt() helper function. have it
return the record and offset that is then passed to your new helper
xfs_difree_finobt(). That way xfs_difree() really becomes the setup
function for the two btree operations rather than containing one set
of modifications and calling a function to do the other...

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_ialloc.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 120 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 516f4af..96f71b5 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -198,6 +198,117 @@ xfs_inobt_insert(
>  }
>  
>  /*
> + * Free an inode in the free inode btree.
> + */
> +STATIC int
> +xfs_ifree_finobt(
> +	struct xfs_mount		*mp,
> +	struct xfs_trans		*tp,
> +	struct xfs_buf			*agbp,
> +	struct xfs_inobt_rec_incore	*ibtrec,/* inobt record */
> +	int				offset)	/* offset of inode */
> +{
> +	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
> +	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
> +	struct xfs_btree_cur		*cur;
> +	struct xfs_inobt_rec_incore	rec;
> +	int				error;
> +	int				i;
> +
> +	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
> +		return 0;

There's that vector thing again...

> +
> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
> +
> +	error = xfs_inobt_lookup(cur, ibtrec->ir_startino, XFS_LOOKUP_EQ, &i);
> +	if (error)
> +		goto error;
> +
> +	if (i == 1) {
> +		int j;
> +		/*
> +		 * Read and update the existing record.
> +		 */
> +		error = xfs_inobt_get_rec(cur, &rec, &j);
> +		if (error)
> +			goto error;
> +		XFS_WANT_CORRUPTED_GOTO(j == 1, error);
> +
> +		rec.ir_free |= XFS_INOBT_MASK(offset);
> +		rec.ir_freecount++;
> +
> +		XFS_WANT_CORRUPTED_GOTO((rec.ir_free == ibtrec->ir_free) &&
> +					(rec.ir_freecount == ibtrec->ir_freecount),
> +					error);
> +	}

I can't say I'm a great fan of the layout of the logic. Yes, there's
lots of cases to handle. It looks like:

	lookup()
	if (found)
		modify in place
	if (found && full && deleting chunks)
		delete record
	else if (!found && no record)
		insert record
	else if (found)
		update record
	else
		corruption!

I think it woul dbe better to get then "!found" case out of the way
at the start. ie

	if (i == 0) {
		if (ibtrec->ir_freecount == 1)
			insert record
		else
			CORRUPTION
		goto out;
	}

	/* found a record, no need to check i == 1 anymore */
	ASSERT(i == 1);

	/* read and update */

	if (full && deleting chunks)
		delete record
	else
		update record

	
> +
> +	/*
> +	 * The content of inobt records should always match between the inobt
> +	 * and finobt. The lifecycle of records in the finobt is different from
> +	 * the inobt in that the finobt only tracks records with at least one
> +	 * free inode. This is to optimize lookup for inode allocation purposes.
> +	 * The following checks fix up the finobt appropriately based on the
> +	 * state of the record subsequent to the current operation.
> +	 */
> +
> +	if ((i == 1) &&
> +	    (rec.ir_freecount == XFS_IALLOC_INODES(mp) &&
> +	     !(mp->m_flags & XFS_MOUNT_IKEEP))) {
> +		/*
> +		 * We have an existing finobt record. If all inodes are free
> +		 * and we're in !ikeep mode, the entire inode chunk has been
> +		 * deallocated. Remove the record from the finobt.
> +		 */
> +		error = xfs_btree_delete(cur, &i);
> +		if (error)
> +			goto error;
> +		ASSERT(i == 1);
> +	} else if ((i == 0) && (ibtrec->ir_freecount == 1)) {
> +		/*
> +		 * No existing finobt record and the inobt record has a single
> +		 * free inode. This means we've freed an inode in a previously
> +		 * fully allocated chunk. Insert a new record into the finobt
> +		 * based on the current inobt record.
> +		 */
> +		cur->bc_rec.i.ir_startino = ibtrec->ir_startino;
> +		cur->bc_rec.i.ir_free = ibtrec->ir_free;
> +		cur->bc_rec.i.ir_freecount = ibtrec->ir_freecount;
> +		error = xfs_btree_insert(cur, &i);
> +		if (error)
> +			goto error;
> +		ASSERT(i == 1);

That's rather similar to the code in xfs_inobt_insert(). Indeed,
is you write a helper - xfs_inobt_insert_rec() - for this, then rather than modifying
xfs_inobt_lookup() to take extra parameters like I wondered for the
previous patch, leave it alonge and pass the parameters to
xfs_inobt_insert_rec() instead.

Then this code is functionally identical to xfs_inobt_insert() done
during allocation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
