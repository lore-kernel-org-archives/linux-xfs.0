Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A57F3C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiF1Use (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiF1Use (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:48:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641C12A953
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:48:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02A626184D
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4D6C341C8;
        Tue, 28 Jun 2022 20:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449312;
        bh=xfkw3eKaNjbFiHH9y+tMHMThhW2gamD4h2DEcFdxeDc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JQUiCUw3OdN2nxNmgymn1KCqh3ohGVq4IQ3uOgvZzg/8+pzZWvkpRmzAjimG+GdS1
         6/r8BppKOTnHX8RrdSCR1kka4DOHhE+OMfb2HU1NMrf+NKl4/CZOI7IB4db1pS4h/q
         3B3GuMdnORdEKPpu0/Y93i4jbg4j0vvQNj6oDqbQ3Rw+s6Pbt3CQ2Jj53bn0L1ekSU
         Xp+VqA5cqQRO6Gpy3Ubo8o085ner9lmdWG68jDiY0i5Vma71yxLVLZmBU95qoAFSqn
         fqxrEFEmk8iMHdcDXG1jxtyqh/2xj8krN5dyaHP4YfpbGdLjzAtIt6+KFzvG3Iuw1Z
         8nWhQlPHAskyg==
Subject: [PATCH 1/8] misc: fix unsigned integer comparison complaints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:48:31 -0700
Message-ID: <165644931191.1089724.14586418293765469096.stgit@magnolia>
In-Reply-To: <165644930619.1089724.12201433387040577983.stgit@magnolia>
References: <165644930619.1089724.12201433387040577983.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

gcc 11.2 complains about certain variables now that xfs_extnum_t is an
unsigned 64-bit integer:

dinode.c: In function ‘process_exinode’:
dinode.c:960:21: error: comparison of unsigned expression in ‘< 0’ is always false [-Werror=type-limits]
  960 |         if (numrecs < 0)

Since we actually have a function that will tell us the maximum
supported extent count for an ondisk dinode structure, use a direct
comparison instead of tricky integer math to detect overflows.  A more
exhaustive audit is probably necessary.

IOWS, shut up, gcc...

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c      |   10 +++++++---
 db/metadump.c   |   11 +++++++----
 repair/dinode.c |   14 ++++++++++----
 3 files changed, 24 insertions(+), 11 deletions(-)


diff --git a/db/check.c b/db/check.c
index fb28994d..c9149daa 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2711,14 +2711,18 @@ process_exinode(
 	int			whichfork)
 {
 	xfs_bmbt_rec_t		*rp;
+	xfs_extnum_t		max_nex;
 
 	rp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 	*nex = xfs_dfork_nextents(dip, whichfork);
-	if (*nex < 0 || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
+	max_nex = xfs_iext_max_nextents(
+			xfs_dinode_has_large_extent_counts(dip),
+			whichfork);
+	if (*nex > max_nex || *nex > XFS_DFORK_SIZE(dip, mp, whichfork) /
 						sizeof(xfs_bmbt_rec_t)) {
 		if (!sflag || id->ilist)
-			dbprintf(_("bad number of extents %d for inode %lld\n"),
-				*nex, id->ino);
+			dbprintf(_("bad number of extents %llu for inode %lld\n"),
+				(unsigned long long)*nex, id->ino);
 		error++;
 		return;
 	}
diff --git a/db/metadump.c b/db/metadump.c
index 999c68f7..27d1df43 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2278,16 +2278,19 @@ process_exinode(
 {
 	int			whichfork;
 	int			used;
-	xfs_extnum_t		nex;
+	xfs_extnum_t		nex, max_nex;
 
 	whichfork = (itype == TYP_ATTR) ? XFS_ATTR_FORK : XFS_DATA_FORK;
 
 	nex = xfs_dfork_nextents(dip, whichfork);
+	max_nex = xfs_iext_max_nextents(
+			xfs_dinode_has_large_extent_counts(dip),
+			whichfork);
 	used = nex * sizeof(xfs_bmbt_rec_t);
-	if (nex < 0 || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
+	if (nex > max_nex || used > XFS_DFORK_SIZE(dip, mp, whichfork)) {
 		if (show_warnings)
-			print_warning("bad number of extents %d in inode %lld",
-				nex, (long long)cur_ino);
+			print_warning("bad number of extents %llu in inode %lld",
+				(unsigned long long)nex, (long long)cur_ino);
 		return 1;
 	}
 
diff --git a/repair/dinode.c b/repair/dinode.c
index 04e7f83e..00de31fb 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -942,7 +942,7 @@ process_exinode(
 	xfs_bmbt_rec_t		*rp;
 	xfs_fileoff_t		first_key;
 	xfs_fileoff_t		last_key;
-	xfs_extnum_t		numrecs;
+	xfs_extnum_t		numrecs, max_numrecs;
 	int			ret;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
@@ -956,7 +956,10 @@ process_exinode(
 	 * be in the range of valid on-disk numbers, which is:
 	 *	0 < numrecs < 2^31 - 1
 	 */
-	if (numrecs < 0)
+	max_numrecs = xfs_iext_max_nextents(
+			xfs_dinode_has_large_extent_counts(dip),
+			whichfork);
+	if (numrecs > max_numrecs)
 		numrecs = *nex;
 
 	/*
@@ -1899,7 +1902,7 @@ process_inode_data_fork(
 {
 	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	int			err = 0;
-	xfs_extnum_t		nex;
+	xfs_extnum_t		nex, max_nex;
 
 	/*
 	 * extent count on disk is only valid for positive values. The kernel
@@ -1907,7 +1910,10 @@ process_inode_data_fork(
 	 * here, trash it!
 	 */
 	nex = xfs_dfork_data_extents(dino);
-	if (nex < 0)
+	max_nex = xfs_iext_max_nextents(
+			xfs_dinode_has_large_extent_counts(dino),
+			XFS_DATA_FORK);
+	if (nex > max_nex)
 		*nextents = 1;
 	else
 		*nextents = nex;

