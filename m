Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C17336883;
	Mon, 12 Oct 2026 15:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791820376; cv=none; b=fD8AFpb40EPa97t+zcgBTZlHzoQ/8U7H/kV1/xl8zu3ahxOE+Gs/UYfmLmoEpey3U7Vl6O/Rtn2S/LknKuGRCcNPDQAXHpYlS6fV0AXZJvHscOY/4cHdzBEU7eT0Y6RMpEj3/r33/pOUoYczDYZkPpVxISxuN3NXlOXidrH/Lk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791820376; c=relaxed/simple;
	bh=yGZQMHIurMBdTBsG9bK6lKhru/bp0GbKU+QZjJv+eOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQtIEGz7rhX4oXDAGt13ce+SGciWOJhiqo9hk+d4eif4NHgWV/plIYZChhfJ0Mu0f2IKpYHml3ZYlIElE32gLgenpJbXsCJ5k/OXEE3+mW0nDrRaQkS3DenyJRAD+3mrj729rF2cxrY95knixsZa2eXudRfxjbvS4A2xbPN2fcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VBKap8my; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VBKap8my"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5BD0A1F0089B;
	Mon, 12 Oct 2026 15:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791820375;
	bh=r1YRHReaoh2NrqFcs0RmaycnTHahxss9fwmfRXIULng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VBKap8mytzXBu1UukTyjZHoE80lpMoHn7wOcpiWIWgOi2jnzPKFPZxokADnQwCs7Z
	 0ruY8xbv4Qo6B4w85nIB6uq/2W9PcW8Ewd/D/XBhoAGA32Nmsu2mAhL+yj/d3k8SU0
	 wpFD3rWtjoWEQGV8LsHCkXWgmvH5L8/UnR7r0rMvH8UiwagS9kVe6THEFB8QIQCpbV
	 XdUwwfhbggVsJfb2gU/sSecJxYxcx1s811d6M1yizxfPKeqFOsZHkkhzYmBNHgKFk1
	 VMgCHRrVbXvm4BRDUN/g89OvzL4pnZ+N04NoZAUMg8Et6gz64sq2Xz6ldJQ39n6QmI
	 t3Q1fMoJwlMZw==
Date: Mon, 12 Oct 2026 08:52:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: only written file data blocks can be shared
Message-ID: <20261012155254.GB2705364@frogsfrogsfrogs>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
 <179178065324.1058326.3356948076285838276.stgit@frogsfrogsfrogs>
 <aszb_INSp9qbSTf-@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aszb_INSp9qbSTf-@infradead.org>

On Mon, Oct 12, 2026 at 06:09:16AM -0700, Christoph Hellwig wrote:
> On Sun, Oct 11, 2026 at 10:57:18PM -0700, Darrick J. Wong wrote:
> > +	/*
> > +	 * The refcount btree should only have records for written file data
> > +	 * blocks or for COW staging blocks.
> > +	 */
> > +	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
> > +	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
> > +	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
> > +			      XFS_RMAP_UNWRITTEN))) {
> > +		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
> > +		return 0;
> > +	}
> 
> > +	/*
> > +	 * The refcount btree should only have records for written file data
> > +	 * blocks or for COW staging blocks.
> > +	 */
> > +	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
> > +	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
> > +	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
> > +			      XFS_RMAP_UNWRITTEN))) {
> > +		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
> > +		return 0;
> > +	}
> 
> Can we have a shared helper for this conditional?
> 
> Otherwise this looks good.

rtrefcount.c goes away entirely with sandeen's series in 7.4-next to
combine the two scrubbers, so in the end there won't be this
duplication.

--D
