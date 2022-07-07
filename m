Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87EAC43334
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 22:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236872AbiGGWil (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 18:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbiGGWil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 18:38:41 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3861902A
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 15:38:40 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fz10so10428878pjb.2
        for <linux-xfs@vger.kernel.org>; Thu, 07 Jul 2022 15:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Wz2WZELYjvDzLPFf0ymTJxmzeMz5XuoDWnEo30E6+4=;
        b=E2cYJ/BNtA+GArGvigIykkau69PHVPa5msNeNXIF4JEPeMQDyXnmJ/pAzJ8MWXMH+1
         M9EhgdP+3uWajwJ0dqgCu8MQLoh8vAcxYbE8y4FgYKxwyvVuM1k3ahdA5rqw3NXptAnq
         JKgewjmx+G0mcseNFNYH7t1rDkn2iFNRdZfzgDNnAadrJn9MBFeXFawe90z5haIB+kO5
         +Mfm3kGhrYAdjrAOqxSrqT+w3t9tCUw5juUczJaG60kMFzqSLJSm2s6TNyDkQp8WNfjD
         ernbb3C41+R668Kc+7dMhgVuT1Mde0GZ26FEErrwJkcy1oq13WiPssM3WjNrrBsErToW
         2CDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Wz2WZELYjvDzLPFf0ymTJxmzeMz5XuoDWnEo30E6+4=;
        b=yijyMtjC57wbRziaIOr38NT6UqUpOcIp9tK/mZXoVG7lCkYN1QdadfiMpKZyRbibhg
         ztB0LMvL5a2oe175Jn8JvBcdj7rk7F1F/oUJA/A9C/uBaJztv6s4zSJXM8fUel9luDHw
         cmKLMY0sRO3lOFmrKEOmo7coUgIvsxgqdRpq2Dbih2v8Z3DlbwUpzWkGYZjRdYPAaBRD
         sA+Z77L//21wf6b1iK1qoknZZVZ26Lts4C776HEJ487oISzyqZwL11zMPfCtxXcAe4yT
         ftZuefc6cuuDz24nMRTJogAncGdbRXtUXvaUA9xi4iB8OEx5tmk3jeK1eZHVaiWxFeRD
         KgLg==
X-Gm-Message-State: AJIora8pQBPMlLZlNICbETVJSyxRNTzRg3CIqpTrrlT6axPtbDE4bCQD
        qz/6Lb6o5VTdNEWj7LKGoY8HVyhHTlbPbg==
X-Google-Smtp-Source: AGRyM1tmwLEISs/TnMf7HhW10mVmJ2PBr2JQs3NQpQJ6p6MIVEexumukxzfiXRX9hj1a1idDr+zx+g==
X-Received: by 2002:a17:90a:3e09:b0:1ef:8399:398b with SMTP id j9-20020a17090a3e0900b001ef8399398bmr159316pjc.39.1657233519493;
        Thu, 07 Jul 2022 15:38:39 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:26db:8a38:cdca:57b5])
        by smtp.gmail.com with ESMTPSA id j15-20020a056a00234f00b0052542cbff9dsm28776889pfj.99.2022.07.07.15.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 15:38:39 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <lrumancik@google.com>
Subject: [PATCH 5.15 CANDIDATE 2/4] xfs: don't include bnobt blocks when reserving free block pool
Date:   Thu,  7 Jul 2022 15:38:26 -0700
Message-Id: <20220707223828.599185-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220707223828.599185-1-leah.rumancik@gmail.com>
References: <20220707223828.599185-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit c8c568259772751a14e969b7230990508de73d9d ]

xfs_reserve_blocks controls the size of the user-visible free space
reserve pool.  Given the difference between the current and requested
pool sizes, it will try to reserve free space from fdblocks.  However,
the amount requested from fdblocks is also constrained by the amount of
space that we think xfs_mod_fdblocks will give us.  If we forget to
subtract m_allocbt_blks before calling xfs_mod_fdblocks, it will will
return ENOSPC and we'll hang the kernel at mount due to the infinite
loop.

In commit fd43cf600cf6, we decided that xfs_mod_fdblocks should not hand
out the "free space" used by the free space btrees, because some portion
of the free space btrees hold in reserve space for future btree
expansion.  Unfortunately, xfs_reserve_blocks' estimation of the number
of blocks that it could request from xfs_mod_fdblocks was not updated to
include m_allocbt_blks, so if space is extremely low, the caller hangs.

Fix this by creating a function to estimate the number of blocks that
can be reserved from fdblocks, which needs to exclude the set-aside and
m_allocbt_blks.

Found by running xfs/306 (which formats a single-AG 20MB filesystem)
with an fstests configuration that specifies a 1k blocksize and a
specially crafted log size that will consume 7/8 of the space (17920
blocks, specifically) in that AG.

Cc: Brian Foster <bfoster@redhat.com>
Fixes: fd43cf600cf6 ("xfs: set aside allocation btree blocks from block reservation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <lrumancik@google.com>
---
 fs/xfs/xfs_fsops.c |  2 +-
 fs/xfs/xfs_mount.c |  2 +-
 fs/xfs/xfs_mount.h | 15 +++++++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 33e26690a8c4..710e857bb825 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -434,7 +434,7 @@ xfs_reserve_blocks(
 	error = -ENOSPC;
 	do {
 		free = percpu_counter_sum(&mp->m_fdblocks) -
-						mp->m_alloc_set_aside;
+						xfs_fdblocks_unavailable(mp);
 		if (free <= 0)
 			break;
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 62f3c153d4b2..76056de83971 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1132,7 +1132,7 @@ xfs_mod_fdblocks(
 	 * problems (i.e. transaction abort, pagecache discards, etc.) than
 	 * slightly premature -ENOSPC.
 	 */
-	set_aside = mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
+	set_aside = xfs_fdblocks_unavailable(mp);
 	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
 	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
 				     XFS_FDBLOCKS_BATCH) >= 0) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e091f3b3fa15..86564295fce6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -478,6 +478,21 @@ extern void	xfs_unmountfs(xfs_mount_t *);
  */
 #define XFS_FDBLOCKS_BATCH	1024
 
+/*
+ * Estimate the amount of free space that is not available to userspace and is
+ * not explicitly reserved from the incore fdblocks.  This includes:
+ *
+ * - The minimum number of blocks needed to support splitting a bmap btree
+ * - The blocks currently in use by the freespace btrees because they record
+ *   the actual blocks that will fill per-AG metadata space reservations
+ */
+static inline uint64_t
+xfs_fdblocks_unavailable(
+	struct xfs_mount	*mp)
+{
+	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
+}
+
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
-- 
2.37.0.rc0.161.g10f37bed90-goog

