Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BF4C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Mar 2022 18:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240451AbiCNSK1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Mar 2022 14:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiCNSK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Mar 2022 14:10:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC8FE007
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 11:09:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB391B80ED9
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 18:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C700C340E9;
        Mon, 14 Mar 2022 18:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647281354;
        bh=6QcUtAFnwvGKkAVfDwczBIUPKptRts0TICEgMCky9+Q=;
        h=Date:From:To:Cc:Subject:From;
        b=Iu4vX0OLcUSqfQLVtMRNAOa5HAk+QLN6m3GLZ2HO4YVz6bvsRjgNwM7/40nQzYtvk
         AEBypWGBxuoIxwjPzqC7IflGjM7wJXitsHQy8p2Eif+bsimsxGU4WZpAgSBtFQudTV
         rnofgEWa4Z/uy5XWQJvoxhL1tHhBfrd6jW0+/gptqOGv4LNhZ6iOZMnUwOrMk3vhz7
         qvhncPxCEiYssx1AJsx2wHV+E8YYVplcbtWlKCRWMELzVZCcQ0h7NhvMS45bTjM/6X
         KvN8k/3K+BqBDSB1NgpZWYMj/mleJnTVI92dj0UyJ8UWci6Sm8I4PS8lKL4j4s6DJi
         PwViANinEsMVw==
Date:   Mon, 14 Mar 2022 11:09:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: make quota default to no warning limit at all
Message-ID: <20220314180914.GN8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Historically, the quota warning counter was never incremented on a
softlimit violation, and hence was never enforced.  Now that the counter
works, the default of 5 warnings is getting enforced, which is a
breakage that people aren't used to.  In the interest of not introducing
new fail to things that used to work, make the default warning limit of
zero, and make zero mean there is no limit.

Sorta-fixes: 4b8628d57b72 ("xfs: actually bump warning counts when we send warnings")
Reported-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.h          |   11 ++++++++---
 fs/xfs/xfs_trans_dquot.c |    3 ++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 5bb12717ea28..2013f6100067 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -134,9 +134,14 @@ struct xfs_dquot_acct {
 #define XFS_QM_RTBTIMELIMIT	(7 * 24*60*60)          /* 1 week */
 #define XFS_QM_ITIMELIMIT	(7 * 24*60*60)          /* 1 week */
 
-#define XFS_QM_BWARNLIMIT	5
-#define XFS_QM_IWARNLIMIT	5
-#define XFS_QM_RTBWARNLIMIT	5
+/*
+ * Histerically, the quota warning counter never incremented and hence was
+ * never enforced.  Now that the counter works, we set a default warning limit
+ * of zero, which means there is no limit.
+ */
+#define XFS_QM_BWARNLIMIT	0
+#define XFS_QM_IWARNLIMIT	0
+#define XFS_QM_RTBWARNLIMIT	0
 
 extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 9ba7e6b9bed3..32da74cf0768 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -598,7 +598,8 @@ xfs_dqresv_check(
 		time64_t	now = ktime_get_real_seconds();
 
 		if ((res->timer != 0 && now > res->timer) ||
-		    (res->warnings != 0 && res->warnings >= qlim->warn)) {
+		    (res->warnings != 0 && qlim->warn != 0 &&
+		     res->warnings >= qlim->warn)) {
 			*fatal = true;
 			return QUOTA_NL_ISOFTLONGWARN;
 		}
