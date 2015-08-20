Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A2BF7F56
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 13:11:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 533D130405F
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 11:11:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 6IS9FhClKKabDprT for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2015 11:11:21 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id D36D461D1A43
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 13:11:20 -0500 (CDT)
Message-ID: <55D61848.7070607@sandeen.net>
Date: Thu, 20 Aug 2015 13:11:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 4/4] xfs_repair: unconditionally free blockmaps when threads
	complete
References: <55D61740.9070507@sandeen.net>
In-Reply-To: <55D61740.9070507@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

blkmap_free() doesn't actually free the block map unless it's
inordinately large; this keeps us from constantly freeing
and re-allocating blockmaps for each inode, which makes sense.

However, once the threads which have allocated these structures
exit, we should actually free them; they can grow up to 2MB
for each of the data and attr maps, for each thread, and not
be freed through the normal blkmap_free() test.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/bmap.c   |   17 ++++++++++++++++-
 repair/bmap.h   |    1 +
 repair/phase3.c |    2 ++
 repair/phase4.c |    1 +
 4 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/repair/bmap.c b/repair/bmap.c
index 2655632..abe9f48 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -82,7 +82,8 @@ blkmap_alloc(
  * extents) then free it to release the memory. This prevents us from pinning
  * large tracts of memory due to corrupted fork values or one-off fragmented
  * files. Otherwise we have nothing to do but keep the memory around for the
- * next inode
+ * next inode.
+ * When the thread is done, it should do an unconditional, final free.
  */
 void
 blkmap_free(
@@ -103,6 +104,20 @@ blkmap_free(
 	free(blkmap);
 }
 
+void
+blkmap_free_final(void)
+{
+	blkmap_t	*blkmap;
+
+	blkmap = pthread_getspecific(dblkmap_key);
+	pthread_setspecific(dblkmap_key, NULL);
+	free(blkmap);
+
+	blkmap = pthread_getspecific(ablkmap_key);
+	pthread_setspecific(ablkmap_key, NULL);
+	free(blkmap);
+}
+
 /*
  * Get one entry from a block map.
  */
diff --git a/repair/bmap.h b/repair/bmap.h
index 973081a..501ef6b 100644
--- a/repair/bmap.h
+++ b/repair/bmap.h
@@ -58,6 +58,7 @@ extern pthread_key_t ablkmap_key;
 
 blkmap_t	*blkmap_alloc(xfs_extnum_t nex, int whichfork);
 void		blkmap_free(blkmap_t *blkmap);
+void		blkmap_free_final(void);
 
 int		blkmap_set_ext(blkmap_t **blkmapp, xfs_fileoff_t o,
 			       xfs_fsblock_t b, xfs_filblks_t c);
diff --git a/repair/phase3.c b/repair/phase3.c
index 20786af..76c9440 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -27,6 +27,7 @@
 #include "err_protos.h"
 #include "dinode.h"
 #include "progress.h"
+#include "bmap.h"
 
 static void
 process_agi_unlinked(
@@ -75,6 +76,7 @@ process_ag_func(
 	wait_for_inode_prefetch(arg);
 	do_log(_("        - agno = %d\n"), agno);
 	process_aginodes(wq->mp, arg, agno, 1, 0, 1);
+	blkmap_free_final();
 	cleanup_inode_prefetch(arg);
 }
 
diff --git a/repair/phase4.c b/repair/phase4.c
index e0571e8..1a7d7b5 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -138,6 +138,7 @@ process_ag_func(
 	wait_for_inode_prefetch(arg);
 	do_log(_("        - agno = %d\n"), agno);
 	process_aginodes(wq->mp, arg, agno, 0, 1, 0);
+	blkmap_free_final();
 	cleanup_inode_prefetch(arg);
 
 	/*
-- 1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
