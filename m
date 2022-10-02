Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5C8C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiJBSeX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiJBSeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:34:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6016A3C173
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:34:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 058FBB80D88
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9906C433C1;
        Sun,  2 Oct 2022 18:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735657;
        bh=RrS2WgVw4mHXam8YnVpXEkxI+ac4hDCWSYII2RTLedI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nKxEh+iyyHoJb5kvRSCgiJQfe1uglITtYM7QZFyTjs5Pzphw6scQx2bpe6IEB+LbE
         Tduk17s+7+BzZsAFvv788/4+Ip3+dbnashxPG/udk9y2XsNk/0WM/D3ItXzw9ZBBe4
         s8JQmDWStwcsJzYTloZ1fH8Hphve6CwInmsb5cf2Q96qijV1hd2zAkzizW6mBibQPQ
         XZgKVtI/yOUR7EP28AW/k/3BXJ7dT40l8F6oAKdTfP2qCm0CugdXga9jWrmIW2xzVt
         63g/PGEmqGx6MvJJ4+9jjvoIxfcG+/pyN2zSUxv+CV+neOAFowRcTkoQvVDbgInoNp
         CpYhzy9A8UBJQ==
Subject: [PATCH 2/2] xfs: check inode core when scrubbing metadata files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:26 -0700
Message-ID: <166473482636.1084588.10974246607672500827.stgit@magnolia>
In-Reply-To: <166473482605.1084588.1965700384229898125.stgit@magnolia>
References: <166473482605.1084588.1965700384229898125.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Metadata files (e.g. realtime bitmaps and quota files) do not show up in
the bulkstat output, which means that scrub-by-handle does not work;
they can only be checked through a specific scrub type.  Therefore, each
scrub type calls xchk_metadata_inode_forks to check the metadata for
whatever's in the file.

Unfortunately, that function doesn't actually check the inode record
itself.  Refactor the function a bit to make that happen.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |   40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 60c4d33fe6f5..73ac38c1126e 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -866,6 +866,33 @@ xchk_buffer_recheck(
 	trace_xchk_block_error(sc, xfs_buf_daddr(bp), fa);
 }
 
+static inline int
+xchk_metadata_inode_subtype(
+	struct xfs_scrub	*sc,
+	unsigned int		scrub_type)
+{
+	__u32			smtype = sc->sm->sm_type;
+	int			error;
+
+	sc->sm->sm_type = scrub_type;
+
+	switch (scrub_type) {
+	case XFS_SCRUB_TYPE_INODE:
+		error = xchk_inode(sc);
+		break;
+	case XFS_SCRUB_TYPE_BMBTD:
+		error = xchk_bmap_data(sc);
+		break;
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+		break;
+	}
+
+	sc->sm->sm_type = smtype;
+	return error;
+}
+
 /*
  * Scrub the attr/data forks of a metadata inode.  The metadata inode must be
  * pointed to by sc->ip and the ILOCK must be held.
@@ -874,13 +901,17 @@ int
 xchk_metadata_inode_forks(
 	struct xfs_scrub	*sc)
 {
-	__u32			smtype;
 	bool			shared;
 	int			error;
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return 0;
 
+	/* Check the inode record. */
+	error = xchk_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_INODE);
+	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		return error;
+
 	/* Metadata inodes don't live on the rt device. */
 	if (sc->ip->i_diflags & XFS_DIFLAG_REALTIME) {
 		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
@@ -900,10 +931,7 @@ xchk_metadata_inode_forks(
 	}
 
 	/* Invoke the data fork scrubber. */
-	smtype = sc->sm->sm_type;
-	sc->sm->sm_type = XFS_SCRUB_TYPE_BMBTD;
-	error = xchk_bmap_data(sc);
-	sc->sm->sm_type = smtype;
+	error = xchk_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTD);
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
@@ -918,7 +946,7 @@ xchk_metadata_inode_forks(
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 	}
 
-	return error;
+	return 0;
 }
 
 /*

