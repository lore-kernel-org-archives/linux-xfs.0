Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B12CCA479
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiGRUac (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbiGRUaa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 16:30:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5C0B87D
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:28 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t5-20020a17090a6a0500b001ef965b262eso13761742pjj.5
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 13:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RMcVXLfYEzH2PDej27796QVsrsD+ysHavCqTye3mqH0=;
        b=oLuNN3RBSJsmJAs2XcEHujFxesna2pqV9z5fMZiUdOhmcIEyuXN8S6MWK5DbO4sZEk
         nsZ5C6HtOFpg1nhVxG4/NpxuC3fxxqew7MzGFtoE3Ezcz7P8VmdLAhnFIzuuZHlrac9t
         msXevuaSsNhMI/WD9fJ9C/VrL5kD051urZ4n0YdKyOjdUNJI4BAMW4G3CYrW7FWpTqp3
         OFAR5pzFZDtbL2G41Be7pnk5vgdCb+ZTOoWwXcl4rJCZrZ3iTKO4mh+Jtm1TWEYe123V
         2TLyL8hX2e8R6569t1+GOG4DPf7Nt6gxFCuwWNNmuWDps2BLQZhDWm/800JK6/PzSdfC
         qGQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RMcVXLfYEzH2PDej27796QVsrsD+ysHavCqTye3mqH0=;
        b=vZuYmnzdn/gODSO5997Rbe3nBtoIER4sYnBOa0qMRCF49c3zclnEOjyEooygvzDU9v
         E0ehyWimiwkzuicr/gFaAoSky0I9++zpawNqZ0E9tCpGrv4iSgdDCnB/vTYQE5ZtaN4P
         BC+LkDkzwfcN0KlXIsCXfBlk6L3Es+fomDxPbNUwMybWVilA4M0uDrPxWErNx4g4B2Bp
         1qeiCHsMKB9jkJOu4rlWWNdr2ZRo1LTYFf7YeLZ9O8MvGoqF1uVl5xA6Gxfy5zdIh1U2
         NpKrvpi86157LQSDtxRBg9uqxUyYmrPiq2CTh/xW2iNRuDZckuYqCx5Oqi/3gW1w81Zm
         jFtA==
X-Gm-Message-State: AJIora9DUX39BOU2oNuT/gNlicZoxokpcIXvpTKKPOzp5dpBEpfcULPY
        LrVt9d0YF2I/ZT+ZMjefJ2mk1epwnAjz3w==
X-Google-Smtp-Source: AGRyM1sDE+5jCoIh70wAkPz3gfTLUnatQFqx8A7RU7+NSiKIak5ePorypE6s16bBNHxgDV19BjJ7cw==
X-Received: by 2002:a17:90b:17d1:b0:1f0:6f1:90d1 with SMTP id me17-20020a17090b17d100b001f006f190d1mr33634782pjb.221.1658176228174;
        Mon, 18 Jul 2022 13:30:28 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cd67:7482:195c:2daf])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a0ccb00b001ef7fd7954esm11890148pjt.20.2022.07.18.13.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 13:30:27 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 7/9] xfs: fix quotaoff mutex usage now that we don't support disabling it
Date:   Mon, 18 Jul 2022 13:29:57 -0700
Message-Id: <20220718202959.1611129-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220718202959.1611129-1-leah.rumancik@gmail.com>
References: <20220718202959.1611129-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 59d7fab2dff96ed2ca732168859489d71fabd33b ]

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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/scrub/quota.c     |  4 ++--
 fs/xfs/scrub/repair.c    |  3 +++
 fs/xfs/scrub/scrub.c     |  4 ----
 fs/xfs/scrub/scrub.h     |  1 -
 fs/xfs/xfs_qm_syscalls.c | 11 +----------
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
index 51e4c61916d2..3e4607dfc661 100644
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
 
-- 
2.37.0.170.g444d1eabd0-goog

