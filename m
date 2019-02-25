Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfBYMzE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Feb 2019 07:55:04 -0500
Date: Mon, 25 Feb 2019 07:55:02 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: don't pass iomap flags to
 xfs_reflink_allocate_cow
Message-ID: <20190225125501.GA2916@bfoster>
References: <155104025871.24373.7462613353398620970.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155104025871.24373.7462613353398620970.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Feb 24, 2019 at 12:30:58PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't pass raw iomap flags to xfs_reflink_allocate_cow; signal our
> intention with a boolean argument.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_iomap.c   |    6 +++---
>  fs/xfs/xfs_reflink.c |    4 ++--
>  fs/xfs/xfs_reflink.h |    2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 01210eae8bf3..a376fb2d4b94 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -983,6 +983,7 @@ xfs_file_iomap_begin(
>  	 */
>  	if (xfs_is_cow_inode(ip)) {
>  		struct xfs_bmbt_irec	orig = imap;
> +		bool			convert_now = (flags & IOMAP_DIRECT);
>  
>  		/* if zeroing doesn't need COW allocation, then we are done. */
>  		if ((flags & IOMAP_ZERO) &&
> @@ -991,7 +992,7 @@ xfs_file_iomap_begin(
>  
>  		/* may drop and re-acquire the ilock */
>  		error = xfs_reflink_allocate_cow(ip, &imap, &shared, &lockmode,
> -						 flags);
> +				convert_now);
>  		if (error)
>  			goto out_unlock;
>  
> @@ -1002,8 +1003,7 @@ xfs_file_iomap_begin(
>  		 * direct I/O code, which must be block aligned we need to
>  		 * report the newly allocated address.
>  		 */
> -		if (!(flags & IOMAP_DIRECT) &&
> -		    orig.br_startblock != HOLESTARTBLOCK)
> +		if (!convert_now && orig.br_startblock != HOLESTARTBLOCK)

FWIW, I thought the original dio check made sense here (in the iomap
callback), whereas the flags parameter to the external function seemed
more of a layering hack. Looks fine, anyways:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  			imap = orig;
>  
>  		end_fsb = imap.br_startoff + imap.br_blockcount;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index e2d9179bd50d..d42e3ef9050e 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -361,7 +361,7 @@ xfs_reflink_allocate_cow(
>  	struct xfs_bmbt_irec	*imap,
>  	bool			*shared,
>  	uint			*lockmode,
> -	unsigned		iomap_flags)
> +	bool			convert_now)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	xfs_fileoff_t		offset_fsb = imap->br_startoff;
> @@ -444,7 +444,7 @@ xfs_reflink_allocate_cow(
>  	 * to initiate a disk write.  For direct I/O we are going to write the
>  	 * data and need the conversion, but for buffered writes we're done.
>  	 */
> -	if (!(iomap_flags & IOMAP_DIRECT) || imap->br_state == XFS_EXT_NORM)
> +	if (!convert_now || imap->br_state == XFS_EXT_NORM)
>  		return 0;
>  	trace_xfs_reflink_convert_cow(ip, imap);
>  	return xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index 2a3052fbe23e..28a43b7f581d 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -27,7 +27,7 @@ bool xfs_inode_need_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,
>  
>  extern int xfs_reflink_allocate_cow(struct xfs_inode *ip,
>  		struct xfs_bmbt_irec *imap, bool *shared, uint *lockmode,
> -		unsigned iomap_flags);
> +		bool convert_now);
>  extern int xfs_reflink_convert_cow(struct xfs_inode *ip, xfs_off_t offset,
>  		xfs_off_t count);
>  
> 
