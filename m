Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EFEBA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rHi5Keok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2A3C433C7;
	Sun, 31 Dec 2023 21:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056821;
	bh=EcO4M90eePfMHohtqU20ShjD2OgSWfK5UvmB9f5MFWI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rHi5Keokj30kMH2yJcEt4mhDkicuMa5WYldN/p+xkt4mYzqopLnT8IaQr2rcvRug2
	 zUzRlpIw4rMX8yWiYYg8jbSCDLLbNxWw2VRjHPiOeqBqAehT3urgsKhQ6TZkFyNYWl
	 SigNJffkCa/dTt+5B64Uf9Ne7KnW72z/z9VMzro8h002Lj1FkTllE9Ne39NlX5+Fdy
	 bg8DT0nTzGcCpXJxqZgNUyPT0xWEQ/fYaDMdQKUo0HhfAhuTvsKxLgsKuUkbQMKJBL
	 XG1KGn1CIQ4KwJRNaIJeSwO+87JwruUWqrgs/Dlkj3u17mz+OACMKGK4fDu42X/EoA
	 khK9/De9qtELQ==
Date: Sun, 31 Dec 2023 13:07:00 -0800
Subject: [PATCH 03/32] xfs: create transaction reservations for metadata inode
 operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844912.1760491.2675400978498717477.stgit@frogsfrogsfrogs>
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

Create transaction reservation types and block reservation helpers to
help us calculate transaction requirements.  Right now the reservations
are the same as always; we're just separating the symbols for a future
patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_imeta.c      |    4 ++++
 fs/xfs/libxfs/xfs_imeta.h      |    4 ++++
 fs/xfs/libxfs/xfs_trans_resv.c |    5 +++++
 fs/xfs/libxfs/xfs_trans_resv.h |    3 +++
 fs/xfs/xfs_imeta_utils.c       |    8 +++++---
 5 files changed, 21 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index 717e67b3264cf..497d28abaff10 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -19,6 +19,10 @@
 #include "xfs_inode.h"
 #include "xfs_quota.h"
 #include "xfs_ialloc.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_trans_space.h"
 
 /*
  * Metadata File Management
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index c1833b8b1c977..7b3da865c0931 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -43,4 +43,8 @@ int xfs_imeta_link(struct xfs_imeta_update *upd);
 bool xfs_is_static_meta_ino(struct xfs_mount *mp, xfs_ino_t ino);
 int xfs_imeta_mount(struct xfs_trans *tp);
 
+unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
+unsigned int xfs_imeta_link_space_res(struct xfs_mount *mp);
+unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
+
 #endif /* __XFS_IMETA_H__ */
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index b390d9aa02142..d7c9af3406949 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -1249,4 +1249,9 @@ xfs_trans_resv_calc(
 	resp->tr_itruncate.tr_logcount += logcount_adj;
 	resp->tr_write.tr_logcount += logcount_adj;
 	resp->tr_qm_dqalloc.tr_logcount += logcount_adj;
+
+	/* metadata inode creation and unlink */
+	resp->tr_imeta_create = resp->tr_create;
+	resp->tr_imeta_link = resp->tr_link;
+	resp->tr_imeta_unlink = resp->tr_remove;
 }
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 0554b9d775d26..6b851dfe1ac07 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -48,6 +48,9 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_qm_dqalloc;	/* allocate quota on disk */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
+	struct xfs_trans_res	tr_imeta_create; /* create metadata inode */
+	struct xfs_trans_res	tr_imeta_link;	/* link metadata inode */
+	struct xfs_trans_res	tr_imeta_unlink; /* unlink metadata inode */
 };
 
 /* shorthand way of accessing reservation structure */
diff --git a/fs/xfs/xfs_imeta_utils.c b/fs/xfs/xfs_imeta_utils.c
index 262422daa931f..65a3aea49a5fc 100644
--- a/fs/xfs/xfs_imeta_utils.c
+++ b/fs/xfs/xfs_imeta_utils.c
@@ -78,7 +78,7 @@ xfs_imeta_start_create(
 	 * will account for them.
 	 */
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
 			xfs_create_space_res(mp, MAXNAMELEN), 0, 0, &upd->tp);
 	if (error)
 		goto out_teardown;
@@ -136,7 +136,8 @@ xfs_imeta_start_link(
 {
 	int				error;
 
-	error = xfs_imeta_start_dir_update(mp, path, ip, &M_RES(mp)->tr_link,
+	error = xfs_imeta_start_dir_update(mp, path, ip,
+			&M_RES(mp)->tr_imeta_link,
 			xfs_link_space_res(mp, MAXNAMELEN), upd);
 	if (error)
 		return error;
@@ -158,7 +159,8 @@ xfs_imeta_start_unlink(
 {
 	int				error;
 
-	error = xfs_imeta_start_dir_update(mp, path, ip, &M_RES(mp)->tr_remove,
+	error = xfs_imeta_start_dir_update(mp, path, ip,
+			&M_RES(mp)->tr_imeta_unlink,
 			xfs_remove_space_res(mp, MAXNAMELEN), upd);
 	if (error)
 		return error;

