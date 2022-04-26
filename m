Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78466C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 01:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240196AbiDZBhH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 21:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237514AbiDZBhG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 21:37:06 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A9284616E
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 18:34:00 -0700 (PDT)
Received: by sandeen.net (Postfix, from userid 500)
        id 4E957793A; Mon, 25 Apr 2022 20:33:38 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, catherine.hoang@oracle.com, david@fromorbit.com
Subject: [PATCH] xfs: revert "xfs: actually bump warning counts when we send warnings"
Date:   Mon, 25 Apr 2022 20:33:38 -0500
Message-Id: <1650936818-20973-1-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This reverts commit 4b8628d57b725b32616965e66975fcdebe008fe7.

XFS quota has had the concept of a "quota warning limit" since
the earliest Irix implementation, but a mechanism for incrementing
the warning counter was never implemented, as documented in the
xfs_quota(8) man page. We do know from the historical archive that
it was never incremented at runtime during quota reservation
operations.

With this commit, the warning counter quickly increments for every
allocation attempt after the user has crossed a quote soft
limit threshold, and this in turn transitions the user to hard
quota failures, rendering soft quota thresholds and timers useless.
This was reported as a regression by users.

Because the intended behavior of this warning counter has never been
understood or documented, and the result of this change is a regression
in soft quota functionality, revert this commit to make soft quota
limits and timers operable again.

Fixes: 4b8628d57b72 ("xfs: actually bump warning counts when we send warnings)
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_trans_dquot.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 9ba7e6b..ebe2c22 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -603,7 +603,6 @@
 			return QUOTA_NL_ISOFTLONGWARN;
 		}
 
-		res->warnings++;
 		return QUOTA_NL_ISOFTWARN;
 	}
 
-- 
1.8.3.1

