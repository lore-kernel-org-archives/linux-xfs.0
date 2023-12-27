Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027F1389
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUnQ3Mpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5338C433C8;
	Mon,  1 Jan 2024 00:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067862;
	bh=y+fDsaWxEwi/ehMCf2dbgZalFgVA8BgmBNHu1R+AkeM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TUnQ3Mpvzvf1DONmFxb0q/qckQyFaZwSZtcuHMN4NRAIGNYHCzdiEoPs6z0HTsjpe
	 EkAlUjf24O9Px4lDECUfnceVGRN6uKrA3jsG/8H6LAPGKNmcz0nbzNNv5s8OrUxzYZ
	 mE3sPU61PUpNrjUKFU9gaE+KX+P0JqAffbWOXmCT3ejlNhONrZak1W8JxA/AH/CY+0
	 3SAfbuAWsgGIU0emJnOcWe1zCuAc/ASwLzRwIxglsTZ+NGyarO/jFvIjOTptiklPs7
	 HD5dK7e7n0FUIq+hyPGS1I/RPsPcUeG22ucNBpIHqUZTuhSGmRE55vLvcmqE5Y0oIj
	 dIZEyqHVjjJvQ==
Date: Sun, 31 Dec 2023 16:11:02 +9900
Subject: [PATCH 02/47] xfs: introduce realtime rmap btree definitions
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015339.1815505.9577554260995888788.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Add new realtime rmap btree definitions. The realtime rmap btree will
be rooted from a hidden inode, but has its own shape and therefore
needs to have most of its own separate types.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.h  |    1 +
 libxfs/xfs_format.h |    7 +++++++
 libxfs/xfs_types.h  |    5 +++--
 3 files changed, 11 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index ce0bc5dfffe..e6571c9157d 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -64,6 +64,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 #define	XFS_BTNUM_RCBAG	((xfs_btnum_t)XFS_BTNUM_RCBAGi)
+#define	XFS_BTNUM_RTRMAP ((xfs_btnum_t)XFS_BTNUM_RTRMAPi)
 
 struct xfs_btree_ops;
 uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 87476c6bb6c..b47d4f16143 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1746,6 +1746,13 @@ typedef __be32 xfs_rmap_ptr_t;
 	 XFS_FIBT_BLOCK(mp) + 1 : \
 	 XFS_IBT_BLOCK(mp) + 1)
 
+/*
+ * Realtime Reverse mapping btree format definitions
+ *
+ * This is a btree for reverse mapping records for realtime volumes
+ */
+#define	XFS_RTRMAP_CRC_MAGIC	0x4d415052	/* 'MAPR' */
+
 /*
  * Reference Count Btree format definitions
  *
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index ad2ce83874f..b3edc57dc65 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -126,7 +126,7 @@ typedef enum {
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
 	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_RCBAGi,
-	XFS_BTNUM_MAX
+	XFS_BTNUM_RTRMAPi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 #define XFS_BTNUM_STRINGS \
@@ -137,7 +137,8 @@ typedef enum {
 	{ XFS_BTNUM_INOi,	"inobt" }, \
 	{ XFS_BTNUM_FINOi,	"finobt" }, \
 	{ XFS_BTNUM_REFCi,	"refcbt" }, \
-	{ XFS_BTNUM_RCBAGi,	"rcbagbt" }
+	{ XFS_BTNUM_RCBAGi,	"rcbagbt" }, \
+	{ XFS_BTNUM_RTRMAPi,	"rtrmapbt" }
 
 struct xfs_name {
 	const unsigned char	*name;

