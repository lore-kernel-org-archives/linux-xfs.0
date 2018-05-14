Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38396 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753247AbeENQAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 May 2018 12:00:13 -0400
Subject: Re: [PATCH 31/33] iomap: add support for sub-pagesize buffered I/O
 without buffer heads
References: <20180509074830.16196-1-hch@lst.de>
 <20180509074830.16196-32-hch@lst.de>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <eebcc4bf-f646-edc6-264b-124b3880f3cb@suse.de>
Date: Mon, 14 May 2018 11:00:08 -0500
MIME-Version: 1.0
In-Reply-To: <20180509074830.16196-32-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org



On 05/09/2018 02:48 AM, Christoph Hellwig wrote:
> After already supporting a simple implementation of buffered writes for
> the blocksize == PAGE_SIZE case in the last commit this adds full support
> even for smaller block sizes.   There are three bits of per-block
> information in the buffer_head structure that really matter for the iomap
> read and write path:
> 
>  - uptodate status (BH_uptodate)
>  - marked as currently under read I/O (BH_Async_Read)
>  - marked as currently under write I/O (BH_Async_Write)
> 
> Instead of having new per-block structures this now adds a per-page
> structure called struct iomap_page to track this information in a slightly
> different form:
> 
>  - a bitmap for the per-block uptodate status.  For worst case of a 64k
>    page size system this bitmap needs to contain 128 bits.  For the
>    typical 4k page size case it only needs 8 bits, although we still
>    need a full unsigned long due to the way the atomic bitmap API works.
>  - two atomic_t counters are used to track the outstanding read and write
>    counts
> 
> There is quite a bit of boilerplate code as the buffered I/O path uses
> various helper methods, but the actual code is very straight forward.
> 
> In this commit the code can't actually be used yet, as we need to
> switch from the old implementation to the new one together with the
> XFS writeback code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap.c            | 262 +++++++++++++++++++++++++++++++++++++-----
>  include/linux/iomap.h |  32 ++++++
>  2 files changed, 264 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index a3861945504f..4e7ac6aa88ef 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -17,6 +17,7 @@
>  #include <linux/iomap.h>
>  #include <linux/uaccess.h>
>  #include <linux/gfp.h>
> +#include <linux/migrate.h>
>  #include <linux/mm.h>
>  #include <linux/mm_inline.h>
>  #include <linux/swap.h>
> @@ -109,6 +110,107 @@ iomap_block_needs_zeroing(struct inode *inode, loff_t pos, struct iomap *iomap)
>         return iomap->type != IOMAP_MAPPED || pos > i_size_read(inode);
>  }
>  
> +static struct iomap_page *
> +iomap_page_create(struct inode *inode, struct page *page)
> +{
> +	struct iomap_page *iop = to_iomap_page(page);
> +
> +	if (iop || i_blocksize(inode) == PAGE_SIZE)
> +		return iop;

Why is this an equal comparison operator? Shouldn't this be >= to
include filesystem blocksize greater than PAGE_SIZE?

-- 
Goldwyn
