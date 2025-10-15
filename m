Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18391F9C1
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 21:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760562801; cv=none; b=X1V5AT/jQlmFp8S4WVtRoocfeGQKli6saCtPQid0WwKOrcNFToQtqhM3V1434+bEbufqDFMiw4a12n8wFcWaG0J8sbPTSQUM7VKSu1jL1uFVdHHW5ShdXZbsYvJwW02GBkaou4tsfIClfzlLc8XPTo6kh/CKf6U3E1e4B//VdFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760562801; c=relaxed/simple;
	bh=G1FTzKLH4NBZmyIo6kX/Gewl+uTYFcw7wu54lLksJ48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eOHVTYbMCT/AJazQkybbKCeXa733b0rbsadwKH6o5A8YmNo8QPxp/dVIWZtM0RiQ2SyLavFtqRS+aM89CZgOp7PQmmJLPUJGxX514njSna/fLAV6KDjwY6fSvrKCPRqopQvyMDZFVOhiFkkVJ59ddn30TQLnJy4Ap8yaazEEef4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rDnMzDS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rDnMzDS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8441CC4CEF8;
	Wed, 15 Oct 2025 21:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760562800;
	bh=G1FTzKLH4NBZmyIo6kX/Gewl+uTYFcw7wu54lLksJ48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rDnMzDS2J60Dk8nSIo6aIovEXKkVevQQHT1FYlmSY7aLTTvipP6EYmh0aMQDkCCeG
	 Nfm1fv1ui6k6N9znIhW2IRKq6L4jEIw6Z10gQYWaAuc7CU52aCN17/gWhXGEdEt0en
	 DKwYjqq1Xgj5AhszvP3FCYWbQoJ0z531uyGU90wh2+eiqECsd1jHi3kcacbDBBXYb9
	 KbgtRGS0WW7Ve0oS/wjOtFhigcm5ib5Ysqt6wEwbHZEbtRSf+iwYHhabc6Pf9Ie4Xp
	 9+sDNNoadVv54sORksOW/JieWYOiQmYboqKEN9w9lfX8TjidtMN8ToMoXEy/IRmJ43
	 nN4za1EBZG8FQ==
Date: Wed, 15 Oct 2025 14:13:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/17] xfs: fold xfs_qm_dqattach_one into
 xfs_qm_dqget_inode
Message-ID: <20251015211319.GD2591640@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024851.4110053-10-hch@lst.de>

On Mon, Oct 13, 2025 at 11:48:10AM +0900, Christoph Hellwig wrote:
> xfs_qm_dqattach_one is a thin wrapper around xfs_qm_dqget_inode.  Move
> the extra asserts into xfs_qm_dqget_inode, drop the unneeded q_qlock
> roundtrip and merge the two functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice straightforward collapse there!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_dquot.c |  9 ++++++---
>  fs/xfs/xfs_qm.c    | 40 +++-------------------------------------
>  2 files changed, 9 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index a6030c53a1f9..fa493520bea6 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -992,7 +992,7 @@ xfs_qm_dqget_inode(
>  	struct xfs_inode	*ip,
>  	xfs_dqtype_t		type,
>  	bool			can_alloc,
> -	struct xfs_dquot	**O_dqpp)
> +	struct xfs_dquot	**dqpp)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> @@ -1001,6 +1001,9 @@ xfs_qm_dqget_inode(
>  	xfs_dqid_t		id;
>  	int			error;
>  
> +	ASSERT(!*dqpp);
> +	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
> +
>  	error = xfs_qm_dqget_checks(mp, type);
>  	if (error)
>  		return error;
> @@ -1063,8 +1066,8 @@ xfs_qm_dqget_inode(
>  	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
>  	trace_xfs_dqget_miss(dqp);
>  found:
> -	*O_dqpp = dqp;
> -	mutex_lock(&dqp->q_qlock);
> +	trace_xfs_dqattach_get(dqp);
> +	*dqpp = dqp;
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 80c99ef91edb..9e173a4b18eb 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -287,40 +287,6 @@ xfs_qm_unmount_quotas(
>  		xfs_qm_destroy_quotainos(mp->m_quotainfo);
>  }
>  
> -STATIC int
> -xfs_qm_dqattach_one(
> -	struct xfs_inode	*ip,
> -	xfs_dqtype_t		type,
> -	bool			doalloc,
> -	struct xfs_dquot	**IO_idqpp)
> -{
> -	struct xfs_dquot	*dqp;
> -	int			error;
> -
> -	ASSERT(!*IO_idqpp);
> -	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
> -
> -	/*
> -	 * Find the dquot from somewhere. This bumps the reference count of
> -	 * dquot and returns it locked.  This can return ENOENT if dquot didn't
> -	 * exist on disk and we didn't ask it to allocate; ESRCH if quotas got
> -	 * turned off suddenly.
> -	 */
> -	error = xfs_qm_dqget_inode(ip, type, doalloc, &dqp);
> -	if (error)
> -		return error;
> -
> -	trace_xfs_dqattach_get(dqp);
> -
> -	/*
> -	 * dqget may have dropped and re-acquired the ilock, but it guarantees
> -	 * that the dquot returned is the one that should go in the inode.
> -	 */
> -	*IO_idqpp = dqp;
> -	mutex_unlock(&dqp->q_qlock);
> -	return 0;
> -}
> -
>  static bool
>  xfs_qm_need_dqattach(
>  	struct xfs_inode	*ip)
> @@ -360,7 +326,7 @@ xfs_qm_dqattach_locked(
>  	ASSERT(!xfs_is_metadir_inode(ip));
>  
>  	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
> -		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_USER,
> +		error = xfs_qm_dqget_inode(ip, XFS_DQTYPE_USER,
>  				doalloc, &ip->i_udquot);
>  		if (error)
>  			goto done;
> @@ -368,7 +334,7 @@ xfs_qm_dqattach_locked(
>  	}
>  
>  	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
> -		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_GROUP,
> +		error = xfs_qm_dqget_inode(ip, XFS_DQTYPE_GROUP,
>  				doalloc, &ip->i_gdquot);
>  		if (error)
>  			goto done;
> @@ -376,7 +342,7 @@ xfs_qm_dqattach_locked(
>  	}
>  
>  	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
> -		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_PROJ,
> +		error = xfs_qm_dqget_inode(ip, XFS_DQTYPE_PROJ,
>  				doalloc, &ip->i_pdquot);
>  		if (error)
>  			goto done;
> -- 
> 2.47.3
> 
> 
