Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E2E49F119
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 16:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365553; cv=none; b=D8IUkTTY9TXHs/aUCxJVeoufCSV+lrAJZTdALFJVnu9nmGcZJdr0BcBtFTsx9gxvSYcOreMDwZdXxwOa/86sHKvHWK/Rscl50tUl+MVLQqV45yfahQ4Ide54m2fLX7gtqVwB1LuaZViVp0PGOf817WvJbUcexu4oBichhMBb6CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365553; c=relaxed/simple;
	bh=/JbWIhO7l7U5TnafK/pnQPrMMHVytDT3n47hTUNKcJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pk7+Ixt9W4UcvY2RKUMo8Wsjsky6uG6dMeGwZ56gLuEFl9BnmpkCggfPPL0U+q33vajLiIYgQB8IDicQJZ5jNHHCYPiFBXMUIrzwvfmHABVbGewXeYc8cF6glsUnlwsxg59QwSxe7+35sBjRg9k/6AAHFlqqmxnWVMyfe4Z94kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jd5rNB9H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jd5rNB9H"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9D9EB1F00A3E;
	Wed,  2 Sep 2026 16:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788365550;
	bh=HQmY5sVIA7ZOoNoInOmlVvFEEYbi9YbdveKjfQzKS+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jd5rNB9HsmilIyQX+sidLBEqk/kqfyMedqPs/s6gXKs5JxW4NZ/UbF6VWG1T0KMRq
	 JWSNsmuLuyZrtAOdQXxqaQYfKj3h4IgjxBxMfey6qjpSyNTXU7F/KJNVrQ87n6vaEA
	 rYlCHZ1S7J4AU8CyrmHv9S/wJemD7kN6eMDDkS1d5NPKfZxc+L9ABEU4H96s3tUkgL
	 REsMdJRL9AcljaGK71toaDy4SGeQxAd7twxuGkScjraiDdRK9NWe7hwUJczJTV9Q8i
	 A8mc1CcQ5Xact+/2wRYKm2bMk9+bP9qTaFyFGxE0nVnDYyOg7H1ZmGVcMOWhghb+/5
	 N3kRVBF2HUaTg==
Date: Wed, 2 Sep 2026 09:12:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: avoid extra cache flushes for multi-device file
 systems in xfs_fsync
Message-ID: <20260902161230.GR1933798@frogsfrogsfrogs>
References: <20260902054942.111988-1-hch@lst.de>
 <20260902054942.111988-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902054942.111988-5-hch@lst.de>

On Wed, Sep 02, 2026 at 08:49:18AM +0300, Christoph Hellwig wrote:
> When xlog_force_lsn sets log_flushed, it has just called xlog_force_iclog
> through xlog_force_and_check_iclog, which sets XLOG_ICL_NEED_FLUSH before
> writing out the head iclog.  This means that we already flushed the log,
> data, and (with the recent fix) RT devices before writing out the iclog
> start record and no extra cache flushed is required.
> 
> The explicit flush of the data that the device resides on when no iclog
> was written out is still required.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 36 +++++++++---------------------------
>  1 file changed, 9 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index cce324321b4c..795e72e1b599 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -128,7 +128,6 @@ xfs_file_fsync(
>  	int			datasync)
>  {
>  	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
> -	struct xfs_mount	*mp = ip->i_mount;
>  	int			log_flushed = 0;
>  	int			error;
>  
> @@ -138,27 +137,17 @@ xfs_file_fsync(
>  	if (error)
>  		return error;
>  
> -	if (xfs_is_shutdown(mp))
> +	if (xfs_is_shutdown(ip->i_mount))
>  		return -EIO;
>  
>  	xfs_iflags_clear(ip, XFS_ITRUNCATED);
>  
>  	/*
> -	 * If we have an RT and/or log subvolume we need to make sure to flush
> -	 * the write cache the device used for file data first.  This is to
> -	 * ensure newly written file data make it to disk before logging the new
> -	 * inode size in case of an extending write.
> -	 */
> -	if (XFS_IS_REALTIME_INODE(ip) && mp->m_rtdev_targp != mp->m_ddev_targp)
> -		error = blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
> -	else if (mp->m_logdev_targp != mp->m_ddev_targp)
> -		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * If the inode has a inode log item attached, it may need the journal
> -	 * flushed to persist any changes the log item might be tracking.
> +	 * If the inode has a log item attached, we must force the log up to the
> +	 * last LSN in which the inode was modified to ensure all metadata is
> +	 * persisted.  The log force will flush the caches for all devices
> +	 * before writing the log records unless it is a no-op because there are
> +	 * no modifications to this inode that need to be pushed out.
>  	 */
>  	if (ip->i_itemp) {
>  		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
> @@ -172,17 +161,10 @@ xfs_file_fsync(
>  	 * when no metadata needed to be committed.
>  	 *
>  	 * Use the inode's actual file data target rather than assuming the
> -	 * main data device. Realtime inodes with a separate realtime device
> -	 * are flushed before the log force, so this fallback only applies
> -	 * when the file data target is the same as the log target.
> +	 * main data device.
>  	 */
> -	if (!log_flushed) {
> -		struct xfs_buftarg *file_targp = xfs_inode_buftarg(ip);
> -
> -		if (mp->m_logdev_targp == file_targp)
> -			return blkdev_issue_flush(file_targp->bt_bdev);
> -	}
> -
> +	if (!log_flushed)
> +		return blkdev_issue_flush(xfs_inode_buftarg(ip)->bt_bdev);

At first I wondered why this flush call couldn't get moved into
xfs_fsync_flush_log, but then realized that log_flushed==0 is a
possibility if the inode doesn't have a log item attached.  Therefore
this blkdev_issue_flush has to stay in xfs_file_fsync so that we flush
write caches after pushing dirty data to disk in the pure overwrite
case where there's also no timestamp update or anything that would
generate log traffic for this inode.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
