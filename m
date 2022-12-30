Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C279C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235683AbiL3Xzz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiL3Xzy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:55:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6511740A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:55:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28DFC61C9A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDDAC433EF;
        Fri, 30 Dec 2022 23:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444551;
        bh=Tw1OOxAo7nJQMaKlmNsNQ19tYLpxPxp7XKcecp+T0Gg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=My2fC5QP3wGIs08NO1TW8AhOTw3VUZJkB0piN1gX8AwCyPcp0pnK1vg1s1ZxoMO72
         sIBrr6TpW4TQ/o7Ym/yxQOaQ9BnHTsaKYyccPHGLOXFAxvkmqpQXPthBsugic7Xu2K
         uAgtsWVfhn+BdoBc8inBzyrN7i5MpSiqm7XsR9l1S9HW2i89Fm0t/iNrzZ3e+ceVqu
         D+688hhh6i6vhZWSkzNb/feE6HTUsx+0zpkuuKyHtVJFADF4UtjPS1IlZYRves3hEQ
         uTBEThMwBIGC71fmwSJ0AZk0MN7SSWysxh0bfTwt7kkJ53HU2wLliW/Lm7G/r+RCPy
         abTpLlw/QyGIQ==
Subject: [PATCH 1/4] xfs: hide private inodes from bulkstat and handle
 functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:01 -0800
Message-ID: <167243844133.699982.515386507193418795.stgit@magnolia>
In-Reply-To: <167243844115.699982.6114366012860370017.stgit@magnolia>
References: <167243844115.699982.6114366012860370017.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We're about to start adding functionality that uses internal inodes that
are private to XFS.  What this means is that userspace should never be
able to access any information about these files, and should not be able
to open these files by handle.  Callers are not allowed to link these
files into the directory tree, which should suffice to make these
private inodes actually private.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_export.c |    2 +-
 fs/xfs/xfs_itable.c |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 1064c2342876..b6ba96e0dd75 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -146,7 +146,7 @@ xfs_nfs_get_inode(
 		return ERR_PTR(error);
 	}
 
-	if (VFS_I(ip)->i_generation != generation) {
+	if (VFS_I(ip)->i_generation != generation || IS_PRIVATE(VFS_I(ip))) {
 		xfs_irele(ip);
 		return ERR_PTR(-ESTALE);
 	}
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index a1c2bcf65d37..7a967cc78010 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -86,6 +86,14 @@ xfs_bulkstat_one_int(
 	vfsuid = i_uid_into_vfsuid(mnt_userns, inode);
 	vfsgid = i_gid_into_vfsgid(mnt_userns, inode);
 
+	/* If this is a private inode, don't leak its details to userspace. */
+	if (IS_PRIVATE(inode)) {
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		xfs_irele(ip);
+		error = -EINVAL;
+		goto out_advance;
+	}
+
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */

