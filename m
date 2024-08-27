Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC8E4A33
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 03:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724728596; cv=none; b=RGdAU7RDRkUmasft3gxi9BUhEesaC40qyLJ6fX+FSLmfNih+pDJdpdBCDWs+tpmLXhVzUzckZdjbKBxH2W+CwE5m+EFouQBRgW/8RRp73zF80D5QetB16yz1UsRwcxXy6NEDRRFubthl9ksre7hU4ImI+d7Svow1CkjUq4zGQVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724728596; c=relaxed/simple;
	bh=Pwpq2sTTLXAOGUvmQYOdP2UJ+AB+PG+/6MKv4CBqfZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jj74SuUZQ4VIm8BzgxK9LODhswf9PgAhA1ORLMNKvGMx8ridqRf7IJOqJlasvjldX2Az+AwCewphBzsrX6yuZpIvcbo3eu+V2V16ZQku2KB59ygDogcFeTJx8XPl+cTJxKJhqMFpFd2tbnFJGn5oqD6sYTvkgMixcBAx3FIybeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X7VLA+Vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X7VLA+Vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC72C8B7A1;
	Tue, 27 Aug 2024 03:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724728596;
	bh=Pwpq2sTTLXAOGUvmQYOdP2UJ+AB+PG+/6MKv4CBqfZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X7VLA+VlwsmdsWERS1TiSyoNB4Xj6hR0cS9CusPAm5dPexfNzDB0BN7CyH5deSQSJ
	 Y/Sr2cVa1sNkvWKc/1U0ZcPfVjV82l5Z828cWcHlp0aDPCFtNIA1buRbd1R4nDEqA0
	 NjQxnIlNHfk7OhvXMMyEffabiEU0LY3GXmn9fFJlRKhB07S237q/dVhnQN23l0NRey
	 T+RkXIuJpVIX27YPq0uPD0So95nN4FKrpNZc2eTu07IWXGGZSmXlDSlTuDUn5VSysU
	 MhsD5QhKvJh47fucda+y0PhpoVLGao8Y/pPwBeDG9eAiZpiJEGoOlbOuXKOexyHDtd
	 T+F+mImgwwAFw==
Date: Mon, 26 Aug 2024 20:16:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: update sb field checks when metadir is turned on
Message-ID: <20240827031635.GH6082@frogsfrogsfrogs>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089450.61495.17228908896759675474.stgit@frogsfrogsfrogs>
 <ZsxQa3xvdkrwvN48@dread.disaster.area>
 <20240826180747.GY865349@frogsfrogsfrogs>
 <Zs03C0CurF8bmDZr@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs03C0CurF8bmDZr@dread.disaster.area>

On Tue, Aug 27, 2024 at 12:16:43PM +1000, Dave Chinner wrote:
> On Mon, Aug 26, 2024 at 11:07:47AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 26, 2024 at 07:52:43PM +1000, Dave Chinner wrote:
> > > On Thu, Aug 22, 2024 at 05:29:15PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > When metadir is enabled, we want to check the two new rtgroups fields,
> > > > and we don't want to check the old inumbers that are now in the metadir.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/scrub/agheader.c |   36 ++++++++++++++++++++++++------------
> > > >  1 file changed, 24 insertions(+), 12 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > > > index cad997f38a424..0d22d70950a5c 100644
> > > > --- a/fs/xfs/scrub/agheader.c
> > > > +++ b/fs/xfs/scrub/agheader.c
> > > > @@ -147,14 +147,14 @@ xchk_superblock(
> > > >  	if (xfs_has_metadir(sc->mp)) {
> > > >  		if (sb->sb_metadirino != cpu_to_be64(mp->m_sb.sb_metadirino))
> > > >  			xchk_block_set_preen(sc, bp);
> > > > +	} else {
> > > > +		if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
> > > > +			xchk_block_set_preen(sc, bp);
> > > > +
> > > > +		if (sb->sb_rsumino != cpu_to_be64(mp->m_sb.sb_rsumino))
> > > > +			xchk_block_set_preen(sc, bp);
> > > >  	}
> > > >  
> > > > -	if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
> > > > -		xchk_block_set_preen(sc, bp);
> > > > -
> > > > -	if (sb->sb_rsumino != cpu_to_be64(mp->m_sb.sb_rsumino))
> > > > -		xchk_block_set_preen(sc, bp);
> > > > -
> > > 
> > > If metadir is enabled, then shouldn't sb->sb_rbmino/sb_rsumino both
> > > be NULLFSINO to indicate they aren't valid?
> > 
> > The ondisk sb values aren't defined anymore and we set the incore values
> > to NULLFSINO (and never write that back out) so there's not much to
> > check anymore.  I guess we could check that they're all zero or
> > something, which is what mkfs writes out, though my intent here was to
> > leave them as undefined bits, figuring that if we ever want to reuse
> > those fields we're going to define a new incompat bit anyway.
> > 
> > OTOH now would be the time to define what the field contents are
> > supposed to be -- zero or NULLFSINO?
> 
> Yeah, I think it's best to give them a solid definition, that way we
> don't bump up against "we can't tell if it has never been used
> before" problems.
> 
> > 
> > > Given the rt inodes should have a well defined value even when
> > > metadir is enabled, I would say the current code that is validating
> > > the values are consistent with the primary across all secondary
> > > superblocks is correct and this change is unnecessary....
> > > 
> > > 
> > > > @@ -229,11 +229,13 @@ xchk_superblock(
> > > >  	 * sb_icount, sb_ifree, sb_fdblocks, sb_frexents
> > > >  	 */
> > > >  
> > > > -	if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
> > > > -		xchk_block_set_preen(sc, bp);
> > > > +	if (!xfs_has_metadir(mp)) {
> > > > +		if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
> > > > +			xchk_block_set_preen(sc, bp);
> > > >  
> > > > -	if (sb->sb_gquotino != cpu_to_be64(mp->m_sb.sb_gquotino))
> > > > -		xchk_block_set_preen(sc, bp);
> > > > +		if (sb->sb_gquotino != cpu_to_be64(mp->m_sb.sb_gquotino))
> > > > +			xchk_block_set_preen(sc, bp);
> > > > +	}
> > > 
> > > Same - if metadir is in use and quota inodes are in the metadir,
> > > then the superblock quota inodes should be NULLFSINO....
> > 
> > Ok, I'll go with NULLFSINO ondisk and in memory.
> 
> OK.
> 
> Just to add to that (because I looked), mkfs.xfs does this to
> initialise rtino numbers before they are allocated:
> 
> $ git grep NULLFSINO mkfs
> mkfs/xfs_mkfs.c:        sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
> $
> 
> and repair does this for quota inodes when clearing the superblock
> inode fields:
> 
> $ git grep NULLFSINO repair/dinode.c
> repair/dinode.c:                        mp->m_sb.sb_uquotino = NULLFSINO;
> repair/dinode.c:                        mp->m_sb.sb_gquotino = NULLFSINO;
> repair/dinode.c:                        mp->m_sb.sb_pquotino = NULLFSINO;
> $
> 
> So the current code is typically using NULLFSINO instead of zero on
> disk for "inode does not exist".

<nod> Though I noticed that it writes out sb_[ugp]quotino = 0.
Christoph once remarked that those parts of the sb were at some point
unused, so they were zero, and they only become NULLFSINO once someone
turns on QUOTABIT in sb_versionnum.

Regardless, all 1s is ok by me.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
