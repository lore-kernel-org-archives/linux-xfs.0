Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52590 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdH1HpC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 03:45:02 -0400
Received: from [46.125.249.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dmEjF-0002Ez-On
        for linux-xfs@vger.kernel.org; Mon, 28 Aug 2017 07:45:02 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: explicitly join inodes to deferred operations V2 (this time for real)
Date: Mon, 28 Aug 2017 09:44:55 +0200
Message-Id: <20170828074458.23786-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This series cleanup up the rolled transaction and defer code to
not treat inodes special - the low-level roll code now doesn't know
about inodes any more, and xfs_defer_finish loses the inode argument.

Changes since V1:
 - rename __xfs_trans_roll to xfs_trans_roll
 - rename xfs_defer_join_inode to xfs_defer_ijoin
