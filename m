Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC74ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 17:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiJ0ROn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbiJ0ROl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 13:14:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22056355
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 10:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12347623ED
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 17:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7342CC433C1;
        Thu, 27 Oct 2022 17:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890877;
        bh=/77lcqCwotCF+bXHjyBZ5YPXK3jC/meEgl8NhelvZmI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XxFOG8/rYHBr+87jFnPxKKwbO+3cye4Wfx7p+N+hl0ZSsjG8HZ3kLrfpRL5voq0T2
         ecptdO6mD7+0Y6J9QNQErgO5BIuvmOeWMq5+NgoSxypNlArhF/2eagF/YaLv+4EzIW
         up0yuRiJ6CpQN3mWBi1peenLUXElXa1WnRRX5CGZRwYdsE58QFWmd0d3VTgPoGSQJR
         WDkaY6ORSgMV+5BTqx7atwAAdLn0arWChnjnJBpfyUjTm3PAaiITplkXHcl7CkNILS
         f8KLIsIdM9m5DQk8xj16vfb+FFvvBxVhkKq26VdNkXQIjHyicxgpxO33HByvirQAo2
         Gxx8PMd3JQZcA==
Subject: [PATCH 06/12] xfs: report refcount domain in tracepoints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Oct 2022 10:14:37 -0700
Message-ID: <166689087703.3788582.4765638597071821270.stgit@magnolia>
In-Reply-To: <166689084304.3788582.15155501738043912776.stgit@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've broken out the startblock and shared/cow domain in the
incore refcount extent record structure, update the tracepoints to
report the domain.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_types.h |    4 ++++
 fs/xfs/xfs_trace.h        |   48 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index eb9a98338bb9..5ebdda7e1078 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -171,6 +171,10 @@ enum xfs_refc_domain {
 	XFS_REFC_DOMAIN_COW,
 };
 
+#define XFS_REFC_DOMAIN_STRINGS \
+	{ XFS_REFC_DOMAIN_SHARED,	"shared" }, \
+	{ XFS_REFC_DOMAIN_COW,		"cow" }
+
 struct xfs_refcount_irec {
 	xfs_agblock_t	rc_startblock;	/* starting block number */
 	xfs_extlen_t	rc_blockcount;	/* count of free blocks */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cb7c81ba7fa3..372d871bccc5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -799,6 +799,9 @@ TRACE_DEFINE_ENUM(PE_SIZE_PTE);
 TRACE_DEFINE_ENUM(PE_SIZE_PMD);
 TRACE_DEFINE_ENUM(PE_SIZE_PUD);
 
+TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_SHARED);
+TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_COW);
+
 TRACE_EVENT(xfs_filemap_fault,
 	TP_PROTO(struct xfs_inode *ip, enum page_entry_size pe_size,
 		 bool write_fault),
@@ -2925,6 +2928,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_refc_domain, domain)
 		__field(xfs_agblock_t, startblock)
 		__field(xfs_extlen_t, blockcount)
 		__field(xfs_nlink_t, refcount)
@@ -2932,13 +2936,15 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
+		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u",
+	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
+		  __print_symbolic(__entry->domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->startblock,
 		  __entry->blockcount,
 		  __entry->refcount)
@@ -2958,6 +2964,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_refc_domain, domain)
 		__field(xfs_agblock_t, startblock)
 		__field(xfs_extlen_t, blockcount)
 		__field(xfs_nlink_t, refcount)
@@ -2966,14 +2973,16 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
+		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 		__entry->agbno = agbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
+	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
+		  __print_symbolic(__entry->domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->startblock,
 		  __entry->blockcount,
 		  __entry->refcount,
@@ -2994,9 +3003,11 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_refc_domain, i1_domain)
 		__field(xfs_agblock_t, i1_startblock)
 		__field(xfs_extlen_t, i1_blockcount)
 		__field(xfs_nlink_t, i1_refcount)
+		__field(enum xfs_refc_domain, i2_domain)
 		__field(xfs_agblock_t, i2_startblock)
 		__field(xfs_extlen_t, i2_blockcount)
 		__field(xfs_nlink_t, i2_refcount)
@@ -3004,20 +3015,24 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
+		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
 		__entry->i1_refcount = i1->rc_refcount;
+		__entry->i2_domain = i2->rc_domain;
 		__entry->i2_startblock = i2->rc_startblock;
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "agbno 0x%x fsbcount 0x%x refcount %u",
+	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
+		  __print_symbolic(__entry->i1_domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->i1_startblock,
 		  __entry->i1_blockcount,
 		  __entry->i1_refcount,
+		  __print_symbolic(__entry->i2_domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->i2_startblock,
 		  __entry->i2_blockcount,
 		  __entry->i2_refcount)
@@ -3038,9 +3053,11 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_refc_domain, i1_domain)
 		__field(xfs_agblock_t, i1_startblock)
 		__field(xfs_extlen_t, i1_blockcount)
 		__field(xfs_nlink_t, i1_refcount)
+		__field(enum xfs_refc_domain, i2_domain)
 		__field(xfs_agblock_t, i2_startblock)
 		__field(xfs_extlen_t, i2_blockcount)
 		__field(xfs_nlink_t, i2_refcount)
@@ -3049,21 +3066,25 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
+		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
 		__entry->i1_refcount = i1->rc_refcount;
+		__entry->i2_domain = i2->rc_domain;
 		__entry->i2_startblock = i2->rc_startblock;
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
 		__entry->agbno = agbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
+	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
+		  __print_symbolic(__entry->i1_domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->i1_startblock,
 		  __entry->i1_blockcount,
 		  __entry->i1_refcount,
+		  __print_symbolic(__entry->i2_domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->i2_startblock,
 		  __entry->i2_blockcount,
 		  __entry->i2_refcount,
@@ -3086,12 +3107,15 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_refc_domain, i1_domain)
 		__field(xfs_agblock_t, i1_startblock)
 		__field(xfs_extlen_t, i1_blockcount)
 		__field(xfs_nlink_t, i1_refcount)
+		__field(enum xfs_refc_domain, i2_domain)
 		__field(xfs_agblock_t, i2_startblock)
 		__field(xfs_extlen_t, i2_blockcount)
 		__field(xfs_nlink_t, i2_refcount)
+		__field(enum xfs_refc_domain, i3_domain)
 		__field(xfs_agblock_t, i3_startblock)
 		__field(xfs_extlen_t, i3_blockcount)
 		__field(xfs_nlink_t, i3_refcount)
@@ -3099,27 +3123,33 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
+		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
 		__entry->i1_refcount = i1->rc_refcount;
+		__entry->i2_domain = i2->rc_domain;
 		__entry->i2_startblock = i2->rc_startblock;
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
+		__entry->i3_domain = i3->rc_domain;
 		__entry->i3_startblock = i3->rc_startblock;
 		__entry->i3_blockcount = i3->rc_blockcount;
 		__entry->i3_refcount = i3->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "agbno 0x%x fsbcount 0x%x refcount %u",
+	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
+		  __print_symbolic(__entry->i1_domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->i1_startblock,
 		  __entry->i1_blockcount,
 		  __entry->i1_refcount,
+		  __print_symbolic(__entry->i2_domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->i2_startblock,
 		  __entry->i2_blockcount,
 		  __entry->i2_refcount,
+		  __print_symbolic(__entry->i3_domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->i3_startblock,
 		  __entry->i3_blockcount,
 		  __entry->i3_refcount)

