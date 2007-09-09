Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Sep 2007 12:34:58 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.181])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l89JYs4p017058
	for <xfs@oss.sgi.com>; Sun, 9 Sep 2007 12:34:55 -0700
Received: by wa-out-1112.google.com with SMTP id k22so1416783waf
        for <xfs@oss.sgi.com>; Sun, 09 Sep 2007 12:34:56 -0700 (PDT)
Message-ID: <cc7060690709091234r115e793p9cc491104862a5cd@mail.gmail.com>
Date: Mon, 10 Sep 2007 01:04:55 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: [PATCH] kill BMAPI_UNWRITTEN
In-Reply-To: <20070909154103.GB19986@lst.de>
MIME-Version: 1.0
References: <20070909154103.GB19986@lst.de>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

The reason for eliminating BMAPI_UNWRITTEN is not clear. It is ideal to keep
all the block map
interfaces and information to go through xfs_iomap, xfs_bmapi functionality.

 Thanks,
-Saradhi.

On 9/9/07, Christoph Hellwig <hch@lst.de> wrote:
>
> There is no reason to go through xfs_iomap for the BMAPI_UNWRITTEN
> because it has nothing in common with the other cases.  Instead
> check for the shutdown filesystem in xfs_end_bio_unwritten and perform
> a direct call to xfs_iomap_write_unwritten (which should be renamed
> to something more sensible one day)
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c      2007-09-06 10:18:
> 05.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c   2007-09-06 10:18:
> 05.000000000 +0200
> @@ -237,12 +237,13 @@ xfs_end_bio_unwritten(
> {
>         xfs_ioend_t             *ioend =
>                 container_of(work, xfs_ioend_t, io_work);
> +       struct xfs_inode        *ip = XFS_I(ioend->io_inode);
>         xfs_off_t               offset = ioend->io_offset;
>         size_t                  size = ioend->io_size;
>
>         if (likely(!ioend->io_error)) {
> -               xfs_bmap(XFS_I(ioend->io_inode), offset, size,
> -                               BMAPI_UNWRITTEN, NULL, NULL);
> +               if (!XFS_FORCED_SHUTDOWN(ip->i_mount))
> +                       xfs_iomap_write_unwritten(ip, offset, size);
>                 xfs_setfilesize(ioend);
>         }
>         xfs_destroy_ioend(ioend);
> Index: linux-2.6-xfs/fs/xfs/xfs_iomap.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.c       2007-09-06 10:18:
> 05.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_iomap.c    2007-09-06 10:18:05.000000000+0200
> @@ -191,9 +191,7 @@ xfs_iomap(
>         if (XFS_FORCED_SHUTDOWN(mp))
>                 return XFS_ERROR(EIO);
>
> -       switch (flags &
> -               (BMAPI_READ | BMAPI_WRITE | BMAPI_ALLOCATE |
> -                BMAPI_UNWRITTEN)) {
> +       switch (flags & (BMAPI_READ | BMAPI_WRITE | BMAPI_ALLOCATE)) {
>         case BMAPI_READ:
>                 xfs_iomap_enter_trace(XFS_IOMAP_READ_ENTER, io, offset,
> count);
>                 lockmode = XFS_LCK_MAP_SHARED(mp, io);
> @@ -218,8 +216,6 @@ xfs_iomap(
>                         XFS_ILOCK(mp, io, lockmode);
>                 }
>                 break;
> -       case BMAPI_UNWRITTEN:
> -               goto phase2;
>         default:
>                 BUG();
>         }
> @@ -238,8 +234,7 @@ xfs_iomap(
>         if (error)
>                 goto out;
>
> -phase2:
> -       switch (flags & (BMAPI_WRITE|BMAPI_ALLOCATE|BMAPI_UNWRITTEN)) {
> +       switch (flags & (BMAPI_WRITE|BMAPI_ALLOCATE)) {
>         case BMAPI_WRITE:
>                 /* If we found an extent, return it */
>                 if (nimaps &&
> @@ -277,11 +272,6 @@ phase2:
>                 error = XFS_IOMAP_WRITE_ALLOCATE(mp, io, offset, count,
>                                                  &imap, &nimaps);
>                 break;
> -       case BMAPI_UNWRITTEN:
> -               lockmode = 0;
> -               error = XFS_IOMAP_WRITE_UNWRITTEN(mp, io, offset, count);
> -               nimaps = 0;
> -               break;
>         }
>
>         if (nimaps) {
> Index: linux-2.6-xfs/fs/xfs/xfs_iomap.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.h       2007-09-06 10:18:
> 05.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_iomap.h    2007-09-06 10:18:05.000000000+0200
> @@ -36,7 +36,6 @@ typedef enum {
>         BMAPI_READ = (1 << 0),          /* read extents */
>         BMAPI_WRITE = (1 << 1),         /* create extents */
>         BMAPI_ALLOCATE = (1 << 2),      /* delayed allocate to real
> extents */
> -       BMAPI_UNWRITTEN  = (1 << 3),    /* unwritten extents to real
> extents */
>         /* modifiers */
>         BMAPI_IGNSTATE = (1 << 4),      /* ignore unwritten state on read
> */
>         BMAPI_DIRECT = (1 << 5),        /* direct instead of buffered
> write */
>
>
>


[[HTML alternate version deleted]]
