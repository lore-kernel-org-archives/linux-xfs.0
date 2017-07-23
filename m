Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31561 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751410AbdGWRzZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jul 2017 13:55:25 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6NHtO4Q009098
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 17:55:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6NHtOOZ026728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 17:55:24 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v6NHtOkY010588
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 17:55:24 GMT
Subject: Re: [PATCH 17/22] xfs: scrub directory freespace
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061201947.14732.7337884085202901044.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <9cc3a14c-37f1-de09-4505-6bbd752e274c@oracle.com>
Date: Sun, 23 Jul 2017 10:55:23 -0700
MIME-Version: 1.0
In-Reply-To: <150061201947.14732.7337884085202901044.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks fine, not much change since v7
Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 7/20/2017 9:40 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Check the free space information in a directory.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/dir.c |  337 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 337 insertions(+)
>
>
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index 1d6b5329..661aec3 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -232,6 +232,338 @@ xfs_scrub_dir_rec(
>  #undef XFS_SCRUB_DIRENT_GOTO
>  #undef XFS_SCRUB_DIRENT_CHECK
>
> +#define XFS_SCRUB_DIR_BLOCK_CHECK(fs_ok) \
> +	XFS_SCRUB_DATA_CHECK(sc, XFS_DATA_FORK, \
> +		lblk << mp->m_sb.sb_blocklog, "dir", fs_ok)
> +#define XFS_SCRUB_DIR_BLOCK_GOTO(fs_ok, label) \
> +	XFS_SCRUB_DATA_GOTO(sc, XFS_DATA_FORK, \
> +		lblk << mp->m_sb.sb_blocklog, "dir", fs_ok, label)
> +#define XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(label) \
> +	XFS_SCRUB_FILE_OP_ERROR_GOTO(sc, XFS_DATA_FORK, \
> +		lblk << mp->m_sb.sb_blocklog, "dir", &error, label)
> +/* Is this free entry either in the bestfree or smaller than all of them? */
> +static inline bool
> +xfs_scrub_directory_check_free_entry(
> +	struct xfs_dir2_data_free	*bf,
> +	struct xfs_dir2_data_unused	*dup)
> +{
> +	struct xfs_dir2_data_free	*dfp;
> +	unsigned int			smallest;
> +
> +	smallest = -1U;
> +	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
> +		if (dfp->offset &&
> +		    be16_to_cpu(dfp->length) == be16_to_cpu(dup->length))
> +			return true;
> +		if (smallest < be16_to_cpu(dfp->length))
> +			smallest = be16_to_cpu(dfp->length);
> +	}
> +
> +	return be16_to_cpu(dup->length) <= smallest;
> +}
> +
> +/* Check free space info in a directory data block. */
> +STATIC int
> +xfs_scrub_directory_data_bestfree(
> +	struct xfs_scrub_context	*sc,
> +	xfs_dablk_t			lblk,
> +	bool				is_block)
> +{
> +	struct xfs_dir2_data_unused	*dup;
> +	struct xfs_dir2_data_free	*dfp;
> +	struct xfs_buf			*bp;
> +	struct xfs_dir2_data_free	*bf;
> +	struct xfs_mount		*mp = sc->mp;
> +	char				*ptr;
> +	char				*endptr;
> +	u16				tag;
> +	int				newlen;
> +	int				offset;
> +	int				error;
> +
> +	if (is_block) {
> +		/* dir block format */
> +		XFS_SCRUB_DIR_BLOCK_CHECK(lblk ==
> +				XFS_B_TO_FSBT(mp, XFS_DIR2_DATA_OFFSET));
> +		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
> +	} else {
> +		/* dir data format */
> +		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk, -1, &bp);
> +	}
> +	XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(out);
> +
> +	/* Do the bestfrees correspond to actual free space? */
> +	bf = sc->ip->d_ops->data_bestfree_p(bp->b_addr);
> +	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
> +		offset = be16_to_cpu(dfp->offset);
> +		XFS_SCRUB_DIR_BLOCK_GOTO(offset < BBTOB(bp->b_length), nextloop);
> +		if (!offset)
> +			continue;
> +		dup = (struct xfs_dir2_data_unused *)(bp->b_addr + offset);
> +		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
> +
> +		XFS_SCRUB_DIR_BLOCK_CHECK(dup->freetag ==
> +				cpu_to_be16(XFS_DIR2_DATA_FREE_TAG));
> +		XFS_SCRUB_DIR_BLOCK_CHECK(be16_to_cpu(dup->length) ==
> +				be16_to_cpu(dfp->length));
> +		XFS_SCRUB_DIR_BLOCK_CHECK(tag ==
> +				((char *)dup - (char *)bp->b_addr));
> +nextloop:;
> +	}
> +
> +	/* Make sure the bestfrees are actually the best free spaces. */
> +	ptr = (char *)sc->ip->d_ops->data_entry_p(bp->b_addr);
> +	if (is_block) {
> +		struct xfs_dir2_block_tail	*btp;
> +
> +		btp = xfs_dir2_block_tail_p(sc->mp->m_dir_geo, bp->b_addr);
> +		endptr = (char *)xfs_dir2_block_leaf_p(btp);
> +	} else
> +		endptr = (char *)bp->b_addr + BBTOB(bp->b_length);
> +	while (ptr < endptr) {
> +		dup = (struct xfs_dir2_data_unused *)ptr;
> +		/* Skip real entries */
> +		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG)) {
> +			struct xfs_dir2_data_entry	*dep;
> +
> +			dep = (struct xfs_dir2_data_entry *)ptr;
> +			newlen = sc->ip->d_ops->data_entsize(dep->namelen);
> +			XFS_SCRUB_DIR_BLOCK_GOTO(newlen > 0, out_buf);
> +			ptr += newlen;
> +			XFS_SCRUB_DIR_BLOCK_CHECK(ptr <= endptr);
> +			continue;
> +		}
> +
> +		/* Spot check this free entry */
> +		tag = be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup));
> +		XFS_SCRUB_DIR_BLOCK_CHECK(tag ==
> +				((char *)dup - (char *)bp->b_addr));
> +
> +		/*
> +		 * Either this entry is a bestfree or it's smaller than
> +		 * any of the bestfrees.
> +		 */
> +		XFS_SCRUB_DIR_BLOCK_CHECK(
> +				xfs_scrub_directory_check_free_entry(bf, dup));
> +
> +		/* Move on. */
> +		newlen = be16_to_cpu(dup->length);
> +		XFS_SCRUB_DIR_BLOCK_GOTO(newlen > 0, out_buf);
> +		ptr += newlen;
> +		XFS_SCRUB_DIR_BLOCK_CHECK(ptr <= endptr);
> +	}
> +out_buf:
> +	xfs_trans_brelse(sc->tp, bp);
> +out:
> +	return error;
> +}
> +
> +/* Is this the longest free entry in the block? */
> +static inline bool
> +xfs_scrub_directory_check_freesp(
> +	struct xfs_inode		*dp,
> +	struct xfs_buf			*dbp,
> +	unsigned int			len)
> +{
> +	struct xfs_dir2_data_free	*bf;
> +	struct xfs_dir2_data_free	*dfp;
> +	unsigned int			longest = 0;
> +	int				offset;
> +
> +	bf = dp->d_ops->data_bestfree_p(dbp->b_addr);
> +	for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
> +		offset = be16_to_cpu(dfp->offset);
> +		if (!offset)
> +			continue;
> +		if (longest < be16_to_cpu(dfp->length))
> +			longest = be16_to_cpu(dfp->length);
> +	}
> +
> +	return longest == len;
> +}
> +
> +/* Check free space info in a directory leaf1 block. */
> +STATIC int
> +xfs_scrub_directory_leaf1_bestfree(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_da_args		*args,
> +	xfs_dablk_t			lblk)
> +{
> +	struct xfs_dir2_leaf_tail	*ltp;
> +	struct xfs_buf			*dbp;
> +	struct xfs_buf			*bp;
> +	struct xfs_mount		*mp = sc->mp;
> +	__be16				*bestp;
> +	__u16				best;
> +	int				i;
> +	int				error;
> +
> +	/* Read the free space block */
> +	error = xfs_dir3_leaf_read(sc->tp, sc->ip, lblk, -1, &bp);
> +	XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(out);
> +
> +	/* Check all the entries. */
> +	ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, bp->b_addr);
> +	bestp = xfs_dir2_leaf_bests_p(ltp);
> +	for (i = 0; i < be32_to_cpu(ltp->bestcount); i++, bestp++) {
> +		best = be16_to_cpu(*bestp);
> +		if (best == NULLDATAOFF)
> +			continue;
> +		error = xfs_dir3_data_read(sc->tp, sc->ip,
> +				i * args->geo->fsbcount, -1, &dbp);
> +		XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(skip_buf);
> +		XFS_SCRUB_DIR_BLOCK_CHECK(
> +				xfs_scrub_directory_check_freesp(sc->ip, dbp,
> +					best));
> +		xfs_trans_brelse(sc->tp, dbp);
> +skip_buf:
> +		;
> +	}
> +out:
> +	return error;
> +}
> +
> +/* Check free space info in a directory freespace block. */
> +STATIC int
> +xfs_scrub_directory_free_bestfree(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_da_args		*args,
> +	xfs_dablk_t			lblk)
> +{
> +	struct xfs_dir3_icfree_hdr	freehdr;
> +	struct xfs_buf			*dbp;
> +	struct xfs_buf			*bp;
> +	struct xfs_mount		*mp = sc->mp;
> +	__be16				*bestp;
> +	__be16				best;
> +	int				i;
> +	int				error;
> +
> +	/* Read the free space block */
> +	error = xfs_dir2_free_read(sc->tp, sc->ip, lblk, &bp);
> +	XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(out);
> +
> +	/* Check all the entries. */
> +	sc->ip->d_ops->free_hdr_from_disk(&freehdr, bp->b_addr);
> +	bestp = sc->ip->d_ops->free_bests_p(bp->b_addr);
> +	for (i = 0; i < freehdr.nvalid; i++, bestp++) {
> +		best = be16_to_cpu(*bestp);
> +		if (best == NULLDATAOFF)
> +			continue;
> +		error = xfs_dir3_data_read(sc->tp, sc->ip,
> +				(freehdr.firstdb + i) * args->geo->fsbcount,
> +				-1, &dbp);
> +		XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(skip_buf);
> +		XFS_SCRUB_DIR_BLOCK_CHECK(
> +				xfs_scrub_directory_check_freesp(sc->ip, dbp,
> +					best));
> +		xfs_trans_brelse(sc->tp, dbp);
> +skip_buf:
> +		;
> +	}
> +out:
> +	return error;
> +}
> +
> +#define for_each_extent_dablk(lblk, args, got) \
> +		for ((lblk) = roundup((xfs_dablk_t)(got)->br_startoff, (args)->geo->fsbcount); \
> +		     (lblk) < (got)->br_startoff + (got)->br_blockcount; \
> +		     (lblk) += (args)->geo->fsbcount)
> +/* Check free space information in directories. */
> +STATIC int
> +xfs_scrub_directory_blocks(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_bmbt_irec		got;
> +	struct xfs_da_args		args;
> +	struct xfs_ifork		*ifp;
> +	struct xfs_mount		*mp = sc->mp;
> +	xfs_fileoff_t			leaf_lblk;
> +	xfs_fileoff_t			free_lblk;
> +	xfs_fileoff_t			lblk;
> +	xfs_extnum_t			idx;
> +	bool				found;
> +	int				is_block = 0;
> +	int				error;
> +
> +	/* Ignore local format directories. */
> +	if (sc->ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
> +	    sc->ip->i_d.di_format != XFS_DINODE_FMT_BTREE)
> +		return 0;
> +
> +	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
> +	lblk = XFS_B_TO_FSB(mp, XFS_DIR2_DATA_OFFSET);
> +	leaf_lblk = XFS_B_TO_FSB(mp, XFS_DIR2_LEAF_OFFSET);
> +	free_lblk = XFS_B_TO_FSB(mp, XFS_DIR2_FREE_OFFSET);
> +
> +	/* Is this a block dir? */
> +	args.dp = sc->ip;
> +	args.geo = mp->m_dir_geo;
> +	args.trans = sc->tp;
> +	error = xfs_dir2_isblock(&args, &is_block);
> +	XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO(out);
> +
> +	/* Iterate all the data extents in the directory... */
> +	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
> +	while (found) {
> +		/* No more data blocks... */
> +		if (got.br_startoff >= leaf_lblk)
> +			break;
> +
> +		/* Check each data block's bestfree data */
> +		for_each_extent_dablk(lblk, &args, &got) {
> +			error = xfs_scrub_directory_data_bestfree(sc, lblk,
> +					is_block);
> +			if (error)
> +				goto out;
> +		}
> +
> +		found = xfs_iext_get_extent(ifp, ++idx, &got);
> +	}
> +
> +	/* Look for a leaf1 block, which has free info. */
> +	if (xfs_iext_lookup_extent(sc->ip, ifp, leaf_lblk, &idx, &got) &&
> +	    got.br_startoff == leaf_lblk &&
> +	    got.br_blockcount == args.geo->fsbcount &&
> +	    !xfs_iext_get_extent(ifp, ++idx, &got)) {
> +		XFS_SCRUB_DIR_BLOCK_GOTO(!is_block, not_leaf1);
> +		error = xfs_scrub_directory_leaf1_bestfree(sc, &args,
> +				leaf_lblk);
> +		if (error)
> +			goto out;
> +	}
> +not_leaf1:
> +
> +	/* Scan for free blocks */
> +	lblk = free_lblk;
> +	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &idx, &got);
> +	while (found) {
> +		/*
> +		 * Dirs can't have blocks mapped above 2^32.
> +		 * Single-block dirs shouldn't even be here.
> +		 */
> +		lblk = got.br_startoff;
> +		XFS_SCRUB_DIR_BLOCK_GOTO(!(lblk & ~((1ULL << 32) - 1ULL)), out);
> +		XFS_SCRUB_DIR_BLOCK_GOTO(!is_block, nextfree);
> +
> +		/* Check each dir free block's bestfree data */
> +		for_each_extent_dablk(lblk, &args, &got) {
> +			error = xfs_scrub_directory_free_bestfree(sc, &args,
> +					lblk);
> +			if (error)
> +				goto out;
> +		}
> +
> +nextfree:
> +		found = xfs_iext_get_extent(ifp, ++idx, &got);
> +	}
> +out:
> +	return error;
> +}
> +#undef for_each_extent_dablk
> +#undef XFS_SCRUB_DIR_BLOCK_OP_ERROR_GOTO
> +#undef XFS_SCRUB_DIR_BLOCK_CHECK
> +
>  /* Scrub a whole directory. */
>  int
>  xfs_scrub_directory(
> @@ -258,6 +590,11 @@ xfs_scrub_directory(
>  	if (error)
>  		return error;
>
> +	/* Check the freespace. */
> +	error = xfs_scrub_directory_blocks(sc);
> +	if (error)
> +		return error;
> +
>  	/* Check that every dirent we see can also be looked up by hash. */
>  	bufsize = (size_t)min_t(loff_t, 32768, sc->ip->i_d.di_size);
>  	sdc.sc = sc;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
