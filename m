Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:18414 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726437AbeLNDFt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Dec 2018 22:05:49 -0500
Date: Fri, 14 Dec 2018 14:05:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] iomap: optimize iomap_is_partially_uptodate for full
 page range
Message-ID: <20181214030528.GK6311@dastard>
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
 <1544739929-21651-4-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1544739929-21651-4-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph@sandeen.net, Hellwig@sandeen.net, hch@lst.de

On Thu, Dec 13, 2018 at 04:25:29PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> We only call ->is_partially_uptodate to look for an uptodate range
> within a not-uptodate page.
> 
> If the range covers all blocks in the page, there is no point to checking
> each block individually - if the whole range (i.e. the whole page) were
> uptodate, the page would be uptodate as well.  Hence in this case, we
> can return early and skip the loop.
> 
> This is similar to what is done in block_is_partially_uptodate().
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>  fs/iomap.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index ce837d9..7d7d985 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -515,6 +515,10 @@ struct iomap_readpage_ctx {
>  	first = from >> inode->i_blkbits;
>  	last = (from + len - 1) >> inode->i_blkbits;
>  
> +	/* If page wasn't uptodate and range covers all blocks: no partial */
> +	if (first == 0 && last == (PAGE_SIZE - 1) >> inode->i_blkbits)
> +		return 0;
> +

Even if the range covers the entire page, we still have to check
that all the individual blocks in the page are up to date or not.
Hence I think this is wrong....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
