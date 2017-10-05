Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:52134 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751253AbdJEC4X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2017 22:56:23 -0400
Date: Thu, 5 Oct 2017 13:56:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/25] xfs: scrub rmap btrees
Message-ID: <20171005025620.GK3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706333767.19351.13637260621369926859.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150706333767.19351.13637260621369926859.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 01:42:17PM -0700, Darrick J. Wong wrote:
> +/* Scrub an rmapbt record. */
> +STATIC int
> +xfs_scrub_rmapbt_helper(
> +	struct xfs_scrub_btree		*bs,
> +	union xfs_btree_rec		*rec)
> +{
> +	struct xfs_mount		*mp = bs->cur->bc_mp;
> +	struct xfs_agf			*agf;
> +	struct xfs_rmap_irec		irec;
> +	unsigned long long		rec_end;
> +	xfs_agblock_t			eoag;
> +	bool				non_inode;
> +	bool				is_unwritten;
> +	bool				is_bmbt;
> +	bool				is_attr;
> +	int				error;
> +
> +	error = xfs_rmap_btrec_to_irec(rec, &irec);
> +	if (!xfs_scrub_btree_op_ok(bs->sc, bs->cur, 0, &error))
> +		goto out;

This got me again. Again I was thinking that this code threw
away the error from xfs_rmap_btrec_to_irec(). Could we consider
renaming "op_ok" to "process_error" or something like that so
it's clearer that it's doing some kind of checking on the error
we just got back?

> +
> +	/* Check extent. */
> +	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
> +	eoag = be32_to_cpu(agf->agf_length);
> +	rec_end = (unsigned long long)irec.rm_startblock + irec.rm_blockcount;
> +
> +	if (irec.rm_startblock >= mp->m_sb.sb_agblocks ||
> +	    irec.rm_startblock >= eoag ||
> +	    irec.rm_blockcount == 0 ||
> +	    rec_end > mp->m_sb.sb_agblocks ||
> +	    rec_end > eoag)
> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);

Broken Record (tm).

> +	/* Check flags. */
> +	non_inode = XFS_RMAP_NON_INODE_OWNER(irec.rm_owner);
> +	is_bmbt = irec.rm_flags & XFS_RMAP_BMBT_BLOCK;
> +	is_attr = irec.rm_flags & XFS_RMAP_ATTR_FORK;
> +	is_unwritten = irec.rm_flags & XFS_RMAP_UNWRITTEN;
> +
> +	if (is_bmbt && irec.rm_offset != 0)
> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +
> +	if (non_inode && irec.rm_offset != 0)
> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +
> +	if (is_unwritten && (is_bmbt || non_inode || is_attr))
> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +
> +	if (non_inode && (is_bmbt || is_unwritten || is_attr))
> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +
> +	if (!non_inode) {
> +		xfs_agnumber_t	agno = XFS_INO_TO_AGNO(mp, irec.rm_owner);
> +		xfs_agino_t	agino = XFS_INO_TO_AGINO(mp, irec.rm_owner);
> +		xfs_agblock_t	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
> +
> +		/* Owner inode within an AG? */
> +		if (agno >= mp->m_sb.sb_agcount ||
> +		    agbno >= mp->m_sb.sb_agblocks)
> +			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +
> +		/* Owner inode within the FS? */
> +		if (XFS_AGB_TO_DADDR(mp, agno, agbno) >=
> +		    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks))
> +			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);

These two checks probably also should be libxfs functionality.
We've got similar checks strewn all over the place (e.g. valid_bno()
in xfs_db, verify_aginum/verify_inum/verify_agbno/verify_dfsbno
in repair, etc.

It would be good to get all these sorts of basic type checks
centralised and used consistenly by all the code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
