Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DE7EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjG0Wd1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbjG0Wd0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:33:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5C13590
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:32:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A1B161F70
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADCDC433C7;
        Thu, 27 Jul 2023 22:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690497158;
        bh=G1sGSLoZMwloHmawlDprsF2kvMlQf/tk+DodZvMhgRc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=DRUm7QQxvIv9hReCnbKiEjXwkBnUQcBEwu/8we/017la3sYElg5J4rWCwa8A6gNBg
         cL7lwQ6cuVn/1m+8I4qGi3FrgKlgvlGIbtpmtb3VWRDjNS5LFYu4kPfUQw06FmAxwT
         Po+tzSM+TeUcOdE80D3QMK5QYQfF1kamGnEWSB8VdZooeNsUXfk5vtynR5yozLI0uf
         /P2jp4NyWcu8kKivsjzGszNEkrjBfBqHza36oGV4HcvXnV6Qg6NgoyfRBT8fEd2iDh
         7eHdLysJJDjM2j5giYcXT7ga82+89Npo1T6uD7u60cw6F+Ge1B6Ue/3CirPBtk++fM
         TIgp9t8q5/6IQ==
Date:   Thu, 27 Jul 2023 15:32:38 -0700
Subject: [PATCH 2/6] xfs: try to attach dquots to files before repairing them
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049626469.922543.13796599557453030731.stgit@frogsfrogsfrogs>
In-Reply-To: <169049626432.922543.2560381879385116722.stgit@frogsfrogsfrogs>
References: <169049626432.922543.2560381879385116722.stgit@frogsfrogsfrogs>
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
index 75588915572e9..76aa40fef84ad 100644
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
index 52fa0028c7ba0..32e599b6546cb 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -818,6 +818,26 @@ xchk_iget_agi(
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
@@ -1029,6 +1049,11 @@ xchk_setup_inode_contents(
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
index b26b0ea3ea5a1..b7a86ffd21060 100644
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
index 59d7912fb75f1..6b6d912c710eb 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -38,6 +38,10 @@ xchk_prepare_iscrub(
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
index 546e8423a9165..a7fd91e774fe0 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -710,10 +710,10 @@ xrep_force_quotacheck(
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
@@ -721,7 +721,10 @@ xrep_ino_dqattach(
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
index 008ddb599e132..7a64489fe9c54 100644
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
index 437ed9acbb273..55d79050e6734 100644
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

