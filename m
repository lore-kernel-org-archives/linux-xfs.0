Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CE91D53C
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 15:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719244484; cv=none; b=bE3ZeBRJrQcdQi0Tlkhq1wfqzPuWXRWSUqHIu/5obWAZ8qa3bFsUOZ4yZjX3qXTJUjHYjT6rDOeaTMHT9v92uBDLcQcbM0z6nDE3zJjTMQY3+XG06fT+GQ9vnYW+/PwBW97GDqVHSMt5eJCjpYGCdVF1FTxAKCFHNGnfeGkFCOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719244484; c=relaxed/simple;
	bh=q/zTDt3G67VWad5wSqY0m3bEK5d2Ps7RRUXb6YhnHAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cQYw0GVLp4ecTo/iaAc4t1VrTPwWuo2rqlXpp+bK5arMmdiYgLZECvxVHrN4Fa5ohGfqrh9vJx2mgPQxX7V2ZLkCfTy3O2CzihQn915mxmd2n8eNEWLiwPJRb1mrb3Y5+HuoV71tKB3kEcpz7qG4gE34q++n/aX4C/M3oCLf97w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SV+Xc8U8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SV+Xc8U8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E85C2BBFC;
	Mon, 24 Jun 2024 15:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719244484;
	bh=q/zTDt3G67VWad5wSqY0m3bEK5d2Ps7RRUXb6YhnHAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SV+Xc8U8arL5yHECVC4WQa0rajcxmzvn0M9aMDVM51JJPg+2G9INoj3G7JBYXfdGi
	 TmfO+i1CzR7JwwF5C2geBoUmGHAs6L2nuRiZFd2r5Z6LQxNJ0avam8FhrpsP10iqnt
	 a4303Q+lfsTRAFbMD6sgYELPoY28wVso+fauJPRqD/i6E5CIfOWrcglvFVrC95x1dh
	 Ssvf9Xto1Jz3iM9SdNBePeXXRjAeq+n8o4Lh0Tifv+JDps3pNIBBU8dEVyylTsUbeA
	 gdTD7umljJQd6A64A4g0lWmyvsDyyf+LMTWSKo6Qg8DrBQ/XumT6J+LnJGNtQV4iee
	 kmp1Fgm+vfIyg==
Date: Mon, 24 Jun 2024 08:54:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs: reclaim speculative preallocations for append
 only files
Message-ID: <20240624155443.GN3058325@frogsfrogsfrogs>
References: <20240623053532.857496-1-hch@lst.de>
 <20240623053532.857496-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623053532.857496-11-hch@lst.de>

On Sun, Jun 23, 2024 at 07:34:55AM +0200, Christoph Hellwig wrote:
> The XFS XFS_DIFLAG_APPEND maps to the VFS S_APPEND flag, which forbids
> writes that don't append at the current EOF.
> 
> But the commit originally adding XFS_DIFLAG_APPEND support (commit
> a23321e766d in xfs xfs-import repository) also checked it to skip
> releasing speculative preallocations, which doesn't make any sense.
> 
> Another commit (dd9f438e3290 in the xfs-import repository) late extended

                                                             later

> that flag to also report these speculation preallocations which should
> not exist in getbmap.
> 
> Remove these checks as nothing XFS_DIFLAG_APPEND implies that
> preallocations beyond EOF should exist, but explicitly check for
> XFS_DIFLAG_APPEND in xfs_file_release to bypass the algorithm that
> discard preallocations on the first close as append only file aren't

                                                           files

> expected to be written to only once.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_bmap_util.c | 12 +++++-------
>  fs/xfs/xfs_file.c      |  4 ++++
>  fs/xfs/xfs_icache.c    |  2 +-
>  3 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 52863b784b023f..aa924d7cd32abd 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -331,8 +331,7 @@ xfs_getbmap(
>  		}
>  
>  		if (xfs_get_extsz_hint(ip) ||
> -		    (ip->i_diflags &
> -		     (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))
> +		    (ip->i_diflags & XFS_DIFLAG_PREALLOC))

The last time you tried to remove XFS_DIFLAG_APPEND from this test, I
noticed that there's some fstest that "fails" because the bmap output
for an append-only file now stops at isize instead of maxbytes.  Do you
see this same regression?

>  			max_len = mp->m_super->s_maxbytes;
>  		else
>  			max_len = XFS_ISIZE(ip);
> @@ -524,12 +523,11 @@ xfs_can_free_eofblocks(
>  		return false;
>  
>  	/*
> -	 * Only free real extents for inodes with persistent preallocations or
> -	 * the append-only flag.
> +	 * Do not free real extents in preallocated files unless the file has
> +	 * delalloc blocks and we are forced to remove them.
>  	 */
> -	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
> -		if (ip->i_delayed_blks == 0)
> -			return false;
> +	if ((ip->i_diflags & XFS_DIFLAG_PREALLOC) && !ip->i_delayed_blks)
> +		return false;
>  
>  	/*
>  	 * Do not try to free post-EOF blocks if EOF is beyond the end of the
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 1903fa5568a37d..b05822a70ea680 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1231,6 +1231,9 @@ xfs_file_release(
>  	 * one file after another without going back to it while keeping the
>  	 * preallocation for files that have recurring open/write/close cycles.
>  	 *
> +	 * This heuristic is skipped for inodes with the append-only flag as
> +	 * that flags is rather pointless for inodes written oly once.

                flag                                         only

--D

> +	 *
>  	 * There is no point in freeing blocks here for open but unlinked files
>  	 * as they will be taken care of by the inactivation path soon.
>  	 *
> @@ -1245,6 +1248,7 @@ xfs_file_release(
>  	 */
>  	if (inode->i_nlink &&
>  	    (file->f_mode & FMODE_WRITE) &&
> +	    !(ip->i_diflags & XFS_DIFLAG_APPEND) &&
>  	    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
>  	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
>  		if (xfs_can_free_eofblocks(ip)) {
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 9967334ea99f1a..0f07ec842b7023 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1158,7 +1158,7 @@ xfs_inode_free_eofblocks(
>  	if (xfs_can_free_eofblocks(ip))
>  		return xfs_free_eofblocks(ip);
>  
> -	/* inode could be preallocated or append-only */
> +	/* inode could be preallocated */
>  	trace_xfs_inode_free_eofblocks_invalid(ip);
>  	xfs_inode_clear_eofblocks_tag(ip);
>  	return 0;
> -- 
> 2.43.0
> 
> 
