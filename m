Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbdFFQ2P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jun 2017 12:28:15 -0400
Date: Tue, 6 Jun 2017 12:28:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/13] xfs: check if an inode is cached and allocated
Message-ID: <20170606162813.GB55166@bfoster.bfoster>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
 <149643868294.23065.8094890990886436794.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149643868294.23065.8094890990886436794.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 02, 2017 at 02:24:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the inode cache for a particular inode number.  If it's in the
> cache, check that it's not currently being reclaimed.  If it's not being
> reclaimed, return zero if the inode is allocated.  This function will be
> used by various scrubbers to decide if the cache is more up to date
> than the disk in terms of checking if an inode is allocated.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_icache.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_icache.h |    3 ++
>  2 files changed, 86 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index f61c84f8..d610a7e 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -633,6 +633,89 @@ xfs_iget(
>  }
>  
>  /*
> + * "Is this a cached inode that's also allocated?"
> + *
> + * Look up an inode by number in the given file system.  If the inode is
> + * in cache and isn't in purgatory, return 1 if the inode is allocated
> + * and 0 if it is not.  For all other cases (not in cache, being torn
> + * down, etc.), return a negative error code.
> + *
> + * (The caller has to prevent inode allocation activity.)
> + */

Hmm.. so isn't the data returned here potentially invalid once we drop
the inode reference? In other words, couldn't an inode where we return
inuse == true be reclaimed immediately after? Perhaps I'm just not far
enough along to understand how this is used. If that's the case, a note
about the lifetime/rules of this value might be useful.

FWIW, I'm also kind of wondering if rather than open code the bits of
the inode lookup, we could accomplish the same thing with a new flag to
the existing xfs_iget() lookup mechanism that implements the associated
semantics (i.e., don't read from disk, don't reinit, sort of a read-only
semantic).

Brian

> +int
> +xfs_icache_inode_is_allocated(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_ino_t		ino,
> +	bool			*inuse)
> +{
> +	struct xfs_inode	*ip;
> +	struct xfs_perag	*pag;
> +	xfs_agino_t		agino;
> +	int			ret = 0;
> +
> +	/* reject inode numbers outside existing AGs */
> +	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
> +		return -EINVAL;
> +
> +	/* get the perag structure and ensure that it's inode capable */
> +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ino));
> +	agino = XFS_INO_TO_AGINO(mp, ino);
> +
> +	rcu_read_lock();
> +	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> +	if (!ip) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Is the inode being reused?  Is it new?  Is it being
> +	 * reclaimed?  Is it being torn down?  For any of those cases,
> +	 * fall back.
> +	 */
> +	spin_lock(&ip->i_flags_lock);
> +	if (ip->i_ino != ino ||
> +	    (ip->i_flags & (XFS_INEW | XFS_IRECLAIM | XFS_IRECLAIMABLE))) {
> +		ret = -EAGAIN;
> +		goto out_istate;
> +	}
> +
> +	/*
> +	 * If lookup is racing with unlink, jump out immediately.
> +	 */
> +	if (VFS_I(ip)->i_mode == 0) {
> +		*inuse = false;
> +		ret = 0;
> +		goto out_istate;
> +	}
> +
> +	/* If the VFS inode is being torn down, forget it. */
> +	if (!igrab(VFS_I(ip))) {
> +		ret = -EAGAIN;
> +		goto out_istate;
> +	}
> +
> +	/* We've got a live one. */
> +	spin_unlock(&ip->i_flags_lock);
> +	rcu_read_unlock();
> +	xfs_perag_put(pag);
> +
> +	*inuse = !!(VFS_I(ip)->i_mode);
> +	ret = 0;
> +	IRELE(ip);
> +
> +	return ret;
> +
> +out_istate:
> +	spin_unlock(&ip->i_flags_lock);
> +out:
> +	rcu_read_unlock();
> +	xfs_perag_put(pag);
> +	return ret;
> +}
> +
> +/*
>   * The inode lookup is done in batches to keep the amount of lock traffic and
>   * radix tree lookups to a minimum. The batch size is a trade off between
>   * lookup reduction and stack usage. This is in the reclaim path, so we can't
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 9183f77..eadf718 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -126,4 +126,7 @@ xfs_fs_eofblocks_from_user(
>  	return 0;
>  }
>  
> +int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
> +				  xfs_ino_t ino, bool *inuse);
> +
>  #endif
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
