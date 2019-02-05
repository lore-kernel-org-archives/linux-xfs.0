Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35822 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfBETUO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Feb 2019 14:20:14 -0500
Date: Tue, 5 Feb 2019 11:20:06 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/10] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190205192006.GL7991@magnolia>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930320519.31814.7868551876308474527.stgit@magnolia>
 <20190205142458.GD51421@bfoster>
 <20190205175309.GJ7991@magnolia>
 <20190205190626.GF51421@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205190626.GF51421@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 05, 2019 at 02:06:27PM -0500, Brian Foster wrote:
> On Tue, Feb 05, 2019 at 09:53:09AM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 05, 2019 at 09:24:59AM -0500, Brian Foster wrote:
> > > On Mon, Feb 04, 2019 at 10:00:05AM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Use a rhashtable to cache the unlinked list incore.  This should speed
> > > > up unlinked processing considerably when there are a lot of inodes on
> > > > the unlinked list because iunlink_remove no longer has to traverse an
> > > > entire bucket list to find which inode points to the one being removed.
> > > > 
> > > > The incore list structure records "X.next_unlinked = Y" relations, with
> > > > the rhashtable using Y to index the records.  This makes finding the
> > > > inode X that points to a inode Y very quick.  If our cache fails to find
> > > > anything we can always fall back on the old method.
> > > > 
> > > > FWIW this drastically reduces the amount of time it takes to remove
> > > > inodes from the unlinked list.  I wrote a program to open a lot of
> > > > O_TMPFILE files and then close them in the same order, which takes
> > > > a very long time if we have to traverse the unlinked lists.  With the
> > > > ptach, I see:
> > > > 
> > > ...
> > > > ---
> > > >  fs/xfs/xfs_inode.c       |  207 ++++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/xfs_inode.h       |    9 ++
> > > >  fs/xfs/xfs_log_recover.c |   12 ++-
> > > >  fs/xfs/xfs_mount.c       |    5 +
> > > >  fs/xfs/xfs_mount.h       |    1 
> > > >  5 files changed, 233 insertions(+), 1 deletion(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > index b9696d762c8f..baee8c894447 100644
> > > > --- a/fs/xfs/xfs_inode.c
> > > > +++ b/fs/xfs/xfs_inode.c
> > > > @@ -1880,6 +1880,167 @@ xfs_inactive(
> > > >  	xfs_qm_dqdetach(ip);
> > > >  }
> > > >  
> > > ...
> > > > +
> > > > +static const struct rhashtable_params xfs_iunlink_hash_params = {
> > > > +	.min_size		= XFS_AGI_UNLINKED_BUCKETS,
> > > > +	.nelem_hint		= 512,
> > > 
> > > Any reasoning behind the 512 value? It seems rather large to me, at
> > > least until we get more into deferred inactivation and whatnot. It looks
> > > like the rhashtable code will round this up to 1024 as well, FWIW.
> > > 
> > > I'm also wondering whether a kmem_zone might be worthwhile for
> > > xfs_iunlink structures, but that's probably also more for when we expect
> > > to drive deeper unlinked lists.
> > 
> > I picked an arbitrary value of 64 buckets * 8 items per list.  I /do/
> > have plans to test various values to see if there's a particular sweet
> > spot, though I guess this could be much lower on the assumption that
> > we don't expect /that/ many unlinked inodes(?)
> > 
> 
> Ok. To be clear, I don't really have any insight as to what a good value
> is, I was just curious where 512 came from. 8 items per bucket sounds
> more reasonable when you frame it that way. This only looked like an 8k
> or so allocation in the hashtable code, which seems reasonable, but then
> again this is a per-ag allocation.

Good point, we should keep our rhashtable heads smaller than a page.
I'll turn this down to 256.  FWIW I tried exercising 64 -> 128 -> 256 ->
512 -> 1024 (factoring in the 4/3 thing) and it didn't really seem to
make much of a difference.

> Hmm, I suppose if you just include something like a /* 64 buckets * 8
> items per list */ comment on that line so it's clear where the number
> comes from and then verify this doesn't cause a mount of an fs with some
> absurd number of AGs to fall over or steal an unreasonable amount of
> memory then it's probably fine.

Ok.

> > > > +	.key_len		= sizeof(xfs_agino_t),
> > > > +	.key_offset		= offsetof(struct xfs_iunlink, iu_next_unlinked),
> > > > +	.head_offset		= offsetof(struct xfs_iunlink, iu_rhash_head),
> > > > +	.automatic_shrinking	= true,
> > > > +	.obj_cmpfn		= xfs_iunlink_obj_cmpfn,
> > > > +};
> > > > +
> > > ...
> > > >  /*
> > > >   * Point the AGI unlinked bucket at an inode and log the results.  The caller
> > > >   * is responsible for validating the old value.
> > > > @@ -2055,6 +2216,14 @@ xfs_iunlink(
> > > >  		if (error)
> > > >  			goto out;
> > > >  		ASSERT(old_agino == NULLAGINO);
> > > > +
> > > > +		/*
> > > > +		 * agino has been unlinked, add a backref from the next inode
> > > > +		 * back to agino.
> > > > +		 */
> > > > +		error = xfs_iunlink_add_backref(pag, agino, next_agino);
> > > > +		if (error)
> > > > +			goto out;
> > > 
> > > At a glance, it looks like -ENOMEM/-EEXIST is possible from
> > > rhashtable_insert_fast(). Do we really want to translate those into a
> > > broader operational failure, or perhaps just skip the hashtable update?
> > > The latter seems more appropriate given that we already account for the
> > > possibility of a missing hashtable entry on lookup.
> > 
> > Good point, we could be much more resilient to backref cache failures
> > since we do have the option of doing it the slow way.
> > 
> > (And, I guess by extension, a debugging knob or something to disable the
> > cache so that we can test the bucket list walker...)
> > 
> 
> Good idea. An error tag on the add backref path perhaps? Then we can
> cover anything from random insertion failures to turning it off
> completely.

Ok.

--D

> Brian
> 
> > > >  	}
> > > >  
> > > >  	/* Point the head of the list to point to this inode. */
> > > > @@ -2127,6 +2296,17 @@ xfs_iunlink_map_prev(
> > > >  
> > > >  	ASSERT(head_agino != target_agino);
> > > >  
> > > > +	/* See if our backref cache can find it faster. */
> > > > +	next_agino = xfs_iunlink_lookup_backref(pag, target_agino);
> > > > +	if (next_agino != NULLAGINO) {
> > > > +		next_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
> > > > +		error = xfs_iunlink_map_ino(tp, next_ino, imap, &last_dip,
> > > > +				&last_ibp);
> > > > +		if (error)
> > > > +			return error;
> > > 
> > > Could we assert or somehow or another verify that
> > > last_dip->di_next_unlinked points at target_agino before we proceed?
> > 
> > Ok.
> > 
> > > > +		goto out;
> > > > +	}
> > > > +
> > > >  	next_agino = head_agino;
> > > >  	while (next_agino != target_agino) {
> > > >  		xfs_agino_t	unlinked_agino;
> > > > @@ -2156,6 +2336,7 @@ xfs_iunlink_map_prev(
> > > >  		next_agino = unlinked_agino;
> > > >  	}
> > > >  
> > > > +out:
> > > >  	/* Should never happen, but don't return garbage. */
> > > >  	if (next_ino == NULLFSINO)
> > > >  		return -EFSCORRUPTED;
> > > > @@ -2218,6 +2399,20 @@ xfs_iunlink_remove(
> > > >  	if (error)
> > > >  		goto out;
> > > >  
> > > > +	/*
> > > > +	 * If there was a backref pointing from the next inode back to this
> > > > +	 * one, remove it because we've removed this inode from the list.
> > > > +	 *
> > > > +	 * Later, if this inode was in the middle of the list we'll update
> > > > +	 * this inode's backref to point from the next inode.
> > > > +	 */
> > > > +	if (next_agino != NULLAGINO) {
> > > > +		error = xfs_iunlink_change_backref(pag, next_agino,
> > > > +				NULLAGINO);
> > > > +		if (error)
> > > > +			goto out;
> > > > +	}
> > > > +
> > > >  	if (head_agino == agino) {
> > > >  		/* Point the head of the list to the next unlinked inode. */
> > > >  		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
> > > > @@ -2236,6 +2431,18 @@ xfs_iunlink_remove(
> > > >  		/* Point the previous inode on the list to the next inode. */
> > > >  		xfs_iunlink_update_dinode(tp, agno, last_ibp, last_dip, &imap,
> > > >  				prev_ino, next_agino);
> > > > +
> > > > +		/*
> > > > +		 * Now we deal with the backref for this inode.  If this inode
> > > > +		 * pointed at a real inode, change the backref that pointed to
> > > > +		 * us to point to our old next.  If this inode was the end of
> > > > +		 * the list, delete the backref that pointed to us.  Note that
> > > > +		 * change_backref takes care of deleting the backref if
> > > > +		 * next_agino is NULLAGINO.
> > > > +		 */
> > > 
> > > Thanks for the comment.
> > > 
> > > > +		error = xfs_iunlink_change_backref(pag, agino, next_agino);
> > > > +		if (error)
> > > > +			goto out;
> > > 
> > > Ok, but the whole lookup path accounts for the possibility of a missing
> > > entry and falls back to the old on-disk walk. It doesn't look like we
> > > handle that properly here. IOW, if the hashtable lookup ever fails and
> > > we do fallback as such, we're guaranteed to eventually fail here.
> > > 
> > > It seems to me we need to be extra careful so as to not turn in-core
> > > hashtable issues (whether it be external things such as -ENOENT or
> > > internal -ENOMEM or whatever) into fatal filesystem errors.
> > 
> > <nod> I'll fix this for v3 so that backref cache failures don't shut
> > down the filesystem.
> > 
> > > >  	}
> > > >  	pag->pagi_unlinked_count--;
> > > >  out:
> > > ...
> > > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > > index c634fbfea4a8..f5fb8885662f 100644
> > > > --- a/fs/xfs/xfs_log_recover.c
> > > > +++ b/fs/xfs/xfs_log_recover.c
> > > > @@ -5078,10 +5078,20 @@ xlog_recover_process_one_iunlink(
> > > >  	agino = be32_to_cpu(dip->di_next_unlinked);
> > > >  	xfs_buf_relse(ibp);
> > > >  
> > > > -	/* Make sure the in-core data knows about this unlinked inode. */
> > > > +	/*
> > > > +	 * Make sure the in-core data knows about this unlinked inode.  Since
> > > > +	 * our iunlinks recovery basically just deletes the head of a bucket
> > > > +	 * list until the bucket is empty, we need only to add the backref from
> > > > +	 * the current list item to the next one, if this isn't the list tail.
> > > > +	 */
> > > >  	pag = xfs_perag_get(mp, agno);
> > > >  	pag->pagi_unlinked_count++;
> > > > +	if (agino != NULLAGINO)
> > > > +		error = xfs_iunlink_add_backref(pag, XFS_INO_TO_AGINO(mp, ino),
> > > > +				agino);
> > > 
> > > ISTM that fixing the iunlink_remove code to not rely on hashtable
> > > entries could also alleviate the need for this hack?
> > > 
> > > >  	xfs_perag_put(pag);
> > > > +	if (error)
> > > > +		goto fail_iput;
> > > 
> > > Similar potential for error amplification here.
> > 
> > Agreed.
> > 
> > --D
> > 
> > > Brian
> > > 
> > > >  
> > > >  	/*
> > > >  	 * Prevent any DMAPI event from being sent when the reference on
> > > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > > index 6ca92a71c233..9a181f7ca1d5 100644
> > > > --- a/fs/xfs/xfs_mount.c
> > > > +++ b/fs/xfs/xfs_mount.c
> > > > @@ -151,6 +151,7 @@ xfs_free_perag(
> > > >  		ASSERT(atomic_read(&pag->pag_ref) == 0);
> > > >  		ASSERT(pag->pagi_unlinked_count == 0 ||
> > > >  		       XFS_FORCED_SHUTDOWN(mp));
> > > > +		xfs_iunlink_destroy(pag);
> > > >  		xfs_buf_hash_destroy(pag);
> > > >  		mutex_destroy(&pag->pag_ici_reclaim_lock);
> > > >  		call_rcu(&pag->rcu_head, __xfs_free_perag);
> > > > @@ -229,6 +230,9 @@ xfs_initialize_perag(
> > > >  		/* first new pag is fully initialized */
> > > >  		if (first_initialised == NULLAGNUMBER)
> > > >  			first_initialised = index;
> > > > +		error = xfs_iunlink_init(pag);
> > > > +		if (error)
> > > > +			goto out_hash_destroy;
> > > >  	}
> > > >  
> > > >  	index = xfs_set_inode_alloc(mp, agcount);
> > > > @@ -251,6 +255,7 @@ xfs_initialize_perag(
> > > >  		if (!pag)
> > > >  			break;
> > > >  		xfs_buf_hash_destroy(pag);
> > > > +		xfs_iunlink_destroy(pag);
> > > >  		mutex_destroy(&pag->pag_ici_reclaim_lock);
> > > >  		kmem_free(pag);
> > > >  	}
> > > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > > index 169069a01f3c..dcc45b441dd6 100644
> > > > --- a/fs/xfs/xfs_mount.h
> > > > +++ b/fs/xfs/xfs_mount.h
> > > > @@ -391,6 +391,7 @@ typedef struct xfs_perag {
> > > >  
> > > >  	/* unlinked inode info; lock AGI to access */
> > > >  	unsigned int		pagi_unlinked_count;
> > > > +	struct rhashtable	pagi_unlinked_hash;
> > > >  } xfs_perag_t;
> > > >  
> > > >  static inline struct xfs_ag_resv *
> > > > 
