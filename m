Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA0997F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 10:24:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6FB62AC00D
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 08:24:53 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qsM054DRmPWlT1ES for
	<xfs@oss.sgi.com>; Tue, 11 Feb 2014 08:24:52 -0800 (PST)
Message-ID: <52FA5086.9010600@redhat.com>
Date: Tue, 11 Feb 2014 11:32:06 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 06/11] xfs: use and update the finobt on inode
	allocation
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-7-git-send-email-bfoster@redhat.com>
	<20140211071703.GG13647@dastard>
In-Reply-To: <20140211071703.GG13647@dastard>
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
Cc: xfs@oss.sgi.com

On 02/11/2014 02:17 AM, Dave Chinner wrote:
> On Tue, Feb 04, 2014 at 12:49:37PM -0500, Brian Foster wrote:
>> Replace xfs_dialloc_ag() with an implementation that looks for a
>> record in the finobt. The finobt only tracks records with at least
>> one free inode. This eliminates the need for the intra-ag scan in
>> the original algorithm. Once the inode is allocated, update the
>> finobt appropriately (possibly removing the record) as well as the
>> inobt.
>>
>> Move the original xfs_dialloc_ag() algorithm to
>> xfs_dialloc_ag_slow() and fall back as such if finobt support is
>> not enabled.
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  fs/xfs/xfs_ialloc.c | 211 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 210 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
>> index bdaab76..afc9840 100644
>> --- a/fs/xfs/xfs_ialloc.c
>> +++ b/fs/xfs/xfs_ialloc.c
>> @@ -723,7 +723,7 @@ xfs_ialloc_get_rec(
>>   * available.
>>   */
>>  STATIC int
>> -xfs_dialloc_ag(
>> +xfs_dialloc_ag_slow(
>>  	struct xfs_trans	*tp,
>>  	struct xfs_buf		*agbp,
>>  	xfs_ino_t		parent,
> 
> OK, though I would have called it xfs_dialloc_ag_from_inobt() or
> something similar to indicate what tree it is walking....
> 

Fair enough, that's more specific at least.

>> +STATIC int
>> +xfs_dialloc_ag(
>> +	struct xfs_trans	*tp,
>> +	struct xfs_buf		*agbp,
>> +	xfs_ino_t		parent,
>> +	xfs_ino_t		*inop)
>> +{
> 
> Initial thought: Wow, long, long function. How can we split this up?
> 
>> +	struct xfs_mount		*mp = tp->t_mountp;
>> +	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
>> +	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
>> +	xfs_agnumber_t			pagno = XFS_INO_TO_AGNO(mp, parent);
>> +	xfs_agino_t			pagino = XFS_INO_TO_AGINO(mp, parent);
>> +	struct xfs_perag		*pag;
>> +	struct xfs_btree_cur		*cur;
>> +	struct xfs_btree_cur		*tcur;
>> +	struct xfs_inobt_rec_incore	rec;
>> +	struct xfs_inobt_rec_incore	trec;
>> +	xfs_ino_t			ino;
>> +	int				error;
>> +	int				offset;
>> +	int				i, j;
>> +
>> +	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
>> +		return xfs_dialloc_ag_slow(tp, agbp, parent, inop);
>> +
>> +	pag = xfs_perag_get(mp, agno);
>> +
>> +	/*
>> +	 * If pagino is 0 (this is the root inode allocation) use newino.
>> +	 * This must work because we've just allocated some.
>> +	 */
>> +	if (!pagino)
>> +		pagino = be32_to_cpu(agi->agi_newino);
>> +
>> +	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_FINO);
>> +
>> +	error = xfs_check_agi_freecount(cur, agi);
>> +	if (error)
>> +		goto error_cur;
>> +
>> +	if (agno == pagno) {
>> +		/*
>> +		 * We're in the same AG as the parent inode so allocate the
>> +		 * closest inode to the parent.
>> +		 */
>> +		error = xfs_inobt_lookup(cur, pagino, XFS_LOOKUP_LE, &i);
>> +		if (error)
>> +			goto error_cur;
>> +		if (i == 1) {
>> +			error = xfs_inobt_get_rec(cur, &rec, &i);
>> +			if (error)
>> +				goto error_cur;
>> +			XFS_WANT_CORRUPTED_GOTO(i == 1, error_cur);
>> +
>> +			/*
>> +			 * See if we've landed in the parent inode record. The
>> +			 * finobt only tracks chunks with at least one free
>> +			 * inode, so record existence is enough.
>> +			 */
>> +			if (pagino >= rec.ir_startino &&
>> +			    pagino < (rec.ir_startino + XFS_INODES_PER_CHUNK))
>> +				goto alloc_inode;
>> +		}
>> +
>> +		error = xfs_btree_dup_cursor(cur, &tcur);
>> +		if (error) 
>> +			goto error_cur;
>> +
>> +		error = xfs_inobt_lookup(tcur, pagino, XFS_LOOKUP_GE, &j);
>> +		if (error)
>> +			goto error_tcur;
>> +		if (j == 1) {
>> +			error = xfs_inobt_get_rec(tcur, &trec, &j);
>> +			if (error)
>> +				goto error_tcur;
>> +			XFS_WANT_CORRUPTED_GOTO(j == 1, error_tcur);
>> +		}
>> +
>> +		if (i == 1 && j == 1) {
>> +			if ((pagino - rec.ir_startino + XFS_INODES_PER_CHUNK - 1) >
>> +			    (trec.ir_startino - pagino)) {
>> +				rec = trec;
>> +				xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>> +				cur = tcur;
>> +			} else {
>> +				xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
>> +			}
>> +		} else if (j == 1) {
>> +			rec = trec;
>> +			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>> +			cur = tcur;
>> +		} else {
>> +			xfs_btree_del_cursor(tcur, XFS_BTREE_NOERROR);
>> +		}
> 
> That entire branch can be easily factored into:
> 
> 		error = xfs_dialloc_ag_finobt_near(cur, pagino, &rec);
> 

Indeed. The function is already organized to facilitate this via the use
of the cursor/record pointers. A slight difference is the callee may
need to duplicate and replace the caller's cursor.

> /*
>  * Allocate as close to the target agino as possible
>  */
> static int
> xfs_dialloc_ag_finobt_near(
> 	struct xfs_btree_cur	*cur,
> 	xfs_agino_t		agino,
> 	struct xfs_inobt_rec_incore *rec)
> {
> 	struct xfs_btree_cur	*rcur;	/* cursor for right search */
> 	struct xfs_inobt_rec_incore rrec; /* and the record used */
> 	int		error;
> 	int		i;
> 	int		l;
> 
> 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &i);
> 	if (error)
> 		return error;
> 
> 	if (i == 1) {
> 		error = xfs_inobt_get_rec(cur, rec, &i);
> 		if (error)
> 			return error;
> 		XFS_WANT_CORRUPTED_RETURN(i == 1);
> 
> 		/*
> 		 * See if we've landed in the target inode record. The
> 		 * finobt only tracks chunks with at least one free
> 		 * inode, so record existence is enough.
> 		 */
> 		if (agino >= rec->ir_startino &&
> 		    agino < (rec->ir_startino + XFS_INODES_PER_CHUNK))
> 			return 0;
> 	}
> 
> 	error = xfs_btree_dup_cursor(cur, &rcur);
> 	if (error)
> 		return error;
> 
> 	error = xfs_inobt_lookup(rcur, agino, XFS_LOOKUP_GE, &j);
> 	if (error)
> 		goto error_rcur;
> 	if (j == 1) {
> 		error = xfs_inobt_get_rec(rcur, &rrec, &j);
> 		if (error)
> 			goto error_rcur;
> 		XFS_WANT_CORRUPTED_GOTO(j == 1, error_rcur);
> 	}
> 
> 	if (i == 1 && j == 1) {
> 		/*
> 		 * both left and right records are valid, so choose
> 		 * the closer inode chunk to the target.
> 		 */
> 		if ((agino - rec.ir_startino + XFS_INODES_PER_CHUNK - 1) >
> 					(rrec.ir_startino - agino)) {
> 			*rec = rrec;
> 			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> 			cur = rcur;
> 		} else {
> 			xfs_btree_del_cursor(rcur, XFS_BTREE_NOERROR);
> 		}
> 	} else if (j == 1) {
> 		/* only right record is valid */
> 		*rec = rrec;
> 		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> 		cur = rcur;
> 	} else {
> 		/* Found neither left nor right.
> 		xfs_btree_del_cursor(rcur, XFS_BTREE_NOERROR);
> 	}
> 	return 0;
> 
> error_rcur:
> 	xfs_btree_del_cursor(rcur, XFS_BTREE_ERROR);
> 	return error;
> }
> 
>> +	} else {
>> +		/*
>> +		 * Different AG from the parent inode. Check the record for the
>> +		 * most recently allocated inode.
>> +		 */
>> +		if (agi->agi_newino != cpu_to_be32(NULLAGINO)) {
>> +			error = xfs_inobt_lookup(cur, agi->agi_newino,
>> +						 XFS_LOOKUP_EQ, &i);
>> +			if (error)
>> +				goto error_cur;
>> +			if (i == 1) {
>> +				error = xfs_inobt_get_rec(cur, &rec, &i);
>> +				if (error)
>> +					goto error_cur;
>> +				XFS_WANT_CORRUPTED_GOTO(i == 1, error_cur);
>> +				goto alloc_inode;
>> +			}
>> +		}
>> +
>> +		/*
>> +		 * Allocate the first inode available in the AG.
>> +		 */
>> +		error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
>> +		if (error)
>> +			goto error_cur;
>> +		XFS_WANT_CORRUPTED_GOTO(i == 1, error_cur);
>> +
>> +		error = xfs_inobt_get_rec(cur, &rec, &i);
>> +		if (error)
>> +			goto error_cur;
>> +		XFS_WANT_CORRUPTED_GOTO(i == 1, error_cur);
> 
> And that can be factored in a similar manner in
> xfs_dialloc_ag_newino()....
> 

Ok.

>> +	}
>> +
>> +alloc_inode:
>> +	offset = xfs_lowbit64(rec.ir_free);
>> +	ASSERT(offset >= 0);
>> +	ASSERT(offset < XFS_INODES_PER_CHUNK);
>> +	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
>> +				   XFS_INODES_PER_CHUNK) == 0);
>> +	ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino + offset);
>> +
>> +	/*
>> +	 * Modify or remove the finobt record.
>> +	 */
>> +	rec.ir_free &= ~XFS_INOBT_MASK(offset);
>> +	rec.ir_freecount--;
>> +	if (rec.ir_freecount) 
>> +		error = xfs_inobt_update(cur, &rec);
>> +	else
>> +		error = xfs_btree_delete(cur, &i);
>> +	if (error)
>> +		goto error_cur;
>> +
>> +	/*
>> +	 * Lookup and modify the equivalent record in the inobt.
>> +	 */
>> +	tcur = xfs_inobt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_INO);
> 
> In case ou hadn't guessed, I don't like the "tcur/trec" variables
> because they make me thing "temporary" which they aren't. In this
> case it is the inobt cursor and record....
> 
> In fact, this whole segment could be factored into a function like
> xfs_dialloc_ag_inobt_update(), hence removing the second cursor from
> xfs_dialloc_ag() function altogether and that would clean a lot of
> the logic up....
> 

