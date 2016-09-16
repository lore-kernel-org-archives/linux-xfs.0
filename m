Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40368 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932447AbcIPL1T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Sep 2016 07:27:19 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: iomap based DAX path V3
Date: Fri, 16 Sep 2016 13:27:02 +0200
Message-Id: <1474025234-13804-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org
Cc: ross.zwisler@linux.intel.com

This series adds a DAX I/O path based on the iomap interface.  This
allows more efficient block mapping including defined hole semantics,
and is an important step toward getting rid of buffer_heads in XFS.

Changes since V2:
 - feedback to various small comments from Ross
 - added Reviewed-by: tags

Changes since V1:
 - added a conversion of ext2 to the iomap interface
 - addresse feedback from Ross, Dave and Robert

