Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D35BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbiLaBPu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiLaBPt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:15:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A541E2BC4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:15:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4442261D39
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A2FC433EF;
        Sat, 31 Dec 2022 01:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449347;
        bh=8UkypakY+PbI/zJ6e/y7KMHxq0HSS1AeXyyQI34mGrU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gJXDSiYnCa/+vZJPyPRVnOR8upTWsN5Gze/pZljZKHkii+w4gFg7QtJarahnHUJmo
         sib4vqQnAFXAJtgu77b0DycTSZLvmHzZYQtQGOTct3xGRYPs7MK9PDcjASvXXBdU9t
         ExzQB7yXLWjhrQUhlfaMJmYgjU/DyU5uXLf5k7prMgfLS2xcG7/pSWa0jLGrAzy/E7
         D/l66XnS2oQHirds1JipvwVadaJNpKWIjgdogvmPGk8jhIj3tYqXk1XGviTO3uAaCb
         Eeb+itQHvjYO4YN6nBhU/+bLI7dP2yZa3qUWNuL1eOg/nI4w8F4CIlb839uBxH1WBi
         to2dKaAoUgQHg==
Subject: [PATCH 21/23] xfs: teach nlink scrubber to deal with metadata
 directory roots
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:27 -0800
Message-ID: <167243864755.708110.16970195189174285046.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enhance the inode link count online fsck code alter their behavior when
they detect metadata directory tree roots, just like they do for the
regular root directory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/nlinks.c        |   12 +++++++-----
 fs/xfs/scrub/nlinks_repair.c |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index dca759d27ac4..5325bb0e196e 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -282,7 +282,7 @@ xchk_nlinks_collect_dirent(
 	 * Otherwise, increment the number of backrefs pointing back to ino.
 	 */
 	if (dotdot) {
-		if (dp == sc->mp->m_rootip)
+		if (dp == sc->mp->m_rootip || dp == sc->mp->m_metadirip)
 			error = xchk_nlinks_update_incore(xnc, ino, 1, 0, 0);
 		else
 			error = xchk_nlinks_update_incore(xnc, ino, 0, 1, 0);
@@ -458,9 +458,11 @@ xchk_nlinks_collect(
 	int			error;
 
 	/* Count the rt and quota files that are rooted in the superblock. */
-	error = xchk_nlinks_collect_metafiles(xnc);
-	if (error)
-		return error;
+	if (!xfs_has_metadir(sc->mp)) {
+		error = xchk_nlinks_collect_metafiles(xnc);
+		if (error)
+			return error;
+	}
 
 	/*
 	 * Set up for a potentially lengthy filesystem scan by reducing our
@@ -648,7 +650,7 @@ xchk_nlinks_compare_inode(
 			xchk_ino_set_corrupt(sc, ip->i_ino);
 	}
 
-	if (ip == sc->mp->m_rootip) {
+	if (ip == sc->mp->m_rootip || ip == sc->mp->m_metadirip) {
 		/*
 		 * For the root of a directory tree, both the '.' and '..'
 		 * entries should point to the root directory.  The dot entry
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index f881e5dbd432..055eb4b67053 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -86,7 +86,7 @@ xrep_nlinks_is_orphaned(
 
 	if (obs->parents != 0)
 		return false;
-	if (ip == mp->m_rootip || ip == sc->orphanage)
+	if (ip == mp->m_rootip || ip == sc->orphanage || ip == mp->m_metadirip)
 		return false;
 	return actual_nlink != 0;
 }

