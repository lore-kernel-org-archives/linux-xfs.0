Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751049AbdFGOWq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Jun 2017 10:22:46 -0400
Date: Wed, 7 Jun 2017 10:22:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/13] xfs: check if an inode is cached and allocated
Message-ID: <20170607142244.GC64146@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643868294.23065.8094890990886436794.stgit@birch.djwong.org>
 <20170606162813.GB55166@bfoster.bfoster>
 <20170606184006.GD5196@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606184006.GD5196@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2017 at 11:40:06AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 06, 2017 at 12:28:13PM -0400, Brian Foster wrote:
> > On Fri, Jun 02, 2017 at 02:24:43PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Check the inode cache for a particular inode number.  If it's in the
> > > cache, check that it's not currently being reclaimed.  If it's not being
> > > reclaimed, return zero if the inode is allocated.  This function will be
> > > used by various scrubbers to decide if the cache is more up to date
> > > than the disk in terms of checking if an inode is allocated.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_icache.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_icache.h |    3 ++
> > >  2 files changed, 86 insertions(+)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index f61c84f8..d610a7e 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -633,6 +633,89 @@ xfs_iget(
> > >  }
> > >  
> > >  /*
> > > + * "Is this a cached inode that's also allocated?"
> > > + *
> > > + * Look up an inode by number in the given file system.  If the inode is
> > > + * in cache and isn't in purgatory, return 1 if the inode is allocated
> > > + * and 0 if it is not.  For all other cases (not in cache, being torn
> > > + * down, etc.), return a negative error code.
> > > + *
> > > + * (The caller has to prevent inode allocation activity.)
> > > + */
> > 
> > Hmm.. so isn't the data returned here potentially invalid once we drop
> > the inode reference? In other words, couldn't an inode where we return
> > inuse == true be reclaimed immediately after? Perhaps I'm just not far
> > enough along to understand how this is used. If that's the case, a note
> > about the lifetime/rules of this value might be useful.
> 
> The comment could state more explicitly what we're assuming the caller
> has done to prevent inode allocation or freeing activity.  The scrubber
> that calls this function will have locked the AGI buffer for this AG so
> that it can compare the inobt ir_free bits against di_mode to make sure
> that there aren't any discrepancies.  Even if the inode is immediately
> reclaimed/deleted after we release the inode, the corresponding inobt
> update will block on the AGI until the scrubber finishes, so from the
> scrubber's point of view things are still consistent.  If the scrubber
> finds the inode in some intermediate state of being created or torn
> down, it doesn't bother checking the free mask on the assumption that
> the thread modifying the inode will ensure the consistency or shut down.
> 
> tldr: We assume the caller has the AGI locked so that inodes stay stable
> wrt to allocation or freeing, or only end up in an intermediate state;
> we also assume the caller can handle inodes in an intermediate state.
> 

Ok, thanks for the explanation. The bits about reclaim are still a bit
unclear to me, but that will probably make more sense when I see how
this is used.

> > FWIW, I'm also kind of wondering if rather than open code the bits of
> > the inode lookup, we could accomplish the same thing with a new flag to
> > the existing xfs_iget() lookup mechanism that implements the associated
> > semantics (i.e., don't read from disk, don't reinit, sort of a read-only
> > semantic).
> 
> Originally it was just an iget flag, but the flag ended up special
> casing a lot of the existing iget functionality.  Basically, we need to
> disable the xfs_iget_cache_miss call; avoid the out_error_or_again case;
> do our i_mode testing, release the inode, and jump out of the function
> prior to the bit that can call xfs_setup_existing_inode; and change the
> lock_flags assert to require lock_flags == 0 when we're just checking.
> 
> All that turned xfs_iget into such a muddy mess that I decided it was
> cleaner to separate this specialized case into its own function and hope
> that we're not really going to modify _iget a whole lot.
> 

Hmm, so obviously I would expect some tweaks in that code, but I'm
curious how messy it really has to be. Walking through some of the
changes...

- The lock_flags check is already conditional in the code, so I'm not
  sure we really need the assert. I'd be fine with dropping it at least
  if we had a lock_flags == 0 caller. We could alternatively adjust it
  to accommodate the new xfs_iget() flag, which might be safer.
- I'm not sure that xfs_iget() really needs to be responsible for the
  release. What about a helper function on top that actually receives
  the xfs_inode from xfs_iget() and does the resulting checks, sets
  inuse appropriately and then releases the inode?
- With the above changes, would that reduce the necessary xfs_iget()
  changes to basically skipping out in a few places? For example,
  consider an XFS_IGET_INCORE flag that skips the -EAGAIN retry, skips
  the IRECLAIMABLE reinit in _iget_cache_hit() (returns -EAGAIN) and
  returns -ENOENT rather than calling _iget_cache_miss(). The code flow
  of the helper might look something like the following:

int
xfs_icache_inode_is_allocated(
	...
	xfs_ino_t		ino,
	bool			*inuse)
{
	...

	*inuse = false;
	error = xfs_iget(..., ino, XFS_IGET_INCORE, 0, &ip);
	if (error)
		return error;

	if (<ip checks>)
		*inuse = true;

	IRELE(ip);
	return 0;
}

... and may only require fairly straightforward tweaks to xfs_iget().
Thoughts?

Brian

> Anyway, thank you for the reviewing!
> 
> --D
> 
> > 
> > Brian
> > 
> > > +int
> > > +xfs_icache_inode_is_allocated(
> > > +	struct xfs_mount	*mp,
> > > +	struct xfs_trans	*tp,
> > > +	xfs_ino_t		ino,
> > > +	bool			*inuse)
> > > +{
> > > +	struct xfs_inode	*ip;
> > > +	struct xfs_perag	*pag;
> > > +	xfs_agino_t		agino;
> > > +	int			ret = 0;
> > > +
> > > +	/* reject inode numbers outside existing AGs */
> > > +	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
> > > +		return -EINVAL;
> > > +
> > > +	/* get the perag structure and ensure that it's inode capable */
> > > +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
> > > +	agino = XFS_INO_TO_AGINO(mp, ino);
> > > +
> > > +	rcu_read_lock();
> > > +	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> > > +	if (!ip) {
> > > +		ret = -ENOENT;
> > > +		goto out;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Is the inode being reused?  Is it new?  Is it being
> > > +	 * reclaimed?  Is it being torn down?  For any of those cases,
> > > +	 * fall back.
> > > +	 */
> > > +	spin_lock(&ip->i_flags_lock);
> > > +	if (ip->i_ino != ino ||
> > > +	    (ip->i_flags & (XFS_INEW | XFS_IRECLAIM | XFS_IRECLAIMABLE))) {
> > > +		ret = -EAGAIN;
> > > +		goto out_istate;
> > > +	}
> > > +
> > > +	/*
> > > +	 * If lookup is racing with unlink, jump out immediately.
> > > +	 */
> > > +	if (VFS_I(ip)->i_mode == 0) {
> > > +		*inuse = false;
> > > +		ret = 0;
> > > +		goto out_istate;
> > > +	}
> > > +
> > > +	/* If the VFS inode is being torn down, forget it. */
> > > +	if (!igrab(VFS_I(ip))) {
> > > +		ret = -EAGAIN;
> > > +		goto out_istate;
> > > +	}
> > > +
> > > +	/* We've got a live one. */
> > > +	spin_unlock(&ip->i_flags_lock);
> > > +	rcu_read_unlock();
> > > +	xfs_perag_put(pag);
> > > +
> > > +	*inuse = !!(VFS_I(ip)->i_mode);
> > > +	ret = 0;
> > > +	IRELE(ip);
> > > +
> > > +	return ret;
> > > +
> > > +out_istate:
> > > +	spin_unlock(&ip->i_flags_lock);
> > > +out:
> > > +	rcu_read_unlock();
> > > +	xfs_perag_put(pag);
> > > +	return ret;
> > > +}
> > > +
> > > +/*
> > >   * The inode lookup is done in batches to keep the amount of lock traffic and
> > >   * radix tree lookups to a minimum. The batch size is a trade off between
> > >   * lookup reduction and stack usage. This is in the reclaim path, so we can't
> > > diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> > > index 9183f77..eadf718 100644
> > > --- a/fs/xfs/xfs_icache.h
> > > +++ b/fs/xfs/xfs_icache.h
> > > @@ -126,4 +126,7 @@ xfs_fs_eofblocks_from_user(
> > >  	return 0;
> > >  }
> > >  
> > > +int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
> > > +				  xfs_ino_t ino, bool *inuse);
> > > +
> > >  #endif
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
