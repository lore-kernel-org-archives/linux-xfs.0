Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:41553 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbeLCLEy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 06:04:54 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-9-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-9-david@fromorbit.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Dec 2018 13:04:07 +0200
Message-ID: <CAOQ4uxgwZLsO1yV37_CHaZ-O+-+-OggSP9g6m9YE57kLPc5yDw@mail.gmail.com>
Subject: Re: [PATCH 08/11] vfs: push EXDEV check down into ->remap_file_range
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 3, 2018 at 10:34 AM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> before we can enable cross-device copies into copy_file_range(),
> we have to ensure that ->remap_file_range() implemenations will
> correctly reject attempts to do cross filesystem clones. Currently

But you only fixed remap_file_range() implemenations of xfs and ocfs2...

> these checks are done above calls to ->remap_file_range(), but
> we need to drive them inwards so that we get EXDEV protection for all
> callers of ->remap_file_range().
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

That leaves {nfs42,cifs,btrfs}_remap_file_range() exposed to passing
files not of their own fs type let alone same sb when do_clone_file_range()
is called from ovl_copy_up_data().

Thanks,
Amir.
