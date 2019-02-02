Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34504 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbfBBQId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 11:08:33 -0500
Date: Sat, 2 Feb 2019 08:08:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 5/6] xfs: create delalloc bmapi wrapper for full
 extent allocation
Message-ID: <20190202160832.GA12373@infradead.org>
References: <20190201143256.43232-1-bfoster@redhat.com>
 <20190201143256.43232-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201143256.43232-6-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 01, 2019 at 09:32:55AM -0500, Brian Foster wrote:
> The writeback delalloc conversion code is racy with respect to
> changes in the currently cached file mapping. This stems from the
> fact that the bmapi allocation code requires a file range to
> allocate and the writeback conversion code assumes the range of the
> currently cached mapping is still valid with respect to the fork. It
> may not be valid, however, because the ilock is cycled (potentially
> multiple times) between the time the cached mapping was populated
> and the delalloc conversion occurs.
> 
> To facilitate a solution to this problem, create a new
> xfs_bmapi_delalloc() wrapper to xfs_bmapi_write() that takes a file
> (FSB) offset and attempts to allocate whatever delalloc extent backs
> the offset. Use a new bmapi flag to cause xfs_bmapi_write() to set
> the range based on the extent backing the bno parameter unless bno
> lands in a hole. If bno does land in a hole, fall back to the
> current behavior (which may result in an error or quietly skipping
> holes in the specified range depending on other parameters). This
> patch does not change behavior.
> 
> [hch: Rename helper function and tweak interface.]
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  Feel free to drop the [hch: ] note and replace my
signoff for that with a:

Reviewed-by: Christoph Hellwig <hch@lst.de>

for the whole patch.
