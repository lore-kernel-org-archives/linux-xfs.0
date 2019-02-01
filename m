Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbfBAT3F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 14:29:05 -0500
Date: Fri, 1 Feb 2019 14:29:02 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/8] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190201192902.GG31203@bfoster>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897672012.26065.1375987197453969157.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154897672012.26065.1375987197453969157.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 03:18:40PM -0800, Darrick J. Wong wrote:
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
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

I still need to take a closer look at this one, but I want to make sure
I grok what's happening from the unlinked list perspective...

>  fs/xfs/xfs_inode.c       |  216 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h       |   10 ++
>  fs/xfs/xfs_log_recover.c |   12 ++-
>  fs/xfs/xfs_mount.c       |    7 +
>  fs/xfs/xfs_mount.h       |    1 
>  5 files changed, 245 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 56349497d75b..eec3c6109fc6 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
...
> @@ -2072,6 +2255,9 @@ xfs_iunlink(
>  		if (error)
>  			goto out_unlock;
>  		ASSERT(old_agino == NULLAGINO);
> +		error = xfs_iunlink_add_backref(pag, agino, next_agino);
> +		if (error)
> +			goto out_unlock;

agino has been unlinked, add a backref from the next inode (i.e., we
point to) back to agino.

>  	}
>  
>  	/* Point the head of the list to point to this inode. */
> @@ -2144,6 +2330,17 @@ xfs_iunlink_map_prev(
>  
>  	ASSERT(head_agino != target_agino);
>  
> +	/* See if our backref cache can find it faster. */
> +	error = xfs_iunlink_lookup_backref(pag, target_agino, &next_agino);
> +	if (error == 0) {
> +		next_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
> +		error = xfs_iunlink_map_ino(tp, next_ino, &last_imap,
> +				&last_dip, &last_ibp);
> +		if (error)
> +			return error;
> +		goto out;
> +	}
> +
>  	next_agino = head_agino;
>  	while (next_agino != target_agino) {
>  		xfs_agino_t	unlinked_agino;
> @@ -2169,6 +2366,7 @@ xfs_iunlink_map_prev(
>  		next_agino = unlinked_agino;
>  	}
>  
> +out:
>  	/* Should never happen, but don't return garbage. */
>  	if (next_ino == NULLFSINO)
>  		return -EFSCORRUPTED;
> @@ -2243,6 +2441,12 @@ xfs_iunlink_remove(
>  		if (error)
>  			goto out_unlock;
>  
> +		if (next_agino != NULLAGINO) {
> +			error = xfs_iunlink_forget_backref(pag, next_agino);
> +			if (error)
> +				goto out_unlock;
> +		}

Removed from the head. We thus had no inode pointing to us, but the next
record had a ref that we pointed to it. Drop that since we're gone and
that inode is now the head.

> +
>  		/* Point the head of the list to the next unlinked inode. */
>  		error = xfs_iunlink_update_bucket(tp, agibp, bucket_index,
>  				next_agino);
> @@ -2265,10 +2469,22 @@ xfs_iunlink_remove(
>  				&next_agino);
>  		if (error)
>  			goto out_unlock;
> +		if (next_agino != NULLAGINO) {
> +			error = xfs_iunlink_forget_backref(pag, next_agino);
> +			if (error)
> +				goto out_unlock;
> +		}

Removed from the middle. next_agino had a backref to us, so we drop that
since we're going away.

>  
>  		/* Point the previous inode on the list to the next inode. */
>  		xfs_iunlink_update_dinode(tp, last_ibp, last_dip, &imap,
>  				next_ino, next_agino);
> +		if (next_agino == NULLAGINO)
> +			error = xfs_iunlink_forget_backref(pag, agino);
> +		else
> +			error = xfs_iunlink_change_backref(pag, agino,
> +					next_agino);

Now we deal with the backref for us (i.e., to whatever pointed at us and
now points at something else). If it now points at a real inode, change
the ref that pointed to us to point to our old next. If it doesn't,
delete the ref that pointed to us. Am I following that correctly?

Hmm, I realize this may be what's happening behind these wrappers, but
I'm wondering if the logic at this level would be easier to grok if we
just dropped the backref that points to our ip (IIUC we should always
have one here), if we point to something, drop the backref for that and
then add a new one for the prev->next link we've just created.

But I still need to take a closer look at all of this... it might be
more clear with some comments.

Brian

> +		if (error)
> +			goto out_unlock;
>  	}
>  	pag->pagi_unlinked_count--;
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index be2014520155..9690f0d32e33 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -500,4 +500,14 @@ extern struct kmem_zone	*xfs_inode_zone;
>  
>  bool xfs_inode_verify_forks(struct xfs_inode *ip);
>  
> +int xfs_iunlink_init(struct xfs_perag *pag);
> +void xfs_iunlink_destroy(struct xfs_perag *pag);
> +int xfs_iunlink_lookup_backref(struct xfs_perag *pag, xfs_agino_t agino,
> +		xfs_agino_t *prev_agino);
> +int xfs_iunlink_add_backref(struct xfs_perag *pag, xfs_agino_t prev_agino,
> +		xfs_agino_t this_agino);
> +int xfs_iunlink_forget_backref(struct xfs_perag *pag, xfs_agino_t agino);
> +int xfs_iunlink_change_backref(struct xfs_perag *pag, xfs_agino_t prev_agino,
> +		xfs_agino_t this_agino);
> +
>  #endif	/* __XFS_INODE_H__ */
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index c920b8aeba01..909b70550aa8 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -5078,12 +5078,22 @@ xlog_recover_process_one_iunlink(
>  	agino = be32_to_cpu(dip->di_next_unlinked);
>  	xfs_buf_relse(ibp);
>  
> -	/* Make sure the in-core data knows about this unlinked inode. */
> +	/*
> +	 * Make sure the in-core data knows about this unlinked inode.  Since
> +	 * our iunlinks recovery basically just deletes the head of a bucket
> +	 * list until the bucket is empty, we need only to add the backref from
> +	 * the current list item to the next one, if this isn't the list tail.
> +	 */
>  	pag = xfs_perag_get(mp, agno);
>  	mutex_lock(&pag->pagi_unlinked_lock);
>  	pag->pagi_unlinked_count++;
> +	if (agino != NULLAGINO)
> +		error = xfs_iunlink_add_backref(pag, XFS_INO_TO_AGINO(mp, ino),
> +				agino);
>  	mutex_unlock(&pag->pagi_unlinked_lock);
>  	xfs_perag_put(pag);
> +	if (error)
> +		goto fail_iput;
>  
>  	/*
>  	 * Prevent any DMAPI event from being sent when the reference on
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 6bfc985669e0..4eb97ddc915e 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -151,6 +151,7 @@ xfs_free_perag(
>  		ASSERT(atomic_read(&pag->pag_ref) == 0);
>  		ASSERT(pag->pagi_unlinked_count == 0 ||
>  		       XFS_FORCED_SHUTDOWN(mp));
> +		xfs_iunlink_destroy(pag);
>  		mutex_destroy(&pag->pagi_unlinked_lock);
>  		xfs_buf_hash_destroy(pag);
>  		mutex_destroy(&pag->pag_ici_reclaim_lock);
> @@ -231,6 +232,9 @@ xfs_initialize_perag(
>  		if (first_initialised == NULLAGNUMBER)
>  			first_initialised = index;
>  		mutex_init(&pag->pagi_unlinked_lock);
> +		error = xfs_iunlink_init(pag);
> +		if (error)
> +			goto out_iunlink_mutex;
>  	}
>  
>  	index = xfs_set_inode_alloc(mp, agcount);
> @@ -241,6 +245,8 @@ xfs_initialize_perag(
>  	mp->m_ag_prealloc_blocks = xfs_prealloc_blocks(mp);
>  	return 0;
>  
> +out_iunlink_mutex:
> +	mutex_destroy(&pag->pagi_unlinked_lock);
>  out_hash_destroy:
>  	xfs_buf_hash_destroy(pag);
>  out_free_pag:
> @@ -253,6 +259,7 @@ xfs_initialize_perag(
>  		if (!pag)
>  			break;
>  		xfs_buf_hash_destroy(pag);
> +		xfs_iunlink_destroy(pag);
>  		mutex_destroy(&pag->pagi_unlinked_lock);
>  		mutex_destroy(&pag->pag_ici_reclaim_lock);
>  		kmem_free(pag);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 0fcc6b6a4f67..27a433e93d32 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -392,6 +392,7 @@ typedef struct xfs_perag {
>  	/* unlinked inodes */
>  	struct mutex		pagi_unlinked_lock;
>  	uint32_t		pagi_unlinked_count;
> +	struct rhashtable	pagi_unlinked_hash;
>  } xfs_perag_t;
>  
>  static inline struct xfs_ag_resv *
> 
