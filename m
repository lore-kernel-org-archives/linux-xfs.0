Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34278 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbfBKMyd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 07:54:33 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: small fixes and optimizations for delalloc and reflink 
Date: Mon, 11 Feb 2019 13:54:17 +0100
Message-Id: <20190211125427.16577-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

Hi all,

this series contains my changes to fix up the delalloc and reflink
code to prepare for the always COW mode.  This sits on top of
the 'xfs: properly invalidate cached writeback mapping' series from
Brian.

To make reviewing easier I also have a git tree available here:

    git://git.infradead.org/users/hch/xfs.git xfs-mapping-validation.4

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-mapping-validation.4
