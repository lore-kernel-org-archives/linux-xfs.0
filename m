Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 951CE7F8C
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 14:53:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2CC1AAC001
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 12:53:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id RWRnAxuxZNUyJcHK for <xfs@oss.sgi.com>;
	Fri, 09 Oct 2015 12:53:38 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7850763C77A5
	for <xfs@oss.sgi.com>; Fri,  9 Oct 2015 14:53:38 -0500 (CDT)
Subject: [PATCH 5/5] xfs_repair: fix left-shift overflows
References: <56181A17.9080503@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56181B42.3080304@sandeen.net>
Date: Fri, 9 Oct 2015 14:53:38 -0500
MIME-Version: 1.0
In-Reply-To: <56181A17.9080503@sandeen.net>
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
To: xfs@oss.sgi.com

pmask in struct parent_list is a __uint64_t, but in some places
we populated it with "1LL << shift" where shift could be up
to 63; this really needs to be a 1ULL type for this to be correct.

Also spotted by libubsan...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 repair/incore_ino.c | 14 +++++++-------
 repair/prefetch.c   |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 32d7678..1898257 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -625,7 +625,7 @@ set_inode_parent(
 		else
 			irec->ino_un.plist = ptbl;
 
-		ptbl->pmask = 1LL << offset;
+		ptbl->pmask = 1ULL << offset;
 		ptbl->pentries = (xfs_ino_t*)memalign(sizeof(xfs_ino_t),
 							sizeof(xfs_ino_t));
 		if (!ptbl->pentries)
@@ -638,8 +638,8 @@ set_inode_parent(
 		return;
 	}
 
-	if (ptbl->pmask & (1LL << offset))  {
-		bitmask = 1LL;
+	if (ptbl->pmask & (1ULL << offset))  {
+		bitmask = 1ULL;
 		target = 0;
 
 		for (i = 0; i < offset; i++)  {
@@ -655,7 +655,7 @@ set_inode_parent(
 		return;
 	}
 
-	bitmask = 1LL;
+	bitmask = 1ULL;
 	cnt = target = 0;
 
 	for (i = 0; i < XFS_INODES_PER_CHUNK; i++)  {
@@ -691,7 +691,7 @@ set_inode_parent(
 	ptbl->cnt++;
 #endif
 	ptbl->pentries[target] = parent;
-	ptbl->pmask |= (1LL << offset);
+	ptbl->pmask |= (1ULL << offset);
 }
 
 xfs_ino_t
@@ -707,8 +707,8 @@ get_inode_parent(ino_tree_node_t *irec, int offset)
 	else
 		ptbl = irec->ino_un.plist;
 
-	if (ptbl->pmask & (1LL << offset))  {
-		bitmask = 1LL;
+	if (ptbl->pmask & (1ULL << offset))  {
+		bitmask = 1ULL;
 		target = 0;
 
 		for (i = 0; i < offset; i++)  {
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 52238ca..b11dcb3 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -762,7 +762,7 @@ pf_queuing_worker(
 			 * sparse state in cluster sized chunks as cluster size
 			 * is the min. granularity of sparse irec regions.
 			 */
-			if ((sparse & ((1 << inodes_per_cluster) - 1)) == 0)
+			if ((sparse & ((1ULL << inodes_per_cluster) - 1)) == 0)
 				pf_queue_io(args, &map, 1,
 					    (cur_irec->ino_isa_dir != 0) ?
 					     B_DIR_INODE : B_INODE);
-- 
2.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
