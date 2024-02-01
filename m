Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB5782C97
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706814469; cv=none; b=GU07BSBVYr8sfA0JTpoV3XF03hUYtZoEFf/KmqogiB6H/+smcrThil+cPhMK7JrTOb0KYRf+KC04ecaVPdy+wpRxvBTgsdd5VlURpNK/Baip6N6X1NBppQLTnptvQ0ZVz9sHbd0fpRgEOBf1aL/IfRvBQjz/ImXxU4aoNYyfjZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706814469; c=relaxed/simple;
	bh=m1MtSNQSetkswxcflm6YG/h5jWnaC8yVBM0205j9QfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U4MIuLi49B8edOFzgMU/erSxPS2vACPDudZp9MfZ0QUlaXVvXquxZxZzdgEjEY/hHeg6uRadJEv3I5DRSxMXfVRGPg/CqXT9DX4lAgRwIwC98Vdi03QM7I684rS0xjTc045ajq2AgZhS7x1Yfu/1wqorEkbXwsBtUml48HxZwX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NlrdCdM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NlrdCdM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D749BC433F1;
	Thu,  1 Feb 2024 19:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706814468;
	bh=m1MtSNQSetkswxcflm6YG/h5jWnaC8yVBM0205j9QfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NlrdCdM5vOc2KH2Q9a6IYDU5Motuc9H5TXWAmihXhDpbC7pdXwMkgCvy0pY5ViYpU
	 CTJILaYuyDZZWGqOvjEcQszah6oecrHd7HEGXizq5d5N46PiV4h/PHgSRRZQeDiaLU
	 ZxAY9qPGafrlAa7ZgEODtCUGMYhgn4BnFhDomPaDdEj7njFB6kceo7SRHAMvdYapb6
	 /tvVPRDAK7nlM/USONxZTgIXKKDz+0pmNlwwYmFIZ7RgjRaCni4jbtEENUtWHQXqDl
	 H5a+pMiTAVClLM66wEt/cd+WjMRz3j76EGcUMLEgQcLwpuqH6emqoDrClV5BVN/tSt
	 ip9Tnj73rfGfA==
Date: Thu, 1 Feb 2024 11:07:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: make inode inactivation state changes atomic
Message-ID: <20240201190748.GD616564@frogsfrogsfrogs>
References: <20240201005217.1011010-1-david@fromorbit.com>
 <20240201005217.1011010-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240201005217.1011010-2-david@fromorbit.com>

On Thu, Feb 01, 2024 at 11:30:13AM +1100, Dave Chinner wrote:
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
> ---
>  fs/xfs/xfs_icache.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 06046827b5fe..425b55526386 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1875,7 +1875,12 @@ xfs_inodegc_worker(
>  	llist_for_each_entry_safe(ip, n, node, i_gclist) {
>  		int	error;
>  
> -		xfs_iflags_set(ip, XFS_INACTIVATING);
> +		/* Switch state to inactivating. */
> +		spin_lock(&ip->i_flags_lock);
> +		ip->i_flags |= XFS_INACTIVATING;
> +		ip->i_flags &= ~XFS_NEED_INACTIVE;

The comment for XFS_INACTIVATING ought to be updated to state that
NEED_INACTIVE is cleared at the same time that INACTIVATING is set.

> +		spin_unlock(&ip->i_flags_lock);
> +
>  		error = xfs_inodegc_inactivate(ip);
>  		if (error && !gc->error)
>  			gc->error = error;
> @@ -2068,9 +2073,13 @@ xfs_inodegc_queue(
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
> -	ip->i_flags |= XFS_NEED_INACTIVE;
> -	spin_unlock(&ip->i_flags_lock);
>  
>  	cpu_nr = get_cpu();
>  	gc = this_cpu_ptr(mp->m_inodegc);
> @@ -2079,6 +2088,9 @@ xfs_inodegc_queue(
>  	WRITE_ONCE(gc->items, items + 1);
>  	shrinker_hits = READ_ONCE(gc->shrinker_hits);
>  
> +	ip->i_flags |= XFS_NEED_INACTIVE;
> +	spin_unlock(&ip->i_flags_lock);

This change mostly makes sense to me, but is it necessary to move the
line that sets XFS_NEED_INACTIVE?  This change extends the critical
section so that the llist_add and the flags update are atomic, so
couldn't this change reduce down to moving the spin_unlock call?

(IOWs I'm not sure if there's a subtlety here or if this is merely rough
draft syndrome.)

--D

> +
>  	/*
>  	 * Ensure the list add is always seen by anyone who finds the cpumask
>  	 * bit set. This effectively gives the cpumask bit set operation
> -- 
> 2.43.0
> 
> 
