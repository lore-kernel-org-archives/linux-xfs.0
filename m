Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n583pXuW203314 for <xfs@oss.sgi.com>; Sun, 7 Jun 2009 22:51:33 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DBAB2DB22B
	for <xfs@oss.sgi.com>; Sun,  7 Jun 2009 20:51:52 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id sjQmZhOu8NzWfMdO for
	<xfs@oss.sgi.com>; Sun, 07 Jun 2009 20:51:52 -0700 (PDT)
Message-ID: <4A2C8AD8.9030107@sandeen.net>
Date: Sun, 07 Jun 2009 22:51:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: catch bad depth in traverse_int_dir2block
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Richard Kolkovich <richard@intrameta.com>

A bad on-disk tree depth in traverse_int_dir2block() can
later cause a segfault when it's used as an array index in
this function; if we get something beyond the max depth,
just error out and the dir will get rebuilt.

Reported-by: Richard Kolkovich <richard@intrameta.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/repair/dir2.c b/repair/dir2.c
index 9575fb1..2723e3b 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -339,9 +339,17 @@ traverse_int_dir2block(xfs_mount_t	*mp,
 		/*
 		 * maintain level counter
 		 */
-		if (i == -1)
+		if (i == -1) {
 			i = da_cursor->active = be16_to_cpu(node->hdr.level);
-		else  {
+			if (i >= XFS_DA_NODE_MAXDEPTH) {
+				do_warn(_("bad header depth for directory "
+					  "inode %llu\n"),
+					da_cursor->ino);
+				da_brelse(bp);
+				i = -1;
+				goto error_out;
+			}
+		} else {
 			if (be16_to_cpu(node->hdr.level) == i - 1)  {
 				i--;
 			} else  {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
