Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 447367F37
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 19:27:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2F921304032
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 17:27:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id e7U15fg0Oy0g1kWD for <xfs@oss.sgi.com>;
	Thu, 08 Oct 2015 17:27:23 -0700 (PDT)
Received: from Liberator.local (unknown [205.215.222.148])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5304E61F8992
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 19:27:23 -0500 (CDT)
Subject: [PATCH 4/4] xfs_repair: fix left-shift overflows
References: <56170906.5090301@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <561709E9.3000406@sandeen.net>
Date: Thu, 8 Oct 2015 19:27:21 -0500
MIME-Version: 1.0
In-Reply-To: <56170906.5090301@redhat.com>
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

The code in prefetch.c has another issue with large fs blocks
(32 or 64k) because it shifts by up to 128 bits, but that's left
for later...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/incore_ino.c |   14 +++++++-------
 repair/prefetch.c   |    2 +-
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
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
