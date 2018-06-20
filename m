Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752792AbeFTIf0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jun 2018 04:35:26 -0400
Date: Wed, 20 Jun 2018 00:34:35 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: More robust inode extent count validation
Message-ID: <20180620073435.GB5257@infradead.org>
References: <20180619024128.22669-1-david@fromorbit.com>
 <20180619024128.22669-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619024128.22669-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 19, 2018 at 12:41:28PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When the inode is in extent format, it can't have more extents that
> fit in the inode fork. We don't currenty check this, and so this
> corruption goes unnoticed by the inode verifiers. This can lead to
> crashes operating on invalid in-memory structures.
> 
> Attempts to access such a inode will now error out in the verifier
> rather than allowing modification operations to proceed.
> 
> Reported-by: Wen Xu <wen.xu@gatech.edu>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h    |  3 ++
>  fs/xfs/libxfs/xfs_inode_buf.c | 74 +++++++++++++++++++++--------------
>  2 files changed, 48 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 1c5a8aaf2bfc..1cb298fec274 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -962,6 +962,9 @@ typedef enum xfs_dinode_fmt {
>  		XFS_DFORK_DSIZE(dip, mp) : \
>  		XFS_DFORK_ASIZE(dip, mp))
>  
> +#define XFS_DFORK_MAXEXT(dip, mp, w) \
> +	(XFS_DFORK_SIZE(dip, mp, w) / sizeof(xfs_bmbt_rec_t))

struct xfs_bmbt_rec, please.

Also do we really need this macro instead of just open coding it?

> +		if (di_nextents)
> +			return __this_address;
> +		/* fall through */

seems weird to fall through when the next check is just for di_nextents
again.  I'd rather break out of the switch and have the common
validation after it.

But the basic of the patch look fine to me.
