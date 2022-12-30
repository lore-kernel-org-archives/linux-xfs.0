Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E58C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbiLaBaI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbiLaBaF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:30:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5101DF18
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:30:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDE5561CBD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3E9C433D2;
        Sat, 31 Dec 2022 01:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450204;
        bh=P2PNLXVClgGP5uOcM3KOBWi2FiU5Tuv+4kSoblPLQ/c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KBcnFYfgrAn2iG6tMj885IlIWd/Zx399f33sEZqeM+QAA2On2W3hMovub/37mHwuF
         YKwd7F7RZbEu9OElrVICQG3NOYovcreEBwOTohidsFW/Wp1AZVqrcBKGls3f6vQ48z
         Ei65QzZCeP5fkyWBDKdV6N91FjwKUtnOl0dEZmYVmHiVm7ardJWTpYYqk3aI0UR68x
         cgvXo7hQ0m8jWSkC8i4N1Iw4VVMBIEaFdeD3j/ksAdHRqm92WHD0NDqCz+KJdCh8Aw
         PTpYy2rEBs/r6Yo+zd1APME6S+YTP4YKkmza+Z9j8WR9Zjfo0em4uk3oG6iQiGfTfQ
         z3Tj6dfw91msA==
Subject: [PATCH 10/22] xfs: add frextents to the lazysbcounters when rtgroups
 enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:54 -0800
Message-ID: <167243867411.712847.9218677001627679490.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make the free rt extent count a part of the lazy sb counters when the
realtime groups feature is enabled.  This is possible because the patch
to recompute frextents from the rtbitmap during log recovery predates
the code adding rtgroup support, hence we know that the value will
always be correct during runtime.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c |    5 +++++
 fs/xfs/xfs_trans.c     |   18 +++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index db88f601e24b..ee4e59453edc 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1089,6 +1089,9 @@ xfs_log_sb(
 	 * sb counters, despite having a percpu counter. It is always kept
 	 * consistent with the ondisk rtbitmap by xfs_trans_apply_sb_deltas()
 	 * and hence we don't need have to update it here.
+	 *
+	 * sb_frextents was added to the lazy sb counters when the rt groups
+	 * feature was introduced.
 	 */
 	if (xfs_has_lazysbcount(mp)) {
 		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
@@ -1097,6 +1100,8 @@ xfs_log_sb(
 				mp->m_sb.sb_icount);
 		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
 	}
+	if (xfs_has_rtgroups(mp))
+		mp->m_sb.sb_frextents = percpu_counter_sum(&mp->m_frextents);
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index a6f46cd9e60c..05e93af190df 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -475,6 +475,8 @@ xfs_trans_mod_sb(
 			ASSERT(tp->t_rtx_res_used <= tp->t_rtx_res);
 		}
 		tp->t_frextents_delta += delta;
+		if (xfs_has_rtgroups(mp))
+			flags &= ~XFS_TRANS_SB_DIRTY;
 		break;
 	case XFS_TRANS_SB_RES_FREXTENTS:
 		/*
@@ -569,8 +571,14 @@ xfs_trans_apply_sb_deltas(
 	 *
 	 * Don't touch m_frextents because it includes incore reservations,
 	 * and those are handled by the unreserve function.
+	 *
+	 * sb_frextents was added to the lazy sb counters when the rt groups
+	 * feature was introduced.  This is possible because we know that all
+	 * kernels supporting rtgroups will also recompute frextents from the
+	 * realtime bitmap.
 	 */
-	if (tp->t_frextents_delta || tp->t_res_frextents_delta) {
+	if ((tp->t_frextents_delta || tp->t_res_frextents_delta) &&
+	    !xfs_has_rtgroups(tp->t_mountp)) {
 		struct xfs_mount	*mp = tp->t_mountp;
 		int64_t			rtxdelta;
 
@@ -684,7 +692,8 @@ xfs_trans_unreserve_and_mod_sb(
 	if (tp->t_rtx_res > 0)
 		rtxdelta = tp->t_rtx_res;
 	if ((tp->t_frextents_delta != 0) &&
-	    (tp->t_flags & XFS_TRANS_SB_DIRTY))
+	    (xfs_has_rtgroups(mp) ||
+	     (tp->t_flags & XFS_TRANS_SB_DIRTY)))
 		rtxdelta += tp->t_frextents_delta;
 
 	if (xfs_has_lazysbcount(mp) ||
@@ -723,8 +732,11 @@ xfs_trans_unreserve_and_mod_sb(
 	 * Do not touch sb_frextents here because we are dealing with incore
 	 * reservation.  sb_frextents is not part of the lazy sb counters so it
 	 * must be consistent with the ondisk rtbitmap and must never include
-	 * incore reservations.
+	 * incore reservations.  sb_frextents was added to the lazy sb counters
+	 * when the realtime groups feature was introduced.
 	 */
+	if (xfs_has_rtgroups(mp))
+		mp->m_sb.sb_frextents += rtxdelta;
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
 	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;

