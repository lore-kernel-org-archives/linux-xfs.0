Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:35602 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751862AbdDKAHh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2017 20:07:37 -0400
Date: Tue, 11 Apr 2017 10:03:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs_db: use iocursor type to guess btree geometry if
 bad magic
Message-ID: <20170411000332.GB12369@dastard>
References: <149186446125.32572.5134583964816531229.stgit@birch.djwong.org>
 <149186447366.32572.11858750403661352513.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149186447366.32572.11858750403661352513.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Mon, Apr 10, 2017 at 03:47:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The function block_to_bt plays an integral role in determining the btree
> geometry of a block that we want to manipulate with the debugger.
> Normally we use the block magic to find the geometry profile, but if the
> magic is bad we'll never find it and return NULL.  The callers of this
> function do not check for NULL and crash.
> 
> Therefore, if we can't find a geometry profile matching the magic
> number, use the iocursor type to guess the profile and scowl about that
> to stdout.  This makes it so that even with a corrupt magic we can try
> to print the fields instead of crashing the debugger.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: be less macro-happy and only evaluate hascrc once
> ---
>  db/btblock.c |   52 ++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 44 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/db/btblock.c b/db/btblock.c
> index 835a5f0..e494f3e 100644
> --- a/db/btblock.c
> +++ b/db/btblock.c
> @@ -25,6 +25,8 @@
>  #include "print.h"
>  #include "bit.h"
>  #include "init.h"
> +#include "io.h"
> +#include "output.h"
>  
>  /*
>   * Definition of the possible btree block layouts.
> @@ -122,13 +124,50 @@ static struct xfs_db_btree *
>  block_to_bt(
>  	struct xfs_btree_block	*bb)
>  {
> -	struct xfs_db_btree *btp = &btrees[0];
> +	struct xfs_db_btree	*btp;
> +	uint32_t		magic;
> +	bool			crc;
> +
> +	magic = be32_to_cpu((bb)->bb_magic);
> +	for (btp = &btrees[0]; btp->magic != 0; btp++)
> +		if (magic == btp->magic)
> +			return btp;

{}

-Dave.
-- 
Dave Chinner
david@fromorbit.com
