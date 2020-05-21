Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73DF6C433E5
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D42E20756
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 02:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgEUCft (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 22:35:49 -0400
Received: from sandeen.net ([63.231.237.45]:41454 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727776AbgEUCft (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 22:35:49 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id 5AA5A328A03; Wed, 20 May 2020 21:35:20 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] xfs: allow individual quota grace period extension
Date:   Wed, 20 May 2020 21:35:18 -0500
Message-Id: <1590028518-6043-8-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
References: <1590028518-6043-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The only grace period which can be set in the kernel today is for id 0,
i.e. the default grace period for all users.  However, setting an
individual grace period is useful; for example:

 Alice has a soft quota of 100 inodes, and a hard quota of 200 inodes
 Alice uses 150 inodes, and enters a short grace period
 Alice really needs to use those 150 inodes past the grace period
 The administrator extends Alice's grace period until next Monday

vfs quota users such as ext4 can do this today, with setquota -T

To enable this for XFS, we simply move the timelimit assignment out
from under the (id == 0) test.  Default setting remains under (id == 0).
Note that this now is consistent with how we set warnings.

(Userspace requires updates to enable this as well; xfs_quota needs to
parse new options, and setquota needs to set appropriate field flags.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_qm_syscalls.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 9b69ce1..362ccec 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -555,32 +555,40 @@
 		ddq->d_rtbwarns = cpu_to_be16(newlim->d_rt_spc_warns);
 
 	if (id == 0) {
-		/*
-		 * Timelimits for the super user set the relative time
-		 * the other users can be over quota for this file system.
-		 * If it is zero a default is used.  Ditto for the default
-		 * soft and hard limit values (already done, above), and
-		 * for warnings.
-		 */
-		if (newlim->d_fieldmask & QC_SPC_TIMER) {
-			defq->btimelimit = newlim->d_spc_timer;
-			ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
-		}
-		if (newlim->d_fieldmask & QC_INO_TIMER) {
-			defq->itimelimit = newlim->d_ino_timer;
-			ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
-		}
-		if (newlim->d_fieldmask & QC_RT_SPC_TIMER) {
-			defq->rtbtimelimit = newlim->d_rt_spc_timer;
-			ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
-		}
 		if (newlim->d_fieldmask & QC_SPC_WARNS)
 			defq->bwarnlimit = newlim->d_spc_warns;
 		if (newlim->d_fieldmask & QC_INO_WARNS)
 			defq->iwarnlimit = newlim->d_ino_warns;
 		if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
 			defq->rtbwarnlimit = newlim->d_rt_spc_warns;
-	} else {
+	}
+
+	/*
+	 * Timelimits for the super user set the relative time the other users
+	 * can be over quota for this file system. If it is zero a default is
+	 * used.  Ditto for the default soft and hard limit values (already
+	 * done, above), and for warnings.
+	 *
+	 * For other IDs, userspace can bump out the grace period if over
+	 * the soft limit.
+	 */
+	if (newlim->d_fieldmask & QC_SPC_TIMER)
+		ddq->d_btimer = cpu_to_be32(newlim->d_spc_timer);
+	if (newlim->d_fieldmask & QC_INO_TIMER)
+		ddq->d_itimer = cpu_to_be32(newlim->d_ino_timer);
+	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
+		ddq->d_rtbtimer = cpu_to_be32(newlim->d_rt_spc_timer);
+
+	if (id == 0) {
+		if (newlim->d_fieldmask & QC_SPC_TIMER)
+			defq->btimelimit = newlim->d_spc_timer;
+		if (newlim->d_fieldmask & QC_INO_TIMER)
+			defq->itimelimit = newlim->d_ino_timer;
+		if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
+			defq->rtbtimelimit = newlim->d_rt_spc_timer;
+	}
+
+	if (id != 0) {
 		/*
 		 * If the user is now over quota, start the timelimit.
 		 * The user will not be 'warned'.
-- 
1.8.3.1

