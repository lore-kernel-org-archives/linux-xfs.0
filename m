Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE6E17D8A6
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 18:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724695668; cv=none; b=CzaZ/sYAtEBoU0rKBCF3LjZ4aUAjXlUW7NfUff0fY/cs0IT2jOrAOX3HBLTqfewenrkhA6V0LM1xAwRqxs8+kZGelES10rVDAktrlapzm84PJNAnE5HB7hCtdZMDk2aApIB/n9OrObZtcfkQI+qUbdYo5GIDq9RcE1wNNBG4RJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724695668; c=relaxed/simple;
	bh=9K6XpI245hS6v+ZqPhCecbBRHOo6h9kB3z+Re8vJAMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jsWrjdT82aZTnOZ5HH5jaPjswcG9GDYPxmbR66DpgLJhN/dtoqk6x2ea8SG4Pa7WZGF4ZS1j/s3uHpmHDc84Fki2M/sRzwTAcxwNcJPq1uV3WQhtnO1yg55OXPdbci3BgOemv793jse2+6jCdqLtVVLo4glmNzKed3qOD01SlOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m/hLgfQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m/hLgfQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310F9C8B7A2;
	Mon, 26 Aug 2024 18:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724695668;
	bh=9K6XpI245hS6v+ZqPhCecbBRHOo6h9kB3z+Re8vJAMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m/hLgfQLtaP8/gGnzq79n9bOUjafmn/2sZP+t+UFdc0h084bSn6gX4NfYs5f4qEOg
	 aHzt2F9Z85h9xvdSEXMe4qecgVrzLJSMG83QpSy7yXzRYDNQ3aTcJ+cxiiHqMCpWeH
	 mFlCbh3THbPZNynC6XHu9c6Z2fE9W0UHhPoRpruwQtfb7IV18+4dzDgpevPwrALi7r
	 nL7quVXJdsfdByr/8IiTqs3Ra84MeuVkWXI6qj0tDQmWRq/8LlLhU3z7UeaTaxjV04
	 cecGbLld9uRXi49/eJobqx9oDl0G0pUkOoUte5xRxkQ/IhkFDEjFsbzJLJQRQmLO1G
	 pBzMtfT1ddtBw==
Date: Mon, 26 Aug 2024 11:07:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: update sb field checks when metadir is turned on
Message-ID: <20240826180747.GY865349@frogsfrogsfrogs>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089450.61495.17228908896759675474.stgit@frogsfrogsfrogs>
 <ZsxQa3xvdkrwvN48@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsxQa3xvdkrwvN48@dread.disaster.area>

On Mon, Aug 26, 2024 at 07:52:43PM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2024 at 05:29:15PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When metadir is enabled, we want to check the two new rtgroups fields,
> > and we don't want to check the old inumbers that are now in the metadir.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/agheader.c |   36 ++++++++++++++++++++++++------------
> >  1 file changed, 24 insertions(+), 12 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index cad997f38a424..0d22d70950a5c 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -147,14 +147,14 @@ xchk_superblock(
> >  	if (xfs_has_metadir(sc->mp)) {
> >  		if (sb->sb_metadirino != cpu_to_be64(mp->m_sb.sb_metadirino))
> >  			xchk_block_set_preen(sc, bp);
> > +	} else {
> > +		if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
> > +			xchk_block_set_preen(sc, bp);
> > +
> > +		if (sb->sb_rsumino != cpu_to_be64(mp->m_sb.sb_rsumino))
> > +			xchk_block_set_preen(sc, bp);
> >  	}
> >  
> > -	if (sb->sb_rbmino != cpu_to_be64(mp->m_sb.sb_rbmino))
> > -		xchk_block_set_preen(sc, bp);
> > -
> > -	if (sb->sb_rsumino != cpu_to_be64(mp->m_sb.sb_rsumino))
> > -		xchk_block_set_preen(sc, bp);
> > -
> 
> If metadir is enabled, then shouldn't sb->sb_rbmino/sb_rsumino both
> be NULLFSINO to indicate they aren't valid?

The ondisk sb values aren't defined anymore and we set the incore values
to NULLFSINO (and never write that back out) so there's not much to
check anymore.  I guess we could check that they're all zero or
something, which is what mkfs writes out, though my intent here was to
leave them as undefined bits, figuring that if we ever want to reuse
those fields we're going to define a new incompat bit anyway.

OTOH now would be the time to define what the field contents are
supposed to be -- zero or NULLFSINO?

> Given the rt inodes should have a well defined value even when
> metadir is enabled, I would say the current code that is validating
> the values are consistent with the primary across all secondary
> superblocks is correct and this change is unnecessary....
> 
> 
> > @@ -229,11 +229,13 @@ xchk_superblock(
> >  	 * sb_icount, sb_ifree, sb_fdblocks, sb_frexents
> >  	 */
> >  
> > -	if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
> > -		xchk_block_set_preen(sc, bp);
> > +	if (!xfs_has_metadir(mp)) {
> > +		if (sb->sb_uquotino != cpu_to_be64(mp->m_sb.sb_uquotino))
> > +			xchk_block_set_preen(sc, bp);
> >  
> > -	if (sb->sb_gquotino != cpu_to_be64(mp->m_sb.sb_gquotino))
> > -		xchk_block_set_preen(sc, bp);
> > +		if (sb->sb_gquotino != cpu_to_be64(mp->m_sb.sb_gquotino))
> > +			xchk_block_set_preen(sc, bp);
> > +	}
> 
> Same - if metadir is in use and quota inodes are in the metadir,
> then the superblock quota inodes should be NULLFSINO....

Ok, I'll go with NULLFSINO ondisk and in memory.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
