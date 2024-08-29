Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A657926296
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 22:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724969430; cv=none; b=Mqopk/fxuUpmSsbrkXLLSejMUk3G8clYHoG9loKFe9G707tXEIOFHKI8MmZgrv3qh4dUT2CYKBcfFJfTtSeMS3UgA23aVrr2x84yRUrnpbAgcGmVjW8gqkzynL+YSPQIHn16IcRe9gmL/LGmMhedz6iPP4oe2KgkuhTd7QLZx2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724969430; c=relaxed/simple;
	bh=Jp5OOPqGXTF5XL580yUT1PXbqJwYGo01yisG+oBk2Nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oijXJHETnn7Jg0wAFdT5+0T++us+d36SNyO2CfHAd/v2n7cw5vn4oCAecWjrChCuTyrmTTHaPNDPwsEL3rvtl7ZhCPunsU5S1qILfPnY8r2a7c7bzm4PDe2aELtjwNW1FoN3ESQiq7x9D03Ar/1ua1bokLX+88prZfqVJg8HBNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=anjpFaIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="anjpFaIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F0AC4CEC1;
	Thu, 29 Aug 2024 22:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724969430;
	bh=Jp5OOPqGXTF5XL580yUT1PXbqJwYGo01yisG+oBk2Nc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=anjpFaIoaXae2xdMSwQQj5ZUnLtn5R6a60/G+Tz8APodOd5uJ9ZNN3J6KFpnBMT+7
	 WRYfCzMsiO4NhIDaHnTTn/Hy25RfMUBq/af4QHRICA8gD8A9DUotppGULZ03TWpo50
	 F4dn5AxLqFdBzL9Lpcjmay5bNbbEBS2h5ZUS+z+nVXohABMK/GZaNYlNx3CtV9RTqz
	 FR5yHONMBpzSeCBgTaOf6gQhwHdf11DqZYAAY+LnpgfAFkn0frsseaYiGn32B6jEVr
	 bW5fLFzLwRi9JbK7Xc81Ii4E5qYqANyMHIjKXKFLxjJSl/cryk195rJqZ/wlrIxjKc
	 Ymn7RQtxlmwiQ==
Date: Thu, 29 Aug 2024 15:10:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/10] xfs: replace shouty XFS_BM{BT,DR} macros
Message-ID: <20240829221029.GR6224@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <172480131573.2291268.11692699884722779994.stgit@frogsfrogsfrogs>
 <Zs/WSw6fm4SyyyW4@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs/WSw6fm4SyyyW4@dread.disaster.area>

On Thu, Aug 29, 2024 at 12:00:43PM +1000, Dave Chinner wrote:
> On Tue, Aug 27, 2024 at 04:34:45PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Replace all the shouty bmap btree and bmap disk root macros with actual
> > functions, and fix a type handling error in the xattr code that the
> > macros previously didn't care about.
> 
> I don't see a type handling fix in the xattr code in the patch.
> 
> If there is one, can you please split it out to make it obvious?

No, I think that's just debris from an old iteration of this years-old
patch.  The xattr fixes got merged in the xattr state machine series
that Allison merged a long time ago.

> ....
> 
> > -#define XFS_BMDR_REC_ADDR(block, index) \
> > -	((xfs_bmdr_rec_t *) \
> > -		((char *)(block) + \
> > -		 sizeof(struct xfs_bmdr_block) + \
> > -	         ((index) - 1) * sizeof(xfs_bmdr_rec_t)))
> 
> > +
> > +static inline struct xfs_bmbt_rec *
> > +xfs_bmdr_rec_addr(
> > +	struct xfs_bmdr_block	*block,
> > +	unsigned int		index)
> > +{
> > +	return (struct xfs_bmbt_rec *)
> > +		((char *)(block + 1) +
> > +		 (index - 1) * sizeof(struct xfs_bmbt_rec));
> > +}
> 
> There's a logic change in these BMDR conversions - why does the new
> version use (block + 1) and the old one use a (block + sizeof())
> calculation?

Pointer arithmetic works great inside C functions where you know the
type of the operand.  That's why I used it.

That doesn't work at all in a macro where someone could pass in any
random pointer and then the math is wrong.  That's why the macro casts
to a byte-sized pointer type and then adds exactly the sizeof() bytes,
or at least I assume that's the motivation of the authors.

> I *think* they are equivalent, but now as I read the code I have to
> think about casts and pointer arithmetic and work out what structure
> we are taking the size of in my head rather than it being straight
> forward and obvious from the code.

The function argument declaration is four lines up.

> It doesn't change the code that is generated, so I think that the
> existing "+ sizeof()" variants is better than this mechanism because
> everyone is familiar with the existing definitions....

I disagree.  With your change, to validate this function, everyone must
to check that the argument type matches the sizeof argument to confirm
that the pointer arithmetic is correct.

static inline struct xfs_bmbt_rec *
xfs_bmdr_rec_addr(
	struct xfs_bmdr_block	*block,
	unsigned int		index)
{
	return (struct xfs_bmbt_rec *)
		((char *)(block) +
		 sizeof(struct xfs_btree_block) +
		 (index - 1) * sizeof(struct xfs_bmbt_rec));
}

Oops, this function is broken, when we could have trusted the compiler
to get the types and the math correct for us.

> > +static inline struct xfs_bmbt_key *
> > +xfs_bmdr_key_addr(
> > +	struct xfs_bmdr_block	*block,
> > +	unsigned int		index)
> > +{
> > +	return (struct xfs_bmbt_key *)
> > +		((char *)(block + 1) +
> > +		 (index - 1) * sizeof(struct xfs_bmbt_key));
> > +}
> > +
> > +static inline xfs_bmbt_ptr_t *
> > +xfs_bmdr_ptr_addr(
> > +	struct xfs_bmdr_block	*block,
> > +	unsigned int		index,
> > +	unsigned int		maxrecs)
> > +{
> > +	return (xfs_bmbt_ptr_t *)
> > +		((char *)(block + 1) +
> > +		 maxrecs * sizeof(struct xfs_bmbt_key) +
> > +		 (index - 1) * sizeof(xfs_bmbt_ptr_t));
> > +}
> 
> Same for these.
> 
> > +/*
> > + * Compute the space required for the incore btree root containing the given
> > + * number of records.
> > + */
> > +static inline size_t
> > +xfs_bmap_broot_space_calc(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		nrecs)
> > +{
> > +	return xfs_bmbt_block_len(mp) + \
> > +	       (nrecs * (sizeof(struct xfs_bmbt_key) + sizeof(xfs_bmbt_ptr_t)));
> > +}
> 
> stray '\' remains in that conversion.

Will fix, thanks.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