Sounds reasonable.

>> +
>> +	error = xfs_check_agi_freecount(tcur, agi);
>> +	if (error)
>> +		goto error_tcur;
>> +
>> +	error = xfs_inobt_lookup(tcur, rec.ir_startino, XFS_LOOKUP_EQ, &i);
>> +	if (error)
>> +		goto error_tcur;
>> +	XFS_WANT_CORRUPTED_GOTO(i == 1, error_tcur);
>> +
>> +	error = xfs_inobt_get_rec(tcur, &trec, &i);
>> +	if (error)
>> +		goto error_tcur;
>> +	XFS_WANT_CORRUPTED_GOTO(i == 1, error_tcur);
>> +	ASSERT((XFS_AGINO_TO_OFFSET(mp, trec.ir_startino) %
>> +				   XFS_INODES_PER_CHUNK) == 0);
>> +
>> +	trec.ir_free &= ~XFS_INOBT_MASK(offset);
>> +	trec.ir_freecount--;
>> +
>> +	XFS_WANT_CORRUPTED_GOTO((rec.ir_free == trec.ir_free) &&
>> +				(rec.ir_freecount == trec.ir_freecount),
>> +				error_tcur);
>> +
>> +	error = xfs_inobt_update(tcur, &trec);
>> +	if (error)
>> +		goto error_tcur;
>> +
>> +	/*
>> +	 * Update the perag and superblock.
>> +	 */
>> +	be32_add_cpu(&agi->agi_freecount, -1);
>> +	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
>> +	pag->pagi_freecount--;
>> +
>> +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
> 
> This will need to be done before you update the inobt, though, so
> you can run the xfs_check_agi_freecount() count in it and it will
> come out correct....
> 

Right. I suppose this could update the finobt, perag & super, check the
agi against the finobt, then invoke the new helper (which will update
the inobt and check its cursor against the agi).

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
