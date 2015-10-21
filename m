Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B0A6629DF5
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 16:17:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8DFF78F804C
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 14:17:37 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id K1oUSDWApDhErfrf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 21 Oct 2015 14:17:35 -0700 (PDT)
Date: Wed, 21 Oct 2015 14:17:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 48/58] xfs: copy-on-write reflinked blocks when zeroing
	ranges of blocks
Message-ID: <20151021211727.GM10397@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
	<20151007050025.30457.19562.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151007050025.30457.19562.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Oct 06, 2015 at 10:00:25PM -0700, Darrick J. Wong wrote:
> When we're writing zeroes to a reflinked block (such as when we're
> punching a reflinked range), we need to fork the the block and write
> to that, otherwise we can corrupt the other reflinks.

Something that's missing from this patch series: when we shorten a file,
the VFS will zero the page contents between the new and old EOF.  Therefore,
we must ensure that the block is forked prior to this happening, or else we
end up changing the shared block, corrupting the other files.

--D

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c |   25 +++++++-
>  fs/xfs/xfs_reflink.c   |  154 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_reflink.h   |    6 ++
>  3 files changed, 183 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 245a34a..b054b28 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -41,6 +41,7 @@
>  #include "xfs_icache.h"
>  #include "xfs_log.h"
>  #include "xfs_rmap_btree.h"
> +#include "xfs_reflink.h"
>  
>  /* Kernel only BMAP related definitions and functions */
>  
> @@ -1095,7 +1096,9 @@ xfs_zero_remaining_bytes(
>  	xfs_buf_t		*bp;
>  	xfs_mount_t		*mp = ip->i_mount;
>  	int			nimap;
> -	int			error = 0;
> +	int			error = 0, err2;
> +	bool			should_fork;
> +	struct xfs_trans	*tp;
>  
>  	/*
>  	 * Avoid doing I/O beyond eof - it's not necessary
> @@ -1136,8 +1139,14 @@ xfs_zero_remaining_bytes(
>  		if (lastoffset > endoff)
>  			lastoffset = endoff;
>  
> +		/* Do we need to CoW this block? */
> +		error = xfs_reflink_should_fork_block(ip, &imap, offset,
> +				&should_fork);
> +		if (error)
> +			return error;
> +
>  		/* DAX can just zero the backing device directly */
> -		if (IS_DAX(VFS_I(ip))) {
> +		if (IS_DAX(VFS_I(ip)) && !should_fork) {
>  			error = dax_zero_page_range(VFS_I(ip), offset,
>  						    lastoffset - offset + 1,
>  						    xfs_get_blocks_direct);
> @@ -1158,10 +1167,22 @@ xfs_zero_remaining_bytes(
>  				(offset - XFS_FSB_TO_B(mp, imap.br_startoff)),
>  		       0, lastoffset - offset + 1);
>  
> +		tp = NULL;
> +		if (should_fork) {
> +			error = xfs_reflink_fork_buf(ip, bp, offset_fsb, &tp);
> +			if (error)
> +				return error;
> +		}
> +
>  		error = xfs_bwrite(bp);
> +
> +		err2 = xfs_reflink_finish_fork_buf(ip, bp, offset_fsb, tp,
> +						   error, imap.br_startblock);
>  		xfs_buf_relse(bp);
>  		if (error)
>  			return error;
> +		if (err2)
> +			return err2;
>  	}
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 226e23f..f5eed2f 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -788,3 +788,157 @@ xfs_reflink_add_ioend(
>  {
>  	list_add_tail(&eio->rlei_list, &ioend->io_reflink_endio_list);
>  }
> +
> +/**
> + * xfs_reflink_fork_buf() - start a transaction to fork a buffer (if needed)
> + *
> + * @mp: XFS mount point
> + * @ip: XFS inode
> + * @bp: the buffer that we might need to fork
> + * @fileoff: file offset of the buffer
> + * @ptp: pointer to an XFS transaction
> + */
> +int
> +xfs_reflink_fork_buf(
> +	struct xfs_inode	*ip,
> +	struct xfs_buf		*bp,
> +	xfs_fileoff_t		fileoff,
> +	struct xfs_trans	**ptp)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	xfs_fsblock_t		fsbno;
> +	xfs_fsblock_t		new_fsbno;
> +	xfs_agnumber_t		agno;
> +	xfs_agblock_t		agbno;
> +	uint			resblks;
> +	int			error;
> +
> +	fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
> +	agno = XFS_FSB_TO_AGNO(mp, fsbno);
> +	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
> +	CHECK_AG_NUMBER(mp, agno);
> +	CHECK_AG_EXTENT(mp, agno, 1);
> +
> +	/*
> +	 * Get ready to remap the thing...
> +	 */
> +	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 3);
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
> +
> +	/*
> +	 * check for running out of space
> +	 */
> +	if (error) {
> +		/*
> +		 * Free the transaction structure.
> +		 */
> +		ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
> +		goto out_cancel;
> +	}
> +	error = xfs_trans_reserve_quota(tp, mp,
> +			ip->i_udquot, ip->i_gdquot, ip->i_pdquot,
> +			resblks, 0, XFS_QMOPT_RES_REGBLKS);
> +	if (error)
> +		goto out_cancel;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +
> +	/* fork block, remap buffer */
> +	error = fork_one_block(mp, tp, ip, fsbno, &new_fsbno, fileoff);
> +	if (error)
> +		goto out_cancel;
> +
> +	trace_xfs_reflink_fork_buf(ip, fileoff, fsbno, 1, new_fsbno);
> +
> +	XFS_BUF_SET_ADDR(bp, XFS_FSB_TO_DADDR(mp, new_fsbno));
> +	*ptp = tp;
> +	return error;
> +
> +out_cancel:
> +	xfs_trans_cancel(tp);
> +	trace_xfs_reflink_fork_buf_error(ip, error, _RET_IP_);
> +	return error;
> +}
> +
> +/**
> + * xfs_reflink_finish_fork_buf() - finish forking a file buffer
> + *
> + * @ip: XFS inode
> + * @bp: the buffer that was forked
> + * @fileoff: file offset of the buffer
> + * @tp: transaction that was returned from xfs_reflink_fork_buf()
> + * @write_error: status code from writing the block
> + */
> +int
> +xfs_reflink_finish_fork_buf(
> +	struct xfs_inode	*ip,
> +	struct xfs_buf		*bp,
> +	xfs_fileoff_t		fileoff,
> +	struct xfs_trans	*tp,
> +	int			write_error,
> +	xfs_fsblock_t		old_fsbno)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_bmap_free	free_list;
> +	xfs_fsblock_t		firstfsb;
> +	xfs_fsblock_t		fsbno;
> +	struct xfs_bmbt_irec	imaps[1];
> +	xfs_agnumber_t		agno;
> +	int			nimaps = 1;
> +	int			done;
> +	int			error = write_error;
> +	int			committed;
> +	struct xfs_owner_info	oinfo;
> +
> +	if (tp == NULL)
> +		return 0;
> +
> +	fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
> +	agno = XFS_FSB_TO_AGNO(mp, fsbno);
> +	XFS_RMAP_INO_OWNER(&oinfo, ip->i_ino, XFS_DATA_FORK, fileoff);
> +	if (write_error != 0)
> +		goto out_write_error;
> +
> +	trace_xfs_reflink_fork_buf(ip, fileoff, old_fsbno, 1, fsbno);
> +	/*
> +	 * Remap the old blocks.
> +	 */
> +	xfs_bmap_init(&free_list, &firstfsb);
> +	error = xfs_bunmapi(tp, ip, fileoff, 1, 0, 1, &firstfsb, &free_list,
> +			    &done);
> +	if (error)
> +		goto out_free;
> +	ASSERT(done == 1);
> +
> +	error = xfs_bmapi_write(tp, ip, fileoff, 1, XFS_BMAPI_REMAP, &fsbno,
> +					1, &imaps[0], &nimaps, &free_list);
> +	if (error)
> +		goto out_free;
> +
> +	/*
> +	 * complete the transaction
> +	 */
> +	error = xfs_bmap_finish(&tp, &free_list, &committed);
> +	if (error)
> +		goto out_cancel;
> +
> +	error = xfs_trans_commit(tp);
> +	if (error)
> +		goto out_error;
> +
> +	return error;
> +out_free:
> +	xfs_bmap_finish(&tp, &free_list, &committed);
> +out_write_error:
> +	done = xfs_free_extent(tp, fsbno, 1, &oinfo);
> +	if (error == 0)
> +		error = done;
> +out_cancel:
> +	xfs_trans_cancel(tp);
> +out_error:
> +	trace_xfs_reflink_finish_fork_buf_error(ip, error, _RET_IP_);
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index b3e12d2..ce00cf6 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -38,4 +38,10 @@ extern void xfs_reflink_add_ioend(struct xfs_ioend *ioend,
>  extern int xfs_reflink_should_fork_block(struct xfs_inode *ip,
>  		struct xfs_bmbt_irec *imap, xfs_off_t offset, bool *type);
>  
> +extern int xfs_reflink_fork_buf(struct xfs_inode *ip, struct xfs_buf *bp,
> +		xfs_fileoff_t fileoff, struct xfs_trans **ptp);
> +extern int xfs_reflink_finish_fork_buf(struct xfs_inode *ip, struct xfs_buf *bp,
> +		xfs_fileoff_t fileoff, struct xfs_trans *tp, int write_error,
> +		xfs_fsblock_t old_fsbno);
> +
>  #endif /* __XFS_REFLINK_H */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
