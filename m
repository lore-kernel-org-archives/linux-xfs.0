Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43972 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753048AbcK2R2V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 12:28:21 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: an iomap-based direct I/O implementation V4
Date: Tue, 29 Nov 2016 18:28:11 +0100
Message-Id: <1480440496-25737-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: axboe@fb.com, linux-fsdevel@vger.kernel.org

Hi all,

this series adds a new direct I/O implementation based on the iomap
interface, and switches XFS to use it.

The first two patches are a resend of my earlier series to remove the
XFS iolock.  They are needed for the lockdep assert in the new iomap
code.

The rest implements a new iomap_dio_rw direct I/O implementation and
switches XFS to use it.

It requires a patch from the block tree which we'll need to cherry-pick
into the XFS tree to avoid pulling in the whole block tree:

9cd56d91 ("block: add bio_iov_iter_get_pages()")

To make everyones lifer easie I also have a git tree that includes this
cherry pick:

    git://git.infradead.org/users/hch/vfs.git iomap-dio.4

Note that with this patch I see somewhat increased failure rates on
generic/209.  This is not because of any locking or invalidation changes
in this series, but just because it's always been fundamentally race,
and the new direct I/O code is a lot faster, which causes the direct
writes in this test to race significantly more often with readahead.


Changes since V3:
 - untangle from the block tree

Changes since V2:
 - added a few comments to unconfuse reviewers
 - added a iomap_dio_set_error helper
 - dropped support for not filling holes on writes
 - pulled in a more recent block tree (blk_poll -> blk_mq_poll)

Changes since V1:
 - dropped the bio_iov_iter_get_pages patch, now merged in the block tree
 - rebased on top of a merge of the XFS tree with the block tree
 - stopped using WRITE_ODIRECT which has been removed in the block tree
