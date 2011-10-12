Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9C4jqdq038710 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 23:45:53 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 828401BD7A6
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 21:45:50 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id eMp9ptVvhwnFsyP3
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 21:45:50 -0700 (PDT)
Received: by bkbzt12 with SMTP id zt12so599964bkb.26
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 21:45:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110914140826.GA25729@infradead.org>
References: <20110914140826.GA25729@infradead.org>
Date: Wed, 12 Oct 2011 10:15:49 +0530
Message-ID: <CADDb1s1ng_MxC5eQoFoFeU98C4Zsg_JZCgcRWqJaW7ky5Uv47w@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix buffer flushing during unmount
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi Christoph,
Just few minor suggestions to maintain modularity:

On Wed, Sep 14, 2011 at 7:38 PM, Christoph Hellwig <hch@infradead.org> wrot=
e:
> The code to flush buffers in the umount code is a bit iffy: we first flush
> all delwri buffers out, but then might be able to queue up a new one when
> logging the sb counts. =A0On a normal shutdown that one would get flushed
> out when doing the synchronous superblock write in xfs_unmountfs_writesb,
> but we skip that one if the filesystem has been shut down.
>
> Fix this by moving the delwri list flushing until just before unmounting
> the log, and while we're at it also remove the superflous delwri list
> and buffer lru flusing for the rt and log device that can never have
> cached or delwri buffers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> Tested-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
>
> Index: xfs/fs/xfs/xfs_buf.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfs.orig/fs/xfs/xfs_buf.h =A0 2011-09-13 10:55:20.744090516 -0400
> +++ xfs/fs/xfs/xfs_buf.h =A0 =A0 =A0 =A02011-09-13 10:55:52.461091480 -04=
00
> @@ -318,7 +318,6 @@ extern struct list_head *xfs_get_buftarg
> =A0#define xfs_getsize_buftarg(buftarg) =A0 block_size((buftarg)->bt_bdev)
> =A0#define xfs_readonly_buftarg(buftarg) =A0bdev_read_only((buftarg)->bt_=
bdev)
>
> -#define xfs_binval(buftarg) =A0 =A0 =A0 =A0 =A0 =A0xfs_flush_buftarg(buf=
targ, 1)
> =A0#define XFS_bflush(buftarg) =A0 =A0 =A0 =A0 =A0 =A0xfs_flush_buftarg(b=
uftarg, 1)
>
> =A0#endif /* __XFS_BUF_H__ */
> Index: xfs/fs/xfs/xfs_mount.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfs.orig/fs/xfs/xfs_mount.c 2011-09-13 10:55:20.748087866 -0400
> +++ xfs/fs/xfs/xfs_mount.c =A0 =A0 =A02011-09-13 10:56:19.108088343 -0400
> @@ -44,9 +44,6 @@
> =A0#include "xfs_trace.h"
>
>
> -STATIC void =A0 =A0xfs_unmountfs_wait(xfs_mount_t *);
> -
> -
> =A0#ifdef HAVE_PERCPU_SB
> =A0STATIC void =A0 =A0xfs_icsb_balance_counter(xfs_mount_t *, xfs_sb_fiel=
d_t,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0int);
> @@ -1496,11 +1493,6 @@ xfs_unmountfs(
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0xfs_log_force(mp, XFS_LOG_SYNC);
>
> - =A0 =A0 =A0 xfs_binval(mp->m_ddev_targp);
> - =A0 =A0 =A0 if (mp->m_rtdev_targp) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_binval(mp->m_rtdev_targp);
> - =A0 =A0 =A0 }
> -
This is OK.
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Unreserve any blocks we have so that when we unmount we=
 don't account
> =A0 =A0 =A0 =A0 * the reserved free space as used. This is really only ne=
cessary for
> @@ -1526,7 +1518,16 @@ xfs_unmountfs(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xfs_warn(mp, "Unable to update superblock =
counters. "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Freespace=
 may not be correct on next mount.");
> =A0 =A0 =A0 =A0xfs_unmountfs_writesb(mp);
> - =A0 =A0 =A0 xfs_unmountfs_wait(mp); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* =
wait for async bufs */
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Make sure all buffers have been flushed and completed =
before
> + =A0 =A0 =A0 =A0* unmounting the log.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 error =3D xfs_flush_buftarg(mp->m_ddev_targp, 1);
> + =A0 =A0 =A0 if (error)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_warn(mp, "%d busy buffers during unmoun=
t.", error);
> + =A0 =A0 =A0 xfs_wait_buftarg(mp->m_ddev_targp);
> +
instead of removing xfs_unmountfs_wait() altogether, how about keeping
the function and modifying the contents with above changes?
flushing/waiting at this point looks a little out of order.
> =A0 =A0 =A0 =A0xfs_log_unmount_write(mp);
> =A0 =A0 =A0 =A0xfs_log_unmount(mp);
> =A0 =A0 =A0 =A0xfs_uuid_unmount(mp);
> @@ -1537,16 +1538,6 @@ xfs_unmountfs(
> =A0 =A0 =A0 =A0xfs_free_perag(mp);
> =A0}
>
> -STATIC void
> -xfs_unmountfs_wait(xfs_mount_t *mp)
> -{
> - =A0 =A0 =A0 if (mp->m_logdev_targp !=3D mp->m_ddev_targp)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_wait_buftarg(mp->m_logdev_targp);
> - =A0 =A0 =A0 if (mp->m_rtdev_targp)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_wait_buftarg(mp->m_rtdev_targp);
> - =A0 =A0 =A0 xfs_wait_buftarg(mp->m_ddev_targp);
> -}
> -
I mean the above should be like this:
STATIC void
xfs_unmountfs_wait(xfs_mount_t *mp)
{
 +
 +       /*
 +        * Make sure all buffers have been flushed and completed before
 +        * unmounting the log.
 +        */
 +       error =3D xfs_flush_buftarg(mp->m_ddev_targp, 1);
 +       if (error)
 +               xfs_warn(mp, "%d busy buffers during unmount.", error);
 +       xfs_wait_buftarg(mp->m_ddev_targp);
 +
}

> =A0int
> =A0xfs_fs_writable(xfs_mount_t *mp)
> =A0{
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

Regards,
Amit Sahrawat

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
