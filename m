Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30693 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753006AbdJPWIy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 18:08:54 -0400
Date: Mon, 16 Oct 2017 15:08:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 21/30] xfs: scrub inodes
Message-ID: <20171016220850.GO4703@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777258004.1724.14107466871314594061.stgit@magnolia>
 <20171012223250.GN7122@magnolia>
 <20171016031647.GX3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016031647.GX3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 16, 2017 at 02:16:47PM +1100, Dave Chinner wrote:
> On Thu, Oct 12, 2017 at 03:32:50PM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 11, 2017 at 06:43:00PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Scrub the fields within an inode.
> 
> .....
> 
> > > +
> > > +/*
> > > + * Given an inode and the scrub control structure, grab either the
> > > + * inode referenced in the control structure or the inode passed in.
> > > + * The inode is not locked.
> > > + */
> > > +int
> > > +xfs_scrub_get_inode(
> > > +	struct xfs_scrub_context	*sc,
> > > +	struct xfs_inode		*ip_in)
> > > +{
> > > +	struct xfs_mount		*mp = sc->mp;
> > > +	struct xfs_inode		*ip = NULL;
> > > +	int				error;
> > > +
> > > +	/*
> > > +	 * If userspace passed us an AG number or a generation number
> > > +	 * without an inode number, they haven't got a clue so bail out
> > > +	 * immediately.
> > > +	 */
> > > +	if (sc->sm->sm_agno || (sc->sm->sm_gen && !sc->sm->sm_ino))
> > > +		return -EINVAL;
> > > +
> > > +	/* We want to scan the inode we already had opened. */
> > > +	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino) {
> > > +		sc->ip = ip_in;
> > > +		return 0;
> > > +	}
> > > +
> > > +	/* Look up the inode, see if the generation number matches. */
> > > +	if (xfs_internal_inum(mp, sc->sm->sm_ino))
> > > +		return -ENOENT;
> > > +	error = xfs_iget(mp, NULL, sc->sm->sm_ino,
> > > +			XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE, 0, &ip);
> > > +	if (error == -ENOENT || error == -EINVAL) {
> > > +		/* inode doesn't exist... */
> > > +		return -ENOENT;
> > > +	} else if (error) {
> > > +		trace_xfs_scrub_op_error(sc,
> > > +				XFS_INO_TO_AGNO(mp, sc->sm->sm_ino),
> > > +				XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),
> > > +				error, __return_address);
> > > +		return error;
> > > +	}
> > > +	if (VFS_I(ip)->i_generation != sc->sm->sm_gen) {
> > > +		iput(VFS_I(ip));
> > > +		return -ENOENT;
> > > +	}
> > > +
> > > +	sc->ip = ip;
> > > +	return 0;
> > > +}
> 
> Much nicer with the way everything is clearly spelled out :P
> 
> > > +/* Inode core */
> > > +
> > > +/*
> > > + * di_extsize hint validation is somewhat cumbersome. Rules are:
> > > + *
> > > + * 1. extent size hint is only valid for directories and regular files
> > > + * 2. DIFLAG_EXTSIZE is only valid for regular files
> > > + * 3. DIFLAG_EXTSZINHERIT is only valid for directories.
> > > + * 4. extsize hint of 0 turns off hints, clears inode flags.
> > > + * 5. either flag must be set if extsize != 0
> > > + * 6. Extent size must be a multiple of the appropriate block size.
> > > + * 7. extent size hint cannot be longer than maximum extent length
> > > + * 8. for non-realtime files, the extent size hint must be limited
> > > + *    to half the AG size to avoid alignment extending the extent
> > > + *    beyond the limits of the AG.
> > > + */
> > > +STATIC void
> > > +xfs_scrub_inode_extsize(
> > > +	struct xfs_scrub_context	*sc,
> > > +	struct xfs_buf			*bp,
> > > +	struct xfs_dinode		*dip,
> > > +	xfs_ino_t			ino,
> > > +	uint16_t			mode,
> > > +	uint16_t			flags)
> > > +{
> > > +	struct xfs_mount		*mp = sc->mp;
> > > +	bool				rt_flag;
> > > +	bool				hint_flag;
> > > +	bool				inherit_flag;
> > > +	uint32_t			extsize;
> > > +	uint32_t			extsize_bytes;
> > > +	uint32_t			blocksize_bytes;
> > > +
> > > +	rt_flag = (flags & XFS_DIFLAG_REALTIME);
> > > +	hint_flag = (flags & XFS_DIFLAG_EXTSIZE);
> > > +	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
> > > +	extsize = be32_to_cpu(dip->di_extsize);
> > > +	extsize_bytes = XFS_FSB_TO_B(sc->mp, extsize);
> > > +
> > > +	if (rt_flag)
> > > +		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> > > +	else
> > > +		blocksize_bytes = mp->m_sb.sb_blocksize;
> > > +
> > > +	if ((hint_flag || inherit_flag) && (!S_ISDIR(mode) && !S_ISREG(mode)))
> 
> Logic is a correct but reads funny:
> 
> 	if ((hint_flag || inherit_flag) &&
> 	    !(S_ISREG(mode) || S_ISDIR(mode)))

Ok.  Fixed this and the cowextsize.

> > > +/*
> > > + * di_cowextsize hint validation is somewhat cumbersome. Rules are:
> > > + *
> > > + * 1. flag requires reflink feature
> > > + * 2. cow extent size hint is only valid for directories and regular files
> > > + * 3. cow extsize hint of 0 turns off hints, clears inode flags.
> > > + * 4. either flag must be set if cow extsize != 0
> > > + * 5. flag cannot be set for rt files
> > > + * 6. Extent size must be a multiple of the appropriate block size.
> > > + * 7. extent size hint cannot be longer than maximum extent length
> > > + * 8. the extent size hint must be limited
> > > + *    to half the AG size to avoid alignment extending the extent
> > > + *    beyond the limits of the AG.
> > > + */
> 
> Perhaps this comment doesn't need duplicating for a 3rd time. Maybe
> for both di_extsize and di_cowextsize just say:
> 
> /*
>  * Extent size hints have explicit rules. They are documented at
>  * xfs_ioctl_setattr_check_extsize() - these functions need to be
>  * kept in sync with each other.
>  */

Ok.  I've also amended the comment at xfs_ioctl_setattr_check_extsize to
remind people to keep the scrub version in sync.

> > > +STATIC void
> > > +xfs_scrub_inode_cowextsize(
> > > +	struct xfs_scrub_context	*sc,
> > > +	struct xfs_buf			*bp,
> > > +	struct xfs_dinode		*dip,
> > > +	xfs_ino_t			ino,
> > > +	uint16_t			mode,
> > > +	uint16_t			flags,
> > > +	uint64_t			flags2)
> > > +{
> > > +	struct xfs_mount		*mp = sc->mp;
> > > +	bool				rt_flag;
> > > +	bool				hint_flag;
> > > +	uint32_t			extsize;
> > > +	uint32_t			extsize_bytes;
> > > +
> > > +	rt_flag = (flags & XFS_DIFLAG_REALTIME);
> > > +	hint_flag = (flags2 & XFS_DIFLAG2_COWEXTSIZE);
> > > +	extsize = be32_to_cpu(dip->di_extsize);
> > 
> > Doh, this ought to be extsize = be32_to_cpu(dip->di_cowextsize); will fix.
> 
> Yup, with that fix in place all the spurious inode warnings I was
> getting went away.
> 
> > > +/* Map and read a raw inode. */
> > > +STATIC int
> > > +xfs_scrub_inode_map_raw(
> > > +	struct xfs_scrub_context	*sc,
> > > +	xfs_ino_t			ino,
> > > +	struct xfs_buf			**bpp,
> > > +	struct xfs_dinode		**dipp)
> > > +{
> > > +	struct xfs_imap			imap;
> > > +	struct xfs_mount		*mp = sc->mp;
> > > +	struct xfs_buf			*bp;
> > > +	struct xfs_dinode		*dip;
> > > +	int				error;
> > > +
> > > +	error = xfs_imap(mp, sc->tp, ino, &imap, XFS_IGET_UNTRUSTED);
> > > +	if (error == -EINVAL) {
> > > +		/*
> > > +		 * Inode could have gotten deleted out from under us;
> > > +		 * just forget about it.
> > > +		 */
> > > +		error = -ENOENT;
> > > +		goto out;
> > > +	}
> > > +	if (!xfs_scrub_process_error(sc, XFS_INO_TO_AGNO(mp, ino),
> > > +			XFS_INO_TO_AGBNO(mp, ino), &error))
> > > +		goto out;
> > > +
> > > +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > > +			imap.im_blkno, imap.im_len, XBF_UNMAPPED, &bp,
> > > +			NULL);
> > > +	if (!xfs_scrub_process_error(sc, XFS_INO_TO_AGNO(mp, ino),
> > > +			XFS_INO_TO_AGBNO(mp, ino), &error))
> > > +		goto out;
> > > +
> > > +	/* Is this really an inode? */
> > > +	bp->b_ops = &xfs_inode_buf_ops;
> 
> A comment here on why we skip the read verifier when pulling in the
> inode buffer would be nice.

/*
 * Is this really an inode?  We disabled verifiers in the above
 * xfs_trans_read_buf call because the inode buffer verifier
 * fails on /any/ inode record in the inode cluster with a bad
 * magic or version number, not just the one that we're
 * checking.  Therefore, grab the buffer unconditionally, attach
 * the inode verifiers by hand, and run the inode verifier only
 * on the one inode we want.
 */

--D

> 
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
