Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:43822 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753864AbeFJL1D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 07:27:03 -0400
Received: by mail-yw0-f196.google.com with SMTP id r19-v6so5475240ywc.10
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 04:27:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1528607272-11122-25-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com> <1528607272-11122-25-git-send-email-allison.henderson@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 10 Jun 2018 14:27:01 +0300
Message-ID: <CAOQ4uxihru8aEqcdB6AMLvr2-wRvhQado_bh=Q5vpZ88d=XJhA@mail.gmail.com>
Subject: Re: [PATCH v2 24/27] xfsprogs: Add parent pointers to recreated inodes
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Jun 10, 2018 at 8:07 AM, Allison Henderson
<allison.henderson@oracle.com> wrote:
> Inodes that are not recovered from the orphanage will
> be recreated, so we will need to re-add the parent pointers
> here too.
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  libxfs/libxfs_api_defs.h |  1 +
>  repair/phase6.c          | 40 +++++++++++++++++++++++++++-------------
>  2 files changed, 28 insertions(+), 13 deletions(-)
>
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 78daca0..4b47479 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -152,5 +152,6 @@
>  #define xfs_rmap_compare               libxfs_rmap_compare
>  #define xfs_dir_get_ops                        libxfs_dir_get_ops
>  #define xfs_default_ifork_ops          libxfs_default_ifork_ops
> +#define xfs_parent_add                 libxfs_parent_add
>
>  #endif /* __LIBXFS_API_DEFS_H__ */
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 4fedb35..96ffade 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -29,6 +29,7 @@
>  #include "dinode.h"
>  #include "progress.h"
>  #include "versions.h"
> +#include "xfs_parent.h"
>
>  static struct cred             zerocr;
>  static struct fsxattr          zerofsx;
> @@ -962,19 +963,20 @@ mk_root_dir(xfs_mount_t *mp)
>  static xfs_ino_t
>  mk_orphanage(xfs_mount_t *mp)
>  {
> -       xfs_ino_t       ino;
> -       xfs_trans_t     *tp;
> -       xfs_inode_t     *ip;
> -       xfs_inode_t     *pip;
> -       xfs_fsblock_t   first;
> -       ino_tree_node_t *irec;
> -       int             ino_offset = 0;
> -       int             i;
> -       int             error;
> +       xfs_ino_t               ino;
> +       struct xfs_trans        *tp;
> +       struct xfs_inode        *ip;
> +       struct xfs_inode        *pip;

I guess you did some whitespace cleanups here while at it,
but why did those types change from xfs_inode_t etc?

> +       xfs_fsblock_t           first;
> +       struct ino_tree_node    *irec;
> +       int                     ino_offset = 0;
> +       int                     i;
> +       int                     error;
>         struct xfs_defer_ops    dfops;
> -       const int       mode = 0755;
> -       int             nres;
> -       struct xfs_name xname;
> +       const int               mode = 0755;
> +       int                     nres;
> +       struct xfs_name         xname;
> +       xfs_dir2_dataptr_t      offset;
>
>         /*
>          * check for an existing lost+found first, if it exists, return
> @@ -1061,7 +1063,7 @@ mk_orphanage(xfs_mount_t *mp)
>          * create the actual entry
>          */
>         error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, &first,
> -                                       &dfops, nres, NULL);
> +                                       &dfops, nres, &offset);
>         if (error)
>                 do_error(
>                 _("can't make %s, createname error %d\n"),
> @@ -1083,6 +1085,18 @@ mk_orphanage(xfs_mount_t *mp)
>         libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>
>         libxfs_defer_ijoin(&dfops, ip);
> +
> +        if (xfs_sb_version_hasparent(&mp->m_sb)) {
> +                error = -libxfs_parent_add(pip, ip, &xname, offset,
> +                                      &first, &dfops);
> +                if (error)
> +                        do_error(_("Error creating parent pointer: %d\n"),
> +                                error);
> +               libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
> +               libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +               libxfs_defer_ijoin(&dfops, pip);
> +        }
> +
>         error = -libxfs_defer_finish(&tp, &dfops);
>         if (error) {
>                 do_error(_("%s directory creation failed -- bmapf error %d\n"),
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
