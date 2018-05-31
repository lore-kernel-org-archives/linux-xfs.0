Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50820 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755824AbeEaSH2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 14:07:28 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: iomap SEEK_HOLE / SEEK_DATA cleanups and generalization v2
Date: Thu, 31 May 2018 20:07:21 +0200
Message-Id: <20180531180724.21573-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

Refactor the seek pagecache helpers to work independent of buffer_heads,
and clean up a few lose bits.

This is needed for the small blocksize buffered I/O support in iomap.

Changes since v1:
 - a trivial comment update
