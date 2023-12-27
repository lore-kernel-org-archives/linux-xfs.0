Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241F47F9
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0yCrb0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E472FC433C8;
	Mon,  1 Jan 2024 00:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068785;
	bh=2EdNrrzP4xM1+O2G/ymmypew6WdlTTTZq25CBfYJWUk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c0yCrb0aCR7/BTQnrd/1Y55EmOObaoF2D5dmeaoAZxWMxnPbAl1muVyZ9Y4rONc7W
	 HVkVtgZ7WZXG2+SflLwHqcjPwbBOvNIwnGN5drFvtOaVRO4re0OmDyA6+IaXW1DGKr
	 Rm+kHYI5tVyuiQcnbXJsDA7hk5fD98K+gvki2ie5qeTCA3uLmysx14bOEHn9gB5PPT
	 x+NKLtf1qr7flH6efFkTgnNql2vMYwJeAC8I+0dMYVx6KK9DJ7tprWaHxkrPcFdbld
	 1G6gcQLO/d9RIercYP7VJu3W9hHPl9XGuLZHtaMSt4D4FwlsLwoPE5K0hgG60ROy2b
	 Ef38oPSyvufKA==
Date: Sun, 31 Dec 2023 16:26:24 +9900
Subject: [PATCH 01/42] xfs: introduce realtime refcount btree definitions
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017138.1817107.14584000489556762268.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_btree.h  |    1 +
 libxfs/xfs_format.h |    6 ++++++
 libxfs/xfs_types.h  |    5 +++--
 3 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 4753a5c8476..f58240adda6 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -65,6 +65,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 #define	XFS_BTNUM_RCBAG	((xfs_btnum_t)XFS_BTNUM_RCBAGi)
 #define	XFS_BTNUM_RTRMAP ((xfs_btnum_t)XFS_BTNUM_RTRMAPi)
+#define	XFS_BTNUM_RTREFC ((xfs_btnum_t)XFS_BTNUM_RTREFCi)
 
 struct xfs_btree_ops;
 uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 1c1910256a9..0dc169fde2e 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index b3edc57dc65..4147ba288ec 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
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

