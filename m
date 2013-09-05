Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 44F1129DFB
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 21:27:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 24EEC8F8035
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 19:27:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	UqCnZ5dn15tmr6NF for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 19:27:24 -0700 (PDT)
Date: Thu, 5 Sep 2013 12:27:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 09/11] xfs: use and update the finobt on inode
	allocation
Message-ID: <20130905022719.GW23571@dastard>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-10-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378232708-57156-10-git-send-email-bfoster@redhat.com>
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

On Tue, Sep 03, 2013 at 02:25:06PM -0400, Brian Foster wrote:
> Replace xfs_dialloc_ag() with an implementation that looks for a
> record in the finobt. The finobt only tracks records with at least
> one free inode. This eliminates the need for the intra-ag scan in
> the original algorithm. Once the inode is allocated, update the
> finobt appropriately (possibly removing the record) as well as the
> inobt.
> 
> Move the original xfs_dialloc_ag() algorithm to
> xfs_dialloc_ag_slow() and fall back as such if finobt support is
> not enabled.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_ialloc.c | 136 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 135 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index e64a728..516f4af 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -708,7 +708,7 @@ xfs_ialloc_get_rec(
>   * available.
>   */
>  STATIC int
> -xfs_dialloc_ag(
> +xfs_dialloc_ag_slow(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*agbp,
>  	xfs_ino_t		parent,
> @@ -966,6 +966,140 @@ error0:
>  	return error;
>  }
>  
> +STATIC int
> +xfs_dialloc_ag(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	xfs_ino_t		parent,
> +	xfs_ino_t		*inop)
> +{
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
> +	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
> +	xfs_agino_t			pagino = XFS_INO_TO_AGINO(mp, parent);
> +	struct xfs_perag		*pag;
> +	struct xfs_btree_cur		*fcur;
> +	struct xfs_btree_cur		*icur;
> +	struct xfs_inobt_rec_incore	frec;
> +	struct xfs_inobt_rec_incore	irec;
> +	xfs_ino_t			ino;
> +	int				error;
> +	int				offset;
> +	int				i;
> +
> +	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
> +		return xfs_dialloc_ag_slow(tp, agbp, parent, inop);

I'm starting to think that we really, really need the iops vector
mentioned in "[RFD 15/17] xfs: introduce a method vector for unlinked
list operations" so we don't need to have these sorts of switches in
the code...

> +
> +	pag = xfs_perag_get(mp, agno);
> +
> +	/*
> +	 * If pagino is 0 (this is the root inode allocation) use newino.
> +	 * This must work because we've just allocated some.
> +	 */
> +	if (!pagino)
> +		pagino = be32_to_cpu(agi->agi_newino);
> +
> +	fcur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
> +	icur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
> +
> +	error = xfs_check_agi_freecount(fcur, agi);
> +	if (error)
> +		goto error;
> +	error = xfs_check_agi_freecount(icur, agi);
> +	if (error)
> +		goto error;

Why do we need to initialise both cursors at once? We only do the
operations one at a time, and you should actually use 2 cursors
for the finobt lookup.....

> +
> +	/*
> +	 * Search the finobt.
> +	 */
> +	error = xfs_inobt_lookup(fcur, pagino, XFS_LOOKUP_LE, &i);
> +	if (error)
> +		goto error;
> +	if (i == 0) {
> +		error = xfs_inobt_lookup(fcur, pagino, XFS_LOOKUP_GE, &i);
> +		if (error)
> +			goto error;
> +		XFS_WANT_CORRUPTED_GOTO(i == 1, error);
> +	}

.... because this biases allocation to lower inode numbers than the
target. i.e we only ever search for higher numbers if here are none
lower. That's quite different to the current algorithm which first
searches for the *closest* free inode.

That is, we should be using two cursors for the free inode search,
one for LE, the other for GT. If they both return records then, like
the "slow" algorithm, calculate the diff between them and the target
inode, and select the closer one (smallest diff). Destroy the cursor
you don't need.


> +	error = xfs_inobt_get_rec(fcur, &frec, &i);
> +	if (error)
> +		goto error;
> +	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
> +
> +	offset = xfs_lowbit64(frec.ir_free);
> +	ASSERT(offset >= 0);
> +	ASSERT(offset < XFS_INODES_PER_CHUNK);
> +	ASSERT((XFS_AGINO_TO_OFFSET(mp, frec.ir_startino) %
> +				   XFS_INODES_PER_CHUNK) == 0);
> +	ino = XFS_AGINO_TO_INO(mp, agno, frec.ir_startino + offset);
> +
> +	/*
> +	 * Modify or remove the finobt record.
> +	 */
> +	frec.ir_free &= ~XFS_INOBT_MASK(offset);
> +	frec.ir_freecount--;
> +	if (frec.ir_freecount) 
> +		error = xfs_inobt_update(fcur, &frec);
> +	else
> +		error = xfs_btree_delete(fcur, &i);
> +	if (error)
> +		goto error;

Yup, good.

Now you can re-initialise the second cursor to point at the inobt
and:

> +
> +	/*
> +	 * Lookup and modify the equivalent record in the inobt.
> +	 */
> +	error = xfs_inobt_lookup(icur, frec.ir_startino, XFS_LOOKUP_EQ, &i);
> +	if (error)
> +		goto error;
> +	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
> +
> +	error = xfs_inobt_get_rec(icur, &irec, &i);
> +	if (error)
> +		goto error;
> +	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
> +	ASSERT((XFS_AGINO_TO_OFFSET(mp, irec.ir_startino) %
> +				   XFS_INODES_PER_CHUNK) == 0);
> +
> +	irec.ir_free &= ~XFS_INOBT_MASK(offset);
> +	irec.ir_freecount--;
> +
> +	XFS_WANT_CORRUPTED_GOTO((frec.ir_free == irec.ir_free) &&
> +				(frec.ir_freecount == irec.ir_freecount),
> +				error);

Good, I like that check - they should be the same!

> +
> +	error = xfs_inobt_update(icur, &irec);
> +	if (error)
> +		goto error;
> +
> +	/*
> +	 * Update the perag and superblock.
> +	 */
> +	be32_add_cpu(&agi->agi_freecount, -1);
> +	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
> +	pag->pagi_freecount--;
> +
> +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
> +	xfs_perag_put(pag);
> +
> +	error = xfs_check_agi_freecount(fcur, agi);
> +	if (error)
> +		goto error;
> +	error = xfs_check_agi_freecount(icur, agi);
> +	if (error)
> +		goto error;

Failures here will result in 2 calls to xfs_perag_put(pag);

> +
> +	xfs_btree_del_cursor(icur, XFS_BTREE_NOERROR);
> +	xfs_btree_del_cursor(fcur, XFS_BTREE_ERROR);
> +	*inop = ino;
> +	return 0;
> +error:
> +	xfs_perag_put(pag);
> +	xfs_btree_del_cursor(icur, XFS_BTREE_ERROR);
> +	xfs_btree_del_cursor(fcur, XFS_BTREE_ERROR);
> +	return error;
> +}

Otherwise it looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
