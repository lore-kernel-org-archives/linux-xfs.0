Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35797 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbcIWH57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 03:57:59 -0400
MIME-Version: 1.0
In-Reply-To: <1473856994-27463-4-git-send-email-amir73il@gmail.com>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com> <1473856994-27463-4-git-send-email-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 23 Sep 2016 10:57:56 +0300
Message-ID: <CAOQ4uxiZBE_2qy86b6x19opLcGbMzhtqrWBkFZqHeQnZgHtJfQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] vfs: allow vfs_copy_file_range() across file systems
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Sep 14, 2016 at 3:43 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> copy_file_range syscall returns -EXDEV if src and dest
> file are not on the same file system.
> The vfs_copy_file_range() helper, however, knows how to copy
> across file systems with do_splice_direct().
>
> Move the enforcement of same file system from the vfs helper
> to the syscall code.
>
> A following patch is going to use the vfs_copy_file_range()
> helper in overlayfs to copy up between lower and upper
> not on the same file system.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/read_write.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 9dc6e52..6975fe8 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1502,10 +1502,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>             (file_out->f_flags & O_APPEND))
>                 return -EBADF;
>
> -       /* this could be relaxed once a method supports cross-fs copies */
> -       if (inode_in->i_sb != inode_out->i_sb)
> -               return -EXDEV;
> -
>         if (len == 0)
>                 return 0;
>
> @@ -1514,7 +1510,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>                 return ret;
>
>         ret = -EOPNOTSUPP;
> -       if (file_out->f_op->copy_file_range)
> +       /* copy_file_range() method does not support cross-fs copies */
> +       if (inode_in->i_sb == inode_out->i_sb &&
> +           file_out->f_op->copy_file_range)
>                 ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
>                                                       pos_out, len, flags);
>         if (ret == -EOPNOTSUPP)
> @@ -1569,6 +1567,14 @@ SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
>                 pos_out = f_out.file->f_pos;
>         }
>
> +       /*
> +        * vfs_copy_file_range() can do cross-fs copy, but we want to
> +        * fulfill the guaranty to userland that copy_file_range syscall
> +        * does not allow cross-fs copy
> +        */
> +       if (file_inode(f_in.file)->i_sb != file_inode(f_out.file)->i_sb)
> +               return -EXDEV;

Oops, that was supposed to be goto out;
Anyway, I am holding back on the vfs_copy_file_range() patches sub set
until I have a reliable test on xfs to fall back from clone to copy range

> +
>         ret = vfs_copy_file_range(f_in.file, pos_in, f_out.file, pos_out, len,
>                                   flags);
>         if (ret > 0) {
> --
> 2.7.4
>
