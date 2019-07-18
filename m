Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48336 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfGRMcG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 08:32:06 -0400
Date: Thu, 18 Jul 2019 05:31:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] iomap: generalize IOMAP_INLINE to cover tail-packing
 case
Message-ID: <20190718123155.GA21252@infradead.org>
References: <20190703075502.79782-1-yuchao0@huawei.com>
 <CAHpGcM+s77hKMXo=66nWNF7YKa3qhLY9bZrdb4-Lkspyg2CCDw@mail.gmail.com>
 <39944e50-5888-f900-1954-91be2b12ea5b@huawei.com>
 <20190711122831.3970-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711122831.3970-1-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Chao Yu <yuchao0@huawei.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, chao@kernel.org

> +iomap_to_bh(struct inode *inode, struct page *page, sector_t block,
> +		struct buffer_head *bh, struct iomap *iomap)
>  {
>  	loff_t offset = block << inode->i_blkbits;
>  
> @@ -1924,6 +1924,10 @@ iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
>  				inode->i_blkbits;
>  		set_buffer_mapped(bh);
>  		break;
> +	case IOMAP_INLINE:
> +		__iomap_read_inline_data(inode, page, iomap);
> +		set_buffer_uptodate(bh);
> +		break;

I have to say I hate pushing this into the legacy buffer_head code.
My hope was that we could get rid of this code rather than adding to it.

The other issue is that this now calls iomap functions from buffer.c,
which I'd also really avoid.

That being said until the tail packing fs (erofs?) actually uses
buffer_heads we should not need this hunk, and I don't think erofs
should have any reason to use buffer_heads.

> +#define offset_in_block(offset, inode) \
> +	((unsigned long)(offset) & (i_blocksize(inode) - 1))

Make this an inline function, please.  I think we also have a few
other places that could make use of this helper, maybe it might
even go into fs.h.

Otherwise this looks sensible to me.
