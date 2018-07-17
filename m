Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38532 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729759AbeGQX7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jul 2018 19:59:03 -0400
Received: from sjc00ib2.hgst.com ([199.255.44.5] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ffZKB-0001DV-EQ
        for linux-xfs@vger.kernel.org; Tue, 17 Jul 2018 23:24:07 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: reduce lookups in the COW extent tree V3
Date: Tue, 17 Jul 2018 16:23:59 -0700
Message-Id: <20180717232405.18511-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This series (on top of the iomap series) reduce the number of lookups we
do in the COW tree by adding a sequence number that counts modifications
to the extent tree.

Changes since v2:
 - bump if_seq before modifying the extent tree

Changes since v1:
 - don't update wpc->cow_seq for non-COW allocations
 - update a comment
 - rebase to the lastest tree as baseline
