Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8191EC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbiLaC0r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236031AbiLaC0o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:26:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316E612AC8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:26:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DACF0B81E5E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C11DC433D2;
        Sat, 31 Dec 2022 02:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453600;
        bh=FJTozK7q3euO2Pt+iO/+e//lf+iSdYuithguESup7Vw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vBXWCNFJfZ94VzB+QlhsMowMLShqlTVyFmOsnoJjZvjzEXpij2LHtyLSZkwneJVfy
         RJeN1WMhbK8Wd8gGw0sQvaCWy6OHGKKd9Aw0JnrmyVUHZqk6GM0iu4xRkRB7gql7cf
         RNCncBjVKPzSXQss3CLfvs2uV0tZ5NlsfE81eanmLhqNfSEcfaWWEw9bSdHo+/Cmiw
         hDYSQODH3KFiTwfT6cMym7ibILPujA5DunzdtYOMqDSZzZl1bq5ityZTnIVOLkuBZ2
         z3SiyPf3pioXvELlSXTTXiK4/gJhqqmj1fu4U1Ywb/gtI3b2JcIr5XMo+sv8X5Xgj7
         qFGvcKCn88zJQ==
Subject: [PATCH 9/9] misc: use m_blockwsize instead of sb_blocksize for rt
 blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:33 -0800
Message-ID: <167243877348.727982.12662155722060955983.stgit@magnolia>
In-Reply-To: <167243877226.727982.8292582053571487702.stgit@magnolia>
References: <167243877226.727982.8292582053571487702.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In preparation to add block headers to rt bitmap and summary blocks,
convert all the relevant calculations in the userspace tools to use the
per-block word count instead of the raw blocksize.  This is key to
adding this support outside of libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c      |    4 ++--
 repair/phase6.c |    6 ++++--
 repair/rt.c     |    9 +++++----
 3 files changed, 11 insertions(+), 8 deletions(-)


diff --git a/db/check.c b/db/check.c
index 2dcab8e87e6..f39d732d04d 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3624,7 +3624,7 @@ process_rtbitmap(
 	int		t;
 	xfs_rtword_t	*words;
 
-	bitsperblock = mp->m_sb.sb_blocksize * NBBY;
+	bitsperblock = mp->m_blockwsize << XFS_NBWORDLOG;
 	words = malloc(mp->m_blockwsize << XFS_WORDLOG);
 	if (!words) {
 		dbprintf(_("could not allocate rtwords buffer\n"));
@@ -3738,7 +3738,7 @@ process_rtsummary(
 		}
 
 		ondisk = xfs_rsumblock_infoptr(iocur_top->bp, 0);
-		memcpy(sfile, ondisk, mp->m_sb.sb_blocksize);
+		memcpy(sfile, ondisk, mp->m_blockwsize << XFS_WORDLOG);
 		pop_cur();
 		sfile += mp->m_blockwsize;
 	}
diff --git a/repair/phase6.c b/repair/phase6.c
index 3be1da033c5..31d42b9306b 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -828,7 +828,8 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 			return(1);
 		}
 
-		memcpy(xfs_rbmblock_wordptr(bp, 0), bmp, mp->m_sb.sb_blocksize);
+		memcpy(xfs_rbmblock_wordptr(bp, 0), bmp,
+				mp->m_blockwsize << XFS_WORDLOG);
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
@@ -899,7 +900,8 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 			return(1);
 		}
 
-		memcpy(xfs_rsumblock_infoptr(bp, 0), smp, mp->m_sb.sb_blocksize);
+		memcpy(xfs_rsumblock_infoptr(bp, 0), smp,
+				mp->m_blockwsize << XFS_WORDLOG);
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
diff --git a/repair/rt.c b/repair/rt.c
index 9333bce8fbb..56a04c3de6e 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -25,8 +25,9 @@ rtinit(xfs_mount_t *mp)
 		return;
 
 	/*
-	 * realtime init -- blockmap initialization is
-	 * handled by incore_init()
+	 * Allocate buffers for formatting the collected rt free space
+	 * information.  The rtbitmap buffer must be large enough to compare
+	 * against any unused bytes in the last block of the file.
 	 */
 	wordcnt = libxfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
 	btmcompute = calloc(wordcnt, sizeof(union xfs_rtword_ondisk));
@@ -67,7 +68,7 @@ generate_rtinfo(
 
 	ASSERT(mp->m_rbmip == NULL);
 
-	bitsperblock = mp->m_sb.sb_blocksize * NBBY;
+	bitsperblock = mp->m_blockwsize << XFS_NBWORDLOG;
 	extno = start_ext = 0;
 	bmbno = in_extent = start_bmbno = 0;
 
@@ -179,7 +180,7 @@ check_rtfile_contents(
 			break;
 		}
 
-		if (memcmp(bp->b_addr, buf, mp->m_sb.sb_blocksize))
+		if (memcmp(bp->b_addr, buf, mp->m_blockwsize << XFS_WORDLOG))
 			do_warn(_("discrepancy in %s at dblock 0x%llx\n"),
 					filename, (unsigned long long)bno);
 

