Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012BBC2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DySp13Fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647AAC433C8;
	Sun, 31 Dec 2023 23:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065391;
	bh=QuFqgqzER0t8/R+FFaFWpG4KBpl2YcqoW/je87ttp28=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DySp13Fd8OZYFdQgg8fl40zLJNT+IPAqLGq2IgnzNu9aKDv9ykOPp6BmRzctbTHbP
	 jW0jSAiM6ryP6MzWudyd3e3hxuh8IM9zXWLtrgsfTZtpfVzLFzQDvjIrxok6iUUXK3
	 zjJvdWb6qkIPpSx4OBQsEM5WZilUP3/H1G7mAPkrJtlQSth4zXhWP8rD01TO8ge5DM
	 aIqt/fyg4hbfJpcXLP1eCv9YwgXGebrsjZhXPTCyC1dltal8WBtjZtH+r40VQeqdY7
	 xaPFanDdoTguZ4WR4ayBTw26+AQGt00OA/S9qTM/1PvIWHpdQvupIjZNH68sqIS/uT
	 T3OBs14j+tOLA==
Date: Sun, 31 Dec 2023 15:29:50 -0800
Subject: [PATCH 01/58] xfs: don't use the incore struct xfs_sb for offsets
 into struct xfs_dsb
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009961.1809361.5479999483125335705.stgit@frogsfrogsfrogs>
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

Currently, the XFS_SB_CRC_OFF macro uses the incore superblock struct
(xfs_sb) to compute the address of sb_crc within the ondisk superblock
struct (xfs_dsb).  This is a landmine if we ever change the layout of
the incore superblock (as we're about to do), so redefine the macro
to use xfs_dsb to compute the layout of xfs_dsb.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c                   |    4 ++--
 libxfs/xfs_format.h       |    9 ++++-----
 libxfs/xfs_ondisk.h       |    1 +
 mdrestore/xfs_mdrestore.c |    6 ++----
 repair/agheader.c         |   12 ++++++------
 5 files changed, 15 insertions(+), 17 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index 9a5d665dfbd..e738065b5be 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -50,8 +50,8 @@ sb_init(void)
 	add_command(&version_cmd);
 }
 
-#define	OFF(f)	bitize(offsetof(xfs_sb_t, sb_ ## f))
-#define	SZC(f)	szcount(xfs_sb_t, sb_ ## f)
+#define	OFF(f)	bitize(offsetof(struct xfs_dsb, sb_ ## f))
+#define	SZC(f)	szcount(struct xfs_dsb, sb_ ## f)
 const field_t	sb_flds[] = {
 	{ "magicnum", FLDT_UINT32X, OI(OFF(magicnum)), C1, 0, TYP_NONE },
 	{ "blocksize", FLDT_UINT32D, OI(OFF(blocksize)), C1, 0, TYP_NONE },
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index b0aaa825539..c60af436963 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -90,8 +90,7 @@ struct xfs_ifork;
 #define XFSLABEL_MAX			12
 
 /*
- * Superblock - in core version.  Must match the ondisk version below.
- * Must be padded to 64 bit alignment.
+ * Superblock - in core version.  Must be padded to 64 bit alignment.
  */
 typedef struct xfs_sb {
 	uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
@@ -178,10 +177,8 @@ typedef struct xfs_sb {
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
-#define XFS_SB_CRC_OFF		offsetof(struct xfs_sb, sb_crc)
-
 /*
- * Superblock - on disk version.  Must match the in core version above.
+ * Superblock - on disk version.
  * Must be padded to 64 bit alignment.
  */
 struct xfs_dsb {
@@ -265,6 +262,8 @@ struct xfs_dsb {
 	/* must be padded to 64 bit alignment */
 };
 
+#define XFS_SB_CRC_OFF		offsetof(struct xfs_dsb, sb_crc)
+
 /*
  * Misc. Flags - warning - these will be cleared by xfs_repair unless
  * a feature bit is set when the flag is used.
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index bffd39242d4..832d96f0f3c 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -85,6 +85,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_remote_t,	12);
 	 */
 
+	XFS_CHECK_OFFSET(struct xfs_dsb, sb_crc,		224);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, valuelen,	0);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, namelen,	2);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, nameval,	3);
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 8e3998db06c..6465a481ce3 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -101,10 +101,8 @@ fixup_superblock(
 	memset(block_buffer, 0, sb->sb_sectsize);
 	sb->sb_inprogress = 0;
 	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, sb);
-	if (xfs_sb_version_hascrc(sb)) {
-		xfs_update_cksum(block_buffer, sb->sb_sectsize,
-				 offsetof(struct xfs_sb, sb_crc));
-	}
+	if (xfs_sb_version_hascrc(sb))
+		xfs_update_cksum(block_buffer, sb->sb_sectsize, XFS_SB_CRC_OFF);
 
 	if (pwrite(ddev_fd, block_buffer, sb->sb_sectsize, 0) < 0)
 		fatal("error writing primary superblock: %s\n", strerror(errno));
diff --git a/repair/agheader.c b/repair/agheader.c
index 762901581e1..3930a0ac091 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -358,22 +358,22 @@ secondary_sb_whack(
 	 * size is the size of data which is valid for this sb.
 	 */
 	if (xfs_sb_version_hasmetauuid(sb))
-		size = offsetof(xfs_sb_t, sb_meta_uuid)
+		size = offsetof(struct xfs_dsb, sb_meta_uuid)
 			+ sizeof(sb->sb_meta_uuid);
 	else if (xfs_sb_version_hascrc(sb))
-		size = offsetof(xfs_sb_t, sb_lsn)
+		size = offsetof(struct xfs_dsb, sb_lsn)
 			+ sizeof(sb->sb_lsn);
 	else if (xfs_sb_version_hasmorebits(sb))
-		size = offsetof(xfs_sb_t, sb_bad_features2)
+		size = offsetof(struct xfs_dsb, sb_bad_features2)
 			+ sizeof(sb->sb_bad_features2);
 	else if (xfs_sb_version_haslogv2(sb))
-		size = offsetof(xfs_sb_t, sb_logsunit)
+		size = offsetof(struct xfs_dsb, sb_logsunit)
 			+ sizeof(sb->sb_logsunit);
 	else if (xfs_sb_version_hassector(sb))
-		size = offsetof(xfs_sb_t, sb_logsectsize)
+		size = offsetof(struct xfs_dsb, sb_logsectsize)
 			+ sizeof(sb->sb_logsectsize);
 	else /* only support dirv2 or more recent */
-		size = offsetof(xfs_sb_t, sb_dirblklog)
+		size = offsetof(struct xfs_dsb, sb_dirblklog)
 			+ sizeof(sb->sb_dirblklog);
 
 	/* Check the buffer we read from disk for garbage outside size */

