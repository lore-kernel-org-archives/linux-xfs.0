Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878DA1FA4
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831661; cv=none; b=ru530ODvQzVpECmqfbPGr1jzvAIkkNdcFl1RX6ZK17LEgdF3/XvbABexWbJUxrePfOZFDJoPuyzKicFjjc2Et+KReF8veBmKG+ybEyOz9hAfIMknhzFrS4Iog+ZCuXdmsPf6mqu+3yaRxatdvWBWcu6KozGF5e1d9Ih3C4GCSGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831661; c=relaxed/simple;
	bh=P9Vy0PpkuOAn0sNraUSMCVmcyP8nPx5AXuX1lrJkX5E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UfHdl34sqFP8uSxdtN0iUYHXCJSkdrKDzWBntdQh6gXsZ+QbgaRiERi/UwPav9P35HJMhhR3cH/q2tN2Ct4biBwN/9A6JaQ1iRrEbevJdZcmAsuRE0AMBWfj9pAbLZIo2zbSKn2x4EDbcEi/nB+VME9ic0xpTxsh2gUvaxTfpCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TNKLlid3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TNKLlid3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8BBC4CECD;
	Wed,  2 Oct 2024 01:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831661;
	bh=P9Vy0PpkuOAn0sNraUSMCVmcyP8nPx5AXuX1lrJkX5E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TNKLlid3pYyKEBd8AdogV+WIy7c59jup3abPhDLccerE2CKh/5gZEWcxYr6HhbfOE
	 /L0EhnHpvSCrmtzTbw2PzAmtqTfi28H9zbZQDjs4yPUt6oiEAMMLUFyPjrRkkGkWgE
	 OAnqiJKnvATnA5WtspW3S3XDv5v1ifAySUG1oF31qnf9Yta8wMm23QNDKq2lNA9YHf
	 TaXfRZM6qyIT1cSkJqT41XHd5G8RAzZyrVMnxCNLmHsSz1tbkQ92rVO2wNCfEjRslU
	 zVP1undj2NLmsVV8uq0Qai7l3kzQOZWe+TYj8aPt3eU672ESRpVAWVMhWesXGCbVkA
	 q1VsIFRcnKSpQ==
Date: Tue, 01 Oct 2024 18:14:20 -0700
Subject: [PATCH 25/64] xfs: create libxfs helper to link a new inode into a
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102158.4036371.4553530797356384848.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 1fa2e81957cf11620867729fb613b121692ee0d3

Create a new libxfs function to link a newly created inode into a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dir2.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_dir2.h |   12 ++++++++++++
 2 files changed, 65 insertions(+)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 9cf05ec51..e98b28024 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -18,6 +18,9 @@
 #include "xfs_errortag.h"
 #include "xfs_trace.h"
 #include "xfs_health.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_parent.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -755,3 +758,53 @@ xfs_dir2_compname(
 		return xfs_ascii_ci_compname(args, name, len);
 	return xfs_da_compname(args, name, len);
 }
+
+/*
+ * Given a directory @dp, a newly allocated inode @ip, and a @name, link @ip
+ * into @dp under the given @name.  If @ip is a directory, it will be
+ * initialized.  Both inodes must have the ILOCK held and the transaction must
+ * have sufficient blocks reserved.
+ */
+int
+xfs_dir_create_child(
+	struct xfs_trans	*tp,
+	unsigned int		resblks,
+	struct xfs_dir_update	*du)
+{
+	struct xfs_inode	*dp = du->dp;
+	const struct xfs_name	*name = du->name;
+	struct xfs_inode	*ip = du->ip;
+	int			error;
+
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
+	xfs_assert_ilocked(dp, XFS_ILOCK_EXCL);
+
+	error = xfs_dir_createname(tp, dp, name, ip->i_ino, resblks);
+	if (error) {
+		ASSERT(error != -ENOSPC);
+		return error;
+	}
+
+	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		error = xfs_dir_init(tp, ip, dp);
+		if (error)
+			return error;
+
+		xfs_bumplink(tp, dp);
+	}
+
+	/*
+	 * If we have parent pointers, we need to add the attribute containing
+	 * the parent information now.
+	 */
+	if (du->ppargs) {
+		error = xfs_parent_addname(tp, du->ppargs, dp, name, ip);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 6dbe6e9ec..a1ba6fd0a 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -309,4 +309,16 @@ static inline unsigned char xfs_ascii_ci_xfrm(unsigned char c)
 	return c;
 }
 
+struct xfs_parent_args;
+
+struct xfs_dir_update {
+	struct xfs_inode	*dp;
+	const struct xfs_name	*name;
+	struct xfs_inode	*ip;
+	struct xfs_parent_args	*ppargs;
+};
+
+int xfs_dir_create_child(struct xfs_trans *tp, unsigned int resblks,
+		struct xfs_dir_update *du);
+
 #endif	/* __XFS_DIR2_H__ */

