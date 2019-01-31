Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56596 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfAaHz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 02:55:27 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: make delalloc conversion more robust and clear
Date: Thu, 31 Jan 2019 08:55:13 +0100
Message-Id: <20190131075524.4769-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

Hi all,

I've rebased the series to rewrite the delalloc handling to handle the
race where another thread moves extents from the COW to the data fork
on top of the ' xfs: properly invalidate cached writeback mapping'
series from Brian.

The first patch is a FOLD for that series as those changes should go
into the original patches.

To make reviewing easier I also have a git tree available here:

    git://git.infradead.org/users/hch/xfs.git xfs-mapping-validation.3

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-mapping-validation.3
