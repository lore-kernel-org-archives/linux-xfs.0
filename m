Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F9857318
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 23:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFylJeqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCA2C433CC;
	Tue, 28 Nov 2023 23:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701212929;
	bh=/TcXiUuh1ZNpDmpTaATugCPfEXX90mSjKYBuarR4MTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VFylJeqz8U6pptW9udYDRDkB5v4pU9EYFUOMiz0xGPmCu+yc0St/8M59YyAFGiFCk
	 osi3Cer+Y16OmovUiouHS2lYliIXMNKC3icmIuSQw43xamJGYg0PYaYB4TRytZb4oo
	 oyyv/in76yaN2UbuByhxlNnMT7mYcH3mP9FqgW3ux8qNG8iX5tBBCma3pqh/3tz9cy
	 88FsW48s6HjlGVIagKbLEkL4p9nE8Y1uaOnBsx6DsQehsZdNmfVOPSOslEG6buIbXD
	 BsHLjd7Hyte9U8/ymGh6uhmJQcSSEsVH1sioZn4jZYlOT+wlMbauNuePQtxUSRjrZY
	 YSmVSM9JSmfsw==
Date: Tue, 28 Nov 2023 15:08:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: repair inode records
Message-ID: <20231128230848.GD4167244@frogsfrogsfrogs>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927488.2771142.16279946215209833817.stgit@frogsfrogsfrogs>
 <ZWYek3C/x7pLqRFj@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZWYek3C/x7pLqRFj@infradead.org>

