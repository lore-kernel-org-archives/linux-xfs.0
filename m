Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44940 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728718AbfGaRRm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 13:17:42 -0400
From: Matthew Wilcox <willy@infradead.org>
Subject: [RFC 0/2] iomap & xfs support for large pages
Date: Wed, 31 Jul 2019 10:17:32 -0700
Message-Id: <20190731171734.21601-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de, linux-xfs@vger.kernel.org, linux-mm@kvack.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Christoph sent me a patch a few months ago called "XFS THP wip".
I've redone it based on current linus tree, plus the page_size() /
compound_nr() / page_shift() patches currently found in -mm.  I fixed
the logic bugs that I noticed in his patch and may have introduced some
of my own.  I have only compile tested this code.

Matthew Wilcox (Oracle) (2):
  iomap: Support large pages
  xfs: Support large pages

 fs/iomap/buffered-io.c | 82 ++++++++++++++++++++++++++----------------
 fs/xfs/xfs_aops.c      | 37 +++++++++----------
 include/linux/iomap.h  |  2 +-
 3 files changed, 72 insertions(+), 49 deletions(-)

-- 
2.20.1
