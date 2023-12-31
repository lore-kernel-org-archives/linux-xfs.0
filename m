Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD45CC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TG9dDmqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973BEC433C8;
	Sun, 31 Dec 2023 23:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065422;
	bh=UfGCM8qkXPM/AIDGwKwjQ3HpcnQ8UIlTRum8v+RUvFo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TG9dDmqgr9MibjiM4RtS0tfqsnHt8s86tGiyxyfPHJn0QOK783CBZyywll4iA69hp
	 02VbpbW6RLK2YTYUwTghd+MLb7dZff2I5sd0aeNDo6wuaE2NnJ86+oRaKV6YSoVLxI
	 oSZw5Us0ruOybfjrxTx9ekCZnx7xQGMhRSeqwOde9dFbMfu2mhWcLoE6pqe6+URE3k
	 13Ui3BECzTOtVCeI++rMpuCQRxcCxODFs+YWtgz+A8SLDI7HTm3A44Oya/zCO9bwPk
	 2TlBCEj1FSAUIwj0FwWl8V4qCS62JqiJdbg7YLOvYiL0dpP1jhYe2Z1oAfzsbec/Wb
	 JZNhGz/Auzk0w==
Date: Sun, 31 Dec 2023 15:30:22 -0800
Subject: [PATCH 03/58] xfs: create transaction reservations for metadata inode
 operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009987.1809361.15843525045056018505.stgit@frogsfrogsfrogs>
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

Create transaction reservation types and block reservation helpers to
help us calculate transaction requirements.  Right now the reservations
are the same as always; we're just separating the symbols for a future
patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/imeta_utils.c     |    8 +++++---
 libxfs/libxfs_api_defs.h |    3 +++
 libxfs/xfs_imeta.c       |    4 ++++
 libxfs/xfs_imeta.h       |    4 ++++
 libxfs/xfs_trans_resv.c  |    5 +++++
 libxfs/xfs_trans_resv.h  |    3 +++
 6 files changed, 24 insertions(+), 3 deletions(-)


diff --git a/libxfs/imeta_utils.c b/libxfs/imeta_utils.c
index 4610c2f49c8..f3165b5eed3 100644
--- a/libxfs/imeta_utils.c
+++ b/libxfs/imeta_utils.c
@@ -70,7 +70,7 @@ xfs_imeta_start_create(
 	if (error)
 		return error;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
 			xfs_create_space_res(mp, MAXNAMELEN), 0, 0, &upd->tp);
 	if (error)
 		goto out_teardown;
@@ -128,7 +128,8 @@ xfs_imeta_start_link(
 {
 	int				error;
 
-	error = xfs_imeta_start_dir_update(mp, path, ip, &M_RES(mp)->tr_link,
+	error = xfs_imeta_start_dir_update(mp, path, ip,
+			&M_RES(mp)->tr_imeta_link,
 			xfs_link_space_res(mp, MAXNAMELEN), upd);
 	if (error)
 		return error;
@@ -150,7 +151,8 @@ xfs_imeta_start_unlink(
 {
 	int				error;
 
-	error = xfs_imeta_start_dir_update(mp, path, ip, &M_RES(mp)->tr_remove,
+	error = xfs_imeta_start_dir_update(mp, path, ip,
+			&M_RES(mp)->tr_imeta_unlink,
 			xfs_remove_space_res(mp, MAXNAMELEN), upd);
 	if (error)
 		return error;
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 9fd53415b47..167617771d8 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -176,13 +176,16 @@
 #define xfs_imeta_cancel_update		libxfs_imeta_cancel_update
 #define xfs_imeta_commit_update		libxfs_imeta_commit_update
 #define xfs_imeta_create		libxfs_imeta_create
+#define xfs_imeta_create_space_res	libxfs_imeta_create_space_res
 #define xfs_imeta_link			libxfs_imeta_link
+#define xfs_imeta_link_space_res	libxfs_imeta_link_space_res
 #define xfs_imeta_lookup		libxfs_imeta_lookup
 #define xfs_imeta_mount			libxfs_imeta_mount
 #define xfs_imeta_start_create		libxfs_imeta_start_create
 #define xfs_imeta_start_link		libxfs_imeta_start_link
 #define xfs_imeta_start_unlink		libxfs_imeta_start_unlink
 #define xfs_imeta_unlink		libxfs_imeta_unlink
+#define xfs_imeta_unlink_space_res	libxfs_imeta_unlink_space_res
 
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
diff --git a/libxfs/xfs_imeta.c b/libxfs/xfs_imeta.c
index b89843926fe..086c250a3c2 100644
--- a/libxfs/xfs_imeta.c
+++ b/libxfs/xfs_imeta.c
@@ -18,6 +18,10 @@
 #include "xfs_trace.h"
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_trans_space.h"
 
 /*
  * Metadata File Management
diff --git a/libxfs/xfs_imeta.h b/libxfs/xfs_imeta.h
index c1833b8b1c9..7b3da865c09 100644
--- a/libxfs/xfs_imeta.h
+++ b/libxfs/xfs_imeta.h
@@ -43,4 +43,8 @@ int xfs_imeta_link(struct xfs_imeta_update *upd);
 bool xfs_is_static_meta_ino(struct xfs_mount *mp, xfs_ino_t ino);
 int xfs_imeta_mount(struct xfs_trans *tp);
 
+unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
+unsigned int xfs_imeta_link_space_res(struct xfs_mount *mp);
+unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
+
 #endif /* __XFS_IMETA_H__ */
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 78e7a575baa..5a1ad959870 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -1246,4 +1246,9 @@ xfs_trans_resv_calc(
 	resp->tr_itruncate.tr_logcount += logcount_adj;
 	resp->tr_write.tr_logcount += logcount_adj;
 	resp->tr_qm_dqalloc.tr_logcount += logcount_adj;
+
+	/* metadata inode creation and unlink */
+	resp->tr_imeta_create = resp->tr_create;
+	resp->tr_imeta_link = resp->tr_link;
+	resp->tr_imeta_unlink = resp->tr_remove;
 }
diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index 0554b9d775d..6b851dfe1ac 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
@@ -48,6 +48,9 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_qm_dqalloc;	/* allocate quota on disk */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
+	struct xfs_trans_res	tr_imeta_create; /* create metadata inode */
+	struct xfs_trans_res	tr_imeta_link;	/* link metadata inode */
+	struct xfs_trans_res	tr_imeta_unlink; /* unlink metadata inode */
 };
 
 /* shorthand way of accessing reservation structure */

