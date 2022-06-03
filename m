Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EADA6C43334
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 18:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348500AbiFCS6K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348487AbiFCS6I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 14:58:08 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A1D29C87
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 11:58:07 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id h192so1094923pgc.4
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jun 2022 11:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+2hrIKF5pDaYRaFF9m3UrUfIfWQH25Avq8v2Hlyw1kQ=;
        b=PXkoPLPswva5qBSKmYiP1XS00je9QbGdENaIn8/y1KScfGiYibZiaMD0PGGZprV4RI
         WzNiD8AxMsETjIdauYVEWMrKQpuB2arB5nLNL3AXyRrx4BgMQ1oe62fdQTF2jqUibf/t
         V+4zKggC19IqAOaXqq9eU6dinjjf71QJLNAPzlywAgOz/PEn6cQbqWtPKXKZVD0zryDz
         n/0+uYKZztsMDQ5JA8V3X/zBoXbjGJZvjUH2XVjD+o/cW4FUtVY4rc7y7X3rioUyjIwd
         OPywB2z56e/iZ2EFwj//Vx1/e6/3xYdsYqyl60/q0t797lq3FxIcxfGHsKWsMnjxuo2D
         z8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+2hrIKF5pDaYRaFF9m3UrUfIfWQH25Avq8v2Hlyw1kQ=;
        b=iUjebW5xrnwfZ0LwSpOMQqQgwgtoqTQS5PsGfe0Yq1TlIUH+ArdUt1LG8HLFGmKsgM
         M7khuC4lizSyPKsOhPZK5WcffejGqyV9xQd1hKVSL99dhcVnulANZVgOxaJF9nJbZivb
         alqKluw+s4UG2O98EZzhTwretqY3BTk7N+yJdKh8Mi7N1sPcpJSpZgoQoGYjpChnPM5w
         IcxwbNMXykFMc7CnAvrKV2KPoGjNpiMp+pihB15eO7EELFmEoRHdDe2oZt4Ejz4zZxFs
         UGOuCyjw2bogmU4DNlG1Zux5DaU81tXq/mi2tn8OeN2d/9CmmI78wS7b6ZrvPXWOte0L
         /m+w==
X-Gm-Message-State: AOAM5339n4xhQqMXsDoIdwNaHqazFtT488T/MYYIHAAYOqAvSsDtsGZ2
        68LwoCZ9a1JQHg567mVwOoWKNkGyejWfcA==
X-Google-Smtp-Source: ABdhPJzWt0GNoy7jr+4fXoIbErUCTmscPEIlRe+ojhwgJmlh8yILMjU2HkpnAxGDTY6ZRBGEqpUr2Q==
X-Received: by 2002:a63:65c7:0:b0:3fc:85b5:30c0 with SMTP id z190-20020a6365c7000000b003fc85b530c0mr10300843pgb.165.1654282687285;
        Fri, 03 Jun 2022 11:58:07 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:e74e:a023:a0be:b6a8])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b001621ce92196sm4480969plk.86.2022.06.03.11.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:58:06 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 13/15] xfs: don't include bnobt blocks when reserving free block pool
Date:   Fri,  3 Jun 2022 11:57:19 -0700
Message-Id: <20220603185721.3121645-13-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220603185721.3121645-1-leah.rumancik@gmail.com>
References: <20220603185721.3121645-1-leah.rumancik@gmail.com>
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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
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
2.36.1.255.ge46751e96f-goog

