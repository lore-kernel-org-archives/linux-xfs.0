Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592F5A92E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231373; cv=none; b=CCCxbxxF7fgw9VUATIqYbqIOnh6bxeWcHVRIAmboie7VtRHALTFWlf8gOBvTV3JmVkU5Pxa2aBjaiRJAl4kG/3ei02USpNpwsmDqT029KFI/yNOGVsOjK+nrqmHSbKsQk44NFqVa0HPX/rmt1fmmS8Wk1L1ImnjyYM6r2QbQFwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231373; c=relaxed/simple;
	bh=RCuT/CVacWZA21H8Sz/pMpLqkGpDzYTG6p0KpTucSos=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n5aw9PvXH4BiA7UJE14pPkLDZcj4iN6UhaBMJHcTYkVAFIhetdA5pcAX+14AWRVdWjumBlAnmcAWXisZDYTrg6FgwoKWhnfqHRsPM6cV2DNJwbAlmx4ryAJQrIViXEaRCe53sIfDFqjzb1vfrJ+Xib+o9/9izVUhplB5n1CnYnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/PR2H4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/PR2H4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9ADC113CC;
	Tue, 16 Apr 2024 01:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231372;
	bh=RCuT/CVacWZA21H8Sz/pMpLqkGpDzYTG6p0KpTucSos=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U/PR2H4zvHZvqJYyXan8+mMC0QgtvsViHuAJpvMpnu7vx6XfQiniCSafBFmwb+juM
	 13ikhf4/XWXzDqf1rUMToZODS1gN9o+xCWTZ4c8I4VdRmrPDMht7si55nAbPd/Etbw
	 mEUwGA3IC8O4DmvgVK8VrMQXAdw8hAFqfb9k5KLgcMPMZMIFCM5BemfJvGQObpyX7z
	 hiodC2fjjXy/wt9Xv24xMi9agPfzV/kdMSck60L40yTDwKrFLbQLZpvnhdTD2e2FST
	 x6fKliw6MClHcp025T7ueq+ARLdgAjgGVhoEJVzGLLwXg86ItWAh+UF76Q/1EVG7is
	 pC9fdxk3Q5ULQ==
Date: Mon, 15 Apr 2024 18:36:12 -0700
Subject: [PATCH 01/17] xfs: remove some boilerplate from xfs_attr_set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, hch@infradead.org,
 linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Message-ID: <171323029202.253068.8909364981150861497.stgit@frogsfrogsfrogs>
In-Reply-To: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
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

In preparation for online/offline repair wanting to use xfs_attr_set,
move some of the boilerplate out of this function into the callers.
Repair can initialize the da_args completely, and the userspace flag
handling/twisting goes away once we move it to xfs_attr_change.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c   |   33 ++++++++++++---------------------
 fs/xfs/scrub/attr_repair.c |    4 ++++
 fs/xfs/xfs_xattr.c         |   24 ++++++++++++++++++++++--
 3 files changed, 38 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8c283e5c24702..df8418671c379 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -948,6 +948,16 @@ xfs_attr_lookup(
 	return error;
 }
 
+/*
+ * Make a change to the xattr structure.
+ *
+ * The caller must have initialized @args, attached dquots, and must not hold
+ * any ILOCKs.
+ *
+ * Returns -EEXIST for XFS_ATTRUPDATE_CREATE if the name already exists.
+ * Returns -ENOATTR for XFS_ATTRUPDATE_REMOVE if the name does not exist.
+ * Returns 0 on success, or a negative errno if something else went wrong.
+ */
 int
 xfs_attr_set(
 	struct xfs_da_args	*args,
@@ -961,27 +971,7 @@ xfs_attr_set(
 	int			rmt_blks = 0;
 	unsigned int		total;
 
-	if (xfs_is_shutdown(dp->i_mount))
-		return -EIO;
-
-	error = xfs_qm_dqattach(dp);
-	if (error)
-		return error;
-
-	if (!args->owner)
-		args->owner = args->dp->i_ino;
-	args->geo = mp->m_attr_geo;
-	args->whichfork = XFS_ATTR_FORK;
-	xfs_attr_sethash(args);
-
-	/*
-	 * We have no control over the attribute names that userspace passes us
-	 * to remove, so we have to allow the name lookup prior to attribute
-	 * removal to fail as well.  Preserve the logged flag, since we need
-	 * to pass that through to the logging code.
-	 */
-	args->op_flags = XFS_DA_OP_OKNOENT |
-					(args->op_flags & XFS_DA_OP_LOGGED);
+	ASSERT(!args->trans);
 
 	switch (op) {
 	case XFS_ATTRUPDATE_UPSERT:
@@ -1076,6 +1066,7 @@ xfs_attr_set(
 	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	args->trans = NULL;
 	return error;
 
 out_trans_cancel:
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 8b89c112c492f..67c0ec0d1dbba 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -558,6 +558,9 @@ xrep_xattr_insert_rec(
 		.namelen		= key->namelen,
 		.valuelen		= key->valuelen,
 		.owner			= rx->sc->ip->i_ino,
+		.geo			= rx->sc->mp->m_attr_geo,
+		.whichfork		= XFS_ATTR_FORK,
+		.op_flags		= XFS_DA_OP_OKNOENT,
 	};
 	struct xchk_xattr_buf		*ab = rx->sc->buf;
 	int				error;
@@ -602,6 +605,7 @@ xrep_xattr_insert_rec(
 	 * xfs_attr_set creates and commits its own transaction.  If the attr
 	 * already exists, we'll just drop it during the rebuild.
 	 */
+	xfs_attr_sethash(&args);
 	error = xfs_attr_set(&args, XFS_ATTRUPDATE_CREATE);
 	if (error == -EEXIST)
 		error = 0;
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c34d09c998a05..bf0cbcd7567e8 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -17,6 +17,7 @@
 #include "xfs_acl.h"
 #include "xfs_log.h"
 #include "xfs_xattr.h"
+#include "xfs_quota.h"
 
 #include <linux/posix_acl_xattr.h>
 
@@ -70,7 +71,9 @@ xfs_attr_want_log_assist(
 
 /*
  * Set or remove an xattr, having grabbed the appropriate logging resources
- * prior to calling libxfs.
+ * prior to calling libxfs.  Callers of this function are only required to
+ * initialize the inode, attr_filter, name, namelen, value, and valuelen fields
+ * of @args.
  */
 int
 xfs_attr_change(
@@ -80,7 +83,19 @@ xfs_attr_change(
 	struct xfs_mount	*mp = args->dp->i_mount;
 	int			error;
 
-	ASSERT(!(args->op_flags & XFS_DA_OP_LOGGED));
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
+	error = xfs_qm_dqattach(args->dp);
+	if (error)
+		return error;
+
+	/*
+	 * We have no control over the attribute names that userspace passes us
+	 * to remove, so we have to allow the name lookup prior to attribute
+	 * removal to fail as well.
+	 */
+	args->op_flags = XFS_DA_OP_OKNOENT;
 
 	if (xfs_attr_want_log_assist(mp)) {
 		error = xfs_attr_grab_log_assist(mp);
@@ -90,6 +105,11 @@ xfs_attr_change(
 		args->op_flags |= XFS_DA_OP_LOGGED;
 	}
 
+	args->owner = args->dp->i_ino;
+	args->geo = mp->m_attr_geo;
+	args->whichfork = XFS_ATTR_FORK;
+	xfs_attr_sethash(args);
+
 	return xfs_attr_set(args, op);
 }
 

