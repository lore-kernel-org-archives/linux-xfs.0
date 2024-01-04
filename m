Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72FE1EB41
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 07:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUkhYo9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA1BC433C8;
	Thu,  4 Jan 2024 07:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704353273;
	bh=h5oBFmRR/sOTxfVpYN3o7xWWRaOut7zHvhBGqbnwx3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SUkhYo9ouLXAeLqR4hhctXR3O5dyFYdfDAIJs2GuwpA4Gqr+2k4tu/7X7OyxKtvHq
	 crtDeB+v0a6gM1/vpzPLrYKJ9ixO8BRYML6XMXmtdFDXn8rpur7zVL5OAfDvCbfUMi
	 Mr19jIY0nMEcOUq0XWZLy4dTgvDUBZYfEp+Wm2M1QCJQ+tL+ZtPI6P31Lrn3AOek41
	 Zyl5+dzER62Q0NQYQ23YlAu4/Q89aGgboBTzyCdHa+MDIudYxy88G7DhRmdU5yng/a
	 OhEl32v9aXMH0/3AoN5pFurcoqEXUm2dJKha6VtwwfNibTPyh+FlC/kE5gYAYleUr6
	 ygwuDIUkD21pQ==
Date: Wed, 3 Jan 2024 23:27:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 8/9] xfs: support in-memory btrees
Message-ID: <20240104072752.GC361584@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829708.1748854.10994305200199735396.stgit@frogsfrogsfrogs>
 <ZZZUkq145pW64Zzo@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZZUkq145pW64Zzo@infradead.org>

On Wed, Jan 03, 2024 at 10:47:46PM -0800, Christoph Hellwig wrote:
> > -	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
> > +	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
> > +	    !(cur->bc_flags & XFS_BTREE_IN_XFILE) && cur->bc_ag.pag)
> >  		xfs_perag_put(cur->bc_ag.pag);
> > +	if (cur->bc_flags & XFS_BTREE_IN_XFILE) {
> > +		if (cur->bc_mem.pag)
> > +			xfs_perag_put(cur->bc_mem.pag);
> > +	}
> 
> Btw, one thing I noticed is that we have a lot of confusion on what
> part of the bc_ino/ag/mem union is used for a given btree.  For
> On-disk inodes we abuse the long ptrs flag, and then we through in
> the xfile flags.  If you're fine with it I can try to sort it out.
> It's not really a blocker, but I think it would be a lot claner if
> we used the chance to sort it out.  This will become even more
> important with the rt rmap/reflink trees that will further increase
> the confusion here.

Go for it! :)

> > +	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
> > +		return xfbtree_bbsize();
> > +	return cur->bc_mp->m_bsize;
> > +}
> 
> One thing I've been wondering is if we should split
> a strut xfs_btree outof struct xfbtree that contains most of the
> fields from it minuts the space allocation (and the new fake header
> from my patches) and also use that for the on-disk btrees.
> 
> That means xfs_btree.c can use the target from it, and the owner
> and we can remove the indirect calls for calculcating maxrecs/minrecs,
> and then also add a field for the block size like this one and remove
> a lof of the XFS_BTREE_IN_XFILE checks.

Sounds like a good idea.

> > +	if (cur->bc_flags & XFS_BTREE_IN_XFILE)
> > +		return 0;
> > +
> >  	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLFSBLOCK) {
> >  		xfs_btree_reada_bufl(cur->bc_mp, left, 1,
> 
> Should the xfile check go into  xfs_buf_readahead instead?  That would
> execute a little more useles code for in-memory btrees, but keep this
> check in one place (where we could also write a nice comment explaining
> it :))

Sure, why not?  It's too bad that readahead to an xfile can't
asynchronously call xfile_get_page; maybe we wouldn't need so much
caching.

> > +	xfs_btree_buf_to_ptr(cur, bp, &bufptr);
> >  	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
> > -		if (be64_to_cpu(rptr.l) == XFS_DADDR_TO_FSB(cur->bc_mp,
> > -							xfs_buf_daddr(bp))) {
> > +		if (rptr.l == bufptr.l) {
> >  			xfs_btree_mark_sick(cur);
> >  			return -EFSCORRUPTED;
> >  		}
> >  	} else {
> > -		if (be32_to_cpu(rptr.s) == xfs_daddr_to_agbno(cur->bc_mp,
> > -							xfs_buf_daddr(bp))) {
> > +		if (rptr.s == bufptr.s) {
> 
> This almost screams for a xfs_btree_ptr_cmp helper, even if this
> seems to be the only user so far..

<nod>

> > +static inline loff_t xfile_size(struct xfile *xf)
> > +{
> > +	return i_size_read(file_inode(xf->file));
> > +}
> 
> Despite looking over the whole patch for a while I only noticed
> this one, and I think I could add it in my xfile diet series
> instea dof open coding it in trace.h.
> 
> In general it would be really nice to split out patches that add
> infrastructure in other parts of the XFS codebase to make them stick
> out a bit more.

<nod>

> > +/* file block (aka system page size) to basic block conversions. */
> > +typedef unsigned long long	xfileoff_t;
> > +#define XFB_BLOCKSIZE		(PAGE_SIZE)
> > +#define XFB_BSHIFT		(PAGE_SHIFT)
> > +#define XFB_SHIFT		(XFB_BSHIFT - BBSHIFT)
> > +
> > +static inline loff_t xfo_to_b(xfileoff_t xfoff)
> > +{
> > +	return xfoff << XFB_BSHIFT;
> > +}
> 
> ...
> 
> xfile.h feels like the wrong place for this - the encoding only really
> makes sense fo the xfbtree.  And in a way it feels redundant over
> just using pgoff_t and the PAGE_* constants directly which should be
> pretty obvious to everyone knowning the Linux MM and page cache APIs.

Especially if it ends up in the xfs_btree stub object that you were
talking about above.  Just be careful not to make the userspace xfile.c
and xfbtree.c too weird -- some of the quirky apis here are a result of
me trying to keep things similar between kernel and xfsprogs.

(and the userspace xfile is weird because we're constrained by the size
of the fd table and hence have to partition memfds)

> > +/* Return the number of sectors for a buffer target. */
> > +xfs_daddr_t
> > +xfs_buftarg_nr_sectors(
> > +	struct xfs_buftarg	*btp)
> > +{
> > +	if (btp->bt_flags & XFS_BUFTARG_XFILE)
> > +		return xfile_buftarg_nr_sectors(btp);
> 
> If we didn't add an ifdef around the struct xfile definition, this could
> just be open coded and rely on the compiler eliminating dead code when
> XFS_BUFTARG_XFILE isn't defined.

Ok.

--D
