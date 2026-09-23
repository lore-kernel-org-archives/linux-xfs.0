Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891CB53B322;
	Wed, 23 Sep 2026 16:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790182519; cv=none; b=ktbDiEglQNEBc1mUpxHwqfUGeiFfTwiSN6xKdbyXoIherThyXyZrZ218yOByPQ6ye/zhn+iUfVqvgI/owL+AakEAB3slFa39N77nzeZOpi8CXIYNOze/CwRFgIcGG1wYxYe3Z943S29M/oxnqJj/SxgSJdd0TQRhxZXOCkyUono=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790182519; c=relaxed/simple;
	bh=a+GMB5qVD9ZAbtd1a3qTD56IBUJbpiNabXOXiiZqy1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kVfxYdfE0XzKl0k8ICWvgLAina0SO833aGk1Jit2H+ksX7s7Asg0vHpHTzeJmyAMfQ0snz0EMl8uwswgPDZ5+dqVs9yLvT9VXbCQCu0AlJCuKRktK2oCQFJXtVhXuN+dPfru1MGI/3q39zGPI5RG+idSDCE2Zoti/GSYyOkmtfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dryvgs1s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dryvgs1s"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2754E1F000FF;
	Wed, 23 Sep 2026 16:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790182518;
	bh=Diq01iAs35QsxqCi7Y+JesWTuEVB1bEqcMQJasl1pgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dryvgs1s9JTEQn7MvbgOOzFB6L5MoAkKSt0tpFtaR+E0YgHDVGGFCKkUczFZfleS/
	 lq93Ef/zoUg5otzsjv3xRyJu7PwBDkUmCVt7bIaiNitxr8MGLsT3D13OH+Yv4sK0P/
	 8RaKvZl3sPLvuyoUQRgg55fp4veFnsfKWUObgZ7nIZA0b8OXiY4+TaB1L4Z8FoKJM/
	 jvV8vpP5yiQvWu7gLjTW7HHDD1Un5o3PALSm0yZY48bbVk+N0ZHKqcqxApZlxH4iST
	 c9HBqru997COKBdaO8rlf72q+docT9ZOIwUY+7NqZ+QnudoiKQ/AV5m7j8LOM+EVC8
	 j8blnt/xeH3Yw==
Date: Wed, 23 Sep 2026 09:55:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] xfs: bound inode fork length against the fork
 size during log recovery
Message-ID: <20260923165517.GD2705364@frogsfrogsfrogs>
References: <20260923115744.3160635-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923115744.3160635-1-qwe.aldo@gmail.com>

On Wed, Sep 23, 2026 at 08:57:44AM -0300, Aldo Ariel Panzardo wrote:
> xlog_recover_inode_commit_pass2() copies an inode log item's data/attr
> fork region into the inode buffer using the on-log region length without
> bounding it against the fork capacity, e.g.:
> 
> 	len = item->ri_buf[2].iov_len;
> 	memcpy(XFS_DFORK_DPTR(dip), src, len);
> 
> The only guard is an ASSERT, which is a no-op on production kernels
> (CONFIG_XFS_DEBUG off), and xfs_dinode_verify() runs only after the copy.
> A crafted image with a dirty log can therefore drive a heap out-of-bounds
> write at mount time. The XFS_ILOG_DBROOT sibling already passes
> XFS_DFORK_DSIZE as a bound; the DDATA/DEXT and ADATA/AEXT memcpy paths
> did not.
> 
> Bound each logged fork region against the destination fork size before
> copying it, and reject the log item with -EFSCORRUPTED when it does not
> fit. Because the recovered inode is only verified after the fork data has
> been copied in, the checks are done up front, before any memcpy into the
> on-disk inode.
> 
> Fixes: 658fa68b6f34 ("xfs: refactor log recovery inode item dispatch for pass2 commit functions")
> Cc: <stable@vger.kernel.org> # v5.8
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

Looks correct to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> v2: cc stable # v5.8 (per Darrick).  Move both fork-length checks to the
>     top of the fork-copy block, before any memcpy into the on-disk
>     inode, and drop the now-redundant ASSERT.
> 
>  fs/xfs/xfs_inode_item_recover.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 169a8fe3bf0a..6c7dd7dd7032 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -507,6 +507,25 @@ xlog_recover_inode_commit_pass2(
>  	ASSERT(!(fields & XFS_ILOG_DFORK) ||
>  	       (len == xlog_calc_iovec_len(in_f->ilf_dsize)));
>  
> +	/*
> +	 * The recovered inode is verified only after the fork data has been
> +	 * copied into it, so bound each logged fork region against the size of
> +	 * its fork now, before the memcpy below can overrun the on-disk inode.
> +	 * The DBROOT/ABROOT cases already bound their copies against the fork
> +	 * size.
> +	 */
> +	if ((fields & (XFS_ILOG_DDATA | XFS_ILOG_DEXT)) &&
> +	    item->ri_buf[2].iov_len > XFS_DFORK_DSIZE(dip, mp)) {
> +		error = -EFSCORRUPTED;
> +		goto out_release;
> +	}
> +	if ((fields & (XFS_ILOG_ADATA | XFS_ILOG_AEXT)) &&
> +	    item->ri_buf[(fields & XFS_ILOG_DFORK) ? 3 : 2].iov_len >
> +	    XFS_DFORK_ASIZE(dip, mp)) {
> +		error = -EFSCORRUPTED;
> +		goto out_release;
> +	}
> +
>  	switch (fields & XFS_ILOG_DFORK) {
>  	case XFS_ILOG_DDATA:
>  	case XFS_ILOG_DEXT:
> @@ -546,7 +565,6 @@ xlog_recover_inode_commit_pass2(
>  		case XFS_ILOG_ADATA:
>  		case XFS_ILOG_AEXT:
>  			dest = XFS_DFORK_APTR(dip);
> -			ASSERT(len <= XFS_DFORK_ASIZE(dip, mp));
>  			memcpy(dest, src, len);
>  			break;
>  
> -- 
> 2.53.0
> 
> 
