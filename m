Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199173D9DCA
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 15:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785253403; cv=none; b=Ja+rNUL90OlvCSdViJGWzXd+xLfcwbeYpbGBhqEXe7XbNnp8h+CzwcnO66q4yXQvnUnch/lPaaAceOWWs70nKZJ5ywoTESSUjUXp1AZxSv7d8tYZchuXO6un5+6661M3m2ad+/KBO0Yq5v0Jm1wmkmMRvj+I3SYHSFnyx49pQ9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785253403; c=relaxed/simple;
	bh=jpVj9qM6uIbbhNFhEATwJ2wTCVQyphmRNXZ82zvLe40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYMjWRLuc8QZB8gCFUkgaipq+XOevIJqCtSDsJrnff1XX+lAc18s7D8euDt+hsvCVw+os2gSVE/0G/CZrVpmpvVjc54Qt2fmFW0vKZCW6WNC5cTwTagrBtxjl2we6D8qUzwYAG2EQInsFO1KF79VzZaB9TXN9Dbkt0mmnZ8w6rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HrdRQB4/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HrdRQB4/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A7E721F000E9;
	Tue, 28 Jul 2026 15:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785253401;
	bh=0Q9JDCwxybprsZHoNLH2+vtGQxUp7u4fYk7WUOblSeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HrdRQB4/gHTzd2vLJXRnPkZ+dDd/LT4rRn9Ph/sm3LUVTB+XK3qqoZfT6dPEtU0LE
	 VCiH/BTEU3rxsCENYcfcAVLmeR5j0xdiGto8GnhfVSKZgy1w/pu8HCWaH0bQhcfu5A
	 u/Bn6j6WRmHomht+A4kCpifnJ7YpyliDtbxaNBIoCn0ymlt5uuZTQG1wW2NTFCXEI5
	 VImopVu+qnS1/BEXPysb2SasWqDhvgebGbe1hgyPFO/IxMJgcOjpcxhatj0GOeXtHL
	 xjIeC6nPxIjSFtW3Pr7+OrazvjJMXvz57gqiLlIxF/WWGqfAxDcYv2JtbWsLZwP6ka
	 BsiJjj/puO3Yg==
Date: Tue, 28 Jul 2026 08:43:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: use WRITE_ONCE to update b_flags
Message-ID: <20260728154321.GR2901224@frogsfrogsfrogs>
References: <20260728081152.1778841-1-hch@lst.de>
 <20260728081152.1778841-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728081152.1778841-8-hch@lst.de>

