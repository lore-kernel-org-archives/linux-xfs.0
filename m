Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:41973 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752036AbeFFLhD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jun 2018 07:37:03 -0400
Received: by mail-io0-f195.google.com with SMTP id t5-v6so7194068ioa.8
        for <linux-xfs@vger.kernel.org>; Wed, 06 Jun 2018 04:37:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180606104033.4947-3-hch@lst.de>
References: <20180606104033.4947-1-hch@lst.de> <20180606104033.4947-3-hch@lst.de>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 6 Jun 2018 13:37:02 +0200
Message-ID: <CAHc6FU5xFMmN1EPGrZOhx9S5Focwq0Ky9HZeQ9VRGFC-o-cZZw@mail.gmail.com>
Subject: Re: [PATCH 2/6] iomap: move bdev and dax_dev in a union
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>, linux-ext4 <linux-ext4@vger.kernel.org>

On 6 June 2018 at 12:40, Christoph Hellwig <hch@lst.de> wrote:
> We always either ask for a block device or DAX device mapping, so we can
> use the same space for both.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/ext2/inode.c       | 6 ++++--
>  fs/ext4/inode.c       | 6 ++++--
>  fs/xfs/xfs_iomap.c    | 6 ++++--
>  include/linux/iomap.h | 6 ++++--
>  4 files changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 71635909df3b..8aead4e9dbc1 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -815,9 +815,11 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>                 return ret;
>
>         iomap->flags = 0;
> -       iomap->bdev = inode->i_sb->s_bdev;
>         iomap->offset = (u64)first_block << blkbits;
> -       iomap->dax_dev = sbi->s_daxdev;
> +       if (IS_DAX(inode))
> +               iomap->dax_dev = sbi->s_daxdev;
> +       else
> +               iomap->bdev = inode->i_sb->s_bdev;
>
>         if (ret == 0) {
>                 iomap->type = IOMAP_HOLE;
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 2ea07efbe016..79027e99118f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3524,8 +3524,10 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>         iomap->flags = 0;
>         if (ext4_inode_datasync_dirty(inode))
>                 iomap->flags |= IOMAP_F_DIRTY;
> -       iomap->bdev = inode->i_sb->s_bdev;
> -       iomap->dax_dev = sbi->s_daxdev;
> +       if (IS_DAX(inode))
> +               iomap->dax_dev = sbi->s_daxdev;
> +       else
> +               iomap->bdev = inode->i_sb->s_bdev;
>         iomap->offset = (u64)first_block << blkbits;
>         iomap->length = (u64)map.m_len << blkbits;
>
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index c6ce6f9335b6..587110db1ad2 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -70,8 +70,10 @@ xfs_bmbt_to_iomap(
>         }
>         iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
>         iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
> -       iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
> -       iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
> +       if (IS_DAX(VFS_I(ip)))
> +               iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
> +       else
> +               iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));

This seems backwards.

>  }
>
>  xfs_extlen_t
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index a044a824da85..212f4d59bcbf 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -53,8 +53,10 @@ struct iomap {
>         u64                     length; /* length of mapping, bytes */
>         u16                     type;   /* type of mapping */
>         u16                     flags;  /* flags for mapping */
> -       struct block_device     *bdev;  /* block device for I/O */
> -       struct dax_device       *dax_dev; /* dax_dev for dax operations */
> +       union {
> +               struct block_device *bdev;
> +               struct dax_device   *dax_dev;
> +       };
>  };
>
>  /*
> --
> 2.14.2
>

Andreas
