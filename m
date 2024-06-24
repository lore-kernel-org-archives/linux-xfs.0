Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCDF19B59E
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719243982; cv=none; b=Cnpm3tzxNTA5nr8BkQHMd/UMwcuawzkiIGjsKeP8qBpQYSzq8A6bggR1h8VVUtvpVWVP9f1tBs3hjPx4dIDRXgXBQM/l0HhfVcxlNchovyK1TdW2Xpch4TafWAVEtuNsUpVK+Xoi/y9zAydHBRTP5rrk6FpbdGNkZIiq7YrP/GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719243982; c=relaxed/simple;
	bh=OyVqHGbZZ1I/CR00+J5Fk80FMZUC0cETYpoTXNgV5II=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ak9Z29jwqdc2pIk2Pk8JB7Mze+AstiRB6+uASJ1BAzvheeCKusPVAoLgkuG0sU0pr3Cc+wlmFvFp1ot9g2M5k8AdxZYZhCldE9s1tkMEDnqC0o4nY1kOPoL8vUFrOtT+OZ/Z0aP9Qkg/YDci9J8G7//BloppsiQ5Ichxzn03wgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nl0lE49X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nl0lE49X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B032FC2BBFC;
	Mon, 24 Jun 2024 15:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719243981;
	bh=OyVqHGbZZ1I/CR00+J5Fk80FMZUC0cETYpoTXNgV5II=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nl0lE49XnCDGZskhYcIptUGjjkSf4Q5v/BcKF4b1EF7orOkJy7+TBrLLbFP7N/W/S
	 2t7hLyxg5GpSKYZx2AXEYEjpfxPHztMbigKZyI14xL9Z/aitnzKUay4oqUG08VbSet
	 CBb5lcP2wC6aKWNQyBZ4iXK/APZdpFCNHBuEiTrQKOTYhbM9R568yrsgevaJISXFHy
	 YlJf7o21eLi5Zm9klhGB4vXe1iwHTdeZ7b/BzBtkrps3jP97td+JmnVf1wGPdny36J
	 OsFywAeAGXTyFN6pKFvFdWQP3mko6xZpdv7UgnPyLENRrc8s+CzQXlE1pR2UzDY+Ob
	 0Id58D5jfuVHw==
Date: Mon, 24 Jun 2024 08:46:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: only free posteof blocks on first close
Message-ID: <20240624154621.GK3058325@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623053532.857496-8-hch@lst.de>

On Sun, Jun 23, 2024 at 07:34:52AM +0200, Christoph Hellwig wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Certain workloads fragment files on XFS very badly, such as a software
> package that creates a number of threads, each of which repeatedly run
> the sequence: open a file, perform a synchronous write, and close the
> file, which defeats the speculative preallocation mechanism.  We work
> around this problem by only deleting posteof blocks the /first/ time a
> file is closed to preserve the behavior that unpacking a tarball lays
> out files one after the other with no gaps.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> [hch: rebased, updated comment, renamed the flag]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Someone please review this?  The last person to try was Dave, five years
ago, and I do not know if he ever saw what it did to various workloads.

https://lore.kernel.org/linux-xfs/20190315034237.GL23020@dastard/

--D

> ---
>  fs/xfs/xfs_file.c  | 32 +++++++++++---------------------
>  fs/xfs/xfs_inode.h |  4 ++--
>  2 files changed, 13 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 8d70171678fe24..de52aceabebc27 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1215,15 +1215,21 @@ xfs_file_release(
>  	 * exposed to that problem.
>  	 */
>  	if (xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
> -		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
> +		xfs_iflags_clear(ip, XFS_EOFBLOCKS_RELEASED);
>  		if (ip->i_delayed_blks > 0)
>  			filemap_flush(inode->i_mapping);
>  	}
>  
>  	/*
>  	 * XFS aggressively preallocates post-EOF space to generate contiguous
> -	 * allocations for writers that append to the end of the file and we
> -	 * try to free these when an open file context is released.
> +	 * allocations for writers that append to the end of the file.
> +	 *
> +	 * To support workloads that close and reopen the file frequently, these
> +	 * preallocations usually persist after a close unless it is the first
> +	 * close for the inode.  This is a tradeoff to generate tightly packed
> +	 * data layouts for unpacking tarballs or similar archives that write
> +	 * one file after another without going back to it while keeping the
> +	 * preallocation for files that have recurring open/write/close cycles.
>  	 *
>  	 * There is no point in freeing blocks here for open but unlinked files
>  	 * as they will be taken care of by the inactivation path soon.
> @@ -1241,25 +1247,9 @@ xfs_file_release(
>  	    (file->f_mode & FMODE_WRITE) &&
>  	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
>  		if (xfs_can_free_eofblocks(ip) &&
> -		    !xfs_iflags_test(ip, XFS_IDIRTY_RELEASE)) {
> -			/*
> -			 * Check if the inode is being opened, written and
> -			 * closed frequently and we have delayed allocation
> -			 * blocks outstanding (e.g. streaming writes from the
> -			 * NFS server), truncating the blocks past EOF will
> -			 * cause fragmentation to occur.
> -			 *
> -			 * In this case don't do the truncation, but we have to
> -			 * be careful how we detect this case. Blocks beyond EOF
> -			 * show up as i_delayed_blks even when the inode is
> -			 * clean, so we need to truncate them away first before
> -			 * checking for a dirty release. Hence on the first
> -			 * dirty close we will still remove the speculative
> -			 * allocation, but after that we will leave it in place.
> -			 */
> +		    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED)) {
>  			xfs_free_eofblocks(ip);
> -			if (ip->i_delayed_blks)
> -				xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
> +			xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);
>  		}
>  		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  	}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index ae9851226f9913..548a4f00bcae1b 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -336,7 +336,7 @@ static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
>  #define XFS_INEW		(1 << 3) /* inode has just been allocated */
>  #define XFS_IPRESERVE_DM_FIELDS	(1 << 4) /* has legacy DMAPI fields set */
>  #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
> -#define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
> +#define XFS_EOFBLOCKS_RELEASED	(1 << 6) /* eofblocks were freed in ->release */
>  #define XFS_IFLUSHING		(1 << 7) /* inode is being flushed */
>  #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
>  #define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
> @@ -383,7 +383,7 @@ static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
>   */
>  #define XFS_IRECLAIM_RESET_FLAGS	\
>  	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
> -	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
> +	 XFS_EOFBLOCKS_RELEASED | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
>  	 XFS_INACTIVATING | XFS_IQUOTAUNCHECKED)
>  
>  /*
> -- 
> 2.43.0
> 
> 
