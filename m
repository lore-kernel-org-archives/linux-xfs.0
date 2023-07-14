Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45567EB64DA
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Jul 2023 06:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234877AbjGNGq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jul 2023 02:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbjGNGqE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 02:46:04 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455BA3AAF
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 23:45:21 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3fbc63c2e84so13032735e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jul 2023 23:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689317120; x=1691909120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AULk51Wj6WIrmGoDmUNSadsCc+FusPGzEe6kkkxXmZ4=;
        b=jXpII1jWguZC2oQkHM86gTibco6s05z0E/Jne9Gy8phVXlw4lh0jFUXdV3ZyFZLlUu
         Q6EBSfG/5TGKxJymXDPG+Rl50JV+pVJuAEILEP8OnIE+XDzD6BHwIABkTBMQQIKa0ES7
         0cDaXAB4jzv/NsEJk+QJpxe3a6Ogf7MDk7TsRxgr99zDXwfAKeCPCyVybPQVTBesD/6Y
         OhB8YgM3GOnpMKt8yirHqvivMaio7FN/5ySbsk0sKeRiys+WFelOrc8tNz72uoTl4SHh
         PJcTLJ+7Y3OwZwp6/AX86IinST2Bycj2ZAJu9QXpHVTQw6p1vlgCNypACH4UxFf5k2BI
         ZOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689317120; x=1691909120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AULk51Wj6WIrmGoDmUNSadsCc+FusPGzEe6kkkxXmZ4=;
        b=A1LNSSglx0qPVrFZQKKH6SdwAW6fa+WdOqmY5OPyX8ouebn+ukkaPwSyyL3eRTdhGE
         eGQ/k3Asi9mvMqTdSjHcsfNz2c9vsxps8y1uET0uwRtO1PhzYPKrLJaz/zYOUcmXR9gh
         okUCEJIQRdSeO8VysKOvczN0am+3XC/VLkRthkjf2zhHcx8r9EIaHyoDRWbby5LCQ8e0
         ykc0O/tT9Oqgj6ebmKvfqLpG73y4lTBoe3K+1MGFGjtblbLIj1EY26ql6k1CSWO0zrfG
         q7oox5QIjuVqBfuZ1ohG3L7uv3KHdeaIOYTZNew5w8yTAP6yXmonp9H9mot6XxcUlP+O
         oKug==
X-Gm-Message-State: ABy/qLbAH29mqJccsPXU+gd91lYJ+POO90BkH+0CbHyv3x4VxYsNhgif
        8YYJ7oELY8EX2ooNCfUXBhY=
X-Google-Smtp-Source: APBJJlFgena6L06MGtwr+1s0SM+XoAbdT9VFYugWBqC3Qr1LPAKFNu9Igzf3cYMJV8RPTgwS68hrgQ==
X-Received: by 2002:a7b:c454:0:b0:3f8:fac0:ad40 with SMTP id l20-20020a7bc454000000b003f8fac0ad40mr3732777wmi.29.1689317119529;
        Thu, 13 Jul 2023 23:45:19 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id 3-20020a05600c234300b003fc04d13242sm709574wmq.0.2023.07.13.23.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 23:45:19 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 6.1 CANDIDATE v2 3/4] xfs: disable reaping in fscounters scrub
Date:   Fri, 14 Jul 2023 09:45:08 +0300
Message-Id: <20230714064509.1451122-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714064509.1451122-1-amir73il@gmail.com>
References: <20230714064509.1451122-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2d5f38a31980d7090f5bf91021488dc61a0ba8ee upstream.

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
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/scrub/common.c     | 26 --------------------------
 fs/xfs/scrub/common.h     |  2 --
 fs/xfs/scrub/fscounters.c | 13 ++++++-------
 fs/xfs/scrub/scrub.c      |  2 --
 fs/xfs/scrub/scrub.h      |  1 -
 5 files changed, 6 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 9bbbf20f401b..e71449658ecc 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -865,29 +865,3 @@ xchk_ilock_inverted(
 	}
 	return -EDEADLOCK;
 }
-
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
index 6a6f8fe7f87c..88d6961e3886 100644
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
index 2e8e400f10a9..95132490fda5 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -171,8 +171,6 @@ xchk_teardown(
 	}
 	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
 		mnt_drop_write_file(sc->file);
-	if (sc->flags & XCHK_REAPING_DISABLED)
-		xchk_start_reaping(sc);
 	if (sc->buf) {
 		kmem_free(sc->buf);
 		sc->buf = NULL;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 3de5287e98d8..4cb32c27df10 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -88,7 +88,6 @@ struct xfs_scrub {
 
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
-#define XCHK_REAPING_DISABLED	(1 << 2)  /* background block reaping paused */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
 /* Metadata scrubbers */
-- 
2.34.1

