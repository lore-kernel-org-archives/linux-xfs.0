Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6E3cUoU224113 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 22:38:30 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id xastiONBvLnB6tEl
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Jul 2012 20:38:29 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so8084214pbb.26
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 20:38:29 -0700 (PDT)
From: Chen Baozi <baozich@gmail.com>
Subject: [PATCH] xfs: fix comment typo of struct xfs_da_blkinfo.
Date: Sat, 14 Jul 2012 03:38:13 +0800
Message-Id: <1342208293-3405-1-git-send-email-baozich@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: bpm@sgi.com
Cc: Chen Baozi <baozich@gmail.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Fix trivial typo error that has written "It" to "Is".

Signed-off-by: Chen Baozi <baozich@gmail.com>
---
 fs/xfs/xfs_da_btree.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
index dbf7c07..be30bd4 100644
--- a/fs/xfs/xfs_da_btree.h
+++ b/fs/xfs/xfs_da_btree.h
@@ -32,7 +32,7 @@ struct zone;
 /*
  * This structure is common to both leaf nodes and non-leaf nodes in the Btree.
  *
- * Is is used to manage a doubly linked list of all blocks at the same
+ * It is used to manage a doubly linked list of all blocks at the same
  * level in the Btree, and to identify which type of block this is.
  */
 #define XFS_DA_NODE_MAGIC	0xfebe	/* magic number: non-leaf blocks */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
