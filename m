Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D935C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjEZBjP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZBjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:39:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43745189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD7C364C02
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383D6C433EF;
        Fri, 26 May 2023 01:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065152;
        bh=LfhzzkCoqRzs22rD5p6Wy577BWpDLUQtMmoIrbN4aPo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ki3yMTiVpqwrJEayNaKXZsXq//i/o/4Ws//Q1Yx7LUQ2gpiHJda53YfoK8sHb/8Eq
         jfm7tABfNombVtgscE9hMw26gZYZe+dslK/+IOZXbk5vEaSyrgVqDcNkVMMzVSIzr+
         N1PV14Kb+j1XaDl2DHqsqwxXVuFTHwUMMHYNXrZsfu89zOAYOmaHMoGK7oRqAFrkLa
         JZGlzDAPrNGRyQXcyabZ5bY72PgZUZgOMPCY+HlnxNTENZL5vfqR/fdBN3jICevRdB
         m+jIiKO0KJ/JhIlcRW5fFigJb1OVnpqyndzYuDfhGOUzyjKQ9GAsecLk5pAH3Gapbc
         BJKPJWKZop41Q==
Date:   Thu, 25 May 2023 18:39:11 -0700
Subject: [PATCH 2/3] xfs: try to avoid allocating from sick inode clusters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506069400.3738323.18238804142684543994.stgit@frogsfrogsfrogs>
In-Reply-To: <168506069368.3738323.11092090063491926432.stgit@frogsfrogsfrogs>
References: <168506069368.3738323.11092090063491926432.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I noticed that xfs/413 and xfs/375 occasionally failed while fuzzing
core.mode of an inode.  The root cause of these problems is that the
field we fuzzed (core.mode or core.magic, typically) causes the entire
inode cluster buffer verification to fail, which affects several inodes
at once.  The repair process tries to create either a /lost+found or a
temporary repair file, but regrettably it picks the same inode cluster
that we just corrupted, with the result that repair triggers the demise
of the filesystem.

Try avoid this by making the inode allocation path detect when the perag
health status indicates that someone has found bad inode cluster
buffers, and try to read the inode cluster buffer.  If the cluster
buffer fails the verifiers, try another AG.  This isn't foolproof and
can result in premature ENOSPC, but that might be better than shutting
down.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 7d501a4a529b..bbc3d9a8e1c7 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1022,6 +1022,33 @@ xfs_inobt_first_free_inode(
 	return xfs_lowbit64(realfree);
 }
 
+/*
+ * If this AG has corrupt inodes, check if allocating this inode would fail
+ * with corruption errors.  Returns 0 if we're clear, or EAGAIN to try again
+ * somewhere else.
+ */
+static int
+xfs_dialloc_check_ino(
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino)
+{
+	struct xfs_imap		imap;
+	struct xfs_buf		*bp;
+	int			error;
+
+	error = xfs_imap(pag, tp, ino, &imap, 0);
+	if (error)
+		return -EAGAIN;
+
+	error = xfs_imap_to_bp(pag->pag_mount, tp, &imap, &bp);
+	if (error)
+		return -EAGAIN;
+
+	xfs_trans_brelse(tp, bp);
+	return 0;
+}
+
 /*
  * Allocate an inode using the inobt-only algorithm.
  */
@@ -1274,6 +1301,13 @@ xfs_dialloc_ag_inobt(
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
 	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, rec.ir_startino + offset);
+
+	if (xfs_ag_has_sickness(pag, XFS_SICK_AG_INODES)) {
+		error = xfs_dialloc_check_ino(pag, tp, ino);
+		if (error)
+			goto error0;
+	}
+
 	rec.ir_free &= ~XFS_INOBT_MASK(offset);
 	rec.ir_freecount--;
 	error = xfs_inobt_update(cur, &rec);
@@ -1549,6 +1583,12 @@ xfs_dialloc_ag(
 				   XFS_INODES_PER_CHUNK) == 0);
 	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, rec.ir_startino + offset);
 
+	if (xfs_ag_has_sickness(pag, XFS_SICK_AG_INODES)) {
+		error = xfs_dialloc_check_ino(pag, tp, ino);
+		if (error)
+			goto error_cur;
+	}
+
 	/*
 	 * Modify or remove the finobt record.
 	 */

