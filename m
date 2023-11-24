Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397313C482
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXUtVbM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CE0C433C7;
	Fri, 24 Nov 2023 23:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700870193;
	bh=lhicVZ1FcSzOu7NAdTXmzyReS6cHan4eu5lwuov1Sk0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aXUtVbM1xw9B2zX300n60tbpoSh8eWBnqRqAPuxAKn4TM0qX3G7PDkSloK+q+M46G
	 CVv1Z/TeWSmfvyAjsJrRmE1haGVegI+JnFsF/mR5HTGam+Ai4GiWuvrRnkAUs4TU8h
	 /UfR/MoTDF+Gw+m45VmzCnOO0QWLHKaD2s8F4yN9UuwLC3zSUvjcnDNtf1QXAF7XG9
	 Tp111uqc63PLmV0oHUNvDt/W7PSLCSQggrcfKDE6/Lng+3/W6mcdfx/r+izPKWkzTJ
	 ZK2YzA3RXPZyBBW1vcSBX5hh3d4ItmuqywZyzHOPzdeSWUgTtXZnE17ZoNMY5sF0RL
	 d3sitSh+PuwEg==
Date: Fri, 24 Nov 2023 15:56:33 -0800
Subject: [PATCH 3/5] xfs: pull xfs_qm_dqiterate back into scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086928838.2771741.6827852837191818932.stgit@frogsfrogsfrogs>
In-Reply-To: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
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
index a013b87ab8d5e..60ec401e26ffd 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1362,34 +1362,3 @@ xfs_qm_exit(void)
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
 

