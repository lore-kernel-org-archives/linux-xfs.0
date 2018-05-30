Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56016 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932408AbeE3XrG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 19:47:06 -0400
Date: Thu, 31 May 2018 09:47:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/13] xfs: use iomap for blocksize == PAGE_SIZE readpage
 and readpages
Message-ID: <20180530234703.GK10363@dastard>
References: <20180530095813.31245-1-hch@lst.de>
 <20180530095813.31245-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530095813.31245-14-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 30, 2018 at 11:58:13AM +0200, Christoph Hellwig wrote:
> For file systems with a block size that equals the page size we never do
> partial reads, so we can use the buffer_head-less iomap versions of
> readpage and readpages without conflicting with the buffer_head structures
> create later in write_begin.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
