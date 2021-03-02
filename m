Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712FAC4332E
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40B3064DD8
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245643AbhCCDPw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:15:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2360760AbhCBW3P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 17:29:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76F2B64F39;
        Tue,  2 Mar 2021 22:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614724114;
        bh=aoaVwXq+AcND03EGAMRHA0VdBUlzH/E0JEd3GGB9mhI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uqMC3G7XmD7ORA2JRd4aYJpOGJuz2r1BE66HJtavAkFKXsskdwxCqjjjXdzjs4F6s
         AbacSXmXUxEisBQzgePP4ady4JIsZfOvDSN8kgMwJ9FaXP5ry14wF/wB7waISNZPrq
         69Z6ailNH50aVf9b/nl2qfeL00DvU6y0kppKApW0DrTLsDxCDHFOV/oYl03nx8n9i7
         8Bkp+xWzef1VWfe9gF1eC0YC6ZdelnOqCvAwWSIr6A+fYPPLCkN6YiiE5lQq8xv/NO
         boi9ZF3uGZXDd0OvWL1kTkfiMh51Dnc64HJV1+TEQxajTu1aLlwDUkOrAyxYHxgecA
         IsIFb0cQoXm/g==
Subject: [PATCH 3/3] xfs: force log and push AIL to clear pinned inodes when
 aborting mount
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Date:   Tue, 02 Mar 2021 14:28:34 -0800
Message-ID: <161472411392.3421449.548910053179741704.stgit@magnolia>
In-Reply-To: <161472409643.3421449.2100229515469727212.stgit@magnolia>
References: <161472409643.3421449.2100229515469727212.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we allocate quota inodes in the process of mounting a filesystem but
then decide to abort the mount, it's possible that the quota inodes are
sitting around pinned by the log.  Now that inode reclaim relies on the
AIL to flush inodes, we have to force the log and push the AIL in
between releasing the quota inodes and kicking off reclaim to tear down
all the incore inodes.

This was originally found during a fuzz test of metadata directories
(xfs/1546), but the actual symptom was that reclaim hung up on the quota
inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 52370d0a3f43..6f445b611663 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1007,6 +1007,16 @@ xfs_mountfs(
 	xfs_irele(rip);
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
+
+	/*
+	 * It's possible that we modified some inodes as part of setting up
+	 * quotas or initializing filesystem metadata.  These inodes could be
+	 * pinned in the log, so force the log and push the AIL to unpin them
+	 * so that we can reclaim them.
+	 */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+	xfs_ail_push_all_sync(mp->m_ail);
+
 	/*
 	 * Cancel all delayed reclaim work and reclaim the inodes directly.
 	 * We have to do this /after/ rtunmount and qm_unmount because those

