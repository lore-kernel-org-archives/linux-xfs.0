Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603E7C77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 22:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344337AbjD0Wtf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 18:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344332AbjD0Wte (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 18:49:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D98C2129
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 15:49:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD41564039
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 22:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F29C433EF;
        Thu, 27 Apr 2023 22:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682635772;
        bh=tkNerUdCaUv4YFjdmoSggfNvhEB0ntz0hiHdHAxRNIc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZlFjW079Mqv+t8iwJ8SBFiL3BZWUmcxC5uM+jITiNO1Q/c6V6bppl71mE4itohChz
         aFiCxOwwrmUhERZdyJXHwo5S9nsXyTuST8fqDbVemwTa9QHLW3wDjf5RNsEpBZcejP
         DSoaoim8S5llvnhFR4z+1XaL65zDhaumNz9gosMXR9PdXUgLbDDB3kY9vNnfjTVBl5
         +jPgI9YL7Lt36N6CIGbjK497QEJd4XAds3QD9XBYTPG+35jc56s5cSuz8oM4AimSVm
         tcZEHi9RImdmCPxDT4///jmG/GCeBNxVDuCntDVhlQcEU+O2DPwFjtzDFsRPD1ePyr
         TYS1H5in5IDOQ==
Subject: [PATCH 2/4] xfs: check that per-cpu inodegc workers actually run on
 that cpu
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Apr 2023 15:49:31 -0700
Message-ID: <168263577171.1719564.17269081541985295999.stgit@frogsfrogsfrogs>
In-Reply-To: <168263576040.1719564.2454266085026973056.stgit@frogsfrogsfrogs>
References: <168263576040.1719564.2454266085026973056.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've allegedly worked out the problem of the per-cpu inodegc
workers being scheduled on the wrong cpu, let's put in a debugging knob
to let us know if a worker ever gets mis-scheduled again.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    2 ++
 fs/xfs/xfs_mount.h  |    3 +++
 fs/xfs/xfs_super.c  |    3 +++
 3 files changed, 8 insertions(+)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 58712113d5d6..4b63c065ef19 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1856,6 +1856,8 @@ xfs_inodegc_worker(
 	struct xfs_inode	*ip, *n;
 	unsigned int		nofs_flag;
 
+	ASSERT(gc->cpu == smp_processor_id());
+
 	WRITE_ONCE(gc->items, 0);
 
 	if (!node)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f3269c0626f0..b51dc8cb7484 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -66,6 +66,9 @@ struct xfs_inodegc {
 	/* approximate count of inodes in the list */
 	unsigned int		items;
 	unsigned int		shrinker_hits;
+#ifdef DEBUG
+	unsigned int		cpu;
+#endif
 };
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4d2e87462ac4..4f498cc1387c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1095,6 +1095,9 @@ xfs_inodegc_init_percpu(
 
 	for_each_possible_cpu(cpu) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+#ifdef DEBUG
+		gc->cpu = cpu;
+#endif
 		init_llist_head(&gc->list);
 		gc->items = 0;
 		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);

