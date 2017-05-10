Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34750 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753224AbdEJTI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2017 15:08:27 -0400
MIME-Version: 1.0
In-Reply-To: <20170510180214.16852-17-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de> <20170510180214.16852-17-hch@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 10 May 2017 22:08:25 +0300
Message-ID: <CAOQ4uxga2U6OS8N5MnBoytyWP8Fbf8qQCS1cnsPqjoby=Mxc1w@mail.gmail.com>
Subject: Re: [PATCH 16/16] fs: switch ->s_uuid to uuid_t
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, May 10, 2017 at 9:02 PM, Christoph Hellwig <hch@lst.de> wrote:
> For some file systems we still memcpy into it, but in various places this
> already allows us to use the proper uuid helpers.  More to come..
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Series looks good!

My main concern is that filesystems with char uuid[16] are here to stay,
or maybe, will be converted slowly.

Considering this, perhaps we should have a helper/macro to copy from
char[16] to *uuid_t and maybe  BUILD_BUG_ON the size comparison?
#define bytes_to_uuid(dst, src) ...


> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 682b336a7a6a..93a420160964 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -75,7 +75,7 @@ xfs_uuid_mount(
>
>         /* Publish UUID in struct super_block */
>         BUILD_BUG_ON(sizeof(mp->m_super->s_uuid) != sizeof(uuid_t));

This BUILD_BUG is no longer needed.

> -       memcpy(&mp->m_super->s_uuid, uuid, sizeof(uuid_t));
> +       uuid_copy(&mp->m_super->s_uuid, uuid);
>
>         if (mp->m_flags & XFS_MOUNT_NOUUID)
>                 return 0;
[...]

> diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
> index d7f282d75cc1..1d32cd20009a 100644
> --- a/security/integrity/evm/evm_crypto.c
> +++ b/security/integrity/evm/evm_crypto.c
> @@ -164,7 +164,7 @@ static void hmac_add_misc(struct shash_desc *desc, struct inode *inode,
>         hmac_misc.mode = inode->i_mode;
>         crypto_shash_update(desc, (const u8 *)&hmac_misc, sizeof(hmac_misc));
>         if (evm_hmac_attrs & EVM_ATTR_FSUUID)
> -               crypto_shash_update(desc, inode->i_sb->s_uuid,
> +               crypto_shash_update(desc, &inode->i_sb->s_uuid.b[0],

I wonder if 'inode->i_sb->s_uuid.b' would have been better here

Cheers,
Amir.
