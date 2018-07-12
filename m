Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37876 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbeGLN6y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jul 2018 09:58:54 -0400
Received: from 213-225-6-92.nat.highway.a1.net ([213.225.6.92] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fdby6-0008Eo-T5
        for linux-xfs@vger.kernel.org; Thu, 12 Jul 2018 13:49:15 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: reduce lookups in the COW extent tree V2
Date: Thu, 12 Jul 2018 15:49:04 +0200
Message-Id: <20180712134910.30298-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This series (on top of the iomap series) reduce the number of lookups we
do in the COW tree by adding a sequence number that counts modifications
to the extent tree.

Changes since v1:
 - don't update wpc->cow_seq for non-COW allocations
 - update a comment
 - rebase to the lastest tree as baseline
