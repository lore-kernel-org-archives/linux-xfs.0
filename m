Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE4EBE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TlhCrLMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC7EC433C8;
	Sun, 31 Dec 2023 21:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059919;
	bh=KX/CVIy1puMLzXKw5gfgMi4XsGp/65vUNSICQmk19GE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TlhCrLMAd9CbTL0k/28V3WiVe+ElWcbqxPz85ai1jQ/eT67lPBVZqx5WgN62fvb6l
	 2ZRuMQHIfclM4CcNKcgbsd1086ucJ/BiQqM32tSqDr8NZUvIM7lhV3YoeZ4x7/w1Lc
	 RH939FzlV0ZfGKLOLtwVemXcs58+DVKE7SXOhDzRw1myCYO0CY2iAsnRVrR/uIxMgn
	 WNdCFJHOqvDSwtqc4jtbOiWfbNTasGGJiUumvoYy0VHhD3sRFq0oSP60w/RhtW0F1Z
	 hMiL53JxJbHnZZ8W6f/DgLRVmsUsJTMee1vTOHF13yT3SPK5obEf5NUiAfWRBWx9nC
	 VotpGpWVn6RNg==
Date: Sun, 31 Dec 2023 13:58:39 -0800
Subject: [PATCH 1/6] xfs: attach dquots to rt metadata files when starting
 quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404853191.1767666.13680815163884956936.stgit@frogsfrogsfrogs>
In-Reply-To: <170404853163.1767666.1660746530012636507.stgit@frogsfrogsfrogs>
References: <170404853163.1767666.1660746530012636507.stgit@frogsfrogsfrogs>
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

Attach dquots to the realtime metadata files when starting up quotas,
since the resources used by them are charged to the root dquot.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c   |    4 +++-
 fs/xfs/xfs_qm.c      |   20 +++++++++++++++++---
 fs/xfs/xfs_qm_bhv.c  |    2 +-
 fs/xfs/xfs_quota.h   |    4 ++--
 fs/xfs/xfs_rtalloc.c |   22 ++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h |    3 +++
 6 files changed, 48 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b20e0e6410512..879945c305da4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1024,7 +1024,9 @@ xfs_mountfs(
 		ASSERT(mp->m_qflags == 0);
 		mp->m_qflags = quotaflags;
 
-		xfs_qm_mount_quotas(mp);
+		error = xfs_qm_mount_quotas(mp);
+		if (error)
+			goto out_rtunmount;
 	}
 
 	/*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index a6b5193190c4c..2771aef361a25 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -30,6 +30,7 @@
 #include "xfs_imeta.h"
 #include "xfs_imeta_utils.h"
 #include "xfs_da_format.h"
+#include "xfs_rtalloc.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -1525,7 +1526,7 @@ xfs_qm_quotacheck(
  * If we fail here, the mount will continue with quota turned off. We don't
  * need to inidicate success or failure at all.
  */
-void
+int
 xfs_qm_mount_quotas(
 	struct xfs_mount	*mp)
 {
@@ -1564,7 +1565,7 @@ xfs_qm_mount_quotas(
 		error = xfs_qm_quotacheck(mp);
 		if (error) {
 			/* Quotacheck failed and disabled quotas. */
-			return;
+			return 0;
 		}
 	}
 	/*
@@ -1605,8 +1606,21 @@ xfs_qm_mount_quotas(
 
 	if (error) {
 		xfs_warn(mp, "Failed to initialize disk quotas.");
-		return;
+		return 0;
 	}
+
+	/*
+	 * Attach dquots to realtime metadata files before we do anything that
+	 * could alter the resource usage of rt metadata (log recovery, normal
+	 * operation, etc).
+	 */
+	error = xfs_rtmount_dqattach(mp);
+	if (error) {
+		xfs_qm_unmount_quotas(mp);
+		return error;
+	}
+
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 271c1021c7335..df569a839d3f9 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -119,7 +119,7 @@ xfs_qm_newmount(
 			 * mounting, and get on with the boring life
 			 * without disk quotas.
 			 */
-			xfs_qm_mount_quotas(mp);
+			return xfs_qm_mount_quotas(mp);
 		} else {
 			/*
 			 * Clear the quota flags, but remember them. This
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 165013f03db9e..b0cdbe1f1f275 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -125,7 +125,7 @@ extern void xfs_qm_dqdetach(struct xfs_inode *);
 extern void xfs_qm_dqrele(struct xfs_dquot *);
 extern void xfs_qm_statvfs(struct xfs_inode *, struct kstatfs *);
 extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
-extern void xfs_qm_mount_quotas(struct xfs_mount *);
+int xfs_qm_mount_quotas(struct xfs_mount *mp);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
@@ -206,7 +206,7 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 #define xfs_qm_dqrele(d)			do { (d) = (d); } while(0)
 #define xfs_qm_statvfs(ip, s)			do { } while(0)
 #define xfs_qm_newmount(mp, a, b)					(0)
-#define xfs_qm_mount_quotas(mp)
+#define xfs_qm_mount_quotas(mp)						(0)
 #define xfs_qm_unmount(mp)
 #define xfs_qm_unmount_quotas(mp)
 #define xfs_inode_near_dquot_enforcement(ip, type)			(false)
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7917eaef911f6..cc83651636ecb 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -32,6 +32,7 @@
 #include "xfs_rtrmap_btree.h"
 #include "xfs_trace.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_quota.h"
 
 /*
  * Realtime metadata files are not quite regular files because userspace can't
@@ -2039,6 +2040,27 @@ xfs_rtmount_inodes(
 	return error;
 }
 
+/*
+ * Attach dquots for realtime metadata files.  Prior to the introduction of the
+ * metadata directory tree, the rtbitmap and rtsummary inodes were counted in
+ * the root dquot icount, so we must dqattach them to maintain correct counts.
+ */
+int
+xfs_rtmount_dqattach(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	if (xfs_has_metadir(mp))
+		return 0;
+
+	error = xfs_qm_dqattach(mp->m_rbmip);
+	if (error)
+		return error;
+
+	return xfs_qm_dqattach(mp->m_rsumip);
+}
+
 void
 xfs_rtunmount_inodes(
 	struct xfs_mount	*mp)
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 8a7b6cfa13cf0..a03796ea90eaf 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -46,6 +46,8 @@ void
 xfs_rtunmount_inodes(
 	struct xfs_mount	*mp);
 
+int xfs_rtmount_dqattach(struct xfs_mount *mp);
+
 /*
  * Get the bitmap and summary inodes into the mount structure
  * at mount time.
@@ -106,6 +108,7 @@ xfs_rtmount_init(
 # define xfs_rt_resv_free(mp)				((void)0)
 # define xfs_rt_resv_init(mp)				(0)
 # define xfs_growfs_check_rtgeom(mp, d, r, rs, rx, rb, rl)	(0)
+# define xfs_rtmount_dqattach(mp)			(0)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __XFS_RTALLOC_H__ */

