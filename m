Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83108C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 01:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhLPBJq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Dec 2021 20:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhLPBJo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Dec 2021 20:09:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FAFC061574
        for <linux-xfs@vger.kernel.org>; Wed, 15 Dec 2021 17:09:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7E9261BB8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Dec 2021 01:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEACC36AE1;
        Thu, 16 Dec 2021 01:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639616983;
        bh=yIIFDdIbod588gBMZ0B3qCiTukToiOPvPxFHRRU6mUA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aqubLzOpuKvoBvfC4SH0nxX0mKpvvoSK5fvyTF7QKyMq9/FQUcDtUWj6+B2Un3pOX
         CgDOL5ClpIbg1BugXOlZ+Yor4zX96l8gWEqZ3Ke0XzINTqQwp5Ll6Lndj8WR3nuYLq
         q1lOPnMeQ65isBs8ryxDVzq7sSSSDCrs6I/1p1ldGK+h8K8Q09nIRySvC/5/MRZpBU
         eHOVXPFpojf8RUQEF6GpiUV0t88rHN8t88JOuRGjzrtRcxz9VHGQCcOPP0n+G4bdHB
         LnovHpJloB5BOV2HADsiUj2WEeiybJjbnsEPnjr12Fn2+1eff7Drr/C0wRLyCQ/fR0
         vGy/uuRp5kmMQ==
Subject: [PATCH 5/7] xfs: fix quotaoff mutex usage now that we don't support
 disabling it
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Dec 2021 17:09:43 -0800
Message-ID: <163961698300.3129691.4408918955613874796.stgit@magnolia>
In-Reply-To: <163961695502.3129691.3496134437073533141.stgit@magnolia>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Prior to commit 40b52225e58c ("xfs: remove support for disabling quota
accounting on a mounted file system"), we used the quotaoff mutex to
protect dquot operations against quotaoff trying to pull down dquots as
part of disabling quota.

Now that we only support turning off quota enforcement, the quotaoff
mutex only protects changes in m_qflags/sb_qflags.  We don't need it to
protect dquots, which means we can remove it from setqlimits and the
dquot scrub code.  While we're at it, fix the function that forces
quotacheck, since it should have been taking the quotaoff mutex.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/quota.c     |    4 ++--
 fs/xfs/scrub/repair.c    |    3 +++
 fs/xfs/scrub/scrub.c     |    4 ----
 fs/xfs/scrub/scrub.h     |    1 -
 fs/xfs/xfs_qm_syscalls.c |   11 +----------
 5 files changed, 6 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index d6c1b00a4fc8..3c7506c7553c 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -48,10 +48,10 @@ xchk_setup_quota(
 	dqtype = xchk_quota_to_dqtype(sc);
 	if (dqtype == 0)
 		return -EINVAL;
-	sc->flags |= XCHK_HAS_QUOTAOFFLOCK;
-	mutex_lock(&sc->mp->m_quotainfo->qi_quotaofflock);
+
 	if (!xfs_this_quota_on(sc->mp, dqtype))
 		return -ENOENT;
+
 	error = xchk_setup_fs(sc);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 8f3cba14ada3..1e7b6b209ee8 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -25,6 +25,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_quota.h"
+#include "xfs_qm.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -912,11 +913,13 @@ xrep_force_quotacheck(
 	if (!(flag & sc->mp->m_qflags))
 		return;
 
+	mutex_lock(&sc->mp->m_quotainfo->qi_quotaofflock);
 	sc->mp->m_qflags &= ~flag;
 	spin_lock(&sc->mp->m_sb_lock);
 	sc->mp->m_sb.sb_qflags &= ~flag;
 	spin_unlock(&sc->mp->m_sb_lock);
 	xfs_log_sb(sc->tp);
+	mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
 }
 
 /*
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8d528d35b725..b11870d07c56 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -173,10 +173,6 @@ xchk_teardown(
 		mnt_drop_write_file(sc->file);
 	if (sc->flags & XCHK_REAPING_DISABLED)
 		xchk_start_reaping(sc);
-	if (sc->flags & XCHK_HAS_QUOTAOFFLOCK) {
-		mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
-		sc->flags &= ~XCHK_HAS_QUOTAOFFLOCK;
-	}
 	if (sc->buf) {
 		kmem_free(sc->buf);
 		sc->buf = NULL;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 80e5026bba44..3de5287e98d8 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -88,7 +88,6 @@ struct xfs_scrub {
 
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
-#define XCHK_HAS_QUOTAOFFLOCK	(1 << 1)  /* we hold the quotaoff lock */
 #define XCHK_REAPING_DISABLED	(1 << 2)  /* background block reaping paused */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 47fe60e1a887..7d5a31827681 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -302,13 +302,6 @@ xfs_qm_scall_setqlim(
 	if ((newlim->d_fieldmask & XFS_QC_MASK) == 0)
 		return 0;
 
-	/*
-	 * We don't want to race with a quotaoff so take the quotaoff lock.
-	 * We don't hold an inode lock, so there's nothing else to stop
-	 * a quotaoff from happening.
-	 */
-	mutex_lock(&q->qi_quotaofflock);
-
 	/*
 	 * Get the dquot (locked) before we start, as we need to do a
 	 * transaction to allocate it if it doesn't exist. Once we have the
@@ -319,7 +312,7 @@ xfs_qm_scall_setqlim(
 	error = xfs_qm_dqget(mp, id, type, true, &dqp);
 	if (error) {
 		ASSERT(error != -ENOENT);
-		goto out_unlock;
+		return error;
 	}
 
 	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
@@ -415,8 +408,6 @@ xfs_qm_scall_setqlim(
 
 out_rele:
 	xfs_qm_dqrele(dqp);
-out_unlock:
-	mutex_unlock(&q->qi_quotaofflock);
 	return error;
 }
 

