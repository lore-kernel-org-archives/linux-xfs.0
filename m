Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 20:03:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O33qNc030436
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 20:03:52 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 953FF9633F9
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 20:05:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id CZpFr2X7AchM6Ofu for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 20:05:25 -0700 (PDT)
Message-ID: <48D9AE73.4000703@sandeen.net>
Date: Tue, 23 Sep 2008 22:05:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix speculative allocation beyond eof
References: <48D85F24.9040305@sgi.com>
In-Reply-To: <48D85F24.9040305@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> Speculative allocation beyond eof doesn't work properly.  It was broken some
> time ago after a code cleanup that moved what is now xfs_iomap_eof_align_last_fsb()
> and xfs_iomap_eof_want_preallocate() out of xfs_iomap_write_delay() into
> separate functions.  The code used to use the current file size in various checks
> but got changed to be max(file_size, i_new_size).  Since i_new_size is the result
> of 'offset + count' then in xfs_iomap_eof_want_preallocate() the check for
> '(offset + count) <= isize' will always be true.
> 
> ie if 'offset + count' is > ip->i_size then isize will be i_new_size and equal to
> 'offset + count'.
> 
> This change fixes all the places that used to use the current file size.

Lachlan, so what's the failure mode?  (is it that we simply don't do
that speculative preallocation anymore due to the problem?)

>From your description of the change above, it seems like you're talking
about:

dd9f438e32900d67def49fa1b8961b3e19b6fefc

[XFS] Implement the di_extsize allocator hint for non-realtime files as
well.  Also provides a mechanism for inheriting this property from the
parent directory for new files.

SGI-PV: 945264
SGI-Modid: xfs-linux-melb:xfs-kern:24367a

Signed-off-by: Nathan Scott <nathans@sgi.com>

but that isn't really a cleanup; and I don't think it changed the isize
behavior.

Was it possibly [XFS] Fix to prevent the notorious 'NULL files' problem
after a crash. that caused the regression?

Thanks,
-Eric

> --- a/fs/xfs/xfs_iomap.c	2008-09-23 12:52:12.000000000 +1000
> +++ b/fs/xfs/xfs_iomap.c	2008-09-23 12:51:29.000000000 +1000
> @@ -290,7 +290,6 @@ STATIC int
>  xfs_iomap_eof_align_last_fsb(
>  	xfs_mount_t	*mp,
>  	xfs_inode_t	*ip,
> -	xfs_fsize_t	isize,
>  	xfs_extlen_t	extsize,
>  	xfs_fileoff_t	*last_fsb)
>  {
> @@ -306,14 +305,14 @@ xfs_iomap_eof_align_last_fsb(
>  	 * stripe width and we are allocating past the allocation eof.
>  	 */
>  	else if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC) &&
> -	        (isize >= XFS_FSB_TO_B(mp, mp->m_swidth)))
> +	        (ip->i_size >= XFS_FSB_TO_B(mp, mp->m_swidth)))
>  		new_last_fsb = roundup_64(*last_fsb, mp->m_swidth);
>  	/*
>  	 * Roundup the allocation request to a stripe unit (m_dalign) boundary
>  	 * if the file size is >= stripe unit size, and we are allocating past
>  	 * the allocation eof.
>  	 */
> -	else if (mp->m_dalign && (isize >= XFS_FSB_TO_B(mp, mp->m_dalign)))
> +	else if (mp->m_dalign && (ip->i_size >= XFS_FSB_TO_B(mp, mp->m_dalign)))
>  		new_last_fsb = roundup_64(*last_fsb, mp->m_dalign);
>  
>  	/*
> @@ -403,7 +402,6 @@ xfs_iomap_write_direct(
>  	xfs_filblks_t	count_fsb, resaligned;
>  	xfs_fsblock_t	firstfsb;
>  	xfs_extlen_t	extsz, temp;
> -	xfs_fsize_t	isize;
>  	int		nimaps;
>  	int		bmapi_flag;
>  	int		quota_flag;
> @@ -426,15 +424,10 @@ xfs_iomap_write_direct(
>  	rt = XFS_IS_REALTIME_INODE(ip);
>  	extsz = xfs_get_extsz_hint(ip);
>  
> -	isize = ip->i_size;
> -	if (ip->i_new_size > isize)
> -		isize = ip->i_new_size;
> -
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  	last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
> -	if ((offset + count) > isize) {
> -		error = xfs_iomap_eof_align_last_fsb(mp, ip, isize, extsz,
> -							&last_fsb);
> +	if ((offset + count) > ip->i_size) {
> +		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
>  		if (error)
>  			goto error_out;
>  	} else {
> @@ -559,7 +552,6 @@ STATIC int
>  xfs_iomap_eof_want_preallocate(
>  	xfs_mount_t	*mp,
>  	xfs_inode_t	*ip,
> -	xfs_fsize_t	isize,
>  	xfs_off_t	offset,
>  	size_t		count,
>  	int		ioflag,
> @@ -573,7 +565,7 @@ xfs_iomap_eof_want_preallocate(
>  	int		n, error, imaps;
>  
>  	*prealloc = 0;
> -	if ((ioflag & BMAPI_SYNC) || (offset + count) <= isize)
> +	if ((ioflag & BMAPI_SYNC) || (offset + count) <= ip->i_size)
>  		return 0;
>  
>  	/*
> @@ -617,7 +609,6 @@ xfs_iomap_write_delay(
>  	xfs_fileoff_t	ioalign;
>  	xfs_fsblock_t	firstblock;
>  	xfs_extlen_t	extsz;
> -	xfs_fsize_t	isize;
>  	int		nimaps;
>  	xfs_bmbt_irec_t imap[XFS_WRITE_IMAPS];
>  	int		prealloc, fsynced = 0;
> @@ -637,11 +628,7 @@ xfs_iomap_write_delay(
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  
>  retry:
> -	isize = ip->i_size;
> -	if (ip->i_new_size > isize)
> -		isize = ip->i_new_size;
> -
> -	error = xfs_iomap_eof_want_preallocate(mp, ip, isize, offset, count,
> +	error = xfs_iomap_eof_want_preallocate(mp, ip, offset, count,
>  				ioflag, imap, XFS_WRITE_IMAPS, &prealloc);
>  	if (error)
>  		return error;
> @@ -655,8 +642,7 @@ retry:
>  	}
>  
>  	if (prealloc || extsz) {
> -		error = xfs_iomap_eof_align_last_fsb(mp, ip, isize, extsz,
> -							&last_fsb);
> +		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
>  		if (error)
>  			return error;
>  	}
> 
> 
