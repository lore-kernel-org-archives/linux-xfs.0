Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C775C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbiLaCfH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236278AbiLaCeo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:34:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAADA1CB1F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:34:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A63E61D07
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD0AC433D2;
        Sat, 31 Dec 2022 02:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454082;
        bh=JhU81Rx7BbLmAepDEG6Sau5chDCzGoFUso2n9XV0vmE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=agimEwh2T8/YkPBZWP61FnPoe+KhaYUwUBUESbrPlvZYFjdFIELSERXOWRO0sGa5V
         0pE4M/TKHiS0pgOhK5FijS08QznWBqzkpSzWV19Lv8WnOULhZZni2WWll6TV3lstSO
         7CaEYUAz7VUdroM3ESCrUfLx8cNfDXDDBWgzLFZ3AAfmb9QLB6GkHRZBXDY399eow7
         a3Zr6jmamxXJbwH9yu7qGAQPUaVZISDWVd/b9647l/suYOZXo5fmFlPYaUEF3T6i/W
         IThZJyAo4rdRZSw1YaSVDM43qlIJE7hOd8w/y3qGSHzJ6l7dXMoP+MfGWeldSV1TzV
         E1eDUN3eD/++Q==
Subject: [PATCH 18/45] xfs: repair secondary realtime group superblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:46 -0800
Message-ID: <167243878601.731133.11726860471295155355.stgit@magnolia>
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

Repair secondary realtime group superblocks.  They're not critical for
anything, but some consistency would be a good idea.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtgroup.c |    2 +-
 libxfs/xfs_rtgroup.h |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index ebbd0d13a8a..97643fdcc7c 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -381,7 +381,7 @@ xfs_rtgroup_log_super(
 }
 
 /* Initialize a secondary realtime superblock. */
-static int
+int
 xfs_rtgroup_init_secondary_super(
 	struct xfs_mount	*mp,
 	xfs_rgnumber_t		rgno,
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 1fec49c496d..3c9572677f7 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -210,6 +210,8 @@ void xfs_rtgroup_update_super(struct xfs_buf *rtsb_bp,
 		const struct xfs_buf *sb_bp);
 void xfs_rtgroup_log_super(struct xfs_trans *tp, const struct xfs_buf *sb_bp);
 int xfs_rtgroup_update_secondary_sbs(struct xfs_mount *mp);
+int xfs_rtgroup_init_secondary_super(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		struct xfs_buf **bpp);
 
 /* Lock the rt bitmap inode in exclusive mode */
 #define XFS_RTGLOCK_BITMAP		(1U << 0)
@@ -230,6 +232,7 @@ int xfs_rtgroup_get_geometry(struct xfs_rtgroup *rtg,
 # define xfs_rtgroup_update_super(bp, sb_bp)	((void)0)
 # define xfs_rtgroup_log_super(tp, sb_bp)	((void)0)
 # define xfs_rtgroup_update_secondary_sbs(mp)	(0)
+# define xfs_rtgroup_init_secondary_super(mp, rgno, bpp)	(-EOPNOTSUPP)
 # define xfs_rtgroup_lock(tp, rtg, gf)		((void)0)
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
 # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)

