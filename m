Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37854 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfGEQti (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jul 2019 12:49:38 -0400
Date: Fri, 5 Jul 2019 09:49:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] xfs: only allocate memory for scrubbing attributes
 when we need it
Message-ID: <20190705164924.GG1404256@magnolia>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
 <156158202408.495944.3341471232105593997.stgit@magnolia>
 <20190705145233.GG37448@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705145233.GG37448@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 05, 2019 at 10:52:33AM -0400, Brian Foster wrote:
> On Wed, Jun 26, 2019 at 01:47:04PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In examining a flame graph of time spent running xfs_scrub on various
> > filesystems, I noticed that we spent nearly 7% of the total runtime on
> > allocating a zeroed 65k buffer for every SCRUB_TYPE_XATTR invocation.
> > We do this even if none of the attribute values were anywhere near 64k
> > in size, even if there were no attribute blocks to check space on, and
> > even if it just turns out there are no attributes at all.
> > 
> > Therefore, rearrange the xattr buffer setup code to support reallocating
> > with a bigger buffer and redistribute the callers of that function so
> > that we only allocate memory just prior to needing it, and only allocate
> > as much as we need.  If we can't get memory with the ILOCK held we'll
> > bail out with EDEADLOCK which will allocate the maximum memory.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/attr.c |   67 ++++++++++++++++++++++++++++++++++++++++++++-------
> >  fs/xfs/scrub/attr.h |    6 ++++-
> >  2 files changed, 63 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> > index c20b6da1db84..09081d8ab34b 100644
> > --- a/fs/xfs/scrub/attr.c
> > +++ b/fs/xfs/scrub/attr.c
> ...
> > @@ -47,10 +53,23 @@ xchk_setup_xattr_buf(
> >  	sz = 3 * sizeof(long) * BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
> >  	sz = max_t(size_t, sz, value_size);
> >  
> > -	sc->buf = kmem_zalloc_large(sz, KM_SLEEP);
> > -	if (!sc->buf)
> > +	/*
> > +	 * If there's already a buffer, figure out if we need to reallocate it
> > +	 * to accomdate a larger size.
> 
> accommodate

Fixed.  Thanks for catching that.

--D

> Otherwise looks good:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +	 */
> > +	if (ab) {
> > +		if (sz <= ab->sz)
> > +			return 0;
> > +		kmem_free(ab);
> > +		sc->buf = NULL;
> > +	}
> > +
> > +	ab = kmem_zalloc_large(sizeof(*ab) + sz, flags);
> > +	if (!ab)
> >  		return -ENOMEM;
> >  
> > +	ab->sz = sz;
> > +	sc->buf = ab;
> >  	return 0;
> >  }
> >  
> > @@ -62,9 +81,16 @@ xchk_setup_xattr(
> >  {
> >  	int			error;
> >  
> > -	error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX);
> > -	if (error)
> > -		return error;
> > +	/*
> > +	 * We failed to get memory while checking attrs, so this time try to
> > +	 * get all the memory we're ever going to need.  Allocate the buffer
> > +	 * without the inode lock held, which means we can sleep.
> > +	 */
> > +	if (sc->flags & XCHK_TRY_HARDER) {
> > +		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX, KM_SLEEP);
> > +		if (error)
> > +			return error;
> > +	}
> >  
> >  	return xchk_setup_inode_contents(sc, ip, 0);
> >  }
> > @@ -115,6 +141,19 @@ xchk_xattr_listent(
> >  		return;
> >  	}
> >  
> > +	/*
> > +	 * Try to allocate enough memory to extrat the attr value.  If that
> > +	 * doesn't work, we overload the seen_enough variable to convey
> > +	 * the error message back to the main scrub function.
> > +	 */
> > +	error = xchk_setup_xattr_buf(sx->sc, valuelen, KM_MAYFAIL);
> > +	if (error == -ENOMEM)
> > +		error = -EDEADLOCK;
> > +	if (error) {
> > +		context->seen_enough = error;
> > +		return;
> > +	}
> > +
> >  	args.flags = ATTR_KERNOTIME;
> >  	if (flags & XFS_ATTR_ROOT)
> >  		args.flags |= ATTR_ROOT;
> > @@ -128,7 +167,7 @@ xchk_xattr_listent(
> >  	args.hashval = xfs_da_hashname(args.name, args.namelen);
> >  	args.trans = context->tp;
> >  	args.value = xchk_xattr_valuebuf(sx->sc);
> > -	args.valuelen = XATTR_SIZE_MAX;
> > +	args.valuelen = valuelen;
> >  
> >  	error = xfs_attr_get_ilocked(context->dp, &args);
> >  	if (error == -EEXIST)
> > @@ -281,16 +320,26 @@ xchk_xattr_block(
> >  	struct xfs_attr_leafblock	*leaf = bp->b_addr;
> >  	struct xfs_attr_leaf_entry	*ent;
> >  	struct xfs_attr_leaf_entry	*entries;
> > -	unsigned long			*usedmap = xchk_xattr_usedmap(ds->sc);
> > +	unsigned long			*usedmap;
> >  	char				*buf_end;
> >  	size_t				off;
> >  	__u32				last_hashval = 0;
> >  	unsigned int			usedbytes = 0;
> >  	unsigned int			hdrsize;
> >  	int				i;
> > +	int				error;
> >  
> >  	if (*last_checked == blk->blkno)
> >  		return 0;
> > +
> > +	/* Allocate memory for block usage checking. */
> > +	error = xchk_setup_xattr_buf(ds->sc, 0, KM_MAYFAIL);
> > +	if (error == -ENOMEM)
> > +		return -EDEADLOCK;
> > +	if (error)
> > +		return error;
> > +	usedmap = xchk_xattr_usedmap(ds->sc);
> > +
> >  	*last_checked = blk->blkno;
> >  	bitmap_zero(usedmap, mp->m_attr_geo->blksize);
> >  
> > diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
> > index 27e879aeaafc..13a1d2e8424d 100644
> > --- a/fs/xfs/scrub/attr.h
> > +++ b/fs/xfs/scrub/attr.h
> > @@ -10,6 +10,9 @@
> >   * Temporary storage for online scrub and repair of extended attributes.
> >   */
> >  struct xchk_xattr_buf {
> > +	/* Size of @buf, in bytes. */
> > +	size_t			sz;
> > +
> >  	/*
> >  	 * Memory buffer -- either used for extracting attr values while
> >  	 * walking the attributes; or for computing attr block bitmaps when
> > @@ -62,6 +65,7 @@ xchk_xattr_dstmap(
> >  			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
> >  }
> >  
> > -int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size);
> > +int xchk_setup_xattr_buf(struct xfs_scrub *sc, size_t value_size,
> > +		xfs_km_flags_t flags);
> >  
> >  #endif	/* __XFS_SCRUB_ATTR_H__ */
> > 
