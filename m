Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39740 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753473AbdJaOWe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 10:22:34 -0400
Received: from bzq-164-168-31-210.red.bezeqint.net ([31.168.164.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e9XR3-0007Yc-V6
        for linux-xfs@vger.kernel.org; Tue, 31 Oct 2017 14:22:34 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: b+tree for the incore extent list
Date: Tue, 31 Oct 2017 16:22:12 +0200
Message-Id: <20171031142230.11755-1-hch@lst.de>
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
