Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB5FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiL3X3m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiL3X3l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:29:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAC513D4C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:29:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 891DD61C0D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99B1C433D2;
        Fri, 30 Dec 2022 23:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442980;
        bh=8G3+mX/81I724rGgt0y2XbMCyndQhMte2FZfhmJEUFY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IRPfspFValzjKDw7yVXMEkGc/0Qm6eutwYFXitSpnqOB6lh4B85IpftfeNqDu5AeN
         ZUvgxDbg1++259A9pXI2/IHzjE142RvPOmRcNHRy0RC5/9YFGRc+DmFbo+nTIAnapM
         8fIwhs4wgqhSEUikU87ee8ObhztceK4YJ8GEPj8lG8V+bGsItIhiNsjZ11vyk2c4E9
         SFqUiwFJcgvbv37dc6UT0y8nIiBCPhgvRJLrJeYwwR8rdLaIaKE1uwrksRUSyq49VX
         LadSfSxnLXdzL6A+g6zsBLHUCBFuMV9Wnkd5Unaa0VO1+pickJvLNHZLu+Ke5vWHEr
         KjFCCVjTyqGAw==
Subject: [PATCH 2/6] xfs: try to attach dquots to files before repairing them
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:52 -0800
Message-ID: <167243837266.694402.16883255377726927881.stgit@magnolia>
In-Reply-To: <167243837231.694402.7473901938296662729.stgit@magnolia>
References: <167243837231.694402.7473901938296662729.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Inode resource usage is tracked in the quota metadata.  Repairing a file
might change the resources used by that file, which means that we need
to attach dquots to the file that we're examining before accessing
anything in the file protected by the ILOCK.

However, there's a twist: a dquot cache miss requires the dquot to be
read in from the quota file, during which we drop the ILOCK on the file
being examined.  This means that we *must* try to attach the dquots
before taking the ILOCK.

Therefore, dquots must be attached to files in the scrub setup function.
If doing so yields corruption errors (or unknown dquot errors), we
instead clear the quotachecked status, which will cause a quotacheck on
next mount.  A future series will make this trigger live quotacheck.

While we're here, change the xrep_ino_dqattach function to use the
unlocked dqattach functions so that we avoid cycling the ILOCK if the
inode already has dquots attached.  This makes the naming and locking
requirements consistent with the rest of the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c      |    4 ++++
 fs/xfs/scrub/common.c    |   25 +++++++++++++++++++++++++
 fs/xfs/scrub/common.h    |    6 ++++++
 fs/xfs/scrub/inode.c     |    4 ++++
 fs/xfs/scrub/repair.c    |   13 ++++++++-----
 fs/xfs/scrub/rtbitmap.c  |    4 ++++
 fs/xfs/scrub/rtsummary.c |    4 ++++
 7 files changed, 55 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 2dc5bcd5c4fa..b6fa880787d9 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -76,6 +76,10 @@ xchk_setup_inode_bmap(
 	if (error)
 		goto out;
 
+	error = xchk_ino_dqattach(sc);
+	if (error)
+		goto out;
+
 	xchk_ilock(sc, XFS_ILOCK_EXCL);
 out:
 	/* scrub teardown will unlock and release the inode */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 2c3707730cd4..6b9d852873d8 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -793,6 +793,26 @@ xchk_iget_agi(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_QUOTA
+/*
+ * Try to attach dquots to this inode if we think we might want to repair it.
+ * Callers must not hold any ILOCKs.  If the dquots are broken and cannot be
+ * attached, a quotacheck will be scheduled.
+ */
+int
+xchk_ino_dqattach(
+	struct xfs_scrub	*sc)
+{
+	ASSERT(sc->tp != NULL);
+	ASSERT(sc->ip != NULL);
+
+	if (!xchk_could_repair(sc))
+		return 0;
+
+	return xrep_ino_dqattach(sc);
+}
+#endif
+
 /* Install an inode that we opened by handle for scrubbing. */
 int
 xchk_install_handle_inode(
@@ -991,6 +1011,11 @@ xchk_setup_inode_contents(
 	error = xchk_trans_alloc(sc, resblks);
 	if (error)
 		goto out;
+
+	error = xchk_ino_dqattach(sc);
+	if (error)
+		goto out;
+
 	xchk_ilock(sc, XFS_ILOCK_EXCL);
 out:
 	/* scrub teardown will unlock and release the inode for us */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 7f2714092514..c1a0a1ac19b2 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -103,9 +103,15 @@ xchk_setup_rtsummary(struct xfs_scrub *sc)
 }
 #endif
 #ifdef CONFIG_XFS_QUOTA
+int xchk_ino_dqattach(struct xfs_scrub *sc);
 int xchk_setup_quota(struct xfs_scrub *sc);
 #else
 static inline int
+xchk_ino_dqattach(struct xfs_scrub *sc)
+{
+	return 0;
+}
+static inline int
 xchk_setup_quota(struct xfs_scrub *sc)
 {
 	return -ENOENT;
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 7a248f26a03c..5c0aaffc6f01 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -37,6 +37,10 @@ xchk_prepare_iscrub(
 	if (error)
 		return error;
 
+	error = xchk_ino_dqattach(sc);
+	if (error)
+		return error;
+
 	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	return 0;
 }
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index d9b0d19c8e2d..e3bcbbcb373e 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -701,10 +701,10 @@ xrep_force_quotacheck(
  *
  * This function ensures that the appropriate dquots are attached to an inode.
  * We cannot allow the dquot code to allocate an on-disk dquot block here
- * because we're already in transaction context with the inode locked.  The
- * on-disk dquot should already exist anyway.  If the quota code signals
- * corruption or missing quota information, schedule quotacheck, which will
- * repair corruptions in the quota metadata.
+ * because we're already in transaction context.  The on-disk dquot should
+ * already exist anyway.  If the quota code signals corruption or missing quota
+ * information, schedule quotacheck, which will repair corruptions in the quota
+ * metadata.
  */
 int
 xrep_ino_dqattach(
@@ -712,7 +712,10 @@ xrep_ino_dqattach(
 {
 	int			error;
 
-	error = xfs_qm_dqattach_locked(sc->ip, false);
+	ASSERT(sc->tp != NULL);
+	ASSERT(sc->ip != NULL);
+
+	error = xfs_qm_dqattach(sc->ip);
 	switch (error) {
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 851039588fe3..c22427012a11 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -32,6 +32,10 @@ xchk_setup_rtbitmap(
 	if (error)
 		return error;
 
+	error = xchk_ino_dqattach(sc);
+	if (error)
+		return error;
+
 	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
 	return 0;
 }
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 6e71e39e197e..73c75d41ef3c 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -61,6 +61,10 @@ xchk_setup_rtsummary(
 	if (error)
 		return error;
 
+	error = xchk_ino_dqattach(sc);
+	if (error)
+		return error;
+
 	/*
 	 * Locking order requires us to take the rtbitmap first.  We must be
 	 * careful to unlock it ourselves when we are done with the rtbitmap

