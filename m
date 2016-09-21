Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36303 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934799AbcIUPJW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Sep 2016 11:09:22 -0400
Received: by mail-oi0-f67.google.com with SMTP id i193so4012995oib.3
        for <linux-xfs@vger.kernel.org>; Wed, 21 Sep 2016 08:09:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1473856994-27463-3-git-send-email-amir73il@gmail.com>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com> <1473856994-27463-3-git-send-email-amir73il@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 21 Sep 2016 17:09:20 +0200
Message-ID: <CAJfpegvtCf7mPanvmhU8vmoyQTUsVo-O0bpNxwnt4abkJ5ZD6Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ovl: use vfs_clone_file_range() for copy up if possible
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org

On Wed, Sep 14, 2016 at 2:43 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> When copying up within the same fs, try to use vfs_clone_file_range().
> This is very efficient when lower and upper are on the same fs
> with file reflink support. If vfs_clone_file_range() fails because
> lower and upper are not on the same fs or if fs has no reflink support,
> copy up falls back to the regular data copy code.
>
> Tested correct behavior when lower and upper are on:
> 1. same ext4 (copy)
> 2. same xfs + reflink patches + mkfs.xfs (copy)
> 3. same xfs + reflink patches + mkfs.xfs -m reflink=1 (reflink)
> 4. different xfs + reflink patches + mkfs.xfs -m reflink=1 (copy)
>
> For comparison, on my laptop, xfstest overlay/001 (copy up of large
> sparse files) takes less than 1 second in the xfs reflink setup vs.
> 25 seconds on the rest of the setups.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/copy_up.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 43fdc27..ba039f8 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -136,6 +136,16 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>                 goto out_fput;
>         }
>
> +       /* Try to use clone_file_range to clone up within the same fs */
> +       error = vfs_clone_file_range(old_file, 0, new_file, 0, len);
> +       if (!error)
> +               goto out;
> +       /* If we can clone but clone failed - abort */
> +       if (error != -EXDEV && error != -EOPNOTSUPP)
> +               goto out;

Would be safer to fall back on any error.

Otherwise ACK.

Thanks,
Miklos
