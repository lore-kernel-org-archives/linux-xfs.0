Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10D73DB80
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sP2NgeRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE26C433C8;
	Fri, 24 Nov 2023 23:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869896;
	bh=s0+2DP/A4dezc/2cZJV0ro1e+SILzN/XZymz9GL4Z3Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sP2NgeRcz5u+MT2JTjvz5VrI1yKCgIJ5HCIOItdKC4EufnhHsxS7Ii6gPTPrApsSS
	 yW3aeNhNDrHB0mor9YPshzSNvh54T83bAog1TdfG0aVsh9HOYfpiW7aZtCcOjZ/wEf
	 Hx/pqOK5qlOdUrWFgFOOvN3ai/wjMYjkT83944Lx5sD7bflhfuG4P5YN+x2d6rH7LN
	 QiuaWVRHMcoWypBIKsF+C9GAkrmLrhkbqFW1pW73JiiVve5zRf10KSYGa78YdCP7Yz
	 mk6jSCxgCuhxv0iObz+aule6SLGQICw0TanyiKubiPs2pGGPqDFNjHEJIqL5evI9mi
	 qOTVFEB1frOnA==
Date: Fri, 24 Nov 2023 15:51:36 -0800
Subject: [PATCH 2/7] xfs: try to attach dquots to files before repairing them
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086927472.2771142.3254084672776828738.stgit@frogsfrogsfrogs>
In-Reply-To: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
index 06d8c1996a338..f74bd2a97c7f7 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -78,6 +78,10 @@ xchk_setup_inode_bmap(
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
index b6725b05fb417..9b7d7010495b9 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -820,6 +820,26 @@ xchk_iget_agi(
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
@@ -1031,6 +1051,11 @@ xchk_setup_inode_contents(
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
index 4b666f254d700..895918565df26 100644
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
index b7a93380a1ab0..7e97db8255c63 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -39,6 +39,10 @@ xchk_prepare_iscrub(
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
index 18f8d54948f26..2e82dace10cc2 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -700,10 +700,10 @@ xrep_force_quotacheck(
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
@@ -711,7 +711,10 @@ xrep_ino_dqattach(
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
index 41a1d89ae8e6c..d509a08d3fc3e 100644
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
index 8b15c47408d03..f94800a029f35 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -63,6 +63,10 @@ xchk_setup_rtsummary(
 	if (error)
 		return error;
 
+	error = xchk_ino_dqattach(sc);
+	if (error)
+		return error;
+
 	/*
 	 * Locking order requires us to take the rtbitmap first.  We must be
 	 * careful to unlock it ourselves when we are done with the rtbitmap

