Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36824 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753723AbeFJG62 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 02:58:28 -0400
Received: by mail-yw0-f195.google.com with SMTP id v68-v6so5391010ywd.3
        for <linux-xfs@vger.kernel.org>; Sat, 09 Jun 2018 23:58:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1528607108-11059-3-git-send-email-allison.henderson@oracle.com>
References: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com> <1528607108-11059-3-git-send-email-allison.henderson@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 10 Jun 2018 09:58:27 +0300
Message-ID: <CAOQ4uxh5Ojx_HsdwFBtrB_Tde87ms2O6Xhca6Q9GhfNU+X2H0g@mail.gmail.com>
Subject: Re: [PATCH v7 02/23] xfs: Add helper function xfs_attr_try_sf_addname
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Jun 10, 2018 at 8:04 AM, Allison Henderson
<allison.henderson@oracle.com> wrote:
> This patch adds a subroutine xfs_attr_try_sf_addname
> used by xfs_attr_set.  This subrotine will attempt to
> add the attribute name specified in args in shortform,
> as well and perform error handling previously done in
> xfs_attr_set.
>
> This patch helps to pre-simplify xfs_attr_set for reviewing
> purposes and reduce indentation.  New function will be added
> in the next patch.
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 64 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 41 insertions(+), 23 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ce4a34a..1524197 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -203,6 +203,44 @@ xfs_attr_calc_size(
>         return nblks;
>  }
>
> +STATIC int
> +xfs_attr_try_sf_addname(
> +       struct xfs_inode        *dp,
> +       struct xfs_da_args      *args,
> +       int                     flags)
> +{
> +
> +       struct xfs_mount        *mp = dp->i_mount;
> +       int                     error;
> +       int                     err2;
> +
> +       error = xfs_attr_shortform_addname(args);
> +       if (error != -ENOSPC) {

Not sure it made sense before, but in the context of this helper
nesting most of the code path for the likely case is weird.
Please return error if (error == -ENOSPC)

> +               /*
> +                * Commit the shortform mods, and we're done.
> +                * NOTE: this is also the error path
> +                * (EEXIST, etc).
> +                */
> +               ASSERT(args->trans != NULL);
> +
> +               /*
> +                * If this is a synchronous mount, make sure
> +                * that the transaction goes to disk before
> +                * returning to the user.
> +                */
> +               if (mp->m_flags & XFS_MOUNT_WSYNC)
> +                       xfs_trans_set_sync(args->trans);
> +
> +               if (!error && (flags & ATTR_KERNOTIME) == 0) {
> +                       xfs_trans_ichgtime(args->trans, dp,
> +                                       XFS_ICHGTIME_CHG);
> +               }
> +               err2 = xfs_trans_commit(args->trans);
> +               error = error ? error : err2;
> +       }
> +       return error;
> +}
> +
>  int
>  xfs_attr_set(
>         struct xfs_inode        *dp,
> @@ -218,7 +256,7 @@ xfs_attr_set(
>         struct xfs_trans_res    tres;
>         xfs_fsblock_t           firstblock;
>         int                     rsvd = (flags & ATTR_ROOT) != 0;
> -       int                     error, err2, local;
> +       int                     error, local;
>
>         XFS_STATS_INC(mp, xs_attr_set);
>
> @@ -297,30 +335,10 @@ xfs_attr_set(
>                  * Try to add the attr to the attribute list in
>                  * the inode.
>                  */
> -               error = xfs_attr_shortform_addname(&args);
> +               error = xfs_attr_try_sf_addname(dp, &args, flags);
>                 if (error != -ENOSPC) {
> -                       /*
> -                        * Commit the shortform mods, and we're done.
> -                        * NOTE: this is also the error path (EEXIST, etc).
> -                        */
> -                       ASSERT(args.trans != NULL);
> -
> -                       /*
> -                        * If this is a synchronous mount, make sure that
> -                        * the transaction goes to disk before returning
> -                        * to the user.
> -                        */
> -                       if (mp->m_flags & XFS_MOUNT_WSYNC)
> -                               xfs_trans_set_sync(args.trans);
> -
> -                       if (!error && (flags & ATTR_KERNOTIME) == 0) {
> -                               xfs_trans_ichgtime(args.trans, dp,
> -                                                       XFS_ICHGTIME_CHG);
> -                       }
> -                       err2 = xfs_trans_commit(args.trans);
>                         xfs_iunlock(dp, XFS_ILOCK_EXCL);
> -
> -                       return error ? error : err2;
> +                       return error;
>                 }
>
>                 /*
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
