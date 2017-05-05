Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33066 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbdEEIoR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 May 2017 04:44:17 -0400
Received: by mail-io0-f196.google.com with SMTP id l196so9530286ioe.0
        for <linux-xfs@vger.kernel.org>; Fri, 05 May 2017 01:44:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170505075725.19597-3-hch@lst.de>
References: <20170505075725.19597-1-hch@lst.de> <20170505075725.19597-3-hch@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 5 May 2017 11:44:16 +0300
Message-ID: <CAOQ4uxg=wLW9d195W_Ro71iNZEt8jVFyVwXysd-WnuDx7ELKDw@mail.gmail.com>
Subject: Re: [PATCH 2/3] xfs: use uuid_be to implement the uuid_t type
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>

On Fri, May 5, 2017 at 10:57 AM, Christoph Hellwig <hch@lst.de> wrote:
> Use the generic Linux definition to implement our UUID type, this will
> allow using more generic infrastructure in the future.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>


> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 044fb0e15390..89ee5ec66837 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -19,6 +19,7 @@
>  #define __XFS_LINUX__
>
>  #include <linux/types.h>
> +#include <linux/uuid.h>
>
>  /*
>   * Kernel specific type declarations for XFS
> @@ -38,6 +39,8 @@ typedef __s64                 xfs_daddr_t;    /* <disk address> type */
>  typedef __u32                  xfs_dev_t;
>  typedef __u32                  xfs_nlink_t;
>
> +typedef uuid_be                        uuid_t;
> +

How about moving this typedef to linux/uuid.h.
It's weird to have a non xfs_ prefixed typedef as it was
and placing it here is even more weird.

Yes, only xfs uses uuid_t right now, but this could mark the intentions
in a central place, so other code can follow suit (i.e. libnvdimm) and
start using uuid_t as well.

I realize this series is intended to be xfs internal cleanup,
so could be part of a follow up patch set.

If this is acceptable by Andy, I can re-post my series based on top
of this one to hoist uuid_t and the rest of the xfs helpers to linux/uuid.h.

Amir.
