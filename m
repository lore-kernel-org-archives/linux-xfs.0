Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497FC36B918
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 16:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784912017; cv=none; b=PWf/ghlO0ikz6ynqe1StlRck3A1KyXvZ39F4w+cm1k8rgBm3NjKQ+Yg9NRKGVuR0uujbB7qpfVyRtL4jwkhTO3Yv4cLZDrK0VHCJFMX5qRZr5n1yDhv55tZtPr334eowGJl2VidX4ysBzTzMsD7apk3r9x0fqvIPFjTcnMZHAto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784912017; c=relaxed/simple;
	bh=mccxWg4V+3bcmLaTtr81bZLBqxCWZuZ+MRlIiCqNFf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XqBdPDCYg2u8sVA7jL9lu6h+/LBMAKyCCsyh3WijnF6fcfXzbyc5gB3O6CM2ZbFvuax0qMtxcXokQDrlFNJnzLn1Ft3HIwfYnbmiPJK+wfTu/B+I+PjqFwtOYtg+oNgwxHt6qAIEYedPjbub/ZFJW7OVvmGBrxzpA4N8GNmlr9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mlbVvo5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mlbVvo5Z"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E50B91F00A3D;
	Fri, 24 Jul 2026 16:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784912016;
	bh=foAP2GZP5Z2bbIEGtXOQ1yieX+4rH1NguI/IuQfWIe4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mlbVvo5Zzkadkd18+yTXYI3rZEzVi5kFEI0iOQ9aAyB+Lh6/ZQZmmcOfuw63GpjLS
	 51XStSObAby26dJ56LqWNZQ+LUinlGr135VxF8F8h2tFMzQkG/rXBVfV4YvxuSfP/A
	 IUWSHtjblFs5vN3qJMD0MlCqpn0iXkObSlvXCKKiZ7DqEbTUL4vsPv0Ob1aH3r0GYo
	 R1SZTTFwVYM2lehk+36/cSirIPjiWnLdTQsEhinjffbHOdHdRMtOUwNacA4T7LpTFQ
	 LVhW6+N0DRPce3s4/yek77BK5Dc+QNH6P6IVUOMD6AZkQBS/83E4xe4pIfU+sVgOb5
	 zDLaHHjNj8dOw==
Date: Fri, 24 Jul 2026 09:53:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: use WRITE_ONCE to update b_flags
Message-ID: <20260724165335.GU2901224@frogsfrogsfrogs>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715145147.95654-8-hch@lst.de>

