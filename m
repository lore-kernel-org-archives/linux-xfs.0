Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C43403151;
	Fri, 15 May 2026 17:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778866248; cv=none; b=q/MFJEfLI+NMK1Zj2gcqJleiWDorVVa58w2uz6T39JR+7VVd2M4izQDGy/aBy2va98ZkzVKcFy4k3pYGCQzJ39eSnva75hdsZLFjYeOXMle/9shb6Jc9P0sk6eqz7v75GIQJZP22YCumX9UwSkJ/iHJzCZAsL0umiX8xQLW6Yug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778866248; c=relaxed/simple;
	bh=5nt6EvBqOR8ML1SWq7SYKTUPIupueoHdr4o8sHmleqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QNngXlJwYQ+ywOOgDHDRGD0edWFxjggA2UL6BEb1sqj6fyoO+oD5meh07pc6W4x2XOY7ohCws6lepZlIDUhjr/AX6RsYXvjxrHR0rXzhc+vGxEA3zB65Huwl2339SLScAzkEWPHAhGDP5oE+a0/TquNEjqbIOrL9OZwE1KGA3Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=omMqj2ly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="omMqj2ly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFBBC2BCB0;
	Fri, 15 May 2026 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778866248;
	bh=5nt6EvBqOR8ML1SWq7SYKTUPIupueoHdr4o8sHmleqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=omMqj2lylQEYB0UacPMXHDI3WxIzlqwrNpCe+9WJNfCdJcvbd/CoMHEVDlUhD/NPW
	 TXwwUBu1W0bXz0gy3KRxqIUWexmOYWjzLNlBFEYb9OnxaG/SYMkJGy36Zc95hghSvL
	 phlN1EgJ7T+LPnDSspOBnkNg3pbon3qe1Su4kDGsBmzXLUzE+5awajiUSs8fkns6Gw
	 UKgzb0R+Pn+a6Rt8EYmHVLZ24Vn/M9NIY48J3J2/rjau1LBqMPTYFAaVIu9ihfZD5K
	 pJWdn4y9ABMXdEouNwUWqHHahgKvk33+cNw6Y9fTB7/JeC2KLhkA1tiRXBJKDlbaxr
	 sVC0I71Krf43A==
Date: Fri, 15 May 2026 10:30:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, brauner@kernel.org, hch@infradead.org,
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH 4/4] iomap: fix out-of-bounds bitmap_set() with
 zero-length range
Message-ID: <20260515173047.GC9555@frogsfrogsfrogs>
References: <20260514062955.1183976-1-yi.zhang@huaweicloud.com>
 <20260514062955.1183976-5-yi.zhang@huaweicloud.com>
 <20260514181053.GB9555@frogsfrogsfrogs>
 <827c4380-4251-40af-bc14-207111736464@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <827c4380-4251-40af-bc14-207111736464@huaweicloud.com>

