Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727490AbfBDTYy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 14:24:54 -0500
Date: Mon, 4 Feb 2019 14:24:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/10] xfs: track unlinked inode counts in per-ag data
Message-ID: <20190204192451.GB47560@bfoster>
References: <154930313674.31814.17994684613232167921.stgit@magnolia>
 <154930315478.31814.9792968910867944759.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154930315478.31814.9792968910867944759.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 09:59:14AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Track the number of unlinked inodes in each AG so that we can use these
> decisions to throttle inactivations when the unlinked list gets long.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

I'm a little confused where we're at with this one given the discussion
on the previous version. We've dropped the locking, but left the
tracking in place. Are we just relying on holding the agi in the
iunlink/iunlink_remove cases? If so, that seems reasonable to me but the
commit log should probably have a sentence or two on the serialization
rules. The commit log could also use an update to describe how this
value is actually used in this patch (as an unmount time check) as
opposed to some apparent throttling functionality that isn't a part of
this series.

Brian

>  fs/xfs/xfs_inode.c       |   35 ++++++++++++++++++++++++-----------
>  fs/xfs/xfs_log_recover.c |    6 ++++++
>  fs/xfs/xfs_mount.c       |    2 ++
>  fs/xfs/xfs_mount.h       |    3 +++
>  4 files changed, 35 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 2367cdfcd90b..435901c7c674 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1900,6 +1900,7 @@ xfs_iunlink(
>  	struct xfs_dinode	*dip;
>  	struct xfs_buf		*agibp;
>  	struct xfs_buf		*ibp;
> +	struct xfs_perag	*pag;
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
> @@ -1907,11 +1908,12 @@ xfs_iunlink(
>  	int			error;
>  
>  	ASSERT(VFS_I(ip)->i_mode != 0);
> +	pag = xfs_perag_get(mp, agno);
>  
>  	/* Get the agi buffer first.  It ensures lock ordering on the list. */
>  	error = xfs_read_agi(mp, tp, agno, &agibp);
>  	if (error)
> -		return error;
> +		goto out;
>  	agi = XFS_BUF_TO_AGI(agibp);
>  
>  	/*
> @@ -1931,7 +1933,7 @@ xfs_iunlink(
>  		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp,
>  				       0, 0);
>  		if (error)
> -			return error;
> +			goto out;
>  
>  		ASSERT(dip->di_next_unlinked == cpu_to_be32(NULLAGINO));
>  		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
> @@ -1956,7 +1958,10 @@ xfs_iunlink(
>  		(sizeof(xfs_agino_t) * bucket_index);
>  	xfs_trans_log_buf(tp, agibp, offset,
>  			  (offset + sizeof(xfs_agino_t) - 1));
> -	return 0;
> +	pag->pagi_unlinked_count++;
> +out:
> +	xfs_perag_put(pag);
> +	return error;
>  }
>  
>  /*
> @@ -1974,6 +1979,7 @@ xfs_iunlink_remove(
>  	struct xfs_buf		*ibp;
>  	struct xfs_buf		*last_ibp;
>  	struct xfs_dinode	*last_dip = NULL;
> +	struct xfs_perag	*pag;
>  	xfs_ino_t		next_ino;
>  	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
> @@ -1983,10 +1989,12 @@ xfs_iunlink_remove(
>  	int			last_offset = 0;
>  	int			error;
>  
> +	pag = xfs_perag_get(mp, agno);
> +
>  	/* Get the agi buffer first.  It ensures lock ordering on the list. */
>  	error = xfs_read_agi(mp, tp, agno, &agibp);
>  	if (error)
> -		return error;
> +		goto out;
>  	agi = XFS_BUF_TO_AGI(agibp);
>  
>  	/*
> @@ -1997,7 +2005,8 @@ xfs_iunlink_remove(
>  			be32_to_cpu(agi->agi_unlinked[bucket_index]))) {
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
>  				agi, sizeof(*agi));
> -		return -EFSCORRUPTED;
> +		error = -EFSCORRUPTED;
> +		goto out;
>  	}
>  
>  	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) == agino) {
> @@ -2013,7 +2022,7 @@ xfs_iunlink_remove(
>  		if (error) {
>  			xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
>  				__func__, error);
> -			return error;
> +			goto out;
>  		}
>  		next_agino = be32_to_cpu(dip->di_next_unlinked);
>  		ASSERT(next_agino != 0);
> @@ -2062,7 +2071,7 @@ xfs_iunlink_remove(
>  				xfs_warn(mp,
>  	"%s: xfs_imap returned error %d.",
>  					 __func__, error);
> -				return error;
> +				goto out;
>  			}
>  
>  			error = xfs_imap_to_bp(mp, tp, &imap, &last_dip,
> @@ -2071,7 +2080,7 @@ xfs_iunlink_remove(
>  				xfs_warn(mp,
>  	"%s: xfs_imap_to_bp returned error %d.",
>  					__func__, error);
> -				return error;
> +				goto out;
>  			}
>  
>  			last_offset = imap.im_boffset;
> @@ -2080,7 +2089,8 @@ xfs_iunlink_remove(
>  				XFS_CORRUPTION_ERROR(__func__,
>  						XFS_ERRLEVEL_LOW, mp,
>  						last_dip, sizeof(*last_dip));
> -				return -EFSCORRUPTED;
> +				error = -EFSCORRUPTED;
> +				goto out;
>  			}
>  		}
>  
> @@ -2093,7 +2103,7 @@ xfs_iunlink_remove(
>  		if (error) {
>  			xfs_warn(mp, "%s: xfs_imap_to_bp(2) returned error %d.",
>  				__func__, error);
> -			return error;
> +			goto out;
>  		}
>  		next_agino = be32_to_cpu(dip->di_next_unlinked);
>  		ASSERT(next_agino != 0);
> @@ -2128,7 +2138,10 @@ xfs_iunlink_remove(
>  				  (offset + sizeof(xfs_agino_t) - 1));
>  		xfs_inobp_check(mp, last_ibp);
>  	}
> -	return 0;
> +	pag->pagi_unlinked_count--;
> +out:
> +	xfs_perag_put(pag);
> +	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ff9a27834c50..c634fbfea4a8 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -5054,6 +5054,7 @@ xlog_recover_process_one_iunlink(
>  	struct xfs_buf			*ibp;
>  	struct xfs_dinode		*dip;
>  	struct xfs_inode		*ip;
> +	struct xfs_perag		*pag;
>  	xfs_ino_t			ino;
>  	int				error;
>  
> @@ -5077,6 +5078,11 @@ xlog_recover_process_one_iunlink(
>  	agino = be32_to_cpu(dip->di_next_unlinked);
>  	xfs_buf_relse(ibp);
>  
> +	/* Make sure the in-core data knows about this unlinked inode. */
> +	pag = xfs_perag_get(mp, agno);
> +	pag->pagi_unlinked_count++;
> +	xfs_perag_put(pag);
> +
>  	/*
>  	 * Prevent any DMAPI event from being sent when the reference on
>  	 * the inode is dropped.
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 10be706ec72e..6ca92a71c233 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -149,6 +149,8 @@ xfs_free_perag(
>  		spin_unlock(&mp->m_perag_lock);
>  		ASSERT(pag);
>  		ASSERT(atomic_read(&pag->pag_ref) == 0);
> +		ASSERT(pag->pagi_unlinked_count == 0 ||
> +		       XFS_FORCED_SHUTDOWN(mp));
>  		xfs_buf_hash_destroy(pag);
>  		mutex_destroy(&pag->pag_ici_reclaim_lock);
>  		call_rcu(&pag->rcu_head, __xfs_free_perag);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index e344b1dfde63..169069a01f3c 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -388,6 +388,9 @@ typedef struct xfs_perag {
>  
>  	/* reference count */
>  	uint8_t			pagf_refcount_level;
> +
> +	/* unlinked inode info; lock AGI to access */
> +	unsigned int		pagi_unlinked_count;
>  } xfs_perag_t;
>  
>  static inline struct xfs_ag_resv *
> 
