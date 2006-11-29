Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 08:02:05 -0800 (PST)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kATG1oaK005193
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 08:01:54 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id kATFifWv006555
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 16:44:42 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id kATFiffi006553
	for xfs@oss.sgi.com; Wed, 29 Nov 2006 16:44:41 +0100
Date: Wed, 29 Nov 2006 16:44:41 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix sparse warning in xfs_da_btree.c
Message-ID: <20061129154441.GA6400@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The first use in xfs_da_node_lookup_int would have to be __be32.
But we can just remove this temporary variable use completely and
make sparse happy.  The variable is used later in the function for
a native endian variable so we'll have to keep it.


Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index a68bc1f..cccf69e 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1090,8 +1090,7 @@ xfs_da_node_lookup_int(xfs_da_state_t *s
 		if (blk->magic == XFS_DA_NODE_MAGIC) {
 			node = blk->bp->data;
 			max = be16_to_cpu(node->hdr.count);
-			btreehashval = node->btree[max-1].hashval;
-			blk->hashval = be32_to_cpu(btreehashval);
+			blk->hashval = be32_to_cpu(node->btree[max-1].hashval);
 
 			/*
 			 * Binary search.  (note: small blocks will skip loop)
