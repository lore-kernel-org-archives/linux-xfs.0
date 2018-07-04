Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58600 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752049AbeGDAQR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Jul 2018 20:16:17 -0400
Date: Tue, 3 Jul 2018 17:16:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/21] xfs: repair inode records
Message-ID: <20180704001612.GZ32415@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986829144.3155.13577483407162701849.stgit@magnolia>
 <20180703061718.GJ2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703061718.GJ2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 03, 2018 at 04:17:18PM +1000, Dave Chinner wrote:
> On Sun, Jun 24, 2018 at 12:24:51PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Try to reinitialize corrupt inodes, or clear the reflink flag
> > if it's not needed.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A comment somewhere that this is only attmepting to repair inodes
> that have failed verifier checks on read would be good.

There are a few comments in the callers, e.g.

"Repair all the things that the inode verifiers care about"

"Fix everything xfs_dinode_verify cares about."

"Make sure we can pass the inode buffer verifier."

Hmm, I think maybe you meant that I need to make it more obvious which
functions exist to make the verifiers happy (and so there won't be any
in-core inodes while they run) vs. which ones fix irregularities that
aren't caught as a condition for setting up in-core inodes?

xrep_inode_unchecked_* are the ones that run on in-core inodes; the rest
run on inodes so damaged they can't be _iget'd.

> ......
> > +/* Make sure this buffer can pass the inode buffer verifier. */
> > +STATIC void
> > +xfs_repair_inode_buf(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_buf			*bp)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_trans		*tp = sc->tp;
> > +	struct xfs_dinode		*dip;
> > +	xfs_agnumber_t			agno;
> > +	xfs_agino_t			agino;
> > +	int				ioff;
> > +	int				i;
> > +	int				ni;
> > +	int				di_ok;
> > +	bool				unlinked_ok;
> > +
> > +	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
> > +	agno = xfs_daddr_to_agno(mp, XFS_BUF_ADDR(bp));
> > +	for (i = 0; i < ni; i++) {
> > +		ioff = i << mp->m_sb.sb_inodelog;
> > +		dip = xfs_buf_offset(bp, ioff);
> > +		agino = be32_to_cpu(dip->di_next_unlinked);
> > +		unlinked_ok = (agino == NULLAGINO ||
> > +			       xfs_verify_agino(sc->mp, agno, agino));
> > +		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
> > +			xfs_dinode_good_version(mp, dip->di_version);
> > +		if (di_ok && unlinked_ok)
> > +			continue;
> 
> Readability woul dbe better with:
> 
> 		unlinked_ok = false;
> 		if (agino == NULLAGINO || xfs_verify_agino(sc->mp, agno, agino))
> 			unlinked_ok = true;
> 
> 		di_ok = false;
> 		if (dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
> 		    xfs_dinode_good_version(mp, dip->di_version))
> 			di_ok = true;
> 
> 		if (di_ok && unlinked_ok)
> 			continue;
> 

Ok.

> Also, is there a need to check the inode CRC here?

We already know the inode core is bad, so why not just reset it?

> > +		dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> > +		dip->di_version = 3;
> > +		if (!unlinked_ok)
> > +			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
> > +		xfs_dinode_calc_crc(mp, dip);
> > +		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
> > +		xfs_trans_log_buf(tp, bp, ioff, ioff + sizeof(*dip) - 1);
> 
> Hmmmm. how does this interact with other transactions in repair that
> might have logged changes to the same in-core inode? If it was just
> changing the unlinked pointer, then that would be ok, but
> magic/version are overwritten by the inode item recovery...

There shouldn't be an in-core inode; this function should only get
called if we failed to _iget the inode, which implies that nobody else
has an in-core inode.

> 
> > +/* Reinitialize things that never change in an inode. */
> > +STATIC void
> > +xfs_repair_inode_header(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_dinode		*dip)
> > +{
> > +	dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> > +	if (!xfs_dinode_good_version(sc->mp, dip->di_version))
> > +		dip->di_version = 3;
> > +	dip->di_ino = cpu_to_be64(sc->sm->sm_ino);
> > +	uuid_copy(&dip->di_uuid, &sc->mp->m_sb.sb_meta_uuid);
> > +	dip->di_gen = cpu_to_be32(sc->sm->sm_gen);
> > +}
> > +
> > +/*
> > + * Turn di_mode into /something/ recognizable.
> > + *
> > + * XXX: Ideally we'd try to read data block 0 to see if it's a directory.
> > + */
> > +STATIC void
> > +xfs_repair_inode_mode(
> > +	struct xfs_dinode	*dip)
> > +{
> > +	uint16_t		mode;
> > +
> > +	mode = be16_to_cpu(dip->di_mode);
> > +	if (mode == 0 || xfs_mode_to_ftype(mode) != XFS_DIR3_FT_UNKNOWN)
> > +		return;
> > +
> > +	/* bad mode, so we set it to a file that only root can read */
> > +	mode = S_IFREG;
> > +	dip->di_mode = cpu_to_be16(mode);
> > +	dip->di_uid = 0;
> > +	dip->di_gid = 0;
> 
> Not sure that's a good idea - if the mode is bad I don't think we
> should expose it to anyone. Perhaps we need an orphan type

Agreed.

> > +}
> > +
> > +/* Fix any conflicting flags that the verifiers complain about. */
> > +STATIC void
> > +xfs_repair_inode_flags(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_dinode		*dip)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	uint64_t			flags2;
> > +	uint16_t			mode;
> > +	uint16_t			flags;
> > +
> > +	mode = be16_to_cpu(dip->di_mode);
> > +	flags = be16_to_cpu(dip->di_flags);
> > +	flags2 = be64_to_cpu(dip->di_flags2);
> > +
> > +	if (xfs_sb_version_hasreflink(&mp->m_sb) && S_ISREG(mode))
> > +		flags2 |= XFS_DIFLAG2_REFLINK;
> > +	else
> > +		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
> > +	if (flags & XFS_DIFLAG_REALTIME)
> > +		flags2 &= ~XFS_DIFLAG2_REFLINK;
> > +	if (flags2 & XFS_DIFLAG2_REFLINK)
> > +		flags2 &= ~XFS_DIFLAG2_DAX;
> > +	dip->di_flags = cpu_to_be16(flags);
> > +	dip->di_flags2 = cpu_to_be64(flags2);
> > +}
> > +
> > +/* Make sure we don't have a garbage file size. */
> > +STATIC void
> > +xfs_repair_inode_size(
> > +	struct xfs_dinode	*dip)
> > +{
> > +	uint64_t		size;
> > +	uint16_t		mode;
> > +
> > +	mode = be16_to_cpu(dip->di_mode);
> > +	size = be64_to_cpu(dip->di_size);
> > +	switch (mode & S_IFMT) {
> > +	case S_IFIFO:
> > +	case S_IFCHR:
> > +	case S_IFBLK:
> > +	case S_IFSOCK:
> > +		/* di_size can't be nonzero for special files */
> > +		dip->di_size = 0;
> > +		break;
> > +	case S_IFREG:
> > +		/* Regular files can't be larger than 2^63-1 bytes. */
> > +		dip->di_size = cpu_to_be64(size & ~(1ULL << 63));
> > +		break;
> > +	case S_IFLNK:
> > +		/* Catch over- or under-sized symlinks. */
> > +		if (size > XFS_SYMLINK_MAXLEN)
> > +			dip->di_size = cpu_to_be64(XFS_SYMLINK_MAXLEN);
> > +		else if (size == 0)
> > +			dip->di_size = cpu_to_be64(1);
> 
> Not sure this is valid - if the inode is in extent format then a
> size of 1 is invalid and means the symlink will point to the
> first byte in the data fork, and that could be anything....

I picked these wonky looking formats so that we'd always trigger the
higher level repair functions to have a look at the link/dir without
blowing up elsewhere in the code if we tried to use them.  Not that we
can do much for broken symlinks, but directories could be rebuilt.

But maybe directories should simply be reset to an empty inline
directory, and eventually grow an iflag that will always trigger
directory reconstruction (when parent pointers become a thing).

> > +		break;
> > +	case S_IFDIR:
> > +		/* Directories can't have a size larger than 32G. */
> > +		if (size > XFS_DIR2_SPACE_SIZE)
> > +			dip->di_size = cpu_to_be64(XFS_DIR2_SPACE_SIZE);
> > +		else if (size == 0)
> > +			dip->di_size = cpu_to_be64(1);
> 
> Similar. A size of 1 is not valid for a directory.
> 
> > +		break;
> > +	}
> > +}
> .....
> > +
> > +/* Inode didn't pass verifiers, so fix the raw buffer and retry iget. */
> > +STATIC int
> > +xfs_repair_inode_core(
> > +	struct xfs_scrub_context	*sc)
> > +{
> > +	struct xfs_imap			imap;
> > +	struct xfs_buf			*bp;
> > +	struct xfs_dinode		*dip;
> > +	xfs_ino_t			ino;
> > +	int				error;
> > +
> > +	/* Map & read inode. */
> > +	ino = sc->sm->sm_ino;
> > +	error = xfs_imap(sc->mp, sc->tp, ino, &imap, XFS_IGET_UNTRUSTED);
> > +	if (error)
> > +		return error;
> > +
> > +	error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
> > +			imap.im_blkno, imap.im_len, XBF_UNMAPPED, &bp, NULL);
> > +	if (error)
> > +		return error;
> 
> I'd like to see this check the inode isn't in-core after we've read
> and locked the inode buffer, just to ensure we haven't raced with
> another access.

