Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0515ABA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eHub37Cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBFFC433C7;
	Sun, 31 Dec 2023 20:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053520;
	bh=JlWJ0RopNUOZ3G+D7BQmxOXjjzVq4Pq7skl+S2mRa+k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eHub37Cz9RTm4CnBFrbwQy4OqLDe/tIgHJLW6X4NKB2GD9XSaohzBbDdm3L9Bb4Au
	 CQYtjSkizJnMlVicxRhn3LRTS1vMB3Fdvq3q8CHivlNfvXgR2jf+dEr7blyfNWQVTo
	 vXusP2eNOtzpN3Q8nm86wKNVEpTf72KbZ0+u4C5pkhR7EvCC2gZmeVpafgkZsaht82
	 ehpYrsIUcbPbme8Fu1ASbrPU2C31DSmWYelkEJlvcCgA8VGxR1UjVdtFaRydLPDHYv
	 hwU1Gw7WSudiG4Vbc7wSBwDVt/87oC+COArNpE+Nigg22mHjvDWeGXKhIr7R3YbQ/u
	 Qu0yfmyXtczFg==
Date: Sun, 31 Dec 2023 12:12:00 -0800
Subject: [PATCH 09/11] xfs: report quota block corruption errors to the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404828426.1748329.16008537015421616486.stgit@frogsfrogsfrogs>
In-Reply-To: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
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

Whenever we encounter corrupt quota blocks, we should report that to the
health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c  |   30 ++++++++++++++++++++++++++++++
 fs/xfs/xfs_health.c |    1 +
 fs/xfs/xfs_qm.c     |    8 ++++++--
 3 files changed, 37 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a93ad76f23c56..8703495c2fdc6 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -24,6 +24,7 @@
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /*
  * Lock order:
@@ -44,6 +45,29 @@ static struct kmem_cache	*xfs_dquot_cache;
 static struct lock_class_key xfs_dquot_group_class;
 static struct lock_class_key xfs_dquot_project_class;
 
+/* Record observations of quota corruption with the health tracking system. */
+static void
+xfs_dquot_mark_sick(
+	struct xfs_dquot	*dqp)
+{
+	struct xfs_mount	*mp = dqp->q_mount;
+
+	switch (dqp->q_type) {
+	case XFS_DQTYPE_USER:
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_UQUOTA);
+		break;
+	case XFS_DQTYPE_GROUP:
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_GQUOTA);
+		break;
+	case XFS_DQTYPE_PROJ:
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_PQUOTA);
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+}
+
 /*
  * This is called to free all the memory associated with a dquot
  */
@@ -451,6 +475,8 @@ xfs_dquot_disk_read(
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
 			mp->m_quotainfo->qi_dqchunklen, 0, &bp,
 			&xfs_dquot_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_dquot_mark_sick(dqp);
 	if (error) {
 		ASSERT(bp == NULL);
 		return error;
@@ -574,6 +600,7 @@ xfs_dquot_from_disk(
 			  "Metadata corruption detected at %pS, quota %u",
 			  __this_address, dqp->q_id);
 		xfs_alert(bp->b_mount, "Unmount and run xfs_repair");
+		xfs_dquot_mark_sick(dqp);
 		return -EFSCORRUPTED;
 	}
 
@@ -1238,6 +1265,8 @@ xfs_qm_dqflush(
 				   &bp, &xfs_dquot_buf_ops);
 	if (error == -EAGAIN)
 		goto out_unlock;
+	if (xfs_metadata_is_sick(error))
+		xfs_dquot_mark_sick(dqp);
 	if (error)
 		goto out_abort;
 
@@ -1246,6 +1275,7 @@ xfs_qm_dqflush(
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
 				dqp->q_id, fa);
 		xfs_buf_relse(bp);
+		xfs_dquot_mark_sick(dqp);
 		error = -EFSCORRUPTED;
 		goto out_abort;
 	}
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 7c5e132609011..64dffc69a219d 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -17,6 +17,7 @@
 #include "xfs_btree.h"
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
+#include "xfs_quota_defs.h"
 
 /*
  * Warn about metadata corruption that we detected but haven't fixed, and
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3cc1be30a9f74..4f357cb6de748 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -762,14 +762,18 @@ xfs_qm_qino_alloc(
 			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_gquotino;
 			if (XFS_IS_CORRUPT(mp,
-					   mp->m_sb.sb_pquotino != NULLFSINO))
+					   mp->m_sb.sb_pquotino != NULLFSINO)) {
+				xfs_fs_mark_sick(mp, XFS_SICK_FS_PQUOTA);
 				return -EFSCORRUPTED;
+			}
 		} else if ((flags & XFS_QMOPT_GQUOTA) &&
 			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
 			ino = mp->m_sb.sb_pquotino;
 			if (XFS_IS_CORRUPT(mp,
-					   mp->m_sb.sb_gquotino != NULLFSINO))
+					   mp->m_sb.sb_gquotino != NULLFSINO)) {
+				xfs_fs_mark_sick(mp, XFS_SICK_FS_GQUOTA);
 				return -EFSCORRUPTED;
+			}
 		}
 		if (ino != NULLFSINO) {
 			error = xfs_iget(mp, NULL, ino, 0, 0, ipp);

