Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42140 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdH2Q02 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 12:26:28 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: cleanup the page fault path V2
Date: Tue, 29 Aug 2017 18:26:11 +0200
Message-Id: <20170829162613.27270-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: jack@suse.cz

Hi all,

these two patches simplify the xfs/iomap page fault path.  They came up in
the context of MAP_SYNC support, but are useful on their own, and might be
good to get into 4.14 before the real MAP_SYNC work starts hitting the
tree in some form.

Changes since V1:
 - drop the incorrect pfn consolidation
