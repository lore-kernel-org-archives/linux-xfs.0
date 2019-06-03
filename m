Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53498 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfFCR3t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:29:49 -0400
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hXqmK-0002Mq-QZ
        for linux-xfs@vger.kernel.org; Mon, 03 Jun 2019 17:29:49 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: use bios directly in the log code v2
Date: Mon,  3 Jun 2019 19:29:25 +0200
Message-Id: <20190603172945.13819-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

this series switches the log writing and log recovery code to use bios
directly, and remove various special cases from the buffer cache code.
Note that I have developed it on top of the previous series of log item
related cleanups, so if you don't have that applied there is a small
conflict.  To make life easier I have pushed out a git branche here:

    git://git.infradead.org/users/hch/xfs.git xfs-log-bio

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-bio

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
