Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42670 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750745AbdDMO2C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 10:28:02 -0400
Subject: Re: [PATCH] mkfs: remove leftover blkid include
References: <20170413135122.16730-1-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4669c4ed-dd3c-0ebe-8871-fc18004cb4e8@sandeen.net>
Date: Thu, 13 Apr 2017 09:28:00 -0500
MIME-Version: 1.0
In-Reply-To: <20170413135122.16730-1-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On 4/13/17 8:51 AM, Christoph Hellwig wrote:
> All topology handling moved to libxcmd a while ago.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 6fedc05c..23e3e330 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -18,9 +18,6 @@
>  
>  #include "libxfs.h"
>  #include <ctype.h>
> -#ifdef ENABLE_BLKID
> -#  include <blkid/blkid.h>
> -#endif /* ENABLE_BLKID */
>  #include "xfs_multidisk.h"
>  #include "libxcmd.h"
>  
> 
