Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25645 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdHDAJj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Aug 2017 20:09:39 -0400
Subject: [PATCH 18/22] xfs_scrub: fstrim the free areas if there are no
 errors on the filesystem
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 03 Aug 2017 17:09:34 -0700
Message-ID: <150180537405.18784.14838999249522731708.stgit@magnolia>
In-Reply-To: <150180525692.18784.13730590233404009267.stgit@magnolia>
References: <150180525692.18784.13730590233404009267.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the filesystem scan comes out clean or fixes all the problems, call
fstrim to clean out the free areas (if it's an ssd/thinp/whatever).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase4.c |    5 +++++
 scrub/vfs.c    |   23 +++++++++++++++++++++++
 scrub/vfs.h    |    2 ++
 3 files changed, 30 insertions(+)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index 7c2e0fb..606f3fd 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -87,5 +87,10 @@ xfs_repair_fs(
 	}
 	destroy_work_queue(&wq);
 
+	pthread_mutex_lock(&ctx->lock);
+	if (moveon && ctx->errors_found == 0)
+		fstrim(ctx);
+	pthread_mutex_unlock(&ctx->lock);
+
 	return moveon;
 }
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 1cff2ab..c6cbf5d 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -197,3 +197,26 @@ scan_fs_tree(
 
 	return sft.moveon;
 }
+
+#ifndef FITRIM
+struct fstrim_range {
+	__u64 start;
+	__u64 len;
+	__u64 minlen;
+};
+#define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
+#endif
+
+/* Call FITRIM to trim all the unused space in a filesystem. */
+void
+fstrim(
+	struct scrub_ctx	*ctx)
+{
+	struct fstrim_range	range = {0};
+	int			error;
+
+	range.len = ULLONG_MAX;
+	error = ioctl(ctx->mnt_fd, FITRIM, &range);
+	if (error && errno != EOPNOTSUPP && errno != ENOTTY)
+		perror(_("fstrim"));
+}
diff --git a/scrub/vfs.h b/scrub/vfs.h
index 3a3b2dc..fa6d9a3 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -30,4 +30,6 @@ typedef bool (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 bool scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
+void fstrim(struct scrub_ctx *ctx);
+
 #endif /* XFS_SCRUB_VFS_H_ */

