Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61AEBC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjEZB2u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjEZB2t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:28:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32624189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:28:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C445E60C2B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AA8C433D2;
        Fri, 26 May 2023 01:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064528;
        bh=fCMEpHCNsdzlXm8eF5ZVzdxdu6jinEYn7eNtGvU1A5U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=E5G2e3SVok1YPdupwd4esCG4l0Y2ZBJSBfAPDqqcoGGsqbDa0u3K4q39Tvny9/48G
         AvUG6dYyhnK3Fr13b7vXRpwyb5LvMd5iwMLVCjPhjIKINsp6cZm2HaQJ0dyfViDl50
         1S8G0ZSAU4SNhslQTRvLzlEgSt3ZJl2ZzZOoWkkYESOJ36NSCrf2YhDI39sDgRxCzJ
         AlNoVBIRI/E9GNMb2ymF0ix3PJVxEOzI0tbmn3+jXrUd6ylK4dyvpTOcdBsFJDNc94
         u80aJjxRZLHSRG0/VnOXOHZePIitOFQsIoTrViwHwFsocN6JuaBbs3x4iJRz+goX4J
         tFnW5vlLgWdpA==
Date:   Thu, 25 May 2023 18:28:47 -0700
Subject: [PATCH 1/4] xfs: hide private inodes from bulkstat and handle
 functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506065656.3735098.13046581162928612139.stgit@frogsfrogsfrogs>
In-Reply-To: <168506065638.3735098.13625967488642973015.stgit@frogsfrogsfrogs>
References: <168506065638.3735098.13625967488642973015.stgit@frogsfrogsfrogs>
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
index f225413a993c..55b307b2d895 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -86,6 +86,14 @@ xfs_bulkstat_one_int(
 	vfsuid = i_uid_into_vfsuid(idmap, inode);
 	vfsgid = i_gid_into_vfsgid(idmap, inode);
 
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

