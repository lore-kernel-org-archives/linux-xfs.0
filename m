Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3091BC3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236324AbiLaDJq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbiLaDJp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:09:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2731054D;
        Fri, 30 Dec 2022 19:09:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B34F61D43;
        Sat, 31 Dec 2022 03:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFEEC433EF;
        Sat, 31 Dec 2022 03:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456184;
        bh=2ults4eSPPu2CQwu9Ox3S3rmD1ptyWG0E9hpnInd/tA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nZRcvlT99NskIlyCKfPMEceyMCJoR/qJVyUqtzhN1121Mf+x6FLO/ho3vxRF8F7pS
         3ttskirz/w7hqawFINy9K3ukkpZsUWPbbWlAUdSwlha3Ex+O6EfF9CuGfbDQe9jneh
         0ATPeSqEaAONG1RGZX/qr34T13vEU2XWoaadtAEUdWS27aSfoqrOzNiUGod5KRBF5I
         dQmbto58ngy8uOzjygA99x0ktKTxZh2kQXVdjTB8BKhEoQUmLPzfrTLjWrxsWf4/qr
         zvZ0Apy8EvXJF/ZkjYwU39dgEMfglcirlrUc82PKyfp+MwALWvIxA/QGgfT2Zc+aQB
         N3uxM6GuxF3fg==
Subject: [PATCH 01/12] xfs/122: update for rtgroups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:39 -0800
Message-ID: <167243883960.739029.13358901178644202496.stgit@magnolia>
In-Reply-To: <167243883943.739029.3041109696120604285.stgit@magnolia>
References: <167243883943.739029.3041109696120604285.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add our new metadata for realtime allocation groups to the ondisk checking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index eee6c1ee6d..01376180cc 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -44,6 +44,9 @@ offsetof(xfs_sb_t, sb_rbmino) = 64
 offsetof(xfs_sb_t, sb_rextents) = 24
 offsetof(xfs_sb_t, sb_rextsize) = 80
 offsetof(xfs_sb_t, sb_rextslog) = 125
+offsetof(xfs_sb_t, sb_rgblklog) = 280
+offsetof(xfs_sb_t, sb_rgblocks) = 272
+offsetof(xfs_sb_t, sb_rgcount) = 276
 offsetof(xfs_sb_t, sb_rootino) = 56
 offsetof(xfs_sb_t, sb_rrmapino) = 264
 offsetof(xfs_sb_t, sb_rsumino) = 72
@@ -112,9 +115,11 @@ sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12
 sizeof(struct xfs_rmap_key) = 20
 sizeof(struct xfs_rmap_rec) = 24
+sizeof(struct xfs_rtgroup_geometry) = 128
 sizeof(struct xfs_rtrmap_key) = 24
 sizeof(struct xfs_rtrmap_rec) = 32
 sizeof(struct xfs_rtrmap_root) = 4
+sizeof(struct xfs_rtsb) = 104
 sizeof(struct xfs_rud_log_format) = 16
 sizeof(struct xfs_rui_log_format) = 16
 sizeof(struct xfs_scrub_metadata) = 64

