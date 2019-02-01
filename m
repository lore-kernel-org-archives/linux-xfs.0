Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56292 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbfBATBU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 14:01:20 -0500
Date: Fri, 1 Feb 2019 14:01:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/8] xfs: refactor inode unlinked pointer update functions
Message-ID: <20190201190117.GD31203@bfoster>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897670150.26065.2878806054016276963.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154897670150.26065.2878806054016276963.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 03:18:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hoist the functions that update an inode's unlinked pointer updates into
> a helper.  No functional changes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_inode.c |  188 +++++++++++++++++++++++++++-------------------------
>  fs/xfs/xfs_trace.h |   26 +++++++
>  2 files changed, 124 insertions(+), 90 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4ddda3f3255f..ea38b66fbc59 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1920,6 +1920,88 @@ xfs_iunlink_update_bucket(
>  	return 0;
>  }
>  
> +/* Set an on-disk inode's unlinked pointer and return the old value. */

Doesn't look like this one returns anything.

> +STATIC void
> +xfs_iunlink_update_dinode(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*ibp,
> +	struct xfs_dinode	*dip,
> +	struct xfs_imap		*imap,
> +	xfs_ino_t		ino,
> +	xfs_agino_t		new_agino)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	int			offset;
> +
> +	ASSERT(new_agino == NULLAGINO ||
> +	       xfs_verify_agino(mp, XFS_INO_TO_AGNO(mp, ino), new_agino));
> +
> +	trace_xfs_iunlink_update_dinode(mp,
> +			XFS_INO_TO_AGNO(mp, ino),
> +			XFS_INO_TO_AGINO(mp, ino),
> +			be32_to_cpu(dip->di_next_unlinked), new_agino);
> +
> +	dip->di_next_unlinked = cpu_to_be32(new_agino);
> +	offset = imap->im_boffset +
> +			offsetof(struct xfs_dinode, di_next_unlinked);
> +
> +	/* need to recalc the inode CRC if appropriate */
> +	xfs_dinode_calc_crc(mp, dip);
> +	xfs_trans_inode_buf(tp, ibp);
> +	xfs_trans_log_buf(tp, ibp, offset, (offset + sizeof(xfs_agino_t) - 1));
> +	xfs_inobp_check(mp, ibp);
> +}
> +
> +/* Set an in-core inode's unlinked pointer and return the old value. */
> +STATIC int
> +xfs_iunlink_update_inode(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	xfs_agino_t		new_agino,
> +	xfs_agino_t		*old_agino)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_dinode	*dip;
> +	struct xfs_buf		*ibp;
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> +	xfs_agino_t		old_value;
> +	int			error;
> +
> +	ASSERT(new_agino == NULLAGINO || xfs_verify_agino(mp, agno, new_agino));
> +
> +	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0, 0);
> +	if (error)
> +		return error;
> +
> +	/* Make sure the old pointer isn't garbage. */
> +	old_value = be32_to_cpu(dip->di_next_unlinked);
> +	if (old_value != NULLAGINO && !xfs_verify_agino(mp, agno, old_value)) {
> +		error = -EFSCORRUPTED;
> +		goto out;
> +	}
> +	*old_agino = old_value;
> +
> +	/*
> +	 * Since we're updating a linked list, we should never find that the
> +	 * current pointer is the same as the new value, unless we're
> +	 * terminating the list.
> +	 */
> +	*old_agino = old_value;

Double assign of *old_agino.

