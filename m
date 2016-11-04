Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52751 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936176AbcKDQVV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 12:21:21 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: an iomap-based direct I/O implementation V2
Date: Fri,  4 Nov 2016 10:21:14 -0600
Message-Id: <1478276479-10749-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: axboe@fb.com, kent.overstreet@gmail.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

Hi all,

this series adds a new direct I/O implementation based on the iomap
interface, and switches XFS to use it.

The first two patches are a resend of my earlier series to remove the
XFS iolock.  They are needed for the lockdep assert in the new iomap
code.

The rest implements a new iomap_dio_rw direct I/O implementation and
switches XFS to use it.

Note that this series is on top of a merge of the XFS for-next
tree with the block tree, which has a new helper needed for this
implementation.  This is the block tree it's on top of:

    git://git.kernel.dk/linux-block for-4.10/block

To make everyones life easier І also have a git tree with the merge
plus the patches in this series available here:

    git://git.infradead.org/users/hch/vfs.git iomap-dio.2

Changes since V1:
 - dropped the bio_iov_iter_get_pages patch, now merged in the block tree
 - rebased on top of a merge of the XFS tree with the block tree
 - stopped using WRITE_ODIRECT which has been removed in the block tree
