Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24298 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750723AbdGYFmV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2017 01:42:21 -0400
Date: Mon, 24 Jul 2017 22:42:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/22] xfs: scrub the backup superblocks
Message-ID: <20170725054216.GB4369@magnolia>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061194700.14732.436243943528759418.stgit@magnolia>
 <20170725040500.GI17762@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170725040500.GI17762@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 25, 2017 at 02:05:00PM +1000, Dave Chinner wrote:
> On Thu, Jul 20, 2017 at 09:39:07PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Ensure that the geometry presented in the backup superblocks matches
> > the primary superblock so that repair can recover the filesystem if
> > that primary gets corrupted.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ....
> > +int
> > +xfs_scrub_setup_ag_header(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_inode		*ip)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +
> > +	if (sc->sm->sm_agno >= mp->m_sb.sb_agcount ||
> > +	    sc->sm->sm_ino || sc->sm->sm_gen)
> > +		return -EINVAL;
> > +	return xfs_scrub_setup_fs(sc, ip);
> > +}
> 
> Could we create a superblock buffer here that contains just the bits
> we expect the secondary superblocks to have up to date (everything
> else should be zero!), and then just use a memcmp() on the raw
> secondary superblock buffer?
> 
> If there is a difference, then we can dig further to find what's
> wrong?

Sure.

> > +/* Superblock */
> > +
> > +#define XFS_SCRUB_SB_CHECK(fs_ok) \
> > +	XFS_SCRUB_CHECK(sc, bp, "superblock", fs_ok)
> > +#define XFS_SCRUB_SB_PREEN(fs_ok) \
> > +	XFS_SCRUB_PREEN(sc, bp, "superblock", fs_ok)
> 
> I don't understand from reading the code why some fields are checked
> and others are preened. A comment explaining this would be helpful.

Ok.

/* 
 * Superblock fields that are set at mkfs time are checked.
 * Fields in super block 0 that can be updated after mkfs and
 * not copied to the backup superblocks are preened.
 */

> 
> > +#define XFS_SCRUB_SB_OP_ERROR_GOTO(label) \
> > +	XFS_SCRUB_OP_ERROR_GOTO(sc, agno, 0, "superblock", &error, out)
> > +/* Scrub the filesystem superblock. */
> > +int
> > +xfs_scrub_superblock(
> > +	struct xfs_scrub_context	*sc)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_buf			*bp;
> > +	struct xfs_sb			sb;
> > +	xfs_agnumber_t			agno;
> > +	uint32_t			v2_ok;
> > +	int				error;
> > +
> > +	agno = sc->sm->sm_agno;
> > +
> > +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > +		  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> > +		  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
> > +	if (error) {
> > +		trace_xfs_scrub_block_error(mp, agno, XFS_SB_BLOCK(mp),
> > +				"superblock", "error != 0", __func__, __LINE__);
> > +		error = 0;
> > +		sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
> > +		goto out;
> > +	}
> > +
> > +	/*
> > +	 * The in-core sb is a more up-to-date copy of AG 0's sb,
> > +	 * so there's no point in comparing the two.
> > +	 */
> > +	if (agno == 0)
> > +		goto out;
> 
> Check this before reading the sb buffer?
> 
> > +	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
> 
> Ok, there's a problem here - the on-disk superblock needs all unused
> fields, empty space and feature bit conditional fields to be zero on
> disk. Unused and feature dependent fields aren't necessarily zero in
> memory, so we're not really scrubbing the on-disk superblock here.

Ok.

> ALso, all the space between the end of the defined superblock and
> the end of the superblock sector must be zero, so scrubbing needs to
> verify that, too.

Ok.

