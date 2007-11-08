Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Nov 2007 16:39:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA80cmTx011409
	for <xfs@oss.sgi.com>; Wed, 7 Nov 2007 16:38:50 -0800
Date: Thu, 8 Nov 2007 11:38:48 +1100
From: David Chinner <dgc@sgi.com>
Subject: [patch] Fix broken inode clustering
Message-ID: <20071108003848.GA66820511@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>

The radix tree based inode caches did away with the inode cluster hashes,
replacing them with a bunch of masking and gang lookups on the radix tree.

This masking got broken when moving the code to per-ag radix trees and
indexing by agino # rather than straight inode number. The result is
clustered inode writeback does not cluster and things can go extremely
slowly when there are lots of inodes to write.

The following patch fixes this up by comparing agino # of the inode
found to the index of the cluster we are looking for.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>

---
 fs/xfs/xfs_iget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2007-11-02 13:44:46.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2007-11-07 13:08:42.534440675 +1100
@@ -248,7 +248,7 @@ finish_inode:
 	icl = NULL;
 	if (radix_tree_gang_lookup(&pag->pag_ici_root, (void**)&iq,
 							first_index, 1)) {
-		if ((iq->i_ino & mask) == first_index)
+		if ((XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) == first_index)
 			icl = iq->i_cluster;
 	}
 
