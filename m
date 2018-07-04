Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42818 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752218AbeGDSpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jul 2018 14:45:35 -0400
Date: Wed, 4 Jul 2018 11:45:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/21] xfs: repair damaged symlinks
Message-ID: <20180704184529.GG32415@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986831674.3155.13573754070174091850.stgit@magnolia>
 <20180704054533.GO2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180704054533.GO2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 04, 2018 at 03:45:33PM +1000, Dave Chinner wrote:
> On Sun, Jun 24, 2018 at 12:25:16PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Repair inconsistent symbolic link data.
> .....
> > +/*
> > + * Symbolic Link Repair
> > + * ====================
> > + *
> > + * There's not much we can do to repair symbolic links -- we truncate them to
> > + * the first NULL byte and fix up the remote target block headers if they're
> > + * incorrect.  Zero-length symlinks are turned into links to /.
> > + */
> > +
> > +/* Blow out the whole symlink; replace contents. */
> > +STATIC int
> > +xfs_repair_symlink_rewrite(
> > +	struct xfs_trans	**tpp,
> > +	struct xfs_inode	*ip,
> > +	const char		*target_path,
> > +	int			pathlen)
> > +{
> > +	struct xfs_defer_ops	dfops;
> > +	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
> > +	struct xfs_ifork	*ifp;
> > +	const char		*cur_chunk;
> > +	struct xfs_mount	*mp = (*tpp)->t_mountp;
> > +	struct xfs_buf		*bp;
> > +	xfs_fsblock_t		first_block;
> > +	xfs_fileoff_t		first_fsb;
> > +	xfs_filblks_t		fs_blocks;
> > +	xfs_daddr_t		d;
> > +	int			byte_cnt;
> > +	int			n;
> > +	int			nmaps;
> > +	int			offset;
> > +	int			error = 0;
> > +
> > +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > +
> > +	/* Truncate the whole data fork if it wasn't inline. */
> > +	if (!(ifp->if_flags & XFS_IFINLINE)) {
> > +		error = xfs_itruncate_extents(tpp, ip, XFS_DATA_FORK, 0);
> > +		if (error)
> > +			goto out;
> > +	}
> > +
> > +	/* Blow out the in-core fork and zero the on-disk fork. */
> > +	xfs_idestroy_fork(ip, XFS_DATA_FORK);
> > +	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
> > +	ip->i_d.di_nextents = 0;
> > +	memset(&ip->i_df, 0, sizeof(struct xfs_ifork));
> > +	ip->i_df.if_flags |= XFS_IFEXTENTS;
> 
> This looks familiar - doesn't the fork zapping code do exactly this,
> too? factor into a helper?

Yeah, helpers clearly needed somewhere.

> > +
> > +	/* Rewrite an inline symlink. */
> > +	if (pathlen <= XFS_IFORK_DSIZE(ip)) {
> > +		xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen);
> > +
> > +		i_size_write(VFS_I(ip), pathlen);
> > +		ip->i_d.di_size = pathlen;
> > +		ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
> > +		xfs_trans_log_inode(*tpp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
> > +		goto out;
> > +
> > +	}
> 
> Might make sense to separate inline vs remote into separate
> functions - we tend to do that everywhere else in the symlink code.

Ok.

> > +
> > +	/* Rewrite a remote symlink. */
> > +	fs_blocks = xfs_symlink_blocks(mp, pathlen);
> > +	first_fsb = 0;
> > +	nmaps = XFS_SYMLINK_MAPS;
> > +
> > +	/* Reserve quota for new blocks. */
> > +	error = xfs_trans_reserve_quota_nblks(*tpp, ip, fs_blocks, 0,
> > +			XFS_QMOPT_RES_REGBLKS);
> > +	if (error)
> > +		goto out;
> > +
> > +	/* Map blocks, write symlink target. */
> > +	xfs_defer_init(&dfops, &first_block);
> > +
> > +	error = xfs_bmapi_write(*tpp, ip, first_fsb, fs_blocks,
> > +			  XFS_BMAPI_METADATA, &first_block, fs_blocks,
> > +			  mval, &nmaps, &dfops);
> > +	if (error)
> > +		goto out_bmap_cancel;
> > +
> > +	ip->i_d.di_size = pathlen;
> > +	i_size_write(VFS_I(ip), pathlen);
> > +	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
> > +
> > +	cur_chunk = target_path;
> > +	offset = 0;
> > +	for (n = 0; n < nmaps; n++) {
> > +		char	*buf;
> > +
> > +		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
> > +		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
> > +		bp = xfs_trans_get_buf(*tpp, mp->m_ddev_targp, d,
> > +				       BTOBB(byte_cnt), 0);
> > +		if (!bp) {
> > +			error = -ENOMEM;
> > +			goto out_bmap_cancel;
> > +		}
> > +		bp->b_ops = &xfs_symlink_buf_ops;
> > +
> > +		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
> > +		byte_cnt = min(byte_cnt, pathlen);
> > +
> > +		buf = bp->b_addr;
> > +		buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset,
> > +					   byte_cnt, bp);
> > +
> > +		memcpy(buf, cur_chunk, byte_cnt);
> > +
> > +		cur_chunk += byte_cnt;
> > +		pathlen -= byte_cnt;
> > +		offset += byte_cnt;
> > +
> > +		xfs_trans_buf_set_type(*tpp, bp, XFS_BLFT_SYMLINK_BUF);
> > +		xfs_trans_log_buf(*tpp, bp, 0, (buf + byte_cnt - 1) -
> > +						(char *)bp->b_addr);
> > +	}
> > +	ASSERT(pathlen == 0);
> 
> This just looks like a copynpaste of main loop in xfs_symlink() -
> can you factor that into a helper, please?

