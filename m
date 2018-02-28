Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42293 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751566AbeB1Dv5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Feb 2018 22:51:57 -0500
From: Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH v2] xfs_repair: Add missing braces
Date: Wed, 28 Feb 2018 11:41:53 +0800
Message-ID: <1519789313-4037-1-git-send-email-yangx.jy@cn.fujitsu.com>
In-Reply-To: <b311ddb9-e996-9e4b-f7f1-d0d45b8f782a@sandeen.net>
References: <b311ddb9-e996-9e4b-f7f1-d0d45b8f782a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, Xiao Yang <yangx.jy@cn.fujitsu.com>

When xlog_find_tail() fails to find the head or the tail, the missing
braces leads that an unparseable log always exits with status 2, even
if we've asked for -n or -L which should proceed.  We can expose this
issue by xfstests case xfs/098.

Fixes:'commit b04647edea32 ("xfs_repair: exit with status 2 if log dirtiness is unknown")'

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 repair/phase2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/repair/phase2.c b/repair/phase2.c
index 992e997..c124882 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -78,12 +78,13 @@ zero_log(
 		do_warn(
 		_("zero_log: cannot find log head/tail (xlog_find_tail=%d)\n"),
 			error);
-		if (!no_modify && !zap_log)
+		if (!no_modify && !zap_log) {
 			do_warn(_(
 "ERROR: The log head and/or tail cannot be discovered. Attempt to mount the\n"
 "filesystem to replay the log or use the -L option to destroy the log and\n"
 "attempt a repair.\n"));
 			exit(2);
+		}
 	} else {
 		if (verbose) {
 			do_log(
-- 
1.8.3.1



