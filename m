Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26628 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbdBOCRs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2017 21:17:48 -0500
Date: Tue, 14 Feb 2017 18:17:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix len comparison in xfs_extent_busy_trim
Message-ID: <20170215021734.GA9303@birch.djwong.org>
References: <20170214170836.2705798-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170214170836.2705798-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org

On Tue, Feb 14, 2017 at 06:08:30PM +0100, Arnd Bergmann wrote:
> The length is now passed by reference, so the assertion has to be updated
> to match the other changes, as pointed out by this W=1 warning:
> 
> fs/xfs/xfs_extent_busy.c: In function 'xfs_extent_busy_trim':
> fs/xfs/xfs_extent_busy.c:356:13: error: ordered comparison of pointer with integer zero [-Werror=extra]
> 
> Fixes: ebf55872616c ("xfs: improve handling of busy extents in the low-level allocator")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied (4.11).

--D

> ---
>  fs/xfs/xfs_extent_busy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index ab062610234e..77760dbf0242 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -353,7 +353,7 @@ xfs_extent_busy_trim(
>  	struct rb_node		*rbp;
>  	bool			ret = false;
>  
> -	ASSERT(len > 0);
> +	ASSERT(*len > 0);
>  
>  	spin_lock(&args->pag->pagb_lock);
>  restart:
> -- 
> 2.9.0
> 
