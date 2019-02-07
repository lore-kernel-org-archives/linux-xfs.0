Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbfBGObT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 09:31:19 -0500
Date: Thu, 7 Feb 2019 09:31:15 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 9/9] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190207143114.GB2880@bfoster>
References: <154947207759.22369.11575570374120223292.stgit@magnolia>
 <154947213625.22369.7330296004413590907.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154947213625.22369.7330296004413590907.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 06, 2019 at 08:55:36AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use a rhashtable to cache the unlinked list incore.  This should speed
> up unlinked processing considerably when there are a lot of inodes on
> the unlinked list because iunlink_remove no longer has to traverse an
> entire bucket list to find which inode points to the one being removed.
> 
> The incore list structure records "X.next_unlinked = Y" relations, with
> the rhashtable using Y to index the records.  This makes finding the
> inode X that points to a inode Y very quick.  If our cache fails to find
> anything we can always fall back on the old method.
> 
> FWIW this drastically reduces the amount of time it takes to remove
> inodes from the unlinked list.  I wrote a program to open a lot of
> O_TMPFILE files and then close them in the same order, which takes
> a very long time if we have to traverse the unlinked lists.  With the
> ptach, I see:
> 
...
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

A few minor comments below. With those addressed, this otherwise looks
pretty good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_errortag.h |    4 -
>  fs/xfs/xfs_error.c           |    3 
>  fs/xfs/xfs_inode.c           |  269 +++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_inode.h           |    3 
>  fs/xfs/xfs_mount.c           |    5 +
>  fs/xfs/xfs_mount.h           |    7 +
>  fs/xfs/xfs_trace.h           |    1 
>  7 files changed, 285 insertions(+), 7 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 53a9c8c26d18..fdfcb3a9bac7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1906,6 +1906,194 @@ xfs_inactive(
>  	xfs_qm_dqdetach(ip);
>  }
>  
...
> +/*
> + * Remember that @prev_agino.next_unlinked = @this_agino.  Fail loudly if there
> + * already was an entry, but absorb any other runtime errors.
> + */
> +int
> +xfs_iunlink_add_backref(
> +	struct xfs_perag	*pag,
> +	xfs_agino_t		prev_agino,
> +	xfs_agino_t		this_agino)
> +{
> +	struct xfs_iunlink	*iu;
> +	int			error;
> +
> +	if (XFS_TEST_ERROR(false, pag->pag_mount, XFS_ERRTAG_IUNLINK_FALLBACK))
> +		return 0;
> +
> +	iu = kmem_zalloc(sizeof(*iu), KM_SLEEP | KM_NOFS);
> +	iu->iu_agino = prev_agino;
> +	iu->iu_next_unlinked = this_agino;
> +
> +	error = rhashtable_insert_fast(&pag->pagi_unlinked_hash,
> +			&iu->iu_rhash_head, xfs_iunlink_hash_params);
> +	if (error == 0 || error == -EEXIST)
> +		return error;
> +	return 0;

The return val looks funny at a glance: return -EEXIST or otherwise
return 0 for success and all other errors (also the error == 0 looks
superfluous). I see the comment above describes what this does, but it
doesn't explain why. I'd move the comment to above the if check and
explain why it's there (i.e., "Absorb all runtime errors besides -EEXIST
because fallback blah blah. We care about -EEXIST because ...").

Also I assume we need to free the iu object on insert failure,
regardless of whether we ultimately return the error.

> +}
> +
> +/*
> + * Replace X.next_unlinked = @agino with X.next_unlinked = @next_unlinked.
> + * If @next_unlinked is NULLAGINO, we drop the backref and exit.  If there
> + * wasn't any such entry then we don't bother.
> + */
> +int
> +xfs_iunlink_change_backref(
> +	struct xfs_perag	*pag,
> +	xfs_agino_t		agino,
> +	xfs_agino_t		next_unlinked)
> +{
> +	struct xfs_iunlink	*iu;
> +	int			error;
> +
> +	/* Look up the old entry; if there wasn't one then exit. */
> +	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &agino,
> +			xfs_iunlink_hash_params);
> +	if (!iu)
> +		return 0;
> +
> +	/*
> +	 * Remove the entry.  This shouldn't ever return an error, but if we
> +	 * couldn't remove the old entry we don't want to add it again to the
> +	 * hash table, and if the entry disappeared on us then someone's
> +	 * violated the locking rules and we need to fail loudly.
> +	 */
> +	error = rhashtable_remove_fast(&pag->pagi_unlinked_hash,
> +			&iu->iu_rhash_head, xfs_iunlink_hash_params);
> +	if (error)
> +		return error;

