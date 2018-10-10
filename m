Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35470 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725757AbeJJNnG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 09:43:06 -0400
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia> <153913041692.32295.9928643841686525236.stgit@magnolia>
In-Reply-To: <153913041692.32295.9928643841686525236.stgit@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 10 Oct 2018 09:22:16 +0300
Message-ID: <CAOQ4uxgT-uBn=Zf=085J0HQNy8kgDzB=kNh_dXHXQEbr83Vehw@mail.gmail.com>
Subject: Re: [PATCH 15/25] vfs: plumb RFR_* remap flags through the vfs clone functions
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Wed, Oct 10, 2018 at 3:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Plumb a remap_flags argument through the {do,vfs}_clone_file_range
> functions so that clone can take advantage of it.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
[...]
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index c8c890c22898..8b22035af4d7 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -462,7 +462,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
>
>         case OVL_CLONE:
>                 ret = vfs_clone_file_range(real_in.file, pos_in,
> -                                          real_out.file, pos_out, len);
> +                                          real_out.file, pos_out, len, flags);
>                 break;
>
>         case OVL_DEDUPE:
> @@ -509,7 +509,7 @@ static loff_t ovl_remap_file_range(struct file *file_in, loff_t pos_in,
>              !ovl_inode_upper(file_inode(file_out))))
>                 return -EPERM;
>
> -       return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> +       return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, flags,
>                             op);
>  }

This patch forgets to change args in ovl_copyfile() function definition.

Thanks,
Amir.
