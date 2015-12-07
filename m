Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC7907F37
	for <xfs@oss.sgi.com>; Mon,  7 Dec 2015 08:21:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51FB2AC002
	for <xfs@oss.sgi.com>; Mon,  7 Dec 2015 06:21:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TrN3LIx0WzSqqS3i (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Dec 2015 06:21:25 -0800 (PST)
Date: Mon, 7 Dec 2015 09:21:23 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_db: make check work for sparse inodes
Message-ID: <20151207142123.GA4071@bfoster.bfoster>
References: <20151204202606.GB16277@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151204202606.GB16277@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com

On Fri, Dec 04, 2015 at 12:26:06PM -0800, Darrick J. Wong wrote:
> Teach the inobt/finobt scanning functions how to deal with sparse
> inode chunks well enough that we can pass the spot-check.  Should
> fix the xfs/076 failures.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Hi Darrick,

Thanks for the patch...

>  db/check.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 75 insertions(+), 15 deletions(-)
> 
> diff --git a/db/check.c b/db/check.c
> index 9c1541d..14c7de5 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -4319,6 +4319,30 @@ scanfunc_cnt(
>  		scan_sbtree(agf, be32_to_cpu(pp[i]), level, 0, scanfunc_cnt, TYP_CNTBT);
>  }
>  
> +static bool
> +ino_issparse(
> +	struct xfs_inobt_rec	*rp,
> +	int			offset)
> +{
> +	if (!xfs_sb_version_hassparseinodes(&mp->m_sb))
> +		return false;
> +
> +	return xfs_inobt_is_sparse_disk(rp, offset);
> +}
> +
> +static int
> +find_first_zero_bit(
> +	unsigned long	mask)
> +{
> +	int		n;
> +	int		b = 0;
> +
> +	for (n = 0; n < sizeof(mask) * NBBY && (mask & 1); n++, mask >>= 1)
> +		b++;
> +
> +	return b;
> +}
> +
>  static void
>  scanfunc_ino(
>  	struct xfs_btree_block	*block,
> @@ -4336,6 +4360,10 @@ scanfunc_ino(
>  	int			off;
>  	xfs_inobt_ptr_t		*pp;
>  	xfs_inobt_rec_t		*rp;
> +	bool			sparse;
> +	int			inodes_per_chunk;
> +	int			freecount;
> +	int			startidx;
>  
>  	if (be32_to_cpu(block->bb_magic) != XFS_IBT_MAGIC &&
>  	    be32_to_cpu(block->bb_magic) != XFS_IBT_CRC_MAGIC) {
> @@ -4364,29 +4392,44 @@ scanfunc_ino(
>  		}
>  		rp = XFS_INOBT_REC_ADDR(mp, block, 1);
>  		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
> -			agino = be32_to_cpu(rp[i].ir_startino);
> +			sparse = xfs_sb_version_hassparseinodes(&mp->m_sb);
> +			if (sparse) {
> +				unsigned long	holemask;
> +
> +				inodes_per_chunk = rp[i].ir_u.sp.ir_count;
> +				freecount = rp[i].ir_u.sp.ir_freecount;
> +				holemask = be16_to_cpu(rp[i].ir_u.sp.ir_holemask);
> +				startidx = find_first_zero_bit(holemask) * XFS_INODES_PER_HOLEMASK_BIT;
> +			} else {
> +				inodes_per_chunk = XFS_INODES_PER_CHUNK;
> +				freecount = be32_to_cpu(rp[i].ir_u.f.ir_freecount);
> +				startidx = 0;
> +			}

This looks Ok...

> +			agino = be32_to_cpu(rp[i].ir_startino) + startidx;
>  			off = XFS_INO_TO_OFFSET(mp, agino);
>  			if (off == 0) {
> -				if ((sbversion & XFS_SB_VERSION_ALIGNBIT) &&
> +				if (!sparse &&
> +				    (sbversion & XFS_SB_VERSION_ALIGNBIT) &&

Here we're not checking the record alignment solely based on whether the
fs has the sparse inodes feature, which I don't think is what we want.
The sparse inodes feature tweaks sb_inoalignmt to the record size and
sets sb_spino_align (to the cluster size) to dictate the sparse chunk
allocation requirements. IOW, we probably want to check startino
alignment against sb_inoalignmt even if startino is not actually a
physical inode, because the record must still be correctly aligned.

>  				    mp->m_sb.sb_inoalignmt &&
>  				    (XFS_INO_TO_AGBNO(mp, agino) %
>  				     mp->m_sb.sb_inoalignmt))
>  					sbversion &= ~XFS_SB_VERSION_ALIGNBIT;
>  				set_dbmap(seqno, XFS_AGINO_TO_AGBNO(mp, agino),
>  					(xfs_extlen_t)MAX(1,
> -						XFS_INODES_PER_CHUNK >>
> +						inodes_per_chunk >>

While I think this might be practically correct in that with the current
supported alignments, the chunk of the record that is physically
allocated is typically contiguous, this might not always be the case.
E.g., if the cluster size is reduced due to some future mkfs change, the
allocated regions of the sparse record could be discontiguous.

>  						mp->m_sb.sb_inopblog),
>  					DBM_INODE, seqno, bno);
>  			}
> -			icount += XFS_INODES_PER_CHUNK;
> -			agicount += XFS_INODES_PER_CHUNK;
> -			ifree += be32_to_cpu(rp[i].ir_u.f.ir_freecount);
> -			agifreecount += be32_to_cpu(rp[i].ir_u.f.ir_freecount);
> +			icount += inodes_per_chunk;
> +			agicount += inodes_per_chunk;
> +			ifree += freecount;
> +			agifreecount += freecount;
>  			push_cur();
>  			set_cur(&typtab[TYP_INODE],
>  				XFS_AGB_TO_DADDR(mp, seqno,
>  						 XFS_AGINO_TO_AGBNO(mp, agino)),
> -				(int)XFS_FSB_TO_BB(mp, mp->m_ialloc_blks),
> +				(int)XFS_FSB_TO_BB(mp, inodes_per_chunk >>
> +						   mp->m_sb.sb_inopblog),

The same general contiguity issue applies here (and to the finobt
equivalent scan function)...

I think what we need to do here is rather than try to tweak the
set_dbmap()/set_cur() call params to try and cover the allocated range
in one shot, refactor the part of the code that processes the actual
inodes to walk the the record a cluster buffer at a time. E.g., after
we've grabbed the record data, checked the startino alignment, etc., add
a new loop that iterates the associated inode chunk a cluster buffer at
a time. If the starting inode of that cluster buffer is sparse, just
skip to the next cluster. Otherwise, carry on with the process_inode(),
set_dbmap() bits, etc., for each inode in the buffer.

FWIW, xfsprogs commit 04b21e41 ("metadump: support sparse inode
records") should provide a pretty close example of the same change
required here (db/metadump.c:copy_inode_chunk()).

Brian

>  				DB_RING_IGN, NULL);
>  			if (iocur_top->data == NULL) {
>  				if (!sflag)
> @@ -4399,20 +4442,22 @@ scanfunc_ino(
>  				continue;
>  			}
>  			for (j = 0, nfree = 0; j < XFS_INODES_PER_CHUNK; j++) {
> +				if (ino_issparse(&rp[i], j))
> +					continue;
>  				isfree = XFS_INOBT_IS_FREE_DISK(&rp[i], j);
>  				if (isfree)
>  					nfree++;
> -				process_inode(agf, agino + j,
> -					(xfs_dinode_t *)((char *)iocur_top->data + ((off + j) << mp->m_sb.sb_inodelog)),
> +				process_inode(agf, agino - startidx + j,
> +					(xfs_dinode_t *)((char *)iocur_top->data + ((off - startidx + j) << mp->m_sb.sb_inodelog)),
>  						isfree);
>  			}
> -			if (nfree != be32_to_cpu(rp[i].ir_u.f.ir_freecount)) {
> +			if (nfree != freecount) {
>  				if (!sflag)
>  					dbprintf(_("ir_freecount/free mismatch, "
>  						 "inode chunk %u/%u, freecount "
>  						 "%d nfree %d\n"),
>  						seqno, agino,
> -						be32_to_cpu(rp[i].ir_u.f.ir_freecount), nfree);
> +						freecount, nfree);
>  				error++;
>  			}
>  			pop_cur();
> @@ -4447,6 +4492,9 @@ scanfunc_fino(
>  	int			off;
>  	xfs_inobt_ptr_t		*pp;
>  	struct xfs_inobt_rec	*rp;
> +	bool			sparse;
> +	int			inodes_per_chunk;
> +	int			startidx;
>  
>  	if (be32_to_cpu(block->bb_magic) != XFS_FIBT_MAGIC &&
>  	    be32_to_cpu(block->bb_magic) != XFS_FIBT_CRC_MAGIC) {
> @@ -4475,17 +4523,29 @@ scanfunc_fino(
>  		}
>  		rp = XFS_INOBT_REC_ADDR(mp, block, 1);
>  		for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++) {
> -			agino = be32_to_cpu(rp[i].ir_startino);
> +			sparse = xfs_sb_version_hassparseinodes(&mp->m_sb);
> +			if (sparse) {
> +				unsigned long	holemask;
> +
> +				inodes_per_chunk = rp[i].ir_u.sp.ir_count;
> +				holemask = be16_to_cpu(rp[i].ir_u.sp.ir_holemask);
> +				startidx = find_first_zero_bit(holemask) * XFS_INODES_PER_HOLEMASK_BIT;
> +			} else {
> +				inodes_per_chunk = XFS_INODES_PER_CHUNK;
> +				startidx = 0;
> +			}
> +			agino = be32_to_cpu(rp[i].ir_startino) + startidx;
>  			off = XFS_INO_TO_OFFSET(mp, agino);
>  			if (off == 0) {
> -				if ((sbversion & XFS_SB_VERSION_ALIGNBIT) &&
> +				if (!sparse &&
> +				    (sbversion & XFS_SB_VERSION_ALIGNBIT) &&
>  				    mp->m_sb.sb_inoalignmt &&
>  				    (XFS_INO_TO_AGBNO(mp, agino) %
>  				     mp->m_sb.sb_inoalignmt))
>  					sbversion &= ~XFS_SB_VERSION_ALIGNBIT;
>  				check_set_dbmap(seqno, XFS_AGINO_TO_AGBNO(mp, agino),
>  					(xfs_extlen_t)MAX(1,
> -						XFS_INODES_PER_CHUNK >>
> +						inodes_per_chunk >>
>  						mp->m_sb.sb_inopblog),
>  					DBM_INODE, DBM_INODE, seqno, bno);
>  			}
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
