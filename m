Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF62BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AYKnLCc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32FAC433C8;
	Sun, 31 Dec 2023 21:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058355;
	bh=G9MrzXIp+a/2boci0/eQ/LHW7gDOrQG4+OubWORU6ys=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AYKnLCc6lpiyUD4CdxcBhI5It9BhSNkLieBVl8lhBHPQwzvmA3JaV8fZhrP6Fgfjk
	 XkvvfXKsmYLg1eWLSCef3lkYqVKCK+cxNHTx/dOfssRGOqyMrNwoC9zuotO2ykW8B+
	 7t8E+kjl5h1uT/93Eic4Y6AEzVxkJkiWtZWQ2mlBp5Rr+9KKWL6+P3XdYwvlBswwIq
	 yKrrNqoTbP2vEQ5TKY+cEOhquAEcJbiWz7ETeuFkzubT+FyTz63sJRHrxhgTfNrWyZ
	 WbWl+p5saL9xXSHjHCeGWZzwH7MpfylMAtuyFK9fsDKrhsfjWGm3SMyeRY8BqcD1bJ
	 0yR0TGGVEBRcg==
Date: Sun, 31 Dec 2023 13:32:34 -0800
Subject: [PATCH 03/39] xfs: introduce realtime rmap btree definitions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404849949.1764998.560975757192969969.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_btree.h  |    1 +
 fs/xfs/libxfs/xfs_format.h |    7 +++++++
 fs/xfs/libxfs/xfs_types.h  |    5 +++--
 fs/xfs/scrub/trace.h       |    1 +
 fs/xfs/xfs_trace.h         |    1 +
 5 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index ce0bc5dfffe1c..e6571c9157d1e 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -64,6 +64,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 #define	XFS_BTNUM_RCBAG	((xfs_btnum_t)XFS_BTNUM_RCBAGi)
+#define	XFS_BTNUM_RTRMAP ((xfs_btnum_t)XFS_BTNUM_RTRMAPi)
 
 struct xfs_btree_ops;
 uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 87476c6bb6c64..b47d4f16143a6 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index ad2ce83874f9f..b3edc57dc65bd 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
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
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index dd809042a6041..bdcd77c839317 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -48,6 +48,7 @@ TRACE_DEFINE_ENUM(XFS_BTNUM_FINOi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RCBAGi);
+TRACE_DEFINE_ENUM(XFS_BTNUM_RTRMAPi);
 
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_SHARED);
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_COW);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 43ecf98f86558..1c89d38b85446 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2550,6 +2550,7 @@ TRACE_DEFINE_ENUM(XFS_BTNUM_FINOi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RCBAGi);
+TRACE_DEFINE_ENUM(XFS_BTNUM_RTRMAPi);
 
 DECLARE_EVENT_CLASS(xfs_btree_cur_class,
 	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp),

