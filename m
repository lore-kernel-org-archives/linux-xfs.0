Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B345276041
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 09:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784019689; cv=none; b=V4FXRviBzJ9Mkrrn0eJMM5/tysM1NRVbmZOCHukViXKaG9Z0/CPWlnvnLmNpAKWylsWywO7dEpa36C36Br200dHjx+XfaOmM4YE9i4Npq2NGOLHqPUtM2LigsjqcB2cqePL4zmzJf162al56LX7PFlb+PJHgNViH+Kp4NXM/uX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784019689; c=relaxed/simple;
	bh=FfQhNl0DcXKVuCYHJwadnUMqeBtECiHAzExsLhS6JAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e8+/IPW1rYNOPAYEIH0z2GHhaZqGhdCCUZoeO/HArDPDEmGW1KHZl9nXeaso0Hy7EjfQ9sfkLKhX64qlmR/1Njt4dYwBHPfo2+mpAcISSkr8J8FbEPXNtMA4o+BPttsbhyRK6s9laXNjmSq6r6SF1zyFpDuZLy9Cwouj/Fhu94k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lcuhs1K7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lcuhs1K7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76241F000E9;
	Tue, 14 Jul 2026 09:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784019687;
	bh=IeWFSV+5TmeNUkIEn9uhtdM1TdKNsntyi2QLZMPva1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lcuhs1K79/OowMPnyF8BihoYqo/dzBhJG38QhPpm0lKvV9rSmSqfX2Y7FQctqD/x/
	 gGBq1UoeoZIl9/zUb2kFXVUEG9SF4VZG7JRa2CLTGrdNDReGWRwlkR1xqfTNVf7Smy
	 1Wn4UoMTB6tqHv1F/LIvYDJXORjbEjJ7ytrZL4m/jLyHCzTq09uAIUNJ6tUe3DDriY
	 acfItIDwB1olHdx04JsIfM76jVtdv9NgK6Cg1aR23gvHW9vpnlxicxieBE7Dp9CX7a
	 wajKFyHVC6QpvZsDK1VINqccBy9iVBN10a6NDzWFAxrjx3bCV8pEDaKPcP4cz62zlX
	 zwnJfmQjul94w==
Date: Tue, 14 Jul 2026 11:01:23 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: resample the data fork mapping after cycling ILOCK
Message-ID: <alX63M11tY_xPnrn@nidhogg.toxiclabs.cc>
References: <20260714060344.GA7380@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714060344.GA7380@frogsfrogsfrogs>

On Mon, Jul 13, 2026 at 11:03:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_reflink_fill_{cow_hole,delalloc} are both presented with an inode,
> a data fork mapping, and a cow fork mapping.  Unfortunately, these two
> helpers cycle the ILOCK to grab a transaction, which means that the
> mappings are stale as soon as we reacquire the ILOCK.  Currently we
> refresh the cow fork mapping by re-calling xfs_find_trim_cow_extent, but
> we don't refresh the data fork mapping beforehand, which means that the
> xfs_bmap_trim_cow in that function queries the refcount btree about the
> wrong physical blocks and returns an inaccurate value in *shared.
> 
> If *shared is now false, the directio write proceeds with a stale data
> fork mapping.  Fix this by querying the data fork mapping if the
> sequence counter changes across the ILOCK cycle.
> 
> Cc: <hch@lst.de>
> Cc: <stable@vger.kernel.org> # v4.11
> Fixes: 3c68d44a2b49a0 ("xfs: allocate direct I/O COW blocks in iomap_begin")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_reflink.c |   36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index d81510912be58b..489ecd4cf10aff 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -440,6 +440,7 @@ xfs_reflink_fill_cow_hole(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
>  	xfs_filblks_t		resaligned;
> +	unsigned int		seq_before = READ_ONCE(ip->i_df.if_seq);
>  	unsigned int		dblocks = 0, rblocks = 0;
>  	int			nimaps;
>  	int			error;
> @@ -465,6 +466,22 @@ xfs_reflink_fill_cow_hole(
>  
>  	*lockmode = XFS_ILOCK_EXCL;
>  
> +	/*
> +	 * The data fork mapping may have changed while we dropped the ILOCK
> +	 * (a racing O_DIRECT writer under IOLOCK_SHARED can complete a full
> +	 * CoW cycle including xfs_reflink_end_cow(), which remaps this offset
> +	 * and drops the refcount of the old shared block).  Re-read it so the
> +	 * shared-status recheck below and the caller's in-place iomap both
> +	 * operate on the current mapping rather than a stale physical block.
> +	 */
> +	if (seq_before != READ_ONCE(ip->i_df.if_seq)) {
> +		nimaps = 1;
> +		error = xfs_bmapi_read(ip, imap->br_startoff,
> +				imap->br_blockcount, imap, &nimaps, 0);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
>  	error = xfs_find_trim_cow_extent(ip, imap, cmap, shared, &found);
>  	if (error || !*shared)
>  		goto out_trans_cancel;
> @@ -511,6 +528,8 @@ xfs_reflink_fill_delalloc(
>  	bool			found;
>  
>  	do {
> +		unsigned int	seq_before = READ_ONCE(ip->i_df.if_seq);
> +
>  		xfs_iunlock(ip, *lockmode);
>  		*lockmode = 0;
>  
> @@ -521,6 +540,23 @@ xfs_reflink_fill_delalloc(
>  
>  		*lockmode = XFS_ILOCK_EXCL;
>  
> +		/*
> +		 * The data fork mapping may have changed while we dropped the
> +		 * ILOCK (a racing O_DIRECT writer under IOLOCK_SHARED can
> +		 * complete a full CoW cycle including xfs_reflink_end_cow(),
> +		 * which remaps this offset and drops the refcount of the old
> +		 * shared block).  Re-read it so the shared-status recheck
> +		 * below and the caller's in-place iomap both operate on the
> +		 * current mapping rather than a stale physical block.
> +		 */
> +		if (seq_before != READ_ONCE(ip->i_df.if_seq)) {
> +			nimaps = 1;
> +			error = xfs_bmapi_read(ip, imap->br_startoff,
> +					imap->br_blockcount, imap, &nimaps, 0);
> +			if (error)
> +				goto out_trans_cancel;
> +		}
> +
>  		error = xfs_find_trim_cow_extent(ip, imap, cmap, shared,
>  				&found);
>  		if (error || !*shared)
> 
