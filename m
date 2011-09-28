Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8SAvI3Y103492 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 05:57:18 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 2/5] xfsprogs: libxcmd: simplify fs_table_lookup()
Date: Wed, 28 Sep 2011 05:57:09 -0500
Message-Id: <4790c40ad138f61ca542c7c0cb49987e43164a31.1317207144.git.aelder@sgi.com>
In-Reply-To: <1317207432-8464-1-git-send-email-aelder@sgi.com>
References: <1317207432-8464-1-git-send-email-aelder@sgi.com>
In-Reply-To: <08dbe8c3d0f49bac0c18570a68e7aa983cb4c731.1317207144.git.aelder@sgi.com>
References: <08dbe8c3d0f49bac0c18570a68e7aa983cb4c731.1317207144.git.aelder@sgi.com>
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
Cc: Alex Elder <aelder@sgi.com>

Move a block of invariant code out of the loop in fs_table_lookup(),
and add a few comments.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxcmd/paths.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 0e02eb7..5aa343b 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -37,6 +37,11 @@ struct fs_path *fs_path;
 char *mtab_file;
 #define PROC_MOUNTS	"/proc/self/mounts"
 
+/*
+ * Find the FS table entry for the given path.  The "flags" argument
+ * is a mask containing FS_MOUNT_POINT or FS_PROJECT_PATH (or both)
+ * to indicate the type of table entry sought.
+ */
 struct fs_path *
 fs_table_lookup(
 	const char	*dir,
@@ -44,16 +49,25 @@ fs_table_lookup(
 {
 	struct stat64	sbuf;
 	uint		i;
+	dev_t		dev;
 
 	if (stat64(dir, &sbuf) < 0)
 		return NULL;
+
+	/*
+	 * We want to match st_rdev if the directory provided is a
+	 * device special file.  Otherwise we are looking for the
+	 * the device id for the containing filesystem, in st_dev.
+	 */
+	if (S_ISBLK(sbuf.st_mode) || S_ISCHR(sbuf.st_mode))
+		dev = sbuf.st_rdev;
+	else
+		dev = sbuf.st_dev;
+
 	for (i = 0; i < fs_count; i++) {
 		if ((flags & fs_table[i].fs_flags) == 0)
 			continue;
-		if (S_ISBLK(sbuf.st_mode) || S_ISCHR(sbuf.st_mode)) {
-			if (sbuf.st_rdev == fs_table[i].fs_datadev)
-				return &fs_table[i];
-		} else if (sbuf.st_dev == fs_table[i].fs_datadev)
+		if (fs_table[i].fs_datadev == dev)
 			return &fs_table[i];
 	}
 	return NULL;
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
