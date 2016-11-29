Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51995 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751726AbcK2XSf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 18:18:35 -0500
Date: Tue, 29 Nov 2016 15:18:25 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: an iomap-based direct I/O implementation V4
Message-ID: <20161129231825.GU16813@birch.djwong.org>
References: <1480440496-25737-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1480440496-25737-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, axboe@fb.com, linux-fsdevel@vger.kernel.org

On Tue, Nov 29, 2016 at 06:28:11PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds a new direct I/O implementation based on the iomap
> interface, and switches XFS to use it.
> 
> The first two patches are a resend of my earlier series to remove the
> XFS iolock.  They are needed for the lockdep assert in the new iomap
> code.
> 
> The rest implements a new iomap_dio_rw direct I/O implementation and
> switches XFS to use it.
> 
> It requires a patch from the block tree which we'll need to cherry-pick
> into the XFS tree to avoid pulling in the whole block tree:
> 
> 9cd56d91 ("block: add bio_iov_iter_get_pages()")
> 
> To make everyones lifer easie I also have a git tree that includes this
> cherry pick:
> 
>     git://git.infradead.org/users/hch/vfs.git iomap-dio.4
> 
> Note that with this patch I see somewhat increased failure rates on
> generic/209.  This is not because of any locking or invalidation changes
> in this series, but just because it's always been fundamentally race,
> and the new direct I/O code is a lot faster, which causes the direct
> writes in this test to race significantly more often with readahead.

I looked through the patches and didn't have any questions, so:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> 
> Changes since V3:
>  - untangle from the block tree
> 
> Changes since V2:
>  - added a few comments to unconfuse reviewers
>  - added a iomap_dio_set_error helper
>  - dropped support for not filling holes on writes
>  - pulled in a more recent block tree (blk_poll -> blk_mq_poll)
> 
> Changes since V1:
>  - dropped the bio_iov_iter_get_pages patch, now merged in the block tree
>  - rebased on top of a merge of the XFS tree with the block tree
>  - stopped using WRITE_ODIRECT which has been removed in the block tree
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
