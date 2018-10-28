Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45101 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbeJ2A1g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Oct 2018 20:27:36 -0400
Received: by mail-lf1-f68.google.com with SMTP id c24-v6so4190904lfi.12
        for <linux-xfs@vger.kernel.org>; Sun, 28 Oct 2018 08:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <20181026201943.24131-1-stefanrin@gmail.com> <3e653734-6470-3160-58e8-5bdf866dbd87@sandeen.net>
 <5228ed5f-b238-1596-a829-6bf482da7e2b@sandeen.net> <CAAxjCExbUX1hDDV_0yK5Uu1eGf3aC8XT0CN-eL66+9GNDtdRVg@mail.gmail.com>
 <CAAxjCEyu9e4=umUMzxXZvDFHABwO6NVwihZbV2+gdwWJC8NkCQ@mail.gmail.com>
In-Reply-To: <CAAxjCEyu9e4=umUMzxXZvDFHABwO6NVwihZbV2+gdwWJC8NkCQ@mail.gmail.com>
From: Stefan Ring <stefanrin@gmail.com>
Date: Sun, 28 Oct 2018 16:42:28 +0100
Message-ID: <CAAxjCExkOoCUiLuQAkxiVim5T5jmFxrwdCSjOuboTBWdi9__tA@mail.gmail.com>
Subject: Re: [PATCH 0/5] v4 Try to squash metadump data leaks
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Sun, Oct 28, 2018 at 3:36 PM Stefan Ring <stefanrin@gmail.com> wrote:
>
> Ok, this is a better replacement for the fifth patch (copy/pasted into
> in-browser e-mail editor, might have broken formatting).

I've also put it up at
https://github.com/Ringdingcoder/xfsprogs-dev/commits/metadump-stale-data-v5-prelim
for now.

> Apparently the dev's inode contents are xfs_dev_t, and the rest of the
> data fork can be cleared. The attribute fork is handled later in
> process_inode.
>
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2270,6 +2270,25 @@ process_inode_data(
>         return 1;
>  }
>
> +static int
> +process_dev_inode(
> +       xfs_dinode_t            *dip)
> +{
> +       if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
> +               if (show_warnings)
> +                       print_warning("inode %llu has unexpected extents",
> +                                     (unsigned long long)cur_ino);
> +               return 0;
> +       } else {
> +               if (zero_stale_data) {
> +                       unsigned int size = sizeof(xfs_dev_t);
> +                       memset(XFS_DFORK_DPTR(dip) + size, 0,
> +                                       XFS_DFORK_DSIZE(dip, mp) - size);
> +               }
> +               return 1;
> +       }
> +}
> +
>  /*
>   * when we process the inode, we may change the data in the data and/or
>   * attribute fork if they are in short form and we are obfuscating names.
> @@ -2322,7 +2341,10 @@ process_inode(
>                 case S_IFREG:
>                         success = process_inode_data(dip, TYP_DATA);
>                         break;
> -               default: ;
> +               default:
> +                       success = process_dev_inode(dip);
> +                       need_new_crc = 1;
> +                       break;
>         }
>         nametable_clear();
