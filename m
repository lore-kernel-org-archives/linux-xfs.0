Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F87047A41
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZUZS5lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2318EC433C8;
	Wed, 20 Dec 2023 17:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092458;
	bh=3lRRla+Q0o/2lorjQzUJ9KDkJoOPZl/2EY7eNm3kDQE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IZUZS5lRJ8EborpNcWHDxBDA3EIXmWN4klaZtJcxcdERRqnpzSNiOUZ3h/cTOTWFG
	 tMAX2wsESJglQpNNLOT+P1tzhiCa8c3DWAxhrs0nrSALzHVxQFvSr0Y79RRskhFnDM
	 u2kXCdJh0LDycPo6iGpD01CNS6HxBeshtlGdw4/WjNZe25w9gPUnTCQOBL+8yJsRvI
	 ExAH6lToWyxxMud7GtK7FOdV//Uy/KtgiKrIkLQh9VFM6hl1RUDXoHvy+6jGsJn8hT
	 FCtPQvoQkgqkhmjO+1lWdsMpmf3td37pOGjWbi9ihh5DPbp5VJ1/+QZJKiI0TAmEP8
	 7TULaaR6PyaPg==
Date: Wed, 20 Dec 2023 09:14:17 -0800
Subject: [PATCH 6/6] xfs_mdrestore: refactor progress printing and sb fixup
 code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170309218796.1607943.2978536167133920710.stgit@frogsfrogsfrogs>
In-Reply-To: <170309218716.1607943.7868749567386210342.stgit@frogsfrogsfrogs>
References: <170309218716.1607943.7868749567386210342.stgit@frogsfrogsfrogs>
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

Now that we've fixed the dissimilarities between the two progress
printing callsites, refactor them into helpers.  Do the same for the
duplicate code that clears sb_inprogress from the primary superblock
after the copy succeeds.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mdrestore/xfs_mdrestore.c |  109 ++++++++++++++++++++++++---------------------
 1 file changed, 59 insertions(+), 50 deletions(-)


diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 685ca4c1..8e3998db 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -58,6 +58,58 @@ print_progress(const char *fmt, ...)
 	mdrestore.progress_since_warning = true;
 }
 
+static inline void
+maybe_print_progress(
+	int64_t		*cursor,
+	int64_t		bytes_read)
+{
+	int64_t		mb_now = bytes_read >> 20;
+
+	if (!mdrestore.show_progress)
+		return;
+
+	if (mb_now != *cursor) {
+		print_progress("%lld MB read", mb_now);
+		*cursor = mb_now;
+	}
+}
+
+static inline void
+final_print_progress(
+	int64_t		*cursor,
+	int64_t		bytes_read)
+{
+	if (!mdrestore.show_progress)
+		goto done;
+
+	if (bytes_read <= (*cursor << 20))
+		goto done;
+
+	print_progress("%lld MB read", howmany_64(bytes_read, 1U << 20));
+
+done:
+	if (mdrestore.progress_since_warning)
+		putchar('\n');
+}
+
+static void
+fixup_superblock(
+	int		ddev_fd,
+	char		*block_buffer,
+	struct xfs_sb	*sb)
+{
+	memset(block_buffer, 0, sb->sb_sectsize);
+	sb->sb_inprogress = 0;
+	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, sb);
+	if (xfs_sb_version_hascrc(sb)) {
+		xfs_update_cksum(block_buffer, sb->sb_sectsize,
+				 offsetof(struct xfs_sb, sb_crc));
+	}
+
+	if (pwrite(ddev_fd, block_buffer, sb->sb_sectsize, 0) < 0)
+		fatal("error writing primary superblock: %s\n", strerror(errno));
+}
+
 static int
 open_device(
 	char		*path,
@@ -210,14 +262,7 @@ restore_v1(
 	bytes_read = 0;
 
 	for (;;) {
-		if (mdrestore.show_progress) {
-			int64_t		mb_now = bytes_read >> 20;
-
-			if (mb_now != mb_read) {
-				print_progress("%lld MB read", mb_now);
-				mb_read = mb_now;
-			}
-		}
+		maybe_print_progress(&mb_read, bytes_read);
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
 			if (pwrite(ddev_fd, &block_buffer[cur_index <<
@@ -247,22 +292,9 @@ restore_v1(
 		bytes_read += block_size + (mb_count << h->v1.mb_blocklog);
 	}
 
-	if (mdrestore.show_progress && bytes_read > (mb_read << 20))
-		print_progress("%lld MB read", howmany_64(bytes_read, 1U << 20));
+	final_print_progress(&mb_read, bytes_read);
 
-	if (mdrestore.progress_since_warning)
-		putchar('\n');
-
-	memset(block_buffer, 0, sb.sb_sectsize);
-	sb.sb_inprogress = 0;
-	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, &sb);
-	if (xfs_sb_version_hascrc(&sb)) {
-		xfs_update_cksum(block_buffer, sb.sb_sectsize,
-				 offsetof(struct xfs_sb, sb_crc));
-	}
-
-	if (pwrite(ddev_fd, block_buffer, sb.sb_sectsize, 0) < 0)
-		fatal("error writing primary superblock: %s\n", strerror(errno));
+	fixup_superblock(ddev_fd, block_buffer, &sb);
 
 	free(metablock);
 }
@@ -401,6 +433,8 @@ restore_v2(
 		char *device;
 		int fd;
 
+		maybe_print_progress(&mb_read, bytes_read);
+
 		if (fread(&xme, sizeof(xme), 1, md_fp) != 1) {
 			if (feof(md_fp))
 				break;
@@ -428,38 +462,13 @@ restore_v2(
 				len);
 
 		bytes_read += len;
-
-		if (mdrestore.show_progress) {
-			int64_t	mb_now = bytes_read >> 20;
-
-			if (mb_now != mb_read) {
-				print_progress("%lld mb read", mb_now);
-				mb_read = mb_now;
-			}
-		}
 	} while (1);
 
-	if (mdrestore.show_progress && bytes_read > (mb_read << 20))
-		print_progress("%lld mb read", howmany_64(bytes_read, 1U << 20));
+	final_print_progress(&mb_read, bytes_read);
 
-	if (mdrestore.progress_since_warning)
-		putchar('\n');
-
-	memset(block_buffer, 0, sb.sb_sectsize);
-	sb.sb_inprogress = 0;
-	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, &sb);
-	if (xfs_sb_version_hascrc(&sb)) {
-		xfs_update_cksum(block_buffer, sb.sb_sectsize,
-				offsetof(struct xfs_sb, sb_crc));
-	}
-
-	if (pwrite(ddev_fd, block_buffer, sb.sb_sectsize, 0) < 0)
-		fatal("error writing primary superblock: %s\n",
-			strerror(errno));
+	fixup_superblock(ddev_fd, block_buffer, &sb);
 
 	free(block_buffer);
-
-	return;
 }
 
 static struct mdrestore_ops mdrestore_ops_v2 = {

