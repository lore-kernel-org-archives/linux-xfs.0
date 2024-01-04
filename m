Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5341DDC8
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vGVPZvic"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=631qpLymvqNIbFQtnx7wkr1YH0EIy+0qU4AS3mMmlaE=; b=vGVPZvicEUP/78Vt4+6F9G8ryu
	OZ+9xF782VNJx3aFHoGwN+brQ4fJbi6S1a8B98u0nwS6O/Okc7pdRw/GpVsSNl+XGWUrYZc1gIAga
	AY8MAkyPTwW3YheImnq/6RwPWcs460Y6rE3KnBZ4FgGsVPXQO6TOQoLznrRsZNvzDChSbDNpND6+L
	E9RMwlEktzRTHfwJURQl1k4qFKbycHs4SmGlZdoZ/fgV99TRybn8Te96aPgt/xBFuPhBTgR6Tz7wX
	7vrWteQ7TGJbhqO/D/1lZiYZbiCs0o4C+Ivoq1fh5OxOVfEz2Y5jJLpSJ2akMsMTmBg+Ih+KjzCqv
	PakqGdqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLHcM-00D1ZE-1i;
	Thu, 04 Jan 2024 06:54:14 +0000
Date: Wed, 3 Jan 2024 22:54:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 9/9] xfs: connect in-memory btrees to xfiles
Message-ID: <ZZZWFjy1fGwSCx7C@infradead.org>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829726.1748854.1262147267981918901.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404829726.1748854.1262147267981918901.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:15:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add to our stubbed-out in-memory btrees the ability to connect them with
> an actual in-memory backing file (aka xfiles) and the necessary pieces
> to track free space in the xfile and flush dirty xfbtree buffers on
> demand, which we'll need for online repair.

I guess this is is split from the last patch because of the size of
the changes?   Because it feels they relong belong together.  Maybe with
my patches for the diet and splitting out the new helpers outside the
btree code these could now become a single commit?

> +#ifdef CONFIG_XFS_BTREE_IN_XFILE
> +static inline unsigned long
> +xfbtree_ino(
> +	struct xfbtree		*xfbt)
> +{
> +	return file_inode(xfbt->target->bt_xfile->file)->i_ino;
> +}
> +#endif /* CONFIG_XFS_BTREE_IN_XFILE */

This should probably move to xfile.h?

> +	/* Make sure we actually can write to the block before we return it. */
> +	pos = xfo_to_b(bt_xfoff);
> +	error = xfile_prealloc(xfbtree_xfile(xfbt), pos, xfo_to_b(1));
> +	if (error)
> +		return error;

IFF we stick to always backing the buffers directly by the shmem
pages this won't be needed - the btree code does a buf_get right after
calling into ->alloc_blocks that will allocate the page.

> +int
> +xfbtree_free_block(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfbtree		*xfbt = cur->bc_mem.xfbtree;
> +	xfileoff_t		bt_xfoff, bt_xflen;
> +
> +	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
> +
> +	bt_xfoff = xfs_daddr_to_xfot(xfs_buf_daddr(bp));
> +	bt_xflen = xfs_daddr_to_xfot(bp->b_length);
> +
> +	trace_xfbtree_free_block(xfbt, cur, bt_xfoff);
> +
> +	return xfboff_bitmap_set(&xfbt->freespace, bt_xfoff, bt_xflen);

Any reason this doesn't actually remove the page from shmem?

> +int
> +xfbtree_trans_commit(
> +	struct xfbtree		*xfbt,
> +	struct xfs_trans	*tp)
> +{
> +	LIST_HEAD(buffer_list);
> +	struct xfs_log_item	*lip, *n;
> +	bool			corrupt = false;
> +	bool			tp_dirty = false;

Can we have some sort of flag on the xfs_trans structure that marks it
as fake for xfbtree, and assert it gets fed here, and add ansother
assert it desn't get fed to xfs_trans_commit/cancel?

> +/* Discard pages backing a range of the xfile. */
> +void
> +xfile_discard(
> +	struct xfile		*xf,
> +	loff_t			pos,
> +	u64			count)
> +{
> +	trace_xfile_discard(xf, pos, count);
> +	shmem_truncate_range(file_inode(xf->file), pos, pos + count - 1);
> +}

This doesn't end up being used.

> +/* Ensure that there is storage backing the given range. */
> +int
> +xfile_prealloc(
> +	struct xfile		*xf,
> +	loff_t			pos,
> +	u64			count)

If we end up needing this somewhere else in the end (and it really
should be a separate patch), we should be able to replace it with
a simple xfile_get_page/xfile_put_page pair.
