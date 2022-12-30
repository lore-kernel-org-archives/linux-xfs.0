Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E9FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbiL3WhC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3Wgw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:36:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455FE17E33
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:36:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D50ED61C17
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42645C433EF;
        Fri, 30 Dec 2022 22:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439809;
        bh=eoxUUKAFfVdhXAvSYKiULuqiQl2Tk5dktiDu45Lr7J8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=D9zPDKt376/YvNAhbotqY4t9XVzzhJ5w1mTC9xTZGfeeu2izKeG3LWYnfj27j+F2i
         oAAR/mGF9RquNoGOtYRD81Z9/4XMMdifS04wH1Oqj6mltnjw3GVqUf10d/m/uHuboO
         0cpPhR1Nwy8RCxomAhnu87/8ZYCsHzUsIz2zlDAds7SiqDMVArSRQOJQVCamlwgxqx
         wqRnjh+QDLqC6+TDddqH4hYzHdoAe3uaFXevwm1qcjxZSbIpDK2biCSqPgAPJstBo9
         JfnLrVeToprUpsm480yloakCEGs3KU6Nh9kcqD5IuLo5g9U8UlK1xC+08o3D51y4Gc
         AtwWtgGZv5CKQ==
Subject: [PATCH 1/5] xfs: add a tracepoint to report incorrect extent
 refcounts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:07 -0800
Message-ID: <167243826765.683691.11622957887822223639.stgit@magnolia>
In-Reply-To: <167243826744.683691.2061427880010614570.stgit@magnolia>
References: <167243826744.683691.2061427880010614570.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new tracepoint so that I can see exactly what and where we failed
the refcount check.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/refcount.c |    5 ++++-
 fs/xfs/scrub/trace.h    |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index d9c1b3cea4a5..ffa6eda8b7d4 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -13,6 +13,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
+#include "scrub/trace.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_ag.h"
@@ -300,8 +301,10 @@ xchk_refcountbt_xref_rmap(
 		goto out_free;
 
 	xchk_refcountbt_process_rmap_fragments(&refchk);
-	if (irec->rc_refcount != refchk.seen)
+	if (irec->rc_refcount != refchk.seen) {
+		trace_xchk_refcount_incorrect(sc->sa.pag, irec, refchk.seen);
 		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+	}
 
 out_free:
 	list_for_each_entry_safe(frag, n, &refchk.fragments, list) {
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 93ece6df02e3..403c0e62257e 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -30,6 +30,9 @@ TRACE_DEFINE_ENUM(XFS_BTNUM_FINOi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
 
+TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_SHARED);
+TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_COW);
+
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PROBE);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_SB);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_AGF);
@@ -657,6 +660,38 @@ TRACE_EVENT(xchk_fscounters_within_range,
 		  __entry->old_value)
 )
 
+TRACE_EVENT(xchk_refcount_incorrect,
+	TP_PROTO(struct xfs_perag *pag, const struct xfs_refcount_irec *irec,
+		 xfs_nlink_t seen),
+	TP_ARGS(pag, irec, seen),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_refc_domain, domain)
+		__field(xfs_agblock_t, startblock)
+		__field(xfs_extlen_t, blockcount)
+		__field(xfs_nlink_t, refcount)
+		__field(xfs_nlink_t, seen)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->domain = irec->rc_domain;
+		__entry->startblock = irec->rc_startblock;
+		__entry->blockcount = irec->rc_blockcount;
+		__entry->refcount = irec->rc_refcount;
+		__entry->seen = seen;
+	),
+	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u seen %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __print_symbolic(__entry->domain, XFS_REFC_DOMAIN_STRINGS),
+		  __entry->startblock,
+		  __entry->blockcount,
+		  __entry->refcount,
+		  __entry->seen)
+)
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 

