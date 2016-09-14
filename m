Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51648 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932545AbcINKBf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2016 06:01:35 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: iomap based DAX path V2
Date: Wed, 14 Sep 2016 12:01:19 +0200
Message-Id: <1473847291-18913-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
Cc: ross.zwisler@linux.intel.com

This series adds a DAX I/O path based on the iomap interface.  This
allows more efficient block mapping including defined hole semantics,
and is an important step toward getting rid of buffer_heads in XFS.

Changes since V1:
 - added a conversion of ext2 to the iomap interface
 - addresse feedback from Ross, Dave and Robert