Ok.

> > +
> > +	error = xfs_defer_finish(tpp, &dfops);
> > +	if (error)
> > +		goto out_bmap_cancel;
> > +
> > +	return 0;
> > +
> > +out_bmap_cancel:
> > +	xfs_defer_cancel(&dfops);
> > +out:
> > +	return error;
> > +}
> > +
> > +/* Fix everything that fails the verifiers in the remote blocks. */
> > +STATIC int
> > +xfs_repair_symlink_fix_remotes(
> > +	struct xfs_scrub_context	*sc,
> > +	loff_t				len)
> > +{
> > +	struct xfs_bmbt_irec		mval[XFS_SYMLINK_MAPS];
> > +	struct xfs_buf			*bp;
> > +	xfs_filblks_t			fsblocks;
> > +	xfs_daddr_t			d;
> > +	loff_t				offset;
> > +	unsigned int			byte_cnt;
> > +	int				n;
> > +	int				nmaps = XFS_SYMLINK_MAPS;
> > +	int				nr;
> > +	int				error;
> > +
> > +	fsblocks = xfs_symlink_blocks(sc->mp, len);
> > +	error = xfs_bmapi_read(sc->ip, 0, fsblocks, mval, &nmaps, 0);
> > +	if (error)
> > +		return error;
> > +
> > +	offset = 0;
> > +	for (n = 0; n < nmaps; n++) {
> > +		d = XFS_FSB_TO_DADDR(sc->mp, mval[n].br_startblock);
> > +		byte_cnt = XFS_FSB_TO_B(sc->mp, mval[n].br_blockcount);
> > +
> > +		error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
> > +				d, BTOBB(byte_cnt), 0, &bp, NULL);
> > +		if (error)
> > +			return error;
> > +		bp->b_ops = &xfs_symlink_buf_ops;
> > +
> > +		byte_cnt = XFS_SYMLINK_BUF_SPACE(sc->mp, byte_cnt);
> > +		if (len < byte_cnt)
> > +			byte_cnt = len;
> 
> can we make this the same as the other functions? i.e.
> 
> 		byte_cnt = min(byte_cnt, len);

<nod>

> > +
> > +		nr = xfs_symlink_hdr_set(sc->mp, sc->ip->i_ino, offset,
> > +				byte_cnt, bp);
> > +
> > +		len -= byte_cnt;
> > +		offset += byte_cnt;
> > +
> > +		xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SYMLINK_BUF);
> > +		xfs_trans_log_buf(sc->tp, bp, 0, nr - 1);
> > +		xfs_trans_brelse(sc->tp, bp);
> 
> xfs_trans_brelse() is a no-op here because the buffer has been
> logged. It can be removed.

