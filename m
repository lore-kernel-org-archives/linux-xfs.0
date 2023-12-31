Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A18BC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sVKNKtwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C31C433C8;
	Sun, 31 Dec 2023 23:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065235;
	bh=IBywPLv0Slg1M5kLYFynJOmLBjG56MkPJ/OK+O7tHf8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sVKNKtwlw/YzP6xX67uoWA/t2FV0QOKPzPjeHZt2KgmwJwudIe8IpPupvYtHXYoYu
	 li8JBd35a6Gb7PD0MmSngDghhn1OHReEhhpPYim+pQrA6eDwrMJFU5DUBK4DC24j5v
	 RaHdaweKKqrtkJx8Co+JPkm5zUODU/+FQB/OWVTcXd9BoJ58Y+35MivLEuU/6ofPXl
	 0RMvXxAvmA1AVDCzui1gqHInzC4O4yBkNCJV8yDTKjhKuU90zJNnyb9N06nZw9WmuN
	 2CWcky1O7hZb7Nv9xrYcIdgKb1xazAEaOu6GCuVrHc/y87GFUcibvBy6i6It2W6ZNg
	 714IyEEP2i6XQ==
Date: Sun, 31 Dec 2023 15:27:14 -0800
Subject: [PATCH 19/28] xfs: create libxfs helper to link a new inode into a
 directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009430.1808635.2626790860497805288.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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

Create a new libxfs function to link a newly created inode into a
directory.  The upcoming metadata directory feature will need this to
create a metadata directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_dir2.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_dir2.h |   12 ++++++++++++
 2 files changed, 60 insertions(+)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index b906f39e0fe..3b7c828fec1 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -18,6 +18,10 @@
 #include "xfs_errortag.h"
 #include "xfs_trace.h"
 #include "xfs_health.h"
+#include "xfs_shared.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_parent.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -781,3 +785,47 @@ xfs_dir2_compname(
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
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_EXCL));
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
+	return xfs_parent_add(tp, du->ppargs, dp, name, ip);
+}
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index ca1949ed4f5..71a8d8e8a8e 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -293,4 +293,16 @@ static inline unsigned char xfs_ascii_ci_xfrm(unsigned char c)
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

