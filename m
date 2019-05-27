Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:33446 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfE0IEX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 May 2019 04:04:23 -0400
Received: by mail-io1-f67.google.com with SMTP id u13so3870764iop.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 May 2019 01:04:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190526062825.23059-1-amir73il@gmail.com>
In-Reply-To: <20190526062825.23059-1-amir73il@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 27 May 2019 10:04:11 +0200
Message-ID: <CAJfpegvsN4qUXOpRGwv-0PkE8tjy6dGNCtekfbFaJviiDQd8Xg@mail.gmail.com>
Subject: Re: [PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR ioctls
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Sun, May 26, 2019 at 8:28 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> They are the extended version of FS_IOC_FS[SG]ETFLAGS ioctls.
> xfs_io -c "chattr <flags>" uses the new ioctls for setting flags.
>
> This used to work in kernel pre v4.19, before stacked file ops
> introduced the ovl_ioctl whitelist.
>
> Reported-by: Dave Chinner <david@fromorbit.com>
> Fixes: d1d04ef8572b ("ovl: stack file ops")
> Cc: <stable@vger.kernel.org> # v4.19
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Thanks,  applied.

Miklos
