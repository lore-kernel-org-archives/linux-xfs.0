Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71D9BE67
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MeYx//i1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8343C433C8;
	Sun, 31 Dec 2023 22:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061701;
	bh=kb+SRakTp6BmZpP2l7drmzh2NxPB2mTCz7lovIoKHdI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MeYx//i18ENTlAkKyBsbA/bIfNXzi1p/yCHRzGAbAy+MG2q6jIBFo8b8qtWhquxz5
	 LpUxVl2gMLKfXHZiPA/m8hWfYvnxUlczbNq0pgIfxS+nGXikfDO/Cccmh2H+2NIGl5
	 oJwMBufEL4L9kqAxRz6IZaHICCLM7Vqx5IZSVngE0paSvWxB8XIqLSt9ecVKejL+RB
	 F3fIlDwxWlprMXTjpO29l3h9obP3zsTi/OHD8/cMlRCvsuNVPhyCofLOuBsZgSDXOk
	 i7pNZBw95WXn4W5S5njHDqu1VHF+h5qam+SyEOeFlw3vgLP44Wcv1qBYmnstpAm7YJ
	 YpxQNPFK5QWWA==
Date: Sun, 31 Dec 2023 14:28:21 -0800
Subject: [PATCH 05/20] xfs: introduce a swap-extent log intent item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996341.1796128.15576953269608510832.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
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

Introduce a new intent log item to handle swapping extents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_log_format.h |   51 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 48 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 16872972e1e..24c3d5dc361 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -117,8 +117,9 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
 #define XLOG_REG_TYPE_ATTR_NAME	29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
-#define XLOG_REG_TYPE_MAX		30
-
+#define XLOG_REG_TYPE_SXI_FORMAT	31
+#define XLOG_REG_TYPE_SXD_FORMAT	32
+#define XLOG_REG_TYPE_MAX		32
 
 /*
  * Flags to log operation header
@@ -243,6 +244,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_BUD		0x1245
 #define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
 #define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
+#define	XFS_LI_SXI		0x1248  /* extent swap intent */
+#define	XFS_LI_SXD		0x1249  /* extent swap done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -260,7 +263,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
 	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
 	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
-	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
+	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }, \
+	{ XFS_LI_SXI,		"XFS_LI_SXI" }, \
+	{ XFS_LI_SXD,		"XFS_LI_SXD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -878,6 +883,46 @@ struct xfs_bud_log_format {
 	uint64_t		bud_bui_id;	/* id of corresponding bui */
 };
 
+/*
+ * SXI/SXD (extent swapping) log format definitions
+ */
+
+struct xfs_swap_extent {
+	uint64_t		sx_inode1;
+	uint64_t		sx_inode2;
+	uint64_t		sx_startoff1;
+	uint64_t		sx_startoff2;
+	uint64_t		sx_blockcount;
+	uint64_t		sx_flags;
+	int64_t			sx_isize1;
+	int64_t			sx_isize2;
+};
+
+#define XFS_SWAP_EXT_FLAGS		(0)
+
+#define XFS_SWAP_EXT_STRINGS
+
+/* This is the structure used to lay out an sxi log item in the log. */
+struct xfs_sxi_log_format {
+	uint16_t		sxi_type;	/* sxi log item type */
+	uint16_t		sxi_size;	/* size of this item */
+	uint32_t		__pad;		/* must be zero */
+	uint64_t		sxi_id;		/* sxi identifier */
+	struct xfs_swap_extent	sxi_extent;	/* extent to swap */
+};
+
+/*
+ * This is the structure used to lay out an sxd log item in the
+ * log.  The sxd_extents array is a variable size array whose
+ * size is given by sxd_nextents;
+ */
+struct xfs_sxd_log_format {
+	uint16_t		sxd_type;	/* sxd log item type */
+	uint16_t		sxd_size;	/* size of this item */
+	uint32_t		__pad;
+	uint64_t		sxd_sxi_id;	/* id of corresponding bui */
+};
+
 /*
  * Dquot Log format definitions.
  *

