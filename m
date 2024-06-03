Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B374C13A416
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442303; cv=none; b=P9oE220QBOiV5imRzt+SCFcQyHL9+dm4Jn2CtL/EiQWzBwSklI8r3kpYlKQCAOjZ+B2RfVN3KwCo5lIGh0E9pGrYO+4jl4gire0I9LUaMKHJB49RwdyKArN9REAbRhAXI19wj05EKSr8opzqOL+dCmsk1BsL/zqIvrOrYwTCbXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442303; c=relaxed/simple;
	bh=mJC5dFYfs5w6NVOEWunyHy++wr1S81iNx3ArtFhmfx8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VoXtlGxs5Nc9MHjA1qv5vDvUnoZwFW4gUf5N10lczladT/vlXEVQ2//1eudgTueEGx/XcpdF9Sie4xfzkg3yZonhI56E24yKDAubCAg0kp5X+jRF8vCGvCnx/Hk/bsBPOFpy3IWCw9zUIA8DWXQz0GlEtl72iLOME4RqXaC4ctA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kuZodZZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kuZodZZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C84C32782;
	Mon,  3 Jun 2024 19:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442303;
	bh=mJC5dFYfs5w6NVOEWunyHy++wr1S81iNx3ArtFhmfx8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kuZodZZUXYscO7a97GEEabP0mu1L64L56EZMxPRHWazWDQJ65buj/WGT8Bn1QnJfW
	 +Ie3Ppgcexo6P57Sep2h2uJs6dgRw78x6aZv/dZ9gvd/WaLHvnsFUmFrPtOlGKk4fu
	 e68QOw9aO8xUhwbAiGEIf+uUxAJzDEvYk9zVrHN1Zh0NHmWzHKaUv9ucDl1GKZ0QDn
	 4m6skrEf0if5x+bFhtVGvJZ41IfxqmRAVQpnY9BP11oy0hoM1bPAUwU9fsYMcPTkmO
	 lB5SNyBirJB9K5LRGdQCvzKxG9Ai4m8PxlYaLO40g6c7yO5DermPSyapl+M9HY/Yve
	 eGp+06Cy3DozQ==
Date: Mon, 03 Jun 2024 12:18:23 -0700
Subject: [PATCH 101/111] xfs: move xfs_bmap_defer_add to xfs_bmap_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040883.1443973.3817411985567051486.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

