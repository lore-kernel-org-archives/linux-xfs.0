Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1700C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V1s3oNnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F0EC433C8;
	Sun, 31 Dec 2023 23:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065547;
	bh=LTnO4CjatAseTVxeJ5Jbnvm3RDhaGj1g+Hoq1X1gIkk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V1s3oNnNgQerFWXcz07uhtCPIB4lmH7Z52h2ubcWEb7ohP+Tq2Y42zAw9oy/PTn97
	 K7y+1mrW10lo6XGG7QRyw/JCN6tHjmapv6PUvJw/tmFaIxDep9nmMgR2aIjpCsVWY9
	 FLLCt4qrlxL8f/iG0uwz2jRmgaW5/M9HmtXhQs+s+UNJ9ofyIJII2ekOJNY6n552N4
	 RG/VFgJ8jFSYmite4IDoEMjI2hgIH+Vli7T5PUAS2dUc9ONAzYDoU47KZ4jXSgUnzy
	 L8v4a+zdZDXtggv14bo5ikZy5rFD3g4FN0iGVOWv9JYh1hRxmw9s5jKOTwJ6LNGt3v
	 WExk2NNGElRAA==
Date: Sun, 31 Dec 2023 15:32:27 -0800
Subject: [PATCH 11/58] xfs: convert metadata inode lookup keys to use paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010094.1809361.127923577020344029.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_imeta.c |   48 ++++++++++++++++++++++++++----------------------
 libxfs/xfs_imeta.h |   27 +++++++++++++++++++++++++--
 2 files changed, 51 insertions(+), 24 deletions(-)


diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index 086c250a3c2..e59b0f414ed 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -48,26 +48,17 @@
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
@@ -75,7 +66,20 @@ xfs_imeta_path_compare(
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
@@ -83,7 +87,7 @@ static inline bool
 xfs_imeta_path_check(
 	const struct xfs_imeta_path	*path)
 {
-	return true;
+	return path->im_depth <= XFS_IMETA_MAX_DEPTH;
 }
 
 /* Functions for storing and retrieving superblock inode values. */
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
index 0a4361bda1c..60e0f6a6c13 100644
--- a/libxfs/xfs_imeta.h
+++ b/libxfs/xfs_imeta.h
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

