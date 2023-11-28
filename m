Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p5LYETZp"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E943D10CA
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 09:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7a6zE5KaXpH1+YrlM51pkM3+yrrjnJQxgBh2U6pcjSs=; b=p5LYETZpvdfDA4Z/Dt49kYSfwA
	6KMOge/Q0L0WPZJtdDobKuxQAUoNz119UmEnJprPBVc4vP0Qokff5mIZuF1KqdW7vfQgZNwRAa91f
	deQvSGp0SH+/w7F189qZQXpb83oTvUBhVS932UYH7mQu9/pZhvy7OJk+98RX6cTtkCDY08/bwTqRf
	REntAhNEoVAOAXOkWFJJH4AD4vs9yNerh3FNnB87WIcvVDfrobrGY7jwY48hVt0uW4hgpTa+9Vs4b
	N0gxP2JwK1ZDI/ccpCnseRXreXODpnz1bECaerrGMGluFErwbihMGQmf9jiiPf+G9S/OcvgXujVck
	VdHqDLUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r81Zb-005tUY-2h;
	Tue, 28 Nov 2023 17:08:35 +0000
Date: Tue, 28 Nov 2023 09:08:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: repair inode records
Message-ID: <ZWYek3C/x7pLqRFj@infradead.org>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927488.2771142.16279946215209833817.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927488.2771142.16279946215209833817.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> @@ -1012,7 +1012,8 @@ enum xfs_dinode_fmt {
>  #define XFS_DFORK_APTR(dip)	\
>  	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
>  #define XFS_DFORK_PTR(dip,w)	\
> -	((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : XFS_DFORK_APTR(dip))
> +	((void *)((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : \
> +					 XFS_DFORK_APTR(dip)))

Not requiring a cast when using XFS_DFORK_PTR is a good thing, but I
think this is the wrong way to do it.  Instead of adding another cast
here we can just change the char * cast in XFS_DFORK_DPTR to a void *
one and rely on the widely used void pointer arithmetics extension in
gcc (and clang).  That'll also need a fixup to use a void instead of
char * cast in xchk_dinode.

And in the long run many of these helpers relly should become inline
functions..

> +	/* no large extent counts without the filesystem feature */
> +	if ((flags2 & XFS_DIFLAG2_NREXT64) && !xfs_has_large_extent_counts(mp))
> +		goto bad;

This is just a missing check and not really related to repair, is it?

> +	/*
> +	 * The only information that needs to be passed between inode scrub and
> +	 * repair is the location of the ondisk metadata if iget fails.  The
> +	 * rest of struct xrep_inode is context data that we need to massage
> +	 * the ondisk inode to the point that iget will work, which means that
> +	 * we don't allocate anything at all if the incore inode is loaded.
> +	 */
> +	if (!imap)
> +		return 0;

I don't really understand why this comment is here, and how it relates
to the imap NULL check.  But as the only caller passes the address of an
on-stack imap I also don't understand why the check is here to start
with.

> +	for (i = 0; i < ni; i++) {
> +		ioff = i << mp->m_sb.sb_inodelog;
> +		dip = xfs_buf_offset(bp, ioff);
> +		agino = be32_to_cpu(dip->di_next_unlinked);
> +
> +		unlinked_ok = magic_ok = crc_ok = false;

I'd split the body of this loop into a separate helper and keep a lot of
the variables local to it.

> +/* Reinitialize things that never change in an inode. */
> +STATIC void
> +xrep_dinode_header(
> +	struct xfs_scrub	*sc,
> +	struct xfs_dinode	*dip)
> +{
> +	trace_xrep_dinode_header(sc, dip);
> +
> +	dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> +	if (!xfs_dinode_good_version(sc->mp, dip->di_version))
> +		dip->di_version = 3;

Can we ever end up here for v4 file systems? Because in that case
the sane default inode version would be 2.

> +
> +/* Turn di_mode into /something/ recognizable. */
> +STATIC void
> +xrep_dinode_mode(
> +	struct xfs_scrub	*sc,
> +	struct xfs_dinode	*dip)
> +{
> +	uint16_t		mode;
> +
> +	trace_xrep_dinode_mode(sc, dip);
> +
> +	mode = be16_to_cpu(dip->di_mode);
> +	if (mode == 0 || xfs_mode_to_ftype(mode) != XFS_DIR3_FT_UNKNOWN)

This is a somewhat odd way to check for a valid mode, but it works, so..

> +	if (xfs_has_reflink(mp) && S_ISREG(mode))
> +		flags2 |= XFS_DIFLAG2_REFLINK;

We set the reflink flag by default, because a later stage will clear
it if there aren't any shared blocks, right?  Maybe add a comment to
avoid any future confusion.

> +STATIC void
> +xrep_dinode_zap_symlink(
> +	struct xfs_scrub	*sc,
> +	struct xfs_dinode	*dip)
> +{
> +	char			*p;
> +
> +	trace_xrep_dinode_zap_symlink(sc, dip);
> +
> +	dip->di_format = XFS_DINODE_FMT_LOCAL;
> +	dip->di_size = cpu_to_be64(1);
> +	p = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
> +	*p = '.';

Hmm, changing a symlink to actually point somewhere seems very
surprising, but making it point to the current directory almost begs
for userspace code to run in loops.

> +}
> +
> +/*
> + * Blow out dir, make it point to the root.  In the future repair will
> + * reconstruct this directory for us.  Note that there's no in-core directory
> + * inode because the sf verifier tripped, so we don't have to worry about the
> + * dentry cache.
> + */

"make it point to root" isn't what I read in the code below.  I parents
it in root I think.

> +/* Make sure we don't have a garbage file size. */
> +STATIC void
> +xrep_dinode_size(
> +	struct xfs_scrub	*sc,
> +	struct xfs_dinode	*dip)
> +{
> +	uint64_t		size;
> +	uint16_t		mode;
> +
> +	trace_xrep_dinode_size(sc, dip);
> +
> +	mode = be16_to_cpu(dip->di_mode);
> +	size = be64_to_cpu(dip->di_size);

Any reason to not simplify initialize the variables at declaration
time?  (Same for a while bunch of other functions / variables)

> +	if (xfs_has_reflink(sc->mp)) {
> +		; /* data fork blockcount can exceed physical storage */

... because we would be reflinking the same blocks into the same inode
at different offsets over and over again ... ?

Still, shouldn't we limit the condition to xfs_is_reflink_inode?

> +/* Check for invalid uid/gid/prid. */
> +STATIC void
> +xrep_inode_ids(
> +	struct xfs_scrub	*sc)
> +{
> +	bool			dirty = false;
> +
> +	trace_xrep_inode_ids(sc);
> +
> +	if (i_uid_read(VFS_I(sc->ip)) == -1U) {

What is invalid about all-F uid/gid/projid?

> +	tstamp = inode_get_atime(inode);
> +	xrep_clamp_timestamp(ip, &tstamp);
> +	inode_set_atime_to_ts(inode, tstamp);

Meh, I hate these new VFS timestamp access helper..

> +	/* Find the last block before 32G; this is the dir size. */
> +	error = xfs_iread_extents(sc->tp, sc->ip, XFS_DATA_FORK);

I think that comments needs to go down to the off asignment and
xfs_iext_lookup_extent_before call.

> +/*
> + * Fix any irregularities in an inode's size now that we can iterate extent
> + * maps and access other regular inode data.
> + */
> +STATIC void
> +xrep_inode_size(
> +	struct xfs_scrub	*sc)
> +{
> +	trace_xrep_inode_size(sc);
> +
> +	/*
> +	 * Currently we only support fixing size on extents or btree format
> +	 * directories.  Files can be any size and sizes for the other inode
> +	 * special types are fixed by xrep_dinode_size.
> +	 */
> +	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
> +		return;

I think moving this check to the caller and renaming the function would
be a bit nicer, especially if we grow more file type specific checks
in the future.

Otherwise this looks reasonable to me.
