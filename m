Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:44685 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdJKWyw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 18:54:52 -0400
Received: by mail-oi0-f46.google.com with SMTP id v132so5704299oie.1
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2017 15:54:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171011200603.27442-20-jack@suse.cz>
References: <20171011200603.27442-1-jack@suse.cz> <20171011200603.27442-20-jack@suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 15:54:51 -0700
Message-ID: <CAPcyv4jW1sz8415MBfvXkAL9wb-YQyop_o+B9gFnJ3f3xrXMzw@mail.gmail.com>
Subject: Re: [PATCH 19/19] xfs: Add support for MAP_SYNC flag
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Wed, Oct 11, 2017 at 1:06 PM, Jan Kara <jack@suse.cz> wrote:
> Now when everything is prepared, add support in xfs to accept MAP_SYNC
> as an mmap(2) flag.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c    |  1 +
>  fs/xfs/xfs_file.c | 23 +++++++++++++++++++++++
>  2 files changed, 24 insertions(+)
>
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index f013cda84b3d..6b597cc6b29d 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -26,6 +26,7 @@
>  #include <linux/quotaops.h>
>  #include <linux/pagevec.h>
>  #include <linux/uio.h>
> +#include <linux/mman.h>
>  #include "ext4.h"
>  #include "ext4_jbd2.h"
>  #include "xattr.h"
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c45f24ffab22..fb135224476d 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -44,6 +44,7 @@
>  #include <linux/falloc.h>
>  #include <linux/pagevec.h>
>  #include <linux/backing-dev.h>
> +#include <linux/mman.h>
>
>  static const struct vm_operations_struct xfs_file_vm_ops;
>
> @@ -1142,6 +1143,27 @@ xfs_file_mmap(
>         return 0;
>  }
>
> +#define XFS_MAP_SUPPORTED (LEGACY_MAP_MASK | MAP_SYNC)
> +
> +static int
> +xfs_file_mmap_validate(
> +       struct file             *filp,
> +       struct vm_area_struct   *vma,
> +       unsigned long           map_flags)
> +{
> +       if (map_flags & ~XFS_MAP_SUPPORTED)
> +               return -EOPNOTSUPP;
> +
> +       /*
> +        * We don't support synchronous mappings for non-DAX files. At least
> +        * until someone comes with a sensible use case.
> +        */
> +       if (!IS_DAX(file_inode(filp)) && (map_flags & MAP_SYNC))
> +               return -EOPNOTSUPP;

Same comment about using EPERM here. That's also what I'm returning in
the MAP_DIRECT case when the inode is a reflink inode and does not
support MAP_DIRECT.
