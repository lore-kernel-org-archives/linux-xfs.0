Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55068 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753458AbdDLQKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 12:10:18 -0400
Date: Wed, 12 Apr 2017 09:10:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Deadlock between block allocation and block truncation
Message-ID: <20170412161017.GA16590@infradead.org>
References: <800468eb-3ded-9166-20a4-047de8018582@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <800468eb-3ded-9166-20a4-047de8018582@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: linux-xfs@vger.kernel.org

Hi Nikolay,

I guess the culprit is that truncate can free up to two extents in
the same transaction and thus try to lock two different AGs without
requiring them to be in increasing order.

Does the one liner below fix the problem for you?

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7605d8396596..29f2cd5afb04 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -58,7 +58,7 @@ kmem_zone_t *xfs_inode_zone;
  * Used in xfs_itruncate_extents().  This is the maximum number of extents
  * freed from a file in a single transaction.
  */
-#define	XFS_ITRUNC_MAX_EXTENTS	2
+#define	XFS_ITRUNC_MAX_EXTENTS	1
 
 STATIC int xfs_iflush_int(struct xfs_inode *, struct xfs_buf *);
 STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
