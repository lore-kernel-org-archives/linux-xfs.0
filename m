Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48448 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdAXJky (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2017 04:40:54 -0500
Date: Tue, 24 Jan 2017 01:40:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: xfs/122 failure for a while
Message-ID: <20170124094054.GA8536@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

xfs/122 has been failing for me for a while with this error:

-sizeof(xfs_dsb_t) = 272
+sizeof(xfs_dsb_t) = 264

That 272 numbers comes from:

908ce96f ("xfs/122: add the realtime rmapbt inode and btree fields"),
which don't seem to be features that made it into the kernel and
xfsprogs so far.
