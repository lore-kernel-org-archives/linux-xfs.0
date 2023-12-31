Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42685C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JM6IBsiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10246C433C7;
	Sun, 31 Dec 2023 22:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062093;
	bh=2k87ZphoUyTe0paE85vQqCGHkx/LdRnAUZk9QHddoAk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JM6IBsiKBfLR1MjVLH2U3N9Kc/hsLR9tvZdX0S0+FVetNXzR3LlEDf8bkAdx+heP6
	 Kb/qIzbxSa75VY4vPqTob2QrGsKUsk4PSwpdxZW9pRvPLZj3haqWEekqXpAfimHlnM
	 19MGtPWw736sRGuCPDK6g2CNUKMoRdu4HCzv1KNNfdeIAhQR69ncgUSpslU8IRX4sw
	 MO7ssMtlGW8dON1RRPTHa2Tff64qOF6I+MQYZA0yrt3NaLffn+S5qC9TBmatqH+vj1
	 hT7d68E9nZ3ilC879bzWBz4CCK9re/9dRLz9at0eOsUOvL+N4UxaBxdPB4e4fUJo3o
	 ORqTU6xZpAFSg==
Date: Sun, 31 Dec 2023 14:34:52 -0800
Subject: [PATCH 1/1] xfs: repair extended attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404997313.1796932.8516728123495313162.stgit@frogsfrogsfrogs>
In-Reply-To: <170404997300.1796932.8121789737419955958.stgit@frogsfrogsfrogs>
References: <170404997300.1796932.8121789737419955958.stgit@frogsfrogsfrogs>
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

If the extended attributes look bad, try to sift through the rubble to
find whatever keys/values we can, stage a new attribute structure in a
temporary file and use the atomic extent swapping mechanism to commit
the results in bulk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c      |    2 +-
 libxfs/xfs_attr.h      |    2 ++
 libxfs/xfs_da_format.h |    5 +++++
 libxfs/xfs_swapext.c   |    2 +-
 libxfs/xfs_swapext.h   |    1 +
 5 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 985989b5ade..8f527ac9292 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1045,7 +1045,7 @@ xfs_attr_set(
  * External routines when attribute list is inside the inode
  *========================================================================*/
 
-static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
+int xfs_attr_sf_totsize(struct xfs_inode *dp)
 {
 	struct xfs_attr_shortform *sf;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 81be9b3e400..e4f55008552 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -618,4 +618,6 @@ extern struct kmem_cache *xfs_attr_intent_cache;
 int __init xfs_attr_intent_init_cache(void);
 void xfs_attr_intent_destroy_cache(void);
 
+int xfs_attr_sf_totsize(struct xfs_inode *dp);
+
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 44748f1640e..0e1ada44f21 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -716,6 +716,11 @@ struct xfs_attr3_leafblock {
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
 #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
 
+#define XFS_ATTR_NAMESPACE_STR \
+	{ XFS_ATTR_LOCAL,	"local" }, \
+	{ XFS_ATTR_ROOT,	"root" }, \
+	{ XFS_ATTR_SECURE,	"secure" }
+
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
  * there can be only one alignment value)
diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index f396593a5c8..1f7fbe76a89 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -767,7 +767,7 @@ xfs_swapext_rmapbt_blocks(
 }
 
 /* Estimate the bmbt and rmapbt overhead required to exchange extents. */
-static int
+int
 xfs_swapext_estimate_overhead(
 	struct xfs_swapext_req	*req)
 {
diff --git a/libxfs/xfs_swapext.h b/libxfs/xfs_swapext.h
index 37842a4ee9a..a4768eddc9c 100644
--- a/libxfs/xfs_swapext.h
+++ b/libxfs/xfs_swapext.h
@@ -200,6 +200,7 @@ unsigned int xfs_swapext_reflink_prep(const struct xfs_swapext_req *req);
 void xfs_swapext_reflink_finish(struct xfs_trans *tp,
 		const struct xfs_swapext_req *req, unsigned int reflink_state);
 
+int xfs_swapext_estimate_overhead(struct xfs_swapext_req *req);
 int xfs_swapext_estimate(struct xfs_swapext_req *req);
 
 extern struct kmem_cache	*xfs_swapext_intent_cache;

