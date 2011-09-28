Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8SAvIgS103497 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 05:57:18 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 4/5] xfsprogs: libxcmd: move fs_device_number() up in the file
Date: Wed, 28 Sep 2011 05:57:11 -0500
Message-Id: <3a3e7a98f00ba3c8971c9941b3ee7a9fc63ddf99.1317207144.git.aelder@sgi.com>
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

No content change, just code movement in preparation for the next
patch.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxcmd/paths.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index f1cd6c7..aa0aeb6 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -37,6 +37,20 @@ struct fs_path *fs_path;
 char *mtab_file;
 #define PROC_MOUNTS	"/proc/self/mounts"
 
+static char *
+fs_device_number(
+	char		*name,
+	dev_t		*devnum)
+{
+	struct stat64	sbuf;
+
+	if (stat64(name, &sbuf) < 0)
+		return NULL;
+	*devnum = sbuf.st_dev;
+
+	return name;
+}
+
 /*
  * Find the FS table entry for the given path.  The "flags" argument
  * is a mask containing FS_MOUNT_POINT or FS_PROJECT_PATH (or both)
@@ -73,20 +87,6 @@ fs_table_lookup(
 	return NULL;
 }
 
-static char *
-fs_device_number(
-	char		*name,
-	dev_t		*devnum)
-{
-	struct stat64	sbuf;
-
-	if (stat64(name, &sbuf) < 0)
-		return NULL;
-	*devnum = sbuf.st_dev;
-
-	return name;
-}
-
 static int
 fs_table_insert(
 	char		*dir,
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
