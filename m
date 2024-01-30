Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69308376F7
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591495; cv=none; b=srJq+bBwpFiqMrKN8Rc2W9+HhNYSWunbwXSwfoxMT0Lt+FC7PJdq3xOZJR/iw3tilXjcutSnjIbQYYm8dN3W4kZCdyZWcIN8uoyMWzMZIAqQl2STqQe6/C3yH3kT2upyVC4vOdJwzlAbTAEvWEb4nxPLnQUNZXUTtLqq3zhMArs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591495; c=relaxed/simple;
	bh=wkaW13CmhOR56Ds30joItlPuMSvbmxyUoQZg9cjfXW8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S8Ox1qjUyeHlGWtGXqdApcyJe5LP4IPQK6fq//e7rT3QxCo1TiiTUIOCABpacxLH/JQnLtpD/t+bRRTQ5m/Dp2qIdMuDHwgO1YoEP+Cvs8QU9rXuLZJxjgFjjRUyKNKaDSUe0VYWgAm8c2XDmc49mOnPK4U1PDwa8yVlLJthr3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZXeezwQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXeezwQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA244C433C7;
	Tue, 30 Jan 2024 05:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591494;
	bh=wkaW13CmhOR56Ds30joItlPuMSvbmxyUoQZg9cjfXW8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZXeezwQUHFOU5HQNsZ5nAEteqGV5EEDelDRWf1OqxqaIsveNHRJa0d6pkkg3n9qHi
	 vPznaxgSOO8vBoT8SeHYsyCSJjW2gnQvKSzxAIVV8vuAftXsgFy+Q7o7LaLD3csTQq
	 5DoeFZvSEokvpPcnnxxEl3240vP8nlGpKCoumb9T1672sUaGXWporrpM1/eTaebTYx
	 7ts9AVXf0oMckID+LxXLrYrEuou3yyRCMMRZ8Fbh/vLIWj2aATGMruzR0jD0C1b92S
	 MFzmrIEDY5ZkjVQ796HExTzDyqIgXcOkE7k6TbXyXvvjeHmD2f0hex/BoW0jJJPXPD
	 kq9affSwmPKgA==
Date: Mon, 29 Jan 2024 21:11:34 -0800
Subject: [PATCH 09/11] xfs: report quota block corruption errors to the health
 system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063875.3353909.6312604731788772368.stgit@frogsfrogsfrogs>
In-Reply-To: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
References: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c  |   30 ++++++++++++++++++++++++++++++
 fs/xfs/xfs_health.c |    1 +
 fs/xfs/xfs_qm.c     |    8 ++++++--
 3 files changed, 37 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index b4f20d9c8f98e..ed3a6be4886d2 100644
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
index a94ba8e67a647..a0f986a1edd1c 100644
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

