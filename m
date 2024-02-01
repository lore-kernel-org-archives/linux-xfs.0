Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA61C84FDF
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706815873; cv=none; b=IEAAxUTQQGlag9IFDS0qIy6XqgkYtHBuYbpXD63qYe8FEtHIZDjMS69fwcrdoXZoSf1ZIusGnybLUgElASIsgDm8Wl8ghkYWr28TydqhfrjciI6APRe51esZdxi81N6IZTvYE6vh2IYuasDNuVCtquT5y9qI/vcgvjmrMEUW2ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706815873; c=relaxed/simple;
	bh=lObTokn8g91xE65CHpKsV51/mc501egO2uH+Tdll+s0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCNiwgmQpVZw2Q4toCzezkSlOu+hA9BKzmjcfCTddOBC26XG9UNzVGELhcXQ6l0wJkw63gqR5cUfifywnTLBgt7fkYPcaI9mta9i/EcrvGevnTkgNpLuSHGVMXGkk6dNqOkRi8Or7KwGMP+6wCq9KcwJa750r/c9oR+P5INnmGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DQof/x9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQof/x9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39182C433C7;
	Thu,  1 Feb 2024 19:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706815873;
	bh=lObTokn8g91xE65CHpKsV51/mc501egO2uH+Tdll+s0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DQof/x9hJ/Ezg6ZivLMJXKiFO3pcow9DffGWihb0VakeS+8O/0CsjX3YhRaDWFTBJ
	 68ymkRvQ+kpnNg0hfjXBU6naYfG1D5gufDmREgKSCMtb4rcMhYGqp4riMqpD7DMTlO
	 C3eMRPmxtSsj5Kzo+omtx4VB4xSuTOPIGjeuVYdKbXXFlSljRdM5c7oNyRxACq6bq0
	 x6jWmrtkAc4gpTV/eTSdhNUoDnIbwULdIZlgbmLzFV6VfGV4LeNCu2jd41G8SSYYAy
	 eIA4J/hZX/O+2vCPoXaXbOodPvdYVoHFpYV5pGmsJq4vacztjmZrWZWJzZJJZDG7AG
	 gPg2RPplFtMNw==
Date: Thu, 1 Feb 2024 11:31:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: allow lazy removal of inodes from the inodegc
 queues
Message-ID: <20240201193112.GF616564@frogsfrogsfrogs>
References: <20240201005217.1011010-1-david@fromorbit.com>
 <20240201005217.1011010-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240201005217.1011010-4-david@fromorbit.com>

On Thu, Feb 01, 2024 at 11:30:15AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To allow us to recycle inodes that are awaiting inactivation, we
> need to enable lazy removal of inodes from the list. Th elist is a

s/Th elist/The list/

> lockless single linked variant, so we can't just remove inodes from
> the list at will.
> 
> Instead, we can remove them lazily whenever inodegc runs by enabling
> the inodegc processing to determine whether inactivation needs to be
> done at processing time rather than queuing time.
> 
> We've already modified the queuing code to only queue the inode if
> it isn't already queued, so here all we need to do is modify the
> queue processing to determine if inactivation needs to be done.
> 
> Hence we introduce the behaviour that we can cancel inactivation
> processing simply by clearing the XFS_NEED_INACTIVE flag on the
> inode. Processing will check this flag and skip inactivation
> processing if it is not set. The flag is always set at queuing time,
> regardless of whether the inode is already one the queues or not.
> Hence if it is not set at processing time, it means that something
> has cancelled the inactivation and we should just remove it from the
> list and then leave it alone.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 38 ++++++++++++++++++++++++++++++--------
>  1 file changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 2dd1559aade2..10588f78f679 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1877,15 +1877,23 @@ xfs_inodegc_worker(
>  		int	error;
>  
>  		/*
> -		 * Switch state to inactivating and remove the inode from the
> -		 * gclist. This allows the use of llist_on_list() in the queuing
> -		 * code to determine if the inode is already on an inodegc
> -		 * queue.
> +		 * Remove the inode from the gclist and determine if it needs to
> +		 * be processed. The XFS_NEED_INACTIVE flag gets cleared if the
> +		 * inode is reactivated after queuing, but the list removal is
> +		 * lazy and left up to us.
> +		 *
> +		 * We always remove the inode from the list to allow the use of
> +		 * llist_on_list() in the queuing code to determine if the inode
> +		 * is already on an inodegc queue.
>  		 */
>  		spin_lock(&ip->i_flags_lock);
> +		init_llist_node(&ip->i_gclist);
> +		if (!(ip->i_flags & XFS_NEED_INACTIVE)) {
> +			spin_unlock(&ip->i_flags_lock);
> +			continue;
> +		}
>  		ip->i_flags |= XFS_INACTIVATING;
>  		ip->i_flags &= ~XFS_NEED_INACTIVE;
> -		init_llist_node(&ip->i_gclist);

Nit: unnecessary churn from the last patch.

So if I understand this correctly, if we think a released inode needs
inactivation, we put it on the percpu gclist and set NEEDS_INACTIVE.
Once it's on there, only the inodegc worker can remove it from that
list.  The novel part here is that now we serialize the i_gclist update
with i_flags_lock, which means that the inodegc worker can observe that
NEEDS_INACTIVE fell off the inode, and ignore the inode.

This sounds pretty similar to the v8 deferred inode inactivation series
where one could untag a NEED_INACTIVE inode to prevent the inodegc
worker from finding it, though now ported to lockless lists that showed
up for v9.

>  		spin_unlock(&ip->i_flags_lock);
>  
>  		error = xfs_inodegc_inactivate(ip);
> @@ -2153,7 +2161,6 @@ xfs_inode_mark_reclaimable(
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> -	bool			need_inactive;
>  
>  	XFS_STATS_INC(mp, vn_reclaim);
>  
> @@ -2162,8 +2169,23 @@ xfs_inode_mark_reclaimable(
>  	 */
>  	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_ALL_IRECLAIM_FLAGS));
>  
> -	need_inactive = xfs_inode_needs_inactive(ip);
> -	if (need_inactive) {
> +	/*
> +	 * If the inode is already queued for inactivation because it was
> +	 * re-activated and is now being reclaimed again (e.g. fs has been
> +	 * frozen for a while) we must ensure that the inode waits for inodegc
> +	 * to be run and removes it from the inodegc queue before it moves to
> +	 * the reclaimable state and gets freed.
> +	 *
> +	 * We don't care about races here. We can't race with a list addition
> +	 * because only one thread can be evicting the inode from the VFS cache,
> +	 * hence false negatives can't occur and we only need to worry about
> +	 * list removal races.  If we get a false positive from a list removal
> +	 * race, then the inode goes through the inactive list whether it needs
> +	 * to or not. This will slow down reclaim of this inode slightly but
> +	 * should have no other side effects.

That makes sense to me.

> +	 */
> +	if (llist_on_list(&ip->i_gclist) ||
> +	    xfs_inode_needs_inactive(ip)) {

With the nits fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  		xfs_inodegc_queue(ip);
>  		return;
>  	}
> -- 
> 2.43.0
> 
> 
