Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52136 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933522AbeEWOqu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 May 2018 10:46:50 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: sub-page blocksize support in iomap non-buffer head path v3
Date: Wed, 23 May 2018 16:46:44 +0200
Message-Id: <20180523144646.19159-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

Hi all,

this series adds support for buffered I/O without buffer heads for
block size < PAGE_SIZE to the iomap and XFS code.

A git tree is available at:

    git://git.infradead.org/users/hch/xfs.git xfs-iomap-read xfs-remove-bufferheads.2

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-remove-bufferheads.2

Changes since v2:
 - rebased

Changes since v1:
 - call iomap_page_create in page_mkwrite to fix generic/095
 - split into a separate series
