Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF4B53BE
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052184; cv=none; b=CWdG1+Yzymonk/6pOCiapUF3jwebQxUJl3XQj7C0KPjWT7YsNlPmVALteGq7OvRPMMIGhowKkja+owaD/A33oV8N81iiZmlQAxF+E+UTi8owpELz8TX4Q/U+oeRQVZWqKZvDE36dMwpCUneZZefu6oyDOfX8OjQ9LNXU9Feu6Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052184; c=relaxed/simple;
	bh=mTlsMr36vrI4gtuF3v/blsk4bAnF7h04g4vXPxm+Ty4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QOYvlsTdalJHuqRjlzmZkSiUru0sLPIgecf/BcrVWCQNHJwaQ0cGP7IqE0+nZYpPqFvaXdd46jsALWhnj1/w780MtxSum/0IWekzWbyRnR3rfJNC81mcki2oEEQZGT83AXJmhgWXooGUCQ3DRDVnT72aWHDJvo352wJaKeU7rfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XKbH4YgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XKbH4YgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A92CC4CECE;
	Fri, 13 Dec 2024 01:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052184;
	bh=mTlsMr36vrI4gtuF3v/blsk4bAnF7h04g4vXPxm+Ty4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XKbH4YgVGFUMpZ8hdPqZFmfXiVKhRfnuL7W+WQcOYba/J+AQStf5uYf2/viWyX1fj
	 3YuEcy/M+dHI/8p3HeukR5i3wjdBLnNvdiS4fg7BNEvLFhIN/pFqbdAVImxJ2c7//v
	 z3soHuAvznJMnH3Pyi4UHBfClY4NulYn+IJmyvGTY5hWZXUjNk8dNEImHovpBa6lV+
	 DwZOTIeXfmWmRwfoZ1Y7ve+6YAgzcv4vGZwXZAxGSU163OnI+45LKxkqkT3IUE9qDs
	 gyKUJC4lI2GEe3qD1aWJKvtOEHKoxiIw3EZfW1oU01bDMm7C/6oiyxVoIIhPDqJT8A
	 2xL/DjxWc8A1Q==
Date: Thu, 12 Dec 2024 17:09:43 -0800
Subject: [PATCH 35/37] xfs: clean up device translation in
 xfs_dax_notify_failure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123917.1181370.5005272756259746108.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Move all the dax_dev -> buftarg and range translation code to a separate
function so that xfs_dax_notify_failure will be more straightforward.
Also make a proper header file for the dax holder ops.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c            |    1 
 fs/xfs/xfs_notify_failure.c |  115 ++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_notify_failure.h |   11 ++++
 fs/xfs/xfs_super.h          |    1 
 4 files changed, 91 insertions(+), 37 deletions(-)
 create mode 100644 fs/xfs/xfs_notify_failure.h


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index aa63b8efd78228..6f313fbf766910 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -22,6 +22,7 @@
 #include "xfs_error.h"
 #include "xfs_ag.h"
 #include "xfs_buf_mem.h"
+#include "xfs_notify_failure.h"
 
 struct kmem_cache *xfs_buf_cache;
 
diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index fa50e5308292d3..da07d0efc5a2a0 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -19,11 +19,18 @@
 #include "xfs_rtalloc.h"
 #include "xfs_trans.h"
 #include "xfs_ag.h"
+#include "xfs_notify_failure.h"
 
 #include <linux/mm.h>
 #include <linux/dax.h>
 #include <linux/fs.h>
 
