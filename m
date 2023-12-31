Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB90C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kPsPaXCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837D0C433C8;
	Sun, 31 Dec 2023 23:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065516;
	bh=7uRS5G9klNxj6jdi7LLbA3iTIf+bYMr+els+NiORrHU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kPsPaXCnjuMIRkEqoFXULfz911TT0lmqAqvE6tIrRymBSEnvVbKcRodxH11rHXOrr
	 I1a2f4gNPN+vEQ7opfaL8wOhpmwgT6JtzSo3yYoV6tywc7YpDjRae8K3bRHPFEmLCL
	 95HaZz91DepF63jlMPYW+PiXnF7AE+Agpi7JJPYNyArnxDt2NvEAi6Mrlp6ctrWcxc
	 aIlKnA0kg9Mg/XAWODPDtemcIagMcGzgNa0t2txVtfzTklXqFgpFc7AtaTIG7DFuUF
	 ynSrcE6FX2/kdRGLYMGCHH8KRullxRGTpOBXG9eYvoUH8MtIOan2g6epD4REYiRaXn
	 oPI370c8jXZpg==
Date: Sun, 31 Dec 2023 15:31:56 -0800
Subject: [PATCH 09/58] xfs: update imeta transaction reservations for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010067.1809361.750161469464973114.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Update the new metadata inode transaction reservations to handle
metadata directories if that feature is enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_trans_resv.c |  101 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 5a1ad959870..a46360e2bdb 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -1106,6 +1106,81 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
+/*
+ * Metadata inode creation needs enough space to create or mkdir a directory,
+ * plus logging the superblock.
+ */
+static unsigned int
+xfs_calc_imeta_create_resv(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret;
+
+	ret = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+	ret += resp->tr_create.tr_logres;
+	return ret;
+}
+
+/* Metadata inode creation needs enough rounds to create or mkdir a directory */
+static int
+xfs_calc_imeta_create_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	return resp->tr_create.tr_logcount;
+}
+
+/*
+ * Metadata inode link needs enough space to add a file plus logging the
+ * superblock.
+ */
+static unsigned int
+xfs_calc_imeta_link_resv(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret;
+
+	ret = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+	ret += resp->tr_link.tr_logres;
+	return ret;
+}
+
+/* Metadata inode linking needs enough rounds to remove a file. */
+static int
+xfs_calc_imeta_link_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	return resp->tr_link.tr_logcount;
+}
+
+/*
+ * Metadata inode unlink needs enough space to remove a file plus logging the
+ * superblock.
+ */
+static unsigned int
+xfs_calc_imeta_unlink_resv(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret;
+
+	ret = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
+	ret += resp->tr_remove.tr_logres;
+	return ret;
+}
+
+/* Metadata inode unlinking needs enough rounds to remove a file. */
+static int
+xfs_calc_imeta_unlink_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	return resp->tr_remove.tr_logcount;
+}
+
 /*
  * Namespace reservations.
  *
@@ -1248,7 +1323,27 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount += logcount_adj;
 
 	/* metadata inode creation and unlink */
-	resp->tr_imeta_create = resp->tr_create;
-	resp->tr_imeta_link = resp->tr_link;
-	resp->tr_imeta_unlink = resp->tr_remove;
+	if (xfs_has_metadir(mp)) {
+		resp->tr_imeta_create.tr_logres =
+				xfs_calc_imeta_create_resv(mp, resp);
+		resp->tr_imeta_create.tr_logcount =
+				xfs_calc_imeta_create_count(mp, resp);
+		resp->tr_imeta_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+		resp->tr_imeta_link.tr_logres =
+				xfs_calc_imeta_link_resv(mp, resp);
+		resp->tr_imeta_link.tr_logcount =
+				xfs_calc_imeta_link_count(mp, resp);
+		resp->tr_imeta_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+		resp->tr_imeta_unlink.tr_logres =
+				xfs_calc_imeta_unlink_resv(mp, resp);
+		resp->tr_imeta_unlink.tr_logcount =
+				xfs_calc_imeta_unlink_count(mp, resp);
+		resp->tr_imeta_unlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	} else {
+		resp->tr_imeta_create = resp->tr_create;
+		resp->tr_imeta_link = resp->tr_link;
+		resp->tr_imeta_unlink = resp->tr_remove;
+	}
 }

