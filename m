Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C831D532
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CChTIJu5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z0KsrxSGAjjCyxvSH+fMkXZMsd/mX/QOC5b1NV9BjyE=; b=CChTIJu5AH5pEfXxbqFSNIdj7t
	rWGtGdZCM1Va0bad+9g6EmcmrPxc23DeEo/FFxBDzhrTFoayImO4L3g+DRDfROI2B1ikXv3S9pI1A
	yG3UX7Ip0vBtClusFQbObvjy0NIYgpnNJp6SLYp/4nnUaLaM3L+uCJz/Yy3kz7kgRfdtvkQGzFEFK
	lO5zP9RUEzYHXgE3iOrSRWZbtHJYzFgcxE8fLbyt32xKX4ohs1Ll5qYXdQGAjAhoLtu4IOYMRXCtA
	dwTNB6vuh7IL26NQZZEv89gj/r1R5E23ZXZt0Q3KtNFcCy2K7XNoAgVGhGnDHMtFhEg01ICotyORQ
	uReCfzxA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLHW6-00D127-0k;
	Thu, 04 Jan 2024 06:47:46 +0000
Date: Wed, 3 Jan 2024 22:47:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 8/9] xfs: support in-memory btrees
Message-ID: <ZZZUkq145pW64Zzo@infradead.org>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829708.1748854.10994305200199735396.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404829708.1748854.10994305200199735396.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> -	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
> +	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
> +	    !(cur->bc_flags & XFS_BTREE_IN_XFILE) && cur->bc_ag.pag)
>  		xfs_perag_put(cur->bc_ag.pag);
> +	if (cur->bc_flags & XFS_BTREE_IN_XFILE) {
> +		if (cur->bc_mem.pag)
> +			xfs_perag_put(cur->bc_mem.pag);
> +	}

Btw, one thing I noticed is that we have a lot of confusion on what
part of the bc_ino/ag/mem union is used for a given btree.  For
On-disk inodes we abuse the long ptrs flag, and then we through in
the xfile flags.  If you're fine with it I can try to sort it out.
It's not really a blocker, but I think it would be a lot claner if
we used the chance to sort it out.  This will become even more
important with the rt rmap/reflink trees that will further increase
the confusion here.

> +	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
> +		return xfbtree_bbsize();
> +	return cur->bc_mp->m_bsize;
> +}

One thing I've been wondering is if we should split
a strut xfs_btree outof struct xfbtree that contains most of the
fields from it minuts the space allocation (and the new fake header
from my patches) and also use that for the on-disk btrees.

That means xfs_btree.c can use the target from it, and the owner
and we can remove the indirect calls for calculcating maxrecs/minrecs,
and then also add a field for the block size like this one and remove
a lof of the XFS_BTREE_IN_XFILE checks.

> +	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
> +		return 0;
> +
>  	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLFSBLOCK) {
>  		xfs_btree_reada_bufl(cur->bc_mp, left, 1,

Should the xfile check go into  xfs_buf_readahead instead?  That would
execute a little more useles code for in-memory btrees, but keep this
check in one place (where we could also write a nice comment explaining
it :))

> +	xfs_btree_buf_to_ptr(cur, bp, &bufptr);
>  	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> -		if (be64_to_cpu(rptr.l) == XFS_DADDR_TO_FSB(cur->bc_mp,
> -							xfs_buf_daddr(bp))) {
> +		if (rptr.l == bufptr.l) {
>  			xfs_btree_mark_sick(cur);
>  			return -EFSCORRUPTED;
>  		}
>  	} else {
> -		if (be32_to_cpu(rptr.s) == xfs_daddr_to_agbno(cur->bc_mp,
> -							xfs_buf_daddr(bp))) {
> +		if (rptr.s == bufptr.s) {

This almost screams for a xfs_btree_ptr_cmp helper, even if this
seems to be the only user so far..

> +static inline loff_t xfile_size(struct xfile *xf)
> +{
> +	return i_size_read(file_inode(xf->file));
> +}

Despite looking over the whole patch for a while I only noticed
this one, and I think I could add it in my xfile diet series
instea dof open coding it in trace.h.

In general it would be really nice to split out patches that add
infrastructure in other parts of the XFS codebase to make them stick
out a bit more.

> +/* file block (aka system page size) to basic block conversions. */
> +typedef unsigned long long	xfileoff_t;
> +#define XFB_BLOCKSIZE		(PAGE_SIZE)
> +#define XFB_BSHIFT		(PAGE_SHIFT)
> +#define XFB_SHIFT		(XFB_BSHIFT - BBSHIFT)
> +
> +static inline loff_t xfo_to_b(xfileoff_t xfoff)
> +{
> +	return xfoff << XFB_BSHIFT;
> +}

...

xfile.h feels like the wrong place for this - the encoding only really
makes sense fo the xfbtree.  And in a way it feels redundant over
just using pgoff_t and the PAGE_* constants directly which should be
pretty obvious to everyone knowning the Linux MM and page cache APIs.

> +/* Return the number of sectors for a buffer target. */
> +xfs_daddr_t
> +xfs_buftarg_nr_sectors(
> +	struct xfs_buftarg	*btp)
> +{
> +	if (btp->bt_flags & XFS_BUFTARG_XFILE)
> +		return xfile_buftarg_nr_sectors(btp);

If we didn't add an ifdef around the struct xfile definition, this could
just be open coded and rely on the compiler eliminating dead code when
XFS_BUFTARG_XFILE isn't defined.
