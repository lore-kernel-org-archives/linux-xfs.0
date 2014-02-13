Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B94D57F55
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 15:50:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 800CD8F8037
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 13:50:06 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id D7qQQOMTNWPuqJDp for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 13:50:01 -0800 (PST)
Message-ID: <52FD3E08.8010500@sandeen.net>
Date: Thu, 13 Feb 2014 15:50:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: skip verification on initial "guess" superblock read
References: <52FD3C59.3050400@redhat.com>
In-Reply-To: <52FD3C59.3050400@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Note, this one might need to be in 3.14 fixes as well, if

[PATCH] xfs: xfs_sb_read_verify() doesn't flag bad crcs on primary sb

is queued up; with that patch in place, we'll fail mounting
i.e. a 4K sector size FS on a 512 sector disk, because we'll
try to do a 4K metadata checksum on a 512 byte buffer...  :/

I had thought about just skipping the CRC if BBTOB(bp->b_length) !=
sb->sb_sectsize, but it seemed like other superblock read paths
would wind up skipping CRCs based what would be corruption.

By doing this (ugly?) no-op verifier, at least this first
(short?) sb read is under complete control, with no guessing required
in the normal verifier.

-Eric

On 2/13/14, 3:42 PM, Eric Sandeen wrote:
> When xfs_readsb() does the very first read of the superblock,
> it makes a guess at the length of the buffer, based on the
> sector size of the underlying storage.  This may or may
> not match the filesystem sector size in sb_sectsize, so
> we can't i.e. do a CRC check on it; it might be too short.
> 
> In fact, mounting a filesystem with sb_sectsize larger
> than the device sector size will cause a mount failure
> if CRCs are enabled, because we are checksumming a length
> which exceeds the buffer passed to it.
> 
> The only really foolproof way I see around this is to
> *always* read the superblock twice in xfs_readsb();
> first with a guess, and again with a length as indicated
> by the superblock's sb_sectsize.  The verifier for
> this guessed length buffer is a no-op; we'll do proper
> verification on the 2nd time around.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 02df7b4..b4413fe 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -282,22 +282,28 @@ xfs_readsb(
>  	struct xfs_sb	*sbp = &mp->m_sb;
>  	int		error;
>  	int		loud = !(flags & XFS_MFSI_QUIET);
> +	const struct xfs_buf_ops *buf_ops;
>  
>  	ASSERT(mp->m_sb_bp == NULL);
>  	ASSERT(mp->m_ddev_targp != NULL);
>  
>  	/*
> +	 * For the initial read, we must guess at the sector
> +	 * size based on the block device.  It's enough to
> +	 * get the sb_sectsize out of the superblock and
> +	 * then reread with the proper length.
> +	 */
> +	sector_size = xfs_getsize_buftarg(mp->m_ddev_targp);
> +	buf_ops = &xfs_sb_guess_buf_ops;
> +
> +	/*
>  	 * Allocate a (locked) buffer to hold the superblock.
>  	 * This will be kept around at all times to optimize
>  	 * access to the superblock.
>  	 */
> -	sector_size = xfs_getsize_buftarg(mp->m_ddev_targp);
> -
>  reread:
>  	bp = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
> -				   BTOBB(sector_size), 0,
> -				   loud ? &xfs_sb_buf_ops
> -				        : &xfs_sb_quiet_buf_ops);
> +				   BTOBB(sector_size), 0, buf_ops);
>  	if (!bp) {
>  		if (loud)
>  			xfs_warn(mp, "SB buffer read failed");
> @@ -328,12 +334,13 @@ reread:
>  	}
>  
>  	/*
> -	 * If device sector size is smaller than the superblock size,
> -	 * re-read the superblock so the buffer is correctly sized.
> +	 * Re-read the superblock so the buffer is correctly sized,
> +	 * and properly verified.
>  	 */
> -	if (sector_size < sbp->sb_sectsize) {
> +	if (buf_ops == &xfs_sb_guess_buf_ops) {
>  		xfs_buf_relse(bp);
>  		sector_size = sbp->sb_sectsize;
> +		buf_ops = loud ? &xfs_sb_buf_ops : &xfs_sb_quiet_buf_ops;
>  		goto reread;
>  	}
>  
> diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
> index 5071ccb..abbbbb7 100644
> --- a/fs/xfs/xfs_sb.c
> +++ b/fs/xfs/xfs_sb.c
> @@ -653,6 +653,20 @@ xfs_sb_quiet_read_verify(
>  	/* quietly fail */
>  	xfs_buf_ioerror(bp, EWRONGFS);
>  }
> +/*
> + * The initial superblock read from xfs_readsb only guesses at
> + * the sector size based on the block device sector size, so
> + * we may get here with a buffer length shorter than the filesystem
> + * sb_sectsize.  We can't properly verify it, so just return,
> + * and xfs_readsb will call the proper verifer with a real length
> + * on the 2nd time around.
> + */
> +static void
> +xfs_sb_guess_read_verify(
> +	struct xfs_buf	*bp)
> +{
> +	return;
> +}
>  
>  static void
>  xfs_sb_write_verify(
> @@ -680,16 +694,24 @@ xfs_sb_write_verify(
>  			 offsetof(struct xfs_sb, sb_crc));
>  }
>  
> +/* Normal read verifier */
>  const struct xfs_buf_ops xfs_sb_buf_ops = {
>  	.verify_read = xfs_sb_read_verify,
>  	.verify_write = xfs_sb_write_verify,
>  };
>  
> +/* Quiet verifier for MS_SILENT mounts; ignore non-XFS magic */
>  const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
>  	.verify_read = xfs_sb_quiet_read_verify,
>  	.verify_write = xfs_sb_write_verify,
>  };
>  
> +/* The very first superblock read must guess at the size */
> +const struct xfs_buf_ops xfs_sb_guess_buf_ops = {
> +	.verify_read = xfs_sb_guess_read_verify,
> +	.verify_write = xfs_sb_write_verify,
> +};
> +
>  /*
>   * xfs_mount_common
>   *
> diff --git a/fs/xfs/xfs_shared.h b/fs/xfs/xfs_shared.h
> index 8c5035a..a4294a6 100644
> --- a/fs/xfs/xfs_shared.h
> +++ b/fs/xfs/xfs_shared.h
> @@ -51,6 +51,7 @@ extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
>  extern const struct xfs_buf_ops xfs_dquot_buf_ops;
>  extern const struct xfs_buf_ops xfs_sb_buf_ops;
>  extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
> +extern const struct xfs_buf_ops xfs_sb_guess_buf_ops;
>  extern const struct xfs_buf_ops xfs_symlink_buf_ops;
>  
>  /*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
