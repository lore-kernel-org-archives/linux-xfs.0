Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85585C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A3EF64E74
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhBMFrn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:47:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230117AbhBMFrm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:47:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D88B64E95;
        Sat, 13 Feb 2021 05:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613195222;
        bh=tTvyXxBzcp/uo81o0t+pFv2C3tXNBjx17IAZnH0yTSE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gVlsIXnlOXLFTqaAfhGVjh1cUCpyTmNp1tCLxFlryexFGUo00w15DSV4CgwIjgH1t
         ybhGciJYiFvQyiGgDIHohhdMG0rZ93ioDCPMsryzi1WTt4P96KlmBxB+LRm9FAfctA
         89elAv5la0/vkVn6IHaRyc3JdTE8pS1HIzMYgMh0QfYPGsZPsnq+XVE/zzvEb7Ia+p
         Kev+NT05/ZSWoTNYfhjHMl5WLNOZyo2LlhSSrkQ3jO+8IhQNwN3SxFjBCa/XIik8d6
         n0KZI5QA0uWw1XeZC50GCnlFSCVNCnhf0gpQG5NbG8iAcXcWpj9M+qoFO8D1vy1cV3
         JzCzPyFktDQjw==
Subject: [PATCH 3/3] xfs_repair: add post-phase error injection points
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Fri, 12 Feb 2021 21:47:01 -0800
Message-ID: <161319522176.422860.4620061453225202229.stgit@magnolia>
In-Reply-To: <161319520460.422860.10568013013578673175.stgit@magnolia>
References: <161319520460.422860.10568013013578673175.stgit@magnolia>
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
---
 repair/globals.c    |    3 +++
 repair/globals.h    |    3 +++
 repair/progress.c   |    3 +++
 repair/xfs_repair.c |    4 ++++
 4 files changed, 13 insertions(+)


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
diff --git a/repair/progress.c b/repair/progress.c
index e5a9c1ef..5bbe58ec 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -410,6 +410,9 @@ timestamp(int end, int phase, char *buf)
 		current_phase = phase;
 	}
 
+	if (fail_after_phase && phase == fail_after_phase)
+		kill(getpid(), SIGKILL);
+
 	if (buf) {
 		tmp = localtime((const time_t *)&now);
 		sprintf(buf, _("%02d:%02d:%02d"), tmp->tm_hour, tmp->tm_min, tmp->tm_sec);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 12e319ae..6b60b8f4 100644
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

