Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:35267 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbeLCMhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 07:37:04 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-10-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-10-david@fromorbit.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Dec 2018 14:36:00 +0200
Message-ID: <CAOQ4uxhiWGXrdzvXzsYcaTGL06xipDUC8KWMwGTBfcM+hZoekA@mail.gmail.com>
Subject: Re: [PATCH 09/11] vfs: push copy_file_ranges -EXDEV checks down
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
> We want to enable cross-filesystem copy_file_range functionality
> where possible, so push the "same superblock only" checks down to
> the individual filesystem callouts so they can make their own
> decisions about cross-superblock copy offload.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.
You may add
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Similar comment about overlayfs as patch 3.

 diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 68736e5d6a56..34fb0398d016 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -443,6 +443,14 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
>         const struct cred *old_cred;
>         loff_t ret;
>
> +       /*
> +        * Temporary. Cross device copy checks should be left to the copy file
> +        * call on the real inodes, but existing behaviour checks the upper
> +        * files only.
> +        */
> +       if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
> +               return -EXDEV;
> +
>         ret = ovl_real_fdget(file_out, &real_out);
>         if (ret)
>                 return ret;
> @@ -491,7 +499,7 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
>         ret =  ovl_copyfile(file_in, pos_in, file_out, pos_out, len, flags,
>                             OVL_COPY);
>
> -       if (ret == -EOPNOTSUPP)
> +       if (ret == -EOPNOTSUPP || ret == -EXDEV)
>                 ret = generic_copy_file_range(file_in, pos_in, file_out,
>                                         pos_out, len, flags);

This fallback is already provided by vfs_copy_file_range().

Thanks,
Amir.
