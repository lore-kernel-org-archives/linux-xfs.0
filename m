Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J0TbZj141340 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 18:29:37 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D7431C5C78F
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 16:30:35 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	hjeE1TKw5B9bbmSG for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 16:30:35 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11645678-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 11:00:33 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX1zM-0003DP-Gf
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:32 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX1zL-0003W6-SY
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 11:30:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfs: make xfs_dir_cilookup_result use unsigned char
Date: Tue, 19 Jan 2010 11:30:22 +1100
Message-Id: <1263861026-13448-5-git-send-email-david@fromorbit.com>
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

For consistency with the result of the code.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_dir2.c |    2 +-
 fs/xfs/xfs_dir2.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index c21c527..3a8c6ba 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -247,7 +247,7 @@ xfs_dir_createname(
 int
 xfs_dir_cilookup_result(
 	struct xfs_da_args *args,
-	const char	*name,
+	const unsigned char *name,
 	int		len)
 {
 	if (args->cmpresult == XFS_CMP_DIFFERENT)
diff --git a/fs/xfs/xfs_dir2.h b/fs/xfs/xfs_dir2.h
index 1d9ef96..74a3b10 100644
--- a/fs/xfs/xfs_dir2.h
+++ b/fs/xfs/xfs_dir2.h
@@ -100,7 +100,7 @@ extern int xfs_dir2_isleaf(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_dabuf *bp);
 
-extern int xfs_dir_cilookup_result(struct xfs_da_args *args, const char *name,
-				int len);
+extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
+				const unsigned char *name, int len);
 
 #endif	/* __XFS_DIR2_H__ */
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
