Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57400 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFMSDD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:03 -0400
Received: from [213.208.157.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbU3z-0002fE-87
        for linux-xfs@vger.kernel.org; Thu, 13 Jun 2019 18:03:03 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: misc log item related cleanups v2
Date: Thu, 13 Jun 2019 20:02:40 +0200
Message-Id: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

I've recently been trying to debug issue related to latencies related to
locked buffers and went all over our log item lifecycles for that.

It turns out a lot of code in that area is rather obsfucated and
redundant.  This series is almost entirely cleanups, but there are lots
of it.  The only exception is a fix for systematic memory leaks which
appears entirely theoretical.

Note that this series sits on top of the series titled
"use bios directly in the log code v4".  To make everyones life easier
a git tree is available here:

    git://git.infradead.org/users/hch/xfs.git xfs-log-item-cleanup

Gitweb:

    http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-log-item-cleanup


Changes since v1:
 - improve a few commit messages
 - add various comments
 - minor code style fixes
 - drop the patch to remove iop_pushed from the quotaoff item
 - set XFS_LI_ABORTED earlier in xfs_trans_committed_bulk
