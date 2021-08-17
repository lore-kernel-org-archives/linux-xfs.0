Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6A8C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01D7E6103A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229466AbhHQXnN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236442AbhHQXnN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:43:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB91061008;
        Tue, 17 Aug 2021 23:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243759;
        bh=mx/Se6A94477rdInWD6DgE4geLQq9nhc8hJ0kshcO3k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tTXgfvMnnhK8rPuVg5y7FAvt+hElqoMoDt/pdI5a4AvraOhP0f+371Ds5Yc/X+/K2
         YEEAYIZ/xGRoNLLZ0Cf/HwFgnNgTpbZQUaLWsy2e3Hrr+r8U3YRQZRaXi48BubJbtH
         9HLH/IWEaMJxAuT8cDs1PewuVcq3qlHFoKfPIBAXrXuArCH9Jto0aQM4th88KCMiCO
         p5Xu+8+l2t2gbO1RlK3GSk2S6gsbuW8FM38j6tqHxZ1ZtCR5l2EowQFsn96go+GBLs
         OSJb16ACJ1E8RMZhLJbfeTgYRrXl/LX0sma+krh67ePKsjXZMjNkrmpfGz6rw38+6J
         pT/HHIhB9HbFw==
Subject: [PATCH 05/15] xfs: standardize rmap owner number formatting in ftrace
 output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:42:39 -0700
Message-ID: <162924375953.761813.2443716298245181301.stgit@magnolia>
In-Reply-To: <162924373176.761813.10896002154570305865.stgit@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Always print rmap owner number in hexadecimal and preceded with the unit
"owner".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 fs/xfs/xfs_trace.h   |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 49822589a4ae..486e6f3c0ea2 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -699,7 +699,7 @@ DECLARE_EVENT_CLASS(xrep_rmap_class,
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner %lld offset %llu flags 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx offset %llu flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a780b1752ede..d6365a0ee0ff 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2598,7 +2598,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
 		__entry->l_state = state;
 		__entry->op = op;
 	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner %lld %s offset %llu len %llu state %d",
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s offset %llu len %llu state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->op,
 		  __entry->agno,
@@ -2668,7 +2668,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 		if (unwritten)
 			__entry->flags |= XFS_RMAP_UNWRITTEN;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner %lld offset %llu flags 0x%lx",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx offset %llu flags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2748,7 +2748,7 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner %lld offset %llu flags 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner 0x%llx offset %llu flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -3417,7 +3417,7 @@ DECLARE_EVENT_CLASS(xfs_fsmap_class,
 		__entry->offset = rmap->rm_offset;
 		__entry->flags = rmap->rm_flags;
 	),
-	TP_printk("dev %d:%d keydev %d:%d agno 0x%x bno %llu len %llu owner %lld offset %llu flags 0x%x",
+	TP_printk("dev %d:%d keydev %d:%d agno 0x%x bno %llu len %llu owner 0x%llx offset %llu flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->agno,
@@ -3457,7 +3457,7 @@ DECLARE_EVENT_CLASS(xfs_getfsmap_class,
 		__entry->offset = fsmap->fmr_offset;
 		__entry->flags = fsmap->fmr_flags;
 	),
-	TP_printk("dev %d:%d keydev %d:%d block %llu len %llu owner %lld offset %llu flags 0x%llx",
+	TP_printk("dev %d:%d keydev %d:%d block %llu len %llu owner 0x%llx offset %llu flags 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->block,

