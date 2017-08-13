Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44966 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbdHMOmT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Aug 2017 10:42:19 -0400
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dgu5r-0003Wj-7Q
        for linux-xfs@vger.kernel.org; Sun, 13 Aug 2017 14:42:19 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: explicitly join inodes to deferred operations
Date: Sun, 13 Aug 2017 16:42:13 +0200
Message-Id: <20170813144216.11192-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This series cleanup up the rolled transaction and defer code to
not treat inodes special - the low-level roll code now doesn't know
about inodes any more, and xfs_defer_finish loses the inode argument.

