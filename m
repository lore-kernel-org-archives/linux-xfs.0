Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF872BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mFQKAwiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E6BC433C7;
	Sun, 31 Dec 2023 21:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056930;
	bh=3py4V5QCfFDtLF+8uR0Wq6FrYYi7ulCA+Rupuuwh/2o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mFQKAwiERAq9qG8rYu2V2Be00qvFH+G4dgtFgbCX/d9jV/ksBbFHDWu5ZZs7HkzgZ
	 vqqkahAxmJ/Cghf/X3JZQo1O2LQwotr54FjWDtjoOg1wvY5VmUqshwP1HJf9QU8Edn
	 SupSUPEgYPL6qFD0j+QYMmzXi92yBWdvKAyfCX1TXfEuxkml6YppzzNxhcGp9eResx
	 hh0Z8kdwFQHffP/qn+HrtbgYwQG7xubHcFf0D8kFtfQ8b26vtF7eF5fGfq1gS2y8Bu
	 gh6VqFHZcUoP74qpLAxCM40QGc2JFusaa0bUSrB845ok4rgJjZANxvj0sRl6XdFuL/
	 oa6b4p4zc+CDg==
Date: Sun, 31 Dec 2023 13:08:50 -0800
Subject: [PATCH 10/32] xfs: convert metadata inode lookup keys to use paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845025.1760491.7166028789997318003.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Convert the magic metadata inode lookup keys to use actual strings
for paths.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_imeta.c |   48 ++++++++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_imeta.h |   27 +++++++++++++++++++++++--
 fs/xfs/xfs_trace.h        |   10 ++++++++-
 3 files changed, 59 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index 497d28abaff10..bab82c3dde5de 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -49,26 +49,17 @@
  */
 
 /* Static metadata inode paths */
-
-const struct xfs_imeta_path XFS_IMETA_RTBITMAP = {
-	.bogus = 0,
-};
-
-const struct xfs_imeta_path XFS_IMETA_RTSUMMARY = {
-	.bogus = 1,
-};
-
-const struct xfs_imeta_path XFS_IMETA_USRQUOTA = {
-	.bogus = 2,
-};
-
-const struct xfs_imeta_path XFS_IMETA_GRPQUOTA = {
-	.bogus = 3,
-};
-
-const struct xfs_imeta_path XFS_IMETA_PRJQUOTA = {
-	.bogus = 4,
-};
+static const unsigned char *rtbitmap_path[]	= {"realtime", "bitmap"};
+static const unsigned char *rtsummary_path[]	= {"realtime", "summary"};
+static const unsigned char *usrquota_path[]	= {"quota", "user"};
+static const unsigned char *grpquota_path[]	= {"quota", "group"};
+static const unsigned char *prjquota_path[]	= {"quota", "project"};
+
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_RTBITMAP,	rtbitmap_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_RTSUMMARY,	rtsummary_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_USRQUOTA,	usrquota_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_GRPQUOTA,	grpquota_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_PRJQUOTA,	prjquota_path);
 
 /* Are these two paths equal? */
 STATIC bool
@@ -76,7 +67,20 @@ xfs_imeta_path_compare(
 	const struct xfs_imeta_path	*a,
 	const struct xfs_imeta_path	*b)
 {
-	return a == b;
+	unsigned int			i;
+
+	if (a == b)
+		return true;
+
+	if (a->im_depth != b->im_depth)
+		return false;
+
+	for (i = 0; i < a->im_depth; i++)
+		if (a->im_path[i] != b->im_path[i] &&
+		    strcmp(a->im_path[i], b->im_path[i]))
+			return false;
+
+	return true;
 }
 
 /* Is this path ok? */
@@ -84,7 +88,7 @@ static inline bool
 xfs_imeta_path_check(
 	const struct xfs_imeta_path	*path)
 {
-	return true;
+	return path->im_depth <= XFS_IMETA_MAX_DEPTH;
 }
 
 /* Functions for storing and retrieving superblock inode values. */
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 0a4361bda1c4f..60e0f6a6c134a 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -6,10 +6,23 @@
 #ifndef __XFS_IMETA_H__
 #define __XFS_IMETA_H__
 
+/* How deep can we nest metadata dirs? */
+#define XFS_IMETA_MAX_DEPTH	64
+
+/* Form an imeta path from a simple array of strings. */
+#define XFS_IMETA_DEFINE_PATH(name, path) \
+const struct xfs_imeta_path name = { \
+	.im_path = (path), \
+	.im_depth = ARRAY_SIZE(path), \
+}
+
 /* Key for looking up metadata inodes. */
 struct xfs_imeta_path {
-	/* Temporary: integer to keep the static imeta definitions unique */
-	int		bogus;
+	/* Array of string pointers. */
+	const unsigned char	**im_path;
+
+	/* Number of strings in path. */
+	uint8_t			im_depth;
 };
 
 /* Cleanup widget for metadata inode creation and deletion. */
@@ -25,6 +38,16 @@ struct xfs_imeta_update {
 	unsigned int		ip_locked:1;
 };
 
+/* Grab the last path component, mostly for tracing. */
+static inline const unsigned char *
+xfs_imeta_lastpath(
+	const struct xfs_imeta_update	*upd)
+{
+	if (upd->path && upd->path->im_path && upd->path->im_depth > 0)
+		return upd->path->im_path[upd->path->im_depth - 1];
+	return "?";
+}
+
 /* Lookup keys for static metadata inodes. */
 extern const struct xfs_imeta_path XFS_IMETA_RTBITMAP;
 extern const struct xfs_imeta_path XFS_IMETA_RTSUMMARY;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index bedfed2ef3e60..12f68507d7a74 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5091,13 +5091,16 @@ DECLARE_EVENT_CLASS(xfs_imeta_update_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
+		__string(fname, xfs_imeta_lastpath(upd))
 	),
 	TP_fast_assign(
 		__entry->dev = upd->mp->m_super->s_dev;
 		__entry->ino = upd->ip ? upd->ip->i_ino : NULLFSINO;
+		__assign_str(fname, xfs_imeta_lastpath(upd));
 	),
-	TP_printk("dev %d:%d ino 0x%llx",
+	TP_printk("dev %d:%d fname '%s' ino 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __get_str(fname),
 		  __entry->ino)
 )
 
@@ -5121,14 +5124,17 @@ DECLARE_EVENT_CLASS(xfs_imeta_update_error_class,
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(int, error)
+		__string(fname, xfs_imeta_lastpath(upd))
 	),
 	TP_fast_assign(
 		__entry->dev = upd->mp->m_super->s_dev;
 		__entry->ino = upd->ip ? upd->ip->i_ino : NULLFSINO;
 		__entry->error = error;
+		__assign_str(fname, xfs_imeta_lastpath(upd));
 	),
-	TP_printk("dev %d:%d ino 0x%llx error %d",
+	TP_printk("dev %d:%d fname '%s' ino 0x%llx error %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __get_str(fname),
 		  __entry->ino,
 		  __entry->error)
 )

