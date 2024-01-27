Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B4C8F40
	for <linux-xfs@vger.kernel.org>; Sat, 27 Jan 2024 01:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706319156; cv=none; b=Oain5euK0UYX6XwQpQ9El0Bv64xdjNoed1XywYDMIX3dM66n5t/J7r3iC21S4r+iVU5DkaDEY6hzDPtCtHOwQ/U4nkNw8tlmxlqvlCmCqO7cE7nzJhAZrixeK9oT4MKO/seE8nza6phHTdGNxzw/HBvHI5QBWntyXg7zv57uA4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706319156; c=relaxed/simple;
	bh=bLMAmfjl6R4KcLjz0Q1/rbi6OGKoPzz1cqeqrZ/iYQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQZf/TIlx7FQs7lwG6IO6CK42OoYdJr9Gc0V7OZ6WLiEyhD3iitzbEZsGJr4F4fJyWXh77f87YilictTA6vOrRCXLdGenKulmq5oqhqEQUCxvpNISo0P2Rx2MDq6O17EvzBzW7nV0Hhxzo1ptfKbDP3kT/Mw8zeWcohS9QTU8Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DDr9TpDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DDr9TpDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A971C433C7;
	Sat, 27 Jan 2024 01:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706319156;
	bh=bLMAmfjl6R4KcLjz0Q1/rbi6OGKoPzz1cqeqrZ/iYQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DDr9TpDb1P1O2NTy/qokcJjUBcUPs0EmOqm2roTZC866Km8S0meOOyCL8iSFaYjBC
	 N7K8izkqrbFClzBa0Dg8xJDiqb3jXeyDRdP2e0IHgv1rmH6So39WsTXb/TFMO6/9o6
	 zKhYlZa7LsylRZQ++PuTmUCXe2jXwUCjxbxe80txUOVzw3JfVWHyIM+ZAK8iLX6myx
	 jnCFVxugg8VbN7Oqmku2TZdy4jFQorFPOTGRQj6Vu1QHrvfnkEdbAJrCSD9ZoMqZEd
	 G3TxG7T9xYWSEPjOXRiCZYZCmqbFT61/mu0QtucEu9hq19KPgFjEgTOQbGSLqcHWrZ
	 uOpnOhEOSAd0A==
Date: Fri, 26 Jan 2024 17:32:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 17/21] xfs: add file_{get,put}_folio
Message-ID: <20240127013235.GE1371843@frogsfrogsfrogs>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-18-hch@lst.de>
 <zfgublewgj5g6ipf2twkdl4kyvgttrvmigegxthgvc6ghdauwo@fej77ff4mtjs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zfgublewgj5g6ipf2twkdl4kyvgttrvmigegxthgvc6ghdauwo@fej77ff4mtjs>

On Fri, Jan 26, 2024 at 08:26:22PM -0500, Kent Overstreet wrote:
> On Fri, Jan 26, 2024 at 02:28:59PM +0100, Christoph Hellwig wrote:
> > From: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > Add helper similar to file_{get,set}_page, but which deal with folios
> > and don't allocate new folio unless explicitly asked to, which map
> > to shmem_get_folio instead of calling into the aops.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> looks boilerplatey to my eyes, but this is all new conceptual stuff and
> the implementation will be evolving, so...
> 
> one nit: that's really not the right place for memalloc_nofs_save(), can
> we try to start figuring out the proper locations for those?

I /think/ this is actually unnecessary since the xfs scrub code will
have already allocated a (possibly empty) transaction, which will have
set PF_MEMALLOC_NOFS.  But.  I'd rather concentrate on merging the code
and fixing the correctness bugs; and later we can find and remove the
unnecessary bits.

(Yeah shameful copy pasta from shmem.c.)

--D

> Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>
> 
> > ---
> >  fs/xfs/scrub/trace.h |  2 ++
> >  fs/xfs/scrub/xfile.c | 74 ++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/xfile.h |  7 +++++
> >  3 files changed, 83 insertions(+)
> > 
> > diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> > index 0327cab606b070..c61fa7a95ef522 100644
> > --- a/fs/xfs/scrub/trace.h
> > +++ b/fs/xfs/scrub/trace.h
> > @@ -908,6 +908,8 @@ DEFINE_XFILE_EVENT(xfile_store);
> >  DEFINE_XFILE_EVENT(xfile_seek_data);
> >  DEFINE_XFILE_EVENT(xfile_get_page);
> >  DEFINE_XFILE_EVENT(xfile_put_page);
> > +DEFINE_XFILE_EVENT(xfile_get_folio);
> > +DEFINE_XFILE_EVENT(xfile_put_folio);
> >  
> >  TRACE_EVENT(xfarray_create,
> >  	TP_PROTO(struct xfarray *xfa, unsigned long long required_capacity),
> > diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
> > index 2d802c20a8ddfe..1c1db4ae1ba6ee 100644
> > --- a/fs/xfs/scrub/xfile.c
> > +++ b/fs/xfs/scrub/xfile.c
> > @@ -365,3 +365,77 @@ xfile_put_page(
> >  		return -EIO;
> >  	return 0;
> >  }
> > +
> > +/*
> > + * Grab the (locked) folio for a memory object.  The object cannot span a folio
> > + * boundary.  Returns the locked folio if successful, NULL if there was no
> > + * folio or it didn't cover the range requested, or an ERR_PTR on failure.
> > + */
> > +struct folio *
> > +xfile_get_folio(
> > +	struct xfile		*xf,
> > +	loff_t			pos,
> > +	size_t			len,
> > +	unsigned int		flags)
> > +{
> > +	struct inode		*inode = file_inode(xf->file);
> > +	struct folio		*folio = NULL;
> > +	unsigned int		pflags;
> > +	int			error;
> > +
> > +	if (inode->i_sb->s_maxbytes - pos < len)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	trace_xfile_get_folio(xf, pos, len);
> > +
> > +	/*
> > +	 * Increase the file size first so that shmem_get_folio(..., SGP_CACHE),
> > +	 * actually allocates a folio instead of erroring out.
> > +	 */
> > +	if ((flags & XFILE_ALLOC) && pos + len > i_size_read(inode))
> > +		i_size_write(inode, pos + len);
> > +
> > +	pflags = memalloc_nofs_save();
> > +	error = shmem_get_folio(inode, pos >> PAGE_SHIFT, &folio,
> > +			(flags & XFILE_ALLOC) ? SGP_CACHE : SGP_READ);
> > +	memalloc_nofs_restore(pflags);
> > +	if (error)
> > +		return ERR_PTR(error);
> > +
> > +	if (!folio)
> > +		return NULL;
> > +
> > +	if (len > folio_size(folio) - offset_in_folio(folio, pos)) {
> > +		folio_unlock(folio);
> > +		folio_put(folio);
> > +		return NULL;
> > +	}
> > +
> > +	if (xfile_has_lost_data(inode, folio)) {
> > +		folio_unlock(folio);
> > +		folio_put(folio);
> > +		return ERR_PTR(-EIO);
> > +	}
> > +
> > +	/*
> > +	 * Mark the folio dirty so that it won't be reclaimed once we drop the
> > +	 * (potentially last) reference in xfile_put_folio.
> > +	 */
> > +	if (flags & XFILE_ALLOC)
> > +		folio_set_dirty(folio);
> > +	return folio;
> > +}
> > +
> > +/*
> > + * Release the (locked) folio for a memory object.
> > + */
> > +void
> > +xfile_put_folio(
> > +	struct xfile		*xf,
> > +	struct folio		*folio)
> > +{
> > +	trace_xfile_put_folio(xf, folio_pos(folio), folio_size(folio));
> > +
> > +	folio_unlock(folio);
> > +	folio_put(folio);
> > +}
> > diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
> > index 465b10f492b66d..afb75e9fbaf265 100644
> > --- a/fs/xfs/scrub/xfile.h
> > +++ b/fs/xfs/scrub/xfile.h
> > @@ -39,4 +39,11 @@ int xfile_get_page(struct xfile *xf, loff_t offset, unsigned int len,
> >  		struct xfile_page *xbuf);
> >  int xfile_put_page(struct xfile *xf, struct xfile_page *xbuf);
> >  
> > +#define XFILE_MAX_FOLIO_SIZE	(PAGE_SIZE << MAX_PAGECACHE_ORDER)
> > +
> > +#define XFILE_ALLOC		(1 << 0) /* allocate folio if not present */
> > +struct folio *xfile_get_folio(struct xfile *xf, loff_t offset, size_t len,
> > +		unsigned int flags);
> > +void xfile_put_folio(struct xfile *xf, struct folio *folio);
> > +
> >  #endif /* __XFS_SCRUB_XFILE_H__ */
> > -- 
> > 2.39.2
> > 
> 
