Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182AD6FB8
	for <linux-xfs@vger.kernel.org>; Fri, 15 Mar 2024 02:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710469714; cv=none; b=Djuny7+4ScCBM9guiTNvRUFHm5hQkZlj2S5MBa03mtcQp4LPbp2XM1twMK+QwvsXoRVq4iO6m6wOZnJYtkLdROzKWFBXfnqGMXXJHNIPt3PRI+OF2b9sUoUycyCiXQ+pth+K9/hifJs46FPrZKWvN4uZC4hlXZg5n4O8UjMq388=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710469714; c=relaxed/simple;
	bh=Kh8+VT3ezt0sPYi1QBIREf17f4QBAeK9zHimJbebOzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrZ9jmIs+tRaTP5eETuucP6S5Jx5BVSzV5fCUv3zcAl4tmCWrvcjNGZdQCXSI8gFyq5X0uu5c4N2pBXVOnje021oSdmsz9BgfA93KBSUop0EM2SWj7XNon/pZAgHrGqN5agyGKjpjbQ2vosc1LjdcfM2zsvRz8oTnyrkobPsFzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SCTsSpcr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SCTsSpcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B606C433F1;
	Fri, 15 Mar 2024 02:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710469713;
	bh=Kh8+VT3ezt0sPYi1QBIREf17f4QBAeK9zHimJbebOzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SCTsSpcrJWYPhVqerLSU7zLEm3xVXJpXjz3gb25JBmz7rd1IM2JluBLRKbTAcs/IB
	 PV4/JoRp1AhdY2dm59uDkLc+cbEJNtJ7V778vdGwkjOCK97juwqiU54CIIx12Pn2hp
	 /pVPsCbCz2BxKiEwquL3OTwbpCil/SFLJ8ZrWNantiujEXhnZBgS07NqLbNfm880ca
	 Lq424HipGMXCngj3JdPs3MfMHS4mjrrS/HBVDUqVDzJ0cwZGY4f3WmvTuogJJNLVwF
	 pZBsAUXjHab2MI1T9Fd41AKbirFa3MuM+YJUttqgL/4JvVSoGdVi2Y9pxU7Y7wwuPg
	 lEQfG1P8tWRsw==
Date: Thu, 14 Mar 2024 19:28:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH] xfs: quota radix tree allocations need to be NOFS on
 insert
Message-ID: <20240315022832.GY1927156@frogsfrogsfrogs>
References: <20240315011639.2129658-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240315011639.2129658-1-david@fromorbit.com>

On Fri, Mar 15, 2024 at 12:16:39PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In converting the XFS code from GFP_NOFS to scoped contexts, we
> converted the quota radix tree to GFP_KERNEL. Unfortunately, it was
> not clearly documented that this set was because there is a
> dependency on the quotainfo->qi_tree_lock being taken in memory
> reclaim to remove dquots from the radix tree.
> 
> In hindsight this is obvious, but the radix tree allocations on
> insert are not immediately obvious, and we avoid this for the inode
> cache radix trees by using preloading and hence completely avoiding
> the radix tree node allocation under tree lock constraints.
> 
> Hence there are a few solutions here. The first is to reinstate
> GFP_NOFS for the radix tree and add a comment explaining why
> GFP_NOFS is used. The second is to use memalloc_nofs_save() on the
> radix tree insert context, which makes it obvious that the radix
> tree insert runs under GFP_NOFS constraints. The third option is to
> simply replace the radix tree and it's lock with an xarray which can
> do memory allocation safely in an insert context.
> 
> The first is OK, but not really the direction we want to head. The
> second is my preferred short term solution. The third - converting
> XFS radix trees to xarray - is the longer term solution.
> 
> Hence to fix the regression here, we take option 2 as it moves us in
> the direction we want to head with memory allocation and GFP_NOFS
> removal.
> 
> Reported-by: syzbot+8fdff861a781522bda4d@syzkaller.appspotmail.com
> Reported-by: syzbot+d247769793ec169e4bf9@syzkaller.appspotmail.com
> Fixes: 94a69db2367e ("xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_dquot.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d2c7fcc2ea6b..9c027e44d88f 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -811,6 +811,12 @@ xfs_qm_dqget_cache_lookup(
>   * caller should throw away the dquot and start over.  Otherwise, the dquot
>   * is returned locked (and held by the cache) as if there had been a cache
>   * hit.
> + *
> + * The insert needs to be done under memalloc_nofs context because the radix
> + * tree can do memory allocation during insert. The qi->qi_tree_lock is taken in
> + * memory reclaim when freeing unused dquots, so we cannot have the radix tree
> + * node allocation recursing into filesystem reclaim whilst we hold the
> + * qi_tree_lock.

Sounds reasonable to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>   */
>  static int
>  xfs_qm_dqget_cache_insert(
> @@ -820,25 +826,27 @@ xfs_qm_dqget_cache_insert(
>  	xfs_dqid_t		id,
>  	struct xfs_dquot	*dqp)
>  {
> +	unsigned int		nofs_flags;
>  	int			error;
>  
> +	nofs_flags = memalloc_nofs_save();
>  	mutex_lock(&qi->qi_tree_lock);
>  	error = radix_tree_insert(tree, id, dqp);
>  	if (unlikely(error)) {
>  		/* Duplicate found!  Caller must try again. */
> -		mutex_unlock(&qi->qi_tree_lock);
>  		trace_xfs_dqget_dup(dqp);
> -		return error;
> +		goto out_unlock;
>  	}
>  
>  	/* Return a locked dquot to the caller, with a reference taken. */
>  	xfs_dqlock(dqp);
>  	dqp->q_nrefs = 1;
> -
>  	qi->qi_dquots++;
> -	mutex_unlock(&qi->qi_tree_lock);
>  
> -	return 0;
> +out_unlock:
> +	mutex_unlock(&qi->qi_tree_lock);
> +	memalloc_nofs_restore(nofs_flags);
> +	return error;
>  }
>  
>  /* Check our input parameters. */
> -- 
> 2.43.0
> 
> 
