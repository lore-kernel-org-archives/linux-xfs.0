Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA2BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbiLaDEG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236186AbiLaDEF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:04:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9CE15816
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:04:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E32D0B81E5B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EACC433D2;
        Sat, 31 Dec 2022 03:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455841;
        bh=+bGROqjw1ozNwps2kYH0orpU7ULbVr08CWj42zwYVSw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y9dIom9EOIKtDvAibVa/e91OT/blpKmKchvLARm1r/85JKU4iuG5jHN0SieSztd0e
         WATXDYGUE/EJa1aYzJNpm2RGJGnM1FMTitxeO0dFI2c+/kn6gzAnBekhRweFlqvbaD
         iAQczKO3jXutMMIwIp/ePxXdlYjGMguRNrsX5Lir7zc+s8WU8Wje3PLOWpiIbrN2dG
         mfDi4vUhflkfxnfl9CvfpjecY/8c3cX83a6IgRu+NcTs2zqtZvFGmvzI3IHn66B58v
         w+OE4dK7LANLZbijEgJxbvLiCRlFheur3SD/drNkN4PF9x6NLTWzV8Zk+sZ/0/lFoW
         lYKZwf2cEXwTQ==
Subject: [PATCH 38/41] xfs_repair: validate CoW extent size hint on rtinherit
 directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:12 -0800
Message-ID: <167243881273.734096.17578213689785399379.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

XFS allows a sysadmin to change the rt extent size when adding a rt
section to a filesystem after formatting.  If there are any directories
with both a cowextsize hint and rtinherit set, the hint could become
misaligned with the new rextsize.  Offer to fix the problem if we're in
modify mode and the verifier didn't trip.  If we're in dry run mode,
we let the kernel fix it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   64 +++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 21 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 09cef18f2e9..db049415af4 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2795,6 +2795,47 @@ _("Bad extent size hint %u on inode %" PRIu64 ", "),
 	}
 }
 
+static void
+validate_cowextsize(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dino,
+	xfs_ino_t		lino,
+	int			*dirty)
+{
+	uint16_t		flags = be16_to_cpu(dino->di_flags);
+	uint64_t		flags2 = be64_to_cpu(dino->di_flags2);
+	unsigned int		value = be32_to_cpu(dino->di_cowextsize);
+	bool			misaligned = false;
+	bool			bad;
+
+	/*
+	 * XFS allows a sysadmin to change the rt extent size when adding a
+	 * rt section to a filesystem after formatting.  If there are any
+	 * directories with both a cowextsize hint and rtinherit set, the
+	 * hint could become misaligned with the new rextsize.
+	 */
+	if ((flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    (flags & XFS_DIFLAG_RTINHERIT) &&
+	    value % mp->m_sb.sb_rextsize > 0)
+		misaligned = true;
+
+	/* Complain if the verifier fails. */
+	bad = libxfs_inode_validate_cowextsize(mp, value,
+			be16_to_cpu(dino->di_mode), flags, flags2) != NULL;
+	if (bad || misaligned) {
+		do_warn(
+_("Bad CoW extent size hint %u on inode %" PRIu64 ", "),
+				be32_to_cpu(dino->di_cowextsize), lino);
+		if (!no_modify) {
+			do_warn(_("resetting to zero\n"));
+			dino->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
+			dino->di_cowextsize = 0;
+			*dirty = 1;
+		} else
+			do_warn(_("would reset to zero\n"));
+	}
+}
+
 /*
  * returns 0 if the inode is ok, 1 if the inode is corrupt
  * check_dups can be set to 1 *only* when called by the
@@ -3372,27 +3413,8 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 
 	validate_extsize(mp, dino, lino, dirty);
 
-	/*
-	 * Only (regular files and directories) with COWEXTSIZE flags
-	 * set can have extsize set.
-	 */
-	if (dino->di_version >= 3 &&
-	    libxfs_inode_validate_cowextsize(mp,
-			be32_to_cpu(dino->di_cowextsize),
-			be16_to_cpu(dino->di_mode),
-			be16_to_cpu(dino->di_flags),
-			be64_to_cpu(dino->di_flags2)) != NULL) {
-		do_warn(
-_("Bad CoW extent size %u on inode %" PRIu64 ", "),
-				be32_to_cpu(dino->di_cowextsize), lino);
-		if (!no_modify)  {
-			do_warn(_("resetting to zero\n"));
-			dino->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
-			dino->di_cowextsize = 0;
-			*dirty = 1;
-		} else
-			do_warn(_("would reset to zero\n"));
-	}
+	if (dino->di_version >= 3)
+		validate_cowextsize(mp, dino, lino, dirty);
 
 	/* nsec fields cannot be larger than 1 billion */
 	check_nsec("atime", lino, dino, &dino->di_atime, dirty);

