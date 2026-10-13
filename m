Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAC830ACE6
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871377; cv=none; b=fLnrynKikW12kj+pFAo2jQmZjxZsTBtYPEotbrlyMnPRvcw5rGjH3xpv0Gby0TygREKIIHm3A8W/BlKLhU81xp3Rrmrf8KNbJu/Gs2TZOpC79bEjmegAu4m0nN8RuZz6iwTIcPTTmhd8H6iwB6oDslYjNB+ZaqXAFCDwTSr77Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871377; c=relaxed/simple;
	bh=2wEGYhy65qoTgsp9W3lyR1micJea60tHCkGol+fAn0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7IXZIZ/FqUeDNLzyrhxc/GyPgeHT59v2uSAYrC1dhL8iHmhq+9rLymvEN5x2e2W183IPYpfgxLmu2r7iucKso2iQYsY0cNCBjFtIkOhY9v2RBr1Xn+BNBfawqQRJ0upYPDGsKZhGHnflsxiNVIubHh7A+7xHmdTqwLp4V+Cuwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nn4G8icn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nn4G8icn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3DE1F00893;
	Tue, 13 Oct 2026 06:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871376;
	bh=g/FRzgNpLEppW5C2AJ2LBMY13E8gVdLQll3bdSNi0C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nn4G8icnvBiekcPSv/9K0Tq9K5Fn0J5Hcfmp0LUMdpbjINjUzpytKs7LYmxfhPHpu
	 lvssMEqOaE2Tp9ichMD+kXTbH5sypn5R/HS/bl4MY9MQ0vvFLikUmFBz0+/OhL9+ul
	 5t7H/nlS8V5wpMJsNPNF1dClBIeOg3UHsZbHEmetQqJi6fefr6p6aN8lo01eppyViA
	 dHiStf8lP1gvXciI2nNbB8TZzE8H2ueAAqPqMlZBZD+NI6ung1KCJHsFscSeZ0+WLa
	 QLF+4jhKYyALoYGxuFcNNpoJnZhGHlYUP14rtbZIKHKXnLIXJ8q7wSFcmrQ4I7hCun
	 b1MSqVaVDEoSw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 38/48] xfs: validate logged local fork contents during recovery
Date: Tue, 13 Oct 2026 17:01:28 +1100
Message-ID: <20261013060204.3138690-39-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A local format fork carries a shortform directory, an extended attribute
structure or a symlink target directly in the inode. Recovery copied these into
the inode without inspecting them, so a corrupt shortform structure was replayed
as it stood.

Validate the contents of a logged local fork once the fork has been verified
against the core. The shortform directory and attribute verifiers are reused
directly as they already operate on the on-disk form. The logged symlink target
is validated by a recovery local helper because the shared verifier expects the
null terminated in-core form, which the logged target does not have.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_inode_item_recover.c | 53 +++++++++++++++++++++++++++++----
 1 file changed, 48 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index c5be302bdad7..c987d4cd0285 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -24,6 +24,8 @@
 #include "xfs_ialloc.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_attr_leaf.h"
 #include "xfs_metafile.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rtrmap_btree.h"
@@ -441,6 +443,45 @@ xlog_dinode_verify(
 	return NULL;
 }
 
+/*
+ * Verify a logged shortform symlink target. The logged target is the on-disk
+ * form, which is not null terminated, so this cannot use
+ * xfs_symlink_shortform_verify().
+ */
+static xfs_failaddr_t
+xlog_dinode_verify_symlink(
+	void			*sfp,
+	unsigned int		size)
+{
+	if (size == 0 || size > XFS_SYMLINK_MAXLEN)
+		return __this_address;
+
+	/* The target must not contain a null. */
+	if (memchr(sfp, 0, size))
+		return __this_address;
+
+	return NULL;
+}
+
+/*
+ * Verify the contents of a logged local format data fork. A directory holds a
+ * shortform directory, and a symlink holds its target. A regular file has no
+ * local format data fork.
+ */
+static xfs_failaddr_t
+xlog_dinode_verify_local_dfork(
+	struct xfs_mount		*mp,
+	struct xfs_log_dinode		*ldip,
+	void				*src,
+	unsigned int			size)
+{
+	if (S_ISDIR(ldip->di_mode))
+		return xfs_dir2_sf_verify(mp, src, size);
+	if (S_ISLNK(ldip->di_mode))
+		return xlog_dinode_verify_symlink(src, size);
+	return __this_address;
+}
+
 /*
  * Verify the logged data fork against the core and the fork region that carries
  * it. The core has already been verified, so the mode and fork offset can be
@@ -449,9 +490,9 @@ xlog_dinode_verify(
  * the fork was logged, the field logged for it must match that format, and the
  * region holding it must be the size the format header records. A local or
  * extents fork is copied verbatim into the inode fork, so it must also fit
- * within the space the fork offset leaves for it. A btree fork is logged in the
- * larger expanded form and compressed into the fork on replay, so it does not
- * get the fit check. The contents of the region are not inspected.
+ * within the space the fork offset leaves for it, and a local fork must hold
+ * valid contents. A btree fork is logged in the larger expanded form and
+ * compressed into the fork on replay, so it does not get the fit check.
  */
 static xfs_failaddr_t
 xlog_dinode_verify_dfork(
@@ -490,7 +531,8 @@ xlog_dinode_verify_dfork(
 			return __this_address;
 		if (ilfp->ilf_dsize > fork_size)
 			return __this_address;
-		break;
+		return xlog_dinode_verify_local_dfork(mp, ldip,
+				item->ri_buf[2].iov_base, ilfp->ilf_dsize);
 	case XFS_DINODE_FMT_EXTENTS:
 		if (field != XFS_ILOG_DEXT)
 			return __this_address;
@@ -547,7 +589,8 @@ xlog_dinode_verify_afork(
 			return __this_address;
 		if (ilfp->ilf_asize > fork_size)
 			return __this_address;
-		break;
+		return xfs_attr_shortform_verify(item->ri_buf[region].iov_base,
+				ilfp->ilf_asize);
 	case XFS_DINODE_FMT_EXTENTS:
 		if (field != XFS_ILOG_AEXT)
 			return __this_address;
-- 
2.55.0

