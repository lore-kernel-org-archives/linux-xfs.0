Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45478 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbeLCKW6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 05:22:58 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-4-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-4-david@fromorbit.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 3 Dec 2018 12:22:21 +0200
Message-ID: <CAOQ4uxjRErxoOTAr+yzu7s5S4SEYZuw6GcfQ-M7UXAasTG9Knw@mail.gmail.com>
Subject: Re: [PATCH 03/11] vfs: no fallback for ->copy_file_range
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 3, 2018 at 10:34 AM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> Now that we have generic_copy_file_range(), remove it as a fallback
> case when offloads fail. This puts the responsibility for executing
> fallbacks on the filesystems that implement ->copy_file_range and
> allows us to add operational validity checks to
> generic_copy_file_range().
>
> Rework vfs_copy_file_range() to call a new do_copy_file_range()
> helper to exceute the copying callout, and move calls to
> generic_file_copy_range() into filesystem methods where they
> currently return failures.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

You may add
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

After fixing the overlayfs issue below.
...

> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 84dd957efa24..68736e5d6a56 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -486,8 +486,15 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
>                                    struct file *file_out, loff_t pos_out,
>                                    size_t len, unsigned int flags)
>  {
> -       return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, flags,
> +       ssize_t ret;
> +
> +       ret =  ovl_copyfile(file_in, pos_in, file_out, pos_out, len, flags,
>                             OVL_COPY);
> +
> +       if (ret == -EOPNOTSUPP)
> +               ret = generic_copy_file_range(file_in, pos_in, file_out,
> +                                       pos_out, len, flags);
> +       return ret;
>  }
>

This is unneeded, because ovl_copyfile(OVL_COPY) is implemented
by calling vfs_copy_file_range() (on the underlying files) and it is
not possible
to get EOPNOTSUPP from vfs_copy_file_range().

Thanks,
Amir.