> +	if (old_value == new_agino) {
> +		if (new_agino != NULLAGINO)
> +			error = -EFSCORRUPTED;
> +		goto out;
> +	}
> +
> +	/* Ok, update the new pointer. */
> +	xfs_iunlink_update_dinode(tp, ibp, dip, &ip->i_imap, ip->i_ino,
> +			new_agino);
> +	return 0;
> +out:
> +	xfs_trans_brelse(tp, ibp);
> +	return error;
> +}
> +
>  /*
>   * This is called when the inode's link count goes to 0 or we are creating a
>   * tmpfile via O_TMPFILE. In the case of a tmpfile, @ignore_linkcount will be
> @@ -1937,15 +2019,12 @@ xfs_iunlink(
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_agi		*agi;
> -	struct xfs_dinode	*dip;
>  	struct xfs_buf		*agibp;
> -	struct xfs_buf		*ibp;
>  	struct xfs_perag	*pag;
>  	xfs_agnumber_t		agno;
>  	xfs_agino_t		next_agino;
>  	xfs_agino_t		agino;
>  	short			bucket_index;
> -	int			offset;
>  	int			error;
>  
>  	ASSERT(VFS_I(ip)->i_mode != 0);
> @@ -1980,29 +2059,17 @@ xfs_iunlink(
>  	}
>  
>  	if (next_agino != NULLAGINO) {
> +		xfs_agino_t	old_agino;
> +
>  		/*
>  		 * There is already another inode in the bucket we need
>  		 * to add ourselves to.  Add us at the front of the list.
> -		 * Here we put the head pointer into our next pointer,
> -		 * and then we fall through to point the head at us.
>  		 */
> -		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
> -				       0, 0);
> +		error = xfs_iunlink_update_inode(tp, ip, next_agino,
> +				&old_agino);

What's left of the comment above seems a bit misleading wrt to what
we're doing here. Could we say something like "point this inode to the
current head of the list" instead of "add us to the front of the list?"

