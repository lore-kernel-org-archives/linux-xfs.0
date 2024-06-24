Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6622C13D61B
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719243300; cv=none; b=JnDNEpu7JE2xjU5M5F2NUzDKyikM5XiAeUMm4WUW4n5DWR29md20IJ5AA+ZfAP7iRcx44XaR1pPDgBiWsj3OaGoeYfRQBNaNMUHOddcCRlqdk7WzUHBmqhFuXNbLpzzLBsmiG2clWJEKTVY548Rp1a/7m1OkdR5S95c8ntBYcrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719243300; c=relaxed/simple;
	bh=Tf5uiHjXLRlgZVVgYqWtOJY3or/bxXut/QH3YTOiUbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QNVY+jNjRm+CX7twdkBx0rI/MdjJLrR2L8qyrRWcVIVOqBEW757USoWe8jIqL3mhKXG9N03zVXz8mWkgHBbjZz3nnKxD9NpO8vn7ghUcKs63ESVKx78c9nXqj3Px+GeIL48BESa0U42hpwUlS2v5iED7THLqfMPZUzKY0AhhQMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csFdl9pH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csFdl9pH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F296AC2BBFC;
	Mon, 24 Jun 2024 15:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719243300;
	bh=Tf5uiHjXLRlgZVVgYqWtOJY3or/bxXut/QH3YTOiUbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=csFdl9pH+1b8WqZhu0CjGPbDgzAeKS91Qsab4UufkFuZXpbEwbJqQ5JHhLzknHBtM
	 ACSmWASshqd1RgyHXLW1A6b1g/Q5B2/RpOpsWCgbAex3JBeeUQP1hDTrVXEdDEzpkp
	 AVKlTCUg6lPqI66dUG9sBEmNFI9lxvgjjpt9TOpGLJ6zgMCIiYeklR1uKN5G+EC8OA
	 8ApRdABNguSRWH/iUF43fJC/xc4yv/d+Nn7T3CNM2R3kApHVyKHqIGCA9g55YXYc9k
	 G8qqdeiHBn349eiJJqs8Gqs2OmgfoW/l4AB5ua5Scete373cKBugEBc+q8v4IRj5vZ
	 2D4wNsv09C1Rw==
Date: Mon, 24 Jun 2024 08:34:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: remove the i_mode check in xfs_release
Message-ID: <20240624153459.GF3058325@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623053532.857496-3-hch@lst.de>

On Sun, Jun 23, 2024 at 07:34:47AM +0200, Christoph Hellwig wrote:
> xfs_release is only called from xfs_file_release, which is wired up as
> the f_op->release handler for regular files only.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_inode.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 38f946e3be2da3..9a9340aebe9d8a 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1552,9 +1552,6 @@ xfs_release(
>  	xfs_mount_t	*mp = ip->i_mount;
>  	int		error = 0;
>  
> -	if (!S_ISREG(VFS_I(ip)->i_mode) || (VFS_I(ip)->i_mode == 0))

How would we encounter !i_mode regular files being released?

If an open file's link count is incorrectly low, it can't get freed
until after all the open file descriptors have been released, right?
Or is there some other vector for this?

I'm wondering if this ought to be:

	if (XFS_IS_CORRUPT(mp, !VFS_I(ip)->i_mode)) {
		xfs_inode_mark_sick(ip);
		return -EFSCORRUPTED;
	}

--D

> -		return 0;
> -
>  	/* If this is a read-only mount, don't do this (would generate I/O) */
>  	if (xfs_is_readonly(mp))
>  		return 0;
> -- 
> 2.43.0
> 
> 
