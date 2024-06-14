Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4886626ADE
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 05:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718342826; cv=none; b=bkxMRYfycLhS9UpXeHmBlj953tQiqIp4yu9dYwOKnhiOj8/WGM/YR0Tq61SORkPhyQb5NKCprtQDrhApMqeVGW0q6Th8rwYe5l8V5X6QpdLih34mcXtw6KbR1HRR7CYlJFoLRCaWiSd1CsAjAw8hP0J9yLz4NeS+61YugpBg/fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718342826; c=relaxed/simple;
	bh=cZRZQZ9oFJxZ2MVjb27n0cELUlQbIb2wS9fMPli+wB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A8ARtxyFH1IhzR8cBbWKEQvVm7bfQUkAUeqpy9MBcS+OSYRvAXnlYZTaN5idZJl7fytUQguyVxQTVjQoe4hnzgn00U6yTr84DCPjNTzW8bt81kozAKvivA3ysl/jXWahAzJCJLmwzjJFHhLPglxlWs/0x99FDqPQx3cflSajQLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KH2s5Ygg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KH2s5Ygg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4D1C2BD10;
	Fri, 14 Jun 2024 05:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718342825;
	bh=cZRZQZ9oFJxZ2MVjb27n0cELUlQbIb2wS9fMPli+wB8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KH2s5YggrH1nnQYDG0rHOTxtRL2UtvDPtopHCOq6gS2yXIlhPnFkfSGuGou3o5/9B
	 9ySXdjydr0gjXJNSQsIWvlXSRK/9ubQZ3/irX17A+G9HkHjHUybU4ZNiJRf+bmnzUO
	 AXd+gbQ3uBWh2xUiMNJgDogPkMUEVoWYy0vx47nQUz2OPodjXb7qwuAqzA6IiIV2dI
	 UaFBle+U1womW0UubCLc8Xmq/NyvLdsXmrqE9jYp7N5uRYxGeJoHZ7hGldPJS47x9y
	 EBQ7xu150pCJfR0GYsda3jloAeorQtsVd5vnSiqfFODnkEfF7jSpksl7VXMB+cRmEm
	 M5+ddGt8I8phA==
Date: Thu, 13 Jun 2024 22:27:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: restrict when we try to align cow fork delalloc
 to cowextsz hints
Message-ID: <20240614052705.GC6147@frogsfrogsfrogs>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs>
 <171821431812.3202459.13352462937816171357.stgit@frogsfrogsfrogs>
 <20240613050613.GC17048@lst.de>
 <20240614041310.GG6125@frogsfrogsfrogs>
 <20240614044155.GA9084@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614044155.GA9084@lst.de>

On Fri, Jun 14, 2024 at 06:41:55AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 13, 2024 at 09:13:10PM -0700, Darrick J. Wong wrote:
> > > Looking at the caller below I don't think we need the use_cowextszhint
> > > flag here, we can just locally check for prealloc beeing non-0 in
> > > the branch below:
> > 
> > That won't work, because xfs_buffered_write_iomap_begin only sets
> > @prealloc to nonzero if it thinks is an extending write.  For the cow
> > fork, we create delalloc reservations that are aligned to the cowextsize
> > value for overwrites below eof.
> 
> Yeah.  For that we'd need to move the retry loop into
> xfs_bmapi_reserve_delalloc - which honestly feels like the more logical
> place for it anyway.  As in the untested version below, also note
> my XXX comment about a comment being added:
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c101cf266bc4db..58ff21cb84e0f5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4059,19 +4059,33 @@ xfs_bmapi_reserve_delalloc(
>  	uint64_t		fdblocks;
>  	int			error;
>  	xfs_fileoff_t		aoff = off;
> +	bool			use_cowextszhint =
> +		whichfork == XFS_COW_FORK && !prealloc;
>  
>  	/*
>  	 * Cap the alloc length. Keep track of prealloc so we know whether to
>  	 * tag the inode before we return.
>  	 */
> +retry:
>  	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
>  	if (!eof)
>  		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
>  	if (prealloc && alen >= len)
>  		prealloc = alen - len;
>  
> -	/* Figure out the extent size, adjust alen */
> -	if (whichfork == XFS_COW_FORK) {
> +	/*
> +	 * If we're targeting the COW fork but aren't creating a speculative
> +	 * posteof preallocation, try to expand the reservation to align with
> +	 * the cow extent size hint if there's sufficient free space.
> +	 *
> +	 * Unlike the data fork, the CoW cancellation functions will free all
> +	 * the reservations at inactivation, so we don't require that every
> +	 * delalloc reservation have a dirty pagecache.
> +	 *
> +	 * XXX(hch): I can't see where we actually require dirty pagecache
> +	 * for speculative data fork preallocations.  What am I missing?

IIRC a delalloc reservation in the data fork that isn't backing a dirty
page will just sit there in the data fork and never get reclaimed.
There's no writeback to turn it into an unwritten -> written extent.
The blockgc functions won't (can't?) walk the pagecache to find clean
regions that could be torn down.  xfs destroy_inode just asserts on any
reservations that it finds.

--D

> +	 */
> +	if (use_cowextszhint) {
>  		struct xfs_bmbt_irec	prev;
>  		xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);
>  
> @@ -4090,7 +4104,7 @@ xfs_bmapi_reserve_delalloc(
>  	 */
>  	error = xfs_quota_reserve_blkres(ip, alen);
>  	if (error)
> -		return error;
> +		goto out;
>  
>  	/*
>  	 * Split changing sb for alen and indlen since they could be coming
> @@ -4140,6 +4154,16 @@ xfs_bmapi_reserve_delalloc(
>  out_unreserve_quota:
>  	if (XFS_IS_QUOTA_ON(mp))
>  		xfs_quota_unreserve_blkres(ip, alen);
> +out:
> +	if (error == -ENOSPC || error == -EDQUOT) {
> +		trace_xfs_delalloc_enospc(ip, off, len);
> +		if (prealloc || use_cowextszhint) {
> +			/* retry without any preallocation */
> +			prealloc = 0;
> +			use_cowextszhint = false;
> +			goto retry;
> +		}
> +	}
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 3783426739258c..34cce017fe7ce1 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1148,27 +1148,13 @@ xfs_buffered_write_iomap_begin(
>  		}
>  	}
>  
> -retry:
>  	error = xfs_bmapi_reserve_delalloc(ip, allocfork, offset_fsb,
>  			end_fsb - offset_fsb, prealloc_blocks,
>  			allocfork == XFS_DATA_FORK ? &imap : &cmap,
>  			allocfork == XFS_DATA_FORK ? &icur : &ccur,
>  			allocfork == XFS_DATA_FORK ? eof : cow_eof);
> -	switch (error) {
> -	case 0:
> -		break;
> -	case -ENOSPC:
> -	case -EDQUOT:
> -		/* retry without any preallocation */
> -		trace_xfs_delalloc_enospc(ip, offset, count);
> -		if (prealloc_blocks) {
> -			prealloc_blocks = 0;
> -			goto retry;
> -		}
> -		fallthrough;
> -	default:
> +	if (error)
>  		goto out_unlock;
> -	}
>  
>  	if (allocfork == XFS_COW_FORK) {
>  		trace_xfs_iomap_alloc(ip, offset, count, allocfork, &cmap);