What's interesting about remove failure is that if we otherwise found an
iu for this inode, removing the inode from the unlinked list leaves a
stale/incorrect iu around in the in-core table. So it's one thing for
the in-core table to be a valid subset of the on-disk structures, but
another thing entirely to have incoherence between the two. It might be
worth pointing out that it's critical to return an error here so we
don't actually remove the inode (whereas the re-add below is less
strict).

> +
> +	/* If there is no new next entry just free our item and return. */
> +	if (next_unlinked == NULLAGINO) {
> +		kmem_free(iu);
> +		return 0;
> +	}
> +
> +	/*
> +	 * Update the hash table to the new entry, ignoring operational
> +	 * errors.
> +	 */
> +	iu->iu_next_unlinked = next_unlinked;
> +	error = rhashtable_insert_fast(&pag->pagi_unlinked_hash,
> +			&iu->iu_rhash_head, xfs_iunlink_hash_params);
> +	if (error == 0 || error == -EEXIST)
> +		return error;
> +	return 0;

Similar error == 0 thing and potential memory leak here.

> +}
> +
...
> @@ -2141,6 +2341,27 @@ xfs_iunlink_map_prev(
>  
>  	ASSERT(head_agino != target_agino);
>  
> +	/* See if our backref cache can find it faster. */
> +	*agino = xfs_iunlink_lookup_backref(pag, target_agino);
> +	if (*agino != NULLAGINO) {
> +		error = xfs_iunlink_map_ino(tp, agno, *agino, imap, dipp, bpp);
> +		if (error)
> +			return error;
> +
> +		if (be32_to_cpu((*dipp)->di_next_unlinked) == target_agino)
> +			return 0;
> +
> +		/*
> +		 * If we get here the cache contents were corrupt, so drop the
> +		 * buffer and fall back to walking the bucket list.
> +		 */
> +		xfs_trans_brelse(tp, *bpp);
> +		*bpp = NULL;

I like the logic to ensure we don't screw around with an inode that
doesn't actually point to our target, but I do wonder whether we should
do a little more than silently ignore the fact we found an incoherent
backref. Even just a WARN_ON[_ONCE]() or something here to help us
detect this case during testing might be sufficient..?

Brian

> +	}
> +
> +	trace_xfs_iunlink_map_prev_fallback(mp, agno);
> +
> +	/* Otherwise, walk the entire bucket until we find it. */
>  	next_agino = head_agino;
>  	while (next_agino != target_agino) {
>  		xfs_agino_t	unlinked_agino;
> @@ -2186,6 +2407,7 @@ xfs_iunlink_remove(
>  	struct xfs_buf		*agibp;
>  	struct xfs_buf		*last_ibp = NULL;
>  	struct xfs_dinode	*last_dip = NULL;
> +	struct xfs_perag	*pag = NULL;
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agino_t		next_agino;
> @@ -2221,27 +2443,62 @@ xfs_iunlink_remove(
>  	if (error)
>  		return error;
>  
> +	/*
> +	 * If there was a backref pointing from the next inode back to this
> +	 * one, remove it because we've removed this inode from the list.
> +	 *
> +	 * Later, if this inode was in the middle of the list we'll update
> +	 * this inode's backref to point from the next inode.
> +	 */
> +	if (next_agino != NULLAGINO) {
> +		pag = xfs_perag_get(mp, agno);
> +		error = xfs_iunlink_change_backref(pag, next_agino,
> +				NULLAGINO);
> +		if (error)
> +			goto out;
> +	}
> +
>  	if (head_agino == agino) {
>  		/* Point the head of the list to the next unlinked inode. */
>  		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
>  				next_agino);
>  		if (error)
> -			return error;
> +			goto out;
>  	} else {
>  		struct xfs_imap	imap;
>  		xfs_agino_t	prev_agino;
>  
> +		if (!pag)
> +			pag = xfs_perag_get(mp, agno);
> +
>  		/* We need to search the list for the inode being freed. */
>  		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
> -				&prev_agino, &imap, &last_dip, &last_ibp);
> +				&prev_agino, &imap, &last_dip, &last_ibp,
> +				pag);
>  		if (error)
> -			return error;
> +			goto out;
>  
>  		/* Point the previous inode on the list to the next inode. */
>  		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
>  				last_dip, &imap, next_agino);
> +
> +		/*
> +		 * Now we deal with the backref for this inode.  If this inode
> +		 * pointed at a real inode, change the backref that pointed to
> +		 * us to point to our old next.  If this inode was the end of
> +		 * the list, delete the backref that pointed to us.  Note that
> +		 * change_backref takes care of deleting the backref if
> +		 * next_agino is NULLAGINO.
> +		 */
> +		error = xfs_iunlink_change_backref(pag, agino, next_agino);
> +		if (error)
> +			goto out;
>  	}
> -	return 0;
> +
> +out:
> +	if (pag)
> +		xfs_perag_put(pag);
> +	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index be2014520155..e62074a5257c 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -500,4 +500,7 @@ extern struct kmem_zone	*xfs_inode_zone;
>  
>  bool xfs_inode_verify_forks(struct xfs_inode *ip);
>  
> +int xfs_iunlink_init(struct xfs_perag *pag);
> +void xfs_iunlink_destroy(struct xfs_perag *pag);
> +
>  #endif	/* __XFS_INODE_H__ */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index b4d8c318be3c..fd63b0b1307c 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -149,6 +149,7 @@ xfs_free_perag(
>  		spin_unlock(&mp->m_perag_lock);
>  		ASSERT(pag);
>  		ASSERT(atomic_read(&pag->pag_ref) == 0);
> +		xfs_iunlink_destroy(pag);
>  		xfs_buf_hash_destroy(pag);
>  		mutex_destroy(&pag->pag_ici_reclaim_lock);
>  		call_rcu(&pag->rcu_head, __xfs_free_perag);
> @@ -227,6 +228,9 @@ xfs_initialize_perag(
>  		/* first new pag is fully initialized */
>  		if (first_initialised == NULLAGNUMBER)
>  			first_initialised = index;
> +		error = xfs_iunlink_init(pag);
> +		if (error)
> +			goto out_hash_destroy;
>  	}
>  
>  	index = xfs_set_inode_alloc(mp, agcount);
> @@ -249,6 +253,7 @@ xfs_initialize_perag(
>  		if (!pag)
>  			break;
>  		xfs_buf_hash_destroy(pag);
> +		xfs_iunlink_destroy(pag);
>  		mutex_destroy(&pag->pag_ici_reclaim_lock);
>  		kmem_free(pag);
>  	}
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 7daafe064af8..a33f45077867 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -396,6 +396,13 @@ typedef struct xfs_perag {
>  
>  	/* reference count */
>  	uint8_t			pagf_refcount_level;
> +
> +	/*
> +	 * Unlinked inode information.  This incore information reflects
> +	 * data stored in the AGI, so callers must hold the AGI buffer lock
> +	 * or have some other means to control concurrency.
> +	 */
> +	struct rhashtable	pagi_unlinked_hash;
>  } xfs_perag_t;
>  
>  static inline struct xfs_ag_resv *
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a6e384a642b1..c83ce022a355 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3447,6 +3447,7 @@ DEFINE_EVENT(xfs_ag_inode_class, name, \
>  	TP_ARGS(ip))
>  DEFINE_AGINODE_EVENT(xfs_iunlink);
>  DEFINE_AGINODE_EVENT(xfs_iunlink_remove);
> +DEFINE_AG_EVENT(xfs_iunlink_map_prev_fallback);
>  
>  #endif /* _TRACE_XFS_H */
>  
> 
