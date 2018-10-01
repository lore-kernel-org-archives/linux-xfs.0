Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729182AbeJAVFA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 17:05:00 -0400
Date: Mon, 1 Oct 2018 10:26:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/7] xfs: remove the unused trimmed argument from
 xfs_reflink_trim_around_shared
Message-ID: <20181001142653.GG53694@bfoster>
References: <20181001123741.32005-1-hch@lst.de>
 <20181001123741.32005-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001123741.32005-6-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:37:39AM -0700, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_util.c |  4 ++--
>  fs/xfs/xfs_iomap.c     |  5 ++---
>  fs/xfs/xfs_reflink.c   | 15 +++++----------
>  fs/xfs/xfs_reflink.h   |  2 +-
>  4 files changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 6de8d90041ff..8d2579847076 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -406,10 +406,10 @@ xfs_getbmap_report_one(
>  	struct xfs_bmbt_irec	*got)
>  {
>  	struct kgetbmap		*p = out + bmv->bmv_entries;
> -	bool			shared = false, trimmed = false;
> +	bool			shared = false;
>  	int			error;
>  
> -	error = xfs_reflink_trim_around_shared(ip, got, &shared, &trimmed);
> +	error = xfs_reflink_trim_around_shared(ip, got, &shared);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 8ba97e67b474..1224eced1ee4 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1026,7 +1026,7 @@ xfs_file_iomap_begin(
>  	struct xfs_bmbt_irec	imap;
>  	xfs_fileoff_t		offset_fsb, end_fsb;
>  	int			nimaps = 1, error = 0;
> -	bool			shared = false, trimmed = false;
> +	bool			shared = false;
>  	unsigned		lockmode;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
> @@ -1062,8 +1062,7 @@ xfs_file_iomap_begin(
>  
>  	if (flags & IOMAP_REPORT) {
>  		/* Trim the mapping to the nearest shared extent boundary. */
> -		error = xfs_reflink_trim_around_shared(ip, &imap, &shared,
> -				&trimmed);
> +		error = xfs_reflink_trim_around_shared(ip, &imap, &shared);
>  		if (error)
>  			goto out_unlock;
>  	}
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 06e38e88ddee..1e39a7d21c7e 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -182,8 +182,7 @@ int
>  xfs_reflink_trim_around_shared(
>  	struct xfs_inode	*ip,
>  	struct xfs_bmbt_irec	*irec,
> -	bool			*shared,
> -	bool			*trimmed)
> +	bool			*shared)
>  {
>  	xfs_agnumber_t		agno;
>  	xfs_agblock_t		agbno;
> @@ -209,7 +208,7 @@ xfs_reflink_trim_around_shared(
>  	if (error)
>  		return error;
>  
> -	*shared = *trimmed = false;
> +	*shared = false;
>  	if (fbno == NULLAGBLOCK) {
>  		/* No shared blocks at all. */
>  		return 0;
> @@ -222,8 +221,6 @@ xfs_reflink_trim_around_shared(
>  		 */
>  		irec->br_blockcount = flen;
>  		*shared = true;
> -		if (flen != aglen)
> -			*trimmed = true;
>  		return 0;
>  	} else {
>  		/*
> @@ -233,7 +230,6 @@ xfs_reflink_trim_around_shared(
>  		 * start of the shared region.
>  		 */
>  		irec->br_blockcount = fbno - agbno;
> -		*trimmed = true;
>  		return 0;
>  	}
>  }
> @@ -255,7 +251,7 @@ xfs_reflink_reserve_cow(
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>  	struct xfs_bmbt_irec	got;
>  	int			error = 0;
> -	bool			eof = false, trimmed;
> +	bool			eof = false;
>  	struct xfs_iext_cursor	icur;
>  	bool			shared;
>  
> @@ -277,7 +273,7 @@ xfs_reflink_reserve_cow(
>  	}
>  
>  	/* Trim the mapping to the nearest shared extent boundary. */
> -	error = xfs_reflink_trim_around_shared(ip, imap, &shared, &trimmed);
> +	error = xfs_reflink_trim_around_shared(ip, imap, &shared);
>  	if (error)
>  		return error;
>  
> @@ -366,7 +362,6 @@ xfs_find_trim_cow_extent(
>  	xfs_filblks_t		count_fsb = imap->br_blockcount;
>  	struct xfs_iext_cursor	icur;
>  	struct xfs_bmbt_irec	got;
> -	bool			trimmed;
>  
>  	*found = false;
>  
> @@ -376,7 +371,7 @@ xfs_find_trim_cow_extent(
>  	 */
>  	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got) ||
>  	    got.br_startoff > offset_fsb)
> -		return xfs_reflink_trim_around_shared(ip, imap, shared, &trimmed);
> +		return xfs_reflink_trim_around_shared(ip, imap, shared);
>  
>  	*shared = true;
>  	if (isnullstartblock(got.br_startblock)) {
> diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> index b77f4079022a..7f47202b5639 100644
> --- a/fs/xfs/xfs_reflink.h
> +++ b/fs/xfs/xfs_reflink.h
> @@ -10,7 +10,7 @@ extern int xfs_reflink_find_shared(struct xfs_mount *mp, struct xfs_trans *tp,
>  		xfs_agnumber_t agno, xfs_agblock_t agbno, xfs_extlen_t aglen,
>  		xfs_agblock_t *fbno, xfs_extlen_t *flen, bool find_maximal);
>  extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
> -		struct xfs_bmbt_irec *irec, bool *shared, bool *trimmed);
> +		struct xfs_bmbt_irec *irec, bool *shared);
>  
>  extern int xfs_reflink_reserve_cow(struct xfs_inode *ip,
>  		struct xfs_bmbt_irec *imap);
> -- 
> 2.19.0
> 
