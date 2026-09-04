Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B573D891E;
	Fri,  4 Sep 2026 16:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538006; cv=none; b=guoa+55/Suqt0BGLQlJHA8fVq5JijMevWO9UWLdrJaGXimoBluRRNhg/S/nj+zpveRSVSY1EQf5fQUkO5r2Tn9NMIKGWcLJjIBmQqeIMuQUZ3uudbNddQtCwfK0zWGvjKGueLdjw7aGX/c0SVvKKE58gLVSnP1pGC0cNlLOst54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538006; c=relaxed/simple;
	bh=xeQiDBPvVXf3mhzDJuaGWk/QtgZ3jOrmHhgWPeOL0fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=foRyaRTifEFjAnfoe601QO64aLxUJdGE0KAbdr8LKYWnpmcg9wKXFVgiY+GoLNgQxUlsFURl4VbmWiMUhBvUJxQKsYAKu5utA5SjHwDsBLKcZZSI7bKr6vrgT/3LFg9UjyYVyDhvjL8OBPJX/k3jBdTRrh4b41KipRxAXhpdzAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dRPBiL1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dRPBiL1A"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4CCD51F00A3E;
	Fri,  4 Sep 2026 16:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788538001;
	bh=ja9SnIsCHUkvSSnRXW4N3nERb2UOdb8zsr0Mp+uth98=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dRPBiL1AdUqoGi/4NbKu6IP4bkjX9VQL3dblGC4i4B9rhVO3JEjLbyIhQKCbpPLZ3
	 eIIRrDGCcsDJpt+k2cBoSd8pZcC6mkP0h3z3wU+3rHuiqTvwQRH6s10/5zKwMubKfE
	 bHLz8kpi6M9tqeGsxYXDZcDS7x9Pxuik8QEXbwtoCpXgph/Ps3lBe3w6g+VCBRkxfT
	 Fk90V9J5qMnPQdz1DzJOwN/1if6rl6CRBl5CYrR5u1QgmhqU+yEISLZqFOwwCKWqWg
	 Vx7Cg/Xs9UMaGfbROxYibLuQTfCS0axG8U0rRjQEoDvke/Fv0uKKToG3Vi2vnhbxUp
	 +mXg8fSBqM9ng==
Date: Fri, 4 Sep 2026 09:06:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hemanth Selam <hemanth.selam@gmail.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix repeated words in comments
Message-ID: <20260904160640.GA1933798@frogsfrogsfrogs>
References: <20260904112909.8197-1-hemanth.selam@gmail.com>
 <20260904112909.8197-3-hemanth.selam@gmail.com>
 <aprEgoAcpxbOblRi@andromeda.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aprEgoAcpxbOblRi@andromeda.toxiclabs.cc>

On Fri, Sep 04, 2026 at 03:16:29PM +0200, Carlos Maiolino wrote:
> On Fri, Sep 04, 2026 at 04:59:04PM +0530, Hemanth Selam wrote:
> > Drop words accidentally written twice, reported by checkpatch.pl as a
> > possible repeated word.  Only touches comments, no code changes.
> > 
> > Assisted-by: Cursor:claude-opus-5
> > Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> 
> There are no need for these two be in separated patches, and please get
> rid of the model there. We are not allowing models to be specified in
> the patch descriptions anymore.

I agree, all these minor edits could be a single largish patch.

--D

