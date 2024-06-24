Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE6E19B5B4
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719243823; cv=none; b=cyDrVG0x9urfFwlC8sPgHQDNdpsxInDuq6dllPqF7NF0q0aQS+NgivJUMbEH5IgmZUviqNyIV+pvBAkOvvHuug9OZd1qlDHFjihkILM43jTTxsCKfyveHwQcMkSK4vcBL2V34CMTwPAK3nu6RbPLetKlQB6m8pZ+KipgV9u9wZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719243823; c=relaxed/simple;
	bh=NyLXU6KtDz2xoAJoHYT2qe8F6D+NFHvNoXzDVTbPduc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O8ZPUMnGCm3oAs8cHGBXhpsLsrVfgLQSQ3LptR+s9f0WgeEh1eRGruAuJNn9+ySZ7P1V5TzWJPhRLzdCwC8GJIERbYO8SjgbbBcDuajXSgZd+ARB79UP4GSNj4D8p5BFVMKVt+d3WE71+YjELwV5ISoa7nUWa42B15Yqe7KYhzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cvoZCjGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cvoZCjGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3DAC32782;
	Mon, 24 Jun 2024 15:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719243822;
	bh=NyLXU6KtDz2xoAJoHYT2qe8F6D+NFHvNoXzDVTbPduc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cvoZCjGtJivlRqAFfs6O9BGJs8Bjnj1Y5uDvXsuDNkaJ+SEOkiAo4JUqlGq/x/UWJ
	 RoAYo8J++3IDyEEoKHlgCcprQ96u1Xvl6MxvN2EuC6AR4CkHttD9e01sHPmMCQiF+y
	 mxljoySWC9tHjte0jWJJ30nTjuoMgNIgQ1veYcJ6u/Kz8XDc8ckUh8olgm3eu1PsLv
	 x6hgpSCCwYav33ApxHUd/FCYLGLRnodnoV39O92LcebmhUaHPUBYGmr21H7XN2jUA6
	 QZG3VAdAcmz1U24KD/7smxTGyh1vF1bvL016P6a7bnz3ZGrerAqe/kI0a/6sLE2IyO
	 BWVJGm7q662rg==
Date: Mon, 24 Jun 2024 08:43:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: don't free post-EOF blocks on read close
Message-ID: <20240624154342.GJ3058325@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623053532.857496-7-hch@lst.de>

On Sun, Jun 23, 2024 at 07:34:51AM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we have a workload that does open/read/close in parallel with other
> allocation, the file becomes rapidly fragmented. This is due to close()
> calling xfs_file_release() and removing the speculative preallocation
> beyond EOF.
> 
> Add a check for a writable context to xfs_file_release to skip the
> post-EOF block freeing (an the similarly pointless flushing on truncate
> down).
> 
> Before:
> 
> Test 1: sync write fragmentation counts
> 
> /mnt/scratch/file.0: 919
> /mnt/scratch/file.1: 916
> /mnt/scratch/file.2: 919
> /mnt/scratch/file.3: 920
> /mnt/scratch/file.4: 920
> /mnt/scratch/file.5: 921
> /mnt/scratch/file.6: 916
> /mnt/scratch/file.7: 918
> 
> After:
> 
> Test 1: sync write fragmentation counts
> 
> /mnt/scratch/file.0: 24
> /mnt/scratch/file.1: 24
> /mnt/scratch/file.2: 11
> /mnt/scratch/file.3: 24
> /mnt/scratch/file.4: 3
> /mnt/scratch/file.5: 24
> /mnt/scratch/file.6: 24
> /mnt/scratch/file.7: 23
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [darrick: wordsmithing, fix commit message]
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> [hch: ported to the new ->release code structure]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I like how this has gotten much pared down from what's been lurking in
my tree for ages.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 0380e0b1d9c6c7..8d70171678fe24 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1228,12 +1228,18 @@ xfs_file_release(
>  	 * There is no point in freeing blocks here for open but unlinked files
>  	 * as they will be taken care of by the inactivation path soon.
>  	 *
> +	 * When releasing a read-only context, don't flush data or trim post-EOF
> +	 * blocks.  This avoids open/read/close workloads from removing EOF
> +	 * blocks that other writers depend upon to reduce fragmentation.
> +	 *
>  	 * If we can't get the iolock just skip truncating the blocks past EOF
>  	 * because we could deadlock with the mmap_lock otherwise. We'll get
>  	 * another chance to drop them once the last reference to the inode is
>  	 * dropped, so we'll never leak blocks permanently.
>  	 */
> -	if (inode->i_nlink && xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> +	if (inode->i_nlink &&
> +	    (file->f_mode & FMODE_WRITE) &&
> +	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
>  		if (xfs_can_free_eofblocks(ip) &&
>  		    !xfs_iflags_test(ip, XFS_IDIRTY_RELEASE)) {
>  			/*
> -- 
> 2.43.0
> 
> 
