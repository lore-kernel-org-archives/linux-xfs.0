Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40562 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbdBAVmo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2017 16:42:44 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cZ2fr-0003Q8-1j
        for linux-xfs@vger.kernel.org; Wed, 01 Feb 2017 21:42:43 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: reflink direct I/O improvements V2
Date: Wed,  1 Feb 2017 22:42:35 +0100
Message-Id: <1485985359-971-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This series improves the reflink direct I/O path, by avoiding a pointless
detour through delayed allocations and doing the allocations directly
from the iomap code.

Changes since V1:
 - align the alignment code with the regular direct I/O path
 - rebase on top the patches from Darrick to use unwritten extents
   in the direct I/O COW path
