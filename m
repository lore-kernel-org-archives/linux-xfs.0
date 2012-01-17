Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0HKIJUw175049 for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 14:18:19 -0600
Date: Tue, 17 Jan 2012 14:18:17 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 10/11] xfs: always return with the iolock held from
	xfs_file_aio_write_checks
Message-ID: <20120117201817.GG16581@sgi.com>
References: <20111218200003.557507716@bombadil.infradead.org>
	<20111218200132.483776880@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218200132.483776880@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Dec 18, 2011 at 03:00:13PM -0500, Christoph Hellwig wrote:
> While xfs_iunlock is fine with 0 lockflags the calling conventions are much
> cleaner if xfs_file_aio_write_checks never returns without the iolock held.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

> 
> ---
>  fs/xfs/xfs_file.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_file.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_file.c	2011-12-07 12:46:31.343897882 +0100
> +++ xfs/fs/xfs/xfs_file.c	2011-12-07 12:48:33.309903801 +0100
> @@ -636,7 +636,9 @@ out_lock:
>  /*
>   * Common pre-write limit and setup checks.
>   *
> - * Returns with iolock held according to @iolock.
> + * Called with the iolocked held either shared and exclusive according to
> + * @iolock, and returns with it held.  Might upgrade the iolock to exclusive
> + * if called for a direct write beyond i_size.
>   */
>  STATIC ssize_t
>  xfs_file_aio_write_checks(
> @@ -653,8 +655,7 @@ xfs_file_aio_write_checks(
>  restart:
>  	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
>  	if (error) {
> -		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
> -		*iolock = 0;
> +		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
>  		return error;
>  	}
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
