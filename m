Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45818 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754120AbcJYXEI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:04:08 -0400
Subject: [PATCH 04/39] xfs: add refcount btree operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:04:02 -0700
Message-ID: <147743664272.11035.6730520387402463910.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Implement the generic btree operations required to manipulate refcount
btree blocks.  The implementation is similar to the bmapbt, though it
will only allocate and free blocks from the AG.

[Add the xfs_refcount.h file to the standard include list.]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch: fix logging of AGF refcount btree fields]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
v2: Remove init_rec_from_key since we no longer need it, and add
tracepoints when refcount btree operations fail.

Since the refcount root and level fields are separate from the
existing roots and levels array, they need a separate logging flag.
---
 include/libxfs.h |    1 +
 1 file changed, 1 insertion(+)


diff --git a/include/libxfs.h b/include/libxfs.h
index ec8f6ab..e5e1523 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -80,6 +80,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #include "xfs_rmap_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_refcount.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

