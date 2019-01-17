Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46618 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfAQRni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 12:43:38 -0500
Date: Thu, 17 Jan 2019 09:43:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/12] xfs: refactor walking of per-AG RECLAIM inodes
Message-ID: <20190117174331.GC4424@magnolia>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
 <154630904767.16693.13857289605746264694.stgit@magnolia>
 <20190111190606.GC33275@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190111190606.GC33275@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 11, 2019 at 02:06:06PM -0500, Brian Foster wrote:
> On Mon, Dec 31, 2018 at 06:17:27PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor the code that walks reclaim-tagged inodes so that we can reuse
> > the same loop in a subsequent patch.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_icache.c |  170 +++++++++++++++++++++++++++++----------------------
> >  1 file changed, 97 insertions(+), 73 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 36d986087abb..7e031eb6f048 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> ...
> > @@ -1223,6 +1223,90 @@ xfs_reclaim_inode(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Walk the RECLAIM tagged inodes in this AG looking for inodes to inactivate.
> > + */
> > +STATIC int
> > +xfs_walk_ag_reclaim_inos(
> 
> Nit: how about xfs_reclaim_inodes_pag()? Hm, maybe we can rename
> xfs_reclaim_inodes_ag() to something like __xfs_reclaim_inodes() as
> well.

Ok, will do.  This whole section might change dramatically if the incore
inode radix tree becomes an xarray, but we'll see.

--D

> Brian
> 
> > +	struct xfs_perag	*pag,
> > +	int			sync_flags,
> > +	bool			(*grab_fn)(struct xfs_inode *ip,
> > +					   int sync_flags),
> > +	int			(*execute_fn)(struct xfs_inode *ip,
> > +					      struct xfs_perag *pag,
> > +					      int sync_flags),
> > +	int			*nr_to_scan,
> > +	bool			*done)
> > +{
> > +	struct xfs_mount	*mp = pag->pag_mount;
> > +	unsigned long		first_index = 0;
> > +	int			nr_found = 0;
> > +	int			last_error = 0;
> > +	int			error;
> > +
> > +	do {
> > +		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
> > +		int	i;
> > +
> > +		rcu_read_lock();
> > +		nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
> > +				(void **)batch, first_index, XFS_LOOKUP_BATCH,
> > +				XFS_ICI_RECLAIM_TAG);
> > +		if (!nr_found) {
> > +			*done = true;
> > +			rcu_read_unlock();
> > +			break;
> > +		}
> > +
> > +		/*
> > +		 * Grab the inodes before we drop the lock. if we found
> > +		 * nothing, nr == 0 and the loop will be skipped.
> > +		 */
> > +		for (i = 0; i < nr_found; i++) {
> > +			struct xfs_inode *ip = batch[i];
> > +
> > +			if (*done || !grab_fn(ip, sync_flags))
> > +				batch[i] = NULL;
> > +
> > +			/*
> > +			 * Update the index for the next lookup. Catch
> > +			 * overflows into the next AG range which can occur if
> > +			 * we have inodes in the last block of the AG and we
> > +			 * are currently pointing to the last inode.
> > +			 *
> > +			 * Because we may see inodes that are from the wrong AG
> > +			 * due to RCU freeing and reallocation, only update the
> > +			 * index if it lies in this AG. It was a race that lead
> > +			 * us to see this inode, so another lookup from the
> > +			 * same index will not find it again.
> > +			 */
> > +			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
> > +				continue;
> > +			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
> > +			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
> > +				*done = true;
> > +		}
> > +
> > +		/* unlock now we've grabbed the inodes. */
> > +		rcu_read_unlock();
> > +
> > +		for (i = 0; i < nr_found; i++) {
> > +			if (!batch[i])
> > +				continue;
> > +			error = execute_fn(batch[i], pag, sync_flags);
> > +			if (error && last_error != -EFSCORRUPTED)
> > +				last_error = error;
> > +		}
> > +
> > +		*nr_to_scan -= XFS_LOOKUP_BATCH;
> > +
> > +		cond_resched();
> > +
> > +	} while (nr_found && !*done && *nr_to_scan > 0);
> > +
> > +	return last_error;
> > +}
> > +
> >  /*
> >   * Walk the AGs and reclaim the inodes in them. Even if the filesystem is
> >   * corrupted, we still want to try to reclaim all the inodes. If we don't,
> > @@ -1236,8 +1320,8 @@ xfs_reclaim_inodes_ag(
> >  	int			*nr_to_scan)
> >  {
> >  	struct xfs_perag	*pag;
> > -	int			error = 0;
> >  	int			last_error = 0;
> > +	int			error;
> >  	xfs_agnumber_t		ag;
> >  	int			trylock = flags & SYNC_TRYLOCK;
> >  	int			skipped;
> > @@ -1247,8 +1331,7 @@ xfs_reclaim_inodes_ag(
> >  	skipped = 0;
> >  	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
> >  		unsigned long	first_index = 0;
> > -		int		done = 0;
> > -		int		nr_found = 0;
> > +		bool		done = false;
> >  
> >  		ag = pag->pag_agno + 1;
> >  
> > @@ -1262,70 +1345,11 @@ xfs_reclaim_inodes_ag(
> >  		} else
> >  			mutex_lock(&pag->pag_ici_reclaim_lock);
> >  
> > -		do {
> > -			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
> > -			int	i;
> > -
> > -			rcu_read_lock();
> > -			nr_found = radix_tree_gang_lookup_tag(
> > -					&pag->pag_ici_root,
> > -					(void **)batch, first_index,
> > -					XFS_LOOKUP_BATCH,
> > -					XFS_ICI_RECLAIM_TAG);
> > -			if (!nr_found) {
> > -				done = 1;
> > -				rcu_read_unlock();
> > -				break;
> > -			}
> > -
> > -			/*
> > -			 * Grab the inodes before we drop the lock. if we found
> > -			 * nothing, nr == 0 and the loop will be skipped.
> > -			 */
> > -			for (i = 0; i < nr_found; i++) {
> > -				struct xfs_inode *ip = batch[i];
> > -
> > -				if (done || xfs_reclaim_inode_grab(ip, flags))
> > -					batch[i] = NULL;
> > -
> > -				/*
> > -				 * Update the index for the next lookup. Catch
> > -				 * overflows into the next AG range which can
> > -				 * occur if we have inodes in the last block of
> > -				 * the AG and we are currently pointing to the
> > -				 * last inode.
> > -				 *
> > -				 * Because we may see inodes that are from the
> > -				 * wrong AG due to RCU freeing and
> > -				 * reallocation, only update the index if it
> > -				 * lies in this AG. It was a race that lead us
> > -				 * to see this inode, so another lookup from
> > -				 * the same index will not find it again.
> > -				 */
> > -				if (XFS_INO_TO_AGNO(mp, ip->i_ino) !=
> > -								pag->pag_agno)
> > -					continue;
> > -				first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
> > -				if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
> > -					done = 1;
> > -			}
> > -
> > -			/* unlock now we've grabbed the inodes. */
> > -			rcu_read_unlock();
> > -
> > -			for (i = 0; i < nr_found; i++) {
> > -				if (!batch[i])
> > -					continue;
> > -				error = xfs_reclaim_inode(batch[i], pag, flags);
> > -				if (error && last_error != -EFSCORRUPTED)
> > -					last_error = error;
> > -			}
> > -
> > -			*nr_to_scan -= XFS_LOOKUP_BATCH;
> > -
> > -			cond_resched();
> > -
> > -		} while (nr_found && !done && *nr_to_scan > 0);
> > +		error = xfs_walk_ag_reclaim_inos(pag, flags,
> > +				xfs_reclaim_inode_grab, xfs_reclaim_inode,
> > +				nr_to_scan, &done);
> > +		if (error && last_error != -EFSCORRUPTED)
> > +			last_error = error;
> >  
> >  		if (trylock && !done)
> >  			pag->pag_ici_reclaim_cursor = first_index;
> > 
