Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59398 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfFETPO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:14 -0400
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbNR-0001sl-ES
        for linux-xfs@vger.kernel.org; Wed, 05 Jun 2019 19:15:13 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: use bios directly in the log code v4
Date: Wed,  5 Jun 2019 21:14:47 +0200
Message-Id: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series switches the log writing and log recovery code to use bios
directly, and remove various special cases from the buffer cache code.

A git tree is available here:

    git://git.infradead.org/users/hch/xfs.git xfs-log-bio

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-bio

Chances since v3:
 - add a few additional cleanup patches
 - clean up iclog allocation
 - drop a not required vmap invalidation
 - better document the iclog size fields
 - fix vmap invalidation

Changes since v2:
 - rename the 'flush' flag to 'need_flush'
 - spelling fixes
 - minor cleanups

Changes since v1:
 - rebased to not required the log item series first
 - split the bio-related code out of xfs_log_recover.c into a new file
   to ease using xfs_log_recover.c in xfsprogs
 - use kmem_alloc_large instead of vmalloc to allocate the buffer
 - additional minor cleanups
