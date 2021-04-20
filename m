Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A230EC433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 11:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6716E61363
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 11:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhDTLKG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 07:10:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231837AbhDTLKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 07:10:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618916972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZN6T5KKD9+e3yaq5Rl4vIjtjEO+w4Ko+41heBpnNn7k=;
        b=Jmlw4/gflxYyMgo1D0yfmC/TpsDP67frHpETI8Y4yJizgAimTofWyxEN0zDyYKg0JXjYOL
        RbeU7fVjCCbxGcxvC+kQ4HtKiBu7c9G9iDhvHD44+jVlPvKe0D0Sp2YPrAMz6eno9eLKCy
        pQReJqxh8BZAxYnuBX/ayLQJ0cgI/cE=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-ZafSX2AoOfabhujJWF1VBA-1; Tue, 20 Apr 2021 07:09:30 -0400
X-MC-Unique: ZafSX2AoOfabhujJWF1VBA-1
Received: by mail-pj1-f71.google.com with SMTP id o24-20020a17090ad258b029014e8a92bbeeso13847346pjw.5
        for <linux-xfs@vger.kernel.org>; Tue, 20 Apr 2021 04:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZN6T5KKD9+e3yaq5Rl4vIjtjEO+w4Ko+41heBpnNn7k=;
        b=j1sbg+n89O2CrBKch+r/8g4FVSHdX0yp9A1d6Xo6afcK7pfmx2hW2WEcAgXfXCy5y8
         KW+0qmv/b47GHGeEd912LsdG7/6WtUbS+R44M6i0z4rmT14cqJnxld+G3gWC/CQRJZwa
         TsXGaulosr8KS8/JkyzX/qQ64huxUopv9d6UtZ8CNYRsJWxFwshzqz3x01ACi6V4iKvP
         RaZiEEZLsQ8CO4scL0uTO1SAvnlJohXiNgmBDsKgiK5aQiJrmZrWCWZKFwrTUP4YSApT
         2J8jG+7Ckk3ve3akY6cQdHWWS4/F5W6hsEVr/wGr8xzsMZpJ6KwMhM8SI/ezOyvymZhs
         3k1A==
X-Gm-Message-State: AOAM5329AOdYaYvHD6fY6XVrudHbQfHHXdEWGcJ/nkAnM2jTU+Ae5K6Q
        iHDUmTzLn5rNNA/2ypKjhw379yLa4aBzkQjnXZOlY2gwxHyWdjiZEAbSI0oFo+4MUtpdgTA8inb
        /y2dSrFwanGKzaa/1YbXOSPg+eRoBr8ORZKFrDCycGE6kEXT5QBGggLGf6xsNVebD+uFul8VCVQ
        ==
X-Received: by 2002:a17:90a:b398:: with SMTP id e24mr4465459pjr.141.1618916968797;
        Tue, 20 Apr 2021 04:09:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6jEQAYSO2ODTkmhg3m2QsRbZfaizXzdFIJJ/OK4kUL1IbsWa/Z0k0SoquDcTjI6wrdnv1lQ==
X-Received: by 2002:a17:90a:b398:: with SMTP id e24mr4465435pjr.141.1618916968452;
        Tue, 20 Apr 2021 04:09:28 -0700 (PDT)
Received: from xiangao.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fw24sm2247063pjb.21.2021.04.20.04.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 04:09:28 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2 2/2] xfs: turn on lazysbcount unconditionally
Date:   Tue, 20 Apr 2021 19:08:55 +0800
Message-Id: <20210420110855.2961626-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210420110855.2961626-1-hsiangkao@redhat.com>
References: <20210420110855.2961626-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As Dave mentioned [1], "/me is now wondering why we even bother
with !lazy-count anymore.

We've updated the agr btree block accounting unconditionally since
lazy-count was added, and scrub will always report a mismatch in
counts if they exist regardless of lazy-count. So why don't we just
start ignoring the on-disk value and always use lazy-count based
updates? "

Therefore, turn on lazy sb counters if it's still disabled at the
mount time, or at remount_rw if fs was mounted as read-only.
xfs_initialize_perag_data() is reused here since no need to scan
agf/agi once more again.

After this patch, we could get rid of this whole set of subtle
conditional behaviours in the codebase.

[1] https://lore.kernel.org/r/20210417223201.GU63242@dread.disaster.area
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
Enabling lazysbcount is only addressed in this patch, I'll send
out a seperated following patch to cleanup all unused conditions
later.

Also tr_sb is reused here since only agf is modified for each ag,
and before lazysbcount sb feature is enabled (m_update_sb = true),
agf_btreeblks field shouldn't matter for such AGs.

 fs/xfs/libxfs/xfs_format.h |  6 +++
 fs/xfs/libxfs/xfs_sb.c     | 93 +++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_mount.c         |  2 +-
 fs/xfs/xfs_super.c         |  5 ++
 4 files changed, 98 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 76e2461b9e66..9081d7876d66 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -385,6 +385,12 @@ static inline bool xfs_sb_version_haslazysbcount(struct xfs_sb *sbp)
 		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
 }
 
