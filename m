Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53110 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbfAQQgk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 11:36:40 -0500
Received: from 089144213167.atnat0022.highway.a1.net ([89.144.213.167] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gkAel-00045W-7Z
        for linux-xfs@vger.kernel.org; Thu, 17 Jan 2019 16:36:39 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: COW improvements and always_cow support V4
Date: Thu, 17 Jan 2019 17:36:25 +0100
Message-Id: <20190117163636.23171-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series adds the always_cow mode support after improving our COW
write support a little bit first.

Note that I'm mostly reposting this to get visibility for the core
fixes and improvements.  The actual always COW patch, which is last
in the series still has outstanding feedback I need to address.

The always_cow mode stresses the COW path a lot, but with a few xfstests
fixups it generall looks good, except for a few tests that complain about
fragmentation, which is rather inherent in this mode, and xfs/326 which
inserts error tags into the COW path not getting the expected result.

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
