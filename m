Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804B3C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbiLaCuw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiLaCuv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:50:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C247DF80
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:50:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18F05B81E6E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0970C433D2;
        Sat, 31 Dec 2022 02:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455047;
        bh=R5AVAl79oVI4fcrDvID1voPojji9/iEOWfRh83U+cPM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lG3szCnhLOmRDyzUQb1uB1SeLHFEpGWKw7ura4n4VS/hfO+mpnndP6YBkxJsvgSp1
         DXXxNeU5RXOpGSty4lLix/xN4OsYp+LYfuEZ0MGDEeLEiQEZTkQkbuuBYT+nMpruu5
         Y9Vyrd2AaOEhnfMxC0xuuyaMUaqEVTjiV53addC7z8ZbMa4nFNgB8TDbBBlGXNKeft
         2xV+t04AsaqYK05bH49zhoGdf39M/bAyAQPV3NxUQXE8ZYR9M2UJjv4y3oPKsZZul/
         7f2JHFC3iS7xrtyVUvdR3liBspqCm0v574bQcw2ngjeWgEkZgdyUfhQgNKQgyzpIbn
         BaZn0D2vdJNSg==
Subject: [PATCH 32/41] xfs_repair: refactor realtime inode check
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:00 -0800
Message-ID: <167243880018.732820.7186019411725969251.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refactor the realtime bitmap and summary checks into a helper function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   84 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 39 insertions(+), 45 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 28eb639bbb8..3e55434c849 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1736,6 +1736,39 @@ check_dinode_mode_format(
 	return 0;	/* invalid modes are checked elsewhere */
 }
 
+static int
+process_check_rt_inode(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dinoc,
+	xfs_ino_t		lino,
+	int			*type,
+	int			*dirty,
+	int			expected_type,
+	const char		*tag)
+{
+	xfs_extnum_t		dnextents = xfs_dfork_data_extents(dinoc);
+
+	if (*type != expected_type) {
+		do_warn(
+_("%s inode %" PRIu64 " has bad type 0x%x, "),
+			tag, lino, dinode_fmt(dinoc));
+		if (!no_modify)  {
+			do_warn(_("resetting to regular file\n"));
+			change_dinode_fmt(dinoc, S_IFREG);
+			*dirty = 1;
+		} else  {
+			do_warn(_("would reset to regular file\n"));
+		}
+	}
+	if (mp->m_sb.sb_rblocks == 0 && dnextents != 0)  {
+		do_warn(
+_("bad # of extents (%" PRIu64 ") for %s inode %" PRIu64 "\n"),
+			dnextents, tag, lino);
+		return 1;
+	}
+	return 0;
+}
+
 /*
  * If inode is a superblock inode, does type check to make sure is it valid.
  * Returns 0 if it's valid, non-zero if it needs to be cleared.
@@ -1749,8 +1782,6 @@ process_check_sb_inodes(
 	int			*type,
 	int			*dirty)
 {
-	xfs_extnum_t		dnextents;
-
 	if (lino == mp->m_sb.sb_rootino) {
 		if (*type != XR_INO_DIR)  {
 			do_warn(_("root inode %" PRIu64 " has bad type 0x%x\n"),
@@ -1792,49 +1823,12 @@ process_check_sb_inodes(
 		}
 		return 0;
 	}
-	dnextents = xfs_dfork_data_extents(dinoc);
-	if (lino == mp->m_sb.sb_rsumino) {
-		if (*type != XR_INO_RTSUM) {
-			do_warn(
-_("realtime summary inode %" PRIu64 " has bad type 0x%x, "),
-				lino, dinode_fmt(dinoc));
-			if (!no_modify)  {
-				do_warn(_("resetting to regular file\n"));
-				change_dinode_fmt(dinoc, S_IFREG);
-				*dirty = 1;
-			} else  {
-				do_warn(_("would reset to regular file\n"));
-			}
-		}
-		if (mp->m_sb.sb_rblocks == 0 && dnextents != 0)  {
-			do_warn(
-_("bad # of extents (%" PRIu64 ") for realtime summary inode %" PRIu64 "\n"),
-				dnextents, lino);
-			return 1;
-		}
-		return 0;
-	}
-	if (lino == mp->m_sb.sb_rbmino) {
-		if (*type != XR_INO_RTBITMAP) {
-			do_warn(
-_("realtime bitmap inode %" PRIu64 " has bad type 0x%x, "),
-				lino, dinode_fmt(dinoc));
-			if (!no_modify)  {
-				do_warn(_("resetting to regular file\n"));
-				change_dinode_fmt(dinoc, S_IFREG);
-				*dirty = 1;
-			} else  {
-				do_warn(_("would reset to regular file\n"));
-			}
-		}
-		if (mp->m_sb.sb_rblocks == 0 && dnextents != 0)  {
-			do_warn(
-_("bad # of extents (%" PRIu64 ") for realtime bitmap inode %" PRIu64 "\n"),
-				dnextents, lino);
-			return 1;
-		}
-		return 0;
-	}
+	if (lino == mp->m_sb.sb_rsumino)
+		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
+				XR_INO_RTSUM, _("realtime summary"));
+	if (lino == mp->m_sb.sb_rbmino)
+		return process_check_rt_inode(mp, dinoc, lino, type, dirty,
+				XR_INO_RTBITMAP, _("realtime bitmap"));
 	return 0;
 }
 

