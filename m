Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A32C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbiLaBL2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbiLaBL1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:11:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD3C178B4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:11:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AB1EECE1923
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48A7C433EF;
        Sat, 31 Dec 2022 01:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449083;
        bh=emFVkDJAKccSnagRD096FwMLu6oVMawCwqawXtpRAAQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gLPdLrcPo5WI8mWvK4qG8Gx2VCQGCleTcR1qnRuPyVoeW2izykF4QMDFZtHXYH2FJ
         ROMyQClg+LOf1Whls1eOL1NCfA0gJrdBmY/UgzjAtYJv71sAhsJHcOsXxxsqihM2Ct
         UwjVbDjjwSbmjO0xf8boVZhGEqEEwtXYlF0GdGz2z1ru51+oC01jv6Vp1rCzfl+Osq
         +iq/u/4TnfQraUZD+7sN0HD9a1iCP4tKFlkzVXToUd43XT+q06ej11sucY0AHTyv7w
         y71s/G0rhHvWHxUFM/FiWdTHn2Drc1+C5R5xFQ33zhPg57aB0co1z3O1zf7JYa/LKg
         N5QOvs3sczBTw==
Subject: [PATCH 04/23] xfs: refactor the v4 group/project inode pointer switch
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:25 -0800
Message-ID: <167243864513.708110.10381132998508707928.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refactor the group and project quota inode pointer switcheroo that
happens only on v4 filesystems into a separate function prior to
enhancing the xfs_qm_qino_alloc function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |   90 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 54 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index da6c6f0e1ced..4c629a3bc69e 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -731,6 +731,57 @@ xfs_qm_destroy_quotainfo(
 	mp->m_quotainfo = NULL;
 }
 
+/*
+ * Switch the group and project quota in-core inode pointers if needed.
+ *
+ * On v4 superblocks that don't have separate pquotino, we share an inode
+ * between gquota and pquota. If the on-disk superblock has GQUOTA and the
+ * filesystem is now mounted with PQUOTA, just use sb_gquotino for sb_pquotino
+ * and vice-versa.
+ */
+STATIC int
+xfs_qm_qino_switch(
+	struct xfs_mount	*mp,
+	struct xfs_inode	**ipp,
+	unsigned int		flags,
+	bool			*need_alloc)
+{
+	xfs_ino_t		ino = NULLFSINO;
+	int			error;
+
+	if (xfs_has_pquotino(mp) ||
+	    !(flags & (XFS_QMOPT_PQUOTA | XFS_QMOPT_GQUOTA)))
+		return 0;
+
+	if ((flags & XFS_QMOPT_PQUOTA) &&
+	    (mp->m_sb.sb_gquotino != NULLFSINO)) {
+		ino = mp->m_sb.sb_gquotino;
+		if (XFS_IS_CORRUPT(mp, mp->m_sb.sb_pquotino != NULLFSINO)) {
+			xfs_fs_mark_sick(mp, XFS_SICK_FS_PQUOTA);
+			return -EFSCORRUPTED;
+		}
+	} else if ((flags & XFS_QMOPT_GQUOTA) &&
+		   (mp->m_sb.sb_pquotino != NULLFSINO)) {
+		ino = mp->m_sb.sb_pquotino;
+		if (XFS_IS_CORRUPT(mp, mp->m_sb.sb_gquotino != NULLFSINO)) {
+			xfs_fs_mark_sick(mp, XFS_SICK_FS_GQUOTA);
+			return -EFSCORRUPTED;
+		}
+	}
+
+	if (ino == NULLFSINO)
+		return 0;
+
+	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
+	if (error)
+		return error;
+
+	mp->m_sb.sb_gquotino = NULLFSINO;
+	mp->m_sb.sb_pquotino = NULLFSINO;
+	*need_alloc = false;
+	return 0;
+}
+
 /*
  * Create an inode and return with a reference already taken, but unlocked
  * This is how we create quota inodes
@@ -746,43 +797,10 @@ xfs_qm_qino_alloc(
 	bool			need_alloc = true;
 
 	*ipp = NULL;
-	/*
-	 * With superblock that doesn't have separate pquotino, we
-	 * share an inode between gquota and pquota. If the on-disk
-	 * superblock has GQUOTA and the filesystem is now mounted
-	 * with PQUOTA, just use sb_gquotino for sb_pquotino and
-	 * vice-versa.
-	 */
-	if (!xfs_has_pquotino(mp) &&
-			(flags & (XFS_QMOPT_PQUOTA|XFS_QMOPT_GQUOTA))) {
-		xfs_ino_t ino = NULLFSINO;
 
-		if ((flags & XFS_QMOPT_PQUOTA) &&
-			     (mp->m_sb.sb_gquotino != NULLFSINO)) {
-			ino = mp->m_sb.sb_gquotino;
-			if (XFS_IS_CORRUPT(mp,
-					   mp->m_sb.sb_pquotino != NULLFSINO)) {
-				xfs_fs_mark_sick(mp, XFS_SICK_FS_PQUOTA);
-				return -EFSCORRUPTED;
-			}
-		} else if ((flags & XFS_QMOPT_GQUOTA) &&
-			     (mp->m_sb.sb_pquotino != NULLFSINO)) {
-			ino = mp->m_sb.sb_pquotino;
-			if (XFS_IS_CORRUPT(mp,
-					   mp->m_sb.sb_gquotino != NULLFSINO)) {
-				xfs_fs_mark_sick(mp, XFS_SICK_FS_GQUOTA);
-				return -EFSCORRUPTED;
-			}
-		}
-		if (ino != NULLFSINO) {
-			error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
-			if (error)
-				return error;
-			mp->m_sb.sb_gquotino = NULLFSINO;
-			mp->m_sb.sb_pquotino = NULLFSINO;
-			need_alloc = false;
-		}
-	}
+	error = xfs_qm_qino_switch(mp, ipp, flags, &need_alloc);
+	if (error)
+		return error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
 			need_alloc ? XFS_QM_QINOCREATE_SPACE_RES(mp) : 0,

