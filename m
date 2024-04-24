Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FF185C70
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928951; cv=none; b=iYcII389KHQ/yvxz96G0ciPo+4SZaNxo4BVVruu8CgGbM8sPTzjtO2TyzO5FychCdfk98i46toaJohmIpMHY6ZeUDM1HSSLKd8XmCGV7OQ88uco73cIX8SOnRoSk91Ol9lZoLkM8WMs1TwtMvC/iw91VJvMuyXy4Dx1hjSzeSIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928951; c=relaxed/simple;
	bh=mqKDvNnrULEQxl6+rbcPniv5lctzAQVmbsoPhJyfSxg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J0L8x1y49SfAAY6xgqmsEAHsAv5JQRnRLitai5WrqUkq1tYIcB7gVdUoqtTm9kDSNjAr824nZwtSAoVaU9F7ye22lR+eLlVW/4etF2Hy30KsvhYgE4E4M4fnEihxiw59Kg9UypvksV9ygVu4eTX7cEuE/2EbtBxwfvm2QEL8bMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gm6Uc+/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gm6Uc+/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8883C116B1;
	Wed, 24 Apr 2024 03:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928950;
	bh=mqKDvNnrULEQxl6+rbcPniv5lctzAQVmbsoPhJyfSxg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gm6Uc+/xKUKXIPQalcSnw35RDUC4mGo879d1Xj3f9NmOVoMhrTEIczYT24XR6HYrb
	 iCQZbiWepi6d7VvvkRO8EXSOj5kuJaqFphb3gv9Cyrj4I4WRYiU69VYFfHaj+Wjtnf
	 WaEjGpVMumhTpnmaSrjpTa3uoCs0Xy3mvbqXfsrPFHwq12Ac/P2FwBJ41I9AXJymFn
	 eLEdl8/fPYhDFCnBz15crZBJsCsS8l9Ra22DnLoP33T/JWV8c4Vw2N24/Pvmbo+9hH
	 zBwzA92Cd8ZVFs9PYmwO77jWZX5hpwQgE1/y9RbwbKz76nJdwrngf24ywBhjoIXPfa
	 FeSxOA5uUbyqQ==
Date: Tue, 23 Apr 2024 20:22:30 -0700
Subject: [PATCH 01/16] xfs: remove some boilerplate from xfs_attr_set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784667.1906420.13611798915940012182.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
References: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c   |   33 ++++++++++++---------------------
 fs/xfs/scrub/attr_repair.c |    4 ++++
 fs/xfs/xfs_xattr.c         |   24 ++++++++++++++++++++++--
 3 files changed, 38 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8c283e5c2470..df8418671c37 100644
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
index 8b89c112c492..67c0ec0d1dbb 100644
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
index b43f7081b0f4..bbdbe9026658 100644
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
 

