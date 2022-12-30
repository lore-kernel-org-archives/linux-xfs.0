Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52AC8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbiLaAJy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiLaAJx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:09:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D5F1E3C3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:09:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 911A361CD5
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED187C433EF;
        Sat, 31 Dec 2022 00:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445392;
        bh=Wnfm5jaRBmblsWfXoifqnQ0vy1UiSF7rMCg5jv7M3xU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MnwP9tmeZageuCxrKy7mKh2pLmXwU72mm/jAgiDDfTyMvM8KPoX6NcqQtH6Ll8rGc
         sXl2YkRRyo/a42vVUI7N8SAN80ai5svRM+qhq+BZgtyRF9AILZCk9/UgBji4zN+6US
         TPC9sC0HVZ0yHTtaY89TZ2tU/VsvH23WHIegYk+BXqua3K/oyFxlvNlh/sNukpMpQQ
         D0YqGk8ZakKREQXi97a1itZZU4el+NmxlTnN48Ivh4x3LVwDWWwbLfBJdAJtc7OozQ
         PqUYekewt6RSKDG2jmIzwlQc3QL87N4Bcu5GDRqB4Oo+bxBMzRrM7XbIzFJwbUQsNV
         TcVrXLZ7wKXEg==
Subject: [PATCH 2/3] xfs: teach scrub to check file nlinks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:35 -0800
Message-ID: <167243865528.709394.5932602557148789175.stgit@magnolia>
In-Reply-To: <167243865502.709394.13215707195694339795.stgit@magnolia>
References: <167243865502.709394.13215707195694339795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Copy-pasta the online quotacheck code to check inode link counts too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c                     |    5 +++++
 libxfs/xfs_da_format.h              |   11 +++++++++++
 libxfs/xfs_dir2.c                   |    6 ++++++
 libxfs/xfs_dir2.h                   |    1 +
 libxfs/xfs_fs.h                     |    3 ++-
 man/man2/ioctl_xfs_scrub_metadata.2 |    4 ++++
 repair/phase6.c                     |    4 ----
 7 files changed, 29 insertions(+), 5 deletions(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 3718d56eae3..95daa78ba65 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -139,6 +139,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "quota counters",
 		.group	= XFROG_SCRUB_GROUP_ISCAN,
 	},
+	[XFS_SCRUB_TYPE_NLINKS] = {
+		.name	= "nlinks",
+		.descr	= "inode link counts",
+		.group	= XFROG_SCRUB_GROUP_ISCAN,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 25e2841084e..9d332415e0b 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -159,6 +159,17 @@ struct xfs_da3_intnode {
 
 #define XFS_DIR3_FT_MAX			9
 
+#define XFS_DIR3_FTYPE_STR \
+	{ XFS_DIR3_FT_UNKNOWN,	"unknown" }, \
+	{ XFS_DIR3_FT_REG_FILE,	"file" }, \
+	{ XFS_DIR3_FT_DIR,	"directory" }, \
+	{ XFS_DIR3_FT_CHRDEV,	"char" }, \
+	{ XFS_DIR3_FT_BLKDEV,	"block" }, \
+	{ XFS_DIR3_FT_FIFO,	"fifo" }, \
+	{ XFS_DIR3_FT_SOCK,	"sock" }, \
+	{ XFS_DIR3_FT_SYMLINK,	"symlink" }, \
+	{ XFS_DIR3_FT_WHT,	"whiteout" }
+
 /*
  * Byte offset in data block and shortform entry.
  */
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index d6a192963f5..033b6e4c475 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -24,6 +24,12 @@ const struct xfs_name xfs_name_dotdot = {
 	.type	= XFS_DIR3_FT_DIR,
 };
 
+const struct xfs_name xfs_name_dot = {
+	.name	= (unsigned char *)".",
+	.len	= 1,
+	.type	= XFS_DIR3_FT_DIR,
+};
+
 /*
  * Convert inode mode to directory entry filetype
  */
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index dd39f17dd9a..15a36cf7ae8 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -22,6 +22,7 @@ struct xfs_dir3_icfree_hdr;
 struct xfs_dir3_icleaf_hdr;
 
 extern const struct xfs_name	xfs_name_dotdot;
+extern const struct xfs_name	xfs_name_dot;
 
 /*
  * Convert inode mode to directory entry filetype
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 2f9f13ba75b..3885c56078f 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -710,9 +710,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
+#define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	26
+#define XFS_SCRUB_TYPE_NR	27
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/man/man2/ioctl_xfs_scrub_metadata.2 b/man/man2/ioctl_xfs_scrub_metadata.2
index 42bf1e1cac5..db238de1bb5 100644
--- a/man/man2/ioctl_xfs_scrub_metadata.2
+++ b/man/man2/ioctl_xfs_scrub_metadata.2
@@ -164,6 +164,10 @@ Examine all user, group, or project quota records for corruption.
 .B XFS_SCRUB_TYPE_FSCOUNTERS
 Examine all filesystem summary counters (free blocks, inode count, free inode
 count) for errors.
+
+.TP
+.B XFS_SCRUB_TYPE_NLINKS
+Scan all inodes in the filesystem to verify each file's link count.
 .RE
 
 .PD 1
diff --git a/repair/phase6.c b/repair/phase6.c
index 0be2c9c9705..a7f658d4267 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -23,10 +23,6 @@ static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
 static xfs_ino_t		orphanage_ino;
 
-static struct xfs_name		xfs_name_dot = {(unsigned char *)".",
-						1,
-						XFS_DIR3_FT_DIR};
-
 /*
  * Data structures used to keep track of directories where the ".."
  * entries are updated. These must be rebuilt after the initial pass

