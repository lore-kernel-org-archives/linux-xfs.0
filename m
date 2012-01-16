Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0GMfm6b117775 for <xfs@oss.sgi.com>; Mon, 16 Jan 2012 16:41:48 -0600
Date: Mon, 16 Jan 2012 16:41:47 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 09/11] xfs: remove the i_new_size field in struct xfs_inode
Message-ID: <20120116224147.GC16581@sgi.com>
References: <20111218200003.557507716@bombadil.infradead.org>
	<20111218200132.299481659@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218200132.299481659@bombadil.infradead.org>
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

On Sun, Dec 18, 2011 at 03:00:12PM -0500, Christoph Hellwig wrote:
> Now that we use the VFS i_size field throughout XFS there is no need for the
> i_new_size field any more given that the VFS i_size field gets updated
> in ->write_end before unlocking the page, and thus is a) always uptodate when
> writeback could see a page.  Removing i_new_size also has the advantage that
> we will never have to trim back di_size during a failed buffered write,
> given that it never gets updated past i_size.
> 
> Note that currently the generic direct I/O code only updates i_size after
> calling our end_io handler, which requires a small workaround to make
> sure di_size actually makes it to disk.  I hope to fix this properly in
> the generic code.
> 
> A downside is that we lose the support for parallel non-overlapping O_DIRECT
> appending writes that recently was added.  I don't think keeping the complex
> and fragile i_new_size infrastructure for this is a good tradeoff - if we
> really care about parallel appending writers we should investigate turning
> the iolock into a range lock, which would also allow for parallel
> non-overlapping buffered writers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_aops.c  |   28 +++++++++++---------
>  fs/xfs/xfs_file.c  |   72 +++++++----------------------------------------------
>  fs/xfs/xfs_iget.c  |    1 
>  fs/xfs/xfs_inode.h |    2 -
>  fs/xfs/xfs_trace.h |   18 ++-----------
>  5 files changed, 29 insertions(+), 92 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_file.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_file.c	2011-11-30 12:59:11.669698558 +0100
> +++ xfs/fs/xfs/xfs_file.c	2011-11-30 12:59:13.533021797 +0100
> @@ -413,27 +413,6 @@ xfs_file_splice_read(
>  }
>  
>  /*
> - * If this was a direct or synchronous I/O that failed (such as ENOSPC) then
> - * part of the I/O may have been written to disk before the error occurred.  In
> - * this case the on-disk file size may have been adjusted beyond the in-memory
> - * file size and now needs to be truncated back.
> - */
> -STATIC void
> -xfs_aio_write_newsize_update(
> -	struct xfs_inode	*ip,
> -	xfs_fsize_t		new_size)
> -{
> -	if (new_size == ip->i_new_size) {

Ouch.  If I'm reading this right the behavior prior to this patch is a
little messed up...

xfs_file_aio_write
  new_size = 0
  xfs_file_buffered_aio_write(&new_size
    xfs_file_aio_write_checks - for a non-extending write it won't touch
    				*new_sizep
  generic_file_buffered_write - ...
  xfs_aio_write_isize_update - doesn't touch new_size
  xfs_aio_write_newsize_update:

STATIC void     
xfs_aio_write_newsize_update(
        struct xfs_inode        *ip, 
        xfs_fsize_t             new_size)
{                                               
        if (new_size == ip->i_new_size) {	 <--- 0 == 0 
                xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
                if (new_size == ip->i_new_size) 
                        ip->i_new_size = 0;
                if (ip->i_d.di_size > ip->i_size)
                        ip->i_d.di_size = ip->i_size;
                xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
        }       
}

AFAICT even for non-extending writes we are taking the ilock exclusive
to test (ip->i_d.di_size > ip->i_size).  That does not seem necessary,
correct?

This is not an issue with your patch... I just want to make sure I
understand. 

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
