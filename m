Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7855 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751201AbdJECIP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2017 22:08:15 -0400
Date: Thu, 5 Oct 2017 13:08:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/25] xfs: scrub inode btrees
Message-ID: <20171005020810.GJ3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706333138.19351.1481631767118687082.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150706333138.19351.1481631767118687082.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 01:42:11PM -0700, Darrick J. Wong wrote:
> +/*
> + * Set us up to scrub inode btrees.
> + * If we detect a discrepancy between the inobt and the inode,
> + * try again after forcing logged inode cores out to disk.
> + */
> +int
> +xfs_scrub_setup_ag_iallocbt(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_inode		*ip)
> +{
> +	return xfs_scrub_setup_ag_btree(sc, ip, sc->try_harder);
> +}
> +
> +/* Inode btree scrubber. */
> +
> +/* Is this chunk worth checking? */
> +STATIC bool
> +xfs_scrub_iallocbt_chunk(
> +	struct xfs_scrub_btree		*bs,
> +	struct xfs_inobt_rec_incore	*irec,
> +	xfs_agino_t			agino,
> +	xfs_extlen_t			len)
> +{
> +	struct xfs_mount		*mp = bs->cur->bc_mp;
> +	struct xfs_agf			*agf;
> +	unsigned long long		rec_end;
> +	xfs_agblock_t			eoag;
> +	xfs_agblock_t			bno;
> +
> +	agf = XFS_BUF_TO_AGF(bs->sc->sa.agf_bp);
> +	eoag = be32_to_cpu(agf->agf_length);

Probably should use the AGI for this.

> +	bno = XFS_AGINO_TO_AGBNO(mp, agino);
> +	rec_end = (unsigned long long)bno + len;
> +
> +	if (bno >= mp->m_sb.sb_agblocks || bno >= eoag ||
> +	    rec_end > mp->m_sb.sb_agblocks || rec_end > eoag) {

Same comment as last patch.

> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +		return false;
> +	}
> +
> +	return true;
> +}

I note there is no check on the length passed in for the inode
chunk - should that be verified?

> +
> +/* Count the number of free inodes. */
> +static unsigned int
> +xfs_scrub_iallocbt_freecount(
> +	xfs_inofree_t			freemask)
> +{
> +	int				bits = XFS_INODES_PER_CHUNK;
> +	unsigned int			ret = 0;
> +
> +	while (bits--) {
> +		if (freemask & 1)
> +			ret++;
> +		freemask >>= 1;
> +	}


Seems a little cumbersome. Perhaps a loop using xfs_next_bit()
might be a bit faster, something like:

	nextbit = xfs_next_bit(&freemask, 1, 0); 
	while (nextbit != -1) {
		ret++;
		nextbit = xfs_next_bit(&freemask, 1, nextbit + 1);
	}


> +/* Check a particular inode with ir_free. */
> +STATIC int
> +xfs_scrub_iallocbt_check_cluster_freemask(
> +	struct xfs_scrub_btree		*bs,
> +	xfs_ino_t			fsino,
> +	xfs_agino_t			chunkino,
> +	xfs_agino_t			clusterino,
> +	struct xfs_inobt_rec_incore	*irec,
> +	struct xfs_buf			*bp)
> +{
> +	struct xfs_dinode		*dip;
> +	struct xfs_mount		*mp = bs->cur->bc_mp;
> +	bool				freemask_ok;
> +	bool				inuse;
> +	int				error;
> +
> +	dip = xfs_buf_offset(bp, clusterino * mp->m_sb.sb_inodesize);
> +	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC ||
> +	    (dip->di_version >= 3 &&
> +	     be64_to_cpu(dip->di_ino) != fsino + clusterino)) {
> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +		goto out;
> +	}
> +
> +	freemask_ok = !!(irec->ir_free & XFS_INOBT_MASK(chunkino + clusterino));

No need for !!(...) for a bool type - the compiler will squash it
down to 0/1 autmoatically.

> +	error = xfs_icache_inode_is_allocated(mp, bs->cur->bc_tp,
> +			fsino + clusterino, &inuse);
> +	if (error == -ENODATA) {
> +		/* Not cached, just read the disk buffer */

I think that is wrong. xfs_icache_inode_is_allocated() returns
-ENOENT if the inode is not in cache....

> +		freemask_ok ^= !!(dip->di_mode);
> +		if (!bs->sc->try_harder && !freemask_ok)
> +			return -EDEADLOCK;
> +	} else if (error < 0) {
> +		/* Inode is only half assembled, don't bother. */
> +		freemask_ok = true;

Or we had an IO error looking it up. i.e. -EAGAIN is the "half
assembled" state (i.e. in the XFS_INEW state) or the half
*disasembled* state (i.e. XFS_IRECLAIMABLE), anything
else is an error...

> +	} else {
> +		/* Inode is all there. */
> +		freemask_ok ^= inuse;

So inuse is returned from a mode check after iget succeeds. The mode
isn't zeroed until  /after/ XFS_IRECLAIMABLE is set, but it's also
set before XFS_INEW is cleared.  IOWs, how can
xfs_icache_inode_is_allocated() report anything
other than inuse == true here? If that's the case, what's the point
of the mode check inside xfs_icache_inode_is_allocated()?

> +	}
> +	if (!freemask_ok)
> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +out:
> +	return 0;
> +}
> +
> +/* Make sure the free mask is consistent with what the inodes think. */
> +STATIC int
> +xfs_scrub_iallocbt_check_freemask(
> +	struct xfs_scrub_btree		*bs,
> +	struct xfs_inobt_rec_incore	*irec)
> +{
> +	struct xfs_owner_info		oinfo;
> +	struct xfs_imap			imap;
> +	struct xfs_mount		*mp = bs->cur->bc_mp;
> +	struct xfs_dinode		*dip;
> +	struct xfs_buf			*bp;
> +	xfs_ino_t			fsino;
> +	xfs_agino_t			nr_inodes;
> +	xfs_agino_t			agino;
> +	xfs_agino_t			chunkino;
> +	xfs_agino_t			clusterino;
> +	xfs_agblock_t			agbno;
> +	int				blks_per_cluster;
> +	uint16_t			holemask;
> +	uint16_t			ir_holemask;
> +	int				error = 0;
> +
> +	/* Make sure the freemask matches the inode records. */
> +	blks_per_cluster = xfs_icluster_size_fsb(mp);
> +	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);

