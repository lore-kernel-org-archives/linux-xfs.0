Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EDBC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345544AbiATA1i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:27:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34448 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345543AbiATA1i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:27:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4CF661511
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27140C004E1;
        Thu, 20 Jan 2022 00:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638457;
        bh=WAqXzCNen8KeQSBhNG1jkqCPzWsEewgC2lQdsPPQ5RU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=h215dYAnsmKcFzscL4wk1/Zhd//uKBjZF4hYrCeGixAUkL80N5WEvZgLXnrzVdJcr
         9p+lfkLMB0215aKwLNmlE2DFWPSmljJ/ODZfNtuXkeO/rWA/1DEyLKEiec1xZleW9q
         6NnCVVXru+R317KlKppT2m85477cI0rOObELxUHRbRwS9omLqvBQOIIlMLj6CbDr6P
         hy1dBsF5mVGzm9d0WeTwjhVptiZNEGI7Ob8ZKsQcmDNn6HcsnVi6U1tnJupsJ6FMmq
         m7s7tyUIlqZqd6HgPc0FwTeL7wGO6BCZsn5hxunCGAluEz1EnE0bekkX2i7+ZW3om2
         PWJMEDG69Lhag==
Subject: [PATCH 48/48] libxfs: remove kernel stubs from xfs_shared.h
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:27:36 -0800
Message-ID: <164263845686.865554.7985182153330834877.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The kernel stubs added to xfs_shared.h don't belong there, and are
mostly unnecessary with the #ifdef __KERNEL__ bits added to the
xfs_ag.[ch] files. Move the one remaining needed stub in libxfs_priv.h.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_priv.h |    2 ++
 libxfs/xfs_shared.h  |   20 --------------------
 2 files changed, 2 insertions(+), 20 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 67d9a8bb..167bd8c0 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -75,6 +75,8 @@ extern struct kmem_cache *xfs_trans_cache;
 /* fake up kernel's iomap, (not) used in xfs_bmap.[ch] */
 struct iomap;
 
+#define cancel_delayed_work_sync(work) do { } while(0)
+
 #include "xfs_cksum.h"
 
 /*
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index bafee48c..25c4cab5 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -180,24 +180,4 @@ struct xfs_ino_geometry {
 
 };
 
-/* Faked up kernel bits */
-struct rb_root {
-};
-
-#define RB_ROOT 		(struct rb_root) { }
-
-typedef struct wait_queue_head {
-} wait_queue_head_t;
-
-#define init_waitqueue_head(wqh)	do { } while(0)
-
-struct rhashtable {
-};
-
-struct delayed_work {
-};
-
-#define INIT_DELAYED_WORK(work, func)	do { } while(0)
-#define cancel_delayed_work_sync(work)	do { } while(0)
-
 #endif /* __XFS_SHARED_H__ */

