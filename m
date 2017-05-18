Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756471AbdERN1T (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 May 2017 09:27:19 -0400
Date: Thu, 18 May 2017 09:27:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/23] xfs: use uuid_be to implement the uuid_t type
Message-ID: <20170518132709.GD18240@bfoster.bfoster>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518062705.25902-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org

On Thu, May 18, 2017 at 08:26:44AM +0200, Christoph Hellwig wrote:
> Use the generic Linux definition to implement our UUID type, this will
> allow using more generic infrastructure in the future.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/uuid.h      | 4 ----
>  fs/xfs/xfs_linux.h | 3 +++
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
> index 104db0f3bed6..4f1441ba4fa5 100644
> --- a/fs/xfs/uuid.h
> +++ b/fs/xfs/uuid.h
> @@ -18,10 +18,6 @@
>  #ifndef __XFS_SUPPORT_UUID_H__
>  #define __XFS_SUPPORT_UUID_H__
>  
> -typedef struct {
> -	unsigned char	__u_bits[16];
> -} uuid_t;
> -
>  extern int uuid_is_nil(uuid_t *uuid);
>  extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
>  extern void uuid_getnodeuniq(uuid_t *uuid, int fsid [2]);
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
> @@ -38,6 +39,8 @@ typedef __s64			xfs_daddr_t;	/* <disk address> type */
>  typedef __u32			xfs_dev_t;
>  typedef __u32			xfs_nlink_t;
>  
> +typedef uuid_be			uuid_t;
> +
>  #include "xfs_types.h"
>  
>  #include "kmem.h"
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
