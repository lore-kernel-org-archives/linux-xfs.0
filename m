Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814F2B675
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HB7UV+jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50696C433C7;
	Sun, 31 Dec 2023 21:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056899;
	bh=3By3HaRin//XcZhpUWFv0Sz3+RPh5/U9Mplr0ucTKCw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HB7UV+jjQzFaJmdQtPWh3uJOAOs36YI06s4ZdXjKyMQkQhA+6PtDS0BRnfs2FY5lb
	 68JsA3hLqBMuyOsy4X08Bc5vnb61bISU18Vcp3JFj++idS09j2XttznAA/oMBO1r+2
	 mJ97dn6mHwTv+d/oPN0pxy/gt9giRGDSWS8VoBHy5HpPfYyO6qXkToz+o+/NhvumK0
	 dPqwdNI5HGjTLn7+1kWLyFkoHzXuE3pvy1jLbvMSmktxFcwXYfc3Uosu8m6V9bcy4W
	 NLK7+Zf7i1yTyG32sghBlldX9acQLVYlqdx4Hc0DD8t+9RqaUizqC3qG/Z35b94llh
	 UKYvp/LX+lSkQ==
Date: Sun, 31 Dec 2023 13:08:18 -0800
Subject: [PATCH 08/32] xfs: update imeta transaction reservations for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844993.1760491.15461254966924912400.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_trans_resv.c |  101 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index d7c9af3406949..a0545daf039c7 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -1109,6 +1109,81 @@ xfs_calc_sb_reservation(
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
@@ -1251,7 +1326,27 @@ xfs_trans_resv_calc(
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

