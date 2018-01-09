Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:62107 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752691AbeAIXIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 18:08:47 -0500
Date: Wed, 10 Jan 2018 10:04:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: use %px for data pointers when debugging
Message-ID: <20180109230409.GP16421@dastard>
References: <151553075309.16288.5030700495895866371.stgit@magnolia>
 <151553077155.16288.9554063846414673501.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151553077155.16288.9554063846414673501.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 09, 2018 at 12:46:11PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Starting with commit 57e734423ad ("vsprintf: refactor %pK code out of
> pointer"), the behavior of the raw '%p' printk format specifier was
> changed to print a 32-bit hash of the pointer value to avoid leaking
> kernel pointers into dmesg.  For most situations that's good.
> 
> This is /undesirable/ behavior when we're trying to debug XFS, however,
> so define a PTR_FMT that prints the actual pointer when we're in debug
> mode.
> 
> Note that %p for tracepoints still prints the raw pointer, so in the
> long run we could consider rewriting some of these messages as
> tracepoints.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

It sucks to have to play games like this, but we have to be able to
debug the code somehow....

> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index fd03780..0949bab 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -291,4 +291,10 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
>  #define XFS_IS_REALTIME_MOUNT(mp) (0)
>  #endif
>  
> +#ifdef DEBUG
> +# define PTR_FMT "%px"
> +#else
> +# define PTR_FMT "%p"
> +#endif

Can you add a comment here explaining why this is different?

Otherwise it looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
