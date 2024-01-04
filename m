Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B372E200A6
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cIilr1w3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A50C433C7;
	Thu,  4 Jan 2024 07:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704353538;
	bh=Ir+hSL/h830pk2UmhEUWpsF4k6yYjZg2KKAawdIz818=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cIilr1w34Fge2JxbJuIy2G6yrzJsCd8wjoEXpB7CEiAsAzLvjWo8eTvSyktrpTqBU
	 2Uw9xyqQiV8UEsmjjA4S6htEGL8R9YQQ5CTA/ENYfgUwQ4tK9mn4SZWSiffUGQTtd0
	 gYxNrFA+lpMtKLHknj3FWYjXOMBi57NoNFTOZZGaVa9HFoKNvfyxwe306oazejyOAq
	 84CCYOoYY3y2ZPrWMWKQI4RX3LQTvedZrr5pjZexKr8h6JBhpWu7C5avoghqfKcW6D
	 iBjxP6huNqPEQ9bMKMQwOGzolrzJzGRYrOFBoYfgiruGXXCw7nH5bORmydXRKuJ1dO
	 oDkttJRXLDJjQ==
Date: Wed, 3 Jan 2024 23:32:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 9/9] xfs: connect in-memory btrees to xfiles
Message-ID: <20240104073217.GD361584@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829726.1748854.1262147267981918901.stgit@frogsfrogsfrogs>
 <ZZZWFjy1fGwSCx7C@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZZWFjy1fGwSCx7C@infradead.org>

On Wed, Jan 03, 2024 at 10:54:14PM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:15:54PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add to our stubbed-out in-memory btrees the ability to connect them with
> > an actual in-memory backing file (aka xfiles) and the necessary pieces
> > to track free space in the xfile and flush dirty xfbtree buffers on
> > demand, which we'll need for online repair.
> 
> I guess this is is split from the last patch because of the size of
> the changes?   Because it feels they relong belong together.  Maybe with
> my patches for the diet and splitting out the new helpers outside the
> btree code these could now become a single commit?

Yep.

> > +#ifdef CONFIG_XFS_BTREE_IN_XFILE
> > +static inline unsigned long
> > +xfbtree_ino(
> > +	struct xfbtree		*xfbt)
> > +{
> > +	return file_inode(xfbt->target->bt_xfile->file)->i_ino;
> > +}
> > +#endif /* CONFIG_XFS_BTREE_IN_XFILE */
> 
> This should probably move to xfile.h?
> 
> > +	/* Make sure we actually can write to the block before we return it. */
> > +	pos = xfo_to_b(bt_xfoff);
> > +	error = xfile_prealloc(xfbtree_xfile(xfbt), pos, xfo_to_b(1));
> > +	if (error)
> > +		return error;
> 
> IFF we stick to always backing the buffers directly by the shmem
> pages this won't be needed - the btree code does a buf_get right after
> calling into ->alloc_blocks that will allocate the page.

Yep, that would make things much simpler.

> > +int
> > +xfbtree_free_block(
> > +	struct xfs_btree_cur	*cur,
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfbtree		*xfbt = cur->bc_mem.xfbtree;
> > +	xfileoff_t		bt_xfoff, bt_xflen;
> > +
> > +	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
> > +
> > +	bt_xfoff = xfs_daddr_to_xfot(xfs_buf_daddr(bp));
> > +	bt_xflen = xfs_daddr_to_xfot(bp->b_length);
> > +
> > +	trace_xfbtree_free_block(xfbt, cur, bt_xfoff);
> > +
> > +	return xfboff_bitmap_set(&xfbt->freespace, bt_xfoff, bt_xflen);
> 
> Any reason this doesn't actually remove the page from shmem?

I think I skipped the shmem_truncate_range call because the next btree
block allocation will re-use the page immediately.

> > +int
> > +xfbtree_trans_commit(
> > +	struct xfbtree		*xfbt,
> > +	struct xfs_trans	*tp)
> > +{
> > +	LIST_HEAD(buffer_list);
> > +	struct xfs_log_item	*lip, *n;
> > +	bool			corrupt = false;
> > +	bool			tp_dirty = false;
> 
> Can we have some sort of flag on the xfs_trans structure that marks it
> as fake for xfbtree, and assert it gets fed here, and add ansother
> assert it desn't get fed to xfs_trans_commit/cancel?

Use an "empty" transaction?

> > +/* Discard pages backing a range of the xfile. */
> > +void
> > +xfile_discard(
> > +	struct xfile		*xf,
> > +	loff_t			pos,
> > +	u64			count)
> > +{
> > +	trace_xfile_discard(xf, pos, count);
> > +	shmem_truncate_range(file_inode(xf->file), pos, pos + count - 1);
> > +}
> 
> This doesn't end up being used.

I'll remove it then.

> > +/* Ensure that there is storage backing the given range. */
> > +int
> > +xfile_prealloc(
> > +	struct xfile		*xf,
> > +	loff_t			pos,
> > +	u64			count)
> 
> If we end up needing this somewhere else in the end (and it really
> should be a separate patch), we should be able to replace it with
> a simple xfile_get_page/xfile_put_page pair.

I think the only place it gets used is btree block allocation to make
sure a page has been stuffed into the xfile/memfd recently.  Probably it
could go away since a write failure will be noticed quickly anyway.

--D
