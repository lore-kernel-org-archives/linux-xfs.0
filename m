Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13404332EAC;
	Thu, 14 May 2026 18:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778782254; cv=none; b=t2Hqr1OPhzkAhYdl+fuou2/YMl66tZuDFxlV3GtXByS4P2I5Z+FVpI/XWbbYlffakiGhh3YB3uYwokDKfSoG1vJFELMHpaGhtLxqRMBnWndjsYELbHQhtGqW2l/OMYciR6vKqmjB86FISz2pkftueH2BRil1HU55So5Vl6x/MnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778782254; c=relaxed/simple;
	bh=sFiP6sSRnbIOzDiNGtTOqku0plnunILN+CHF9u6HgO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYxcl7BeRehDQ5sB96BWq1dndMfvdFshqKjA0V4SrXkmV8NjWHso4zvZ5fNDJU/oaHpFqj0rPsw3HpfcBf3spdzkx68DU5wAhyW1+YVkSUFY46PIEL/gAI7d3c89Ynrs/3yqX29yFZNNwSiq1Udsir0jvzoAxGcwNDEyY697VGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bM3g+y8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bM3g+y8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1562C2BCB3;
	Thu, 14 May 2026 18:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778782253;
	bh=sFiP6sSRnbIOzDiNGtTOqku0plnunILN+CHF9u6HgO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bM3g+y8aunTOdheYLSc9GV1pjJgC0mtD8phvhUbxrQ7b+tzp683lsOyqF1bSY3ycg
	 N73FrF2AlZHeVWr0w52fVOXUS38N1bY50DHvn6MoiBRemjzGN2prhjzSF2igCmGOV/
	 27Qf6BYd1E+6STx1sL4YaBp4Bv+3Fa0RU7ucfs7e//2sN6UkXjRjGW1AQmCHMB06n1
	 qY8M2Gq6XOm7fMMSTKKFNIIwCFFc4gIl5WhliMu2rISKIWmUbLOnNQXoWZv+OEh7E1
	 JCS5XbJI0a4XZ9v/nlntIT9q+w+W9vtTgF/5cHsFBWIQEBdHYLjFN8x7WqFmTF6i+M
	 yqxV2tYZEb5Ng==
Date: Thu, 14 May 2026 11:10:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, brauner@kernel.org, hch@infradead.org,
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH 4/4] iomap: fix out-of-bounds bitmap_set() with
 zero-length range
Message-ID: <20260514181053.GB9555@frogsfrogsfrogs>
References: <20260514062955.1183976-1-yi.zhang@huaweicloud.com>
 <20260514062955.1183976-5-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514062955.1183976-5-yi.zhang@huaweicloud.com>

On Thu, May 14, 2026 at 02:29:55PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> ifs_set_range_dirty() and ifs_set_range_uptodate() compute last_blk
> as (off + len - 1) >> i_blkbits.  When off is 0 and len is 0, the
> unsigned subtraction underflows to SIZE_MAX, producing a huge
> last_blk and nr_blks value that causes bitmap_set() to write far
> beyond the ifs->state allocation.
> 
> Regarding ifs_set_range_uptodate(), it is temporarily safe because len
> cannot be passed in as 0. However, for ifs_set_range_dirty() this is
> reachable from __iomap_write_end(): when copy_folio_from_iter_atomic()
> returns 0 (e.g. user buffer fault) and the folio is already uptodate,
> the guard at the top of __iomap_write_end() does not trigger because
> !folio_test_uptodate() is false, and iomap_set_range_dirty() is called
> with copied == 0.
> 
> Add a !len guard to both functions before the computation, so that a
> zero-length range is a no-op.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/iomap/buffered-io.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 27ab33edbdee..6fe5f7e998fd 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -67,11 +67,14 @@ static bool ifs_set_range_uptodate(struct folio *folio,
>  		struct iomap_folio_state *ifs, size_t off, size_t len)
>  {
>  	struct inode *inode = folio->mapping->host;
> -	unsigned int first_blk = off >> inode->i_blkbits;
> -	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
> -	unsigned int nr_blks = last_blk - first_blk + 1;
> +	unsigned int first_blk, last_blk;
>  
> -	bitmap_set(ifs->state, first_blk, nr_blks);
> +	if (!len)
> +		return true;
> +
> +	first_blk = off >> inode->i_blkbits;
> +	last_blk = (off + len - 1) >> inode->i_blkbits;
> +	bitmap_set(ifs->state, first_blk, last_blk - first_blk + 1);
>  	return ifs_is_fully_uptodate(folio, ifs);
>  }
>  
> @@ -203,13 +206,17 @@ static void ifs_set_range_dirty(struct folio *folio,
>  {
>  	struct inode *inode = folio->mapping->host;
>  	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
> -	unsigned int first_blk = (off >> inode->i_blkbits);
> -	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
> -	unsigned int nr_blks = last_blk - first_blk + 1;
> +	unsigned int first_blk, last_blk;
>  	unsigned long flags;
>  
> +	if (!len)
> +		return;
> +
> +	first_blk = off >> inode->i_blkbits;
> +	last_blk = (off + len - 1) >> inode->i_blkbits;
>  	spin_lock_irqsave(&ifs->state_lock, flags);
> -	bitmap_set(ifs->state, first_blk + blks_per_folio, nr_blks);
> +	bitmap_set(ifs->state, first_blk + blks_per_folio,
> +		   last_blk - first_blk + 1);

I'm curious about the inconsistency in the computations between
ifs_clear_range_dirty and ifs_set_range_dirty now.  In the function that
clears dirty bits, off/len are rounded inwards:

	unsigned int first_blk = round_up(off, i_blocksize(inode)) >>
				 inode->i_blkbits;
	unsigned int last_blk = (off + len) >> inode->i_blkbits;
	unsigned long flags;

	if (first_blk >= last_blk)
		return;

	spin_lock_irqsave(&ifs->state_lock, flags);
	bitmap_clear(ifs->state, first_blk + blks_per_folio,
		     last_blk - first_blk);

but here we're still rounding outwards:

	if (!len)
		return;

	first_blk = off >> inode->i_blkbits;
	last_blk = (off + len - 1) >> inode->i_blkbits;
	spin_lock_irqsave(&ifs->state_lock, flags);
	bitmap_set(ifs->state, first_blk + blks_per_folio,
		   last_blk - first_blk + 1);

That doesn't quite sound right to me without an explanation in the code,
which currently lacks one.  I *think* the reason for the discrepancy is
that if we want to dirty part of an fsblock, we need to mark the whole
block dirty in the ifs so that all the blocks get written out; but when
we're clearing dirty bits, we want to leave an fsblock dirty if we only
wrote back part of that fsblock.  Does that sound right?

--D
