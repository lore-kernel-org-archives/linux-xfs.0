Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Sep 2007 12:32:12 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.182])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l89JW74p016495
	for <xfs@oss.sgi.com>; Sun, 9 Sep 2007 12:32:09 -0700
Received: by wa-out-1112.google.com with SMTP id k22so1416136waf
        for <xfs@oss.sgi.com>; Sun, 09 Sep 2007 12:32:08 -0700 (PDT)
Message-ID: <cc7060690709091232w4185e788yf8a085e0e67e71e8@mail.gmail.com>
Date: Mon, 10 Sep 2007 01:02:07 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: [PATCH] kill BMAPI_DEVICE
In-Reply-To: <20070909153947.GA19986@lst.de>
MIME-Version: 1.0
References: <20070909153947.GA19986@lst.de>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

XFS_IOCORE_RT |  XFS_DIFLAG_REALTIME can be set from an ioctl (xfs_setattr).
A directIO without holding ILOCK
in shared in mode can read a wrong value of di_flag for real time decision.
As a result, we may pass in-correct device
during directIO as the proposed xfs_find_bdev_for_inode doesn't hold any
lock in reading the flags. It is not based
on iocore flags as well.

On a secondary note, XFS_IOCORE_RT was set without holding iolock which
seems to an issue. I tend to leave
xfs_bmapi to decide BMAPI_DEVICE to xfs_iomap.

What is the reason why this has to be seperated?

Thanks,
-Saradhi.

On 9/9/07, Christoph Hellwig <hch@lst.de> wrote:
>
> There is no reason to go into the iomap machinery just to get the
> right block device for an inode.  Instead look at the realtime flag
> in the inode and grab the right device from the mount structure.
>
> I created a new helper, xfs_find_bdev_for_inode instead of opencoding
> it because I plan to use it in other places in the future.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c      2007-08-23 14:54:
> 01.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c   2007-08-23 14:59:
> 55.000000000 +0200
> @@ -107,6 +107,18 @@ xfs_page_trace(
> #define xfs_page_trace(tag, inode, page, pgoff)
> #endif
>
> +STATIC struct block_device *
> +xfs_find_bdev_for_inode(
> +       struct xfs_inode        *ip)
> +{
> +       struct xfs_mount        *mp = ip->i_mount;
> +
> +       if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
> +               return mp->m_rtdev_targp->bt_bdev;
> +       else
> +               return mp->m_ddev_targp->bt_bdev;
> +}
> +
> /*
>   * Schedule IO completion handling on a xfsdatad if this was
>   * the final hold on this ioend. If we are asked to wait,
> @@ -1476,28 +1488,21 @@ xfs_vm_direct_IO(
> {
>         struct file     *file = iocb->ki_filp;
>         struct inode    *inode = file->f_mapping->host;
> -       xfs_iomap_t     iomap;
> -       int             maps = 1;
> -       int             error;
> +       struct block_device *bdev;
>         ssize_t         ret;
>
> -       error = xfs_bmap(XFS_I(inode), offset, 0,
> -                               BMAPI_DEVICE, &iomap, &maps);
> -       if (error)
> -               return -error;
> +       bdev = xfs_find_bdev_for_inode(XFS_I(inode));
>
>         if (rw == WRITE) {
>                 iocb->private = xfs_alloc_ioend(inode, IOMAP_UNWRITTEN);
>                 ret = blockdev_direct_IO_own_locking(rw, iocb, inode,
> -                       iomap.iomap_target->bt_bdev,
> -                       iov, offset, nr_segs,
> +                       bdev, iov, offset, nr_segs,
>                         xfs_get_blocks_direct,
>                         xfs_end_io_direct);
>         } else {
>                 iocb->private = xfs_alloc_ioend(inode, IOMAP_READ);
>                 ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
> -                       iomap.iomap_target->bt_bdev,
> -                       iov, offset, nr_segs,
> +                       bdev, iov, offset, nr_segs,
>                         xfs_get_blocks_direct,
>                         xfs_end_io_direct);
>         }
> Index: linux-2.6-xfs/fs/xfs/xfs_iomap.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.c       2007-08-23 14:39:
> 45.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_iomap.c    2007-08-23 14:59:55.000000000+0200
> @@ -193,7 +193,7 @@ xfs_iomap(
>
>         switch (flags &
>                 (BMAPI_READ | BMAPI_WRITE | BMAPI_ALLOCATE |
> -                BMAPI_UNWRITTEN | BMAPI_DEVICE)) {
> +                BMAPI_UNWRITTEN)) {
>         case BMAPI_READ:
>                 xfs_iomap_enter_trace(XFS_IOMAP_READ_ENTER, io, offset,
> count);
>                 lockmode = XFS_LCK_MAP_SHARED(mp, io);
> @@ -220,13 +220,6 @@ xfs_iomap(
>                 break;
>         case BMAPI_UNWRITTEN:
>                 goto phase2;
> -       case BMAPI_DEVICE:
> -               lockmode = XFS_LCK_MAP_SHARED(mp, io);
> -               iomapp->iomap_target = io->io_flags & XFS_IOCORE_RT ?
> -                       mp->m_rtdev_targp : mp->m_ddev_targp;
> -               error = 0;
> -               *niomaps = 1;
> -               goto out;
>         default:
>                 BUG();
>         }
> Index: linux-2.6-xfs/fs/xfs/xfs_iomap.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.h       2007-08-23 14:39:
> 45.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_iomap.h    2007-08-23 14:59:55.000000000+0200
> @@ -43,7 +43,6 @@ typedef enum {
>         BMAPI_MMAP = (1 << 6),          /* allocate for mmap write */
>         BMAPI_SYNC = (1 << 7),          /* sync write to flush delalloc
> space */
>         BMAPI_TRYLOCK = (1 << 8),       /* non-blocking request */
> -       BMAPI_DEVICE = (1 << 9),        /* we only want to know the device
> */
> } bmapi_flags_t;
>
>
>
>
>


[[HTML alternate version deleted]]
