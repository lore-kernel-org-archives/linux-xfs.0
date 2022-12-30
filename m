Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23CDC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiL3XfJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbiL3XfI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:35:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0230412D20
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:35:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9273E61C2C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC851C433D2;
        Fri, 30 Dec 2022 23:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443307;
        bh=tCy+YLxxVwFngE6PPnqXog5fQCfbXptNHG/Go0jMZqY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uQCL6bmi7VMH7tMQEz9Am/9LCCwWkKuU+tWvCbU3SrWd0XJjGfdCIcLKlLN5gXvtU
         GvsMDd88aENed1hPqZdZSu4lh+0mtVV8aolnmlV2RkhqEbA20fQ0qikjU+6jFy0hOb
         vf96459MtlDC62FdGeFFJG+abjMrTzTmovyce/ebkgpYTj9RLBI9tWW6cTRCC6j0zW
         pdWQUJHt9kuTOo+EQOqO31H3MLZ7mY08bHwxmiUgsWuH6Rs55+jai2+m2C2B4tMURf
         oibJcu4hOXsw9Yi0vbTPoXVaz0bSRAnAp2SxYPiS1wvIoKiyQmIwLjhyyRDOabEafz
         pjfIavijDvnhA==
Subject: [PATCH 4/5] xfs: repair cannot update the summary counters when
 logging quota flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:07 -0800
Message-ID: <167243838749.695667.16792525781900805045.stgit@magnolia>
In-Reply-To: <167243838686.695667.4884256571173103690.stgit@magnolia>
References: <167243838686.695667.4884256571173103690.stgit@magnolia>
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
index 2de438ddb8ac..539c3544b11a 100644
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

