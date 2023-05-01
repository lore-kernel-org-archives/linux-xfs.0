Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732E7C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  1 May 2023 18:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjEAS1d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 May 2023 14:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjEAS1c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 May 2023 14:27:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173F4172B
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 11:27:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9390961E86
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 18:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF39FC433EF;
        Mon,  1 May 2023 18:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682965651;
        bh=JGTj4YlJvrMqQBuBVbUHhcFcM/Rp+1gVS0ttUjJGI00=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZCrPZO51VgxzNcBclRSfdHLx3//BmggZrfgf/5hK2/Pa4Bs6/P73ukwQ4xwQKmo9p
         aCmpCVxlq0FM58lQeQU4JYKoSNxBpqglXJ89+/tnyhuAjsO8lcBmegOXwGfd12iGvI
         /oVnH+pDeR0JecJEZyiAQU15gzNhZ5y+ARiVy/9vT3I7IoXa9fEuUotEdANq6IKAF6
         Vzrvox6se/r9ronbCGQRHkzjxrE5qKrBuHE5e4CHIi+Zw0lbeTcu5VNlXDN4h00Eed
         YcaFjXGv1K+O9gvizbP5QGSzUmAKJkhwdcaGjqmWdcvHp45wmqKaFy/+R4bUzR0yv1
         t29o/wERHU4Sw==
Subject: [PATCH 2/4] xfs: check that per-cpu inodegc workers actually run on
 that cpu
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 01 May 2023 11:27:30 -0700
Message-ID: <168296565051.290156.1446568444182366017.stgit@frogsfrogsfrogs>
In-Reply-To: <168296563922.290156.2222659364666118889.stgit@frogsfrogsfrogs>
References: <168296563922.290156.2222659364666118889.stgit@frogsfrogsfrogs>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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
index f3269c0626f0..aaaf5ec13492 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -66,6 +66,9 @@ struct xfs_inodegc {
 	/* approximate count of inodes in the list */
 	unsigned int		items;
 	unsigned int		shrinker_hits;
+#if defined(DEBUG) || defined(XFS_WARN)
+	unsigned int		cpu;
+#endif
 };
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4d2e87462ac4..7e706255f165 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1095,6 +1095,9 @@ xfs_inodegc_init_percpu(
 
 	for_each_possible_cpu(cpu) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+#if defined(DEBUG) || defined(XFS_WARN)
+		gc->cpu = cpu;
+#endif
 		init_llist_head(&gc->list);
 		gc->items = 0;
 		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);

