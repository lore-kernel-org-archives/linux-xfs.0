Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D5DC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjBPUqq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBPUqp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:46:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9427D52880
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:46:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30F6660C1D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92720C433EF;
        Thu, 16 Feb 2023 20:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580403;
        bh=Tw1OOxAo7nJQMaKlmNsNQ19tYLpxPxp7XKcecp+T0Gg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=s8ysTirZkWFyfI9amkI6uMn8Gtt3z62wMbZ2OOoLdpwS5qx4XrfUTUGLrv62c8I/T
         i8E5pXX2DJj5OxOj9J+6P+yz9VqYayWPU9bH4DlippLTVbCWZLqNwEMJkKuKPU8dhf
         53FreYMGQ/710n4DtUYxkDYWQPcDdkvhDaB4Q1WekaN0WWthoKIXdQ7V8l5Om8ZGj0
         5BbIhgYfV+AlHGS0Z5evKVm3JX1Zj8i6/sMt4hGiZC2VXKw4bUZNasvNgsKtZaY4FZ
         j8VN1L6VdmrtKVSpRdpyHggPSQYgRLe4XIGSq6dP32RLu9Ze17NM9aSzSRZBhj9uRf
         EhmVb+m8n0RPg==
Date:   Thu, 16 Feb 2023 12:46:43 -0800
Subject: [PATCH 19/23] xfs: hide private inodes from bulkstat and handle
 functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874106.3474338.13565241052273372080.stgit@magnolia>
In-Reply-To: <167657873813.3474338.3118516275923112371.stgit@magnolia>
References: <167657873813.3474338.3118516275923112371.stgit@magnolia>
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

