Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA1DEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbjG0Wbx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbjG0Wbx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:31:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8174B2D63
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:31:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F2FF61F1F
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779C3C433C8;
        Thu, 27 Jul 2023 22:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690497111;
        bh=r5l89uIBW///dwuOYzlUQfuScLrr4/gGk+CRF7iqvE4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Bz6LK1dQEJwTp+QcPaOPvi12YZAJHQ5JJHzq7AYy7bTeuABWEzUq+WnAP/6L+qyxM
         /Kcmbv5of2IQWZsnPdL5nCtg+3n70LeTRDuq3he/xpviBPcGgjJD7ztUyvCc/T5cWZ
         m68bUzHcuzGai8aDBkxELUh72pjNyV9kZ2eAl5lCPfWQXcqASK7ZMb6/cf2yiHwUdH
         8fd42QY7+ZHpvhiee9dHHf7JhsbFXwVOV0O2ahiK4s+Ud8LJ6Yqd5S7JF+bBQ3prgm
         jiWhEMMK4AWq5TLNdSWBVriCojbFgCemHfu6TEDepmuwowaQjBJcPLhcjzSmc7sl3n
         leHqJte9fiYLA==
Date:   Thu, 27 Jul 2023 15:31:50 -0700
Subject: [PATCH 1/2] xfs: simplify returns in xchk_bmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049626092.922440.13511873574225817381.stgit@frogsfrogsfrogs>
In-Reply-To: <169049626076.922440.10606459711846791721.stgit@frogsfrogsfrogs>
References: <169049626076.922440.10606459711846791721.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove the pointless goto and return code in xchk_bmap, since it only
serves to obscure what's going on in the function.  Instead, return
whichever error code is appropriate there.  For nonexistent forks,
this should have been ENOENT.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 20ab5d4e92ffb..f1e732d4fefdf 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -841,7 +841,7 @@ xchk_bmap(
 
 	/* Non-existent forks can be ignored. */
 	if (!ifp)
-		goto out;
+		return -ENOENT;
 
 	info.is_rt = whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
 	info.whichfork = whichfork;
@@ -853,7 +853,7 @@ xchk_bmap(
 		/* No CoW forks on non-reflink inodes/filesystems. */
 		if (!xfs_is_reflink_inode(ip)) {
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
-			goto out;
+			return 0;
 		}
 		break;
 	case XFS_ATTR_FORK:
@@ -873,31 +873,31 @@ xchk_bmap(
 		/* No mappings to check. */
 		if (whichfork == XFS_COW_FORK)
 			xchk_fblock_set_corrupt(sc, whichfork, 0);
-		goto out;
+		return 0;
 	case XFS_DINODE_FMT_EXTENTS:
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (whichfork == XFS_COW_FORK) {
 			xchk_fblock_set_corrupt(sc, whichfork, 0);
-			goto out;
+			return 0;
 		}
 
 		error = xchk_bmap_btree(sc, whichfork, &info);
 		if (error)
-			goto out;
+			return error;
 		break;
 	default:
 		xchk_fblock_set_corrupt(sc, whichfork, 0);
-		goto out;
+		return 0;
 	}
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		goto out;
+		return 0;
 
 	/* Find the offset of the last extent in the mapping. */
 	error = xfs_bmap_last_offset(ip, &endoff, whichfork);
 	if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
-		goto out;
+		return error;
 
 	/*
 	 * Scrub extent records.  We use a special iterator function here that
@@ -910,12 +910,12 @@ xchk_bmap(
 	while (xchk_bmap_iext_iter(&info, &irec)) {
 		if (xchk_should_terminate(sc, &error) ||
 		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
-			goto out;
+			return 0;
 
 		if (irec.br_startoff >= endoff) {
 			xchk_fblock_set_corrupt(sc, whichfork,
 					irec.br_startoff);
-			goto out;
+			return 0;
 		}
 
 		if (isnullstartblock(irec.br_startblock))
@@ -928,10 +928,10 @@ xchk_bmap(
 	if (xchk_bmap_want_check_rmaps(&info)) {
 		error = xchk_bmap_check_rmaps(sc, whichfork);
 		if (!xchk_fblock_xref_process_error(sc, whichfork, 0, &error))
-			goto out;
+			return error;
 	}
-out:
-	return error;
+
+	return 0;
 }
 
 /* Scrub an inode's data fork. */

