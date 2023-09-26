Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651D9E7F14B
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjI0AUG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbjI0ASF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:18:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C17A10C6
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:40:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0ACC433C7;
        Tue, 26 Sep 2023 23:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771601;
        bh=twVZxD1FIC86dMQbtgPQmiQmI+gUwyXi//hDR9O+6d4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Ggk/KijhWNsjeNMBISHeeXcuha8I1qEX4vvVULY+XBsfgNV7NMDEgPumBB93gXY+k
         lqZ7vJObYWDshA6zKtrQoX/MgfphHDdtu0PSaGGP+y9f/bAcZuXQJ5OOJ0jhQjbOyK
         L4DNXvlJ7w6fAxGLdMtIIPA0QJI7I2K8DQqLJgTExQ1gc5VebATiBoqAK7Jso1Fzmq
         FUcFGD7Uo+SbtPq2Mk7s2PqwzJhZU+CH1hsCkpPAV+EB7aF6mVSLSroX5fTNvd4J12
         XeWmy7mgZ38i3OeDjt3mfPr6pK8iMM9GiwhbdeX0otUpwgNLSL/3OnJYs+ZLHIMZOq
         hyTOn0m5ZVirw==
Date:   Tue, 26 Sep 2023 16:40:00 -0700
Subject: [PATCH 3/5] xfs: pull xfs_qm_dqiterate back into scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577061619.3315644.9779247939819150874.stgit@frogsfrogsfrogs>
In-Reply-To: <169577061571.3315644.2567541587400012629.stgit@frogsfrogsfrogs>
References: <169577061571.3315644.2567541587400012629.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There aren't any other users of this code outside of online fsck, so
pull it back in there.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile          |    5 ++++
 fs/xfs/scrub/dqiterate.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/quota.c     |    3 ++-
 fs/xfs/scrub/quota.h     |   14 ++++++++++++
 fs/xfs/xfs_dquot.c       |   31 ---------------------------
 fs/xfs/xfs_dquot.h       |    5 ----
 6 files changed, 72 insertions(+), 38 deletions(-)
 create mode 100644 fs/xfs/scrub/dqiterate.c
 create mode 100644 fs/xfs/scrub/quota.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 36e7bc7d147e2..91008db406fb2 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -175,7 +175,10 @@ xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   rtsummary.o \
 				   )
 
-xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
+xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix scrub/, \
+				   dqiterate.o \
+				   quota.o \
+				   )
 
 # online repair
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
diff --git a/fs/xfs/scrub/dqiterate.c b/fs/xfs/scrub/dqiterate.c
new file mode 100644
index 0000000000000..83bb483aafb39
--- /dev/null
+++ b/fs/xfs/scrub/dqiterate.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_bit.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_quota.h"
+#include "xfs_qm.h"
+#include "xfs_bmap.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/quota.h"
+
+/*
+ * Iterate every dquot of a particular type.  The caller must ensure that the
+ * particular quota type is active.  iter_fn can return negative error codes,
+ * or -ECANCELED to indicate that it wants to stop iterating.
+ */
+int
+xchk_dqiterate(
+	struct xfs_mount	*mp,
+	xfs_dqtype_t		type,
+	xchk_dqiterate_fn	iter_fn,
+	void			*priv)
+{
+	struct xfs_dquot	*dq;
+	xfs_dqid_t		id = 0;
+	int			error;
+
+	do {
+		error = xfs_qm_dqget_next(mp, id, type, &dq);
+		if (error == -ENOENT)
+			return 0;
+		if (error)
+			return error;
+
+		error = iter_fn(dq, type, priv);
+		id = dq->q_id + 1;
+		xfs_qm_dqput(dq);
+	} while (error == 0 && id != 0);
+
+	return error;
+}
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 49835d2840b4a..f142ca6646061 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -18,6 +18,7 @@
 #include "xfs_bmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/quota.h"
 
 /* Convert a scrub type code to a DQ flag, or return 0 if error. */
 static inline xfs_dqtype_t
@@ -320,7 +321,7 @@ xchk_quota(
 	xchk_iunlock(sc, sc->ilock_flags);
 	sqi.sc = sc;
 	sqi.last_id = 0;
-	error = xfs_qm_dqiterate(mp, dqtype, xchk_quota_item, &sqi);
+	error = xchk_dqiterate(mp, dqtype, xchk_quota_item, &sqi);
 	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	if (error == -ECANCELED)
 		error = 0;
diff --git a/fs/xfs/scrub/quota.h b/fs/xfs/scrub/quota.h
new file mode 100644
index 0000000000000..0d7b3b01436e6
--- /dev/null
+++ b/fs/xfs/scrub/quota.h
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_QUOTA_H__
+#define __XFS_SCRUB_QUOTA_H__
+
+typedef int (*xchk_dqiterate_fn)(struct xfs_dquot *dq,
+		xfs_dqtype_t type, void *priv);
+int xchk_dqiterate(struct xfs_mount *mp, xfs_dqtype_t type,
+		xchk_dqiterate_fn iter_fn, void *priv);
+
+#endif /* __XFS_SCRUB_QUOTA_H__ */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ac6ba646624df..83647e2f04527 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1361,34 +1361,3 @@ xfs_qm_exit(void)
 	kmem_cache_destroy(xfs_dqtrx_cache);
 	kmem_cache_destroy(xfs_dquot_cache);
 }
-
-/*
- * Iterate every dquot of a particular type.  The caller must ensure that the
- * particular quota type is active.  iter_fn can return negative error codes,
- * or -ECANCELED to indicate that it wants to stop iterating.
- */
-int
-xfs_qm_dqiterate(
-	struct xfs_mount	*mp,
-	xfs_dqtype_t		type,
-	xfs_qm_dqiterate_fn	iter_fn,
-	void			*priv)
-{
-	struct xfs_dquot	*dq;
-	xfs_dqid_t		id = 0;
-	int			error;
-
-	do {
-		error = xfs_qm_dqget_next(mp, id, type, &dq);
-		if (error == -ENOENT)
-			return 0;
-		if (error)
-			return error;
-
-		error = iter_fn(dq, type, priv);
-		id = dq->q_id + 1;
-		xfs_qm_dqput(dq);
-	} while (error == 0 && id != 0);
-
-	return error;
-}
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 80c8f851a2f3b..8d9d4b0d979d0 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -234,11 +234,6 @@ static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 	return dqp;
 }
 
-typedef int (*xfs_qm_dqiterate_fn)(struct xfs_dquot *dq,
-		xfs_dqtype_t type, void *priv);
-int xfs_qm_dqiterate(struct xfs_mount *mp, xfs_dqtype_t type,
-		xfs_qm_dqiterate_fn iter_fn, void *priv);
-
 time64_t xfs_dquot_set_timeout(struct xfs_mount *mp, time64_t timeout);
 time64_t xfs_dquot_set_grace_period(time64_t grace);
 

