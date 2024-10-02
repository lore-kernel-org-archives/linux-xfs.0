Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E492D1103
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831724; cv=none; b=rz29tT+garQ9CUaI/VbAvmShfd2Zj00/XfC1s6SNIuRni4khqOJMagC21+CAGQSOEloPz/ZO3f286pgCIBtb5zKobSa8acEDbl3Ew0CDXgheGkau5RTKrBh396p1ZJnxu8TVDAE8AkRLk/HF2OfpnacpKCP/0KagzyIdyUITpcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831724; c=relaxed/simple;
	bh=Yr/Wy+tb3bFtDgFVX+CKm+zOyT+T9xU9LnIcXmr2lIs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SQld6hUkVg3WCIiABtUzxs/Qp08JH57MSdKfuhM9n2fL4Sheb7mX2aRfX+cO7B0wJSQeD9YCFizg49WjivSnK5EX5bJsD079x9p80MacldxcyQy9cVFNY8zApWTun+KFB66Em/XNjyo5vtPudrLAUFBWsBzZoxgtGKqyc9JCjBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tYQgqv9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tYQgqv9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F92C4CEC6;
	Wed,  2 Oct 2024 01:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831723;
	bh=Yr/Wy+tb3bFtDgFVX+CKm+zOyT+T9xU9LnIcXmr2lIs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tYQgqv9xEhkQ2X5DIcbWElZx6eUItM7dOTuPywUk4lhbENC4lpPMcq6v+nhgXNe5h
	 EJ95J0bJYpTBIMfugF6lCAES7+H8u0SKm4sLxANCsYjCDnhRGkAJByW0hokkl7COsy
	 mUa28plMw4lpYBX4LrFUn1aKq3yme19xAQ8F2khcQVHK28n1NBo93vb5xGHOF7CkyT
	 7VLOpEFki6N1P4sLL0sM/7hdoc66zo36YDUQsWS/hGwveJmkHhoFEMwAnJq9V2+YGU
	 80hTUl+g+UYybKRC63of8MsvLK1Lv9OXiqz+z6tWG82vWSzPunK/ifdYC/e90+Fq2E
	 0QCdkaheUhl7g==
Date: Tue, 01 Oct 2024 18:15:23 -0700
Subject: [PATCH 29/64] xfs: create libxfs helper to exchange two directory
 entries
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102219.4036371.784798163400335516.stgit@frogsfrogsfrogs>
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

Source kernel commit: a55712b35c065eee4ab1195233a5478fb7c93efa

Create a new libxfs function to exchange two directory entries.
The upcoming metadata directory feature will need this to replace a
metadata inode directory entry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dir2.c |  125 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_dir2.h |    3 +
 2 files changed, 128 insertions(+)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index e46f7f489..b47626815 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -954,3 +954,128 @@ xfs_dir_remove_child(
 
 	return 0;
 }
+
+/*
+ * Exchange the entry (@name1, @ip1) in directory @dp1 with the entry (@name2,
+ * @ip2) in directory @dp2, and update '..' @ip1 and @ip2's entries as needed.
+ * @ip1 and @ip2 need not be of the same type.
+ *
+ * All inodes must have the ILOCK held, and both entries must already exist.
+ */
+int
+xfs_dir_exchange_children(
+	struct xfs_trans	*tp,
+	struct xfs_dir_update	*du1,
+	struct xfs_dir_update	*du2,
+	unsigned int		spaceres)
+{
+	struct xfs_inode	*dp1 = du1->dp;
+	const struct xfs_name	*name1 = du1->name;
+	struct xfs_inode	*ip1 = du1->ip;
+	struct xfs_inode	*dp2 = du2->dp;
+	const struct xfs_name	*name2 = du2->name;
+	struct xfs_inode	*ip2 = du2->ip;
+	int			ip1_flags = 0;
+	int			ip2_flags = 0;
+	int			dp2_flags = 0;
+	int			error;
+
+	/* Swap inode number for dirent in first parent */
+	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	if (error)
+		return error;
+
+	/* Swap inode number for dirent in second parent */
+	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	if (error)
+		return error;
+
+	/*
+	 * If we're renaming one or more directories across different parents,
+	 * update the respective ".." entries (and link counts) to match the new
+	 * parents.
+	 */
+	if (dp1 != dp2) {
+		dp2_flags = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+
+		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
+			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
+						dp1->i_ino, spaceres);
+			if (error)
+				return error;
+
+			/* transfer ip2 ".." reference to dp1 */
+			if (!S_ISDIR(VFS_I(ip1)->i_mode)) {
+				error = xfs_droplink(tp, dp2);
+				if (error)
+					return error;
+				xfs_bumplink(tp, dp1);
+			}
+
+			/*
+			 * Although ip1 isn't changed here, userspace needs
+			 * to be warned about the change, so that applications
+			 * relying on it (like backup ones), will properly
+			 * notify the change
+			 */
+			ip1_flags |= XFS_ICHGTIME_CHG;
+			ip2_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+		}
+
+		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
+			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
+						dp2->i_ino, spaceres);
+			if (error)
+				return error;
+
+			/* transfer ip1 ".." reference to dp2 */
+			if (!S_ISDIR(VFS_I(ip2)->i_mode)) {
+				error = xfs_droplink(tp, dp1);
+				if (error)
+					return error;
+				xfs_bumplink(tp, dp2);
+			}
+
+			/*
+			 * Although ip2 isn't changed here, userspace needs
+			 * to be warned about the change, so that applications
+			 * relying on it (like backup ones), will properly
+			 * notify the change
+			 */
+			ip1_flags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+			ip2_flags |= XFS_ICHGTIME_CHG;
+		}
+	}
+
+	if (ip1_flags) {
+		xfs_trans_ichgtime(tp, ip1, ip1_flags);
+		xfs_trans_log_inode(tp, ip1, XFS_ILOG_CORE);
+	}
+	if (ip2_flags) {
+		xfs_trans_ichgtime(tp, ip2, ip2_flags);
+		xfs_trans_log_inode(tp, ip2, XFS_ILOG_CORE);
+	}
+	if (dp2_flags) {
+		xfs_trans_ichgtime(tp, dp2, dp2_flags);
+		xfs_trans_log_inode(tp, dp2, XFS_ILOG_CORE);
+	}
+	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
+
+	/* Schedule parent pointer replacements */
+	if (du1->ppargs) {
+		error = xfs_parent_replacename(tp, du1->ppargs, dp1, name1,
+				dp2, name2, ip1);
+		if (error)
+			return error;
+	}
+
+	if (du2->ppargs) {
+		error = xfs_parent_replacename(tp, du2->ppargs, dp2, name2,
+				dp1, name1, ip2);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index c89916d1c..8b1e192bd 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -325,4 +325,7 @@ int xfs_dir_add_child(struct xfs_trans *tp, unsigned int resblks,
 int xfs_dir_remove_child(struct xfs_trans *tp, unsigned int resblks,
 		struct xfs_dir_update *du);
 
+int xfs_dir_exchange_children(struct xfs_trans *tp, struct xfs_dir_update *du1,
+		struct xfs_dir_update *du2, unsigned int spaceres);
+
 #endif	/* __XFS_DIR2_H__ */

