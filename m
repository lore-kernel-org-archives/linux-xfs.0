Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29735 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752325AbdJSWu0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 18:50:26 -0400
Date: Thu, 19 Oct 2017 15:50:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/15] xfs: remove XFS_BMAP_TRACE_EXLIST
Message-ID: <20171019225022.GU4755@magnolia>
References: <20171019065942.18813-1-hch@lst.de>
 <20171019065942.18813-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019065942.18813-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2017 at 08:59:32AM +0200, Christoph Hellwig wrote:
> Instead of looping over all extents in some debug-only helper just
> insert trace points into the loops that already exist in the calling
> functions.
> 
> Also split the xfs_extlist trace point into one each for reading and
> writing extents from disk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 23 ++---------------------
>  fs/xfs/libxfs/xfs_bmap.h       |  9 ---------
>  fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++++--
>  fs/xfs/xfs_trace.h             |  3 ++-
>  4 files changed, 10 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ff9a8e1d4a96..6431386f4676 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -487,26 +487,6 @@ xfs_bmap_check_leaf_extents(
>  	return;
>  }
>  
> -/*
> - * Add bmap trace insert entries for all the contents of the extent records.
> - */
> -void
> -xfs_bmap_trace_exlist(
> -	xfs_inode_t	*ip,		/* incore inode pointer */
> -	xfs_extnum_t	cnt,		/* count of entries in the list */
> -	int		whichfork,	/* data or attr or cow fork */
> -	unsigned long	caller_ip)
> -{
> -	xfs_extnum_t	idx;		/* extent record index */
> -	xfs_ifork_t	*ifp;		/* inode fork pointer */
> -	int		state = xfs_bmap_fork_to_state(whichfork);
> -
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	ASSERT(cnt == xfs_iext_count(ifp));
> -	for (idx = 0; idx < cnt; idx++)
> -		trace_xfs_extlist(ip, idx, state, caller_ip);
> -}
> -
>  /*
>   * Validate that the bmbt_irecs being returned from bmapi are valid
>   * given the caller's original parameters.  Specifically check the
> @@ -1210,6 +1190,7 @@ xfs_bmap_read_extents(
>  	__be64			*pp;	/* pointer to block address */
>  	/* REFERENCED */
>  	xfs_extnum_t		room;	/* number of entries there's room for */
> +	int			state = xfs_bmap_fork_to_state(whichfork);
>  
>  	mp = ip->i_mount;
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> @@ -1283,6 +1264,7 @@ xfs_bmap_read_extents(
>  						 XFS_ERRLEVEL_LOW, mp);
>  				goto error0;
>  			}
> +			trace_xfs_read_extent(ip, i, state, _THIS_IP_);
>  		}
>  		xfs_trans_brelse(tp, bp);
>  		bno = nextbno;
> @@ -1300,7 +1282,6 @@ xfs_bmap_read_extents(
>  	if (i != XFS_IFORK_NEXTENTS(ip, whichfork))
>  		return -EFSCORRUPTED;
>  	ASSERT(i == xfs_iext_count(ifp));
> -	XFS_BMAP_TRACE_EXLIST(ip, i, whichfork);
>  	return 0;
>  error0:
>  	xfs_trans_brelse(tp, bp);
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index a61c5480b6ad..c837e88ba19a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -197,15 +197,6 @@ enum shift_direction {
>  	SHIFT_RIGHT,
>  };
>  
> -#ifdef DEBUG
> -void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
> -		int whichfork, unsigned long caller_ip);
> -#define	XFS_BMAP_TRACE_EXLIST(ip,c,w)	\
> -	xfs_bmap_trace_exlist(ip,c,w, _THIS_IP_)
> -#else
> -#define	XFS_BMAP_TRACE_EXLIST(ip,c,w)
> -#endif
> -
>  void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
>  		xfs_filblks_t len);
>  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 7f40f53e6c43..31786bad9738 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -336,6 +336,7 @@ xfs_iformat_extents(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> +	int			state = xfs_bmap_fork_to_state(whichfork);
>  	int			nex = XFS_DFORK_NEXTENTS(dip, whichfork);
>  	int			size = nex * sizeof(xfs_bmbt_rec_t);
>  	struct xfs_bmbt_rec	*dp;
> @@ -373,8 +374,8 @@ xfs_iformat_extents(
>  						 XFS_ERRLEVEL_LOW, mp);
>  				return -EFSCORRUPTED;
>  			}
> +			trace_xfs_read_extent(ip, i, state, _THIS_IP_);
>  		}
> -		XFS_BMAP_TRACE_EXLIST(ip, nex, whichfork);
>  	}
>  	ifp->if_flags |= XFS_IFEXTENTS;
>  	return 0;
> @@ -772,6 +773,7 @@ xfs_iextents_copy(
>  	xfs_bmbt_rec_t		*dp,
>  	int			whichfork)
>  {
> +	int			state = xfs_bmap_fork_to_state(whichfork);
>  	int			copied;
>  	int			i;
>  	xfs_ifork_t		*ifp;
> @@ -783,7 +785,6 @@ xfs_iextents_copy(
>  	ASSERT(ifp->if_bytes > 0);
>  
>  	nrecs = xfs_iext_count(ifp);
> -	XFS_BMAP_TRACE_EXLIST(ip, nrecs, whichfork);
>  	ASSERT(nrecs > 0);
>  
>  	/*
> @@ -806,9 +807,12 @@ xfs_iextents_copy(
>  			continue;
>  		}
>  
> +		trace_xfs_write_extent(ip, i, state, _RET_IP_);
> +
>  		/* Translate to on disk format */
>  		put_unaligned_be64(ep->l0, &dp->l0);
>  		put_unaligned_be64(ep->l1, &dp->l1);
> +
>  		dp++;
>  		copied++;
>  	}
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 0a8999a310b9..665ef6cca90c 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -309,7 +309,8 @@ DEFINE_EVENT(xfs_bmap_class, name, \
>  DEFINE_BMAP_EVENT(xfs_iext_remove);
>  DEFINE_BMAP_EVENT(xfs_bmap_pre_update);
>  DEFINE_BMAP_EVENT(xfs_bmap_post_update);
> -DEFINE_BMAP_EVENT(xfs_extlist);
> +DEFINE_BMAP_EVENT(xfs_read_extent);
> +DEFINE_BMAP_EVENT(xfs_write_extent);
>  
>  DECLARE_EVENT_CLASS(xfs_buf_class,
>  	TP_PROTO(struct xfs_buf *bp, unsigned long caller_ip),
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
