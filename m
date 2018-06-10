Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:46905 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753904AbeFJMGK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 08:06:10 -0400
Received: by mail-yb0-f195.google.com with SMTP id p22-v6so5811721yba.13
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:06:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1528607272-11122-27-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com> <1528607272-11122-27-git-send-email-allison.henderson@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 10 Jun 2018 15:06:09 +0300
Message-ID: <CAOQ4uxgSg9FEmwZOTDj5L6DGQiCKXd+YphFMvTdfmLCryTdxHA@mail.gmail.com>
Subject: Re: [PATCH v2 26/27] xfsprogs: implement the upper half of parent pointers
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Jun 10, 2018 at 8:07 AM, Allison Henderson
<allison.henderson@oracle.com> wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
>
> Add ioctl definitions to libxfs, build the necessary helpers into
> libfrog and libhandle to iterate parents (and parent paths), then wire
> up xfs_scrub to be able to query parent pointers from userspace.  The
> goal of this patch is to exercise userspace, and is nowhere near a
> complete solution.  A basic xfs_io parent command implementation
> replaces ... whatever that is that's there now.
>
> Totally missing: actual support in libxfs for working with parent ptrs
> straight off the disk (mkfs, xfs_db, xfs_repair).
>
> [achender: Minor syntax adjustments to sew solution in actual support
>            in libxfs for working with parent ptrs]
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---

While I'm going through unmodified code, a nit picking comment to
Darrick:

> +
> +/* Construct a description for an inode. */
> +void
> +xfs_scrub_ino_descr(
> +       struct scrub_ctx        *ctx,
> +       struct xfs_handle       *handle,
> +       char                    *buf,
> +       size_t                  buflen)
> +{
> +       uint64_t                ino;
> +       xfs_agnumber_t          agno;
> +       xfs_agino_t             agino;
> +       int                     ret;
> +
> +       ret = handle_to_path(handle, sizeof(struct xfs_handle), buf, buflen);
> +       if (ret >= 0)
> +               return;
> +
> +       ino = handle->ha_fid.fid_ino;
> +       agno = ino / (1ULL << (ctx->inopblog + ctx->agblklog));
> +       agino = ino % (1ULL << (ctx->inopblog + ctx->agblklog));
> +       snprintf(buf, buflen, _("inode %"PRIu64" (%u/%u)"), ino, agno,
> +                       agino);
> +}
> +

If we are not using XFS_INO_ macros, at lease let's keep the aritmetic
consistent with the arithmetic used by the macros?

Thanks,
Amir.
