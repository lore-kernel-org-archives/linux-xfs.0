Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF91BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aS1zsAgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1A6C433C7;
	Sun, 31 Dec 2023 21:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059106;
	bh=S1HB87Jh432SVfnrdMA60zpCCquNIBO/LU2/Jtd3JP8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aS1zsAgSasb1/GqrMoOWi5s7T97kOz8u2MMsTiwvHPjDQcWT6yiOoe5rj4YYDQb/i
	 EP5BEu7RTiDGopVle1AwmjrobcYptoUx/HWYNdkmqQEmBzh8W2rfkzEKR4EYhb/0D+
	 mDQMH/neiQom2Y8YePMyy/laYSVR1O7nfLnzAz3087CjZvnPlw2qNGVnxjRx3lnyMv
	 BzOqIJJHtfLuZi3/owOErEmGMKaC1kJD8kI9cm1ah/7B17O0DQQkjUwtLtZ6blQ48X
	 ZdzVmaXrkGDfPYSuieOxS8FaLwevE52RrndNQR4dthC52xZenvkmV9wJ6M77E44xTX
	 wjNKlJZ9X8pmw==
Date: Sun, 31 Dec 2023 13:45:05 -0800
Subject: [PATCH 02/44] xfs: introduce realtime refcount btree definitions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851613.1766284.11276299938653255299.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Add new realtime refcount btree definitions. The realtime refcount btree
will be rooted from a hidden inode, but has its own shape and therefore
needs to have most of its own separate types.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.h  |    1 +
 fs/xfs/libxfs/xfs_format.h |    6 ++++++
 fs/xfs/libxfs/xfs_types.h  |    5 +++--
 fs/xfs/scrub/trace.h       |    1 +
 fs/xfs/xfs_trace.h         |    1 +
 5 files changed, 12 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 4753a5c847616..f58240adda6f4 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -65,6 +65,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 #define	XFS_BTNUM_RCBAG	((xfs_btnum_t)XFS_BTNUM_RCBAGi)
 #define	XFS_BTNUM_RTRMAP ((xfs_btnum_t)XFS_BTNUM_RTRMAPi)
+#define	XFS_BTNUM_RTREFC ((xfs_btnum_t)XFS_BTNUM_RTREFCi)
 
 struct xfs_btree_ops;
 uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1c1910256a927..0dc169fde2e3d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1815,6 +1815,12 @@ struct xfs_refcount_key {
 /* btree pointer type */
 typedef __be32 xfs_refcount_ptr_t;
 
+/*
+ * Realtime Reference Count btree format definitions
+ *
+ * This is a btree for reference count records for realtime volumes
+ */
+#define	XFS_RTREFC_CRC_MAGIC	0x52434e54	/* 'RCNT' */
 
 /*
  * BMAP Btree format definitions
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b3edc57dc65bd..4147ba288ec18 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -126,7 +126,7 @@ typedef enum {
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
 	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_RCBAGi,
-	XFS_BTNUM_RTRMAPi, XFS_BTNUM_MAX
+	XFS_BTNUM_RTRMAPi, XFS_BTNUM_RTREFCi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 #define XFS_BTNUM_STRINGS \
@@ -138,7 +138,8 @@ typedef enum {
 	{ XFS_BTNUM_FINOi,	"finobt" }, \
 	{ XFS_BTNUM_REFCi,	"refcbt" }, \
 	{ XFS_BTNUM_RCBAGi,	"rcbagbt" }, \
-	{ XFS_BTNUM_RTRMAPi,	"rtrmapbt" }
+	{ XFS_BTNUM_RTRMAPi,	"rtrmapbt" }, \
+	{ XFS_BTNUM_RTREFCi,	"rtrefcbt" }
 
 struct xfs_name {
 	const unsigned char	*name;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 65e0872792e1f..72b5277f4ba6d 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -49,6 +49,7 @@ TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RCBAGi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RTRMAPi);
+TRACE_DEFINE_ENUM(XFS_BTNUM_RTREFCi);
 
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_SHARED);
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_COW);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index fd4170a6aea43..86e0aa946aa00 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2555,6 +2555,7 @@ TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RCBAGi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RTRMAPi);
+TRACE_DEFINE_ENUM(XFS_BTNUM_RTREFCi);
 
 DECLARE_EVENT_CLASS(xfs_btree_cur_class,
 	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp),

