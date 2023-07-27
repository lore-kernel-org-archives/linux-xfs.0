Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE14EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjG0W2P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbjG0W2O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:28:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4862696
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB6E761F3E
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C143C433C7;
        Thu, 27 Jul 2023 22:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496892;
        bh=hRGR04pvnhrYjF0qEhdvWOXBynvFK9qOeso45/ca0ug=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rHJL/tOmc3qxlUG8PpPiQrJrs1hX1a7io2anoiaNJ8zukMHLhoMDz1OWBGlmbo0xA
         iSfLXjIQa3RfXunyv5p9ng/qHfNgDSMqbOO9D05wAme6GoITHbGuX117MI7SRw0QMS
         XMMLkebwrxUu+eou3B7hLwkVJq1IulFQG8Jbj5dHZ9NdmOCT1JNNw9ZckYHV3Uhahu
         F6nba2LXLV6mfjzpcvejt1zA6uvCw9LqPHUPryymvRRUr4n8lF46j7PH2oVw0oblPi
         Jb52ga0kP/nKSGTTxVpyzQmebyuUY8gTbtRD3C4HWtX/GGsJTKO2xn+q7GEDgakXC+
         7AHdWap49gHpQ==
Date:   Thu, 27 Jul 2023 15:28:11 -0700
Subject: [PATCH 2/4] xfs: wrap ilock/iunlock operations on sc->ip
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049624332.921804.11477958345667526789.stgit@frogsfrogsfrogs>
In-Reply-To: <169049624299.921804.11447029742535329810.stgit@frogsfrogsfrogs>
References: <169049624299.921804.11447029742535329810.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Scrub tracks the resources that it's holding onto in the xfs_scrub
structure.  This includes the inode being checked (if applicable) and
the inode lock state of that inode.  Replace the open-coded structure
manipulation with a trivial helper to eliminate sources of error.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/bmap.c     |    9 +++------
 fs/xfs/scrub/common.c   |   38 +++++++++++++++++++++++++++++++++-----
 fs/xfs/scrub/common.h   |    5 +++++
 fs/xfs/scrub/inode.c    |    6 ++----
 fs/xfs/scrub/parent.c   |    4 ++--
 fs/xfs/scrub/quota.c    |    9 +++------
 fs/xfs/scrub/rtbitmap.c |    9 ++++-----
 fs/xfs/scrub/scrub.c    |    2 +-
 8 files changed, 53 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 5bf4326e97836..20ab5d4e92ffb 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -38,8 +38,7 @@ xchk_setup_inode_bmap(
 	if (error)
 		goto out;
 
-	sc->ilock_flags = XFS_IOLOCK_EXCL;
-	xfs_ilock(sc->ip, XFS_IOLOCK_EXCL);
+	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
 	/*
 	 * We don't want any ephemeral data/cow fork updates sitting around
@@ -50,8 +49,7 @@ xchk_setup_inode_bmap(
 	    sc->sm->sm_type != XFS_SCRUB_TYPE_BMBTA) {
 		struct address_space	*mapping = VFS_I(sc->ip)->i_mapping;
 
-		sc->ilock_flags |= XFS_MMAPLOCK_EXCL;
-		xfs_ilock(sc->ip, XFS_MMAPLOCK_EXCL);
+		xchk_ilock(sc, XFS_MMAPLOCK_EXCL);
 
 		inode_dio_wait(VFS_I(sc->ip));
 
@@ -79,9 +77,8 @@ xchk_setup_inode_bmap(
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		goto out;
-	sc->ilock_flags |= XFS_ILOCK_EXCL;
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
 
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
 out:
 	/* scrub teardown will unlock and release the inode */
 	return error;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index bcec584742e73..a769063f84841 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1023,20 +1023,48 @@ xchk_setup_inode_contents(
 		return error;
 
 	/* Lock the inode so the VFS cannot touch this file. */
-	sc->ilock_flags = XFS_IOLOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
 	error = xchk_trans_alloc(sc, resblks);
 	if (error)
 		goto out;
-	sc->ilock_flags |= XFS_ILOCK_EXCL;
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
-
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
 out:
 	/* scrub teardown will unlock and release the inode for us */
 	return error;
 }
 
+void
+xchk_ilock(
+	struct xfs_scrub	*sc,
+	unsigned int		ilock_flags)
+{
+	xfs_ilock(sc->ip, ilock_flags);
+	sc->ilock_flags |= ilock_flags;
+}
+
+bool
+xchk_ilock_nowait(
+	struct xfs_scrub	*sc,
+	unsigned int		ilock_flags)
+{
+	if (xfs_ilock_nowait(sc->ip, ilock_flags)) {
+		sc->ilock_flags |= ilock_flags;
+		return true;
+	}
+
+	return false;
+}
+
+void
+xchk_iunlock(
+	struct xfs_scrub	*sc,
+	unsigned int		ilock_flags)
+{
+	sc->ilock_flags &= ~ilock_flags;
+	xfs_iunlock(sc->ip, ilock_flags);
+}
+
 /*
  * Predicate that decides if we need to evaluate the cross-reference check.
  * If there was an error accessing the cross-reference btree, just delete
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 065d4bbd77ec7..6495a39e91230 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -138,6 +138,11 @@ int xchk_setup_ag_btree(struct xfs_scrub *sc, bool force_log);
 int xchk_iget_for_scrubbing(struct xfs_scrub *sc);
 int xchk_setup_inode_contents(struct xfs_scrub *sc, unsigned int resblks);
 int xchk_install_live_inode(struct xfs_scrub *sc, struct xfs_inode *ip);
+
+void xchk_ilock(struct xfs_scrub *sc, unsigned int ilock_flags);
+bool xchk_ilock_nowait(struct xfs_scrub *sc, unsigned int ilock_flags);
+void xchk_iunlock(struct xfs_scrub *sc, unsigned int ilock_flags);
+
 void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
 
 int xchk_iget(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp);
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 1d8097f777603..59d7912fb75f1 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -32,15 +32,13 @@ xchk_prepare_iscrub(
 {
 	int			error;
 
-	sc->ilock_flags = XFS_IOLOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
 
-	sc->ilock_flags |= XFS_ILOCK_EXCL;
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 58d5dfb7ea21b..e6155d86f7916 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -150,8 +150,8 @@ xchk_parent_validate(
 
 	lock_mode = xchk_parent_ilock_dir(dp);
 	if (!lock_mode) {
-		xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
-		xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+		xchk_iunlock(sc, XFS_ILOCK_EXCL);
+		xchk_ilock(sc, XFS_ILOCK_EXCL);
 		error = -EAGAIN;
 		goto out_rele;
 	}
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 19bf7f1182d4e..5671c81534335 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -64,8 +64,7 @@ xchk_setup_quota(
 	if (error)
 		return error;
 
-	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
-	sc->ilock_flags = XFS_ILOCK_EXCL;
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	return 0;
 }
 
@@ -239,13 +238,11 @@ xchk_quota(
 	 * data fork we have to drop ILOCK_EXCL to use the regular dquot
 	 * functions.
 	 */
-	xfs_iunlock(sc->ip, sc->ilock_flags);
-	sc->ilock_flags = 0;
+	xchk_iunlock(sc, sc->ilock_flags);
 	sqi.sc = sc;
 	sqi.last_id = 0;
 	error = xfs_qm_dqiterate(mp, dqtype, xchk_quota_item, &sqi);
-	sc->ilock_flags = XFS_ILOCK_EXCL;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	if (error == -ECANCELED)
 		error = 0;
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK,
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 3bd4d0af94f78..d42e5fc20ebd0 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -32,8 +32,7 @@ xchk_setup_rt(
 	if (error)
 		return error;
 
-	sc->ilock_flags = XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
 	return 0;
 }
 
@@ -143,8 +142,8 @@ xchk_rtsummary(
 	 * flags so that we don't mix up the inode state that @sc tracks.
 	 */
 	sc->ip = rsumip;
-	sc->ilock_flags = XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM;
-	xfs_ilock(sc->ip, sc->ilock_flags);
+	sc->ilock_flags = 0;
+	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
 
 	/* Invoke the fork scrubber. */
 	error = xchk_metadata_inode_forks(sc);
@@ -155,7 +154,7 @@ xchk_rtsummary(
 	xchk_set_incomplete(sc);
 out:
 	/* Switch back to the rtbitmap inode and lock flags. */
-	xfs_iunlock(sc->ip, sc->ilock_flags);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
 	sc->ilock_flags = old_ilock_flags;
 	sc->ip = old_ip;
 	return error;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 2fa651ff8f5dc..d2a91251add74 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -179,7 +179,7 @@ xchk_teardown(
 	}
 	if (sc->ip) {
 		if (sc->ilock_flags)
-			xfs_iunlock(sc->ip, sc->ilock_flags);
+			xchk_iunlock(sc, sc->ilock_flags);
 		xchk_irele(sc, sc->ip);
 		sc->ip = NULL;
 	}

