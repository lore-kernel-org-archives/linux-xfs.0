Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36371 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728329AbeJ0PDb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Oct 2018 11:03:31 -0400
Received: by mail-lf1-f68.google.com with SMTP id h192so2497432lfg.3
        for <linux-xfs@vger.kernel.org>; Fri, 26 Oct 2018 23:23:37 -0700 (PDT)
MIME-Version: 1.0
References: <20181026201943.24131-1-stefanrin@gmail.com> <20181026201943.24131-5-stefanrin@gmail.com>
In-Reply-To: <20181026201943.24131-5-stefanrin@gmail.com>
From: Stefan Ring <stefanrin@gmail.com>
Date: Sat, 27 Oct 2018 08:23:24 +0200
Message-ID: <CAAxjCEyqbTjYKmn2YSSZKh7z_sVta64bSXN-zK24H=f3VodXgg@mail.gmail.com>
Subject: Re: [PATCH 4/5] xfs_metadump: Zap unused space in inode btrees
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Fri, Oct 26, 2018 at 10:20 PM Stefan Ring <stefanrin@gmail.com> wrote:
>
> ---
>  db/metadump.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/db/metadump.c b/db/metadump.c
> index a4867783..39183fb7 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2173,6 +2173,19 @@ process_btinode(
>         }
>
>         pp = XFS_BMDR_PTR_ADDR(dib, 1, maxrecs);
> +
> +       if (zero_stale_data) {
> +               char    *top;
> +
> +               /* Unused btree key space */
> +               top = (char*)XFS_BMDR_KEY_ADDR(dib, nrecs + 1);
> +               memset(top, 'a', (char*)pp - top);

Oh well. This should be 0 instead of 'a' and 'b'.

> +
> +               /* Unused btree ptr space */
> +               top = (char*)&pp[nrecs];
> +               memset(top, 'b', (char*)dib + XFS_DFORK_SIZE(dip, mp, whichfork) - top);
> +       }
> +
>         for (i = 0; i < nrecs; i++) {
>                 xfs_agnumber_t  ag;
>                 xfs_agblock_t   bno;
> --
> 2.14.5
>
