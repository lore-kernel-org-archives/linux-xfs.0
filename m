Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38638 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfBATdx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Feb 2019 14:33:53 -0500
Date: Fri, 1 Feb 2019 11:33:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/8] xfs: track unlinked inode counts in per-ag data
Message-ID: <20190201193348.GL5761@magnolia>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897668290.26065.2216454639188570690.stgit@magnolia>
 <20190201185924.GA31203@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201185924.GA31203@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 01, 2019 at 01:59:24PM -0500, Brian Foster wrote:
> On Thu, Jan 31, 2019 at 03:18:03PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Track the number of unlinked inodes in each AG so that we can use these
> > decisions to throttle inactivations when the unlinked list gets long.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c       |   40 +++++++++++++++++++++++++++++-----------
> >  fs/xfs/xfs_log_recover.c |    8 ++++++++
> >  fs/xfs/xfs_mount.c       |    5 +++++
> >  fs/xfs/xfs_mount.h       |    4 ++++
> >  4 files changed, 46 insertions(+), 11 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index d18354517320..98355f5f9253 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1900,6 +1900,7 @@ xfs_iunlink(
> >  	struct xfs_dinode	*dip;
> >  	struct xfs_buf		*agibp;
> >  	struct xfs_buf		*ibp;
> > +	struct xfs_perag	*pag;
> >  	xfs_agnumber_t		agno;
> >  	xfs_agino_t		agino;
> >  	short			bucket_index;
> > @@ -1912,6 +1913,8 @@ xfs_iunlink(
> >  	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> >  	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> >  	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
> > +	pag = xfs_perag_get(mp, agno);
> > +	mutex_lock(&pag->pagi_unlinked_lock);
> 
> Any particular reason for using a mutex over a spinlock or atomic_t?

Thinking this over, the pagi_unlinked_lock protects pagi_unlinked_count,
which is only used to assert that we don't have any unlinked inodes left
over during a clean unmount.  It /was/ used in the patch to make
->destroy_inode callers wait for inactivation, but since I dropped that
patch I don't need the counter anymore.

Maybe we can just drop this patch entirely?  If we leak any unlinked
inodes they'll get cleaned up at next mount... wait, we never did merge
Eric's patch to reap unlinked inodes at mount time, did we?

--D

> Brian
> 
> >  
> >  	/*
> >  	 * Get the agi buffer first.  It ensures lock ordering
> > @@ -1919,7 +1922,7 @@ xfs_iunlink(
> >  	 */
> >  	error = xfs_read_agi(mp, tp, agno, &agibp);
> >  	if (error)
> > -		return error;
> > +		goto out_unlock;
> >  	agi = XFS_BUF_TO_AGI(agibp);
> >  
> >  	/*
> > @@ -1939,7 +1942,7 @@ xfs_iunlink(
> >  		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
> >  				       0, 0);
> >  		if (error)
> > -			return error;
> > +			goto out_unlock;
> >  
> >  		ASSERT(dip->di_next_unlinked == cpu_to_be32(NULLAGINO));
> >  		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
> > @@ -1964,7 +1967,12 @@ xfs_iunlink(
> >  		(sizeof(xfs_agino_t) * bucket_index);
> >  	xfs_trans_log_buf(tp, agibp, offset,
> >  			  (offset + sizeof(xfs_agino_t) - 1));
> > -	return 0;
> > +	pag->pagi_unlinked_count++;
> > +
> > +out_unlock:
> > +	mutex_unlock(&pag->pagi_unlinked_lock);
> > +	xfs_perag_put(pag);
> > +	return error;
> >  }
> >  
> >  /*
> > @@ -1982,6 +1990,7 @@ xfs_iunlink_remove(
> >  	struct xfs_buf		*ibp;
> >  	struct xfs_buf		*last_ibp;
> >  	struct xfs_dinode	*last_dip = NULL;
> > +	struct xfs_perag	*pag;
> >  	xfs_ino_t		next_ino;
> >  	xfs_agnumber_t		agno;
> >  	xfs_agino_t		agino;
> > @@ -1997,6 +2006,8 @@ xfs_iunlink_remove(
> >  	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
> >  	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> >  	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
> > +	pag = xfs_perag_get(mp, agno);
> > +	mutex_lock(&pag->pagi_unlinked_lock);
> >  
> >  	/*
> >  	 * Get the agi buffer first.  It ensures lock ordering
> > @@ -2004,7 +2015,7 @@ xfs_iunlink_remove(
> >  	 */
> >  	error = xfs_read_agi(mp, tp, agno, &agibp);
> >  	if (error)
> > -		return error;
> > +		goto out_unlock;
> >  	agi = XFS_BUF_TO_AGI(agibp);
> >  
> >  	/*
> > @@ -2015,7 +2026,8 @@ xfs_iunlink_remove(
> >  			be32_to_cpu(agi->agi_unlinked[bucket_index]))) {
> >  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
> >  				agi, sizeof(*agi));
> > -		return -EFSCORRUPTED;
> > +		error = -EFSCORRUPTED;
> > +		goto out_unlock;
> >  	}
> >  
> >  	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) == agino) {
> > @@ -2031,7 +2043,7 @@ xfs_iunlink_remove(
> >  		if (error) {
> >  			xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
> >  				__func__, error);
> > -			return error;
> > +			goto out_unlock;
> >  		}
> >  		next_agino = be32_to_cpu(dip->di_next_unlinked);
> >  		ASSERT(next_agino != 0);
> > @@ -2080,7 +2092,7 @@ xfs_iunlink_remove(
> >  				xfs_warn(mp,
> >  	"%s: xfs_imap returned error %d.",
> >  					 __func__, error);
> > -				return error;
> > +				goto out_unlock;
> >  			}
> >  
> >  			error = xfs_imap_to_bp(mp, tp, &imap, &last_dip,
> > @@ -2089,7 +2101,7 @@ xfs_iunlink_remove(
> >  				xfs_warn(mp,
> >  	"%s: xfs_imap_to_bp returned error %d.",
> >  					__func__, error);
> > -				return error;
> > +				goto out_unlock;
> >  			}
> >  
> >  			last_offset = imap.im_boffset;
> > @@ -2098,7 +2110,8 @@ xfs_iunlink_remove(
> >  				XFS_CORRUPTION_ERROR(__func__,
> >  						XFS_ERRLEVEL_LOW, mp,
> >  						last_dip, sizeof(*last_dip));
> > -				return -EFSCORRUPTED;
> > +				error = -EFSCORRUPTED;
> > +				goto out_unlock;
> >  			}
> >  		}
> >  
> > @@ -2111,7 +2124,7 @@ xfs_iunlink_remove(
> >  		if (error) {
> >  			xfs_warn(mp, "%s: xfs_imap_to_bp(2) returned error %d.",
> >  				__func__, error);
> > -			return error;
> > +			goto out_unlock;
> >  		}
> >  		next_agino = be32_to_cpu(dip->di_next_unlinked);
> >  		ASSERT(next_agino != 0);
> > @@ -2146,7 +2159,12 @@ xfs_iunlink_remove(
> >  				  (offset + sizeof(xfs_agino_t) - 1));
> >  		xfs_inobp_check(mp, last_ibp);
> >  	}
> > -	return 0;
> > +	pag->pagi_unlinked_count--;
> > +
> > +out_unlock:
> > +	mutex_unlock(&pag->pagi_unlinked_lock);
> > +	xfs_perag_put(pag);
> > +	return error;
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index ff9a27834c50..c920b8aeba01 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -5054,6 +5054,7 @@ xlog_recover_process_one_iunlink(
> >  	struct xfs_buf			*ibp;
> >  	struct xfs_dinode		*dip;
> >  	struct xfs_inode		*ip;
> > +	struct xfs_perag		*pag;
> >  	xfs_ino_t			ino;
> >  	int				error;
> >  
> > @@ -5077,6 +5078,13 @@ xlog_recover_process_one_iunlink(
> >  	agino = be32_to_cpu(dip->di_next_unlinked);
> >  	xfs_buf_relse(ibp);
> >  
> > +	/* Make sure the in-core data knows about this unlinked inode. */
> > +	pag = xfs_perag_get(mp, agno);
> > +	mutex_lock(&pag->pagi_unlinked_lock);
> > +	pag->pagi_unlinked_count++;
> > +	mutex_unlock(&pag->pagi_unlinked_lock);
> > +	xfs_perag_put(pag);
> > +
> >  	/*
> >  	 * Prevent any DMAPI event from being sent when the reference on
> >  	 * the inode is dropped.
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 10be706ec72e..6bfc985669e0 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -149,6 +149,9 @@ xfs_free_perag(
> >  		spin_unlock(&mp->m_perag_lock);
> >  		ASSERT(pag);
> >  		ASSERT(atomic_read(&pag->pag_ref) == 0);
> > +		ASSERT(pag->pagi_unlinked_count == 0 ||
> > +		       XFS_FORCED_SHUTDOWN(mp));
> > +		mutex_destroy(&pag->pagi_unlinked_lock);
> >  		xfs_buf_hash_destroy(pag);
> >  		mutex_destroy(&pag->pag_ici_reclaim_lock);
> >  		call_rcu(&pag->rcu_head, __xfs_free_perag);
> > @@ -227,6 +230,7 @@ xfs_initialize_perag(
> >  		/* first new pag is fully initialized */
> >  		if (first_initialised == NULLAGNUMBER)
> >  			first_initialised = index;
> > +		mutex_init(&pag->pagi_unlinked_lock);
> >  	}
> >  
> >  	index = xfs_set_inode_alloc(mp, agcount);
> > @@ -249,6 +253,7 @@ xfs_initialize_perag(
> >  		if (!pag)
> >  			break;
> >  		xfs_buf_hash_destroy(pag);
> > +		mutex_destroy(&pag->pagi_unlinked_lock);
> >  		mutex_destroy(&pag->pag_ici_reclaim_lock);
> >  		kmem_free(pag);
> >  	}
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index e344b1dfde63..0fcc6b6a4f67 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -388,6 +388,10 @@ typedef struct xfs_perag {
> >  
> >  	/* reference count */
> >  	uint8_t			pagf_refcount_level;
> > +
> > +	/* unlinked inodes */
> > +	struct mutex		pagi_unlinked_lock;
> > +	uint32_t		pagi_unlinked_count;
> >  } xfs_perag_t;
> >  
> >  static inline struct xfs_ag_resv *
> > 
