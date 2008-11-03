Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Nov 2008 17:24:44 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA31OV7G020098
	for <xfs@oss.sgi.com>; Sun, 2 Nov 2008 17:24:31 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 676071BDB752
	for <xfs@oss.sgi.com>; Sun,  2 Nov 2008 17:24:32 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 9lPFv0eSNndkysKS for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 17:24:32 -0800 (PST)
Date: Mon, 3 Nov 2008 12:24:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] merge xfs_imap into xfs_dilocate
Message-ID: <20081103012411.GO19509@disturbed>
References: <20081027134124.GD3183@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027134124.GD3183@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:41:24AM -0400, Christoph Hellwig wrote:
> xfs_imap is the only caller of xfs_dilocate and doesn't add any significant
> value.  Merge the two functions and document the various cases we have for
> inode cluster lookup in the new xfs_imap.
> 
> Also remove the unused im_agblkno and im_ioffset fields from struct xfs_imap
> while we're at it.

A few small things....

> @@ -1262,34 +1255,65 @@ xfs_dilocate(
>  #endif /* DEBUG */
>  		return XFS_ERROR(EINVAL);
>  	}
> -	if ((mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp))) {
> +
> +	/*
> +	 * If the inode cluster size is the same as the blocksize or
> +	 * bigger we get to the buffer by simple arithmetics.
> +	 */
> +	if (XFS_INODE_CLUSTER_SIZE(mp) <= mp->m_sb.sb_blocksize) {

The comment doesn't match the code. This is the case where the block
size is the same or larger than the cluster size.

>  		offset = XFS_INO_TO_OFFSET(mp, ino);
>  		ASSERT(offset < mp->m_sb.sb_inopblock);
> -		*bno = XFS_AGB_TO_FSB(mp, agno, agbno);
> -		*off = offset;
> -		*len = 1;
> +
> +		imap->im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
> +		imap->im_len = XFS_FSB_TO_BB(mp, 1);
> +		imap->im_boffset = (ushort)(offset << mp->m_sb.sb_inodelog);
>  		return 0;
>  	}
> +
>  	blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
> -	if (*bno != NULLFSBLOCK) {
> +
> +	/*
> +	 * If we get a block number passed from bulkstat we can use it to
> +	 * find the buffer easily.
> +	 */
> +	if (imap->im_blkno) {

I'm not sure I like this special case of blkno == 0 meaning
"no block set" - it is different to the rest of the code that
uses special values to indicate "no block set". At minimum it
needs documenting at the definition of struct xfs_imap, or
perhaps a new define for "NULLIMAPBLOCK"...

> +
> +	/*
> +	 * With aligned inodes it's again quite simple and we can skip the
> +	 * btree lookup.
> +	 */
>  	if (mp->m_inoalign_mask) {
>  		offset_agbno = agbno & mp->m_inoalign_mask;
>  		chunk_agbno = agbno - offset_agbno;
> +
> +	/*
> +	 * Worst case: we actually have to actually perform a lookup in the
> +	 * inode btree.
> +	 */
>  	} else {

I rather dislike this method of commenting if/else constructs
as it can make it hard to see the flow of the code at a glance.
Can you move the comment inside the else case, or combine the
comment with the one above the if/else. e.g.:

	/*
	 * If the inode chunks are aligned then use simple maths to
	 * find the location. Otherwise we have to do a btree
	 * lookup to find the location.
	 */

> +		xfs_btree_cur_t	*cur;	/* inode btree cursor */
> +		xfs_agino_t	chunk_agino; /* first agino in inode chunk */
> +		__int32_t	chunk_cnt; /* count of free inodes in chunk */
> +		xfs_inofree_t	chunk_free; /* mask of free inodes in chunk */
> +		xfs_buf_t	*agbp;	/* agi buffer */
> +		int		i;	/* temp state */
> +
>  		down_read(&mp->m_peraglock);
>  		error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
>  		up_read(&mp->m_peraglock);
>  		if (error) {
>  #ifdef DEBUG
> -			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
> +			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
>  					"xfs_ialloc_read_agi() returned "
>  					"error %d, agno %d",
>  					error, agno);

I think this should always be emitted here, not just for
debug kernels - it's indicative of a serious error, and
when we have CRC checking it will tell us exactly what
structure is corrupt...

>  #ifdef DEBUG
> -			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_dilocate: "
> +			xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
>  					"xfs_inobt_get_rec() failed");
>  #endif /* DEBUG */
>  			error = XFS_ERROR(EINVAL);
>  		}
> + error0:
>  		xfs_trans_brelse(tp, agbp);
>  		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);

That will delete the cursor when there is an error with a "No Error"
trace. Not exactly what we want, right?

> +	/*
> +	 * If the inode number maps to a block outside the bounds
> +	 * of the file system then return NULL rather than calling
> +	 * read_buf and panicing when we get an error from the
> +	 * driver.
> +	 */
> +	if ((imap->im_blkno + imap->im_len) >
> +	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
> +		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
> +			"(imap->im_blkno (0x%llx) + imap->im_len (0x%llx)) > "
> +			" XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) (0x%llx)",
> +			(unsigned long long) imap->im_blkno,
> +			(unsigned long long) imap->im_len,
> +			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
> +		return EINVAL;

	return XFS_ERROR(EINVAL);

To match the earlier out of bounds error checks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