>  		if (error)
>  			goto out_unlock;
> -
> -		ASSERT(dip->di_next_unlinked == cpu_to_be32(NULLAGINO));
> -		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
> -		offset = ip->i_imap.im_boffset +
> -			offsetof(xfs_dinode_t, di_next_unlinked);
> -
> -		/* need to recalc the inode CRC if appropriate */
> -		xfs_dinode_calc_crc(mp, dip);
> -
> -		xfs_trans_inode_buf(tp, ibp);
> -		xfs_trans_log_buf(tp, ibp, offset,
> -				  (offset + sizeof(xfs_agino_t) - 1));
> -		xfs_inobp_check(mp, ibp);
> +		ASSERT(old_agino == NULLAGINO);
>  	}
>  
>  	/* Point the head of the list to point to this inode. */
> @@ -2027,9 +2094,7 @@ xfs_iunlink_remove(
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_agi		*agi;
> -	struct xfs_dinode	*dip;
>  	struct xfs_buf		*agibp;
> -	struct xfs_buf		*ibp;
>  	struct xfs_buf		*last_ibp;
>  	struct xfs_dinode	*last_dip = NULL;
>  	struct xfs_perag	*pag;
> @@ -2038,8 +2103,6 @@ xfs_iunlink_remove(
>  	xfs_agino_t		agino;
>  	xfs_agino_t		next_agino;
>  	short			bucket_index;
> -	int			offset;
> -	int			last_offset = 0;
>  	int			error;
>  
>  	if (!xfs_verify_ino(mp, ip->i_ino))
> @@ -2076,34 +2139,11 @@ xfs_iunlink_remove(
>  		/*
>  		 * We're at the head of the list.  Get the inode's on-disk
>  		 * buffer to see if there is anyone after us on the list.
> -		 * Only modify our next pointer if it is not already NULLAGINO.
> -		 * This saves us the overhead of dealing with the buffer when
> -		 * there is no need to change it.
>  		 */
> -		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
> -				       0, 0);
> -		if (error) {
> -			xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
> -				__func__, error);
> +		error = xfs_iunlink_update_inode(tp, ip, NULLAGINO,
> +				&next_agino);
> +		if (error)
>  			goto out_unlock;
> -		}
> -		next_agino = be32_to_cpu(dip->di_next_unlinked);
> -		ASSERT(next_agino != 0);
> -		if (next_agino != NULLAGINO) {
> -			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
> -			offset = ip->i_imap.im_boffset +
> -				offsetof(xfs_dinode_t, di_next_unlinked);
> -
> -			/* need to recalc the inode CRC if appropriate */
> -			xfs_dinode_calc_crc(mp, dip);
> -
> -			xfs_trans_inode_buf(tp, ibp);
> -			xfs_trans_log_buf(tp, ibp, offset,
> -					  (offset + sizeof(xfs_agino_t) - 1));
> -			xfs_inobp_check(mp, ibp);
> -		} else {
> -			xfs_trans_brelse(tp, ibp);
> -		}
>  
>  		/* Point the head of the list to the next unlinked inode. */
>  		error = xfs_iunlink_update_bucket(tp, agibp, bucket_index,
> @@ -2111,13 +2151,13 @@ xfs_iunlink_remove(
>  		if (error)
>  			goto out_unlock;
>  	} else {
> +		struct xfs_imap	imap;
> +
>  		/*
>  		 * We need to search the list for the inode being freed.
>  		 */
>  		last_ibp = NULL;
>  		while (next_agino != agino) {
> -			struct xfs_imap	imap;
> -
>  			if (last_ibp)
>  				xfs_trans_brelse(tp, last_ibp);
>  
> @@ -2141,7 +2181,6 @@ xfs_iunlink_remove(
>  				goto out_unlock;
>  			}
>  
> -			last_offset = imap.im_boffset;
>  			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
>  			if (!xfs_verify_agino(mp, agno, next_agino)) {
>  				XFS_CORRUPTION_ERROR(__func__,
> @@ -2156,45 +2195,14 @@ xfs_iunlink_remove(
>  		 * Now last_ibp points to the buffer previous to us on the
>  		 * unlinked list.  Pull us from the list.
>  		 */
> -		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
> -				       0, 0);
> -		if (error) {
> -			xfs_warn(mp, "%s: xfs_imap_to_bp(2) returned error %d.",
> -				__func__, error);
> +		error = xfs_iunlink_update_inode(tp, ip, NULLAGINO,
> +				&next_agino);
> +		if (error)
>  			goto out_unlock;

It looks like the above _update_inode() call is now common across both
branches. We might be able to factor that out a bit further so the
if/else just determines whether we update the bucket or a previous
dinode.

Brian

> -		}
> -		next_agino = be32_to_cpu(dip->di_next_unlinked);
> -		ASSERT(next_agino != 0);
> -		ASSERT(next_agino != agino);
> -		if (next_agino != NULLAGINO) {
> -			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
> -			offset = ip->i_imap.im_boffset +
> -				offsetof(xfs_dinode_t, di_next_unlinked);
> -
> -			/* need to recalc the inode CRC if appropriate */
> -			xfs_dinode_calc_crc(mp, dip);
> -
> -			xfs_trans_inode_buf(tp, ibp);
> -			xfs_trans_log_buf(tp, ibp, offset,
> -					  (offset + sizeof(xfs_agino_t) - 1));
> -			xfs_inobp_check(mp, ibp);
> -		} else {
> -			xfs_trans_brelse(tp, ibp);
> -		}
> -		/*
> -		 * Point the previous inode on the list to the next inode.
> -		 */
> -		last_dip->di_next_unlinked = cpu_to_be32(next_agino);
> -		ASSERT(next_agino != 0);
> -		offset = last_offset + offsetof(xfs_dinode_t, di_next_unlinked);
> -
> -		/* need to recalc the inode CRC if appropriate */
> -		xfs_dinode_calc_crc(mp, last_dip);
>  
> -		xfs_trans_inode_buf(tp, last_ibp);
> -		xfs_trans_log_buf(tp, last_ibp, offset,
> -				  (offset + sizeof(xfs_agino_t) - 1));
> -		xfs_inobp_check(mp, last_ibp);
> +		/* Point the previous inode on the list to the next inode. */
> +		xfs_iunlink_update_dinode(tp, last_ibp, last_dip, &imap,
> +				next_ino, next_agino);
>  	}
>  	pag->pagi_unlinked_count--;
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index c10478e7e49a..fbec8f0e1a9a 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3397,6 +3397,32 @@ TRACE_EVENT(xfs_iunlink_update_bucket,
>  		  __entry->new_ptr)
>  );
>  
> +TRACE_EVENT(xfs_iunlink_update_dinode,
> +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agino_t agino,
> +		 xfs_agino_t old_ptr, xfs_agino_t new_ptr),
> +	TP_ARGS(mp, agno, agino, old_ptr, new_ptr),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agino_t, agino)
> +		__field(xfs_agino_t, old_ptr)
> +		__field(xfs_agino_t, new_ptr)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->agno = agno;
> +		__entry->agino = agino;
> +		__entry->old_ptr = old_ptr;
> +		__entry->new_ptr = new_ptr;
> +	),
> +	TP_printk("dev %d:%d agno %u agino 0x%x old 0x%x new 0x%x",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->agno,
> +		  __entry->agino,
> +		  __entry->old_ptr,
> +		  __entry->new_ptr)
> +);
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 
