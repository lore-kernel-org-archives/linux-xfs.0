Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3D05227
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832316; cv=none; b=DkRJJm9ZhkoPY97/yssd+V8b/MeVPv2El9eyjwVfciyyCVJxxAchuZueVHKL81UAufgiP5WX23RxuYP2KM3cMQX/X1eJSxsUDhScisKKHzIEtC2p2u02j2n+oo4iMVG7DLTGT40vhBQR4VucOLtJrK6oWn7s/OkDbMoahsBDhRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832316; c=relaxed/simple;
	bh=IHzsb+/GRr4mxDJ9HLY0iXbJJwb8fesFPdcHfFk0XoY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IjUgcV3LcIfGq9TcJWfQFSsODouHRozafIAPxFZULrID68inKkrnsiCkV0nsEg2yzg6l4UtLAA/TKVG60OELFtVsho57EUa7f8BkT7ig6SApZ5in4AieGV8i618xDYDxWj/SQTeUmHCsMg3Hw6nsas39eHrkfndr2N2M2byI0Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pWc14p4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pWc14p4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BEEC4CEC6;
	Wed,  2 Oct 2024 01:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832316;
	bh=IHzsb+/GRr4mxDJ9HLY0iXbJJwb8fesFPdcHfFk0XoY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pWc14p4vCYUDLkV+W9UYM6BUc1EHZOo/LeTpifLEmtVk8Yh3AP0PZ1u1/F1pfR+9H
	 5Y84UNI+5RffoY9NKUVIRQyMCGpesQQsN0AzEsgfyHcgb0wr6XrjmBe5cr8df+WxQ/
	 RfOkupgbaL3t17KlKBFuNiSEp/AiAT7Ry0muJBy7nwwd4CH4yt/nqV3a8YDyFB1e36
	 HzVMouF2KzlX+Uj6GeeOT6/QkzQTbeEn70QrlR2wrl02WVAhpbPSxm+s3CuBkUGQMB
	 GsdIU+uBKJVAcQI6Ggm0d3JePs5L8uI6gizzVDQdamPFl0N5wTauJxqH6YfdmfBMqH
	 Y6MIUobQWVdjQ==
Date: Tue, 01 Oct 2024 18:25:16 -0700
Subject: [PATCH 3/4] xfs_db/mdrestore/repair: don't use the incore struct
 xfs_sb for offsets into struct xfs_dsb
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783103075.4038482.16400875402327891337.stgit@frogsfrogsfrogs>
In-Reply-To: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
References: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
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

Source kernel commit: ac3a0275165b4f80d9b7b516d6a8f8b308644fff

Currently, the XFS_SB_CRC_OFF macro uses the incore superblock struct
(xfs_sb) to compute the address of sb_crc within the ondisk superblock
struct (xfs_dsb).  This is a landmine if we ever change the layout of
the incore superblock (as we're about to do), so redefine the macro
to use xfs_dsb to compute the layout of xfs_dsb.

Port the userspace utilities to the new code just like we did for the
kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c                   |    4 ++--
 mdrestore/xfs_mdrestore.c |    6 ++----
 repair/agheader.c         |   12 ++++++------
 3 files changed, 10 insertions(+), 12 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index 7836384a1..9fcb7340f 100644
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
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 334bdd228..269edb8f8 100644
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
index 762901581..3930a0ac0 100644
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

