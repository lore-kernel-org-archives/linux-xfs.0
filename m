Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B5E7441E
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 19:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709150134; cv=none; b=b1XilQ9EmOB/6ydrp2tHccQxqcTb5HhN+fQf48qHECTlPb0AXF3q/w50MJBdslknDQNARtCjE6EWOTpZ/eOXO4Hh/ztN1yXVqICs7GY9iqkm6vC0Df0N45BoHyyKsnkvHaQ+io3eGb3sgziGo0cNV9Axl0fZx3Nu5Lo1U3QHB4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709150134; c=relaxed/simple;
	bh=I+Ar517lwnHNDkb1jeYECs9iOgByu8DQQ9LLA/ZE1OM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7hQPZtkHCvAjN9m2JNXiKLR3tDw2qs9F1iSHggc1QK1vGh1/ZMCGbOotfQX5vQGH11FwcyFEk0k68LDDbY9QZr8aa2UgsoxrmG2xVK0bbQg9y9kToSeTys3PpxbRKDzWXJtX88eMGcmLj2/Ceb+ZCk/Z3zQFag1fZ1va84rd9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/ZKLN3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/ZKLN3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6701C433A6;
	Wed, 28 Feb 2024 19:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709150132;
	bh=I+Ar517lwnHNDkb1jeYECs9iOgByu8DQQ9LLA/ZE1OM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R/ZKLN3KOcYF6f1RtqPGJle+eK2dfBIWCrhK7zN4PNbwnoOOq2JqLsBVwmi+o5/a7
	 Hjw7vvr83vy0bbHQjokfjBhb+TKMwjBmOMmENyVMTpZcFsaNUEZE9FPct1Ry8++mXY
	 Py0kNfESNyqoO+EGEL0B7QAZbSA466EgEv2Txd8wCizumUL90iMu5thFp98ZRaA407
	 EYZqsg4qiNEAiLDyO55h+3fzZqVcGXgBylgRzFAGFP8zJf5GAW1wX5Deo+6nbODA2u
	 bDA+hoMiovOh89TkyqlPoeoaI9OziptRKk/4kDaHznVD5jIF68lOxL/z5i1prvej5A
	 nZKq/Sb7fpoJg==
Date: Wed, 28 Feb 2024 11:55:32 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/14] xfs: create deferred log items for file mapping
 exchanges
Message-ID: <20240228195532.GR1927156@frogsfrogsfrogs>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011723.938268.9127095506680684172.stgit@frogsfrogsfrogs>
 <Zd9V8VIoA6WpZUDM@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd9V8VIoA6WpZUDM@infradead.org>

On Wed, Feb 28, 2024 at 07:49:05AM -0800, Christoph Hellwig wrote:
> > -static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
> > +static inline bool xfs_bmap_is_written_extent(const struct xfs_bmbt_irec *irec)
> 
> This seems entirely unrelated, can you split it into a cleanup patch?

Done.

> > +		state |= CRIGHT_CONTIG;
> > +	if ((state & CBOTH_CONTIG) == CBOTH_CONTIG &&
> > +	    left->br_startblock + curr->br_startblock +
> > +					right->br_startblock > XFS_MAX_BMBT_EXTLEN)

Oh yikes, that should be br_blockcount, not br_startblock.

> Overly long line here (and pretty weird formatting causing it..)

I'll change it to this helper:

static inline bool
xmi_can_merge_all(
	const struct xfs_bmbt_irec	*l,
	const struct xfs_bmbt_irec	*m,
	const struct xfs_bmbt_irec	*r)
{
	xfs_filblks_t			new_len;

	new_len = l->br_blockcount + m->br_blockcount + r->br_blockcount;
	return new_len <= XFS_MAX_BMBT_EXTLEN;
}

Then the call sites become:

	if ((state & CBOTH_CONTIG) == CBOTH_CONTIG &&
	    !xmi_can_merge_all(left, curr, right))
		state &= ~CRIGHT_CONTIG;

> > +	if ((state & NBOTH_CONTIG) == NBOTH_CONTIG &&
> > +	    left->br_startblock + new->br_startblock +
> > +					right->br_startblock > XFS_MAX_BMBT_EXTLEN)
> 
> Same here.

Here too.

> > +/* XFS-specific parts of file exchanges */
> 
> Well, everything really is XFS-specific :)  I'd drop this comment.

Ok.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
