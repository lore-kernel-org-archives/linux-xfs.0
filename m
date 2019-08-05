Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32830 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbfHEMib (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 08:38:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so84377638wru.0
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 05:38:30 -0700 (PDT)
Date: Mon, 5 Aug 2019 14:38:26 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/5] xfs: use a struct iomap in xfs_writepage_ctx
Message-ID: <20190805123826.6bv7jhcnw5ecnol7@orion.maiolino.org>
References: <156444951713.2682520.8109813555788585092.stgit@magnolia>
 <156444952349.2682520.6180005494290997205.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156444952349.2682520.6180005494290997205.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Damien.LeMoal@wdc.com, Christoph Hellwig <hch@lst.de>, agruenba@redhat.com

On Mon, Jul 29, 2019 at 06:18:43PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> In preparation for moving the XFS writeback code to fs/iomap.c, switch
> it to use struct iomap instead of the XFS-specific struct xfs_bmbt_irec.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |   14 ++++++--
>  fs/xfs/libxfs/xfs_bmap.h |    3 +-
>  fs/xfs/xfs_aops.c        |   82 +++++++++++++++++++++-------------------------
>  fs/xfs/xfs_aops.h        |    2 +
>  4 files changed, 50 insertions(+), 51 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index baf0b72c0a37..2a0d9427a9e2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -34,6 +34,7 @@
>  #include "xfs_ag_resv.h"
>  #include "xfs_refcount.h"
>  #include "xfs_icache.h"
> +#include "xfs_iomap.h"
>  
>  
>  kmem_zone_t		*xfs_bmap_free_item_zone;
> @@ -4452,16 +4453,21 @@ int
>  xfs_bmapi_convert_delalloc(
>  	struct xfs_inode	*ip,
>  	int			whichfork,
> -	xfs_fileoff_t		offset_fsb,
> -	struct xfs_bmbt_irec	*imap,
> +	xfs_off_t		offset,
> +	struct iomap		*iomap,
>  	unsigned int		*seq)
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
>  	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	struct xfs_bmalloca	bma = { NULL };
> +	u16			flags = 0;
>  	struct xfs_trans	*tp;
>  	int			error;
>  
> +	if (whichfork == XFS_COW_FORK)
> +		flags |= IOMAP_F_SHARED;
> +
>  	/*
>  	 * Space for the extent and indirect blocks was reserved when the
>  	 * delalloc extent was created so there's no need to do so here.
> @@ -4491,7 +4497,7 @@ xfs_bmapi_convert_delalloc(
>  	 * the extent.  Just return the real extent at this offset.
>  	 */
>  	if (!isnullstartblock(bma.got.br_startblock)) {
> -		*imap = bma.got;
> +		xfs_bmbt_to_iomap(ip, iomap, &bma.got, flags);
>  		*seq = READ_ONCE(ifp->if_seq);
>  		goto out_trans_cancel;
>  	}
> @@ -4524,7 +4530,7 @@ xfs_bmapi_convert_delalloc(
>  	XFS_STATS_INC(mp, xs_xstrat_quick);
>  
>  	ASSERT(!isnullstartblock(bma.got.br_startblock));
> -	*imap = bma.got;
> +	xfs_bmbt_to_iomap(ip, iomap, &bma.got, flags);
>  	*seq = READ_ONCE(ifp->if_seq);
>  
>  	if (whichfork == XFS_COW_FORK) {
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 8f597f9abdbe..3c3470f11648 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -220,8 +220,7 @@ int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
>  		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
>  		int eof);
>  int	xfs_bmapi_convert_delalloc(struct xfs_inode *ip, int whichfork,
> -		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap,
> -		unsigned int *seq);
> +		xfs_off_t offset, struct iomap *iomap, unsigned int *seq);
>  int	xfs_bmap_add_extent_unwritten_real(struct xfs_trans *tp,
>  		struct xfs_inode *ip, int whichfork,
>  		struct xfs_iext_cursor *icur, struct xfs_btree_cur **curp,
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 4e4a4d7df5ac..8a1cd562a358 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -22,7 +22,7 @@
>   * structure owned by writepages passed to individual writepage calls
>   */
>  struct xfs_writepage_ctx {
> -	struct xfs_bmbt_irec    imap;
> +	struct iomap		iomap;
>  	int			fork;
>  	unsigned int		data_seq;
>  	unsigned int		cow_seq;
> @@ -279,7 +279,7 @@ xfs_end_ioend(
>  	 */
>  	if (ioend->io_fork == XFS_COW_FORK)
>  		error = xfs_reflink_end_cow(ip, offset, size);
> -	else if (ioend->io_state == XFS_EXT_UNWRITTEN)
> +	else if (ioend->io_type == IOMAP_UNWRITTEN)
>  		error = xfs_iomap_write_unwritten(ip, offset, size, false);
>  	else
>  		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_append_trans);
> @@ -303,8 +303,8 @@ xfs_ioend_can_merge(
>  		return false;
>  	if ((ioend->io_fork == XFS_COW_FORK) ^ (next->io_fork == XFS_COW_FORK))
>  		return false;
> -	if ((ioend->io_state == XFS_EXT_UNWRITTEN) ^
> -	    (next->io_state == XFS_EXT_UNWRITTEN))
> +	if ((ioend->io_type == IOMAP_UNWRITTEN) ^
> +	    (next->io_type == IOMAP_UNWRITTEN))
>  		return false;
>  	if (ioend->io_offset + ioend->io_size != next->io_offset)
>  		return false;
> @@ -409,7 +409,7 @@ xfs_end_bio(
>  	unsigned long		flags;
>  
>  	if (ioend->io_fork == XFS_COW_FORK ||
> -	    ioend->io_state == XFS_EXT_UNWRITTEN ||
> +	    ioend->io_type == IOMAP_UNWRITTEN ||
>  	    ioend->io_append_trans != NULL) {
>  		spin_lock_irqsave(&ip->i_ioend_lock, flags);
>  		if (list_empty(&ip->i_ioend_list))
> @@ -429,10 +429,10 @@ static bool
>  xfs_imap_valid(
>  	struct xfs_writepage_ctx	*wpc,
>  	struct xfs_inode		*ip,
> -	xfs_fileoff_t			offset_fsb)
> +	loff_t				offset)
>  {
> -	if (offset_fsb < wpc->imap.br_startoff ||
> -	    offset_fsb >= wpc->imap.br_startoff + wpc->imap.br_blockcount)
> +	if (offset < wpc->iomap.offset ||
> +	    offset >= wpc->iomap.offset + wpc->iomap.length)
>  		return false;
>  	/*
>  	 * If this is a COW mapping, it is sufficient to check that the mapping
> @@ -459,7 +459,7 @@ xfs_imap_valid(
>  
>  /*
>   * Pass in a dellalloc extent and convert it to real extents, return the real
> - * extent that maps offset_fsb in wpc->imap.
> + * extent that maps offset_fsb in wpc->iomap.
>   *
>   * The current page is held locked so nothing could have removed the block
>   * backing offset_fsb, although it could have moved from the COW to the data
> @@ -469,23 +469,23 @@ static int
>  xfs_convert_blocks(
>  	struct xfs_writepage_ctx *wpc,
>  	struct xfs_inode	*ip,
> -	xfs_fileoff_t		offset_fsb)
> +	loff_t			offset)
>  {
>  	int			error;
>  
>  	/*
> -	 * Attempt to allocate whatever delalloc extent currently backs
> -	 * offset_fsb and put the result into wpc->imap.  Allocate in a loop
> -	 * because it may take several attempts to allocate real blocks for a
> -	 * contiguous delalloc extent if free space is sufficiently fragmented.
> +	 * Attempt to allocate whatever delalloc extent currently backs offset
> +	 * and put the result into wpc->imap.  Allocate in a loop because it may
				     ^^^^
			And put the result into wpc->iomap?

> +	 * take several attempts to allocate real blocks for a contiguous
> +	 * delalloc extent if free space is sufficiently fragmented.
>  	 */


Other than the comment nitpick above, patch looks good and you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos
