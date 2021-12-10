Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EA6C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Dec 2021 20:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344188AbhLJUZ3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 15:25:29 -0500
Received: from sandeen.net ([63.231.237.45]:43502 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234163AbhLJUZ3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Dec 2021 15:25:29 -0500
Received: by sandeen.net (Postfix, from userid 500)
        id 9E4B5328A14; Fri, 10 Dec 2021 14:21:40 -0600 (CST)
From:   Eric Sandeen <sandeen@sandeen.net>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs_quota: document unit multipliers used in limit command
Date:   Fri, 10 Dec 2021 14:21:34 -0600
Message-Id: <1639167697-15392-2-git-send-email-sandeen@sandeen.net>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
References: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

The units used to set limits are never specified in the xfs_quota
man page, and in fact for block limits, the standard k/m/g/...
units are accepted. Document all of this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 man/man8/xfs_quota.8 | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index 59e603f..f841e3f 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -446,7 +446,13 @@ option reports state on all filesystems and not just the current path.
 .I name
 .br
 Set quota block limits (bhard/bsoft), inode count limits (ihard/isoft)
-and/or realtime block limits (rtbhard/rtbsoft). The
+and/or realtime block limits (rtbhard/rtbsoft) to N, where N is a bare
+number representing bytes or inodes.
+For block limits, a number with a s/b/k/m/g/t/p/e multiplication suffix
+as described in
+.BR mkfs.xfs (8)
+is also accepted.
+The
 .B \-d
 option (defaults) can be used to set the default value
 that will be used, otherwise a specific
-- 
1.8.3.1