On Wed, Jul 15, 2026 at 04:51:00PM +0200, Christoph Hellwig wrote:
> Prepare for limited lockless reading of flags by using WRITE_ONCE to
> prevent the compiler from doing non-standard read-modify-write
> operations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 86 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 51 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 33e904d838f4..2a0a19172847 100644
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
> @@ -307,7 +322,7 @@ xfs_buf_alloc(
>  	INIT_LIST_HEAD(&bp->b_li_list);
>  	bp->b_target = target;
>  	bp->b_mount = target->bt_mount;
> -	bp->b_flags = flags;
> +	WRITE_ONCE(bp->b_flags, flags);
>  	bp->b_rhash_key = map[0].bm_bn;
>  	bp->b_length = 0;
>  	bp->b_map_count = nmaps;
> @@ -436,7 +451,7 @@ xfs_buf_find_lock(
>  			return -ENOENT;
>  		}
>  		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
> -		bp->b_flags &= _XBF_KMEM;
> +		xfs_buf_clear_flags(bp, ~_XBF_KMEM);

Looks ok to me, though it took me a while to figure out that this line
correctly preserves clearing every bit *except* _XBF_KMEM.

--D

>  		bp->b_ops = NULL;
>  	}
>  	return 0;
> @@ -604,8 +619,9 @@ _xfs_buf_read(
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
> @@ -641,7 +657,7 @@ xfs_buf_reverify(
>  	bp->b_ops = ops;
>  	bp->b_ops->verify_read(bp);
>  	if (bp->b_error)
> -		bp->b_flags &= ~XBF_DONE;
> +		xfs_buf_clear_flags(bp, XBF_DONE);
>  	return bp->b_error;
>  }
>  
> @@ -679,7 +695,7 @@ xfs_buf_read_map(
>  		error = xfs_buf_reverify(bp, ops);
>  
>  		/* We do not want read in the flags */
> -		bp->b_flags &= ~XBF_READ;
> +		xfs_buf_clear_flags(bp, XBF_READ);
>  		ASSERT(bp->b_ops != NULL || ops == NULL);
>  	}
>  
> @@ -704,7 +720,7 @@ xfs_buf_read_map(
>  		if (!xlog_is_shutdown(target->bt_mount->m_log))
>  			xfs_buf_ioerror_alert(bp, fa);
>  
> -		bp->b_flags &= ~XBF_DONE;
> +		xfs_buf_clear_flags(bp, XBF_DONE);
>  		xfs_buf_stale(bp);
>  		xfs_buf_relse(bp);
>  
> @@ -750,8 +766,8 @@ xfs_buf_readahead_map(
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
> @@ -783,7 +799,7 @@ xfs_buf_read_uncached(
>  	ASSERT(bp->b_map_count == 1);
>  	bp->b_rhash_key = XFS_BUF_DADDR_NULL;
>  	bp->b_maps[0].bm_bn = daddr;
> -	bp->b_flags |= XBF_READ;
> +	xfs_buf_set_flags(bp, XBF_READ);
>  	bp->b_ops = ops;
>  
>  	xfs_buf_submit(bp);
> @@ -1077,14 +1093,14 @@ xfs_buf_ioend_handle_error(
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
> @@ -1109,7 +1125,7 @@ xfs_buf_ioend(
>  		if (!bp->b_error && bp->b_ops)
>  			bp->b_ops->verify_read(bp);
>  		if (!bp->b_error)
> -			bp->b_flags |= XBF_DONE;
> +			xfs_buf_set_flags(bp, XBF_DONE);
>  		if (bp->b_flags & XBF_READ_AHEAD)
>  			percpu_counter_dec(&bp->b_target->bt_readahead_count);
>  	} else {
> @@ -1119,8 +1135,8 @@ xfs_buf_ioend(
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
> @@ -1140,7 +1156,7 @@ xfs_buf_ioend(
>  			bp->b_iodone(bp);
>  	}
>  
> -	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
> +	xfs_buf_clear_flags(bp, XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
>  	if (async)
>  		xfs_buf_relse(bp);
>  }
> @@ -1186,8 +1202,8 @@ xfs_buf_fail(
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
> @@ -1201,9 +1217,9 @@ xfs_bwrite(
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
> @@ -1394,7 +1410,7 @@ xfs_buf_submit(
>  	return;
>  
>  ioerror:
> -	bp->b_flags &= ~XBF_DONE;
> +	xfs_buf_clear_flags(bp, XBF_DONE);
>  	xfs_buf_stale(bp);
>  end_io:
>  	if (bp->b_flags & XBF_ASYNC)
> @@ -1805,7 +1821,7 @@ xfs_buf_delwri_cancel(
>  		bp = list_first_entry(list, struct xfs_buf, b_list);
>  
>  		xfs_buf_lock(bp);
> -		bp->b_flags &= ~_XBF_DELWRI_Q;
> +		xfs_buf_clear_flags(bp, _XBF_DELWRI_Q);
>  		xfs_buf_list_del(bp);
>  		xfs_buf_relse(bp);
>  	}
> @@ -1850,7 +1866,7 @@ xfs_buf_delwri_queue(
>  	 * might get readded to a delwri list after the synchronous writeout, in
>  	 * which case we need just need to re-add the flag here.
>  	 */
> -	bp->b_flags |= _XBF_DELWRI_Q;
> +	xfs_buf_set_flags(bp, _XBF_DELWRI_Q);
>  	if (list_empty(&bp->b_list)) {
>  		xfs_buf_hold(bp);
>  		list_add_tail(&bp->b_list, list);
> @@ -1927,8 +1943,8 @@ xfs_buf_delwri_submit_prep(
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
> @@ -1969,7 +1985,7 @@ xfs_buf_delwri_submit_nowait(
>  		}
>  		if (!xfs_buf_delwri_submit_prep(bp))
>  			continue;
> -		bp->b_flags |= XBF_ASYNC;
> +		xfs_buf_set_flags(bp, XBF_ASYNC);
>  		xfs_buf_list_del(bp);
>  		xfs_buf_submit(bp);
>  	}
> @@ -2002,7 +2018,7 @@ xfs_buf_delwri_submit(
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
