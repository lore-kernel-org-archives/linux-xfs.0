Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9187634E5
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 01:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712798103; cv=none; b=hU//5M/8jJfWUSDe4uH2FgjfwVuKCUiv4rMJoAhM3/GZXFkyYlhetiehdukDhilnCmV9mAgC1AC1/OGP8x3oV0tf03tP5b1p4H/fVdKyUw3M4nM1SQ65r1rO1uJ1cNYBufzRJersmqTgYXliTBe7rk47dQ+4DywHpdPlJseXgc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712798103; c=relaxed/simple;
	bh=OGT1R9lhCrcY5A4p1cuwsAVtFZoP1uTMbvRMvjh7d80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lov9JHw8Gnk4/3WlcmF3LdlCp8ApLL/tX1wFpizf0rE1mrkUoS/vVT7kEo6sadP59wToLDkCkch4PZPXi8Md7RKP9y6qD52nBHn/cQGV4EuY5LUvINuKhnukWwQFToC6xEKWgAEY0TP4PW0O3FEMd4k00qwkKk4pjHsNtOT3Y5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xumzdjq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xumzdjq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586CEC433C7;
	Thu, 11 Apr 2024 01:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712798103;
	bh=OGT1R9lhCrcY5A4p1cuwsAVtFZoP1uTMbvRMvjh7d80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xumzdjq4tEioYyQNMgvwvTBQQWtGbbEkeC40r1wJMsmYcaVWSzsmVibqcLwNbsdwO
	 36TY+i0EM18xyUZFdj45gIs91QXWPcKp86trsqBHUBOjBi+FXF5kvISL8Oe8sWSrhN
	 ysS0yOtvZ49fKCixOTzpqjaNFwj1cgHPB8X1g3kS9vgne9WALQXSupMwBf1s0eoPPu
	 7rrV+TMg9lzwNF+Gn3zCRwGQMhvQQ7EjYWwG+WJXFkRahSNIPf83y9m1GClyHjuGgj
	 /f21FrlNcMH9vFUHNP3BHEV+Ir7d7AQflY5xf5fzZMfVmt2tDqS1erP1dFj4JCtVF6
	 BtCiykOMc4/KQ==
Date: Wed, 10 Apr 2024 18:15:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <20240411011502.GR6390@frogsfrogsfrogs>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972068.3634974.15204601732623547015.stgit@frogsfrogsfrogs>
 <ZhasUAuV6Ea_nvHh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhasUAuV6Ea_nvHh@infradead.org>

On Wed, Apr 10, 2024 at 08:12:16AM -0700, Christoph Hellwig wrote:
> > +	/*
> > +	 * If the caller wants us to do a scrub-by-handle and the file used to
> > +	 * call the ioctl is not the same file, load the incore inode and pin
> > +	 * it across all the scrubv actions to avoid repeated UNTRUSTED
> > +	 * lookups.  The reference is not passed to deeper layers of scrub
> > +	 * because each scrubber gets to decide its own strategy for getting an
> > +	 * inode.
> > +	 */
> > +	if (vhead->svh_ino && vhead->svh_ino != ip_in->i_ino)
> > +		handle_ip = xchk_scrubv_open_by_handle(mp, vhead);
> 
> Oh.  So we read the inode, keep a reference to it, but still hit the
> inode cache every time.  A little non-onvious and not perfect for
> performance, but based on your numbers probably good enough.
> 
> Curious: what is the reason the scrubbers want/need different ways to
> get at the inode?

I don't remember the exact reason why we don't pass this ip into
xfs_scrub_metadata, but iirc the inode scrub setup functions react
differently (from the bmap/dir/attr/symlink scrubbers) when iget
failures occur.

Also this way xfs_scrub_metadata owns the refcount to whatever inode it
picks up, and can do whatever it wants with that reference.

> > +	/*
> > +	 * If we're holding the only reference to an inode opened via handle
> > +	 * and the scan was clean, mark it dontcache so that we don't pollute
> > +	 * the cache.
> > +	 */
> > +	if (handle_ip) {
> > +		if (set_dontcache &&
> > +		    atomic_read(&VFS_I(handle_ip)->i_count) == 1)
> > +			d_mark_dontcache(VFS_I(handle_ip));
> > +		xfs_irele(handle_ip);
> > +	}
> 
> This looks a little weird to me.  Can't we simply use XFS_IGET_DONTCACHE
> at iget time and then clear I_DONTCACHE here if we want to keep the
> inode around?

Not anymore, because other threads can mess around with the dontcache
state (yay fsdax access path changes!!) while we are scrubbing the
inode.

>                Given that we only set the uncached flag from
> XFS_IGET_DONTCACHE on a cache miss, we won't have set
> DCACHE_DONTCACHE anywhere (and don't really care about the dentries to
> start with).
> 
> But why do we care about keeping the inodes with errors in memory
> here, but not elsewhere?

We actually, do, but it's not obvious...

> Maybe this can be explained in an expanded comment.

...because this bit here is basically the same as xchk_irele, but we
don't have a xfs_scrub object to pass in, so it's opencoded.  I could
pull this logic out into:

void xfs_scrub_irele(struct xfs_inode *ip)
{
	if (atomic_read(&VFS_I(ip)->i_count) == 1) {
		/*
		 * If this is the last reference to the inode and the caller
		 * permits it, set DONTCACHE to avoid thrashing.
		 */
		d_mark_dontcache(VFS_I(ip));
	}
	xfs_irele(ip);
}

and change xchk_irele to:

void
xchk_irele(
	struct xfs_scrub	*sc,
	struct xfs_inode	*ip)
{
	if (sc->tp) {
		spin_lock(&VFS_I(ip)->i_lock);
		VFS_I(ip)->i_state &= ~I_DONTCACHE;
		spin_unlock(&VFS_I(ip)->i_lock);
		xfs_irele(ip);
		return;
	}

	xfs_scrub_irele(ip);
}
