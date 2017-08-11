Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53105 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753158AbdHKJ7M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 05:59:12 -0400
Received: from 80-109-164-210.cable.dynamic.surfer.at ([80.109.164.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dg6il-0001is-OD
        for linux-xfs@vger.kernel.org; Fri, 11 Aug 2017 09:59:12 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: RFC: buffered I/O completion change
Date: Fri, 11 Aug 2017 11:59:04 +0200
Message-Id: <20170811095905.11241-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I'm currently debugging a customer issue where we run into a softlockup
in xfs_finish_writeback, and consequently a lot of stuck buffered
writeback.   I'm still not sure what the root cause it as it is very
hard to reproduce, but one thing that sprang to mind again is the
hairy nature of end_buffer_async_write, especially combined with our
loop that calls it.  This patch avoids these pitfalls by opencoding
end_buffer_async_write.

