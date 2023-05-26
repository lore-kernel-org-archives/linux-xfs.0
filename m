Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D987C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjEZBCf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbjEZBCd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:02:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7ED198
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:02:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C80564B7B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2687C433D2;
        Fri, 26 May 2023 01:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062950;
        bh=j2uvyGIhUmjH6uGAnzodw3yxukt6/xyA3OvH+Ol3Hf8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=bhG9adM+H1oLz756KdRIccS7xd4UeIqntIxYjMSx7eQ2xTBVrdxKACQXK3njgB+uN
         bVkqc29DpbPisFQEKYsEPizS8ntt5sM4XjXDt1SyGwZ+Vag7kbFdECSLQ4h+CeVsvL
         i9TqxWaSh18mXrnsHmYlLDNfmAWUvPymtSqcRFKuS4FWyYPwHJOj4Hzoe7kiXydUTe
         WQ+J5dwvDt8HuFlBKA7c+HKITgVIgeM24z+abHEJnxr7bUuJ7w6SfxiUk5zu9016Cr
         0dFB/DsCPwzsUfqJ7ipddfr9cFHIorxV9v8SyOCArM+qQx6OMM2r2LgCn6/dgqSD5T
         s4ttmnwkVQRag==
Date:   Thu, 25 May 2023 18:02:30 -0700
Subject: [PATCH 09/11] xfs: report quota block corruption errors to the health
 system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506060807.3732173.11853712520029396653.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060658.3732173.4915476844741652700.stgit@frogsfrogsfrogs>
References: <168506060658.3732173.4915476844741652700.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 7f071757f278..2133eb86353e 100644
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
@@ -573,6 +599,7 @@ xfs_dquot_from_disk(
 			  "Metadata corruption detected at %pS, quota %u",
 			  __this_address, dqp->q_id);
 		xfs_alert(bp->b_mount, "Unmount and run xfs_repair");
+		xfs_dquot_mark_sick(dqp);
 		return -EFSCORRUPTED;
 	}
 
@@ -1237,6 +1264,8 @@ xfs_qm_dqflush(
 				   &bp, &xfs_dquot_buf_ops);
 	if (error == -EAGAIN)
 		goto out_unlock;
+	if (xfs_metadata_is_sick(error))
+		xfs_dquot_mark_sick(dqp);
 	if (error)
 		goto out_abort;
 
@@ -1245,6 +1274,7 @@ xfs_qm_dqflush(
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
 				dqp->q_id, fa);
 		xfs_buf_relse(bp);
+		xfs_dquot_mark_sick(dqp);
 		error = -EFSCORRUPTED;
 		goto out_abort;
 	}
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 50b054e4751b..aef5345804da 100644
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
index a83f6c34b88f..97610e02b982 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -761,14 +761,18 @@ xfs_qm_qino_alloc(
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

