Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBEFC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjEZBke (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbjEZBkd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:40:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9F9195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:40:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD375646CD
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F788C433EF;
        Fri, 26 May 2023 01:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065230;
        bh=QY1LLV2qdHMuRtq4st1jl+WlofukQ/rNZZ9iM2JB3og=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=YDtnxQhbVF8yZdZHCG+s89U/2qCM/NCs3b5reiK5pvegeJ1hjOtZo4dF0KqtmkwMO
         TuCHH3xX4tdSMmTAJ7Cu64tY7A7+B2zBjmNhq1P2faXzdUmXjYilvEYQchaQcFiqWX
         ew/dH4IpvxjbQEhRioaEp8aPwNQ1rUsDawkVGU4OknclmdUBLOJLlJgp1TrSQ8vDDM
         xbz3vNx1ZhQuSz3T10kPBpXVFk+CL8gmL93yJZnlDEROo057xBQPWsMuaqr76MQe54
         1O80dYDPRGX7gVGI8kva0Lw2IJGXBuaXrdR970RL/IL/Si9iogCQSlcZT1db8sNonc
         cKw38m2E+iRbg==
Date:   Thu, 25 May 2023 18:40:29 -0700
Subject: [PATCH 4/4] xfs: relax the AGF lock while we're doing a large fstrim
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506069776.3738451.3420229432906882816.stgit@frogsfrogsfrogs>
In-Reply-To: <168506069715.3738451.3754446921976634655.stgit@frogsfrogsfrogs>
References: <168506069715.3738451.3754446921976634655.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we're doing an fstrim by block number, progress is made in linear
order across the AG by increasing block number.  The fact that our scan
cursor increases monotonically makes it trivial to relax the AGF lock to
prevent other threads from blocking in the kernel for long periods of
time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c |   36 +++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_trace.h   |    1 +
 2 files changed, 32 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 9cddfa005105..ec3f470537fd 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -20,11 +20,17 @@
 #include "xfs_ag.h"
 #include "xfs_health.h"
 
+/*
+ * For trim functions that support it, cycle the metadata locks periodically
+ * to prevent other parts of the filesystem from starving.
+ */
+#define XFS_TRIM_RELAX_INTERVAL	(HZ)
+
 /* Trim the free space in this AG by block number. */
 static inline int
 xfs_trim_ag_bybno(
 	struct xfs_perag	*pag,
-	struct xfs_buf		*agbp,
+	struct xfs_buf		**agbpp,
 	xfs_daddr_t		start,
 	xfs_daddr_t		end,
 	xfs_daddr_t		minlen,
@@ -33,12 +39,13 @@ xfs_trim_ag_bybno(
 	struct xfs_mount	*mp = pag->pag_mount;
 	struct block_device	*bdev = xfs_buftarg_bdev(mp->m_ddev_targp);
 	struct xfs_btree_cur	*cur;
-	struct xfs_agf		*agf = agbp->b_addr;
+	struct xfs_agf		*agf = (*agbpp)->b_addr;
 	xfs_daddr_t		end_daddr;
 	xfs_agnumber_t		agno = pag->pag_agno;
 	xfs_agblock_t		start_agbno;
 	xfs_agblock_t		end_agbno;
 	xfs_extlen_t		minlen_fsb = XFS_BB_TO_FSB(mp, minlen);
+	unsigned long		last_relax = jiffies;
 	int			i;
 	int			error;
 
@@ -49,7 +56,7 @@ xfs_trim_ag_bybno(
 	end = min(end, end_daddr - 1);
 	end_agbno = xfs_daddr_to_agbno(mp, end);
 
-	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_BNO);
+	cur = xfs_allocbt_init_cursor(mp, NULL, *agbpp, pag, XFS_BTNUM_BNO);
 
 	error = xfs_alloc_lookup_le(cur, start_agbno, 0, &i);
 	if (error)
@@ -119,8 +126,27 @@ xfs_trim_ag_bybno(
 			goto out_del_cursor;
 		*blocks_trimmed += flen;
 
+		if (time_after(jiffies, last_relax + XFS_TRIM_RELAX_INTERVAL)) {
+			/*
+			 * Cycle the AGF lock since we know how to pick up
+			 * where we left off.
+			 */
+			trace_xfs_discard_relax(mp, agno, fbno, flen);
+			xfs_btree_del_cursor(cur, error);
+			xfs_buf_relse(*agbpp);
+
+			error = xfs_alloc_read_agf(pag, NULL, 0, agbpp);
+			if (error)
+				return error;
+
+			cur = xfs_allocbt_init_cursor(mp, NULL, *agbpp, pag,
+					XFS_BTNUM_BNO);
+			error = xfs_alloc_lookup_ge(cur, fbno + flen, 0, &i);
+			last_relax = jiffies;
+		} else {
 next_extent:
-		error = xfs_btree_increment(cur, 0, &i);
+			error = xfs_btree_increment(cur, 0, &i);
+		}
 		if (error)
 			goto out_del_cursor;
 
@@ -258,7 +284,7 @@ xfs_trim_ag_extents(
 	    end < XFS_AGB_TO_DADDR(mp, pag->pag_agno,
 				   be32_to_cpu(agf->agf_length)) - 1) {
 		/* Only trimming part of this AG */
-		error = xfs_trim_ag_bybno(pag, agbp, start, end, minlen,
+		error = xfs_trim_ag_bybno(pag, &agbp, start, end, minlen,
 				blocks_trimmed);
 	} else {
 		/* Trim this entire AG */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 26d6e9694c2e..e3a22c3c61a3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2487,6 +2487,7 @@ DEFINE_DISCARD_EVENT(xfs_discard_extent);
 DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
 DEFINE_DISCARD_EVENT(xfs_discard_exclude);
 DEFINE_DISCARD_EVENT(xfs_discard_busy);
+DEFINE_DISCARD_EVENT(xfs_discard_relax);
 
 /* btree cursor events */
 TRACE_DEFINE_ENUM(XFS_BTNUM_BNOi);

