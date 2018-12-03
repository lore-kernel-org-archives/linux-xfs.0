Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:40623 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbeLCMr1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 07:47:27 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-2-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-2-david@fromorbit.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Dec 2018 14:46:20 +0200
Message-ID: <CAOQ4uxhOQY8M5rbgHKREN5qpeDGHv0-xK3r37Lj6XfqFoE4qjg@mail.gmail.com>
Subject: Re: [PATCH 01/11] vfs: copy_file_range source range over EOF should fail
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
> The man page says:
>
> EINVAL Requested range extends beyond the end of the source file
>
> But the current behaviour is that copy_file_range does a short
> copy up to the source file EOF. Fix the kernel behaviour to match
> the behaviour described in the man page.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/read_write.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 4dae0399c75a..09d1816cf3cf 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1581,6 +1581,10 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>         if (len == 0)
>                 return 0;
>
> +       /* If the source range crosses EOF, fail the copy */
> +       if (pos_in >= i_size(inode_in) || pos_in + len > i_size(inode_in))
> +               return -EINVAL;
> +

i_size_read()...

Otherwise
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.


> --
> 2.19.1
>
