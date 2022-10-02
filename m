Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E15C5C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiJBS2Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJBS2X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:28:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FCD3BC46
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:28:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A9EBB80D7E
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC333C433C1;
        Sun,  2 Oct 2022 18:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735298;
        bh=ktZ1I+BthTCnkZI7QjhaMEgKhQoJ2pHwCzcN7asYcSE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SWN0RE3U6nRiR0Ipeo8Qp+LiBQSVbhG9xUvVRBvxt4T98yz2cmiBCd00z1RNQ37KP
         YTaoJn8ntFAloM+YNb1oh+u079uetscTqBrIlDi5IECHOyqi9vayTYAEB2JEp1FoHf
         rdbfco0JoFoP6tdeeaCP73tuAuOCpengUVeZBG50q39yXUAJDWd6rXYRPh66qai1c1
         rT12W1Lvn36ImbBaWxUlf/PlFUwJUzEX8M+ItrVdfJL/BT1on2fgnI8V8IR4PQIh1H
         ccFjBDUIMoTj6oImLY5vW7LCsc51Z/8tFNIPQHlIvhgacmVZEUZWsA2+lXx0N+KWJJ
         qxDI4f1xh6pHQ==
Subject: [PATCH 1/2] xfs: standardize GFP flags usage in online scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:52 -0700
Message-ID: <166473479206.1083296.4351345740736162376.stgit@magnolia>
In-Reply-To: <166473479188.1083296.3778962206344152398.stgit@magnolia>
References: <166473479188.1083296.3778962206344152398.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Memory allocation usage is the same throughout online fsck -- we want
kernel memory, we have to be able to back out if we can't allocate
memory, and we don't want to spray dmesg with memory allocation failure
reports.  Standardize the GFP flag usage and document these requirements.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c |    2 +-
 fs/xfs/scrub/attr.c     |    9 ++++-----
 fs/xfs/scrub/scrub.h    |    9 +++++++++
 fs/xfs/scrub/symlink.c  |    2 +-
 4 files changed, 15 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index af284baa6f4c..4dd52b15f09c 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -737,7 +737,7 @@ xchk_agfl(
 		goto out;
 	}
 	sai.entries = kvcalloc(sai.agflcount, sizeof(xfs_agblock_t),
-			GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+			       XCHK_GFP_FLAGS);
 	if (!sai.entries) {
 		error = -ENOMEM;
 		goto out;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index b6f0c9f3f124..11b2593a2be7 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -79,7 +79,8 @@ xchk_setup_xattr(
 	 * without the inode lock held, which means we can sleep.
 	 */
 	if (sc->flags & XCHK_TRY_HARDER) {
-		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX, GFP_KERNEL);
+		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX,
+				XCHK_GFP_FLAGS);
 		if (error)
 			return error;
 	}
@@ -138,8 +139,7 @@ xchk_xattr_listent(
 	 * doesn't work, we overload the seen_enough variable to convey
 	 * the error message back to the main scrub function.
 	 */
-	error = xchk_setup_xattr_buf(sx->sc, valuelen,
-			GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	error = xchk_setup_xattr_buf(sx->sc, valuelen, XCHK_GFP_FLAGS);
 	if (error == -ENOMEM)
 		error = -EDEADLOCK;
 	if (error) {
@@ -324,8 +324,7 @@ xchk_xattr_block(
 		return 0;
 
 	/* Allocate memory for block usage checking. */
-	error = xchk_setup_xattr_buf(ds->sc, 0,
-			GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	error = xchk_setup_xattr_buf(ds->sc, 0, XCHK_GFP_FLAGS);
 	if (error == -ENOMEM)
 		return -EDEADLOCK;
 	if (error)
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 151567f88366..a0f097b8acb0 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -8,6 +8,15 @@
 
 struct xfs_scrub;
 
+/*
+ * Standard flags for allocating memory within scrub.  NOFS context is
+ * configured by the process allocation scope.  Scrub and repair must be able
+ * to back out gracefully if there isn't enough memory.  Force-cast to avoid
+ * complaints from static checkers.
+ */
+#define XCHK_GFP_FLAGS	((__force gfp_t)(GFP_KERNEL | __GFP_NOWARN | \
+					 __GFP_RETRY_MAYFAIL))
+
 /* Type info and names for the scrub types. */
 enum xchk_type {
 	ST_NONE = 1,	/* disabled */
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 75311f8daeeb..c1c99ffe7408 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -21,7 +21,7 @@ xchk_setup_symlink(
 	struct xfs_scrub	*sc)
 {
 	/* Allocate the buffer without the inode lock held. */
-	sc->buf = kvzalloc(XFS_SYMLINK_MAXLEN + 1, GFP_KERNEL);
+	sc->buf = kvzalloc(XFS_SYMLINK_MAXLEN + 1, XCHK_GFP_FLAGS);
 	if (!sc->buf)
 		return -ENOMEM;
 