+enum xfs_failed_device {
+	XFS_FAILED_DATADEV,
+	XFS_FAILED_LOGDEV,
+	XFS_FAILED_RTDEV,
+};
+
 struct xfs_failure_info {
 	xfs_agblock_t		startblock;
 	xfs_extlen_t		blockcount;
@@ -256,54 +263,38 @@ xfs_dax_notify_ddev_failure(
 }
 
 static int
-xfs_dax_notify_failure(
+xfs_dax_translate_range(
+	struct xfs_mount	*mp,
 	struct dax_device	*dax_dev,
 	u64			offset,
 	u64			len,
-	int			mf_flags)
+	enum xfs_failed_device	*fdev,
+	xfs_daddr_t		*daddr,
+	uint64_t		*bbcount)
 {
-	struct xfs_mount	*mp = dax_holder(dax_dev);
+	struct xfs_buftarg	*btp;
 	u64			ddev_start;
 	u64			ddev_end;
 
-	if (!(mp->m_super->s_flags & SB_BORN)) {
-		xfs_warn(mp, "filesystem is not ready for notify_failure()!");
-		return -EIO;
-	}
-
 	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_daxdev == dax_dev) {
-		xfs_debug(mp,
-			 "notify_failure() not supported on realtime device!");
-		return -EOPNOTSUPP;
+		*fdev = XFS_FAILED_RTDEV;
+		btp = mp->m_rtdev_targp;
+	} else if (mp->m_logdev_targp != mp->m_ddev_targp &&
+		   mp->m_logdev_targp->bt_daxdev == dax_dev) {
+		*fdev = XFS_FAILED_LOGDEV;
+		btp = mp->m_logdev_targp;
+	} else {
+		*fdev = XFS_FAILED_DATADEV;
+		btp = mp->m_ddev_targp;
 	}
 
-	if (mp->m_logdev_targp && mp->m_logdev_targp->bt_daxdev == dax_dev &&
-	    mp->m_logdev_targp != mp->m_ddev_targp) {
-		/*
-		 * In the pre-remove case the failure notification is attempting
-		 * to trigger a force unmount.  The expectation is that the
-		 * device is still present, but its removal is in progress and
-		 * can not be cancelled, proceed with accessing the log device.
-		 */
-		if (mf_flags & MF_MEM_PRE_REMOVE)
-			return 0;
-		xfs_err(mp, "ondisk log corrupt, shutting down fs!");
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_ONDISK);
-		return -EFSCORRUPTED;
-	}
-
-	if (!xfs_has_rmapbt(mp)) {
-		xfs_debug(mp, "notify_failure() needs rmapbt enabled!");
-		return -EOPNOTSUPP;
-	}
-
-	ddev_start = mp->m_ddev_targp->bt_dax_part_off;
-	ddev_end = ddev_start + bdev_nr_bytes(mp->m_ddev_targp->bt_bdev) - 1;
+	ddev_start = btp->bt_dax_part_off;
+	ddev_end = ddev_start + bdev_nr_bytes(btp->bt_bdev) - 1;
 
 	/* Notify failure on the whole device. */
 	if (offset == 0 && len == U64_MAX) {
 		offset = ddev_start;
-		len = bdev_nr_bytes(mp->m_ddev_targp->bt_bdev);
+		len = bdev_nr_bytes(btp->bt_bdev);
 	}
 
 	/* Ignore the range out of filesystem area */
@@ -322,8 +313,60 @@ xfs_dax_notify_failure(
 	if (offset + len - 1 > ddev_end)
 		len = ddev_end - offset + 1;
 
-	return xfs_dax_notify_ddev_failure(mp, BTOBB(offset), BTOBB(len),
-			mf_flags);
+	*daddr = BTOBB(offset);
+	*bbcount = BTOBB(len);
+	return 0;
+}
+
+static int
+xfs_dax_notify_failure(
+	struct dax_device	*dax_dev,
+	u64			offset,
+	u64			len,
+	int			mf_flags)
+{
+	struct xfs_mount	*mp = dax_holder(dax_dev);
+	enum xfs_failed_device	fdev;
+	xfs_daddr_t		daddr;
+	uint64_t		bbcount;
+	int			error;
+
+	if (!(mp->m_super->s_flags & SB_BORN)) {
+		xfs_warn(mp, "filesystem is not ready for notify_failure()!");
+		return -EIO;
+	}
+
+	error = xfs_dax_translate_range(mp, dax_dev, offset, len, &fdev,
+			&daddr, &bbcount);
+	if (error)
+		return error;
+
+	if (fdev == XFS_FAILED_RTDEV) {
+		xfs_debug(mp,
+			 "notify_failure() not supported on realtime device!");
+		return -EOPNOTSUPP;
+	}
+
+	if (fdev == XFS_FAILED_LOGDEV) {
+		/*
+		 * In the pre-remove case the failure notification is attempting
+		 * to trigger a force unmount.  The expectation is that the
+		 * device is still present, but its removal is in progress and
+		 * can not be cancelled, proceed with accessing the log device.
+		 */
+		if (mf_flags & MF_MEM_PRE_REMOVE)
+			return 0;
+		xfs_err(mp, "ondisk log corrupt, shutting down fs!");
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_ONDISK);
+		return -EFSCORRUPTED;
+	}
+
+	if (!xfs_has_rmapbt(mp)) {
+		xfs_debug(mp, "notify_failure() needs rmapbt enabled!");
+		return -EOPNOTSUPP;
+	}
+
+	return xfs_dax_notify_ddev_failure(mp, daddr, bbcount, mf_flags);
 }
 
 const struct dax_holder_operations xfs_dax_holder_operations = {
diff --git a/fs/xfs/xfs_notify_failure.h b/fs/xfs/xfs_notify_failure.h
new file mode 100644
index 00000000000000..8d08ec29dd2949
--- /dev/null
+++ b/fs/xfs/xfs_notify_failure.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_NOTIFY_FAILURE_H__
+#define __XFS_NOTIFY_FAILURE_H__
+
+extern const struct dax_holder_operations xfs_dax_holder_operations;
+
+#endif /* __XFS_NOTIFY_FAILURE_H__ */
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 302e6e5d6c7e20..c0e85c1e42f27d 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -92,7 +92,6 @@ extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
 
 extern const struct export_operations xfs_export_operations;
 extern const struct quotactl_ops xfs_quotactl_operations;
-extern const struct dax_holder_operations xfs_dax_holder_operations;
 
 extern void xfs_reinit_percpu_counters(struct xfs_mount *mp);
 

