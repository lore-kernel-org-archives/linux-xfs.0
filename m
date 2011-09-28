Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8SBieGo105763 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 06:44:40 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH 1/2] xfsprogs: libxcmd: allow 0 as a wildcard fs_table entry
	type selector
Date: Wed, 28 Sep 2011 06:44:33 -0500
Message-Id: <a14d653e8a238b3207c5076eb6e6f3358e433422.1317210237.git.aelder@sgi.com>
In-Reply-To: <1317210274-13086-1-git-send-email-aelder@sgi.com>
References: <1317210274-13086-1-git-send-email-aelder@sgi.com>
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

In libxcmd a table is used to represent filesystems and directories
that could be subject to quota operations.  A cursor mechanism is
used to search that table, and it includes a flag that indicates
whether the type of entry desired represents a directory (for project
quotas) or a mount point (otherwise).  It also allows a search for
either type.

There is only call to fs_cursor_initialise() where both mount points
and project paths are requested--all others just requested one or
the other.

Change it so when searching fs_table (in fs_table_lookup() and
fs_cursor_next_entry()), a zero "flags" value is interpreted as a
wildcard, matching either type of entry.

Also add some commentary explaining the use of 0 as a wildcard, and
simplify fs_cursor_next_entry() a bit in the process.

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 libxcmd/paths.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 1dbe0be..9ec42ab 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -48,7 +48,7 @@ fs_table_lookup(
 	if (stat64(dir, &sbuf) < 0)
 		return NULL;
 	for (i = 0; i < fs_count; i++) {
-		if ((flags & fs_table[i].fs_flags) == 0)
+		if (flags && !(flags & fs_table[i].fs_flags))
 			continue;
 		if (S_ISBLK(sbuf.st_mode) || S_ISCHR(sbuf.st_mode)) {
 			if (sbuf.st_rdev == fs_table[i].fs_datadev)
@@ -439,6 +439,16 @@ fs_table_insert_project_path(
  * Table iteration (cursor-based) interfaces
  */
 
+/*
+ * Initialize an fs_table cursor.  If a directory path is supplied,
+ * the cursor is set up to appear as though the table contains only
+ * a single entry which represents the directory specified.
+ * Otherwise it is set up to prepare for visiting all entries in the
+ * global table, starting with the first.  "flags" can be either
+ * FS_MOUNT_POINT or FS_PROJECT_PATH to limit what type of entries
+ * will be selected by fs_cursor_next_entry().  0 can be used as a
+ * wild card (selecting either type).
+ */
 void
 fs_cursor_initialise(
 	char		*dir,
@@ -461,17 +471,19 @@ fs_cursor_initialise(
 	cur->flags = flags;
 }
 
+/*
+ * Use the cursor to find the next entry in the table having the
+ * type specified by the cursor's "flags" field.
+ */
 struct fs_path *
 fs_cursor_next_entry(
 	fs_cursor_t	*cur)
 {
-	fs_path_t	*next = NULL;
-
 	while (cur->index < cur->count) {
-		next = &cur->table[cur->index++];
-		if (cur->flags & next->fs_flags)
-			break;
-		next = NULL;
+		fs_path_t	*next = &cur->table[cur->index++];
+
+		if (!cur->flags || (cur->flags & next->fs_flags))
+			return next;
 	}
-	return next;
+	return NULL;
 }
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
