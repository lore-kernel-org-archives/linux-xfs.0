Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35798 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388273AbfGHQDw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jul 2019 12:03:52 -0400
Date: Mon, 8 Jul 2019 09:03:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH] iomap: generalize IOMAP_INLINE to cover tail-packing
 case
Message-ID: <20190708160346.GA17715@infradead.org>
References: <20190703075502.79782-1-yuchao0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703075502.79782-1-yuchao0@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chao Yu <yuchao0@huawei.com>
Cc: hch@infradead.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, andreas.gruenbacher@gmail.com, gaoxiang25@huawei.com, chao@kernel.org

On Wed, Jul 03, 2019 at 03:55:02PM +0800, Chao Yu wrote:
> Some filesystems like erofs/reiserfs have the ability to pack tail
> data into metadata, e.g.:
> IOMAP_MAPPED [0, 8192]
> IOMAP_INLINE [8192, 8200]
> 
> However current IOMAP_INLINE type has assumption that:
> - inline data should be locating at page #0.
> - inline size should equal to .i_size
> Those restriction fail to convert to use iomap IOMAP_INLINE in erofs,
> so this patch tries to relieve above limits to make IOMAP_INLINE more
> generic to cover tail-packing case.
> 
> Signed-off-by: Chao Yu <yuchao0@huawei.com>

This looks good to me, but I'd also like to see a review and gfs2
testing from Andreas.
