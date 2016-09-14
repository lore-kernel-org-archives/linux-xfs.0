Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 271197CA6
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 10:20:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D1ACD8F8050
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 08:20:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EmNHFAC4I4OAcD1D (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 14 Sep 2016 08:20:12 -0700 (PDT)
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 1/3] xfsprogs: populate fs table with xfs entries first,
	foreign entries last
Date: Wed, 14 Sep 2016 10:19:39 -0500
Message-Id: <1473866381-28975-2-git-send-email-billodo@redhat.com>
In-Reply-To: <1473866381-28975-1-git-send-email-billodo@redhat.com>
References: <1473866381-28975-1-git-send-email-billodo@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

Commits b20b6c2 and 29647c8 modified xfs_quota for use on
non-XFS filesystems. Modifications to fs_initialise_mounts
(paths.c) resulted in an xfstest fail (xfs/261), due to foreign
fs paths being picked up first from the fs table. The xfs_quota
print command then complained about not being able to print the
foreign paths, instead of previous behavior (quiet).

This patch restores correct behavior, sorting the table so that
xfs entries are first, followed by foreign fs entries. The patch
maintains the order of xfs entries and foreign entries in the
same order as mtab entries.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 libxcmd/paths.c | 12 +++++++++++-
 quota/path.c    | 21 ++++++++++++++++-----
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 4158688..6363d40 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -34,6 +34,7 @@ extern char *progname;
 int fs_count;
 struct fs_path *fs_table;
 struct fs_path *fs_path;
+int		xfs_fs_count;
 
 char *mtab_file;
 #define PROC_MOUNTS	"/proc/self/mounts"
@@ -138,7 +139,16 @@ fs_table_insert(
 		goto out_norealloc;
 	fs_table = tmp_fs_table;
 
-	fs_path = &fs_table[fs_count];
+	/* Put foreign filesystems at the end, xfs filesystems at the front */
+	if (flags & FS_FOREIGN || fs_count == 0) {
+		fs_path = &fs_table[fs_count];
+	} else {
+		/* move foreign fs entries down, insert new one just before */
+		memmove(&fs_table[xfs_fs_count], &fs_table[xfs_fs_count - 1],
+			sizeof(fs_path_t)*(fs_count - xfs_fs_count + 1));
+		fs_path = &fs_table[xfs_fs_count];
+		xfs_fs_count++;
+	}
 	fs_path->fs_dir = dir;
 	fs_path->fs_prid = prid;
 	fs_path->fs_flags = flags;
diff --git a/quota/path.c b/quota/path.c
index a623d25..aa3d33e 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -75,9 +75,15 @@ static int
 pathlist_f(void)
 {
 	int		i;
+	struct fs_path	*path;
 
-	for (i = 0; i < fs_count; i++)
-		printpath(&fs_table[i], i, 1, &fs_table[i] == fs_path);
+	for (i = 0; i < fs_count; i++) {
+		path = &fs_table[i];
+		/* Table is ordered xfs first, then foreign */
+		if (path->fs_flags & FS_FOREIGN && !foreign_allowed)
+			break;
+		printpath(path, i, 1, path == fs_path);
+	}
 	return 0;
 }
 
@@ -98,7 +104,7 @@ path_f(
 	int		argc,
 	char		**argv)
 {
-	int	i;
+	int		i;
 
 	if (fs_count == 0) {
 		printf(_("No paths are available\n"));
@@ -113,8 +119,13 @@ path_f(
 		printf(_("value %d is out of range (0-%d)\n"),
 			i, fs_count-1);
 	} else {
-		fs_path = &fs_table[i];
-		pathlist_f();
+		for (i = 0; i < fs_count; i++) {
+			fs_path = &fs_table[i];
+			/* Table is ordered xfs first, then foreign */
+			if (fs_path->fs_flags & FS_FOREIGN && !foreign_allowed)
+				break;
+			pathlist_f();
+		}
 	}
 	return 0;
 }
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
