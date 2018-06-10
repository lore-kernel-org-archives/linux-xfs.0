Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:38277 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753624AbeFJNj7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 09:39:59 -0400
Received: by mail-yb0-f195.google.com with SMTP id q62-v6so5865862ybg.5
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 06:39:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1528607108-11059-20-git-send-email-allison.henderson@oracle.com>
References: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com> <1528607108-11059-20-git-send-email-allison.henderson@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 10 Jun 2018 16:39:58 +0300
Message-ID: <CAOQ4uxiyUOE4Z4RCERuTHGq5APyM6QzrTvC16pJOy_S_syXFkg@mail.gmail.com>
Subject: Re: [PATCH v7 19/23] xfs: Add parent pointers to rename
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Jun 10, 2018 at 8:05 AM, Allison Henderson
<allison.henderson@oracle.com> wrote:
> This patch removes the old parent pointer attribute during the
> rename operation, and re-adds the updated parent pointer
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_inode.c | 68 +++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 52 insertions(+), 16 deletions(-)
>
[...]
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

You forgot to update parent pointers in RENAME_EXCHANGE
case, both src and target.

I commented that on v6, you must have missed that.

Thanks,
Amir.
