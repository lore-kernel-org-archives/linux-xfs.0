Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029C81F80A9
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 19:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729019046; cv=none; b=bmMS6ErbrgKQPoY2WzQlfq4iJEqMI5MdlBasfXtqMGrjgqT+RMxIiya0r8quN/8cTjF1Cyj4hvCr4xTkGio+m2wLKV6HeF3pfM2dNlqlY8NIc1I+vs2qgEpzD4WHBz7hixstNeeq6CfNRiueiUyt9JB5fPc+KSnmbLB/wxdKaFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729019046; c=relaxed/simple;
	bh=ei73gi7CEXiFG/6qHTMKD7m40WxAy1XZfozKuXXVnUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N4t/gYEB4ptPFZgvaCtUhA1/ILRs5fIA7dqglb0v2PYaJxf7ElbBMmNNf39KqZiDQJf1UvqnxIOKHaiF9NbxS6GNT8j4XMgS2oDgjXkAAOjGP4tpPYtUDsiQDN87Czst+NWdB2F2yu664pVGzVle7H2VE5bRb+PtV4xrRLCpiRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KpMJvNn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KpMJvNn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1B5C4CEC7;
	Tue, 15 Oct 2024 19:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729019045;
	bh=ei73gi7CEXiFG/6qHTMKD7m40WxAy1XZfozKuXXVnUE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KpMJvNn7sxqt1xa768EuOWQmVb5P9mFM/lnp1PgmoZW4dwyy0cTelOCEVrBvF5xz8
	 NtiLpi6dX31a1o2izIsNv2Q2ab2BfXJiSHUzPLh3zHzpHvcT9Ll9tT16vcwaGRDYDv
	 9+QFV1VR0g7f0wtAPsKmumdOZvh2vLX0uV366euF1liyB/1cToPSkIda42zh8gtUsJ
	 LPVfCu2wgBAU0S0r7+9Oc5INwnp26vfHrb6hBUBn1PKnLuvNOO4d3iRKCMtHczvRbC
	 OthGLrN0Jz4GytO7iLLTgH0g3sUsbJiHHwux8uI1/aYPA/c4ssc5WI1V6aTzEtq8NT
	 wAFU1eGIRtUNw==
Date: Tue, 15 Oct 2024 12:04:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/28] xfs: iget for metadata inodes
Message-ID: <20241015190404.GH21853@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642100.4176876.17733066608512712993.stgit@frogsfrogsfrogs>
 <Zw4R2zxI6XwOHrIC@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw4R2zxI6XwOHrIC@dread.disaster.area>

On Tue, Oct 15, 2024 at 05:55:23PM +1100, Dave Chinner wrote:
> On Thu, Oct 10, 2024 at 05:49:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a xfs_metafile_iget function for metadata inodes to ensure that
> > when we try to iget a metadata file, the inobt thinks a metadata inode
> > is in use and that the metadata type matches what we are expecting.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> .....
> 
> > +/*
> > + * Get a metadata inode.  The metafile @type must match the inode exactly.
> > + * Caller must supply a transaction (even if empty) to avoid livelocking if the
> > + * inobt has a cycle.
> 
> Is this something we have to be concerned with for normal operation?

I think we should be more concerned about this everywhere.  Remember
that guy who fuzzed a btree so that the lower levels pointed "down" to
an upper level btree block?  Detection and recovery from that is what
running with xfs_trans_alloc_empty() buys us.  It's not a general cycle
detector as you point out below...

> We don't care about needing to detect inobt cycles this when doing
> lookups from the VFS during normal operation, so why is this an
> issue we have to be explicitly concerned about during metadir
> traversals?
> 
> Additionally, I can see how a corrupt btree ptr loop could cause a
> *deadlock* without a transaction context (i.e. end up waiting on a
> lock we already hold) but I don't see what livelock the transaction
> context prevents. It appears to me that it would only turn the
> deadlock into a livelock because the second buffer lookup will find
> the locked buffer already linked to the transaction and simply take
> another reference to it.  Hence it will just run around the loop of
> buffers taking references forever (i.e. a livelock) instead of
> deadlocking.

...because we don't detect loops within a particular level of a btree.
In theory this is possible if you are willing to enhance (for example)
a XFS_BB_RIGHTSIB move by comparing the rightmost record in the old
block against the leftmost record in the new block, but right now the
codebase (except for scrub) doesn't do that.

Maybe someone'll do that some day; it would close a pretty big hole in
runtime problem detection.

> Another question: why are we only concerned cycles in the inobt? If
> we've got a cycle in any other btree the metadir code might interact
> with (e.g. directories, free space, etc), we're going to have the
> same problems with deadlocks and/or livelocks on tree traversal. 

We /do/ hold empty transactions when calling xfs_metadir_load so that we
can error out on wrong-level types of dabtree cycles instead of hanging
the kernel.

> > + */
> > +int
> > +xfs_trans_metafile_iget(
> > +	struct xfs_trans	*tp,
> > +	xfs_ino_t		ino,
> > +	enum xfs_metafile_type	metafile_type,
> > +	struct xfs_inode	**ipp)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_inode	*ip;
> > +	umode_t			mode;
> > +	int			error;
> > +
> > +	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &ip);
> 
> Along a similar line: why don't we trust our own internal inode
> references to be correct and valid? These aren't structures that are
> externally visible or accessible, so the only thing that should be
> interacting with metadir inodes is trusted kernel code.
> 
> At minimum, this needs a big comment explaining why we can't trust
> our metadir structure and why this is different to normal inode
> lookup done for inodes accessed by path traversal from the root
> dir.
> 
> Also, doing a trusted lookup means we don't have to walk the inobt
> during the inode lookup, and so the deadlock/livelock problem goes
> away....
> 
> > @@ -1133,45 +1130,54 @@ xfs_rtmount_iread_extents(
> >   * Get the bitmap and summary inodes and the summary cache into the mount
> >   * structure at mount time.
> >   */
> > -int					/* error */
> > +int
> >  xfs_rtmount_inodes(
> > -	xfs_mount_t	*mp)		/* file system mount structure */
> > +	struct xfs_mount	*mp)
> >  {
> > -	int		error;		/* error return value */
> > -	xfs_sb_t	*sbp;
> > +	struct xfs_trans	*tp;
> > +	struct xfs_sb		*sbp = &mp->m_sb;
> > +	int			error;
> >  
> > -	sbp = &mp->m_sb;
> > -	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
> 
> .... and it's clear that we currently treat the superblock inodes as
> trusted inode numbers. We don't validate that they are allocated
> when we look them up, we trust that they have been correctly
> allocated and properly referenced on disk.
> 
> It's not clear to me why there's an undocumented change of
> trust for internal, trusted access only on-disk metadata being made
> here...

I feel it prudent to check for inconsistencies between the inobt state
and the inode records themselves, because bad space metadata can cause
disproportionately more problems in a filesystem than a regular file's
metadata.  Unlike regular files that can be unloaded and reloaded at
will, we only do this once, so the overhead of the inobt walk is
amortized over the entire mount-lifetime of the filesystem because we
don't irele metadata inodes.

IOWs it's not strictly necessary, but the cost is low to have this
additional safety.

But you're right, that should've been in the comment for this function.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
