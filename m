Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0TbTY141347 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:29:38 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55A1C11F8B48
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:30:35 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	q1vzzpvX5wMCVDEi for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:30:35 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11561537-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:00:33 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX1zM-0003Dd-M3
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:32 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX1zM-0003WF-1f
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] xfs: clean up sign warnings in dir2 code
Date: Tue, 19 Jan 2010 11:30:25 +1100
Message-Id: <1263861026-13448-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1263861026-13448-1-git-send-email-david@fromorbit.com>
References: <1263861026-13448-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

We are now consistently using unsigned char strings for names
so fix up the remaining warnings in the dir2 code to complete
the cleanup.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_dir2.c       |    2 +-
 fs/xfs/xfs_dir2_block.c |    9 +++++----
 fs/xfs/xfs_dir2_leaf.c  |    2 +-
 fs/xfs/xfs_dir2_sf.c    |    2 +-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index 3a8c6ba..42520f0 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -44,7 +44,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 
-struct xfs_name xfs_name_dotdot = {"..", 2};
+struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2};
 
 /*
  * ASCII case-insensitive (ie. A-Z) support for directories that was
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index ddc4ecc..779a267 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -57,8 +57,8 @@ static xfs_dahash_t xfs_dir_hash_dot, xfs_dir_hash_dotdot;
 void
 xfs_dir_startup(void)
 {
-	xfs_dir_hash_dot = xfs_da_hashname(".", 1);
-	xfs_dir_hash_dotdot = xfs_da_hashname("..", 2);
+	xfs_dir_hash_dot = xfs_da_hashname((unsigned char *)".", 1);
+	xfs_dir_hash_dotdot = xfs_da_hashname((unsigned char *)"..", 2);
 }
 
 /*
@@ -513,8 +513,9 @@ xfs_dir2_block_getdents(
 		/*
 		 * If it didn't fit, set the final offset to here & return.
 		 */
-		if (filldir(dirent, dep->name, dep->namelen, cook & 0x7fffffff,
-			    be64_to_cpu(dep->inumber), DT_UNKNOWN)) {
+		if (filldir(dirent, (char *)dep->name, dep->namelen,
+			    cook & 0x7fffffff, be64_to_cpu(dep->inumber),
+			    DT_UNKNOWN)) {
 			*offset = cook & 0x7fffffff;
 			xfs_da_brelse(NULL, bp);
 			return 0;
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 29f484c..e2d8985 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -1081,7 +1081,7 @@ xfs_dir2_leaf_getdents(
 		dep = (xfs_dir2_data_entry_t *)ptr;
 		length = xfs_dir2_data_entsize(dep->namelen);
 
-		if (filldir(dirent, dep->name, dep->namelen,
+		if (filldir(dirent, (char *)dep->name, dep->namelen,
 			    xfs_dir2_byte_to_dataptr(mp, curoff) & 0x7fffffff,
 			    be64_to_cpu(dep->inumber), DT_UNKNOWN))
 			break;
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 9d4f17a..c1a5945 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -782,7 +782,7 @@ xfs_dir2_sf_getdents(
 		}
 
 		ino = xfs_dir2_sf_get_inumber(sfp, xfs_dir2_sf_inumberp(sfep));
-		if (filldir(dirent, sfep->name, sfep->namelen,
+		if (filldir(dirent, (char *)sfep->name, sfep->namelen,
 			    off & 0x7fffffff, ino, DT_UNKNOWN)) {
 			*offset = off & 0x7fffffff;
 			return 0;
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