<nod>

> > +	}
> > +	if (len != 0)
> > +		return -EFSCORRUPTED;
> > +
> > +	return 0;
> > +}
> > +
> > +/* Fix this inline symlink. */
> > +STATIC int
> > +xfs_repair_symlink_inline(
> > +	struct xfs_scrub_context	*sc)
> > +{
> > +	struct xfs_inode		*ip = sc->ip;
> > +	struct xfs_ifork		*ifp;
> > +	loff_t				len;
> > +	size_t				newlen;
> > +
> > +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > +	len = i_size_read(VFS_I(ip));
> > +	xfs_trans_ijoin(sc->tp, ip, 0);
> > +
> > +	if (ifp->if_u1.if_data) {
> > +		newlen = strnlen(ifp->if_u1.if_data, XFS_IFORK_DSIZE(ip));
> > +	} else {
> > +		/* Zero length symlink becomes a root symlink. */
> > +		ifp->if_u1.if_data = kmem_alloc(4, KM_SLEEP);
> > +		snprintf(ifp->if_u1.if_data, 4, "/");
> > +		newlen = 1;
> 
> helper function shared with the fork zapping code?

Yes.

> > +	}
> > +
> > +	if (len > newlen) {
> 
> shouldn't this be 'if (len != newlen) {' ?

Yes.

> > +		i_size_write(VFS_I(ip), newlen);
> > +		ip->i_d.di_size = newlen;
> > +		xfs_trans_log_inode(sc->tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/* Repair a remote symlink. */
> > +STATIC int
> > +xfs_repair_symlink_remote(
> > +	struct xfs_scrub_context	*sc)
> > +{
> > +	struct xfs_inode		*ip = sc->ip;
> > +	loff_t				len;
> > +	size_t				newlen;
> > +	int				error = 0;
> > +
> > +	len = i_size_read(VFS_I(ip));
> > +	xfs_trans_ijoin(sc->tp, ip, 0);
> > +
> > +	error = xfs_repair_symlink_fix_remotes(sc, len);
> > +	if (error)
> > +		return error;
> > +
> > +	/* Roll transaction, release buffers. */
> > +	error = xfs_trans_roll_inode(&sc->tp, ip);
> > +	if (error)
> > +		return error;
> > +
> > +	/* Size set correctly? */
> > +	len = i_size_read(VFS_I(ip));
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	error = xfs_readlink(ip, sc->buf);
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> 
> Can we pass a "need_lock" flag to xfs_readlink() rather than
> creating a race condition with anything that might be blocked on the
> ilock waiting for repair to complete?

LOL, there already is a locked version of that, which I added two years
ago in preparation for online symlink scrub.  Will switch to
xfs_readlink_bmap_ilocked.

> > +	if (error)
> > +		return error;
> > +
> > +	/*
> > +	 * Figure out the new target length.  We can't handle zero-length
> > +	 * symlinks, so make sure that we don't write that out.
> > +	 */
> > +	newlen = strnlen(sc->buf, XFS_SYMLINK_MAXLEN);
> > +	if (newlen == 0) {
> > +		*((char *)sc->buf) = '/';
> > +		newlen = 1;
> 
> We really need to do set the name of the repaired path for zero
> length symlinks in only one place. It really seems to me that it
> should done in xfs_repair_symlink_rewrite() if newlen is 0, not
> here.

Agreed, will work on that.

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
