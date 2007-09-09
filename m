Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Sep 2007 12:43:05 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.176])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l89Jh04p018195
	for <xfs@oss.sgi.com>; Sun, 9 Sep 2007 12:43:01 -0700
Received: by wa-out-1112.google.com with SMTP id k22so1418612waf
        for <xfs@oss.sgi.com>; Sun, 09 Sep 2007 12:43:01 -0700 (PDT)
Message-ID: <cc7060690709091243y4caab0fat85f189d7ce4d6b31@mail.gmail.com>
Date: Mon, 10 Sep 2007 01:13:01 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: [PATCH] remove dead SYNC_BDFLUSH case in xfs_sync_inodes
In-Reply-To: <20070909154220.GC19986@lst.de>
MIME-Version: 1.0
References: <20070909154220.GC19986@lst.de>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

vfs_sync_worker calls with SYNC_BDFLUSH. xfssyncd can call this. I might be
missing something
if this is not used.

Thanks,
-Saradhi.

On 9/9/07, Christoph Hellwig <hch@lst.de> wrote:
>
> A large part of xfs_sync_inodes is conditional on the SYNC_BDFLUSH which
> is never passed to it.  This patch removes it and adds an assert that
> triggers in case some new code tries to pass SYNC_BDFLUSH to it.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c      2007-09-08 17:43:
> 39.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c   2007-09-08 19:06:31.000000000+0200
> @@ -981,8 +981,6 @@ xfs_sync_inodes(
>         int             *bypassed)
> {
>         xfs_inode_t     *ip = NULL;
> -       xfs_inode_t     *ip_next;
> -       xfs_buf_t       *bp;
>         bhv_vnode_t     *vp = NULL;
>         int             error;
>         int             last_error;
> @@ -992,7 +990,6 @@ xfs_sync_inodes(
>         boolean_t       mount_locked;
>         boolean_t       vnode_refed;
>         int             preempt;
> -       xfs_dinode_t    *dip;
>         xfs_iptr_t      *ipointer;
> #ifdef DEBUG
>         boolean_t       ipointer_in = B_FALSE;
> @@ -1045,6 +1042,8 @@ xfs_sync_inodes(
>
> #define XFS_PREEMPT_MASK       0x7f
>
> +       ASSERT(!(flags & SYNC_BDFLUSH));
> +
>         if (bypassed)
>                 *bypassed = 0;
>         if (mp->m_flags & XFS_MOUNT_RDONLY)
> @@ -1057,7 +1056,7 @@ xfs_sync_inodes(
>         ipointer = (xfs_iptr_t *)kmem_zalloc(sizeof(xfs_iptr_t),
> KM_SLEEP);
>
>         fflag = XFS_B_ASYNC;            /* default is don't wait */
> -       if (flags & (SYNC_BDFLUSH | SYNC_DELWRI))
> +       if (flags & SYNC_DELWRI)
>                 fflag = XFS_B_DELWRI;
>         if (flags & SYNC_WAIT)
>                 fflag = 0;              /* synchronous overrides all */
> @@ -1147,24 +1146,6 @@ xfs_sync_inodes(
>                 }
>
>                 /*
> -                * If this is just vfs_sync() or pflushd() calling
> -                * then we can skip inodes for which it looks like
> -                * there is nothing to do.  Since we don't have the
> -                * inode locked this is racy, but these are periodic
> -                * calls so it doesn't matter.  For the others we want
> -                * to know for sure, so we at least try to lock them.
> -                */
> -               if (flags & SYNC_BDFLUSH) {
> -                       if (((ip->i_itemp == NULL) ||
> -                            !(ip->i_itemp->ili_format.ilf_fields &
> -                              XFS_ILOG_ALL)) &&
> -                           (ip->i_update_core == 0)) {
> -                               ip = ip->i_mnext;
> -                               continue;
> -                       }
> -               }
> -
> -               /*
>                  * Try to lock without sleeping.  We're out of order with
>                  * the inode list lock here, so if we fail we need to drop
>                  * the mount lock and try again.  If we're called from
> @@ -1181,7 +1162,7 @@ xfs_sync_inodes(
>                  * it.
>                  */
>                 if (xfs_ilock_nowait(ip, lock_flags) == 0) {
> -                       if ((flags & SYNC_BDFLUSH) || (vp == NULL)) {
> +                       if (vp == NULL) {
>                                 ip = ip->i_mnext;
>                                 continue;
>                         }
> @@ -1242,160 +1223,27 @@ xfs_sync_inodes(
>                         xfs_ilock(ip, XFS_ILOCK_SHARED);
>                 }
>
> -               if (flags & SYNC_BDFLUSH) {
> -                       if ((flags & SYNC_ATTR) &&
> -                           ((ip->i_update_core) ||
> -                            ((ip->i_itemp != NULL) &&
> -                             (ip->i_itemp->ili_format.ilf_fields != 0))))
> {
> -
> -                               /* Insert marker and drop lock if not
> already
> -                                * done.
> -                                */
> -                               if (mount_locked) {
> -                                       IPOINTER_INSERT(ip, mp);
> -                               }
> -
> -                               /*
> -                                * We don't want the periodic flushing of
> the
> -                                * inodes by vfs_sync() to interfere with
> -                                * I/O to the file, especially read I/O
> -                                * where it is only the access time stamp
> -                                * that is being flushed out.  To prevent
> -                                * long periods where we have both inode
> -                                * locks held shared here while reading
> the
> -                                * inode's buffer in from disk, we drop
> the
> -                                * inode lock while reading in the inode
> -                                * buffer.  We have to release the buffer
> -                                * and reacquire the inode lock so that
> they
> -                                * are acquired in the proper order (inode
> -                                * locks first).  The buffer will go at
> the
> -                                * end of the lru chain, though, so we can
> -                                * expect it to still be there when we go
> -                                * for it again in xfs_iflush().
> -                                */
> -                               if ((xfs_ipincount(ip) == 0) &&
> -                                   xfs_iflock_nowait(ip)) {
> -
> -                                       xfs_ifunlock(ip);
> -                                       xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -
> -                                       error = xfs_itobp(mp, NULL, ip,
> -                                                         &dip, &bp, 0,
> 0);
> -                                       if (!error) {
> -                                               xfs_buf_relse(bp);
> -                                       } else {
> -                                               /* Bailing out, remove the
> -                                                * marker and free it.
> -                                                */
> -                                               XFS_MOUNT_ILOCK(mp);
> -                                               IPOINTER_REMOVE(ip, mp);
> -                                               XFS_MOUNT_IUNLOCK(mp);
> -
> -                                               ASSERT(!(lock_flags &
> -
> XFS_IOLOCK_SHARED));
> -
> -                                               kmem_free(ipointer,
> -
> sizeof(xfs_iptr_t));
> -                                               return (0);
> -                                       }
> -
> -                                       /*
> -                                        * Since we dropped the inode
> lock,
> -                                        * the inode may have been
> reclaimed.
> -                                        * Therefore, we reacquire the
> mount
> -                                        * lock and check to see if we
> were the
> -                                        * inode reclaimed. If this
> happened
> -                                        * then the ipointer marker will
> no
> -                                        * longer point back at us. In
> this
> -                                        * case, move ip along to the
> inode
> -                                        * after the marker, remove the
> marker
> -                                        * and continue.
> -                                        */
> -                                       XFS_MOUNT_ILOCK(mp);
> -                                       mount_locked = B_TRUE;
> -
> -                                       if (ip != ipointer->ip_mprev) {
> -                                               IPOINTER_REMOVE(ip, mp);
> -
> -                                               ASSERT(!vnode_refed);
> -                                               ASSERT(!(lock_flags &
> -
> XFS_IOLOCK_SHARED));
> -                                               continue;
> -                                       }
> -
> -                                       ASSERT(ip->i_mount == mp);
> -
> -                                       if (xfs_ilock_nowait(ip,
> -                                                   XFS_ILOCK_SHARED) ==
> 0) {
> -                                               ASSERT(ip->i_mount == mp);
> -                                               /*
> -                                                * We failed to reacquire
> -                                                * the inode lock without
> -                                                * sleeping, so just skip
> -                                                * the inode for now.  We
> -                                                * clear the ILOCK bit
> from
> -                                                * the lock_flags so that
> we
> -                                                * won't try to drop a
> lock
> -                                                * we don't hold below.
> -                                                */
> -                                               lock_flags &=
> ~XFS_ILOCK_SHARED;
> -                                               IPOINTER_REMOVE(ip_next,
> mp);
> -                                       } else if ((xfs_ipincount(ip) ==
> 0) &&
> -                                                  xfs_iflock_nowait(ip))
> {
> -                                               ASSERT(ip->i_mount == mp);
> -                                               /*
> -                                                * Since this is
> vfs_sync()
> -                                                * calling we only flush
> the
> -                                                * inode out if we can
> lock
> -                                                * it without sleeping and
> -                                                * it is not pinned.  Drop
> -                                                * the mount lock here so
> -                                                * that we don't hold it
> for
> -                                                * too long. We already
> have
> -                                                * a marker in the list
> here.
> -                                                */
> -                                               XFS_MOUNT_IUNLOCK(mp);
> -                                               mount_locked = B_FALSE;
> -                                               error = xfs_iflush(ip,
>
> -                                                          XFS_IFLUSH_DELWRI);
> -                                       } else {
> -                                               ASSERT(ip->i_mount == mp);
> -                                               IPOINTER_REMOVE(ip_next,
> mp);
> -                                       }
> -                               }
> -
> -                       }
> +               if ((flags & SYNC_ATTR) &&
> +                   (ip->i_update_core ||
> +                    (ip->i_itemp && ip->i_itemp->ili_format.ilf_fields)))
> {
> +                       if (mount_locked)
> +                               IPOINTER_INSERT(ip, mp);
>
> -               } else {
> -                       if ((flags & SYNC_ATTR) &&
> -                           ((ip->i_update_core) ||
> -                            ((ip->i_itemp != NULL) &&
> -                             (ip->i_itemp->ili_format.ilf_fields != 0))))
> {
> -                               if (mount_locked) {
> -                                       IPOINTER_INSERT(ip, mp);
> -                               }
> +                       if (flags & SYNC_WAIT) {
> +                               xfs_iflock(ip);
> +                               error = xfs_iflush(ip, XFS_IFLUSH_SYNC);
>
> -                               if (flags & SYNC_WAIT) {
> -                                       xfs_iflock(ip);
> -                                       error = xfs_iflush(ip,
>
> -                                                          XFS_IFLUSH_SYNC);
> -                               } else {
> -                                       /*
> -                                        * If we can't acquire the flush
> -                                        * lock, then the inode is already
> -                                        * being flushed so don't bother
> -                                        * waiting.  If we can lock it
> then
> -                                        * do a delwri flush so we can
> -                                        * combine multiple inode flushes
> -                                        * in each disk write.
> -                                        */
> -                                       if (xfs_iflock_nowait(ip)) {
> -                                               error = xfs_iflush(ip,
>
> -                                                          XFS_IFLUSH_DELWRI);
> -                                       }
> -                                       else if (bypassed)
> -                                               (*bypassed)++;
> -                               }
> +                       /*
> +                        * If we can't acquire the flush lock, then the
> inode
> +                        * is already being flushed so don't bother
> waiting.
> +                        *
> +                        * If we can lock it then do a delwri flush so we
> can
> +                        * combine multiple inode flushes in each disk
> write.
> +                        */
> +                       } else if (xfs_iflock_nowait(ip)) {
> +                               error = xfs_iflush(ip, XFS_IFLUSH_DELWRI);
> +                       } else if (bypassed) {
> +                               (*bypassed)++;
>                         }
>                 }
>
>
>
>


[[HTML alternate version deleted]]
