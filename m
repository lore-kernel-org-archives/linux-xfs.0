Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33551 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752072AbdDCMLe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Apr 2017 08:11:34 -0400
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cv0pO-0001mN-VK
        for linux-xfs@vger.kernel.org; Mon, 03 Apr 2017 12:11:23 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: split the reflink remap from the block allocation path
Date: Mon,  3 Apr 2017 14:11:14 +0200
Message-Id: <20170403121120.7265-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We've run into various problems due to the fact that the reflink remap
code reuses the xfs_bmapi_write codepath for setting up the extent list
entries and abuses the firstblock field for that purpose.

This series fixes this by creating an entirely separate xfs_bmapi_remap
path that is much simpler than xfs_bmapi_write and does not need to
overload the firstblock field.
