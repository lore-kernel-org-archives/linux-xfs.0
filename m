Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32864 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbeERQwL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 May 2018 12:52:11 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: sub-page blocksize support in iomap non-buffer head path
Date: Fri, 18 May 2018 18:52:04 +0200
Message-Id: <20180518165206.13829-1-hch@lst.de>
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

Changes since v1:
 - call iomap_page_create in page_mkwrite to fix generic/095
 - split into a separate series