On Tue, Jul 28, 2026 at 10:11:15AM +0200, Christoph Hellwig wrote:
> Prepare for limited lockless reading of flags by using WRITE_ONCE to
> prevent the compiler from doing non-standard read-modify-write
> operations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 86 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 51 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index bc660c8ab9dd..69ace78f9e7f 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -55,11 +55,27 @@ static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
>  	return bp->b_rhash_key == XFS_BUF_DADDR_NULL;
>  }
>  
> +static inline void
> +xfs_buf_set_flags(
> +	struct xfs_buf	*bp,
> +	unsigned int	flags)
> +{
> +	WRITE_ONCE(bp->b_flags, bp->b_flags | flags);
> +}
> +
> +static inline void
> +xfs_buf_clear_flags(
> +	struct xfs_buf	*bp,
> +	unsigned int	flags)
> +{
> +	WRITE_ONCE(bp->b_flags, bp->b_flags & ~flags);
> +}
> +
>  void
>  xfs_buf_set_uptodate(
>  	struct xfs_buf	*bp)
>  {
> -	bp->b_flags |= XBF_DONE;
> +	xfs_buf_set_flags(bp, XBF_DONE);
>  }
>  
>  /*
> @@ -76,14 +92,14 @@ xfs_buf_stale(
>  {
>  	ASSERT(xfs_buf_islocked(bp));
>  
> -	bp->b_flags |= XBF_STALE;
> +	xfs_buf_set_flags(bp, XBF_STALE);
>  
>  	/*
>  	 * Clear the delwri status so that a delwri queue walker will not
>  	 * flush this buffer to disk now that it is stale. The delwri queue has
>  	 * a reference to the buffer, so this is safe to do.
>  	 */
> -	bp->b_flags &= ~_XBF_DELWRI_Q;
> +	xfs_buf_clear_flags(bp, _XBF_DELWRI_Q);
>  
>  	spin_lock(&bp->b_lockref.lock);
>  	atomic_set(&bp->b_lru_ref, 0);
> @@ -97,8 +113,7 @@ xfs_buf_clear_stale(
>  	struct xfs_buf	*bp)
>  {
>  	ASSERT(bp->b_flags & XBF_STALE);
> -
> -	bp->b_flags &= ~XBF_STALE;
> +	xfs_buf_clear_flags(bp, XBF_STALE);
>  }
>  
>  static void
> @@ -175,7 +190,7 @@ xfs_buf_alloc_kmem(
>  		bp->b_addr = NULL;
>  		return -ENOMEM;
>  	}
> -	bp->b_flags |= _XBF_KMEM;
> +	xfs_buf_set_flags(bp, _XBF_KMEM);
>  	trace_xfs_buf_backing_kmem(bp, _RET_IP_);
>  	return 0;
>  }
> @@ -320,7 +335,7 @@ xfs_buf_alloc(
>  	INIT_LIST_HEAD(&bp->b_li_list);
>  	bp->b_target = target;
>  	bp->b_mount = target->bt_mount;
> -	bp->b_flags = flags;
> +	WRITE_ONCE(bp->b_flags, flags);
>  	bp->b_rhash_key = map[0].bm_bn;
>  	bp->b_length = 0;
>  	bp->b_map_count = nmaps;
> @@ -449,7 +464,7 @@ xfs_buf_find_lock(
>  			return -ENOENT;
>  		}
>  		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
> -		bp->b_flags &= _XBF_KMEM;
> +		xfs_buf_clear_flags(bp, ~_XBF_KMEM);
>  		bp->b_ops = NULL;
>  	}
>  	return 0;
> @@ -621,8 +636,9 @@ _xfs_buf_read(
>  {
>  	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
>  
> -	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD | XBF_DONE);
> -	bp->b_flags |= XBF_READ;
> +	xfs_buf_clear_flags(bp, XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD |
> +			XBF_DONE);
> +	xfs_buf_set_flags(bp, XBF_READ);
>  	xfs_buf_submit(bp);
>  	return xfs_buf_iowait(bp);
>  }
> @@ -658,7 +674,7 @@ xfs_buf_reverify(
>  	bp->b_ops = ops;
>  	bp->b_ops->verify_read(bp);
>  	if (bp->b_error)
> -		bp->b_flags &= ~XBF_DONE;
> +		xfs_buf_clear_flags(bp, XBF_DONE);
>  	return bp->b_error;
>  }
>  
> @@ -696,7 +712,7 @@ xfs_buf_read_map(
>  		error = xfs_buf_reverify(bp, ops);
>  
>  		/* We do not want read in the flags */
> -		bp->b_flags &= ~XBF_READ;
> +		xfs_buf_clear_flags(bp, XBF_READ);
>  		ASSERT(bp->b_ops != NULL || ops == NULL);
>  	}
>  
> @@ -721,7 +737,7 @@ xfs_buf_read_map(
>  		if (!xlog_is_shutdown(target->bt_mount->m_log))
>  			xfs_buf_ioerror_alert(bp, fa);
>  
> -		bp->b_flags &= ~XBF_DONE;
> +		xfs_buf_clear_flags(bp, XBF_DONE);
>  		xfs_buf_stale(bp);
>  		xfs_buf_relse(bp);
>  
> @@ -767,8 +783,8 @@ xfs_buf_readahead_map(
>  	}
>  	XFS_STATS_INC(target->bt_mount, xb_get_read);
>  	bp->b_ops = ops;
> -	bp->b_flags &= ~(XBF_WRITE | XBF_DONE);
> -	bp->b_flags |= flags;
> +	xfs_buf_clear_flags(bp, XBF_WRITE | XBF_DONE);
> +	xfs_buf_set_flags(bp, flags);
>  	percpu_counter_inc(&target->bt_readahead_count);
>  	xfs_buf_submit(bp);
>  }
> @@ -800,7 +816,7 @@ xfs_buf_read_uncached(
>  	ASSERT(bp->b_map_count == 1);
>  	bp->b_rhash_key = XFS_BUF_DADDR_NULL;
>  	bp->b_maps[0].bm_bn = daddr;
> -	bp->b_flags |= XBF_READ;
> +	xfs_buf_set_flags(bp, XBF_READ);
>  	bp->b_ops = ops;
>  
>  	xfs_buf_submit(bp);
> @@ -1094,14 +1110,14 @@ xfs_buf_ioend_handle_error(
>  
>  resubmit:
>  	xfs_buf_ioerror(bp, 0);
> -	bp->b_flags |= (XBF_DONE | XBF_WRITE_FAIL);
> +	xfs_buf_set_flags(bp, XBF_DONE | XBF_WRITE_FAIL);
>  	reinit_completion(&bp->b_iowait);
>  	xfs_buf_submit(bp);
>  	return true;
>  out_stale:
>  	xfs_buf_stale(bp);
> -	bp->b_flags |= XBF_DONE;
> -	bp->b_flags &= ~XBF_WRITE;
> +	xfs_buf_set_flags(bp, XBF_DONE);
> +	xfs_buf_clear_flags(bp, XBF_WRITE);
>  	trace_xfs_buf_error_relse(bp, _RET_IP_);
>  	return false;
>  }
> @@ -1126,7 +1142,7 @@ xfs_buf_ioend(
>  		if (!bp->b_error && bp->b_ops)
>  			bp->b_ops->verify_read(bp);
>  		if (!bp->b_error)
> -			bp->b_flags |= XBF_DONE;
> +			xfs_buf_set_flags(bp, XBF_DONE);
>  		if (bp->b_flags & XBF_READ_AHEAD)
>  			percpu_counter_dec(&bp->b_target->bt_readahead_count);
>  	} else {
> @@ -1136,8 +1152,8 @@ xfs_buf_ioend(
>  				return;
>  			}
>  		} else {
> -			bp->b_flags &= ~XBF_WRITE_FAIL;
> -			bp->b_flags |= XBF_DONE;
> +			xfs_buf_clear_flags(bp, XBF_WRITE_FAIL);
> +			xfs_buf_set_flags(bp, XBF_DONE);
>  		}
>  
>  		/* clear the retry state */
> @@ -1157,7 +1173,7 @@ xfs_buf_ioend(
>  			bp->b_iodone(bp);
>  	}
>  
> -	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
> +	xfs_buf_clear_flags(bp, XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
>  	if (async)
>  		xfs_buf_relse(bp);
>  }
> @@ -1203,8 +1219,8 @@ xfs_buf_fail(
>  {
>  	ASSERT(xfs_buf_islocked(bp));
>  
> -	bp->b_flags |= XBF_ASYNC;
> -	bp->b_flags &= ~XBF_DONE;
> +	xfs_buf_set_flags(bp, XBF_ASYNC);
> +	xfs_buf_clear_flags(bp, XBF_DONE);
>  	xfs_buf_stale(bp);
>  	xfs_buf_ioerror(bp, -EIO);
>  	xfs_buf_ioend(bp);
> @@ -1218,9 +1234,9 @@ xfs_bwrite(
>  
>  	ASSERT(xfs_buf_islocked(bp));
>  
> -	bp->b_flags |= XBF_WRITE;
> -	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
> -			 XBF_DONE);
> +	xfs_buf_set_flags(bp, XBF_WRITE);
> +	xfs_buf_clear_flags(bp, XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
> +				XBF_DONE);
>  
>  	xfs_buf_submit(bp);
>  	error = xfs_buf_iowait(bp);
> @@ -1411,7 +1427,7 @@ xfs_buf_submit(
>  	return;
>  
>  ioerror:
> -	bp->b_flags &= ~XBF_DONE;
> +	xfs_buf_clear_flags(bp, XBF_DONE);
>  	xfs_buf_stale(bp);
>  end_io:
>  	if (bp->b_flags & XBF_ASYNC)
> @@ -1822,7 +1838,7 @@ xfs_buf_delwri_cancel(
>  		bp = list_first_entry(list, struct xfs_buf, b_list);
>  
>  		xfs_buf_lock(bp);
> -		bp->b_flags &= ~_XBF_DELWRI_Q;
> +		xfs_buf_clear_flags(bp, _XBF_DELWRI_Q);
>  		xfs_buf_list_del(bp);
>  		xfs_buf_relse(bp);
>  	}
> @@ -1867,7 +1883,7 @@ xfs_buf_delwri_queue(
>  	 * might get readded to a delwri list after the synchronous writeout, in
>  	 * which case we need just need to re-add the flag here.
>  	 */
> -	bp->b_flags |= _XBF_DELWRI_Q;
> +	xfs_buf_set_flags(bp, _XBF_DELWRI_Q);
>  	if (list_empty(&bp->b_list)) {
>  		xfs_buf_hold(bp);
>  		list_add_tail(&bp->b_list, list);
> @@ -1944,8 +1960,8 @@ xfs_buf_delwri_submit_prep(
>  	}
>  
>  	trace_xfs_buf_delwri_split(bp, _RET_IP_);
> -	bp->b_flags &= ~_XBF_DELWRI_Q;
> -	bp->b_flags |= XBF_WRITE;
> +	xfs_buf_clear_flags(bp, _XBF_DELWRI_Q);
> +	xfs_buf_set_flags(bp, XBF_WRITE);
>  	return true;
>  }
>  
> @@ -1986,7 +2002,7 @@ xfs_buf_delwri_submit_nowait(
>  		}
>  		if (!xfs_buf_delwri_submit_prep(bp))
>  			continue;
> -		bp->b_flags |= XBF_ASYNC;
> +		xfs_buf_set_flags(bp, XBF_ASYNC);
>  		xfs_buf_list_del(bp);
>  		xfs_buf_submit(bp);
>  	}
> @@ -2019,7 +2035,7 @@ xfs_buf_delwri_submit(
>  		xfs_buf_lock(bp);
>  		if (!xfs_buf_delwri_submit_prep(bp))
>  			continue;
> -		bp->b_flags &= ~XBF_ASYNC;
> +		xfs_buf_clear_flags(bp, XBF_ASYNC);
>  		list_move_tail(&bp->b_list, &wait_list);
>  		xfs_buf_submit(bp);
>  	}
> -- 
> 2.53.0
> 
> 
