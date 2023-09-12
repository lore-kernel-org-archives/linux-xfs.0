Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D72DEE3F09
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 18:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbjILSBC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 14:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbjILSBB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 14:01:01 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C56C1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 11:00:57 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-68fbb10dea4so2171061b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 11:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694541657; x=1695146457; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/TV/oUpoxGknOEgag/Xb2a1+ydOfie+XpNr9J2KFFk=;
        b=eou7X57FS8OS6c8YsTS07pEmwnedBOOcrGUNVhDJ1K86NPa8sPAavjh9+KWw4qwom7
         SZ6TY0q94QVkfycnVPPxJ541xqHQycEv077ThAYtxQmgXWeKLQt8Iu3zpmqPQCSmAkEl
         A3ilmhGPi+Qa8+NMG9dE+G4H566t+WHcLuMnj6QdQYVxm6K7nKwRqy8/g/J0S2O5Yhdp
         QmNNq7V0wbs+r6RNtkp0AN4nVNa+1V/2TbvFlieXri8SinzwPOWd1+q1O3ZVWx7vvVUd
         uqXoBtmY/DOxPn5llKEgDbvSVjGNB6aQ2qCK11j23Xoh/IIM0jXmCdR9V7aJmRA81Iqd
         YMPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694541657; x=1695146457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D/TV/oUpoxGknOEgag/Xb2a1+ydOfie+XpNr9J2KFFk=;
        b=bL3a9B4svCiiFoxXVE35gFP89Sw0K/PI1nCJWqHxL1WJ7kb/q1QyCJNXpJnIxDc3Ie
         OsMbSPy6f78sLqlP6weQx+HBe1zMxQo7x9PsD4BC67zWktg2qa3SBJwKXsKjbD7mjfmm
         RcIKZ2qePPCjX34y/ofnNGAaQQY2aOiZoELc8A7LL52jdA8SZKfkXVYK3aevtD137hod
         KYWiqo+xw11uSw9AZlmVufE8Pgv+b0NJMmvPkoeUTBiHQLnLNBjHe75Y/8C/7vilpZ5/
         wenVZHduttf4vmjvF8aGETf/7NtojGQxS8XPVzGDKJ99t0QfyhGjrkMzMfzWwt8vJZ+t
         KCOg==
X-Gm-Message-State: AOJu0Yx7hPGBk8V+HaB5rvh0pKhLuGxokpAg7HLNdF24V2P8dtF4wjQa
        APMH7u5yo7w5hA0YvEkb9kQZ4TWsQqHVgA==
X-Google-Smtp-Source: AGHT+IGUy48FRdiy2QYzwgowiedo9kKv/090OL6wzspixC862HNwGhCkwfPm32cwQo63CmsHW8XICg==
X-Received: by 2002:a05:6a00:2eaa:b0:68e:47b3:ec7 with SMTP id fd42-20020a056a002eaa00b0068e47b30ec7mr563008pfb.14.1694541656796;
        Tue, 12 Sep 2023 11:00:56 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:e951:d95c:9c79:d1b])
        by smtp.gmail.com with ESMTPSA id x12-20020aa784cc000000b0068be7119c70sm3412246pfn.186.2023.09.12.11.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 11:00:56 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 5/6] xfs: disable reaping in fscounters scrub
Date:   Tue, 12 Sep 2023 11:00:39 -0700
Message-ID: <20230912180040.3149181-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230912180040.3149181-1-leah.rumancik@gmail.com>
References: <20230912180040.3149181-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 2d5f38a31980d7090f5bf91021488dc61a0ba8ee ]

The fscounters scrub code doesn't work properly because it cannot
quiesce updates to the percpu counters in the filesystem, hence it
returns false corruption reports.  This has been fixed properly in
one of the online repair patchsets that are under review by replacing
the xchk_disable_reaping calls with an exclusive filesystem freeze.
Disabling background gc isn't sufficient to fix the problem.

In other words, scrub doesn't need to call xfs_inodegc_stop, which is
just as well since it wasn't correct to allow scrub to call
xfs_inodegc_start when something else could be calling xfs_inodegc_stop
(e.g. trying to freeze the filesystem).

Neuter the scrubber for now, and remove the xchk_*_reaping functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/scrub/common.c     | 25 -------------------------
 fs/xfs/scrub/common.h     |  2 --
 fs/xfs/scrub/fscounters.c | 13 ++++++-------
 fs/xfs/scrub/scrub.c      |  2 --
 fs/xfs/scrub/scrub.h      |  1 -
 5 files changed, 6 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index bf1f3607d0b6..08df23edea72 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -864,28 +864,3 @@ xchk_ilock_inverted(
 	return -EDEADLOCK;
 }
 
-/* Pause background reaping of resources. */
-void
-xchk_stop_reaping(
-	struct xfs_scrub	*sc)
-{
-	sc->flags |= XCHK_REAPING_DISABLED;
-	xfs_blockgc_stop(sc->mp);
-	xfs_inodegc_stop(sc->mp);
-}
-
-/* Restart background reaping of resources. */
-void
-xchk_start_reaping(
-	struct xfs_scrub	*sc)
-{
-	/*
-	 * Readonly filesystems do not perform inactivation or speculative
-	 * preallocation, so there's no need to restart the workers.
-	 */
-	if (!xfs_is_readonly(sc->mp)) {
-		xfs_inodegc_start(sc->mp);
-		xfs_blockgc_start(sc->mp);
-	}
-	sc->flags &= ~XCHK_REAPING_DISABLED;
-}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 454145db10e7..2ca80102e704 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -148,7 +148,5 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 int xchk_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
-void xchk_stop_reaping(struct xfs_scrub *sc);
-void xchk_start_reaping(struct xfs_scrub *sc);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 48a6cbdf95d0..037541339d80 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -128,13 +128,6 @@ xchk_setup_fscounters(
 	if (error)
 		return error;
 
-	/*
-	 * Pause background reclaim while we're scrubbing to reduce the
-	 * likelihood of background perturbations to the counters throwing off
-	 * our calculations.
-	 */
-	xchk_stop_reaping(sc);
-
 	return xchk_trans_alloc(sc, 0);
 }
 
@@ -353,6 +346,12 @@ xchk_fscounters(
 	if (fdblocks > mp->m_sb.sb_dblocks)
 		xchk_set_corrupt(sc);
 
+	/*
+	 * XXX: We can't quiesce percpu counter updates, so exit early.
+	 * This can be re-enabled when we gain exclusive freeze functionality.
+	 */
+	return 0;
+
 	/*
 	 * If ifree exceeds icount by more than the minimum variance then
 	 * something's probably wrong with the counters.
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 51e4c61916d2..e4d2a41983f7 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -171,8 +171,6 @@ xchk_teardown(
 	}
 	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
 		mnt_drop_write_file(sc->file);
-	if (sc->flags & XCHK_REAPING_DISABLED)
-		xchk_start_reaping(sc);
 	if (sc->flags & XCHK_HAS_QUOTAOFFLOCK) {
 		mutex_unlock(&sc->mp->m_quotainfo->qi_quotaofflock);
 		sc->flags &= ~XCHK_HAS_QUOTAOFFLOCK;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 80e5026bba44..e8d9fe9de26e 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -89,7 +89,6 @@ struct xfs_scrub {
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
 #define XCHK_HAS_QUOTAOFFLOCK	(1 << 1)  /* we hold the quotaoff lock */
-#define XCHK_REAPING_DISABLED	(1 << 2)  /* background block reaping paused */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
 /* Metadata scrubbers */
-- 
2.42.0.283.g2d96d420d3-goog

