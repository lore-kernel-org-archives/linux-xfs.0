Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2681CC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 03:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3FE864ED5
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 03:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhBSDTB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 22:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhBSDS4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Feb 2021 22:18:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A2D564EDB;
        Fri, 19 Feb 2021 03:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613704696;
        bh=Oe9LMLwa4A/l8KiB2WaNs2EVE1/j8fBuAqXEgjUaktw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K2f7JBpHEVXjerx7469FsdW41BWyHZVCEBiBDlycmAvEz3TO2qri4gJCAUXDo6c6Z
         2lzF6Xc/fhab6Zuxvn/dyGqSEjfLa4pOcUiI8FbhCMXvUjeCfzuQyHJTRXitc5v6wN
         /XDTN2kcPMtERe+POodi02j57xLcuti/HbRsJrgK6b4NSZP1m7w8ZrMpuLUeINgFPr
         1E9aWoxB+eeVOszwZYv7BalBwVFLpM/Lu+O+ZCkokks/uQgFyGNKlpRt+hLD6ZPFPN
         iMldtmopQPWHJ6ayoh32W4ZOWJYYwlLkC86EXBR7HW1JLGqXv86+S16D68h9qwjqDY
         R3gdfLjG533QQ==
Subject: [PATCH 4/4] xfs_repair: add post-phase error injection points
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Thu, 18 Feb 2021 19:18:15 -0800
Message-ID: <161370469573.2389661.2370498929966302970.stgit@magnolia>
In-Reply-To: <161370467351.2389661.12577563230109429304.stgit@magnolia>
References: <161370467351.2389661.12577563230109429304.stgit@magnolia>
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
index 891b3b23..33062170 100644
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
@@ -851,6 +855,10 @@ static inline void
 phase_end(int phase)
 {
 	timestamp(PHASE_END, phase, NULL);
+
+	/* Fail if someone injected an post-phase error. */
+	if (fail_after_phase && phase == fail_after_phase)
+		platform_crash();
 }
 
 int

