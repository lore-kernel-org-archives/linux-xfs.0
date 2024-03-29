Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF771E525
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 20:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711745936; cv=none; b=DA0EcwrmOA2IqQriM8Mume6w5RpSQKdNUaC253JgVJn9GBe9wr5jewgW2wAaYbdA4Ioiebqiaq6XyETZyOiWUoM7xommiwqG6EIfKUKq4sBB7o7tBskjAzoPealDYIpiLJc80B2KwXiv1SvRfXmrV3dVwkYbGN7Ql/lGhPcgphY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711745936; c=relaxed/simple;
	bh=L5WSHPibHSznnpiyUvEC9tvzzCtQbpymOZ46MYlBbSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WxDugwhsMYYYu0mGM2PKRYtMHwjAybn8mVYsMAc/Qde366es5fhxxkURGegLwOZssS7iWmrrzx48DugO4YIUEMq7GsgEc1GEBPruhzdMuw9J7LQkk6HC1QRwGPnhXSWeFVfBHltoJgrOl+XUO1+kRRs1jFBU1ggt1AvIUhHqYZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hezm7QgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hezm7QgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13AFC433F1;
	Fri, 29 Mar 2024 20:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711745935;
	bh=L5WSHPibHSznnpiyUvEC9tvzzCtQbpymOZ46MYlBbSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hezm7QgOslB00/rqRARSjj55JTGUNN3L/V0IzHKpjFUHH7Epv0SAr9pWuKdaTsiEr
	 g/kLHcyDzw2p3UG4/1q/LuEEf1NkC5I4qz7Bjn8+OK68ZYTZpnXlaB2zZgePQsw7EL
	 Vto8eJ6pstTOs0G4z2ELB4xVx5raETyg48ZHMX9APi5LXZiZDePkPvTrqvhUSyZzzN
	 c4Djfz8S0pXHFHxQbB9QWQpoEsP+OfDxf7CV9QW8Y/KZ2y414QFKjFrTNXExdy68/0
	 vQwqAcwa8vzzns/JE1aUVMDIkhnW1NbtyozEWARioOxp+mr/K/u1mZDoThBGcQaY6b
	 z7zDrbZJ7YcWA==
Date: Fri, 29 Mar 2024 13:58:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: online repair of symbolic links
Message-ID: <20240329205855.GP6390@frogsfrogsfrogs>
References: <171150384345.3219922.17309419281818068194.stgit@frogsfrogsfrogs>
 <171150384365.3219922.12182012253523618503.stgit@frogsfrogsfrogs>
 <ZgRPEk9MdwbPK64Y@infradead.org>
 <20240329204451.GO6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240329204451.GO6390@frogsfrogsfrogs>

On Fri, Mar 29, 2024 at 01:44:51PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 27, 2024 at 09:53:38AM -0700, Christoph Hellwig wrote:
> > >  /* Write the symlink target into the inode. */
> > >  int
> > > -xfs_symlink_write_target(
> > > +__xfs_symlink_write_target(
> > >  	struct xfs_trans	*tp,
> > >  	struct xfs_inode	*ip,
> > > +	xfs_ino_t		owner,
> > 
> > The xfs_symlink_write_target/__xfs_symlink_write_target split seems
> > a bit pointless with just a single real caller for either variant.
> > Why not just pass the owner to xfs_symlink_write_target and do away
> > with __xfs_symlink_write_target?

Oops, I forgot to respond to this -- yeah, I'll get rid of this trivial
helper.

--D

> > > +/*
> > > + * Symbolic Link Repair
> > > + * ====================
> > > + *
> > > + * We repair symbolic links by reading whatever target data we can find, up to
> > > + * the first NULL byte.  Zero length symlinks are turned into links to the
> > > + * current directory.
> > 
> > Are we actually doing that?  xrep_setup_symlink sets up a link with
> > the "." target (and could use a comment on why), but we're always
> > writing the long dummy target below now, or am I missing something?
> 
> If the target that we salvage has the same strlen as i_size, then we'll
> rewrite what we found into the symlink.  In all other cases, yes, we
> write out the DUMMY_TARGET string.
> 
> IOWs, the comment is out of date.  Here's what I have now:
> 
> /*
>  * Symbolic Link Repair
>  * ====================
>  *
>  * We repair symbolic links by reading whatever target data we can find, up to
>  * the first NULL byte.  If the recovered target strlen matches i_size, then
>  * we rewrite the target.  In all other cases, we replace the target with an
>  * overly long string that cannot possibly resolve.  The new target is written
>  * into a private hidden temporary file, and then a file contents exchange
>  * commits the new symlink target to the file being repaired.
>  */
> 
> > > +/* Set us up to repair the rtsummary file. */
> > 
> > I don't think that's what it does :)
> > 
> > > +	 * We cannot use xfs_exchmaps_estimate because we have not yet
> > > +	 * constructed the replacement rtsummary and therefore do not know how
> > > +	 * many extents it will use.  By the time we do, we will have a dirty
> > > +	 * transaction (which we cannot drop because we cannot drop the
> > > +	 * rtsummary ILOCK) and cannot ask for more reservation.
> > 
> > No rtsummary here either..
> 
> Oops.  Fixed both of those things.  :(
> 
> > > +
> > > +#define DUMMY_TARGET \
> > > +	"The target of this symbolic link could not be recovered at all and " \
> > > +	"has been replaced with this explanatory message.  To avoid " \
> > > +	"accidentally pointing to an existing file path, this message is " \
> > > +	"longer than the maximum supported file name length.  That is an " \
> > > +	"acceptable length for a symlink target on XFS but will produce " \
> > > +	"File Name Too Long errors if resolved."
> > 
> > Haha.  Can this cause the repair to run into ENOSPC if the previous
> > corrupted symlink was way shorter?
> 
> Yes.  In that case, xrep_symlink_rebuild will fail to write DUMMY_TARGET
> into sc->tempip, we ifree the tempfile (with its '.' target), and return
> the error to userspace.
> 
> --D
> 
