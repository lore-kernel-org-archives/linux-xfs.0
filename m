Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E2F84FAC
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706814935; cv=none; b=QIK2v7qCoiRlrndfMzAo5G3Y4uWJVC7R3oAEGIOU5wbl/lmQtimVFmcKJMzCcVVO/EuOJarhykTfh2jRxfL2nFkmCxGU0HoNxl8+lkmlbYaXABgO8vcvlF8EnKQL1+WtxFOVWvQxdM23IaUGanTInl69LhO7/uoz5GQHkdCy/9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706814935; c=relaxed/simple;
	bh=4CslH494IOSCwNsayrNk6zwlZBJtIlypTNQsY9306LA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Va8UD0gmu9IE5OK1bExJobRvuR/cxGPFHbmyQ9CYkv0pfNoSrw4WYKosYyObEcsFky5/OAwmfckcyCydcqYlUMAuXhJ587iK4XeayfdwNKhrbQf+QMQKJfkaY9GCOMUlMGsh/p+HYnVbMKJpOvXYgkLscTD9Lia0Fkipjo5NxwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TyUkMnVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TyUkMnVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D106C433C7;
	Thu,  1 Feb 2024 19:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706814934;
	bh=4CslH494IOSCwNsayrNk6zwlZBJtIlypTNQsY9306LA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TyUkMnVqn4ZLLbsM7jh+POp4Yryv9pwykjwFHmbbOmT5m30DXXfEIomJc7Uy0Vl+b
	 24OuQVKsvAhK6NGkT/4Oc1X1IoYDhCLz4QRaHT83g58XxWWq//WX/dpnq6nDTntCip
	 fYWGXn2fWmKUvaFa7MSx4OisE+lGiHVhSlskQ16hnsqfM7urXDz3kWcA744JVfwrnE
	 GmQuay15Eu8WQp+k9+vFDa9fMBgXMUPO88/jfxaOUovEmYUsfB2vvfOth+jr7hggxy
	 FQzHwk6Q0h2QVilsz1NFBrERRzgRL371+3zObjR48ZA0B6OYHJi4qe3jaC6KdEnKca
	 wogWQDoPIUSiw==
Date: Thu, 1 Feb 2024 11:15:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: prepare inode for i_gclist detection
Message-ID: <20240201191533.GE616564@frogsfrogsfrogs>
References: <20240201005217.1011010-1-david@fromorbit.com>
 <20240201005217.1011010-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240201005217.1011010-3-david@fromorbit.com>

On Thu, Feb 01, 2024 at 11:30:14AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently don't initialise the inode->i_gclist member because it
> it not necessary for a pure llist_add/llist_del_all producer-
> consumer usage pattern.  However, for lazy removal from the inodegc
> list, we need to be able to determine if the inode is already on an
> inodegc list before we queue it.
> 
> We can do this detection by using llist_on_list(), but this requires
> that we initialise the llist_node before we use it, and we
> re-initialise it when we remove it from the llist.
> 
> Because we already serialise the inodegc list add with inode state
> changes under the ip->i_flags_lock, we can do the initialisation on
> list removal atomically with the state change. We can also do the
> check of whether the inode is already on a inodegc list inside the
> state change region on insert.
> 
> This gives us the ability to use llist_on_list(ip->i_gclist) to
> determine if the inode needs to be queued for inactivation without
> having to depend on inode state flags.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 425b55526386..2dd1559aade2 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -114,6 +114,7 @@ xfs_inode_alloc(
>  	spin_lock_init(&ip->i_ioend_lock);
>  	ip->i_next_unlinked = NULLAGINO;
>  	ip->i_prev_unlinked = 0;
> +	init_llist_node(&ip->i_gclist);
>  
>  	return ip;
>  }
> @@ -1875,10 +1876,16 @@ xfs_inodegc_worker(
>  	llist_for_each_entry_safe(ip, n, node, i_gclist) {
>  		int	error;
>  
> -		/* Switch state to inactivating. */
> +		/*
> +		 * Switch state to inactivating and remove the inode from the
> +		 * gclist. This allows the use of llist_on_list() in the queuing
> +		 * code to determine if the inode is already on an inodegc
> +		 * queue.
> +		 */
>  		spin_lock(&ip->i_flags_lock);
>  		ip->i_flags |= XFS_INACTIVATING;
>  		ip->i_flags &= ~XFS_NEED_INACTIVE;
> +		init_llist_node(&ip->i_gclist);
>  		spin_unlock(&ip->i_flags_lock);
>  
>  		error = xfs_inodegc_inactivate(ip);
> @@ -2075,11 +2082,20 @@ xfs_inodegc_queue(
>  	trace_xfs_inode_set_need_inactive(ip);
>  
>  	/*
> -	 * Put the addition of the inode to the gc list under the
> +	 * The addition of the inode to the gc list is done under the
>  	 * ip->i_flags_lock so that the state change and list addition are
>  	 * atomic w.r.t. lookup operations under the ip->i_flags_lock.
> +	 * The removal is also done under the ip->i_flags_lock and so this
> +	 * allows us to safely use llist_on_list() here to determine if the
> +	 * inode is already queued on an inactivation queue.
>  	 */
>  	spin_lock(&ip->i_flags_lock);
> +	ip->i_flags |= XFS_NEED_INACTIVE;

Oh, I see, the flag setting line moves back.

Other than that everything makes sense here...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +
> +	if (llist_on_list(&ip->i_gclist)) {
> +		spin_unlock(&ip->i_flags_lock);
> +		return;
> +	}
>  
>  	cpu_nr = get_cpu();
>  	gc = this_cpu_ptr(mp->m_inodegc);
> @@ -2088,7 +2104,6 @@ xfs_inodegc_queue(
>  	WRITE_ONCE(gc->items, items + 1);
>  	shrinker_hits = READ_ONCE(gc->shrinker_hits);
>  
> -	ip->i_flags |= XFS_NEED_INACTIVE;
>  	spin_unlock(&ip->i_flags_lock);
>  
>  	/*
> -- 
> 2.43.0
> 
> 
