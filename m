Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8076B2B9D2
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 18:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871299; cv=none; b=aXncnhF3BvBBlaAkifx/u/nPNNbuvv1YPuaLc4O7yOc1FgBbk7DN5ZhnuC9JWtmEQ9y2WH+G+sVFZEgmFzWJHNYBvLNg+E7ivApqp7ICglD7U7jE/vc+rTbKUV0f1oLYDkSmAZywJT6OxLbiKTgskLj4Hk4asiExK4KbPmnoKRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871299; c=relaxed/simple;
	bh=yirifWLVqhs31FXYons23yIW7tQJRYeYwW970vZ21Gw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2GNUGy+JoVs2bixWTvT/ceDIryMit/taiT2kmcVToEk4HmXZfd3Z6PO/GOuicUfbaesC88z30lvRLciSll1zaiHyAEmy8mGCtvGB1FxPGS5dwMPOBGDIBdEiqCzLTW+6OpM5Z3jzO2m4lrGWr39Nif1a3ZTbAu9hO+ozrtiAwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=urEP52Vu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="urEP52Vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2679C433F1;
	Tue, 19 Mar 2024 18:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710871298;
	bh=yirifWLVqhs31FXYons23yIW7tQJRYeYwW970vZ21Gw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=urEP52Vu/8v1v5IoWxtWB1j7AUDXdBOjpNNRPgH5dizUOSdwrab6E1xcSv4pRuilX
	 61vIra45+vf8PRM/xrPcmm+53BI6Jg8ntMfFNWtl+gPB7zWe4G3DVLrEbE/XfSMSaD
	 gDm7svKswBnsQAvo9+D4NzIN/zWfZeHSoV/xQJ8v1YGcTBZzYKr347aT0GgfUBMder
	 2A3ltZ2hdxgZerBZb2bBmHliyMICuqWRRRKbf6x6/1VIETcYa0Y7Mmm3M6MCcylu4E
	 AnZdQKqsXKxs34DpAle2T0j1CMDULkC47Yd1f77GVhJe683uDNdLPdS8Jp9Gm7gvuE
	 mSqriZuGfJcfw==
Date: Tue, 19 Mar 2024 11:01:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: make inode inactivation state changes atomic
Message-ID: <20240319180138.GZ1927156@frogsfrogsfrogs>
References: <20240319001707.3430251-1-david@fromorbit.com>
 <20240319001707.3430251-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319001707.3430251-2-david@fromorbit.com>

On Tue, Mar 19, 2024 at 11:15:57AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We need the XFS_NEED_INACTIVE flag to correspond to whether the
> inode is on the inodegc queues so that we can then use this state
> for lazy removal.
> 
> To do this, move the addition of the inode to the inodegc queue
> under the ip->i_flags_lock so that it is atomic w.r.t. setting
> the XFS_NEED_INACTIVE flag.
> 
> Then, when we remove the inode from the inodegc list to actually run
> inactivation, clear the XFS_NEED_INACTIVE at the same time we are
> setting XFS_INACTIVATING to indicate that inactivation is in
> progress.
> 
> These changes result in all the state changes and inodegc queuing
> being atomic w.r.t. each other and inode lookups via the use of the
> ip->i_flags lock.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Pretty straightforward lock coverage extension,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c | 16 ++++++++++++++--
>  fs/xfs/xfs_inode.h  | 11 +++++++----
>  2 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 6c87b90754c4..9a362964f656 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1880,7 +1880,12 @@ xfs_inodegc_worker(
>  	llist_for_each_entry_safe(ip, n, node, i_gclist) {
>  		int	error;
>  
> -		xfs_iflags_set(ip, XFS_INACTIVATING);
> +		/* Switch state to inactivating. */
> +		spin_lock(&ip->i_flags_lock);
> +		ip->i_flags |= XFS_INACTIVATING;
> +		ip->i_flags &= ~XFS_NEED_INACTIVE;
> +		spin_unlock(&ip->i_flags_lock);
> +
>  		error = xfs_inodegc_inactivate(ip);
>  		if (error && !gc->error)
>  			gc->error = error;
> @@ -2075,9 +2080,14 @@ xfs_inodegc_queue(
>  	unsigned long		queue_delay = 1;
>  
>  	trace_xfs_inode_set_need_inactive(ip);
> +
> +	/*
> +	 * Put the addition of the inode to the gc list under the
> +	 * ip->i_flags_lock so that the state change and list addition are
> +	 * atomic w.r.t. lookup operations under the ip->i_flags_lock.
> +	 */
>  	spin_lock(&ip->i_flags_lock);
>  	ip->i_flags |= XFS_NEED_INACTIVE;
> -	spin_unlock(&ip->i_flags_lock);
>  
>  	cpu_nr = get_cpu();
>  	gc = this_cpu_ptr(mp->m_inodegc);
> @@ -2086,6 +2096,8 @@ xfs_inodegc_queue(
>  	WRITE_ONCE(gc->items, items + 1);
>  	shrinker_hits = READ_ONCE(gc->shrinker_hits);
>  
> +	spin_unlock(&ip->i_flags_lock);
> +
>  	/*
>  	 * Ensure the list add is always seen by anyone who finds the cpumask
>  	 * bit set. This effectively gives the cpumask bit set operation
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 94fa79ae1591..b0943d888f5c 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -349,10 +349,13 @@ static inline bool xfs_inode_has_forcealign(struct xfs_inode *ip)
>  
>  /*
>   * If we need to update on-disk metadata before this IRECLAIMABLE inode can be
> - * freed, then NEED_INACTIVE will be set.  Once we start the updates, the
> - * INACTIVATING bit will be set to keep iget away from this inode.  After the
> - * inactivation completes, both flags will be cleared and the inode is a
> - * plain old IRECLAIMABLE inode.
> + * freed, then NEED_INACTIVE will be set. If the inode is accessed via iget
> + * whilst NEED_INACTIVE is set, the inode will be reactivated and become a
> + * normal inode again. Once we start the inactivation, the INACTIVATING bit will
> + * be set and the NEED_INACTIVE bit will be cleared. The INACTIVATING bit will
> + * keep iget away from this inode whilst inactivation is in progress.  After the
> + * inactivation completes, INACTIVATING will be cleared and the inode
> + * transitions to a plain old IRECLAIMABLE inode.
>   */
>  #define XFS_INACTIVATING	(1 << 13)
>  
> -- 
> 2.43.0
> 
> 