Does this setup and loop work for the case where we have 64k
filesystem blocks and so two or more inode chunks per filesystem
block (i.e. ppc64)? 

> +/* Scrub an inobt/finobt record. */
> +STATIC int
> +xfs_scrub_iallocbt_helper(
> +	struct xfs_scrub_btree		*bs,
> +	union xfs_btree_rec		*rec)
> +{
> +	struct xfs_mount		*mp = bs->cur->bc_mp;
> +	struct xfs_agi			*agi;
> +	struct xfs_inobt_rec_incore	irec;
> +	uint64_t			holes;
> +	xfs_agino_t			agino;
> +	xfs_agblock_t			agbno;
> +	xfs_extlen_t			len;
> +	int				holecount;
> +	int				i;
> +	int				error = 0;
> +	unsigned int			real_freecount;
> +	uint16_t			holemask;
> +
> +	xfs_inobt_btrec_to_irec(mp, rec, &irec);
> +
> +	if (irec.ir_count > XFS_INODES_PER_CHUNK ||
> +	    irec.ir_freecount > XFS_INODES_PER_CHUNK)
> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +
> +	real_freecount = irec.ir_freecount +
> +			(XFS_INODES_PER_CHUNK - irec.ir_count);
> +	if (real_freecount != xfs_scrub_iallocbt_freecount(irec.ir_free))
> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +
> +	agi = XFS_BUF_TO_AGI(bs->sc->sa.agi_bp);
> +	agino = irec.ir_startino;
> +	agbno = XFS_AGINO_TO_AGBNO(mp, irec.ir_startino);
> +	if (agbno >= be32_to_cpu(agi->agi_length)) {

Validate as per every other agbno?

> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +		goto out;
> +	}
> +
> +	if ((agbno & (xfs_ialloc_cluster_alignment(mp) - 1)) ||
> +	    (agbno & (xfs_icluster_size_fsb(mp) - 1)))
> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);

What's the magic masking checks being done here? (comment?)

> +	/* Handle non-sparse inodes */
> +	if (!xfs_inobt_issparse(irec.ir_holemask)) {
> +		len = XFS_B_TO_FSB(mp,
> +				XFS_INODES_PER_CHUNK * mp->m_sb.sb_inodesize);
> +		if (irec.ir_count != XFS_INODES_PER_CHUNK)
> +			xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +
> +		if (!xfs_scrub_iallocbt_chunk(bs, &irec, agino, len))
> +			goto out;
> +		goto check_freemask;
> +	}
> +
> +	/* Check each chunk of a sparse inode cluster. */
> +	holemask = irec.ir_holemask;
> +	holecount = 0;
> +	len = XFS_B_TO_FSB(mp,
> +			XFS_INODES_PER_HOLEMASK_BIT * mp->m_sb.sb_inodesize);
> +	holes = ~xfs_inobt_irec_to_allocmask(&irec);
> +	if ((holes & irec.ir_free) != holes ||
> +	    irec.ir_freecount > irec.ir_count)
> +		xfs_scrub_btree_set_corrupt(bs->sc, bs->cur, 0);
> +
> +	for (i = 0; i < XFS_INOBT_HOLEMASK_BITS; holemask >>= 1,
> +			i++, agino += XFS_INODES_PER_HOLEMASK_BIT) {

Urk. THat's a bit hard to read.

> +		if (holemask & 1) {
> +			holecount += XFS_INODES_PER_HOLEMASK_BIT;
> +			continue;
> +		}
> +
> +		if (!xfs_scrub_iallocbt_chunk(bs, &irec, agino, len))
> +			break;
> +	}

How about

	for (i = 0; i < XFS_INOBT_HOLEMASK_BITS; i++) {
		if (holemask & 1) {
			holecount += XFS_INODES_PER_HOLEMASK_BIT;
		} else if (!xfs_scrub_iallocbt_chunk(bs, &irec, agino, len))
			break;

		holemask >>= 1;
		agino += XFS_INODES_PER_HOLEMASK_BIT;
	}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
