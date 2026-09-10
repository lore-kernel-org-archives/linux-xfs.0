Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6C645A29B
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 10:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037024; cv=none; b=AtwnHDDe6tR2rLYAPuD7/Wf5a7pJFTvB74jt2D+SdsNP5Sta7NzwyoCODv313RXuSgpbJ2mPfOQ4OS1arCzwiOsT4fe2ADn3d4q9FGJdb+cn43hbTqtmaiP8Ige4NIq26oiiv3piuqNRnDe0jhcUtqjRFIGO4Fpejg3Bz52O048=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037024; c=relaxed/simple;
	bh=4Ks1dykHeIghc3AbTT+SMDYtvboE3Ru5dgisOamd1RU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vc6sZ3gn0BBbCwpz+6Ng/GrcIzT/ha/tc/OlENhyeho9M/pLprUgLiSv07+Z7vMKzc9xtlLXQ8wba3WQaJJhbOwaXED3gATFMe7mk5at6fEhGxaowwYu0mRoRUcX8EjlSX5pt8g95lgc0hcmURb+7l1fwYjW74SNdmOmQTocACY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QLkh06mW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QLkh06mW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F21D1F000FF;
	Thu, 10 Sep 2026 10:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789037016;
	bh=uDc97xyh9D1KBZF5pZN46Y0MilHa6wHott11LVXcPHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QLkh06mWzk4xNzysZ4UI+D4tsSe9MWgZwFXj/B1zJA9p6PsxafTJCKOpp2yUvtQGz
	 E7HAmAjER0xbAbCsip3RnMoQkzOpDKxCZoJPYYQFjmK38kqJ85ZlPLuvl1oRMemcl6
	 6dQl0wxKjRy/E1LEL5vbcoNdkuIpfwqGIWVYT1zuqXF3QsWapBbbLsmA6bM3FlxRCU
	 KaDExNoAu+CEB5RZBumULbB+7f9fexE5jLVVCOlCXhKvYneWZl4RmWGYRdn+KuCwLu
	 nBR6UHWl23s/ZHlZ62AExwMoT8HYASdIYXeW/86RWtUp88hh8A9p7Dnhk2TAQQs1eH
	 oVlPhBe+YRxIw==
Date: Thu, 10 Sep 2026 12:43:32 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 3/3] xfs: avoid extra cache flushes for multi-device file
 systems in xfs_fsync
Message-ID: <aqKJzXbC1JrxFfwZ@andromeda.toxiclabs.cc>
References: <20260907073427.719935-1-hch@lst.de>
 <20260907073427.719935-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907073427.719935-4-hch@lst.de>

On Mon, Sep 07, 2026 at 10:33:09AM +0300, Christoph Hellwig wrote:
> When xlog_force_lsn sets log_flushed, it has just called xlog_force_iclog
> through xlog_force_and_check_iclog, which sets XLOG_ICL_NEED_FLUSH before
> writing out the head iclog.  This means that we already flushed the log,
> data, and (with the recent fix) RT devices before writing out the iclog
> start record and no extra cache flushed is required.
> 
> This optimizes the external log case, and fixes a performance regression
> due to double RT dev flushes with "xfs: also flush the RT device cache in
> xlog_write_iclog".
> 
> The explicit flush of the data that the device resides on when no iclog
> was written out is still required.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_file.c | 36 +++++++++---------------------------
>  1 file changed, 9 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 0d31fea67a2c..d8202da15aca 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -129,7 +129,6 @@ xfs_file_fsync(
>  	int			datasync)
>  {
>  	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
> -	struct xfs_mount	*mp = ip->i_mount;
>  	int			log_flushed = 0;
>  	int			error;
>  
> @@ -139,27 +138,17 @@ xfs_file_fsync(
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
> @@ -173,17 +162,10 @@ xfs_file_fsync(
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
>  	return 0;
>  }
>  
> -- 
> 2.53.0
> 
> 
