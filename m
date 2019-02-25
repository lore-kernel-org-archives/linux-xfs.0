Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726965AbfBYMzL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Feb 2019 07:55:11 -0500
Date: Mon, 25 Feb 2019 07:55:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: rework breaking of shared extents in
 xfs_file_iomap_begin
Message-ID: <20190225125508.GB2916@bfoster>
References: <155104025871.24373.7462613353398620970.stgit@magnolia>
 <155104026500.24373.14839198455533713908.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155104026500.24373.14839198455533713908.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Feb 24, 2019 at 12:31:05PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rework the data flow in xfs_file_iomap_begin where we decide if we have
> to break shared extents.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iomap.c |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index a376fb2d4b94..a3043b1bcd9a 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -982,7 +982,7 @@ xfs_file_iomap_begin(
>  	 * been done up front, so we don't need to do them here.
>  	 */
>  	if (xfs_is_cow_inode(ip)) {
> -		struct xfs_bmbt_irec	orig = imap;
> +		struct xfs_bmbt_irec	cmap;
>  		bool			convert_now = (flags & IOMAP_DIRECT);
>  
>  		/* if zeroing doesn't need COW allocation, then we are done. */
> @@ -991,7 +991,8 @@ xfs_file_iomap_begin(
>  			goto out_found;
>  
>  		/* may drop and re-acquire the ilock */
> -		error = xfs_reflink_allocate_cow(ip, &imap, &shared, &lockmode,
> +		cmap = imap;
> +		error = xfs_reflink_allocate_cow(ip, &cmap, &shared, &lockmode,
>  				convert_now);
>  		if (error)
>  			goto out_unlock;
> @@ -1001,10 +1002,12 @@ xfs_file_iomap_begin(
>  		 * previous block (if there was any) so that the higher level
>  		 * write code can perform read-modify-write operations.  For
>  		 * direct I/O code, which must be block aligned we need to
> -		 * report the newly allocated address.
> +		 * report the newly allocated address.  If the data fork has
> +		 * a hole, copy the COW fork mapping to avoid allocating to
> +		 * the data fork.
>  		 */
> -		if (!convert_now && orig.br_startblock != HOLESTARTBLOCK)
> -			imap = orig;
> +		if (convert_now || imap.br_startblock == HOLESTARTBLOCK)
> +			imap = cmap;
>  
>  		end_fsb = imap.br_startoff + imap.br_blockcount;
>  		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
> 
