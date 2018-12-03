Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39534 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbeLCQXS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 11:23:18 -0500
Received: from [8.46.75.6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gTr01-00021X-0H
        for linux-xfs@vger.kernel.org; Mon, 03 Dec 2018 16:23:09 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: COW improvements and always_cow support V3
Date: Mon,  3 Dec 2018 11:21:20 -0500
Message-Id: <20181203162131.11652-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series adds the always_cow mode support after improving our COW
write support a little bit first.

The always_cow mode stresses the COW path a lot, but with a few xfstests
fixups it generall looks good, except for a few tests that complain about
fragmentation, which is rather inherent in this mode, and xfs/326 which
inserts error tags into the COW path not getting the expected result.

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
