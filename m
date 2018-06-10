Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:35959 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753868AbeFJLcQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 07:32:16 -0400
Received: by mail-yb0-f196.google.com with SMTP id x128-v6so5567050ybg.3
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 04:32:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1528607272-11122-26-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com> <1528607272-11122-26-git-send-email-allison.henderson@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 10 Jun 2018 14:32:15 +0300
Message-ID: <CAOQ4uxhxUZudsgeJJSnSQb4xwwkYW=_gsH=HM14fG4c25rY1PA@mail.gmail.com>
Subject: Re: [PATCH v2 25/27] xfsprogs: Add parent pointers during protofile creation
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Jun 10, 2018 at 8:07 AM, Allison Henderson
<allison.henderson@oracle.com> wrote:
> Inodes created from protofile parsing will also need to
> add the appropriate parent pointers
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  mkfs/proto.c | 55 ++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 36 insertions(+), 19 deletions(-)
>
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 67c228a..222479f 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -19,6 +19,7 @@
>  #include "libxfs.h"
>  #include <sys/stat.h>
>  #include "xfs_multidisk.h"
> +#include "xfs_parent.h"
>
>  /*
>   * Prototypes for internal functions.
> @@ -318,23 +319,25 @@ newregfile(
>
>  static void
>  newdirent(
> -       xfs_mount_t     *mp,
> -       xfs_trans_t     *tp,
> -       xfs_inode_t     *pip,
> -       struct xfs_name *name,
> -       xfs_ino_t       inum,
> -       xfs_fsblock_t   *first,
> -       struct xfs_defer_ops    *dfops)
> +       struct xfs_mount        *mp,
> +       struct xfs_trans        *tp,
> +       struct xfs_inode        *pip,
> +       struct xfs_name         *name,

Here too. was there a reason to convert to the non typedef-ed
types?

> +       struct xfs_inode        *ip,
> +       xfs_fsblock_t           *first,
> +       struct xfs_defer_ops    *dfops,
> +       xfs_dir2_dataptr_t      *offset)
>  {
> -       int     error;
> -       int     rsv;
> +       int                     error;
> +       int                     rsv;
>
>         rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
>
> -       error = -libxfs_dir_createname(tp, pip, name, inum, first, dfops, rsv,
> -                                      NULL);
> +       error = -libxfs_dir_createname(tp, pip, name, ip->i_ino, first, dfops, rsv,
> +                                      offset);
>         if (error)
>                 fail(_("directory createname error"), error);
> +
>  }
>
>  static void
> @@ -387,6 +390,7 @@ parseproto(
>         cred_t          creds;
>         char            *value;
>         struct xfs_name xname;
> +       xfs_dir2_dataptr_t offset;
>
>         memset(&creds, 0, sizeof(creds));
>         mstr = getstr(pp);
> @@ -470,7 +474,7 @@ parseproto(
>                         free(buf);
>                 libxfs_trans_ijoin(tp, pip, 0);
>                 xname.type = XFS_DIR3_FT_REG_FILE;
> -               newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
> +               newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>                 break;
>
>         case IF_RESERVED:                       /* pre-allocated space only */
> @@ -493,7 +497,7 @@ parseproto(
>                 libxfs_trans_ijoin(tp, pip, 0);
>
>                 xname.type = XFS_DIR3_FT_REG_FILE;
> -               newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
> +               newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>                 libxfs_trans_log_inode(tp, ip, flags);
>
>                 libxfs_defer_ijoin(&dfops, ip);
> @@ -516,7 +520,7 @@ parseproto(
>                 }
>                 libxfs_trans_ijoin(tp, pip, 0);
>                 xname.type = XFS_DIR3_FT_BLKDEV;
> -               newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
> +               newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>                 flags |= XFS_ILOG_DEV;
>                 break;
>
> @@ -530,7 +534,7 @@ parseproto(
>                         fail(_("Inode allocation failed"), error);
>                 libxfs_trans_ijoin(tp, pip, 0);
>                 xname.type = XFS_DIR3_FT_CHRDEV;
> -               newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
> +               newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>                 flags |= XFS_ILOG_DEV;
>                 break;
>
> @@ -542,7 +546,7 @@ parseproto(
>                         fail(_("Inode allocation failed"), error);
>                 libxfs_trans_ijoin(tp, pip, 0);
>                 xname.type = XFS_DIR3_FT_FIFO;
> -               newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
> +               newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>                 break;
>         case IF_SYMLINK:
>                 buf = getstr(pp);
> @@ -555,7 +559,7 @@ parseproto(
>                 flags |= newfile(tp, ip, &dfops, &first, 1, 1, buf, len);
>                 libxfs_trans_ijoin(tp, pip, 0);
>                 xname.type = XFS_DIR3_FT_SYMLINK;
> -               newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
> +               newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>                 break;
>         case IF_DIRECTORY:
>                 tp = getres(mp, 0);
> @@ -572,8 +576,8 @@ parseproto(
>                 } else {
>                         libxfs_trans_ijoin(tp, pip, 0);
>                         xname.type = XFS_DIR3_FT_DIR;
> -                       newdirent(mp, tp, pip, &xname, ip->i_ino,
> -                                 &first, &dfops);
> +                       newdirent(mp, tp, pip, &xname, ip,
> +                                 &first, &dfops, &offset);
>                         inc_nlink(VFS_I(pip));
>                         libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
>                 }
> @@ -612,6 +616,19 @@ parseproto(
>                 fail(_("Error encountered creating file from prototype file"),
>                         error);
>         }
> +
> +       if (xfs_sb_version_hasparent(&mp->m_sb)) {
> +               error = xfs_parent_add(pip, ip, &xname, offset, &first, &dfops);
> +               if (error)
> +                       fail(_("Error creating parent pointer"), error);
> +
> +               libxfs_trans_log_inode(tp, ip, flags);
> +               libxfs_defer_ijoin(&dfops, ip);
> +               error = -libxfs_defer_finish(&tp, &dfops);
> +               if (error)
> +                       fail(_("Directory creation failed"), error);
> +       }
> +
>         libxfs_trans_commit(tp);
>         IRELE(ip);
>  }
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
