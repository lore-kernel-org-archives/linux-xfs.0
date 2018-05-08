Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:39776 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754631AbeEHKEF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 06:04:05 -0400
Received: by mail-yw0-f196.google.com with SMTP id v132-v6so9478425ywc.6
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 03:04:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1525627494-12873-19-git-send-email-allison.henderson@oracle.com>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com> <1525627494-12873-19-git-send-email-allison.henderson@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 8 May 2018 13:04:03 +0300
Message-ID: <CAOQ4uxjQ8kLF=XbOXdGKSFvUoBEgLEvP0NpAz7DS8My4ckycWA@mail.gmail.com>
Subject: Re: [PATCH 18/21] xfs: Add parent pointers to rename
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sun, May 6, 2018 at 8:24 PM, Allison Henderson
<allison.henderson@oracle.com> wrote:
> This patch removes the old parent pointer attribute during the
> rename operation, and re-adds the updated parent pointer
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 68 +++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 52 insertions(+), 16 deletions(-)
>
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index b18b20c..7fd1479 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3004,6 +3004,8 @@ xfs_rename(
>         bool                    src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
>         int                     spaceres;
>         int                     error;
> +       xfs_dir2_dataptr_t      new_diroffset;
> +       xfs_dir2_dataptr_t      old_diroffset;
>
>         trace_xfs_rename(src_dp, target_dp, src_name, target_name);
>
> @@ -3058,14 +3060,14 @@ xfs_rename(
>          * we can rely on either trans_commit or trans_cancel to unlock
>          * them.
>          */
> -       xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
> +       xfs_trans_ijoin(tp, src_dp, 0);
>         if (new_parent)
> -               xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
> -       xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
> +               xfs_trans_ijoin(tp, target_dp, 0);
> +       xfs_trans_ijoin(tp, src_ip, 0);
>         if (target_ip)
> -               xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
> +               xfs_trans_ijoin(tp, target_ip, 0);
>         if (wip)
> -               xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
> +               xfs_trans_ijoin(tp, wip, 0);
>
>         /*
>          * If we are using project inheritance, we only allow renames
> @@ -3075,17 +3077,18 @@ xfs_rename(
>         if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
>                      (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
>                 error = -EXDEV;
> -               goto out_trans_cancel;
> +               goto out_unlock;
>         }
>
>         xfs_defer_init(&dfops, &first_block);
>
>         /* RENAME_EXCHANGE is unique from here on. */
> -       if (flags & RENAME_EXCHANGE)
> -               return xfs_cross_rename(tp, src_dp, src_name, src_ip,
> +       if (flags & RENAME_EXCHANGE) {
> +               error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
>                                         target_dp, target_name, target_ip,
>                                         &dfops, &first_block, spaceres);
> -
> +               goto out;

What about updating parent pointers in xfs_cross_rename()?

Thanks,
Amir.
