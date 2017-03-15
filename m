Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751102AbdCOScl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Mar 2017 14:32:41 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 481C99D4E9
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2017 18:32:36 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v2FIWZPO022288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2017 14:32:36 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: warn about dirty log with -n option
Message-ID: <a59b1187-cf8c-56ac-565d-9c37472730c4@redhat.com>
Date: Wed, 15 Mar 2017 13:32:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

When looking at xfs_repair -n output today, we have no idea if
reported errors may be due to an un-replayed dirty log.  If this
is the case, mention it in the output.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

pls check double-check my logic for the 3 cases :)

diff --git a/repair/phase2.c b/repair/phase2.c
index 5964244..c21778b 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -90,11 +90,16 @@ zero_log(
 	_("zero_log: head block %" PRId64 " tail block %" PRId64 "\n"),
 				head_blk, tail_blk);
 		}
-		if (!no_modify && head_blk != tail_blk) {
-			if (zap_log) {
+		if (head_blk != tail_blk) {
+			if (!no_modify && zap_log) {
 				do_warn(_(
 "ALERT: The filesystem has valuable metadata changes in a log which is being\n"
 "destroyed because the -L option was used.\n"));
+			} else if (no_modify) {
+				do_warn(_(
+"ALERT: The filesystem has valuable metadata changes in a log which is being\n"
+"ignored because the -n option was used.  Expect spurious inconsistencies\n"
+"which may be resolved by first mounting the filesystem to replay the log.\n"));
 			} else {
 				do_warn(_(
 "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"

