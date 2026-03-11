Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304A5296BCF;
	Wed, 11 Mar 2026 22:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773267250; cv=none; b=ldgedCG4JWtoAT8NEtjJzOeDz/lEwahKUuQvH3ctAcxcznM0IPTEzqOQqnmlng3hLn9Y7TgUEVkdSE3cM7nXuWaKFdCMZ45rKC0dgftWNdqhOWECOpp+hhmhFvjcW7cVayYZAtufP7ySNiw2+zfGWhbNou0ZslqJR7TTEib4NoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773267250; c=relaxed/simple;
	bh=O8ufv9orCb9gjhbQTXjts26HeQJe0VHg+7ffSfToflo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mebG4oYY4n8RRTKEnTmkSas4TOCmF5r0kv8+MKi4Hg3fc6x15c+XKzvE2WOasCTu7TPCOjyC+G76hxT6ftMw/ZDYLRYldgmzo5bkTBYgwyV10oFzfw58kDDkiTalJJXKcBhckFtGkXobE/EFUEI0pCamCFmw39uZ8oOuNtzRnQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iQovA7sV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQovA7sV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A46C4CEF7;
	Wed, 11 Mar 2026 22:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773267249;
	bh=O8ufv9orCb9gjhbQTXjts26HeQJe0VHg+7ffSfToflo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iQovA7sVKEYkt4XtYecOThXZEBSxyKJkMp0ZKpkUAW2PSJwENulhtJfJZFJjnEvzy
	 Jq1eugqFxCJlaS3C60TkvvT59m3meVQ5YLhBWuo6gGEsZWlqYzL78KOMcEqeFZ+wgf
	 d1DDB3LKvL0j+pWSzjlOwtOCYnyeePMxo0/D9zKARRJKtn1t2YjFxmFjWLZt16ejFG
	 tqEkuDCng6sIUATbgUFh3JGFHnMeiRZ8ea+uh3Xx+/KJF3RD+zfKTGh3TMDTFCgMKv
	 gN55jiKnrnOuoSTfc5maOhOGbhlGRWJ49LCf5rDIRzQaPr45QA1tCK1AEcmRsUQsEl
	 m8PVfk5khZz+g==
Date: Wed, 11 Mar 2026 15:14:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 2/8] xfs: flush dirty pagecache over hole in zoned
 mode zero range
Message-ID: <20260311221408.GE1770774@frogsfrogsfrogs>
References: <20260311162502.192375-1-bfoster@redhat.com>
 <20260311162502.192375-3-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311162502.192375-3-bfoster@redhat.com>

On Wed, Mar 11, 2026 at 12:24:56PM -0400, Brian Foster wrote:
> For zoned filesystems a window exists between the first write to a
> sparse range (i.e. data fork hole) and writeback completion where we
> might spuriously observe holes in both the COW and data forks. This
> occurs because a buffered write populates the COW fork with
> delalloc, writeback submission removes the COW fork delalloc blocks
> and unlocks the inode, and then writeback completion remaps the
> physically allocated blocks into the data fork. If a zero range
> operation does a lookup during this window where both forks show a
> hole, it incorrectly reports a hole mapping for a range that
> contains data.
> 
> This currently works because iomap checks for dirty pagecache over
> holes and unwritten mappings. If found, it flushes and retries the
> lookup. We plan to remove the hole flush logic from iomap, however,
> so lift the flush into xfs_zoned_buffered_write_iomap_begin() to
> preserve behavior and document the purpose for it. Zoned XFS
> filesystems don't support unwritten extents, so if zoned mode can
> come up with a way to close this transient hole window in the
> future, this flush can likely be removed.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iomap.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 8c3469d2c73e..d3b8c018c883 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1590,6 +1590,7 @@ xfs_zoned_buffered_write_iomap_begin(
>  {
>  	struct iomap_iter	*iter =
>  		container_of(iomap, struct iomap_iter, iomap);
> +	struct address_space	*mapping = inode->i_mapping;
>  	struct xfs_zone_alloc_ctx *ac = iter->private;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -1614,6 +1615,7 @@ xfs_zoned_buffered_write_iomap_begin(
>  	if (error)
>  		return error;
>  
> +restart:
>  	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
>  	if (error)
>  		return error;
> @@ -1686,8 +1688,25 @@ xfs_zoned_buffered_write_iomap_begin(
>  	 * When zeroing, don't allocate blocks for holes as they are already
>  	 * zeroes, but we need to ensure that no extents exist in both the data
>  	 * and COW fork to ensure this really is a hole.
> +	 *
> +	 * A window exists where we might observe a hole in both forks with
> +	 * valid data in cache. Writeback removes the COW fork blocks on
> +	 * submission but doesn't remap into the data fork until completion. If
> +	 * the data fork was previously a hole, we'll fail to zero. Until we
> +	 * find a way to avoid this transient state, check for dirty pagecache
> +	 * and flush to wait on blocks to land in the data fork.
>  	 */
>  	if ((flags & IOMAP_ZERO) && srcmap->type == IOMAP_HOLE) {
> +		if (filemap_range_needs_writeback(mapping, offset,
> +				offset + count - 1)) {
> +			xfs_iunlock(ip, lockmode);
> +			error = filemap_write_and_wait_range(mapping, offset,
> +					offset + count - 1);
> +			if (error)
> +				return error;
> +			goto restart;
> +		}

Seems fine to me.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
>  		xfs_hole_to_iomap(ip, iomap, offset_fsb, end_fsb);
>  		goto out_unlock;
>  	}
> -- 
> 2.52.0
> 
> 