Ok.

> > +
> > +	/* Make sure we can pass the inode buffer verifier. */
> > +	xfs_repair_inode_buf(sc, bp);
> > +	bp->b_ops = &xfs_inode_buf_ops;
> > +
> > +	/* Fix everything the verifier will complain about. */
> > +	dip = xfs_buf_offset(bp, imap.im_boffset);
> > +	xfs_repair_inode_header(sc, dip);
> > +	xfs_repair_inode_mode(dip);
> > +	xfs_repair_inode_flags(sc, dip);
> > +	xfs_repair_inode_size(dip);
> > +	xfs_repair_inode_extsize_hints(sc, dip);
> 
> what if the inode failed the fork verifiers rather than the dinode
> verifier?

That's coming up in the next patch.  Want me to put in an XXX comment to
that effect?

> > + * Fix problems that the verifiers don't care about.  In general these are
> > + * errors that don't cause problems elsewhere in the kernel that we can easily
> > + * detect, so we don't check them all that rigorously.
> > + */
> > +
> > +/* Make sure block and extent counts are ok. */
> > +STATIC int
> > +xfs_repair_inode_unchecked_blockcounts(
> > +	struct xfs_scrub_context	*sc)
> > +{
> > +	xfs_filblks_t			count;
> > +	xfs_filblks_t			acount;
> > +	xfs_extnum_t			nextents;
> > +	int				error;
> > +
> > +	/* di_nblocks/di_nextents/di_anextents don't match up? */
> > +	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
> > +			&nextents, &count);
> > +	if (error)
> > +		return error;
> > +	sc->ip->i_d.di_nextents = nextents;
> > +
> > +	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
> > +			&nextents, &acount);
> > +	if (error)
> > +		return error;
> > +	sc->ip->i_d.di_anextents = nextents;
> 
> Should the returned extent/block counts be validity checked?

Er... yes.  Good catch. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
