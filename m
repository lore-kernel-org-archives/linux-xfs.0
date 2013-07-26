Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D13F17F50
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 16:58:20 -0500 (CDT)
Date: Fri, 26 Jul 2013 16:58:20 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 22/48] xfsprogs: Add verifiers to libxfs buffer interfaces.
Message-ID: <20130726215820.GN3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-23-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-23-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave,

On Fri, Jun 07, 2013 at 10:25:45AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Verifiers need to be used everywhere to enable calculation of CRCs
> during writeback of modified metadata. Add then to the libxfs buffer
> interfaces conver the internal use of devices to be buftarg aware.
> 
> Verifiers also require that the buffer has a back pointer to the
> struct xfs_mount. To make this source level comaptible between
> kernel and userspace, convert userspace to pass struct xfs_buftargs
> around rather than a "device".
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>


> @@ -507,7 +527,7 @@ typedef struct xfs_inode {
>  	xfs_mount_t		*i_mount;	/* fs mount struct ptr */
>  	xfs_ino_t		i_ino;		/* inode number (agno/agino) */
>  	struct xfs_imap		i_imap;		/* location for xfs_imap() */
> -	dev_t			i_dev;		/* dev for this inode */
> +	struct xfs_buftarg			i_dev;		/* dev for this inode */

Got a little jumpy with the tabs there...

> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index e9cc7b1..f91a5d0 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -200,12 +200,15 @@ libxfs_log_header(
>  #undef libxfs_getbuf_flags
>  #undef libxfs_putbuf
>  
> -xfs_buf_t	*libxfs_readbuf(dev_t, xfs_daddr_t, int, int);
> -xfs_buf_t	*libxfs_readbuf_map(dev_t, struct xfs_buf_map *, int, int);
> +xfs_buf_t	*libxfs_readbuf(struct xfs_buftarg *, xfs_daddr_t, int, int,
> +				const struct xfs_buf_map *);

				const struct xfs_buf_ops *);

> +xfs_buf_t	*libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
> +				int, int, const struct xfs_buf_map *);

					  const struct xfs_buf_ops *);

> @@ -612,9 +622,9 @@ libxfs_purgebuf(xfs_buf_t *bp)
>  {
>  	struct xfs_bufkey key = {0};
>  
> -	key.device = bp->b_dev;
> +	key.buftarg = bp->b_target;
>  	key.blkno = bp->b_bn;
> -	key.bblen = bp->b_bcount >> BBSHIFT;
> +	key.bblen = bp->b_length;

Why was this change necessary?  b_bcount to b_length?  It doesn't seem to be
related to the rest of the patch.

> @@ -767,9 +803,42 @@ __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
>  int
>  libxfs_writebufr(xfs_buf_t *bp)
>  {
> -	int	fd = libxfs_device_to_fd(bp->b_dev);
> +	int	fd = libxfs_device_to_fd(bp->b_target->dev);
>  	int	error = 0;
>  
> +	/*
> +	 * we never write buffers that are marked stale. This indicates they
> +	 * contain data that has been invalidated, and even if the buffer is
> +	 * dirty it must *never* be written. Verifiers are wonderful for finding
> +	 * bugs like this. Make sure the error is obvious as to the cause.
> +	 */
> +	if (bp->b_flags & LIBXFS_B_STALE) {
> +		bp->b_error = ESTALE;
> +		return bp->b_error;
> +	}

What led to this?

> +
> +	/*
> +	 * clear any pre-existing error status on the buffer. This can occur if
> +	 * the buffer is corrupt on disk and the repair process doesn't clear
> +	 * the error before fixing and writing it back.
> +	 */
> +	bp->b_error = 0;
> +	if (bp->b_ops) {
> +		bp->b_ops->verify_write(bp);
> +		if (bp->b_error) {
> +			fprintf(stderr,
> +	_("%s: write verifer failed on bno 0x%llx/0x%x\n"),
> +				__func__, (long long)bp->b_bn, bp->b_bcount);
> +			return bp->b_error;
> +		}
> +	}
> +
> +	if (bp->b_ops) {
> +		bp->b_ops->verify_write(bp);
> +		if (bp->b_error)
> +			return bp->b_error;
> +	}
> +

Calling the verifier twice?  Maybe I'm seeing double again...

> @@ -187,11 +184,7 @@ roundup_pow_of_two(uint v)
>  	NULL;						\
>  })
>  #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
> -#define xfs_read_buf(mp,devp,blkno,len,f,bpp)	\
> -					(*(bpp) = libxfs_readbuf((devp), \
> -							(blkno), (len), 1), 0)

Yeah, nobody is using this macro anymore.

> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a393607..3864932 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2487,13 +2488,19 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>  		exit(1);
>  	}
>  
> +	/*
> +	 * XXX: this code is effectively shared with the kernel growfs code.
> +	 * These initialisations should be pulled into libxfs to keep the
> +	 * kernel/userspace header initialisation code the same.
> +	 */
>  	for (agno = 0; agno < agcount; agno++) {

Nice idea.

>  		/*
>  		 * Superblock.
>  		 */
> -		buf = libxfs_getbuf(xi.ddev,
> +		buf = libxfs_getbuf(mp->m_ddev_targp,
>  				XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
>  				XFS_FSS_TO_BB(mp, 1));
> +		buf->b_ops = &xfs_sb_buf_ops;
>  		memset(XFS_BUF_PTR(buf), 0, sectorsize);
>  		libxfs_sb_to_disk((void *)XFS_BUF_PTR(buf), sbp, XFS_SB_ALL_BITS);
>  		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);

...

> @@ -1353,7 +1353,8 @@ scan_ags(
>  	}
>  	memset(agcnts, 0, mp->m_sb.sb_agcount * sizeof(*agcnts));
>  
> -	create_work_queue(&wq, mp, scan_threads);
> +	create_work_queue(&wq, mp, 1);
> +	//create_work_queue(&wq, mp, scan_threads);

What's this all about?  Were you having trouble with a multithreaded scan?

Looks fine for the most part...  I did get a little uncomfortable with using
verifiers on reads in repair.  Not sure whether setting b_error = EFSCORRUPTED
would have ill effect later.

Reviewed-by: Ben Myers <bpm@sgi.com>

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
