Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:39759 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbeLAUtm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Dec 2018 15:49:42 -0500
MIME-Version: 1.0
References: <20181130204238.GE8131@magnolia>
In-Reply-To: <20181130204238.GE8131@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 1 Dec 2018 11:37:24 +0200
Message-ID: <CAOQ4uxjWj=z5KbPpe3jqH5nfcWauPXWrit=3o_XwBPuP=-oEEw@mail.gmail.com>
Subject: Re: [PATCH] vfs: allow remap flags to be passed to vfs_clone_file_range
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Nov 30, 2018 at 10:42 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> In overlayfs, ovl_remap_file_range calls vfs_clone_file_range on the
> lower filesystem's inode, passing through whatever remap flags it got
> from its caller.  Since vfs_copy_file_range first tries a filesystem's
> remap function with REMAP_FILE_CAN_SHORTEN, this can get passed through
> to the second vfs_copy_file_range call, which isn't an issue.
> Remove the WARN_ON because it's unnecessary.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/read_write.c |    2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 4dae0399c75a..2d9fed57e7dd 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1956,8 +1956,6 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
>         struct inode *inode_out = file_inode(file_out);
>         loff_t ret;
>
> -       WARN_ON_ONCE(remap_flags);
> -

WARN_ON_ONCE(remap_flags & ~REMAP_FILE_ADVISORY);

We still do not want anyone to call do_clone_file_range(..., REMAP_FILE_DEDUP)

If we had more users of the overloaded interface, we need to do:

WARN_ON_ONCE((remap_flags & REMAP_FILE_OP_MASK) == REMAP_FILE_OP_CLONE);

With the minor fix, you can add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