On Tue, Nov 28, 2023 at 09:08:35AM -0800, Christoph Hellwig wrote:
> > @@ -1012,7 +1012,8 @@ enum xfs_dinode_fmt {
> >  #define XFS_DFORK_APTR(dip)	\
> >  	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
> >  #define XFS_DFORK_PTR(dip,w)	\
> > -	((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : XFS_DFORK_APTR(dip))
> > +	((void *)((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : \
> > +					 XFS_DFORK_APTR(dip)))
> 
> Not requiring a cast when using XFS_DFORK_PTR is a good thing, but I
> think this is the wrong way to do it.  Instead of adding another cast
> here we can just change the char * cast in XFS_DFORK_DPTR to a void *
> one and rely on the widely used void pointer arithmetics extension in
> gcc (and clang).

Ok.

> That'll also need a fixup to use a void instead of
> char * cast in xchk_dinode.

I'll change the conditional to:

	if (XFS_DFORK_BOFF(dip) >= mp->m_sb.sb_inodesize)

> And in the long run many of these helpers relly should become inline
> functions..
> 
> > +	/* no large extent counts without the filesystem feature */
> > +	if ((flags2 & XFS_DIFLAG2_NREXT64) && !xfs_has_large_extent_counts(mp))
> > +		goto bad;
> 
> This is just a missing check and not really related to repair, is it?

Yep.  I guess I'll pull that out into a separate patch.

> > +	/*
> > +	 * The only information that needs to be passed between inode scrub and
> > +	 * repair is the location of the ondisk metadata if iget fails.  The
> > +	 * rest of struct xrep_inode is context data that we need to massage
> > +	 * the ondisk inode to the point that iget will work, which means that
> > +	 * we don't allocate anything at all if the incore inode is loaded.
> > +	 */
> > +	if (!imap)
> > +		return 0;
> 
> I don't really understand why this comment is here, and how it relates
> to the imap NULL check.  But as the only caller passes the address of an
> on-stack imap I also don't understand why the check is here to start
> with.

Hmm.  I think I've been through too many iterations of this code -- at
one point I remember the null check was actually useful for something.
But now it's not, so it can go.

> 
> > +	for (i = 0; i < ni; i++) {
> > +		ioff = i << mp->m_sb.sb_inodelog;
> > +		dip = xfs_buf_offset(bp, ioff);
> > +		agino = be32_to_cpu(dip->di_next_unlinked);
> > +
> > +		unlinked_ok = magic_ok = crc_ok = false;
> 
> I'd split the body of this loop into a separate helper and keep a lot of
> the variables local to it.

Ok.

> > +/* Reinitialize things that never change in an inode. */
> > +STATIC void
> > +xrep_dinode_header(
> > +	struct xfs_scrub	*sc,
> > +	struct xfs_dinode	*dip)
> > +{
> > +	trace_xrep_dinode_header(sc, dip);
> > +
> > +	dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> > +	if (!xfs_dinode_good_version(sc->mp, dip->di_version))
> > +		dip->di_version = 3;
> 
> Can we ever end up here for v4 file systems? Because in that case
> the sane default inode version would be 2.

No.  xchk_validate_inputs will reject IFLAG_REPAIR on a V4 fs.  Those
are deprecated, there's no point in going back.

> > +
> > +/* Turn di_mode into /something/ recognizable. */
> > +STATIC void
> > +xrep_dinode_mode(
> > +	struct xfs_scrub	*sc,
> > +	struct xfs_dinode	*dip)
> > +{
> > +	uint16_t		mode;
> > +
> > +	trace_xrep_dinode_mode(sc, dip);
> > +
> > +	mode = be16_to_cpu(dip->di_mode);
> > +	if (mode == 0 || xfs_mode_to_ftype(mode) != XFS_DIR3_FT_UNKNOWN)
> 
> This is a somewhat odd way to check for a valid mode, but it works, so..

:)

> > +	if (xfs_has_reflink(mp) && S_ISREG(mode))
> > +		flags2 |= XFS_DIFLAG2_REFLINK;
> 
> We set the reflink flag by default, because a later stage will clear
> it if there aren't any shared blocks, right?  Maybe add a comment to
> avoid any future confusion.

	/*
	 * For regular files on a reflink filesystem, set the REFLINK flag to
	 * protect shared extents.  A later stage will actually check those
	 * extents and clear the flag if possible.
	 */

> 
> > +STATIC void
> > +xrep_dinode_zap_symlink(
> > +	struct xfs_scrub	*sc,
> > +	struct xfs_dinode	*dip)
> > +{
> > +	char			*p;
> > +
> > +	trace_xrep_dinode_zap_symlink(sc, dip);
> > +
> > +	dip->di_format = XFS_DINODE_FMT_LOCAL;
> > +	dip->di_size = cpu_to_be64(1);
> > +	p = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
> > +	*p = '.';
> 
> Hmm, changing a symlink to actually point somewhere seems very
> surprising, but making it point to the current directory almost begs
> for userspace code to run in loops.

How about '🤷'?  That's only four bytes.

Or maybe a question mark.

> > +}
> > +
> > +/*
> > + * Blow out dir, make it point to the root.  In the future repair will
> > + * reconstruct this directory for us.  Note that there's no in-core directory
> > + * inode because the sf verifier tripped, so we don't have to worry about the
> > + * dentry cache.
> > + */
> 
> "make it point to root" isn't what I read in the code below.  I parents
> it in root I think.

Yes.  Changed to "Blow out dir, make the parent point to the root."

> > +/* Make sure we don't have a garbage file size. */
> > +STATIC void
> > +xrep_dinode_size(
> > +	struct xfs_scrub	*sc,
> > +	struct xfs_dinode	*dip)
> > +{
> > +	uint64_t		size;
> > +	uint16_t		mode;
> > +
> > +	trace_xrep_dinode_size(sc, dip);
> > +
> > +	mode = be16_to_cpu(dip->di_mode);
> > +	size = be64_to_cpu(dip->di_size);
> 
> Any reason to not simplify initialize the variables at declaration
> time?  (Same for a while bunch of other functions / variables)

No, not really.  Will fix.

> > +	if (xfs_has_reflink(sc->mp)) {
> > +		; /* data fork blockcount can exceed physical storage */
> 
> ... because we would be reflinking the same blocks into the same inode
> at different offsets over and over again ... ?

Yes.  That's not a terribly functional file, but users can do such
things if they want to pay for the cpu/metadata.

> Still, shouldn't we limit the condition to xfs_is_reflink_inode?

Yep.

> > +/* Check for invalid uid/gid/prid. */
> > +STATIC void
> > +xrep_inode_ids(
> > +	struct xfs_scrub	*sc)
> > +{
> > +	bool			dirty = false;
> > +
> > +	trace_xrep_inode_ids(sc);
> > +
> > +	if (i_uid_read(VFS_I(sc->ip)) == -1U) {
> 
> What is invalid about all-F uid/gid/projid?

I thought those were invalid, though apparently they're not now?
uidgid.h says:

static inline bool uid_valid(kuid_t uid)
{
	return __kuid_val(uid) != (uid_t) -1;
}

Which is why I thought that it's not possible to have a uid of -1 on a
file.  Trying to set that uid on a file causes the kernel to reject the
value, but OTOH I can apparently create inodes with a -1 UID via
idmapping shenanigans.

<shrug>

> > +	tstamp = inode_get_atime(inode);
> > +	xrep_clamp_timestamp(ip, &tstamp);
> > +	inode_set_atime_to_ts(inode, tstamp);
> 
> Meh, I hate these new VFS timestamp access helper..

They're very clunky.

> > +	/* Find the last block before 32G; this is the dir size. */
> > +	error = xfs_iread_extents(sc->tp, sc->ip, XFS_DATA_FORK);
> 
> I think that comments needs to go down to the off asignment and
> xfs_iext_lookup_extent_before call.

Done.

> > +/*
> > + * Fix any irregularities in an inode's size now that we can iterate extent
> > + * maps and access other regular inode data.
> > + */
> > +STATIC void
> > +xrep_inode_size(
> > +	struct xfs_scrub	*sc)
> > +{
> > +	trace_xrep_inode_size(sc);
> > +
> > +	/*
> > +	 * Currently we only support fixing size on extents or btree format
> > +	 * directories.  Files can be any size and sizes for the other inode
> > +	 * special types are fixed by xrep_dinode_size.
> > +	 */
> > +	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
> > +		return;
> 
> I think moving this check to the caller and renaming the function would
> be a bit nicer, especially if we grow more file type specific checks
> in the future.

That's the only one, so I'll rename it to xrep_inode_dir_size and hoist
this check to the caller.

> Otherwise this looks reasonable to me.

Woo, thanks for reading through all this. :)

--D
