Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:45324 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728717AbfGKP3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jul 2019 11:29:05 -0400
MIME-Version: 1.0
References: <20190711140012.1671-1-jack@suse.cz> <20190711140012.1671-4-jack@suse.cz>
In-Reply-To: <20190711140012.1671-4-jack@suse.cz>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 Jul 2019 18:28:54 +0300
Message-ID: <CAOQ4uxh-xpwgF-wQf1ozaZ3yg8nWuBvSyLr_ZFQpkA=coW1dxA@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: Fix stale data exposure when readahead races
 with hole punch
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-xfs <linux-xfs@vger.kernel.org>, Boaz Harrosh <boaz@plexistor.com>, stable <stable@vger.kernel.org>

On Thu, Jul 11, 2019 at 5:00 PM Jan Kara <jack@suse.cz> wrote:
>
> Hole puching currently evicts pages from page cache and then goes on to
> remove blocks from the inode. This happens under both XFS_IOLOCK_EXCL
> and XFS_MMAPLOCK_EXCL which provides appropriate serialization with
> racing reads or page faults. However there is currently nothing that
> prevents readahead triggered by fadvise() or madvise() from racing with
> the hole punch and instantiating page cache page after hole punching has
> evicted page cache in xfs_flush_unmap_range() but before it has removed
> blocks from the inode. This page cache page will be mapping soon to be
> freed block and that can lead to returning stale data to userspace or
> even filesystem corruption.
>
> Fix the problem by protecting handling of readahead requests by
> XFS_IOLOCK_SHARED similarly as we protect reads.
>
> CC: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-fsdevel/CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com/
> Reported-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Looks sane. (I'll let xfs developers offer reviewed-by tags)

>  fs/xfs/xfs_file.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 76748255f843..88fe3dbb3ba2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -33,6 +33,7 @@
>  #include <linux/pagevec.h>
>  #include <linux/backing-dev.h>
>  #include <linux/mman.h>
> +#include <linux/fadvise.h>
>
>  static const struct vm_operations_struct xfs_file_vm_ops;
>
> @@ -939,6 +940,24 @@ xfs_file_fallocate(
>         return error;
>  }
>
> +STATIC int
> +xfs_file_fadvise(
> +       struct file *file,
> +       loff_t start,
> +       loff_t end,
> +       int advice)
> +{
> +       struct xfs_inode *ip = XFS_I(file_inode(file));
> +       int ret;
> +
> +       /* Readahead needs protection from hole punching and similar ops */
> +       if (advice == POSIX_FADV_WILLNEED)
> +               xfs_ilock(ip, XFS_IOLOCK_SHARED);
> +       ret = generic_fadvise(file, start, end, advice);
> +       if (advice == POSIX_FADV_WILLNEED)
> +               xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> +       return ret;
> +}
>
>  STATIC loff_t
>  xfs_file_remap_range(
> @@ -1235,6 +1254,7 @@ const struct file_operations xfs_file_operations = {
>         .fsync          = xfs_file_fsync,
>         .get_unmapped_area = thp_get_unmapped_area,
>         .fallocate      = xfs_file_fallocate,
> +       .fadvise        = xfs_file_fadvise,
>         .remap_file_range = xfs_file_remap_range,
>  };
>
> --
> 2.16.4
>
