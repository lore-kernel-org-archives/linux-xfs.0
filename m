Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vs1-f65.google.com ([209.85.217.65]:34105 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbeLDITI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Dec 2018 03:19:08 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-9-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-9-david@fromorbit.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Tue, 4 Dec 2018 03:18:54 -0500
Message-ID: <CAN-5tyEumh4A+74Xp+ywk0-73X8iqhrv81S+mfLLPExsp4SE8g@mail.gmail.com>
Subject: Re: [PATCH 08/11] vfs: push EXDEV check down into ->remap_file_range
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs <linux-nfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 3, 2018 at 3:34 AM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> before we can enable cross-device copies into copy_file_range(),
> we have to ensure that ->remap_file_range() implemenations will
> correctly reject attempts to do cross filesystem clones. Currently
> these checks are done above calls to ->remap_file_range(), but
> we need to drive them inwards so that we get EXDEV protection for all
> callers of ->remap_file_range().

If there is no check before calling ->remap_file_range() then NFS
barfs. Perhaps it needs a check internally that checks that both file
handles are from the NFS but this was not needed before. Or there
needs to the a check in VFS.

>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/read_write.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 3288db1d5f21..174cf92eea1d 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1909,6 +1909,19 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>         bool same_inode = (inode_in == inode_out);
>         int ret;
>
> +       /*
> +        * FICLONE/FICLONERANGE ioctls enforce that src and dest files are on
> +        * the same mount. Practically, they only need to be on the same file
> +        * system. We check this here rather than at the ioctl layers because
> +        * this is effectively a limitation of the fielsystem implementations,
> +        * not so much the API itself. Further, ->remap_file_range() can be
> +        * called from syscalls that don't have cross device copy restrictions
> +        * (such as copy_file_range()) and so we need to catch them before we
> +        * do any damage.
> +        */
> +       if (inode_in->i_sb != inode_out->i_sb)
> +               return -EXDEV;
> +
>         /* Don't touch certain kinds of inodes */
>         if (IS_IMMUTABLE(inode_out))
>                 return -EPERM;
> @@ -2013,14 +2026,6 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
>         if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
>                 return -EINVAL;
>
> -       /*
> -        * FICLONE/FICLONERANGE ioctls enforce that src and dest files are on
> -        * the same mount. Practically, they only need to be on the same file
> -        * system.
> -        */
> -       if (inode_in->i_sb != inode_out->i_sb)
> -               return -EXDEV;
> -
>         if (!(file_in->f_mode & FMODE_READ) ||
>             !(file_out->f_mode & FMODE_WRITE) ||
>             (file_out->f_flags & O_APPEND))
> --
> 2.19.1
>
