Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6029FC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 20:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiDGUxG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 16:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiDGUwv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 16:52:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D13FB7EB
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 13:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3A1561F70
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 20:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B68C385A4;
        Thu,  7 Apr 2022 20:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649364417;
        bh=726/y9yR5WkHs1542/ugfzv3bTKaczdZ5ylSbMKKVjY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=czMlhmrBMJZew94S4K4YnPlmFIJTmmqgbgnHbk/G3IGeZ3vi3vs4ekudP5AXWxxVW
         ZcUPARA9jcGZuiBoI7BOn3k/qgE6RfX3Rf1E52fpRAhScqlUahFGUdty/giMaut4Hz
         PeU0eMqwbqLf5rBs/GK/TUB6y0wbsKAv85dLBlX3Jvb/FwpsBMbbm88C4aFeoMpbhO
         PXZM5BXPgs1t2rbuC/lgwrXTrXcrbhGyQGKt9wkzO3h+26aNYt5zhJf9mE2Yf8AtEK
         Ny8PjJRmRZr124o51+MEZXXttoPrLcMTQ2F/Yp9l0Tb8YH+4tE/uiOnwAOrN0g8vuB
         6sD/YV5W6FW7A==
Subject: [PATCH 1/2] xfs: recalculate free rt extents after log recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 07 Apr 2022 13:46:56 -0700
Message-ID: <164936441684.457511.12252243723468714698.stgit@magnolia>
In-Reply-To: <164936441107.457511.6646449842358518774.stgit@magnolia>
References: <164936441107.457511.6646449842358518774.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I've been observing periodic corruption reports from xfs_scrub involving
the free rt extent counter (frextents) while running xfs/141.  That test
uses an error injection knob to induce a torn write to the log, and an
arbitrary number of recovery mounts, frextents will count fewer free rt
extents than can be found the rtbitmap.

The root cause of the problem is a combination of the misuse of
sb_frextents in the incore mount to reflect both incore reservations
made by running transactions as well as the actual count of free rt
extents on disk.  The following sequence can reproduce the undercount:

Thread 1			Thread 2
xfs_trans_alloc(rtextents=3)
xfs_mod_frextents(-3)
<blocks>
				xfs_attr_set()
				xfs_bmap_attr_addfork()
				xfs_add_attr2()
				xfs_log_sb()
				xfs_sb_to_disk()
				xfs_trans_commit()
<log flushed to disk>
<log goes down>

Note that thread 1 subtracts 3 from sb_frextents even though it never
commits to using that space.  Thread 2 writes the undercounted value to
the ondisk superblock and logs it to the xattr transaction, which is
then flushed to disk.  At next mount, log recovery will find the logged
superblock and write that back into the filesystem.  At the end of log
recovery, we reread the superblock and install the recovered
undercounted frextents value into the incore superblock.  From that
point on, we've effectively leaked thread 1's transaction reservation.

The correct fix for this is to separate the incore reservation from the
ondisk usage, but that's a matter for the next patch.  Because the
kernel has been logging superblocks with undercounted frextents for a
very long time and we don't demand that sysadmins run xfs_repair after a
crash, fix the undercount by recomputing frextents after log recovery.

Gating this on log recovery is a reasonable balance (I think) between
correcting the problem and slowing down every mount attempt.  Note that
xfs_repair will fix undercounted frextents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 64 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b8c79ee791af..c9ab4f333472 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -19,6 +19,7 @@
 #include "xfs_icache.h"
 #include "xfs_rtalloc.h"
 #include "xfs_sb.h"
+#include "xfs_log_priv.h"
 
 /*
  * Read and return the summary information for a given extent size,
@@ -1284,6 +1285,43 @@ xfs_rtmount_init(
 	return 0;
 }
 
+static inline int
+xfs_rtalloc_count_frextent(
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv)
+{
+	uint64_t			*valp = priv;
+
+	*valp += rec->ar_extcount;
+	return 0;
+}
+
+/* Reinitialize the number of free realtime extents from the realtime bitmap. */
+STATIC int
+xfs_rtalloc_reinit_frextents(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp;
+	uint64_t		val = 0;
+	int			error;
+
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
+	error = xfs_rtalloc_query_all(tp, xfs_rtalloc_count_frextent, &val);
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL);
+	xfs_trans_cancel(tp);
+	if (error)
+		return error;
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_frextents = val;
+	spin_unlock(&mp->m_sb_lock);
+	return 0;
+}
 /*
  * Get the bitmap and summary inodes and the summary cache into the mount
  * structure at mount time.
@@ -1302,13 +1340,35 @@ xfs_rtmount_inodes(
 	ASSERT(mp->m_rbmip != NULL);
 
 	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
-	if (error) {
-		xfs_irele(mp->m_rbmip);
-		return error;
-	}
+	if (error)
+		goto out_rbm;
 	ASSERT(mp->m_rsumip != NULL);
+
+	/*
+	 * Older kernels misused sb_frextents to reflect both incore
+	 * reservations made by running transactions and the actual count of
+	 * free rt extents in the ondisk metadata.  Transactions committed
+	 * during runtime can therefore contain a superblock update that
+	 * undercounts the number of free rt extents tracked in the rt bitmap.
+	 * A clean unmount record will have the correct frextents value since
+	 * there can be no other transactions running at that point.
+	 *
+	 * If we're mounting the rt volume after recovering the log, recompute
+	 * frextents from the rtbitmap file to fix the inconsistency.
+	 */
+	if (xfs_has_realtime(mp) && xlog_recovery_needed(mp->m_log)) {
+		error = xfs_rtalloc_reinit_frextents(mp);
+		if (error)
+			goto out_rsum;
+	}
+
 	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
 	return 0;
+out_rsum:
+	xfs_irele(mp->m_rsumip);
+out_rbm:
+	xfs_irele(mp->m_rbmip);
+	return error;
 }
 
 void

