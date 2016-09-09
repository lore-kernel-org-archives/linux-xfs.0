Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54021 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752924AbcIIQex (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Sep 2016 12:34:53 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: iomap based DAX path
Date: Fri,  9 Sep 2016 18:34:34 +0200
Message-Id: <1473438884-674-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

This series adds a DAX I/O path based on the iomap interface.  This
allows more efficient block mapping including defined hole semantics,
and is an important step toward getting rid of buffer_heads in XFS.

