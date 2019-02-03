Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:46269 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfBCOou (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Feb 2019 09:44:50 -0500
Received: by mail-yw1-f65.google.com with SMTP id t13so4715560ywe.13
        for <linux-xfs@vger.kernel.org>; Sun, 03 Feb 2019 06:44:50 -0800 (PST)
MIME-Version: 1.0
References: <20190121152326.9954-1-hch@lst.de> <20190121152326.9954-2-hch@lst.de>
In-Reply-To: <20190121152326.9954-2-hch@lst.de>
From: Mike Marshall <hubcap@omnibond.com>
Date: Sun, 3 Feb 2019 09:44:38 -0500
Message-ID: <CAOg9mSRFVpMn6+z0t+bQKv6zW7=NpkxY-jEPWDaQkqxO-5vGGQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] orangefs: don't reinitialize result_mask in ->getattr
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Martin Brandenburg <martin@omnibond.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs@vger.kernel.org, devel@lists.orangefs.org

It looks good to both Martin and I, and runs fine through xfstests...
you can add Signed-off-by: Mike Marshall <hubcap@omnibond.com>

-Mike "is there a finally-signed-off-by tag?"


On Mon, Jan 21, 2019 at 10:23 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The caller already initializes it to the basic stats.  Just
> clear not supported default bits where needed.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/orangefs/inode.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
> index f038235c64bd..c3334eca18c7 100644
> --- a/fs/orangefs/inode.c
> +++ b/fs/orangefs/inode.c
> @@ -261,11 +261,8 @@ int orangefs_getattr(const struct path *path, struct kstat *stat,
>                 generic_fillattr(inode, stat);
>
>                 /* override block size reported to stat */
> -               if (request_mask & STATX_SIZE)
> -                       stat->result_mask = STATX_BASIC_STATS;
> -               else
> -                       stat->result_mask = STATX_BASIC_STATS &
> -                           ~STATX_SIZE;
> +               if (!(request_mask & STATX_SIZE))
> +                       stat->result_mask &= ~STATX_SIZE;
>
>                 stat->attributes_mask = STATX_ATTR_IMMUTABLE |
>                     STATX_ATTR_APPEND;
> --
> 2.20.1
>
