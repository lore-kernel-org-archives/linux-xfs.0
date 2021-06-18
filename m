Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31375C48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 18:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15447613ED
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 18:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhFRS4V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 14:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231689AbhFRS4U (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Jun 2021 14:56:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF06561209;
        Fri, 18 Jun 2021 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624042450;
        bh=ykhEUEm9WONsb4V/zWKuyrCWMmqeDg2xWoxVdZMCusc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bJSsMeWo/ZHkub6JAype91QjJeBec8GTHPnp6gC9HXXy7R0eo21L3W4P7hQF5WMrf
         PbVRj5/jViz7VzaPErrzbYR8x7adbwpf0H7OxotYNUNwaVFJe1+HiRWt/hZFGdl8DF
         EI3THd5Z6MYg454t3OUfhZt87xhiDt3FWJgstSzkmfdwRGSrmzFP83PqopM0zDSgq5
         Y8O73kwUgYwrCJY3Q/Q4BG1vfyngBYkOjnTwF7d6d/PwkYeXezKuQSX/yc4vDxSq1D
         S6SKEqmoFGzUR+H7A+ZAx2ybQmhRUZWoIq1CO8uwJxWi5jGoaw18ImZanBRhYF7x2P
         A5OYYj0Znhe0g==
Subject: [PATCH 3/3] xfs: shorten the shutdown messages to a single line
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        chandanrlinux@gmail.com, bfoster@redhat.com
Date:   Fri, 18 Jun 2021 11:54:10 -0700
Message-ID: <162404245053.2377241.2678360661858649500.stgit@locust>
In-Reply-To: <162404243382.2377241.18273624393083430320.stgit@locust>
References: <162404243382.2377241.18273624393083430320.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Consolidate the shutdown messages to a single line containing the
reason, the passed-in flags, the source of the shutdown, and the end
result.  This means we now only have one line to look for when
debugging, which is useful when the fs goes down while something else is
flooding dmesg.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b7f979eca1e2..6ed29b158312 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -538,25 +538,25 @@ xfs_do_force_shutdown(
 
 	if (flags & SHUTDOWN_FORCE_UMOUNT) {
 		xfs_alert(mp,
-"User initiated shutdown received. Shutting down filesystem");
+"User initiated shutdown (0x%x) received. Shutting down filesystem",
+				flags);
 		return;
 	}
 
-	xfs_notice(mp,
-"%s(0x%x) called from line %d of file %s. Return address = %pS",
-		__func__, flags, lnnum, fname, __return_address);
-
 	if (flags & SHUTDOWN_CORRUPT_INCORE) {
 		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
-"Corruption of in-memory data detected.  Shutting down filesystem");
+"Corruption of in-memory data (0x%x) detected at %pS (%s:%d).  Shutting down filesystem",
+				flags, __return_address, fname, lnnum);
 		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
 			xfs_stack_trace();
 	} else if (logerror) {
 		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
-			"Log I/O Error Detected. Shutting down filesystem");
+"Log I/O error (0x%x) detected at %pS (%s:%d). Shutting down filesystem",
+				flags, __return_address, fname, lnnum);
 	} else {
 		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
-			"I/O Error Detected. Shutting down filesystem");
+"I/O error (0x%x) detected at %pS (%s:%d). Shutting down filesystem",
+				flags, __return_address, fname, lnnum);
 	}
 
 	xfs_alert(mp,

