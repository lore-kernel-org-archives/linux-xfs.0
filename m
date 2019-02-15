Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34936 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfBOOr1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Feb 2019 09:47:27 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: small fixes and optimizations for delalloc v2
Date: Fri, 15 Feb 2019 15:47:15 +0100
Message-Id: <20190215144725.8894-1-hch@lst.de>
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

    git://git.infradead.org/users/hch/xfs.git xfs-mapping-validation.5

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-mapping-validation.5

Changes since v1:
 - fix the ilock hold time in delalloc conversions (Darrick)
 - switch handling of a 0 block allocation from an assert to a runtime
   error
 - fix an off by one false negative in an assert
 - move extent trimming from xfs_convert_blocks to the caller
 - update a few commit logs
 
