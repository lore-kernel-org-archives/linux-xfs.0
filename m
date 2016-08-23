Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BB5A67CA0
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 20:27:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F0FBAC001
	for <xfs@oss.sgi.com>; Mon, 22 Aug 2016 18:27:27 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id hXkhLGx38LJFDwHX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Aug 2016 18:27:25 -0700 (PDT)
Date: Mon, 22 Aug 2016 18:27:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: don't set FIEMAP_EXTENT_MERGED for extent based
	filesystems
Message-ID: <20160823012719.GF8268@birch.djwong.org>
References: <1471816023-28739-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1471816023-28739-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, agruenba@redhat.com, xfs@oss.sgi.com

On Sun, Aug 21, 2016 at 11:47:03PM +0200, Christoph Hellwig wrote:
> Filesystems like XFS that use extents should not set the
> FIEMAP_EXTENT_MERGED flag in the fiemap extent structures.  To allow
> for both behaviors for the upcoming gfs2 usage split the iomap
> type field into type and flags, and only set FIEMAP_EXTENT_MERGED if
> the IOMAP_F_MERGED flag is set.  The flags field will also come in
> handy for future features such as shared extents on reflink-enabled
> file systems.

You can add an:
Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

I'm going to send in a similar patch adding a SHARED flag when I
send out the XFS reflink series for review later this week.

--D

> 
> Reported-by: Andreas Gruenbacher <agruenba@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap.c            | 5 ++++-
>  include/linux/iomap.h | 8 +++++++-
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 0342254..706270f 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -428,9 +428,12 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
>  		break;
>  	}
>  
> +	if (iomap->flags & IOMAP_F_MERGED)
> +		flags |= FIEMAP_EXTENT_MERGED;
> +
>  	return fiemap_fill_next_extent(fi, iomap->offset,
>  			iomap->blkno != IOMAP_NULL_BLOCK ? iomap->blkno << 9: 0,
> -			iomap->length, flags | FIEMAP_EXTENT_MERGED);
> +			iomap->length, flags);
>  
>  }
>  
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 3267df4..3d70ece 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -19,6 +19,11 @@ struct vm_fault;
>  #define IOMAP_UNWRITTEN	0x04	/* blocks allocated @blkno in unwritten state */
>  
>  /*
> + * Flags for iomap mappings:
> + */
> +#define IOMAP_F_MERGED	0x01	/* contains multiple blocks/extents */
> +
> +/*
>   * Magic value for blkno:
>   */
>  #define IOMAP_NULL_BLOCK -1LL	/* blkno is not valid */
> @@ -27,7 +32,8 @@ struct iomap {
>  	sector_t		blkno;	/* 1st sector of mapping, 512b units */
>  	loff_t			offset;	/* file offset of mapping, bytes */
>  	u64			length;	/* length of mapping, bytes */
> -	int			type;	/* type of mapping */
> +	u16			type;	/* type of mapping */
> +	u16			flags;	/* flags for mapping */
>  	struct block_device	*bdev;	/* block device for I/O */
>  };
>  
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
