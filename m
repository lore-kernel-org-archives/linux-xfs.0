Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEDEC129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ak5Nk2hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D41C433C7;
	Sun, 31 Dec 2023 22:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061483;
	bh=3bzUONa+Q+3LcG3zfM8zdL3/s/OMybHODPbUFeTWylM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ak5Nk2hnnSxVjiS2fdJtjMlAWLYBjaG/X5uAkYDQ6SLAbNmlc34gQzwZRHX4pGgNl
	 f6ZzHtb3ZOEVkNzIxQ4HpUGzbOfAemOQMZ1zasLckFM58/iLLIfOIQ294Lkpvtbpu3
	 0GGyWmrtHpHY52EcF+uNxveovCGiXbVKEJnA887yyLGgiB82ZpNnYEKcp1fNHT1eZZ
	 EX/b5/VZa2BzyIW2aNYzAHlyITkE9Hj454giBRytK61eXvMfyO1igh2/H/qmKzG3HE
	 RRjXMigjR+qrNFVAiyy5VgJGllWmwzYfG0UdwH0RJVN5Xa1fSzjN7cL8ZcP05FRE6d
	 fCFX2BUKZsYXQ==
Date: Sun, 31 Dec 2023 14:24:42 -0800
Subject: [PATCH 4/5] xfs: move xfs_bmap_defer_add to xfs_bmap_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994873.1795600.5042797508566085479.stgit@frogsfrogsfrogs>
In-Reply-To: <170404994817.1795600.10635472836293725435.stgit@frogsfrogsfrogs>
References: <170404994817.1795600.10635472836293725435.stgit@frogsfrogsfrogs>
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

Move the code that adds the incore xfs_bmap_item deferred work data to a
transaction live with the BUI log item code.  This means that the file
mapping code no longer has to know about the inner workings of the BUI
log items.

As a consequence, we can hide the _get_group helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/Makefile     |    1 +
 libxfs/defer_item.c |   15 ++++++++++++++-
 libxfs/defer_item.h |   13 +++++++++++++
 libxfs/xfs_bmap.c   |    6 ++----
 libxfs/xfs_bmap.h   |    3 ---
 5 files changed, 30 insertions(+), 8 deletions(-)
 create mode 100644 libxfs/defer_item.h


diff --git a/libxfs/Makefile b/libxfs/Makefile
index 8e6b2dfdfe1..e1248c2b3ca 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -20,6 +20,7 @@ PKGHFILES = xfs_fs.h \
 	xfs_log_format.h
 
 HFILES = \
+	defer_item.h \
 	libxfs_io.h \
 	libxfs_api_defs.h \
 	init.h \
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 78de8491bb5..c9502d30860 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -24,6 +24,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "libxfs.h"
+#include "defer_item.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -482,7 +483,7 @@ xfs_bmap_update_create_done(
 }
 
 /* Take an active ref to the AG containing the space we're mapping. */
-void
+static inline void
 xfs_bmap_update_get_group(
 	struct xfs_mount	*mp,
 	struct xfs_bmap_intent	*bi)
@@ -501,6 +502,18 @@ xfs_bmap_update_get_group(
 	bi->bi_pag = xfs_perag_intent_get(mp, agno);
 }
 
+/* Add this deferred BUI to the transaction. */
+void
+xfs_bmap_defer_add(
+	struct xfs_trans	*tp,
+	struct xfs_bmap_intent	*bi)
+{
+	trace_xfs_bmap_defer(bi);
+
+	xfs_bmap_update_get_group(tp->t_mountp, bi);
+	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
+}
+
 /* Release an active AG ref after finishing mapping work. */
 static inline void
 xfs_bmap_update_put_group(
diff --git a/libxfs/defer_item.h b/libxfs/defer_item.h
new file mode 100644
index 00000000000..6d3abf1589c
--- /dev/null
+++ b/libxfs/defer_item.h
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef	__LIBXFS_DEFER_ITEM_H_
+#define	__LIBXFS_DEFER_ITEM_H_
+
+struct xfs_bmap_intent;
+
+void xfs_bmap_defer_add(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
+
+#endif /* __LIBXFS_DEFER_ITEM_H_ */
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 6b0d6d2e635..69ed4150c5e 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -31,6 +31,7 @@
 #include "xfs_refcount.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
+#include "defer_item.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -6170,10 +6171,7 @@ __xfs_bmap_add(
 	bi->bi_whichfork = whichfork;
 	bi->bi_bmap = *bmap;
 
-	trace_xfs_bmap_defer(bi);
-
-	xfs_bmap_update_get_group(tp->t_mountp, bi);
-	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
+	xfs_bmap_defer_add(tp, bi);
 	return 0;
 }
 
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index b477f92c850..a5e37ef7b75 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -243,9 +243,6 @@ struct xfs_bmap_intent {
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
-void xfs_bmap_update_get_group(struct xfs_mount *mp,
-		struct xfs_bmap_intent *bi);
-
 int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 void	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap);

