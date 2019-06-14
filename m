Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbfFNOE0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 10:04:26 -0400
Date: Fri, 14 Jun 2019 10:04:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 10/14] xfs: refactor xfs_iwalk_grab_ichunk
Message-ID: <20190614140423.GB26586@bfoster>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
 <156032211661.3774243.18392356280083221766.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156032211661.3774243.18392356280083221766.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 11:48:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In preparation for reusing the iwalk code for the inogrp walking code
> (aka INUMBERS), move the initial inobt lookup and retrieval code out of
> xfs_iwalk_grab_ichunk so that we call the masking code only when we need
> to trim out the inodes that came before the cursor in the inobt record
> (aka BULKSTAT).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iwalk.c |   79 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 39 insertions(+), 40 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index a2102fa94ff5..8c4d7e59f86a 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -98,43 +98,17 @@ xfs_iwalk_ichunk_ra(
>  }
>  
>  /*
> - * Lookup the inode chunk that the given @agino lives in and then get the
> - * record if we found the chunk.  Set the bits in @irec's free mask that
> - * correspond to the inodes before @agino so that we skip them.  This is how we
> - * restart an inode walk that was interrupted in the middle of an inode record.
> + * Set the bits in @irec's free mask that correspond to the inodes before
> + * @agino so that we skip them.  This is how we restart an inode walk that was
> + * interrupted in the middle of an inode record.
>   */
> -STATIC int
> -xfs_iwalk_grab_ichunk(
> -	struct xfs_btree_cur		*cur,	/* btree cursor */
> +STATIC void
> +xfs_iwalk_adjust_start(
>  	xfs_agino_t			agino,	/* starting inode of chunk */
> -	int				*icount,/* return # of inodes grabbed */
>  	struct xfs_inobt_rec_incore	*irec)	/* btree record */
>  {
>  	int				idx;	/* index into inode chunk */
> -	int				stat;
>  	int				i;
> -	int				error = 0;
> -
> -	/* Lookup the inode chunk that this inode lives in */
> -	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &stat);
> -	if (error)
> -		return error;
> -	if (!stat) {
> -		*icount = 0;
> -		return error;
> -	}
> -
> -	/* Get the record, should always work */
> -	error = xfs_inobt_get_rec(cur, irec, &stat);
> -	if (error)
> -		return error;
> -	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, stat == 1);
> -
> -	/* Check if the record contains the inode in request */
> -	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino) {
> -		*icount = 0;
> -		return 0;
> -	}
>  
>  	idx = agino - irec->ir_startino;
>  
> @@ -149,8 +123,6 @@ xfs_iwalk_grab_ichunk(
>  	}
>  
>  	irec->ir_free |= xfs_inobt_maskn(0, idx);
> -	*icount = irec->ir_count - irec->ir_freecount;
> -	return 0;
>  }
>  
>  /* Allocate memory for a walk. */
> @@ -258,7 +230,7 @@ xfs_iwalk_ag_start(
>  {
>  	struct xfs_mount	*mp = iwag->mp;
>  	struct xfs_trans	*tp = iwag->tp;
> -	int			icount;
> +	struct xfs_inobt_rec_incore *irec;
>  	int			error;
>  
>  	/* Set up a fresh cursor and empty the inobt cache. */
> @@ -274,15 +246,40 @@ xfs_iwalk_ag_start(
>  	/*
>  	 * Otherwise, we have to grab the inobt record where we left off, stuff
>  	 * the record into our cache, and then see if there are more records.
> -	 * We require a lookup cache of at least two elements so that we don't
> -	 * have to deal with tearing down the cursor to walk the records.
> +	 * We require a lookup cache of at least two elements so that the
> +	 * caller doesn't have to deal with tearing down the cursor to walk the
> +	 * records.
>  	 */
> -	error = xfs_iwalk_grab_ichunk(*curpp, agino, &icount,
> -			&iwag->recs[iwag->nr_recs]);
> +	error = xfs_inobt_lookup(*curpp, agino, XFS_LOOKUP_LE, has_more);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * If the LE lookup at @agino yields no records, jump ahead to the
> +	 * inobt cursor increment to see if there are more records to process.
> +	 */
> +	if (!*has_more)
> +		goto out_advance;
> +
> +	/* Get the record, should always work */
> +	irec = &iwag->recs[iwag->nr_recs];
> +	error = xfs_inobt_get_rec(*curpp, irec, has_more);
>  	if (error)
>  		return error;
> -	if (icount)
> -		iwag->nr_recs++;
> +	XFS_WANT_CORRUPTED_RETURN(mp, *has_more == 1);
> +
> +	/*
> +	 * If the LE lookup yielded an inobt record before the cursor position,
> +	 * skip it and see if there's another one after it.
> +	 */
> +	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino)
> +		goto out_advance;
> +
> +	/*
> +	 * If agino fell in the middle of the inode record, make it look like
> +	 * the inodes up to agino are free so that we don't return them again.
> +	 */
> +	xfs_iwalk_adjust_start(agino, irec);
>  
>  	/*
>  	 * set_prefetch is supposed to give us a large enough inobt record
> @@ -290,8 +287,10 @@ xfs_iwalk_ag_start(
>  	 * body can cache a record without having to check for cache space
>  	 * until after it reads an inobt record.
>  	 */
> +	iwag->nr_recs++;
>  	ASSERT(iwag->nr_recs < iwag->sz_recs);
>  
> +out_advance:
>  	return xfs_btree_increment(*curpp, 0, has_more);
>  }
>  
> 
