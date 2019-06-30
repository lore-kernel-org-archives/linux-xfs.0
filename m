Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52104 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbfF3XUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jun 2019 19:20:16 -0400
Date: Sun, 30 Jun 2019 16:19:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC] iomap: introduce IOMAP_TAIL
Message-ID: <20190630231932.GI1404256@magnolia>
References: <20190629073020.22759-1-yuchao0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190629073020.22759-1-yuchao0@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chao Yu <yuchao0@huawei.com>
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, gaoxiang25@huawei.com, chao@kernel.org

On Sat, Jun 29, 2019 at 03:30:20PM +0800, Chao Yu wrote:
> Some filesystems like erofs/reiserfs have the ability to pack tail
> data into metadata, however iomap framework can only support mapping
> inline data with IOMAP_INLINE type, it restricts that:
> - inline data should be locating at page #0.
> - inline size should equal to .i_size

Wouldn't it be easier simply to fix the meaning of IOMAP_INLINE so that
it can be used at something other than offset 0 and length == isize?
IOWs, make it mean "use the *inline_data pointer to read/write data
as a direct memory access"?

I also don't really like the idea of leaving the write paths
unimplemented in core code, though I suppose as an erofs developer
you're not likely to have a good means for testing... :/

/me starts wondering if a better solution would be to invent iomaptestfs
which exists solely to test all iomap code with as little other
intelligence as possible...

--D

> So we can not use IOMAP_INLINE to handle tail-packing case.
> 
> This patch introduces new mapping type IOMAP_TAIL to map tail-packed
> data for further use of erofs.
> 
> Signed-off-by: Chao Yu <yuchao0@huawei.com>
> ---
>  fs/iomap.c            | 22 ++++++++++++++++++++++
>  include/linux/iomap.h |  1 +
>  2 files changed, 23 insertions(+)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 12654c2e78f8..ae7777ce77d0 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -280,6 +280,23 @@ iomap_read_inline_data(struct inode *inode, struct page *page,
>  	SetPageUptodate(page);
>  }
>  
> +static void
> +iomap_read_tail_data(struct inode *inode, struct page *page,
> +		struct iomap *iomap)
> +{
> +	size_t size = i_size_read(inode) & (PAGE_SIZE - 1);
> +	void *addr;
> +
> +	if (PageUptodate(page))
> +		return;
> +
> +	addr = kmap_atomic(page);
> +	memcpy(addr, iomap->inline_data, size);
> +	memset(addr + size, 0, PAGE_SIZE - size);
> +	kunmap_atomic(addr);
> +	SetPageUptodate(page);
> +}
> +
>  static loff_t
>  iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		struct iomap *iomap)
> @@ -298,6 +315,11 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		return PAGE_SIZE;
>  	}
>  
> +	if (iomap->type == IOMAP_TAIL) {
> +		iomap_read_tail_data(inode, page, iomap);
> +		return PAGE_SIZE;
> +	}
> +
>  	/* zero post-eof blocks as the page may be mapped */
>  	iomap_adjust_read_range(inode, iop, &pos, length, &poff, &plen);
>  	if (plen == 0)
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 2103b94cb1bf..7e1ee48e3db7 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -25,6 +25,7 @@ struct vm_fault;
>  #define IOMAP_MAPPED	0x03	/* blocks allocated at @addr */
>  #define IOMAP_UNWRITTEN	0x04	/* blocks allocated at @addr in unwritten state */
>  #define IOMAP_INLINE	0x05	/* data inline in the inode */
> +#define IOMAP_TAIL	0x06	/* tail data packed in metdata */
>  
>  /*
>   * Flags for all iomap mappings:
> -- 
> 2.18.0.rc1
> 
