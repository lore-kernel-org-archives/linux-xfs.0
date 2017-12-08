Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:34146 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbdLHHwz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Dec 2017 02:52:55 -0500
Received: by mail-yb0-f193.google.com with SMTP id k4so4011031ybc.1
        for <linux-xfs@vger.kernel.org>; Thu, 07 Dec 2017 23:52:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171208040222.GE19219@magnolia>
References: <20171208035457.GD19219@magnolia> <20171208040222.GE19219@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 8 Dec 2017 09:52:54 +0200
Message-ID: <CAOQ4uxiT+rhgS5T7211EZdErjdbi8Z6mo4fSbT=nmh1GMEvU1w@mail.gmail.com>
Subject: Re: [RFCRAP DONOTMERGE PATCH 1/2] xfs: sketchy implementation of
 parent pointers
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Dec 8, 2017 at 6:02 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> This is a, um, "sample" implementation of parent pointers that abuses
> struct dentry to return one parent pointer of a file ... if the dentry
> cache has been connected.

Note that your sample implementation will return parent pointer of a
directory even if it wasn't already in dcache.

> This exists only to enable testing of the
> userspace xfs_scrub bits and is probably too ugly to live.  Wait for the
> real implementation.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
[...]

> +/*
> + * No need to do permission checks on the various pathname components
> + * as the handle operations are privileged.
> + */
> +STATIC int
> +xfs_parent_handle_acceptable(
> +       void                    *context,
> +       struct dentry           *dentry)
> +{
> +       return 1;

For the sake of fun, assuming that you want to gear up your sample to return
all parents, the acceptable callback is an iterator on all aliases of
inode in dcache.
So if you pass in your parent iterator context to this iterator, you
can emit all parents
from this callback. Just return 0 to keep iterating. You won't get a dentry back
from exportfs_decode_fh(), but you won't need it.


> +}
> +
> +/* Get parent info for an inode by walking the parent dentry. */
> +static int
> +xfs_parent_get_dparent(
> +       struct file             *filp,
> +       struct xfs_pptr_info    *pi,
> +       struct xfs_pptr_buf     *pb)
> +{
> +       struct xfs_inode        *ip;
> +       struct inode            *dir_inode;
> +       struct dentry           *dentry;
> +       struct dentry           *dparent;
> +       unsigned int            ilock;
> +       int                     error = 0;
> +
> +       pi->pi_oflags |= XFS_PPTR_OFLAG_PARTIAL;
> +
> +       /* Any nonzero byte in the cursor means we've already retrieved one. */
> +       if (memchr_inv(&pi->pi_cursor, 0, sizeof(pi->pi_cursor)))
> +               return 0;
> +       memset(&pi->pi_cursor, 0xFF, sizeof(pi->pi_cursor));
> +
> +       if (pi->pi_iflags & XFS_PPTR_IFLAG_HANDLE) {
> +               struct xfs_handle       *handle = &pi->pi_handle;
> +               struct xfs_fid64        fid = { 0 };
> +
> +               /* Extract the desired file from the handle info. */
> +               if (sizeof(handle->ha_fid) - sizeof(handle->ha_fid.fid_len) !=
> +                               handle->ha_fid.fid_len)
> +                       return -EINVAL;
> +
> +               fid.ino = handle->ha_fid.fid_ino;
> +               fid.gen = handle->ha_fid.fid_gen;
> +
> +               dentry = exportfs_decode_fh(filp->f_path.mnt,
> +                               (struct fid *)&fid, 3,
> +                               FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG,
> +                               xfs_parent_handle_acceptable, NULL);
> +               if (IS_ERR(dentry))
> +                       return PTR_ERR(dentry);
> +       } else {
> +               /* Or just use the dentry of the open file. */
> +               dentry = dget(file_dentry(filp));
> +       }
> +
> +       /* Lock XFS inode... */
> +       ip = XFS_I(d_inode(dentry));
> +       ilock = XFS_IOLOCK_SHARED | XFS_MMAPLOCK_SHARED | XFS_ILOCK_SHARED;
> +       xfs_ilock(ip, ilock);
> +
> +       /* Bail out early for the root dir. */
> +       if (ip->i_ino == ip->i_mount->m_sb.sb_rootino) {

Is it interesting for the API to filter path that are under the root of
the mount where the ioctl was issued from (i.e. bind mount case)?
Probably not. This API should probably be bind mount blind, but
userspace should know to expect that it may can get a real fs path,
that is not really resolvable in its mount namespace.

> +               pi->pi_oflags |= XFS_PPTR_OFLAG_ROOT;
> +               goto out_dentry;
> +       }
> +
> +       /* Filter out the unconnected inodes. */
> +       if (d_unlinked(dentry) || (dentry->d_flags & DCACHE_DISCONNECTED))
> +               goto out_dentry;
> +       if (IS_ROOT(dentry)) {
> +               pi->pi_oflags |= XFS_PPTR_OFLAG_ROOT;

This is a bit confusing... IS_ROOT(dentry) does not mean that you found
the fs root, it really means disconnected of first order (parent == self),
while DCACHE_DISCONNECTED means not connected up to fs root.
You want to check if dentry == dentry->d_sb->s_root.

> +               goto out_dentry;
> +       }
> +
> +       /* Otherwise look up the parent... */
> +       dparent = dget_parent(dentry);
> +       if (IS_ERR(dparent)) {
> +               error = PTR_ERR(dparent);
> +               goto out_dentry;
> +       }
> +
> +       dir_inode = d_inode(dparent);
> +       if (!dir_inode)
> +               goto out_dparent;
> +
> +       /* ...and emit a record. */
> +       error = xfs_parent_emit(pi, pb, dir_inode->i_ino,
> +                       dir_inode->i_generation,
> +                       ACCESS_ONCE(dentry->d_name.len),
> +                       ACCESS_ONCE(dentry->d_name.name));

Just in case some bits of this patch are going to be used in final
implementation, you need to copy d_name either under
dentry->d_lock or use take_dentry_name_snapshot().

Cheers,
Amir.
