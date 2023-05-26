Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8E66C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjEZA6j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjEZA6i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:58:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981DE194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:58:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3569E64B7B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F5DC433EF;
        Fri, 26 May 2023 00:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062716;
        bh=KaxOBZ7b11fOC6o+xYCWa7IzWWGcon00gfLw4YqXTGM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=U+8fWfZ2dvrt7IJBw+QpavW8T3Vq0Zztey9nwO0pFRuBx2mYDtIhKgNJz2z17RLjq
         EVOAOimYJZDKOpO5FBlfOoMn+AbZCXFAYZvdrKZ2ObbZrBXvbTnbBLA987OISugMxR
         VNWQ+LabMnHNHOMuvU6FlDhFHdnIIpJhhdkeE9zEgUqBcJMyVGYuNwke+R0kcqv+5n
         /kdNCSP+7lI7c9GTYPovwp9SORD48SJ9l39gfL9Czxh+unBVF+CWqlE34tNCZLmxbm
         JGJKxaKRykhxoRU5rD1m/44Yp4JIgtI4+8GW1L1IJlFFJ/x2UCRF4A/J6xYIieVsPo
         h/vEuaRYVUBjw==
Date:   Thu, 25 May 2023 17:58:36 -0700
Subject: [PATCH 6/7] xfs: repair cannot update the summary counters when
 logging quota flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506059931.3731102.4086175608078026831.stgit@frogsfrogsfrogs>
In-Reply-To: <168506059833.3731102.13017065640910413459.stgit@frogsfrogsfrogs>
References: <168506059833.3731102.13017065640910413459.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While running xfs/804 (quota repairs racing with fsstress), I observed a
filesystem shutdown in the primary sb write verifier:

run fstests xfs/804 at 2022-05-23 18:43:48
XFS (sda4): Mounting V5 Filesystem
XFS (sda4): Ending clean mount
XFS (sda4): Quotacheck needed: Please wait.
XFS (sda4): Quotacheck: Done.
XFS (sda4): EXPERIMENTAL online scrub feature in use. Use at your own risk!
XFS (sda4): SB ifree sanity check failed 0xb5 > 0x80
XFS (sda4): Metadata corruption detected at xfs_sb_write_verify+0x5e/0x100 [xfs], xfs_sb block 0x0
XFS (sda4): Unmount and run xfs_repair

The "SB ifree sanity check failed" message was a debugging printk that I
added to the kernel; observe that 0xb5 - 0x80 = 53, which is less than
one inode chunk.

I traced this to the xfs_log_sb calls from the online quota repair code,
which tries to clear the CHKD flags from the superblock to force a
mount-time quotacheck if the repair fails.  On a V5 filesystem,
xfs_log_sb updates the ondisk sb summary counters with the current
contents of the percpu counters.  This is done without quiescing other
writer threads, which means it could be racing with a thread that has
updated icount and is about to update ifree.

If the other write thread had incremented ifree before updating icount,
the repair thread will write icount > ifree into the logged update.  If
the AIL writes the logged superblock back to disk before anyone else
fixes this siutation, this will lead to a write verifier failure, which
causes a filesystem shutdown.

Resolve this problem by updating the quota flags and calling
xfs_sb_to_disk directly, which does not touch the percpu counters.
While we're at it, we can elide the entire update if the selected qflags
aren't set.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f0d57aceb46d..ed8246beea0f 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -678,6 +678,39 @@ xrep_find_ag_btree_roots(
 }
 
 #ifdef CONFIG_XFS_QUOTA
+/* Update some quota flags in the superblock. */
+static void
+xrep_update_qflags(
+	struct xfs_scrub	*sc,
+	unsigned int		clear_flags)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*bp;
+
+	mutex_lock(&mp->m_quotainfo->qi_quotaofflock);
+	if ((mp->m_qflags & clear_flags) == 0)
+		goto no_update;
+
+	mp->m_qflags &= ~clear_flags;
+	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_qflags &= ~clear_flags;
+	spin_unlock(&mp->m_sb_lock);
+
+	/*
+	 * Update the quota flags in the ondisk superblock without touching
+	 * the summary counters.  We have not quiesced inode chunk allocation,
+	 * so we cannot coordinate with updates to the icount and ifree percpu
+	 * counters.
+	 */
+	bp = xfs_trans_getsb(sc->tp);
+	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
+	xfs_trans_log_buf(sc->tp, bp, 0, sizeof(struct xfs_dsb) - 1);
+
+no_update:
+	mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
+}
+
 /* Force a quotacheck the next time we mount. */
 void
 xrep_force_quotacheck(
@@ -690,13 +723,7 @@ xrep_force_quotacheck(
 	if (!(flag & sc->mp->m_qflags))
 		return;
 
-	mutex_lock(&sc->mp->m_quotainfo->qi_quotaofflock);
-	sc->mp->m_qflags &= ~flag;
-	spin_lock(&sc->mp->m_sb_lock);
-	sc->mp->m_sb.sb_qflags &= ~flag;
-	spin_unlock(&sc->mp->m_sb_lock);
-	xfs_log_sb(sc->tp);
-	mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
+	xrep_update_qflags(sc, flag);
 }
 
 /*