On Fri, May 15, 2026 at 09:50:08AM +0800, Zhang Yi wrote:
> On 5/15/2026 2:10 AM, Darrick J. Wong wrote:
> > On Thu, May 14, 2026 at 02:29:55PM +0800, Zhang Yi wrote:
> >> From: Zhang Yi <yi.zhang@huawei.com>
> >>
> >> ifs_set_range_dirty() and ifs_set_range_uptodate() compute last_blk
> >> as (off + len - 1) >> i_blkbits.  When off is 0 and len is 0, the
> >> unsigned subtraction underflows to SIZE_MAX, producing a huge
> >> last_blk and nr_blks value that causes bitmap_set() to write far
> >> beyond the ifs->state allocation.
> >>
> >> Regarding ifs_set_range_uptodate(), it is temporarily safe because len
> >> cannot be passed in as 0. However, for ifs_set_range_dirty() this is
> >> reachable from __iomap_write_end(): when copy_folio_from_iter_atomic()
> >> returns 0 (e.g. user buffer fault) and the folio is already uptodate,
> >> the guard at the top of __iomap_write_end() does not trigger because
> >> !folio_test_uptodate() is false, and iomap_set_range_dirty() is called
> >> with copied == 0.
> >>
> >> Add a !len guard to both functions before the computation, so that a
> >> zero-length range is a no-op.
> >>
> >> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> >> ---
> >>  fs/iomap/buffered-io.c | 23 +++++++++++++++--------
> >>  1 file changed, 15 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> >> index 27ab33edbdee..6fe5f7e998fd 100644
> >> --- a/fs/iomap/buffered-io.c
> >> +++ b/fs/iomap/buffered-io.c
> >> @@ -67,11 +67,14 @@ static bool ifs_set_range_uptodate(struct folio *folio,
> >>  		struct iomap_folio_state *ifs, size_t off, size_t len)
> >>  {
> >>  	struct inode *inode = folio->mapping->host;
> >> -	unsigned int first_blk = off >> inode->i_blkbits;
> >> -	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
> >> -	unsigned int nr_blks = last_blk - first_blk + 1;
> >> +	unsigned int first_blk, last_blk;
> >>  
> >> -	bitmap_set(ifs->state, first_blk, nr_blks);
> >> +	if (!len)
> >> +		return true;
> >> +
> >> +	first_blk = off >> inode->i_blkbits;
> >> +	last_blk = (off + len - 1) >> inode->i_blkbits;
> >> +	bitmap_set(ifs->state, first_blk, last_blk - first_blk + 1);
> >>  	return ifs_is_fully_uptodate(folio, ifs);
> >>  }
> >>  
> >> @@ -203,13 +206,17 @@ static void ifs_set_range_dirty(struct folio *folio,
> >>  {
> >>  	struct inode *inode = folio->mapping->host;
> >>  	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
> >> -	unsigned int first_blk = (off >> inode->i_blkbits);
> >> -	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
> >> -	unsigned int nr_blks = last_blk - first_blk + 1;
> >> +	unsigned int first_blk, last_blk;
> >>  	unsigned long flags;
> >>  
> >> +	if (!len)
> >> +		return;
> >> +
> >> +	first_blk = off >> inode->i_blkbits;
> >> +	last_blk = (off + len - 1) >> inode->i_blkbits;
> >>  	spin_lock_irqsave(&ifs->state_lock, flags);
> >> -	bitmap_set(ifs->state, first_blk + blks_per_folio, nr_blks);
> >> +	bitmap_set(ifs->state, first_blk + blks_per_folio,
> >> +		   last_blk - first_blk + 1);
> > 
> > I'm curious about the inconsistency in the computations between
> > ifs_clear_range_dirty and ifs_set_range_dirty now.  In the function that
> > clears dirty bits, off/len are rounded inwards:
> > 
> > 	unsigned int first_blk = round_up(off, i_blocksize(inode)) >>
> > 				 inode->i_blkbits;
> > 	unsigned int last_blk = (off + len) >> inode->i_blkbits;
> > 	unsigned long flags;
> > 
> > 	if (first_blk >= last_blk)
> > 		return;
> > 
> > 	spin_lock_irqsave(&ifs->state_lock, flags);
> > 	bitmap_clear(ifs->state, first_blk + blks_per_folio,
> > 		     last_blk - first_blk);
> > 
> > but here we're still rounding outwards:
> > 
> > 	if (!len)
> > 		return;
> > 
> > 	first_blk = off >> inode->i_blkbits;
> > 	last_blk = (off + len - 1) >> inode->i_blkbits;
> > 	spin_lock_irqsave(&ifs->state_lock, flags);
> > 	bitmap_set(ifs->state, first_blk + blks_per_folio,
> > 		   last_blk - first_blk + 1);
> > 
> > That doesn't quite sound right to me without an explanation in the code,
> > which currently lacks one.  I *think* the reason for the discrepancy is
> > that if we want to dirty part of an fsblock, we need to mark the whole
> > block dirty in the ifs so that all the blocks get written out; but when
> > we're clearing dirty bits, we want to leave an fsblock dirty if we only
> > wrote back part of that fsblock.  Does that sound right?
> > 
> > --D
> > 
> 
> Yes, that's right. The primary purpose of clearing the dirty bit is for
> invalidating a partial folio(e.g., when punching hole). Only when a full
> fsblock has been invalidated can its corresponding dirty bit be cleared.
> Write-back operations never seem to write back only part of a fsblock.
> 
> I can add comments for them in my next iteration.

Sounds good, thank you.

(Does this patch also need a fixes tag like Joanne asked?)

--D

> Thanks,
> Yi.
> 
> 
> 
