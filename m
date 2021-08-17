Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D898C4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74037604AC
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236583AbhHQXoD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236443AbhHQXoD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:44:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68C1A604AC;
        Tue, 17 Aug 2021 23:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243809;
        bh=U+aGCh4Qwge3XyjP4oRByw7PdoYFyDZdixS9ZoRxBik=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Gcmh1jKlKQ++vlJKrO5U/Jhty6o/juk8i3oZPQ3rWBKzt4of179RWBCB6rYXDhvlc
         AKkgF1T0FE1av4ft6MQ9aOfIzJNhhWfzAfEi+HYxeo5zTL5IOiF1zmbexTb+PMEZwJ
         9b8cIN9hDjfhd9QHuI88bNQBS1xgZHHAmqOoUxb3F8FJ5oJG3T6b0jENhDLSV4Gleg
         ejW71OhI8U8FTDkbv1Pn3AhoQtYnazQjfPC8gt4d2VLdy2bSIUgd+0Q41l5mTNSyc3
         XD2urkf79+mM53zsm8N7Gk6WFw9eJ+h8h6tPDFWENWc/ogI6V3kWClVTD5QhLBYpUx
         FTHNUOAgxheHw==
Subject: [PATCH 14/15] xfs: standardize inode generation formatting in ftrace
 output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:43:29 -0700
Message-ID: <162924380913.761813.13285817199891223797.stgit@magnolia>
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

Always print inode generation in hexadecimal and preceded with the unit
"gen".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 fs/xfs/xfs_trace.h   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 36f86b1497f4..2777d882819d 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -103,7 +103,7 @@ DECLARE_EVENT_CLASS(xchk_class,
 		__entry->flags = sm->sm_flags;
 		__entry->error = error;
 	),
-	TP_printk("dev %d:%d ino 0x%llx type %s agno 0x%x inum 0x%llx gen %u flags 0x%x error %d",
+	TP_printk("dev %d:%d ino 0x%llx type %s agno 0x%x inum 0x%llx gen 0x%x flags 0x%x error %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3b53fd681ce7..984a23775340 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2364,7 +2364,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_icreate_item_class,
 		__entry->gen = be32_to_cpu(in_f->icl_gen);
 	),
 	TP_printk("dev %d:%d agno 0x%x agbno 0x%x count %u isize %u blockcount 0x%x "
-		  "gen %u", MAJOR(__entry->dev), MINOR(__entry->dev),
+		  "gen 0x%x", MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno, __entry->agbno, __entry->count, __entry->isize,
 		  __entry->length, __entry->gen)
 )

