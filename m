Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4163118A937
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 23:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724974508; cv=none; b=oM5EwgOpmvBDB8Tk4rQ2iYQOQRwQTZ2TodpDp3hLj0O3mwHgbFp01qZRXUTh98++1xAO4d2djNXEGlk8bdyAtGjz8zAQmTebRukvlG45cr0owxGD8dKDmHnCOjk3ypFQ+1pOvzv0bo9cfhV7pRes1wxXGR7ZVKTUtNmqaVdby0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724974508; c=relaxed/simple;
	bh=GLomZo8w2g8W18mxKNwe/b1Z06KVkTmeKSHQlthZrgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dUYjVqoYrwoj29zN+cBUHlfw3rCYarP0nUymwdmxFbz8Y6Q/aYGHEk3J6DvVo2MgY3OkuSQ+Dj2WifKH+n0awR6yAoVWyiGmIvSBnul5hVJpWXWWdOPKTJ7GsIc3QEfWFAJpqVhhIWMU4BGmv9rg1fvGrGDjK2R+9h+z+SYyOpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Odn0nrPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Odn0nrPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6506C4CEC1;
	Thu, 29 Aug 2024 23:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724974507;
	bh=GLomZo8w2g8W18mxKNwe/b1Z06KVkTmeKSHQlthZrgE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Odn0nrPGH9oFYoHb7CkqnZQpY+Hqf/vl+UqHI9qf5er7yqOWaF4698mTu2C3SGGc/
	 edHYM0av8Jik9KODI7WlPPeEtoVw7aytUg5mU3oJlAz3+Owg6EYY1MHwsxq0n1zP1w
	 pPlWTfd3kQNFQ8jROqB86gTqHqC7VukXvwhAM6gVhZvHmcGg+MPL1tyrysY93m5wAo
	 rpQspwdLQ4ZF1O2odov8Fwm/ERUUCHaMg5z/PTl0DU9CbTd1MbsJNd12AyGUMNS4Pq
	 /gjvPRPXC5bi4jcoLW5Mu9Fq5Lq+tiT8H7AdlcYoP2lQ1dOHbAW73iSrHYssK5PMdG
	 G75BjxGqCu4fQ==
Date: Thu, 29 Aug 2024 16:35:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 08/10] xfs: hoist the code that moves the incore inode
 fork broot memory
Message-ID: <20240829233507.GU6224@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <172480131644.2291268.12671154009132010264.stgit@frogsfrogsfrogs>
 <Zs/i6JZerKLqTLnt@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs/i6JZerKLqTLnt@dread.disaster.area>

On Thu, Aug 29, 2024 at 12:54:32PM +1000, Dave Chinner wrote:
> On Tue, Aug 27, 2024 at 04:35:48PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Whenever we change the size of the memory buffer holding an inode fork
> > btree root block, we have to copy the contents over.  Refactor all this
> > into a single function that handles both, in preparation for making
> > xfs_iroot_realloc more generic.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_inode_fork.c |   87 ++++++++++++++++++++++++++--------------
> >  1 file changed, 56 insertions(+), 31 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 60646a6c32ec7..307207473abdb 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -387,6 +387,50 @@ xfs_iroot_free(
> >  	ifp->if_broot = NULL;
> >  }
> >  
> > +/* Move the bmap btree root from one incore buffer to another. */
> > +static void
> > +xfs_ifork_move_broot(
> > +	struct xfs_inode	*ip,
> > +	int			whichfork,
> > +	struct xfs_btree_block	*dst_broot,
> > +	size_t			dst_bytes,
> > +	struct xfs_btree_block	*src_broot,
> > +	size_t			src_bytes,
> > +	unsigned int		numrecs)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	void			*dptr;
> > +	void			*sptr;
> > +
> > +	ASSERT(xfs_bmap_bmdr_space(src_broot) <= xfs_inode_fork_size(ip, whichfork));
> 
> We pass whichfork just for this debug check. Can you pull this up
> to the callers?

I guess I could do that, but the rtrmap patchset adds its own broot
shrink/grow function specific to rtrmap btree inodes:

