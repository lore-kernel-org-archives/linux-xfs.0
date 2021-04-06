Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9169C433ED
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 13:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80ACB61279
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 13:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244287AbhDFN5h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 09:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235074AbhDFN5e (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Apr 2021 09:57:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2357B61260;
        Tue,  6 Apr 2021 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617717446;
        bh=jusJBIDBkMrA+UiQrH5Z/m+hJXbLJqQAdhkS4cyBpek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gcs2zrrO9G9fGOnaBswNr0K7DplIUHiti8KtL621M15INxJ6oRdkZ9jwbGOiE7VYV
         n0zzhBZwRvHZoP2YQLShdNCeR2f/s3YUlQHEfgYfkSDpOVK0Z8QbmP+Oi1PfDCPeU+
         8L62ctDmz8BNSfkE3qHIRSg7kPAqADbuOQJIfBUG/ewkg4RHMv6hCUyVP/bU3V8baI
         PqcCiW7vtRbpFFPCUu3BSvXpa2jnh4U4BG5eUIjl0VRtiIAqQpwTtgRH7aV3NqU0yt
         0HauBW7KHg87kqSZc+/P+LiuNurv7lOx3OTMBDSkE9OM25jH0IEO0VQ+rQ1qBbVksZ
         +N7nnHyMGsnvg==
Date:   Tue, 6 Apr 2021 06:57:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: scrub: Disable check for unoptimized data fork
 bmbt node
Message-ID: <20210406135726.GF3957620@magnolia>
References: <20210406065519.696-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406065519.696-1-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 06, 2021 at 12:25:19PM +0530, Chandan Babu R wrote:
> xchk_btree_check_minrecs() checks if the contents of the immediate child of a
> bmbt root block can fit within the root block. This check could fail on inodes
> with an attr fork since xfs_bmap_add_attrfork_btree() used to demote the
> current root node of the data fork as the child of a newly allocated root node
> if it found that the size of "struct xfs_btree_block" along with the space
> required for records exceeded that of space available in the data fork.
> 
> xfs_bmap_add_attrfork_btree() should have used "struct xfs_bmdr_block" instead
> of "struct xfs_btree_block" for the above mentioned space requirement
> calculation. This commit disables the check for unoptimized (in terms of
> disk space usage) data fork bmbt trees since there could be filesystems
> in use that already have such a layout.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> Changelog:
>  V1 -> V2:
>    1. Apply "minimum records check" restriction only to BMBT btrees.
>    
>  fs/xfs/scrub/btree.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index debf392e0515..a94bd8122c60 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -9,6 +9,7 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> +#include "xfs_inode.h"
>  #include "xfs_btree.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
> @@ -442,6 +443,30 @@ xchk_btree_check_owner(
>  	return xchk_btree_check_block_owner(bs, level, XFS_BUF_ADDR(bp));
>  }
>  
> +/* Decide if we want to check minrecs of a btree block in the inode root. */
> +static inline bool
> +xchk_btree_check_iroot_minrecs(
> +	struct xchk_btree	*bs)
> +{
> +	/*
> +	 * xfs_bmap_add_attrfork_btree had an implementation bug wherein it
> +	 * would miscalculate the space required for the data fork bmbt root
> +	 * when adding an attr fork, and promote the iroot contents to an
> +	 * external block unnecessarily.  This went unnoticed for many years
> +	 * until scrub found filesystems in this state.  Inode rooted btrees are
> +	 * not supposed to have immediate child blocks that are small enough
> +	 * that the contents could fit in the inode root, but we can't fail
> +	 * existing filesystems, so instead we disable the check for data fork
> +	 * bmap btrees when there's an attr fork.
> +	 */
> +	if (bs->cur->bc_btnum == XFS_BTNUM_BMAP &&
> +	    bs->cur->bc_ino.whichfork == XFS_DATA_FORK &&
> +	    XFS_IFORK_Q(bs->sc->ip))
> +		return false;
> +
> +	return true;
> +}
> +
>  /*
>   * Check that this btree block has at least minrecs records or is one of the
>   * special blocks that don't require that.
> @@ -475,8 +500,9 @@ xchk_btree_check_minrecs(
>  
>  		root_block = xfs_btree_get_block(cur, root_level, &root_bp);
>  		root_maxrecs = cur->bc_ops->get_dmaxrecs(cur, root_level);
> -		if (be16_to_cpu(root_block->bb_numrecs) != 1 ||
> -		    numrecs <= root_maxrecs)
> +		if (xchk_btree_check_iroot_minrecs(bs) &&
> +		    (be16_to_cpu(root_block->bb_numrecs) != 1 ||
> +		     numrecs <= root_maxrecs))
>  			xchk_btree_set_corrupt(bs->sc, cur, level);
>  		return;
>  	}
> -- 
> 2.29.2
> 
