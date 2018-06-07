Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36306 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750897AbeFGF45 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 01:56:57 -0400
Subject: Re: [PATCH 2/2] xfs: xfs_reflink_convert_cow() memory allocation
 deadlock
References: <20180607052132.6207-1-david@fromorbit.com>
 <20180607052132.6207-3-david@fromorbit.com>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <77a374f5-3d05-5d53-0253-265c801eb2f8@oracle.com>
Date: Wed, 6 Jun 2018 22:56:50 -0700
MIME-Version: 1.0
In-Reply-To: <20180607052132.6207-3-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 06/06/2018 10:21 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_reflink_convert_cow() manipulates the incore extent list
> in GFP_KERNEL context in the IO submission path whilst holding
> locked pages under writeback. This is a memory reclaim deadlock
> vector. This code is not in a transaction, so any memory allocations
> it makes aren't protected via the memalloc_nofs_save() context that
> transactions carry.
> 
> Hence we need to run this call under memalloc_nofs_save() context to
> prevent potential memory allocations from being run as GFP_KERNEL
> and deadlocking.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>   fs/xfs/xfs_aops.c  | 11 +++++++++++
>   fs/xfs/xfs_buf.c   |  1 -
>   fs/xfs/xfs_linux.h |  1 +
>   3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 767d53222f31..1eb625fdcb1e 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -531,8 +531,19 @@ xfs_submit_ioend(
>   {
>   	/* Convert CoW extents to regular */
>   	if (!status && ioend->io_type == XFS_IO_COW) {
> +		/*
> +		 * Yuk. This can do memory allocation, but is not a
> +		 * transactional operation so everything is done in GFP_KERNEL
> +		 * context. That can deadlock, because we hold pages in
> +		 * writeback state and GFP_KERNEL allocations can block on them.
> +		 * Hence we must operate in nofs conditions here.
> +		 */
> +		unsigned nofs_flag;
> +
> +		nofs_flag = memalloc_nofs_save();
>   		status = xfs_reflink_convert_cow(XFS_I(ioend->io_inode),
>   				ioend->io_offset, ioend->io_size);
> +		memalloc_nofs_restore(nofs_flag);
>   	}
>   
>   	/* Reserve log space if we might write beyond the on-disk inode size. */
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 980bc48979e9..e9c058e3761c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -21,7 +21,6 @@
>   #include <linux/migrate.h>
>   #include <linux/backing-dev.h>
>   #include <linux/freezer.h>
> -#include <linux/sched/mm.h>
>   
>   #include "xfs_format.h"
>   #include "xfs_log_format.h"
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index ae1e66fa3f61..1631cf4546f2 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -26,6 +26,7 @@ typedef __u32			xfs_nlink_t;
>   
>   #include <linux/semaphore.h>
>   #include <linux/mm.h>
> +#include <linux/sched/mm.h>
>   #include <linux/kernel.h>
>   #include <linux/blkdev.h>
>   #include <linux/slab.h>
> 
Looks, ok.  Was moving the header include intentional?  Just clean up 
maybe?  Other than that, looks good.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
