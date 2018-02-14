Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:43697 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750759AbeBNHyc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 02:54:32 -0500
Received: by mail-wr0-f194.google.com with SMTP id b52so21117920wrd.10
        for <linux-xfs@vger.kernel.org>; Tue, 13 Feb 2018 23:54:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151787295310.3743.17476652120290779062.stgit@magnolia>
References: <151787293446.3743.11110014829952400444.stgit@magnolia> <151787295310.3743.17476652120290779062.stgit@magnolia>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 14 Feb 2018 08:54:10 +0100
Message-ID: <CACj3i73ihFAuwJR4OWuGXkMwpH28oUvrTmwDjJ-FbVbpFSQiJQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] xfs_scrub: classify lack of ioctl support as a
 runtime error
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Feb 6, 2018 at 12:22 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> If the kernel doesn't have the SCRUB_METADATA ioctl that's a runtime
> error, not a fs error.  Account it as such.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Jan Tulak <jtulak@redhat.com>

> ---
>  scrub/phase1.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
>
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index af93d0f..82c8022 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -174,14 +174,14 @@ _("Does not appear to be an XFS filesystem!"));
>             !xfs_can_scrub_bmap(ctx) || !xfs_can_scrub_dir(ctx) ||
>             !xfs_can_scrub_attr(ctx) || !xfs_can_scrub_symlink(ctx) ||
>             !xfs_can_scrub_parent(ctx)) {
> -               str_error(ctx, ctx->mntpoint,
> +               str_info(ctx, ctx->mntpoint,
>  _("Kernel metadata scrubbing facility is not available."));
>                 return false;
>         }
>
>         /* Do we need kernel-assisted metadata repair? */
>         if (ctx->mode != SCRUB_MODE_DRY_RUN && !xfs_can_repair(ctx)) {
> -               str_error(ctx, ctx->mntpoint,
> +               str_info(ctx, ctx->mntpoint,
>  _("Kernel metadata repair facility is not available.  Use -n to scrub."));
>                 return false;
>         }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