+static inline void xfs_sb_version_addlazysbcount(struct xfs_sb *sbp)
+{
+	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
+	sbp->sb_features2 |= XFS_SB_VERSION2_LAZYSBCOUNTBIT;
+}
+
 static inline bool xfs_sb_version_hasattr2(struct xfs_sb *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 423dada3f64c..6353e0d4cab1 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -18,6 +18,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_log.h"
@@ -841,6 +842,55 @@ xfs_sb_mount_common(
 	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
 }
 
+static int
+xfs_fixup_agf_btreeblks(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agfbp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_perag	*pag = agfbp->b_pag;
+	struct xfs_agf		*agf = agfbp->b_addr;
+	xfs_agblock_t		btreeblks, blocks;
+	int			error;
+
+	cur = xfs_allocbt_init_cursor(mp, tp, agfbp, agno, XFS_BTNUM_BNO);
+	error = xfs_btree_count_blocks(cur, &blocks);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, error);
+	btreeblks = blocks - 1;
+
+	cur = xfs_allocbt_init_cursor(mp, tp, agfbp, agno, XFS_BTNUM_CNT);
+	error = xfs_btree_count_blocks(cur, &blocks);
+	if (error)
+		goto err;
+	xfs_btree_del_cursor(cur, error);
+	btreeblks += blocks - 1;
+
+	/*
+	 * although rmapbt doesn't exist in v4 fses, but it'd be better
+	 * to turn it as a generic helper.
+	 */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		cur = xfs_rmapbt_init_cursor(mp, tp, agfbp, agno);
+		error = xfs_btree_count_blocks(cur, &blocks);
+		if (error)
+			goto err;
+		xfs_btree_del_cursor(cur, error);
+		btreeblks += blocks - 1;
+	}
+
+	agf->agf_btreeblks = cpu_to_be32(btreeblks);
+	pag->pagf_btreeblks = btreeblks;
+	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_BTREEBLKS);
+	return 0;
+err:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
+
 /*
  * xfs_initialize_perag_data
  *
@@ -864,27 +914,51 @@ xfs_initialize_perag_data(
 	uint64_t	btree = 0;
 	uint64_t	fdblocks;
 	int		error = 0;
+	bool		conv = !(mp->m_flags & XFS_MOUNT_RDONLY) &&
+				!xfs_sb_version_haslazysbcount(sbp);
+
+	if (conv)
+		xfs_warn(mp, "enabling lazy-counters...");
 
 	for (index = 0; index < agcount; index++) {
+		struct xfs_trans	*tp = NULL;
+		struct xfs_buf		*agfbp;
+
+		if (conv) {
+			error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb,
+					0, 0, 0, &tp);
+			if (error)
+				return error;
+		}
+
 		/*
-		 * read the agf, then the agi. This gets us
+		 * read the agi, then the agf. This gets us
 		 * all the information we need and populates the
 		 * per-ag structures for us.
 		 */
-		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
-		if (error)
+		error = xfs_ialloc_pagi_init(mp, tp, index);
+		if (error) {
+err_out:
+			if (tp)
+				xfs_trans_cancel(tp);
 			return error;
+		}
 
-		error = xfs_ialloc_pagi_init(mp, NULL, index);
+		error = xfs_alloc_read_agf(mp, tp, index, 0, &agfbp);
 		if (error)
-			return error;
-		pag = xfs_perag_get(mp, index);
+			goto err_out;
+		pag = agfbp->b_pag;
 		ifree += pag->pagi_freecount;
 		ialloc += pag->pagi_count;
 		bfree += pag->pagf_freeblks;
 		bfreelst += pag->pagf_flcount;
+		if (tp) {
+			error = xfs_fixup_agf_btreeblks(mp, tp, agfbp, index);
+			xfs_trans_commit(tp);
+		} else {
+			xfs_buf_relse(agfbp);
+		}
 		btree += pag->pagf_btreeblks;
-		xfs_perag_put(pag);
 	}
 	fdblocks = bfree + bfreelst + btree;
 
@@ -900,6 +974,11 @@ xfs_initialize_perag_data(
 		goto out;
 	}
 
+	if (conv) {
+		xfs_sb_version_addlazysbcount(sbp);
+		mp->m_update_sb = true;
+		xfs_warn(mp, "lazy-counters has been enabled.");
+	}
 	/* Overwrite incore superblock counters with just-read data */
 	spin_lock(&mp->m_sb_lock);
 	sbp->sb_ifree = ifree;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index cb1e2c4702c3..b3b13acd45d6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -626,7 +626,7 @@ xfs_check_summary_counts(
 	 * superblock to be correct and we don't need to do anything here.
 	 * Otherwise, recalculate the summary counters.
 	 */
-	if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
+	if ((xfs_sb_version_haslazysbcount(&mp->m_sb) &&
 	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
 	    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
 		return 0;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a2dab05332ac..16197a890c15 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1678,6 +1678,11 @@ xfs_remount_rw(
 	}
 
 	mp->m_flags &= ~XFS_MOUNT_RDONLY;
+	if (!xfs_sb_version_haslazysbcount(sbp)) {
+		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
+		if (error)
+			return error;
+	}
 
 	/*
 	 * If this is the first remount to writeable state we might have some
-- 
2.27.0

