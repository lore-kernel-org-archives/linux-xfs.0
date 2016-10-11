Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:35639 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752849AbcJKBrH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 21:47:07 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u9B1krdC009360
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 11 Oct 2016 01:46:53 GMT
Date: Mon, 10 Oct 2016 18:45:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/9] iomap: add IOMAP_REPORT
Message-ID: <20161011014546.GF22379@birch.djwong.org>
References: <1476106685-29048-1-git-send-email-hch@lst.de>
 <1476106685-29048-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476106685-29048-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 10, 2016 at 03:37:57PM +0200, Christoph Hellwig wrote:
> This allows the file system to tell a FIEMAP from a read operation, and thus
> avoids the need to report flags that aren't actually used in the read path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap.c            |  2 +-
>  include/linux/iomap.h | 17 +++++++++++------
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 013d1d3..a922040 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -561,7 +561,7 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
>  	}
>  
>  	while (len > 0) {
> -		ret = iomap_apply(inode, start, len, 0, ops, &ctx,
> +		ret = iomap_apply(inode, start, len, IOMAP_REPORT, ops, &ctx,

Hmm.  /me notices that generic/352, generic/353, and generic/372 fail after
this patchset is applied.  Will have a look at this tomorrow, unless this rings
a bell?

--D

>  				iomap_fiemap_actor);
>  		/* inode with no (attribute) mapping will give ENOENT */
>  		if (ret == -ENOENT)
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index e63e288..7892f55 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -19,11 +19,15 @@ struct vm_fault;
>  #define IOMAP_UNWRITTEN	0x04	/* blocks allocated @blkno in unwritten state */
>  
>  /*
> - * Flags for iomap mappings:
> + * Flags for all iomap mappings:
>   */
> -#define IOMAP_F_MERGED	0x01	/* contains multiple blocks/extents */
> -#define IOMAP_F_SHARED	0x02	/* block shared with another file */
> -#define IOMAP_F_NEW	0x04	/* blocks have been newly allocated */
> +#define IOMAP_F_NEW	0x01	/* blocks have been newly allocated */
> +
> +/*
> + * Flags that only need to be reported for IOMAP_REPORT requests:
> + */
> +#define IOMAP_F_MERGED	0x10	/* contains multiple blocks/extents */
> +#define IOMAP_F_SHARED	0x20	/* block shared with another file */
>  
>  /*
>   * Magic value for blkno:
> @@ -42,8 +46,9 @@ struct iomap {
>  /*
>   * Flags for iomap_begin / iomap_end.  No flag implies a read.
>   */
> -#define IOMAP_WRITE		(1 << 0)
> -#define IOMAP_ZERO		(1 << 1)
> +#define IOMAP_WRITE		(1 << 0) /* writing, must allocate blocks */
> +#define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
> +#define IOMAP_REPORT		(1 << 2) /* report extent status, e.g. FIEMAP */
>  
>  struct iomap_ops {
>  	/*
> -- 
> 2.10.1.382.ga23ca1b
> 
