Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727157AbeIZVaw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Sep 2018 17:30:52 -0400
Date: Wed, 26 Sep 2018 11:17:24 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/10] xfs: handle extent size hints in
 xfs_file_iomap_begin_delay
Message-ID: <20180926151723.GB899@bfoster>
References: <20180917205354.15401-1-hch@lst.de>
 <20180917205354.15401-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180917205354.15401-8-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 17, 2018 at 10:53:51PM +0200, Christoph Hellwig wrote:
> For files with extent size hints we always allocate unwritten extents
> first and then convert them to real extents later to avoid exposing
> stale data outside the blocks actually written.  But there is no
> reason we can't do unwritten extent allocations from delalloc blocks,
> in fact we already do that for COW operations.
> 
> Note that this does not handle files on the RT subvolume (yet), as
> we removed code handling RT allocations from the delalloc path this
> would be a slightly bigger project, and it doesn't really help with
> simplifying the COW path either.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_iomap.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e12ff5e9a8ec..2d08ace09e25 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -533,7 +533,6 @@ xfs_file_iomap_begin_delay(
>  	xfs_fsblock_t		prealloc_blocks = 0;
>  
>  	ASSERT(!XFS_IS_REALTIME_INODE(ip));
> -	ASSERT(!xfs_get_extsz_hint(ip));
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
> @@ -1035,7 +1034,7 @@ xfs_file_iomap_begin(
>  		return -EIO;
>  
>  	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && !(flags & IOMAP_DIRECT) &&
> -			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
> +			!IS_DAX(inode) && !XFS_IS_REALTIME_INODE(ip)) {

AFAICT this fails to honor the extent size hint for buffered writes:

# xfs_io -fc "truncate 1m" -c "extsize 32k" -c "pwrite 0 4k" -c "fiemap -v" /mnt/file
wrote 4096/4096 bytes at offset 0
4 KiB, 1 ops; 0.0001 sec (35.511 MiB/sec and 9090.9091 ops/sec)
/mnt/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..7]:          80..87               8   0x1
   1: [8..2047]:       hole              2040

... and with an unpatched kernel:

# xfs_io -fc "truncate 1m" -c "extsize 32k" -c "pwrite 0 4k" -c "fiemap -v" /mnt/file                                                                                                                                       
wrote 4096/4096 bytes at offset 0
4 KiB, 1 ops; 0.0017 sec (2.283 MiB/sec and 584.4535 ops/sec)
/mnt/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..7]:          192..199             8   0x0
   1: [8..63]:         200..255            56 0x801
   2: [64..2047]:      hole              1984

I'd guess this is due to the extent overlap check in
xfs_bmap_extsize_align(), but I haven't verified.

Brian

>  		/* Reserve delalloc blocks for regular writeback. */
>  		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
>  				iomap);
> @@ -1088,17 +1087,9 @@ xfs_file_iomap_begin(
>  	 * been done up front, so we don't need to do them here.
>  	 */
>  	if (xfs_is_reflink_inode(ip)) {
> -		if (flags & IOMAP_DIRECT) {
> -			/* may drop and re-acquire the ilock */
> -			error = xfs_reflink_allocate_cow(ip, &imap, &shared,
> -					&lockmode);
> -			if (error)
> -				goto out_unlock;
> -		} else {
> -			error = xfs_reflink_reserve_cow(ip, &imap, &shared);
> -			if (error)
> -				goto out_unlock;
> -		}
> +		error = xfs_reflink_allocate_cow(ip, &imap, &shared, &lockmode);
> +		if (error)
> +			goto out_unlock;
>  
>  		end_fsb = imap.br_startoff + imap.br_blockcount;
>  		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
> -- 
> 2.18.0
> 