> 
> > +
> > +	/* Verify the geometries match. */
> > +#define XFS_SCRUB_SB_FIELD(fn) \
> > +		XFS_SCRUB_SB_CHECK(sb.sb_##fn == mp->m_sb.sb_##fn)
> > +#define XFS_PREEN_SB_FIELD(fn) \
> > +		XFS_SCRUB_SB_PREEN(sb.sb_##fn == mp->m_sb.sb_##fn)
> > +	XFS_SCRUB_SB_FIELD(blocksize);
> > +	XFS_SCRUB_SB_FIELD(dblocks);
> > +	XFS_SCRUB_SB_FIELD(rblocks);
> > +	XFS_SCRUB_SB_FIELD(rextents);
> > +	XFS_SCRUB_SB_PREEN(uuid_equal(&sb.sb_uuid, &mp->m_sb.sb_uuid));
> 
> Isn't this dependent on the xfs_sb_version_hasmetauuid() feature?
> Regardless, I think this should be part of the checks done based on
> that feature bit below...

I don't think it's dependent on hasmetauuid.  sb_uuid is the admin-set
uuid, which ought to be the same on all supers, right?  So that if we
set a new uuid, break sb 0, and have repair fix the fs, the uuid won't
suddenly shift.

Versus sb_meta_uuid, which if hasmetauuid /has/ to match on all supers.

> ....
> 
> > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > +		XFS_SCRUB_SB_CHECK(!xfs_sb_has_compat_feature(&sb,
> > +				XFS_SB_FEAT_COMPAT_UNKNOWN));
> > +		XFS_SCRUB_SB_CHECK(!xfs_sb_has_ro_compat_feature(&sb,
> > +				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> > +		XFS_SCRUB_SB_CHECK(!xfs_sb_has_incompat_feature(&sb,
> > +				XFS_SB_FEAT_INCOMPAT_UNKNOWN));
> > +		XFS_SCRUB_SB_CHECK(!xfs_sb_has_incompat_log_feature(&sb,
> > +				XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN));
> > +		XFS_SCRUB_SB_FIELD(spino_align);
> > +		XFS_PREEN_SB_FIELD(pquotino);
> > +	}
> 
> else all these fields should be zero on disk.

Ok.

> > +	if (xfs_sb_version_hasmetauuid(&mp->m_sb)) {
> > +		XFS_SCRUB_SB_CHECK(uuid_equal(&sb.sb_meta_uuid,
> > +					&mp->m_sb.sb_meta_uuid));
> > +		XFS_SCRUB_SB_CHECK(uuid_equal(&sb.sb_uuid,
> > +					&mp->m_sb.sb_uuid));
> > +	} else
> > +		XFS_SCRUB_SB_CHECK(uuid_equal(&sb.sb_uuid,
> > +					&mp->m_sb.sb_meta_uuid));
> 
> That's checking in-memory state is valid, not that the on-disk
> sb_meta_uuid field is zero for this case.

Eeyuck, that needs some TLC indeed.

> > +#undef XFS_SCRUB_SB_FIELD
> > +
> > +#define XFS_SCRUB_SB_FEAT(fn) \
> > +		XFS_SCRUB_SB_CHECK(xfs_sb_version_has##fn(&sb) == \
> > +		xfs_sb_version_has##fn(&mp->m_sb))
> > +	XFS_SCRUB_SB_FEAT(align);
> > +	XFS_SCRUB_SB_FEAT(dalign);
> > +	XFS_SCRUB_SB_FEAT(logv2);
> > +	XFS_SCRUB_SB_FEAT(extflgbit);
> > +	XFS_SCRUB_SB_FEAT(sector);
> > +	XFS_SCRUB_SB_FEAT(asciici);
> > +	XFS_SCRUB_SB_FEAT(morebits);
> > +	XFS_SCRUB_SB_FEAT(lazysbcount);
> > +	XFS_SCRUB_SB_FEAT(crc);
> > +	XFS_SCRUB_SB_FEAT(_pquotino);
> > +	XFS_SCRUB_SB_FEAT(ftype);
> > +	XFS_SCRUB_SB_FEAT(finobt);
> > +	XFS_SCRUB_SB_FEAT(sparseinodes);
> > +	XFS_SCRUB_SB_FEAT(metauuid);
> > +	XFS_SCRUB_SB_FEAT(rmapbt);
> > +	XFS_SCRUB_SB_FEAT(reflink);
> > +#undef XFS_SCRUB_SB_FEAT
> 
> Do we need bit by bit feature checks? It's trivial to look up the
> mismatched bits from just the raw values....

We could forgo this.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
