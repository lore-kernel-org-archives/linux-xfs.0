Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44498 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753378AbdKCOpm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 10:45:42 -0400
Received: from [94.72.11.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAdE5-0001ip-KA
        for linux-xfs@vger.kernel.org; Fri, 03 Nov 2017 14:45:42 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: b+tree for the incore extent list V2
Date: Fri,  3 Nov 2017 17:45:18 +0300
Message-Id: <20171103144539.2187-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series first updates the incore extent list iteration to use
a cursor based scheme that hides the implementation details, and then
switch to use a b+tree to implement the in-core extent list.  This
reduces the need for a large contiguous allocation that the current
indirection array requires, and thus avoids stalls during workloads
using giant extent lists, especially on systems that are long running.

The algorithms also should be better in general, but due to the fact
the the operations on the on-disk b+tree have such a high overhead
not much that effect is seen on the usual benchmarks.

I also have a git tree available at:

    git://git.infradead.org/users/hch/xfs.git xfs-incore-btree

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-incore-btree

Changes from V1:
 - various spelling and indentation fixes
 - renamed various variables from ext to icur
 - add trace define for XFS_BMAPI_CONVERT_ONLY
 - move a few misplaced hunks into the right patch
 - fix encoding of the in-core extent format (Darrick J. Wong)
 - pass a xfs_bmbt_irec to xfs_validate_extent
 - move xfs_bmbt_irec to xfs_types.h
 - use a fixed 256 byte node size
 - use correct node entry numbers for 32-bit architectures
