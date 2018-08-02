Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52014 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbeHCBcQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Aug 2018 21:32:16 -0400
Date: Thu, 2 Aug 2018 13:08:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs: fix iomap_bmap position calculation
Message-ID: <20180802200852.GU30972@magnolia>
References: <78937e83-5665-11bf-14a6-7815221bf4d8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78937e83-5665-11bf-14a6-7815221bf4d8@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Thu, Aug 02, 2018 at 03:03:51PM -0500, Eric Sandeen wrote:
> The position calculation in iomap_bmap() shifts bno the wrong way,
> so we don't progress properly and end up re-mapping block zero
> over and over, yielding an unchanging physical block range as the
> logical block advances:
> 
> # filefrag -Be file
>  ext:   logical_offset:     physical_offset: length:   expected: flags:
>    0:      0..       0:      21..        21:      1:             merged
>    1:      1..       1:      21..        21:      1:         22: merged
> Discontinuity: Block 1 is at 21 (was 22)
>    2:      2..       2:      21..        21:      1:         22: merged
> Discontinuity: Block 2 is at 21 (was 22)
>    3:      3..       3:      21..        21:      1:         22: merged
> 
> This breaks the FIBMAP interface for anyone using it (XFS), which
> in turn breaks LILO, zipl, etc.
> 
> Bug-actually-spotted-by: Darrick J. Wong <darrick.wong@oracle.com> 
> Fixes: 89eb1906a953 ("iomap: add an iomap-based bmap implementation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 77397b5a96ef..0d0bd8845586 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -1443,7 +1443,7 @@ iomap_bmap(struct address_space *mapping, sector_t bno,
>  		const struct iomap_ops *ops)
>  {
>  	struct inode *inode = mapping->host;
> -	loff_t pos = bno >> inode->i_blkbits;
> +	loff_t pos = bno << inode->i_blkbits;
>  	unsigned blocksize = i_blocksize(inode);
>  
>  	if (filemap_write_and_wait(mapping))
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
