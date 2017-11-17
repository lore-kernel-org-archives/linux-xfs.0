Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30117 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753120AbdKQUOl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 15:14:41 -0500
Subject: [PATCH 10/12] libfrog: add missing function fs_table_destroy
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 17 Nov 2017 12:14:37 -0800
Message-ID: <151094967784.29763.8736996130533375682.stgit@magnolia>
In-Reply-To: <151094960522.29763.11622891165765932168.stgit@magnolia>
References: <151094960522.29763.11622891165765932168.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a function to tear down the fs_table when we're done messing with paths.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/paths.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)


diff --git a/libfrog/paths.c b/libfrog/paths.c
index b767e9d..62b4eda 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -206,6 +206,26 @@ fs_table_insert(
 	return error;
 }
 
+/* Remove all the cached entries in the fs table. */
+void
+fs_table_destroy(void)
+{
+	int		i;
+	struct fs_path	*fsp;
+
+	for (i = 0, fsp = fs_table; i < fs_count; i++, fsp++) {
+		free(fsp->fs_name);
+		free(fsp->fs_dir);
+		free(fsp->fs_log);
+		free(fsp->fs_rt);
+	}
+
+	fs_count = 0;
+	xfs_fs_count = 0;
+	free(fs_table);
+	fs_table = NULL;
+}
+
 /*
  * Table iteration (cursor-based) interfaces
  */

