Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729272AbeJAU6A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 16:58:00 -0400
Date: Mon, 1 Oct 2018 10:19:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/7] xfs: always allocate blocks as unwritten for file
 data
Message-ID: <20181001141956.GD53694@bfoster>
References: <20181001123741.32005-1-hch@lst.de>
 <20181001123741.32005-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001123741.32005-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:37:36AM -0700, Christoph Hellwig wrote:
> XFS historically had a small race that could lead to exposing
> uninitialized data in case of a crash.  If we are filling holes using
> buffered I/O we convert the delayed allocation to a real allocation
> before writing out the data.  If we crash after the blocks were
> allocated, but before the data was written this could lead to reading
> uninitialized blocks (or leaked data from a previous allocation that was
> reused).  Now that we have the CIL logging extent format changes is
> cheap, so we can switch to always allocating blocks as unwritten.
> Note that this is not be strictly necessary for writes that append
> beyond i_size, but given that we have to log a transaction in that
> case anyway we might as well give all block allocations a uniform
> treatment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

It's great that we can finally fix this, particularly with such a simple
change. IIRC, the only real thing standing in the way was the buffer
head delalloc state management mess.

>  fs/xfs/xfs_aops.c  | 3 +--
>  fs/xfs/xfs_aops.h  | 2 --
>  fs/xfs/xfs_iomap.c | 4 ++--
>  3 files changed, 3 insertions(+), 6 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 6320aca39f39..10fc93cebc42 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -662,11 +662,11 @@ xfs_iomap_write_allocate(
>  	xfs_trans_t	*tp;
>  	int		nimaps;
>  	int		error = 0;
> -	int		flags = XFS_BMAPI_DELALLOC;
> +	int		flags = XFS_BMAPI_DELALLOC | XFS_BMAPI_PREALLOC;

... though I don't quite think this is sufficient. xfs_bmapi_allocate()
has this snippet of code:

        if ((!bma->wasdel || (bma->flags & XFS_BMAPI_COWFORK)) &&
            (bma->flags & XFS_BMAPI_PREALLOC) &&
            xfs_sb_version_hasextflgbit(&mp->m_sb))
                bma->got.br_state = XFS_EXT_UNWRITTEN;

... which looks like it explicitly bypasses the PREALLOC flag for
delalloc extents. I figured this would just be an inefficiency since
prealloc conversion comes later, but if you look at
xfs_bmapi_convert_unwritten():

        /* check if we need to do real->unwritten conversion */
        if (mval->br_state == XFS_EXT_NORM &&
            (flags & (XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT)) !=
                        (XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT))
                return 0;

... it sees this as an existing extent and so doesn't change the state
unless the CONVERT flag is also passed. A quick test to shut down
immediately after the xfs_iomap_write_allocate() transaction commits
seems to confirm this behavior:

# xfs_io -c "fiemap -v" /mnt/file
/mnt/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..7]:          72..79               8   0x1

I think the right fix here is to remove the referenced logic from
xfs_bmapi_allocate(). I also think this demonstrates the need for an
xfstest. ;) Expected behavior should be easy to confirm with a new error
tag, for example.

Brian

>  	int		nres;
>  
>  	if (whichfork == XFS_COW_FORK)
> -		flags |= XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
> +		flags |= XFS_BMAPI_COWFORK;
>  
>  	/*
>  	 * Make sure that the dquots are there.
> -- 
> 2.19.0
> 