static void
xfs_rtrmapbt_broot_move(...)
{
	...
	ASSERT(xfs_rtrmap_droot_space(src_broot) <=
	       xfs_inode_fork_size(ip, whichfork));

so I didn't want to add yet another indirect call just for an assertion.

> > +
> > +	/*
> > +	 * We always have to move the pointers because they are not butted
> > +	 * against the btree block header.
> > +	 */
> > +	if (numrecs) {
> > +		sptr = xfs_bmap_broot_ptr_addr(mp, src_broot, 1, src_bytes);
> > +		dptr = xfs_bmap_broot_ptr_addr(mp, dst_broot, 1, dst_bytes);
> > +		memmove(dptr, sptr, numrecs * sizeof(xfs_fsblock_t));
> > +	}
> > +
> > +	if (src_broot == dst_broot)
> > +		return;
> 
> Urk. So this is encoding caller logic directly into this function.
> ie. the grow cases uses krealloc() which copies the keys and
> pointers but still needs the pointers moved. The buffer is large
> enough for that, so it passes src and dst as the same buffer and
> this code then jumps out after copying the ptrs (a second time) to
> their final resting place.

<nod>

> > +	/*
> > +	 * If the root is being totally relocated, we have to migrate the block
> > +	 * header and the keys that come after it.
> > +	 */
> > +	memcpy(dst_broot, src_broot, xfs_bmbt_block_len(mp));
> > +
> > +	/* Now copy the keys, which come right after the header. */
> > +	if (numrecs) {
> > +		sptr = xfs_bmbt_key_addr(mp, src_broot, 1);
> > +		dptr = xfs_bmbt_key_addr(mp, dst_broot, 1);
> > +		memcpy(dptr, sptr, numrecs * sizeof(struct xfs_bmbt_key));
> > +	}
> 
> And here we do the key copy for the shrink case where we technically
> don't need separate buffers but we really want to minimise memory
> usage if we can so we reallocate a smaller buffer and free the
> original larger one.
> 
> Given this, I think this code is more natural by doing all the
> allocate/free/copy ourselves instead of using krealloc() and it's
> implicit copy for one of the cases.
> 
> i.e. rename this function xfs_ifork_realloc_broot() and make it do
> this:
> 
> {
> 	struct xfs_btree_block *src = ifp->if_broot;
> 	struct xfs_btree_block *dst = NULL;
> 
> 	if (!numrecs)
> 		goto out_free_src;
> 
> 	dst = kmalloc(new_size);
> 
> 	/* copy block header */
> 	memcpy(dst, src, xfs_bmbt_block_len(mp));

I'm not sure I like replacing krealloc with kmalloc here.  For a grow
operation, if the new and old object sizes are close enough that we
reuse the existing slab object, then we only have to move the pointers.
In the best case, the object expands, so all the bytes we had before are
still live and we touch fewer cachelines.  In the worst case we get a
new object, but that's roughly exponential.

For a shrink operation, we definitely want the alloc -> copy -> free
logic because there's no way to guarantee that krealloc-down isn't a nop
operation, which wastes memory.

But I see that this function isn't very cohesive and could be split into
separate ->grow and ->shrink functions that do their own allocations.

Or seeing how the only callers of xfs_iroot_realloc are the btree code
itself, maybe I should just refactor this into a single ->broot_realloc
function in the btree ops which will cut out a lot of indirect calls
from the iroot code.

Yeah.  I'm gonna go do that.  Disregard patch 5 onwards.

> 	/* copy records */
> 	sptr = xfs_bmbt_key_addr(mp, src, 1);
> 	dptr = xfs_bmbt_key_addr(mp, dst, 1);
> 	memcpy(dptr, sptr, numrecs * sizeof(struct xfs_bmbt_key));
> 
> 	/* copy pointers */
> 	sptr = xfs_bmap_broot_ptr_addr(mp, src_broot, 1, src_bytes);
> 	dptr = xfs_bmap_broot_ptr_addr(mp, dst_broot, 1, dst_bytes);
> 	memmove(dptr, sptr, numrecs * sizeof(xfs_fsblock_t));
> 
> out_free_src:
> 	kfree(src);
> 	ifp->if_broot = dst;
> 	ifp->if_broot_bytes = new_size;
> }
> 
> And the callers are now both:
> 
> 	xfs_ifork_realloc_broot(mp, ifp, new_size, old_size, numrecs);
> 
> This also naturally handles the "reduce to zero size" without
> needing any special case code, it avoids the double pointer copy on
> grow, and the operation logic is simple, obvious and easy to
> understand...

Hmm.  The rtrmap patchset starts by moving xfs_ifork_move_broot to
xfs_bmap_btree.c and virtualizes the broot grow/shrink operation to
become a per-btree type operation.  The rtreflink series expands this
usage.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
