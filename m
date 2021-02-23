Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373AEC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B4964E5B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhBWDBs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:01:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231266AbhBWDBp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:01:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC4FD64E6B;
        Tue, 23 Feb 2021 03:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049283;
        bh=Wz3jet6NHTd4J1ElhB+e4JYbaZ3lZSHVVdk54ETTl24=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QQU2N2jlTC3bMRw2hqwN0XRGeIOmsDdsQg0JGPtdBqK4SxV/0u7qUxBV3s5eNPhL3
         z3p0yK8S1UQn5luj/dFwPeyFf++9JFea+hHXCUKCWyghGMB0LRZ1PB5HM9DV0xaKb9
         gIG8CaHnW/tGLoOhUkNxe6pv2Ca+CMbbP2eIF3+Ze2gk8jo2ieeKw6HAodJPlgNA7Z
         rHPrQynqInItaFH1fWsXIGMSgQmRyBP7l5cIM6u2kfIqKezt/ljbD7o8fZBxLLGgls
         cqSd/bQjK5ub/k7ZVGYGnVSfpiAjQJNURkH64bC/kdSGAMxVNvlOopOqNgLNRpB+2V
         BEuTVbr7kusmA==
Subject: [PATCH 4/4] xfs_repair: add post-phase error injection points
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:01:23 -0800
Message-ID: <161404928343.425602.4302650863642276667.stgit@magnolia>
In-Reply-To: <161404926046.425602.766097344183886137.stgit@magnolia>
References: <161404926046.425602.766097344183886137.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create an error injection point so that we can simulate repair failing
after a certain phase.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 repair/globals.c    |    3 +++
 repair/globals.h    |    3 +++
 repair/xfs_repair.c |    8 ++++++++
 3 files changed, 14 insertions(+)


diff --git a/repair/globals.c b/repair/globals.c
index 110d98b6..537d068b 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -117,3 +117,6 @@ uint64_t	*prog_rpt_done;
 
 int		ag_stride;
 int		thread_count;
+
+/* If nonzero, simulate failure after this phase. */
+int		fail_after_phase;
diff --git a/repair/globals.h b/repair/globals.h
index 1d397b35..a9287320 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -162,4 +162,7 @@ extern uint64_t		*prog_rpt_done;
 extern int		ag_stride;
 extern int		thread_count;
 
+/* If nonzero, simulate failure after this phase. */
+extern int		fail_after_phase;
+
 #endif /* _XFS_REPAIR_GLOBAL_H */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index a9236bb7..64d7607f 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -362,6 +362,10 @@ process_args(int argc, char **argv)
 
 	if (report_corrected && no_modify)
 		usage();
+
+	p = getenv("XFS_REPAIR_FAIL_AFTER_PHASE");
+	if (p)
+		fail_after_phase = (int)strtol(p, NULL, 0);
 }
 
 void __attribute__((noreturn))
@@ -853,6 +857,10 @@ static inline void
 phase_end(int phase)
 {
 	timestamp(PHASE_END, phase, NULL);
+
+	/* Fail if someone injected an post-phase error. */
+	if (fail_after_phase && phase == fail_after_phase)
+		platform_crash();
 }
 
 int

