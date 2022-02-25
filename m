Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0462CC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 20:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235733AbiBYUCn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 15:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbiBYUCn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 15:02:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B801AA06C
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 12:02:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 28A66CE2771
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 20:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C013C340E7;
        Fri, 25 Feb 2022 20:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645819327;
        bh=S5wezFPtWZQku/N2E+vhIqu+FkygewkY4Co9kJg0Qe8=;
        h=Date:From:To:Cc:Subject:From;
        b=PQDiT84FzbIr8pcQLDGYqE32jsrcOH9EK7Q9u/1qKgCXxZfjqTLYo58ju+5aC+dC6
         0ayEAPmxa9jv+u1nyn9yAmL9zXb8+ZCelwF9MhkhXOg/q0J3xODRxWClA2yk3yHI7B
         UuS40v91M3haRKvZt1fIc9PpoSjdzXmmr4EQ3LbeTVtkMm4wkq72EKVbjOVMLTsFJd
         PBYf3d+4LuobCGCidf0bTZKjXRThqvIBowqZXNIf/GVZSVR+Ij9NNefoX1UwxFMC+w
         pegfDf0dmKR2L2fFBLd/1NZvQh5HrOqpUYnG3vU9r0oRqv8DaA7CE7Smh55gYLLrKl
         BsX8v0caVftyQ==
Date:   Fri, 25 Feb 2022 12:02:06 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: don't generate selinux audit messages for capability
 testing
Message-ID: <20220225200206.GS8313@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are a few places where we test the current process' capability set
to decide if we're going to be more or less generous with resource
acquisition for a system call.  If the process doesn't have the
capability, we can continue the call, albeit in a degraded mode.

These are /not/ the actual security decisions, so it's not proper to use
capable(), which (in certain selinux setups) causes audit messages to
get logged.  Switch them to has_capability_noaudit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c  |    4 ++--
 fs/xfs/xfs_ioctl.c  |    2 +-
 fs/xfs/xfs_iops.c   |    2 +-
 kernel/capability.c |    1 +
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 48287caad28b..10e1cb71439e 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -864,8 +864,8 @@ xfs_getfsmap(
 	    !xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[1]))
 		return -EINVAL;
 
-	use_rmap = capable(CAP_SYS_ADMIN) &&
-		   xfs_has_rmapbt(mp);
+	use_rmap = xfs_has_rmapbt(mp) &&
+		   has_capability_noaudit(current, CAP_SYS_ADMIN);
 	head->fmh_entries = 0;
 
 	/* Set up our device handlers. */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2515fe8299e1..83481005317a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1189,7 +1189,7 @@ xfs_ioctl_setattr_get_trans(
 		goto out_error;
 
 	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
-			capable(CAP_FOWNER), &tp);
+			has_capability_noaudit(current, CAP_FOWNER), &tp);
 	if (error)
 		goto out_error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index a56f08314a3d..e6d910a6c35f 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -723,7 +723,7 @@ xfs_setattr_nonsize(
 	}
 
 	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
-			capable(CAP_FOWNER), &tp);
+			has_capability_noaudit(current, CAP_FOWNER), &tp);
 	if (error)
 		goto out_dqrele;
 
diff --git a/kernel/capability.c b/kernel/capability.c
index 46a361dde042..765194f5d678 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -360,6 +360,7 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
 {
 	return has_ns_capability_noaudit(t, &init_user_ns, cap);
 }
+EXPORT_SYMBOL(has_capability_noaudit);
 
 static bool ns_capable_common(struct user_namespace *ns,
 			      int cap,