> > ---
> >  fs/xfs/libxfs/xfs_exchmaps.c   | 2 +-
> >  fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
> >  fs/xfs/scrub/agheader_repair.c | 2 +-
> >  fs/xfs/scrub/alloc_repair.c    | 2 +-
> >  fs/xfs/scrub/reap.c            | 2 +-
> >  fs/xfs/xfs_bmap_item.c         | 2 +-
> >  fs/xfs/xfs_zone_alloc.c        | 2 +-
> >  fs/xfs/xfs_zone_gc.c           | 2 +-
> >  8 files changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> > index 3efed37cb98a..6a66b6075e0a 100644
> > --- a/fs/xfs/libxfs/xfs_exchmaps.c
> > +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> > @@ -395,7 +395,7 @@ xfs_exchmaps_one_step(
> >  	/*
> >  	 * Re-add both mappings.  We exchange the file offsets between the two
> >  	 * maps and add the opposite map, which has the effect of filling the
> > -	 * logical offsets we just unmapped, but with with the physical mapping
> > +	 * logical offsets we just unmapped, but with the physical mapping
> >  	 * information exchanged.
> >  	 */
> >  	swap(irec1->br_startoff, irec2->br_startoff);
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index e4c3f7b24e95..0340e2189921 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -626,7 +626,7 @@ xfs_dinode_verify(
> >  	 * have di_nlink track the link count, even if the actual filesystem
> >  	 * only supported V1 inodes (i.e. di_onlink).  When writing out the
> >  	 * ondisk inode, it would set both the ondisk di_nlink and di_onlink to
> > -	 * the the incore di_nlink value, which is why we cannot check for
> > +	 * the incore di_nlink value, which is why we cannot check for
> >  	 * di_nlink==0 on a V1 inode.  V2/3 inodes would get written out with
> >  	 * di_onlink==0, so we can check that.
> >  	 */
> > diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> > index 2104512f1ee1..493efa2b2f0d 100644
> > --- a/fs/xfs/scrub/agheader_repair.c
> > +++ b/fs/xfs/scrub/agheader_repair.c
> > @@ -1352,7 +1352,7 @@ xrep_iunlink_mark_ondisk(
> >  
> >  /*
> >   * Walk an iunlink bucket's inode list.  For each inode that should be on this
> > - * chain, clear its entry in in iunlink_bmp because it's ok and we don't need
> > + * chain, clear its entry in iunlink_bmp because it's ok and we don't need
> >   * to touch it further.
> >   */
> >  STATIC int
> > diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
> > index dce6ab0429dc..84ae88ca027a 100644
> > --- a/fs/xfs/scrub/alloc_repair.c
> > +++ b/fs/xfs/scrub/alloc_repair.c
> > @@ -338,7 +338,7 @@ xrep_cntbt_extent_cmp(
> >  }
> >  
> >  /*
> > - * Sort the free extents by length so so that we can put the records into the
> > + * Sort the free extents by length so that we can put the records into the
> >   * cntbt in the correct order.  Don't let userspace kill us if we're resorting
> >   * after allocating btree blocks.
> >   */
> > diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> > index fcd14c1703ea..d1f4b7159af2 100644
> > --- a/fs/xfs/scrub/reap.c
> > +++ b/fs/xfs/scrub/reap.c
> > @@ -172,7 +172,7 @@ static inline bool xreap_is_dirty(const struct xreap_state *rs)
> >  }
> >  
> >  /*
> > - * Decide if we need to roll the transaction to clear out the the log
> > + * Decide if we need to roll the transaction to clear out the log
> >   * reservation that we allocated to buffer invalidations.
> >   */
> >  static inline bool xreap_want_binval_roll(const struct xreap_state *rs)
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 89f6e79a955f..aa5b41629747 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -339,7 +339,7 @@ xfs_bmap_update_get_group(
> >  
> >  	/*
> >  	 * Bump the intent count on behalf of the deferred rmap and refcount
> > -	 * intent items that that we can queue when we finish this bmap work.
> > +	 * intent items that we can queue when we finish this bmap work.
> >  	 * This new intent item will bump the intent count before the bmap
> >  	 * intent drops the intent count, ensuring that the intent count
> >  	 * remains nonzero across the transaction roll.
> > diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> > index bdbb60cc5d5b..f678015457c9 100644
> > --- a/fs/xfs/xfs_zone_alloc.c
> > +++ b/fs/xfs/xfs_zone_alloc.c
> > @@ -826,7 +826,7 @@ xfs_get_cached_zone(
> >  }
> >  
> >  /*
> > - * Stash our zone in the inode so that is is reused for future allocations.
> > + * Stash our zone in the inode so that is reused for future allocations.
> >   *
> >   * The open_zone structure will be pinned until either the inode is freed or
> >   * until the cached open zone is replaced with a different one because the
> > diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> > index 5fdcf98a2133..54b70ed2922f 100644
> > --- a/fs/xfs/xfs_zone_gc.c
> > +++ b/fs/xfs/xfs_zone_gc.c
> > @@ -46,7 +46,7 @@
> >   * before remapping.
> >   *
> >   * Once a zone does not contain any valid data, be that through GC or user
> > - * block removal, it is queued for for a zone reset.  The reset operation
> > + * block removal, it is queued for a zone reset.  The reset operation
> >   * carefully ensures that the RT device cache is flushed and all transactions
> >   * referencing the rmap have been committed to disk.
> >   */
> > -- 
> > 2.48.1
> > 
> > 
> 
