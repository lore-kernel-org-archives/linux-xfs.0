Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35502 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbeK1SO7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 13:14:59 -0500
Date: Tue, 27 Nov 2018 23:14:20 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix PAGE_MASK usage in xfs_free_file_space
Message-ID: <20181128071420.GA10864@infradead.org>
References: <20181127234334.GB8125@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127234334.GB8125@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Nov 27, 2018 at 03:43:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit e53c4b598, I *tried* to teach xfs to force writeback when we
> fzero/fpunch right up to EOF so that if EOF is in the middle of a page,
> the post-EOF part of the page gets zeroed before we return to userspace.
> Unfortunately, I missed the part where PAGE_MASK is ~(PAGE_SIZE - 1),
> which means that we totally fail to zero if we're fpunching and EOF is
> within the first page.  Worse yet, the same PAGE_MASK thinko plagues the
> filemap_write_and_wait_range call, so we'd initiate writeback of the
> entire file, which (mostly) masked the thinko.
> 
> Drop the tricky PAGE_MASK and replace it with correct usage of PAGE_SIZE
> and the proper rounding macros.
> 
> Fixes: e53c4b598 ("xfs: ensure post-EOF zeroing happens after zeroing part of a file")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks.  This also happens to be much more readable as well:

Reviewed-by: Christoph Hellwig <hch@lst.de>
