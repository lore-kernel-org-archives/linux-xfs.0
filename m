Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8SAvJgj103510 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 05:57:19 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 1/5] xfsprogs: libxcmd: don't clobber fs_table on realloc()
Date: Wed, 28 Sep 2011 05:57:08 -0500
Message-Id: <08dbe8c3d0f49bac0c18570a68e7aa983cb4c731.1317207144.git.aelder@sgi.com>
In-Reply-To: <1317207432-8464-1-git-send-email-aelder@sgi.com>
References: <1317207432-8464-1-git-send-email-aelder@sgi.com>
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

In fs_table_insert(), realloc() is called to resize the global
fs_table.  If it fails, it overwrites a previously valid fs_table
pointer with NULL.

Instead, assign the return value to a local temporary and overwrite
fs_table only if the realloc() call succeeds.  The only defined
errno value for a realloc() failure is ENOMEM, so return that
explicitly in the event it fails.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxcmd/paths.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 1dbe0be..0e02eb7 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -102,6 +102,7 @@ fs_table_insert(
 	char		*fsrt)
 {
 	dev_t		datadev, logdev, rtdev;
+	struct fs_path	*tmp_fs_table;
 
 	if (!dir || !fsname)
 		return EINVAL;
@@ -114,9 +115,10 @@ fs_table_insert(
 	if (fsrt && (fsrt = fs_device_number(fsrt, &rtdev, 1)) == NULL)
 		return errno;
 
-	fs_table = realloc(fs_table, sizeof(fs_path_t) * (fs_count + 1));
-	if (!fs_table)
-		return errno;
+	tmp_fs_table = realloc(fs_table, sizeof(fs_path_t) * (fs_count + 1));
+	if (!tmp_fs_table)
+		return ENOMEM;
+	fs_table = tmp_fs_table;
 
 	fs_path = &fs_table[fs_count];
 	fs_path->fs_dir = dir;
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
