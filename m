Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52A2DDD9
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 02:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708740355; cv=none; b=nxupCvTVgA2DNWp1iDJsoF/0Mme4ArSr1DqiuU/CSkKiHf0K74mpG1DCccMv4bsydAk3KL3FsJQ9lmq/SXOworF4CHu3+eLupJG7h+bclZh6Eje7oEXsXfKrlNPeMsEkPnwyYHooDQNvNFoPo7WC95X2y4s8Yf6UvlLMkInLlZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708740355; c=relaxed/simple;
	bh=/rvZvHXcTF4KXOIn6ccWJVNn3UbM487AiqcORr+9iR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=De2UxHJPvie5An+RImsjwUsLw49tZQt8EQrTX8b8RDWA4IeQUh6ZUf1pmSodI2zDX3lCVoS3k+DyDRCWtvufRkNKVitiq5jdk5rSGznpstN67c0kAEOHqRqgzMB7F3Xr1zSkZo771J04m00KMLNv2yK5ILnJlTUyIgXFtUuf0zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b83FG1t5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b83FG1t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D075C433C7;
	Sat, 24 Feb 2024 02:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708740355;
	bh=/rvZvHXcTF4KXOIn6ccWJVNn3UbM487AiqcORr+9iR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b83FG1t5UzZee/lgwnCrkMVKbebaTdBXaX+3L2+/gnW7OoN6wOVweyfYiPISmquK6
	 eWV9ItK86g5QyjQJYunmmNuMRdqBtyGF8fM7likHZNrH8RuFJMA96uzy7omd8GFU46
	 IY0dUkhLhl29PwYjoDw26PMLryKKwjhBC1FCpP9HkvoD2byiQF0jqESDOQR2dBcxmd
	 eOGpfyLy0rrhGUPuW71eZ8ofaIL7Mbs8SGR97jYa3Ip79ORVwisXY4yimQzRbTVZGA
	 enPPxYQbx/rmgQRY2FrILCmMWI9XhvfaNXX/Lyl/l4pLUb4zejuN1gaRdaGe6XFvIV
	 ITxu6idGrbcbw==
Date: Fri, 23 Feb 2024 18:05:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: skip background cowblock trims on inodes open for
 write
Message-ID: <20240224020554.GP6226@frogsfrogsfrogs>
References: <20240214165231.84925-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214165231.84925-1-bfoster@redhat.com>

On Wed, Feb 14, 2024 at 11:52:31AM -0500, Brian Foster wrote:
> The background blockgc scanner runs on a 5m interval by default and
> trims preallocation (post-eof and cow fork) from inodes that are
> otherwise idle. Idle effectively means that iolock can be acquired
> without blocking and that the inode has no dirty pagecache or I/O in
> flight.
> 
> This simple mechanism and heuristic has worked fairly well for
> post-eof speculative preallocations. Support for reflink and COW
> fork preallocations came sometime later and plugged into the same
> mechanism, with similar heuristics. Some recent testing has shown
> that COW fork preallocation may be notably more sensitive to blockgc
> processing than post-eof preallocation, however.
> 
> For example, consider an 8GB reflinked file with a COW extent size
> hint of 1MB. A worst case fully randomized overwrite of this file
> results in ~8k extents of an average size of ~1MB. If the same
> workload is interrupted a couple times for blockgc processing
> (assuming the file goes idle), the resulting extent count explodes
> to over 100k extents with an average size <100kB. This is
> significantly worse than ideal and essentially defeats the COW
> extent size hint mechanism.
> 
> While this particular test is instrumented, it reflects a fairly
> reasonable pattern in practice where random I/Os might spread out
> over a large period of time with varying periods of (in)activity.
> For example, consider a cloned disk image file for a VM or container
> with long uptime and variable and bursty usage. A background blockgc
> scan that races and processes the image file when it happens to be
> clean and idle can have a significant effect on the future
> fragmentation level of the file, even when still in use.
> 
> To help combat this, update the heuristic to skip cowblocks inodes
> that are currently opened for write access during non-sync blockgc
> scans. This allows COW fork preallocations to persist for as long as
> possible unless otherwise needed for functional purposes (i.e. a
> sync scan), the file is idle and closed, or the inode is being
> evicted from cache.

Hmmm.  Thinking this over a bit more, I wonder if we really want this
heuristic?

If we're doing our periodic background scan then sure, I think it's ok
to ignore files that are open for write but aren't actively being
written to.

This might introduce nastier side effects if OTOH we're doing blockgc
because we've hit ENOSPC and we're trying to free up any blocks that we
can.  I /think/ the way you've written the inode_is_open_for_write check
means that we scan maximally for ENOSPC.

However, xfs_blockgc_free_dquots doesn't seem to do synchronous scans
for EDQUOT.  So if we hit quota limits, we won't free maximally, right?
OTOH I guess we don't really do that now either, so maybe it doesn't
matter?

<shrug> Thoughts?

--D

> Suggested-by: Darrick Wong <djwong@kernel.org>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This fell out of some of the discussion on a prospective freeze time
> blockgc scan. I ran this through the same random write test described in
> that thread and it prevented all cowblocks trimming until the file is
> released.
> 
> Brian
> 
> [1] https://lore.kernel.org/linux-xfs/ZcutUN5B2ZCuJfXr@bfoster/
> 
>  fs/xfs/xfs_icache.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index dba514a2c84d..d7c54e45043a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1240,8 +1240,13 @@ xfs_inode_clear_eofblocks_tag(
>   */
>  static bool
>  xfs_prep_free_cowblocks(
> -	struct xfs_inode	*ip)
> +	struct xfs_inode	*ip,
> +	struct xfs_icwalk	*icw)
>  {
> +	bool			sync;
> +
> +	sync = icw && (icw->icw_flags & XFS_ICWALK_FLAG_SYNC);
> +
>  	/*
>  	 * Just clear the tag if we have an empty cow fork or none at all. It's
>  	 * possible the inode was fully unshared since it was originally tagged.
> @@ -1262,6 +1267,15 @@ xfs_prep_free_cowblocks(
>  	    atomic_read(&VFS_I(ip)->i_dio_count))
>  		return false;
>  
> +	/*
> +	 * A full cowblocks trim of an inode can have a significant effect on
> +	 * fragmentation even when a reasonable COW extent size hint is set.
> +	 * Skip cowblocks inodes currently open for write on opportunistic
> +	 * blockgc scans.
> +	 */
> +	if (!sync && inode_is_open_for_write(VFS_I(ip)))
> +		return false;
> +
>  	return true;
>  }
>  
> @@ -1291,7 +1305,7 @@ xfs_inode_free_cowblocks(
>  	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
>  		return 0;
>  
> -	if (!xfs_prep_free_cowblocks(ip))
> +	if (!xfs_prep_free_cowblocks(ip, icw))
>  		return 0;
>  
>  	if (!xfs_icwalk_match(ip, icw))
> @@ -1320,7 +1334,7 @@ xfs_inode_free_cowblocks(
>  	 * Check again, nobody else should be able to dirty blocks or change
>  	 * the reflink iflag now that we have the first two locks held.
>  	 */
> -	if (xfs_prep_free_cowblocks(ip))
> +	if (xfs_prep_free_cowblocks(ip, icw))
>  		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
>  	return ret;
>  }
> -- 
> 2.42.0
> 
