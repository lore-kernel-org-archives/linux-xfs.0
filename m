Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D836A1E498
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347707; cv=none; b=rJKbC/S3zEBH+Y1naJ7ulbKDznyF6dNdslyDHq9R2craD4704DhJHjQrO64VupQ5HrR1A9MgW8LkpzzFr7ko/joCsysyFnIO5A8WwGvUokbB9/J3zcpC0gD5rnGnuVoM+obc6A8q8RQvm6LyzS0GQli8zNiX3AGtc+c7a5UbLtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347707; c=relaxed/simple;
	bh=LSC1yosxYf2fcPd4VCa9SFjXKFq3UVzglM4+chgWhsQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZalZKNdqxhSGbOKu5eirsu8znnv/e7ITCKq/B4tEvFe88I7e4X+DILxQLef2H40bfRtCLfiWbdFET0OCVMYIc0UBHNzAjN9sj7vYtPwS/lJ6uRMLJMc/Rh7QBhXxPv2f5hk5IYcQf5OdWf1gMh6srZ3zRHEIZTTE242uolkebXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IyxPkVSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IyxPkVSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EFFC2BD11;
	Wed, 22 May 2024 03:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347707;
	bh=LSC1yosxYf2fcPd4VCa9SFjXKFq3UVzglM4+chgWhsQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IyxPkVSNB1i8JBq/UOWl2ACRlEVwHhsBKr3HdQpvtXhHUYqrb+vESSSRnylvKJKny
	 DhCIKR999cyfx+pXCBT1Q8bgqiPT5aboaT0rN+Movd1eykDmJuC9qqGIxvr3PLokEi
	 hzOYOf6FPut/w1qi47Zfzu6G/IEnn70hhCGfCda1ozACOxZjRu4YzJQoEtavnnvV8D
	 gl1T7l4yTfczxcviZq1joNbTxGlAPg8hLbU3rhU6s+wzmjtjJ+oz6k3SIrJeGHDzaD
	 E8EBRPUUWA5TN+PDRknc5BGdm+KDoEocGACPsOrWGiIcW+m5d1kId0isRZahEp8xc8
	 6G44qpmtg6mlg==
Date: Tue, 21 May 2024 20:15:06 -0700
Subject: [PATCH 101/111] xfs: move xfs_bmap_defer_add to xfs_bmap_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533219.2478931.15046541974176982300.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 80284115854e60686b2e0183b31bb303ae69aa8c

Move the code that adds the incore xfs_bmap_item deferred work data to a
transaction live with the BUI log item code.  This means that the file
mapping code no longer has to know about the inner workings of the BUI
log items.

As a consequence, we can hide the _get_group helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/Makefile     |    1 +
 libxfs/defer_item.c |   15 ++++++++++++++-
 libxfs/defer_item.h |   13 +++++++++++++
 libxfs/xfs_bmap.c   |    6 ++----
 libxfs/xfs_bmap.h   |    3 ---
 5 files changed, 30 insertions(+), 8 deletions(-)
 create mode 100644 libxfs/defer_item.h


diff --git a/libxfs/Makefile b/libxfs/Makefile
index 9baee62c0..1c88dbc2a 100644
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
index 014589f82..d67032c26 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -24,6 +24,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "libxfs.h"
+#include "defer_item.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -479,7 +480,7 @@ xfs_bmap_update_create_done(
 }
 
 /* Take an active ref to the AG containing the space we're mapping. */
-void
+static inline void
 xfs_bmap_update_get_group(
 	struct xfs_mount	*mp,
 	struct xfs_bmap_intent	*bi)
@@ -498,6 +499,18 @@ xfs_bmap_update_get_group(
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
index 000000000..6d3abf158
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
index ae4f7e699..07bd8b346 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -31,6 +31,7 @@
 #include "xfs_refcount.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
+#include "defer_item.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -6192,10 +6193,7 @@ __xfs_bmap_add(
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
index 0a2fd9304..325cc232a 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -245,9 +245,6 @@ struct xfs_bmap_intent {
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
-void xfs_bmap_update_get_group(struct xfs_mount *mp,
-		struct xfs_bmap_intent *bi);
-
 int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 void	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap);

