Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B97C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236165AbiLaCJX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCJV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:09:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD872140F1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:09:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A9E5B81E02
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F11C433EF;
        Sat, 31 Dec 2022 02:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452558;
        bh=/eAMeapHbzEHWsQ9owPQhdSkQR/IYFc7PaX9DZpaQOs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eQYwshUdi+7WvbOqIcbEhDh4gjsd/+H2aNvC0hF5Zctkiqd/D7RjLxy8vwlXliFx5
         zqOE9yBsyBttjWJXwT/MNWr0MgSfEmgME6R1LvLJp6k4eNiMTC/MKqezDd1Wuxm3bB
         gvpZVpYHiTaXbX+jZOLlt1MsjdUz/dE+f39BDHUpYqIjOl0yHLv4ZaFEmLfSeuWCE4
         qcrYqg/PJIuCuPmGQzvjIHbRfWw1Qlej4dsn5+k4wEX+SKuP6ZAlgX93wR3KWDiz0C
         xAVhtAmzflyaBF8Bz6wZY3+9uALqYTUrUARnajfN+DMUHnFKyR0H/Z1dISkQN/kO9U
         Gu1vemRy2gFdg==
Subject: [PATCH 24/26] xfs: don't use the incore struct xfs_sb for offsets
 into struct xfs_dsb
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:16 -0800
Message-ID: <167243875604.723621.9882135567786591664.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
 mdrestore/xfs_mdrestore.c |    6 ++----
 repair/agheader.c         |   12 ++++++------
 4 files changed, 14 insertions(+), 17 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index fd81286cd60..095c59596a4 100644
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
index 0c457905cce..abd75b3091e 100644
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
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 7c1a66c4001..9f8cbe98cd6 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -164,10 +164,8 @@ perform_restore(
 	memset(block_buffer, 0, sb.sb_sectsize);
 	sb.sb_inprogress = 0;
 	libxfs_sb_to_disk((struct xfs_dsb *)block_buffer, &sb);
-	if (xfs_sb_version_hascrc(&sb)) {
-		xfs_update_cksum(block_buffer, sb.sb_sectsize,
-				 offsetof(struct xfs_sb, sb_crc));
-	}
+	if (xfs_sb_version_hascrc(&sb))
+		xfs_update_cksum(block_buffer, sb.sb_sectsize, XFS_SB_CRC_OFF);
 
 	if (pwrite(dst_fd, block_buffer, sb.sb_sectsize, 0) < 0)
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

