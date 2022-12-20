Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE06C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 00:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiLTAFN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 19:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiLTAFM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 19:05:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76FA266D
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 16:05:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 730EDB8109E
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 00:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235C5C433EF;
        Tue, 20 Dec 2022 00:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671494709;
        bh=rk9n68Xt0K3QgrP+pOY7lic0AMmjbI/qQIqCpjmI2RI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M9ZVU7gj+a7mj/lEiDx0JEygWyyIVcYCfTx+Tl/zo5BO51tY/2jE2YSyITsKMqPYp
         XuwUFrEHRDmVvbYrWim4ydDwrxZngFZgea6cYMEyZVrFpWjpMIJC4nF/K2KN3WiVsR
         0n5az3LRJjSCEzbSVyCAq6STlAsA7oKfBGTk1VisgLIFlFs/5WDQFtB8FTH9TrJiow
         RUdSCVraWa/K5yZOe6bDwRBIxCc9CuM4Dhiz7AMR7gGe8bVZZ0l/E1nF95XQxoA4/z
         FHuX7fq2CU6Vy/kJPGrbYYXMrFJsbbghbaoWJ3Jgo1KHclEWZeOBOdXLnd/NCgstKe
         5G9nn9Nfx3sow==
Subject: [PATCH 2/4] xfs: don't stall background reclaim on inactvation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 19 Dec 2022 16:05:08 -0800
Message-ID: <167149470870.336919.10695086693636688760.stgit@magnolia>
In-Reply-To: <167149469744.336919.13748690081866673267.stgit@magnolia>
References: <167149469744.336919.13748690081866673267.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The online fsck stress tests deadlocked a test VM the other night.  The
deadlock happened because:

1. kswapd tried to prune the sb inode list, xfs found that it needed to
inactivate an inode and that the queue was long enough that it should
wait for the worker.  It was holding shrinker_rwsem.

2. The inactivation worker allocated a transaction and then stalled
trying to obtain the AGI buffer lock.

3. An online repair function called unregister_shrinker while in
transaction context and holding the AGI lock.  It also tried to grab
shrinker_rwsem.

#3 shouldn't happen and was easily fixed, but seeing as we designed
background inodegc to avoid stalling reclaim, I feel that #1 shouldn't
be happening either.  Fix xfs_inodegc_want_flush_work to avoid stalling
background reclaim on inode inactivation.

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f35e2cee5265..24eff2bd4062 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2000,6 +2000,8 @@ xfs_inodegc_want_queue_work(
  *
  * Note: If the current thread is running a transaction, we don't ever want to
  * wait for other transactions because that could introduce a deadlock.
+ *
+ * Don't let kswapd background reclamation stall on inactivations.
  */
 static inline bool
 xfs_inodegc_want_flush_work(
@@ -2010,6 +2012,9 @@ xfs_inodegc_want_flush_work(
 	if (current->journal_info)
 		return false;
 
+	if (current_is_kswapd())
+		return false;
+
 	if (shrinker_hits > 0)
 		return true;
 

