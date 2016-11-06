Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:24962 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750909AbcKFWDo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Nov 2016 17:03:44 -0500
Date: Mon, 7 Nov 2016 09:02:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: provide helper for counting extents from
 if_bytes
Message-ID: <20161106220258.GM14023@dastard>
References: <d279d52e-49f6-6fc2-c78b-0054d7ee0a1e@redhat.com>
 <6191b8d6-4a89-0191-728a-18ebdf9254c6@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6191b8d6-4a89-0191-728a-18ebdf9254c6@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 04, 2016 at 09:27:18PM -0500, Eric Sandeen wrote:
> The open-coded pattern:
> 
> ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)
> 
> is all over the xfs code; provide a new helper
> xfs_iext_count(ifp) to count the number of inline extents
> in an inode fork.
....
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 5dd56d3..a9e4904 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -775,6 +775,16 @@
>  	}
>  }
>  
> +/* Count number of inline extents based on if_bytes */
> +xfs_extnum_t
> +xfs_iext_count(struct xfs_ifork *ifp)
> +{
> +	xfs_extnum_t	nextents;
> +
> +	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
> +	return nextents;
> +}

Why not just "return ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);"?

Otherwise looks good - a needed cleanup.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
