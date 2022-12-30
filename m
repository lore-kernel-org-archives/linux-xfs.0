Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22091C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbiLaCcJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236239AbiLaCcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:32:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221491CB20
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:32:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A424161D07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CC1C433D2;
        Sat, 31 Dec 2022 02:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453927;
        bh=HuSGGzrdCiZTtDCZ1Edkzx9ZDoKpG/B9Pxdx4dlnQYE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qX40RS1dQFD9dsqtXTPiWg1Eaf1DddOBFQpH+cUW/v97X2dzIdvTUvbLSgi7JqzCI
         FEoDjIbD6LlbzT/CKlJuWe8CxLy9z7UkC/KgzLPpHBqQK0HEDZZJlhn84ClZ/jFXft
         UhLNVBPG8bGk8oDsWe3Ea9g227it5gggbFFftbMtBBGSeJEGkFBNfOVnfhMP7lW34B
         4DefbCQyVv8vqEjy8jzUsoYHbQOzzYH7UzSmlmuCanJx13lzcKHTabiGgID976Xfvx
         6GMbptAKq80rZoKmt73uF3fZiryr5aRlH1LIIWV/7bxBhIOIbKdWBamnZy3OfLT0On
         Fvcza1qOSDE+g==
Subject: [PATCH 08/45] xfs: add frextents to the lazysbcounters when rtgroups
 enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:44 -0800
Message-ID: <167243878471.731133.13678474783101264607.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make the free rt extent count a part of the lazy sb counters when the
realtime groups feature is enabled.  This is possible because the patch
to recompute frextents from the rtbitmap during log recovery predates
the code adding rtgroup support, hence we know that the value will
always be correct during runtime.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h |    1 +
 libxfs/xfs_sb.c     |    5 +++++
 2 files changed, 6 insertions(+)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 5987650c639..ed19b15fcb5 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -28,6 +28,7 @@ typedef struct xfs_mount {
 #define m_icount	m_sb.sb_icount
 #define m_ifree		m_sb.sb_ifree
 #define m_fdblocks	m_sb.sb_fdblocks
+#define m_frextents	m_sb.sb_frextents
 	spinlock_t		m_sb_lock;
 
 	/*
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 0ba9143e7c5..1bcffb24761 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1087,6 +1087,9 @@ xfs_log_sb(
 	 * sb counters, despite having a percpu counter. It is always kept
 	 * consistent with the ondisk rtbitmap by xfs_trans_apply_sb_deltas()
 	 * and hence we don't need have to update it here.
+	 *
+	 * sb_frextents was added to the lazy sb counters when the rt groups
+	 * feature was introduced.
 	 */
 	if (xfs_has_lazysbcount(mp)) {
 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
@@ -1095,6 +1098,8 @@ xfs_log_sb(
 				mp->m_sb.sb_icount);
 		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
 	}
+	if (xfs_has_rtgroups(mp))
+		mp->m_sb.sb_frextents = percpu_counter_sum(&mp->m_frextents);
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);

