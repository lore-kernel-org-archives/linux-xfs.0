Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43876 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfBRJSf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 04:18:35 -0500
Received: from [88.128.83.71] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvf4N-0002cy-3M
        for linux-xfs@vger.kernel.org; Mon, 18 Feb 2019 09:18:35 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: COW improvements and always_cow support V5
Date: Mon, 18 Feb 2019 10:18:19 +0100
Message-Id: <20190218091827.12619-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series adds the always_cow mode support after fixing various
little bugs and issues in the COW support.
write support a little bit first.


    git://git.infradead.org/users/hch/xfs.git always_cow.7

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/always_cow.7


Changes since v4:
 - rebased on to of the mapping validation fixes from Brian and me
 - fix SEEK_DATA / SEEK_HOLE vs COW fork preallocations
 - sample the always_cow value in a per-mount variable
 - disable all preallocation, including in zero range and unshare

Changes since v3:
 - spelling fixes
 - improve argument naming and add a comment in xfs_reflink_allocate_cow
 - trace the COW imap if allocating COW blocks
 - collect a few reviewed-by tags from Darrick

Changes since v2:
 - add a patch to remove xfs_trim_extent_eof
 - add a patch to remove the separate io_type and rely on existing state
   in the writeback path
 - rework the truncate race handling in the writeback path a little more

Changes since v1:
 - make delalloc and unwritten extent conversions simpler and more robust
 - add a few additional cleanups
 - support all fallocate modes but actual preallocation
 - rebase on top of a fix from Brian (which is included as first patch
   to make the patch set more usable)
