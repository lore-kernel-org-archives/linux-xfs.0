Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD41C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ED14600D4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhIOXIR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232684AbhIOXIQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:08:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E18FE606A5;
        Wed, 15 Sep 2021 23:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747217;
        bh=IrwHM9H1gSfqfl/PhxYIIq1VE280GzsFulhVyuktQbE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Bl5HU2kX21Q3W9HQeLZW9eFq4/MowKD37wgJi2VPTgwftWcHseM3cK5sX/7i09ScK
         aHfccuen5psL2qIqejayhMkLxZSHkqrkU4KM++n3FQ4Dgv0Zc2hF3W4fIOzL5yVE0l
         Bgtu1qNWBv7MF7Vir/e6rIUutAErAXjedfUN3U6UzyY40lU+AawumrLzOszBoDk6Na
         5jlOwiBo9BryTbE0619tPSSJt8oOBeclD1JAzkc8xdpsDsjq3WkvcfRKRFYNWdKtk0
         qPqdsGhrunVlTQ4L8oLHSBsUJDUxQ4NIsdg3bp6mW/v4+s27pVB+MdH7KzWrdjpqmo
         Di6pqDDKVw50g==
Subject: [PATCH 04/61] libxfs: port xfs_set_inode_alloc from the kernel
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:06:56 -0700
Message-ID: <163174721668.350433.1083608596895028766.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

To prepare to perag initialization code move to libxfs, port the
xfs_set_inode_alloc function from the kernel and make
libxfs_initialize_perag use it.  The code isn't 1:1 identical, but
AFAICT it behaves the same way.  In a future kernel release we'll
move the function into xfs_ag.c and update xfsprogs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/init.c |  142 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 89 insertions(+), 53 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index 1ec83791..6223181f 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -482,18 +482,102 @@ rtmount_init(
 	return 0;
 }
 
+/*
+ * Set parameters for inode allocation heuristics, taking into account
+ * filesystem size and inode32/inode64 mount options; i.e. specifically
+ * whether or not XFS_MOUNT_SMALL_INUMS is set.
+ *
+ * Inode allocation patterns are altered only if inode32 is requested
+ * (XFS_MOUNT_SMALL_INUMS), and the filesystem is sufficiently large.
+ * If altered, XFS_MOUNT_32BITINODES is set as well.
+ *
+ * An agcount independent of that in the mount structure is provided
+ * because in the growfs case, mp->m_sb.sb_agcount is not yet updated
+ * to the potentially higher ag count.
+ *
+ * Returns the maximum AG index which may contain inodes.
+ */
+xfs_agnumber_t
+xfs_set_inode_alloc(
+	struct xfs_mount *mp,
+	xfs_agnumber_t	agcount)
+{
+	xfs_agnumber_t	index;
+	xfs_agnumber_t	maxagi = 0;
+	xfs_sb_t	*sbp = &mp->m_sb;
+	xfs_agnumber_t	max_metadata;
+	xfs_agino_t	agino;
+	xfs_ino_t	ino;
+
+	/*
+	 * Calculate how much should be reserved for inodes to meet
+	 * the max inode percentage.  Used only for inode32.
+	 */
+	if (M_IGEO(mp)->maxicount) {
+		uint64_t	icount;
+
+		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
+		do_div(icount, 100);
+		icount += sbp->sb_agblocks - 1;
+		do_div(icount, sbp->sb_agblocks);
+		max_metadata = icount;
+	} else {
+		max_metadata = agcount;
+	}
+
+	/* Get the last possible inode in the filesystem */
+	agino =	XFS_AGB_TO_AGINO(mp, sbp->sb_agblocks - 1);
+	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
+
+	/*
+	 * If user asked for no more than 32-bit inodes, and the fs is
+	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
+	 * the allocator to accommodate the request.
+	 */
+	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32)
+		mp->m_flags |= XFS_MOUNT_32BITINODES;
+	else
+		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
+
+	for (index = 0; index < agcount; index++) {
+		struct xfs_perag	*pag;
+
+		ino = XFS_AGINO_TO_INO(mp, index, agino);
+
+		pag = xfs_perag_get(mp, index);
+
+		if (mp->m_flags & XFS_MOUNT_32BITINODES) {
+			if (ino > XFS_MAXINUMBER_32) {
+				pag->pagi_inodeok = 0;
+				pag->pagf_metadata = 0;
+			} else {
+				pag->pagi_inodeok = 1;
+				maxagi++;
+				if (index < max_metadata)
+					pag->pagf_metadata = 1;
+				else
+					pag->pagf_metadata = 0;
+			}
+		} else {
+			pag->pagi_inodeok = 1;
+			pag->pagf_metadata = 0;
+		}
+
+		xfs_perag_put(pag);
+	}
+
+	return (mp->m_flags & XFS_MOUNT_32BITINODES) ? maxagi : agcount;
+}
+
 static int
 libxfs_initialize_perag(
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agcount,
 	xfs_agnumber_t	*maxagi)
 {
-	xfs_agnumber_t	index, max_metadata;
+	xfs_agnumber_t	index;
 	xfs_agnumber_t	first_initialised = 0;
 	xfs_perag_t	*pag;
-	xfs_agino_t	agino;
-	xfs_ino_t	ino;
-	xfs_sb_t	*sbp = &mp->m_sb;
 	int		error = -ENOMEM;
 
 	/*
@@ -522,55 +606,7 @@ libxfs_initialize_perag(
 		}
 	}
 
-	/*
-	 * If we mount with the inode64 option, or no inode overflows
-	 * the legacy 32-bit address space clear the inode32 option.
-	 */
-	agino = XFS_AGB_TO_AGINO(mp, sbp->sb_agblocks - 1);
-	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
-
-	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32)
-		mp->m_flags |= XFS_MOUNT_32BITINODES;
-	else
-		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
-
-	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
-		/*
-		 * Calculate how much should be reserved for inodes to meet
-		 * the max inode percentage.
-		 */
-		if (M_IGEO(mp)->maxicount) {
-			uint64_t	icount;
-
-			icount = sbp->sb_dblocks * sbp->sb_imax_pct;
-			do_div(icount, 100);
-			icount += sbp->sb_agblocks - 1;
-			do_div(icount, sbp->sb_agblocks);
-			max_metadata = icount;
-		} else {
-			max_metadata = agcount;
-		}
-
-		for (index = 0; index < agcount; index++) {
-			ino = XFS_AGINO_TO_INO(mp, index, agino);
-			if (ino > XFS_MAXINUMBER_32) {
-				index++;
-				break;
-			}
-
-			pag = xfs_perag_get(mp, index);
-			pag->pagi_inodeok = 1;
-			if (index < max_metadata)
-				pag->pagf_metadata = 1;
-			xfs_perag_put(pag);
-		}
-	} else {
-		for (index = 0; index < agcount; index++) {
-			pag = xfs_perag_get(mp, index);
-			pag->pagi_inodeok = 1;
-			xfs_perag_put(pag);
-		}
-	}
+	index = xfs_set_inode_alloc(mp, agcount);
 
 	if (maxagi)
 		*maxagi = index;

