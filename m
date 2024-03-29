Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159FF3C08F
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 20:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711745094; cv=none; b=RnxHeG4BgCgdHV7NGPmeIlyuAtjnYfZTE++1oBlO+TWLhGK8BFz/EmeChOgCqTO8vkf+BHE87dqiPKR8DkR5eyrx0/vtLyTwgZmM3a5dlhHFWGd42/hKHXo4SBdbNnvVg+/XbshW5RQbRBp6sUdBBqjAIWw9XBKbXxwRcnj2wKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711745094; c=relaxed/simple;
	bh=6JF2757UI0bPGUGWTb2GTahUMqapOqMKx5Z0lRKKtP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=orVuTFcaGReD6dCHi26of+OKv5cBmV4HFL6/B5rmmYMHXjW88t0LZ2AsWnzVZKYQsuWptBhHbaPaysC4a56VdsS4CJBSaZkoZ+Tj6Z3PQRLb9bi5BZXP+U+Y2aYtfbMsfBdkPTz6nm7zEL76SwXKpZIsxhUgytwAf3W4+XCBqkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mrAgLwkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mrAgLwkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839ABC433C7;
	Fri, 29 Mar 2024 20:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711745093;
	bh=6JF2757UI0bPGUGWTb2GTahUMqapOqMKx5Z0lRKKtP0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mrAgLwkp7h+niWK9lbNZ1hbVLzu4TMif4gGJA2SbIO0dX703smf/IXuVd54vv/ENS
	 ku55txWsiyeZGVatXE5cBo3oALwma6gYlg/S3rCKHDbv6pKKBsIdtba4Prud6/NBcv
	 lue7HzqIWuefpZrtrxw275OFKHuQr+DaEqRXoQL8PGy8bYyABeMVvd8qIQEG571vU0
	 gNVJIp71vu2QzHs73cyT02QhK0VuNtgqLo8SlGpZZT7XO/WcoopnJKwPdv1K4odfNf
	 luTEdODFA8D8IP+4EVTuW3D2BWB00zoKCfQIbj/okdpDyovoK2jHFksyxrpLZfx4Yq
	 AhdgnFzFKhktQ==
Date: Fri, 29 Mar 2024 13:44:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: online repair of symbolic links
Message-ID: <20240329204451.GO6390@frogsfrogsfrogs>
References: <171150384345.3219922.17309419281818068194.stgit@frogsfrogsfrogs>
 <171150384365.3219922.12182012253523618503.stgit@frogsfrogsfrogs>
 <ZgRPEk9MdwbPK64Y@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgRPEk9MdwbPK64Y@infradead.org>

On Wed, Mar 27, 2024 at 09:53:38AM -0700, Christoph Hellwig wrote:
> >  /* Write the symlink target into the inode. */
> >  int
> > -xfs_symlink_write_target(
> > +__xfs_symlink_write_target(
> >  	struct xfs_trans	*tp,
> >  	struct xfs_inode	*ip,
> > +	xfs_ino_t		owner,
> 
> The xfs_symlink_write_target/__xfs_symlink_write_target split seems
> a bit pointless with just a single real caller for either variant.
> Why not just pass the owner to xfs_symlink_write_target and do away
> with __xfs_symlink_write_target?
> 
> > +/*
> > + * Symbolic Link Repair
> > + * ====================
> > + *
> > + * We repair symbolic links by reading whatever target data we can find, up to
> > + * the first NULL byte.  Zero length symlinks are turned into links to the
> > + * current directory.
> 
> Are we actually doing that?  xrep_setup_symlink sets up a link with
> the "." target (and could use a comment on why), but we're always
> writing the long dummy target below now, or am I missing something?

If the target that we salvage has the same strlen as i_size, then we'll
rewrite what we found into the symlink.  In all other cases, yes, we
write out the DUMMY_TARGET string.

IOWs, the comment is out of date.  Here's what I have now:

/*
 * Symbolic Link Repair
 * ====================
 *
 * We repair symbolic links by reading whatever target data we can find, up to
 * the first NULL byte.  If the recovered target strlen matches i_size, then
 * we rewrite the target.  In all other cases, we replace the target with an
 * overly long string that cannot possibly resolve.  The new target is written
 * into a private hidden temporary file, and then a file contents exchange
 * commits the new symlink target to the file being repaired.
 */

> > +/* Set us up to repair the rtsummary file. */
> 
> I don't think that's what it does :)
> 
> > +	 * We cannot use xfs_exchmaps_estimate because we have not yet
> > +	 * constructed the replacement rtsummary and therefore do not know how
> > +	 * many extents it will use.  By the time we do, we will have a dirty
> > +	 * transaction (which we cannot drop because we cannot drop the
> > +	 * rtsummary ILOCK) and cannot ask for more reservation.
> 
> No rtsummary here either..

Oops.  Fixed both of those things.  :(

> > +
> > +#define DUMMY_TARGET \
> > +	"The target of this symbolic link could not be recovered at all and " \
> > +	"has been replaced with this explanatory message.  To avoid " \
> > +	"accidentally pointing to an existing file path, this message is " \
> > +	"longer than the maximum supported file name length.  That is an " \
> > +	"acceptable length for a symlink target on XFS but will produce " \
> > +	"File Name Too Long errors if resolved."
> 
> Haha.  Can this cause the repair to run into ENOSPC if the previous
> corrupted symlink was way shorter?

Yes.  In that case, xrep_symlink_rebuild will fail to write DUMMY_TARGET
into sc->tempip, we ifree the tempfile (with its '.' target), and return
the error to userspace.

--D
