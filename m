Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728D6C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbiLaDFY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbiLaDFX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:05:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E7315816
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:05:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84314B81E5B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487B6C433EF;
        Sat, 31 Dec 2022 03:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455919;
        bh=zPeS1UxEpj1feyJBDz/HvbAlBd1ieN+GIugeL7oTsDQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GtNHlZhqstXnSD7GM5rB2/KRis3668MVYWSY4lDG6LZBHI51xi3AQlN3X1k4FBWeo
         OyrwrACbSDIWi0PVaejwR1q6/Ow6NiG0W+WYhEsQddya/eKvY+kU+bJUSsgnCJRc/b
         ZX3LAww+fEhYZGw6OKINldmT77BalX702wul763Z6vccKAC0JdJl+yCuYhXlpNLO4J
         IS3itI4zrFwMvXuVxHk4cf3tiygtQhr5iVukhtssEynhIxTydalzuJAdi/ep+KJIuT
         TAgODSWLqVnQubprNHpvOUHSfxJZgNgRGuvK6W9hD0+PVOAjU4vU87Ejzelu+dvEH/
         nqSbV6HaFpftA==
Subject: [PATCH 2/3] xfs: fix integer overflow when validating extent size
 hints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:16 -0800
Message-ID: <167243881625.735065.12011702487699537803.stgit@magnolia>
In-Reply-To: <167243881598.735065.1487919004054265294.stgit@magnolia>
References: <167243881598.735065.1487919004054265294.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Both file extent size hints are stored as 32-bit quantities, in units of
filesystem blocks.  As part of validating the hints, we convert these
quantities to bytes to ensure that the hint is congruent with the file's
allocation size.

The maximum possible hint value is 2097151 (aka XFS_MAX_BMBT_EXTLEN).
If the file allocation unit is larger than 2048, the unit conversion
will exceed 32 bits in size, which overflows the uint32_t used to store
the value used in the comparison.  This isn't a problem for files on the
data device since the hint will always be a multiple of the block size.
However, this is a problem for realtime files because the rtextent size
can be any integer number of fs blocks, and truncation of upper bits
changes the outcome of division.

Eliminate the overflow by performing the congruency check in units of
blocks, not bytes.  Otherwise, we get errors like this:

$ truncate -s 500T /tmp/a
$ mkfs.xfs -f -N /tmp/a -d extszinherit=2097151,rtinherit=1 -r extsize=28k
illegal extent size hint 2097151, must be less than 2097151 and a multiple of 7.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_inode_buf.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index ba4df981bd0..866cc187769 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -737,13 +737,11 @@ xfs_inode_validate_extsize(
 	bool				rt_flag;
 	bool				hint_flag;
 	bool				inherit_flag;
-	uint32_t			extsize_bytes;
-	uint32_t			blocksize_bytes;
+	uint32_t			alloc_unit = 1;
 
 	rt_flag = (flags & XFS_DIFLAG_REALTIME);
 	hint_flag = (flags & XFS_DIFLAG_EXTSIZE);
 	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
-	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
 
 	/*
 	 * This comment describes a historic gap in this verifier function.
@@ -772,9 +770,7 @@ xfs_inode_validate_extsize(
 	 */
 
 	if (rt_flag)
-		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
-	else
-		blocksize_bytes = mp->m_sb.sb_blocksize;
+		alloc_unit = mp->m_sb.sb_rextsize;
 
 	if ((hint_flag || inherit_flag) && !(S_ISDIR(mode) || S_ISREG(mode)))
 		return __this_address;
@@ -792,7 +788,7 @@ xfs_inode_validate_extsize(
 	if (mode && !(hint_flag || inherit_flag) && extsize != 0)
 		return __this_address;
 
-	if (extsize_bytes % blocksize_bytes)
+	if (extsize % alloc_unit)
 		return __this_address;
 
 	if (extsize > XFS_MAX_BMBT_EXTLEN)
@@ -827,12 +823,10 @@ xfs_inode_validate_cowextsize(
 {
 	bool				rt_flag;
 	bool				hint_flag;
-	uint32_t			cowextsize_bytes;
-	uint32_t			blocksize_bytes;
+	uint32_t			alloc_unit = 1;
 
 	rt_flag = (flags & XFS_DIFLAG_REALTIME);
 	hint_flag = (flags2 & XFS_DIFLAG2_COWEXTSIZE);
-	cowextsize_bytes = XFS_FSB_TO_B(mp, cowextsize);
 
 	/*
 	 * Similar to extent size hints, a directory can be configured to
@@ -847,9 +841,7 @@ xfs_inode_validate_cowextsize(
 	 */
 
 	if (rt_flag)
-		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
-	else
-		blocksize_bytes = mp->m_sb.sb_blocksize;
+		alloc_unit = mp->m_sb.sb_rextsize;
 
 	if (hint_flag && !xfs_has_reflink(mp))
 		return __this_address;
@@ -864,7 +856,7 @@ xfs_inode_validate_cowextsize(
 	if (mode && !hint_flag && cowextsize != 0)
 		return __this_address;
 
-	if (cowextsize_bytes % blocksize_bytes)
+	if (cowextsize % alloc_unit)
 		return __this_address;
 
 	if (cowextsize > XFS_MAX_BMBT_EXTLEN)

