Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B9C12EBFD
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708405; cv=none; b=RDTnXWiUV+CM59g+c02wPhcm20rLC07m3MFXwTqMFNGbbvhq8yqBhK5MR4qjC9ZtHHwKXwa4JrB5kxBTHuNp/9ZvuBI4H5iQbPXh/lJq5lpz7DYNy6pHFmFhjA+2IHMGTD4ECQGxSSeRpmiCJ6ecy/cHxytofZ96q2dRzLgaxuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708405; c=relaxed/simple;
	bh=JQ3Kxvp/A1woNrYfyF+jFi7xAZ6Z5/efHYR6mgIOM5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VZQ5BRoHie4y137MBd2ckCtomruKQRooFmXzvUcoQWVmlIrzD79QW410IjOKZMhJG3hb5If5Izq5dLtLdr1e0AxpK4ju3wjDPTvcFXJBnimgT/fLvl5mF8b+7R2sR1wVCoEdLTKOSoyXBDWRuOMSOAVJ/b3AH3Yqs4OWH7hHVoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GOcX7GH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GOcX7GH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD6AC433F1;
	Fri, 23 Feb 2024 17:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708708404;
	bh=JQ3Kxvp/A1woNrYfyF+jFi7xAZ6Z5/efHYR6mgIOM5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GOcX7GH+LShIYOBbmBaRHRlEv1TV89egLNOGXoYUq6P8G4zulsB8z7l9dFseiGmPD
	 9A0UdptwB9CG6IbhW/trjfwmZf9ySmZFXZZJuKSAoHzrpKqAEl0XkJBqirSxTtvAhV
	 pKTS/gLpJ75ZrES3uGy3jvQ/GmYVCy6c/DabjucH+IkzTdi09aOkaXvldVbq7LVn5F
	 pgPQngmpwmw4BzxSjYx365+VFwxqwiNgtabEi25fQFpebESey9uBzXynzEnx18J68/
	 +R8C9OOpIlTbLNC0XV9Ale3lsG09iBnqzwRsHNrpiORBplZIeviofNGrB5eLCrbH+T
	 k7IA6tr7cNrVQ==
Date: Fri, 23 Feb 2024 09:13:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: cleanup fdblock/frextent accounting in
 xfs_bmap_del_extent_delay
Message-ID: <20240223171324.GS616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223071506.3968029-7-hch@lst.de>

On Fri, Feb 23, 2024 at 08:15:02AM +0100, Christoph Hellwig wrote:
> The code to account fdblocks and frextents in xfs_bmap_del_extent_delay
> is a bit weird in that it accounts frextents before the iext tree
> manipulations and fdblocks after it.  Given that the iext tree
> manipulations can fail currently that's not really a problem, but

                cannot?

If my correction ^^^ is correct, then:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> still odd.  Move the frextent manipulation to the end, and use a
> fdblocks variable to account of the unconditional indirect blocks and
> the data blocks only freed for !RT.  This prepares for following
> updates in the area and already makes the code more readable.
> 
> Also remove the !isrt assert given that this code clearly handles
> rt extents correctly, and we'll soon reinstate delalloc support for
> RT inodes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 95e93534cd1264..074d833e845af3 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4833,6 +4833,7 @@ xfs_bmap_del_extent_delay(
>  	xfs_fileoff_t		del_endoff, got_endoff;
>  	xfs_filblks_t		got_indlen, new_indlen, stolen;
>  	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
> +	uint64_t		fdblocks;
>  	int			error = 0;
>  	bool			isrt;
>  
> @@ -4848,15 +4849,11 @@ xfs_bmap_del_extent_delay(
>  	ASSERT(got->br_startoff <= del->br_startoff);
>  	ASSERT(got_endoff >= del_endoff);
>  
> -	if (isrt)
> -		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
> -
>  	/*
>  	 * Update the inode delalloc counter now and wait to update the
>  	 * sb counters as we might have to borrow some blocks for the
>  	 * indirect block accounting.
>  	 */
> -	ASSERT(!isrt);
>  	error = xfs_quota_unreserve_blkres(ip, del->br_blockcount);
>  	if (error)
>  		return error;
> @@ -4933,12 +4930,15 @@ xfs_bmap_del_extent_delay(
>  
>  	ASSERT(da_old >= da_new);
>  	da_diff = da_old - da_new;
> -	if (!isrt)
> -		da_diff += del->br_blockcount;
> -	if (da_diff) {
> -		xfs_add_fdblocks(mp, da_diff);
> -		xfs_mod_delalloc(mp, -da_diff);
> -	}
> +	fdblocks = da_diff;
> +
> +	if (isrt)
> +		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
> +	else
> +		fdblocks += del->br_blockcount;
> +
> +	xfs_add_fdblocks(mp, fdblocks);
> +	xfs_mod_delalloc(mp, -(int64_t)fdblocks);
>  	return error;
>  }
>  
> -- 
> 2.39.2
> 
> 
