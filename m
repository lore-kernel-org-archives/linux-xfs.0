Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E29C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjDFTjl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjDFTjl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:39:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8D694
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:39:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0853860F9F
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BA7C4339B;
        Thu,  6 Apr 2023 19:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809978;
        bh=FxSAnXMplhguqw6nhGKRHNdCbDlQey16fCFDgudthUw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=EF4xBTH2MVrSzExXnfbJjOAL0KoaOkPf1cPauc4EV2DZ39r/K1AOBPPbX0vmiR6lV
         W1wSYj/eDirnh+/ox3gOKU9Zy/juDv5fRMfJ00E5uOx//M3kLLP9G8Lydxk10BdD8e
         ZLTpZiN0tVjPLmM04ZHSkJaqZIq/fpZNW0gBaCVuuOtwLJHw6s0BMf0oi1FUEw7rUS
         rZkOyNtfWRXTRgjnrlweyLH+9oYon8JpINWoHZPNjQJHIAol0bkj1ev3cf63g7rWwM
         xKWH3XQSgkkyxTyhtSy+Hwd7rRoRC5XOegrfPRUKGMDdb5jJEvwcoafqkD7hf3wXoM
         yiOvzD2R0S8dg==
Date:   Thu, 06 Apr 2023 12:39:38 -0700
Subject: [PATCH 31/32] mkfs: Add parent pointers during protofile creation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827965.616793.17306235980370217756.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Inodes created from protofile parsing will also need to add the
appropriate parent pointers.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: use xfs_parent_add from libxfs instead of open-coding xfs_attr_set]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index ea31cfe5c..d6999b850 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -378,6 +378,20 @@ newdirectory(
 		fail(_("directory create error"), error);
 }
 
+static struct xfs_parent_defer *
+newpptr(
+	struct xfs_mount	*mp)
+{
+	struct xfs_parent_defer	*ret;
+	int			error;
+
+	error = -libxfs_parent_start(mp, &ret);
+	if (error)
+		fail(_("initializing parent pointer"), error);
+
+	return ret;
+}
+
 static void
 parseproto(
 	xfs_mount_t	*mp,
@@ -412,6 +426,7 @@ parseproto(
 	struct cred	creds;
 	char		*value;
 	struct xfs_name	xname;
+	struct xfs_parent_defer *parent = NULL;
 
 	memset(&creds, 0, sizeof(creds));
 	mstr = getstr(pp);
@@ -486,6 +501,7 @@ parseproto(
 	case IF_REGULAR:
 		buf = newregfile(pp, &len);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
+		parent = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					   &creds, fsxp, &ip);
 		if (error)
@@ -509,7 +525,7 @@ parseproto(
 			exit(1);
 		}
 		tp = getres(mp, XFS_B_TO_FSB(mp, llen));
-
+		parent = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					  &creds, fsxp, &ip);
 		if (error)
@@ -520,15 +536,24 @@ parseproto(
 		xname.type = XFS_DIR3_FT_REG_FILE;
 		newdirent(mp, tp, pip, &xname, ip->i_ino);
 		libxfs_trans_log_inode(tp, ip, flags);
+		if (parent) {
+			error = -libxfs_parent_add(tp, parent, pip, &xname,
+					ip);
+			if (error)
+				fail(_("committing parent pointers failed."),
+						error);
+		}
 		error = -libxfs_trans_commit(tp);
 		if (error)
 			fail(_("Space preallocation failed."), error);
+		libxfs_parent_finish(mp, parent);
 		rsvfile(mp, ip, llen);
 		libxfs_irele(ip);
 		return;
 
 	case IF_BLOCK:
 		tp = getres(mp, 0);
+		parent = newpptr(mp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFBLK, 1,
@@ -544,6 +569,7 @@ parseproto(
 
 	case IF_CHAR:
 		tp = getres(mp, 0);
+		parent = newpptr(mp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFCHR, 1,
@@ -558,6 +584,7 @@ parseproto(
 
 	case IF_FIFO:
 		tp = getres(mp, 0);
+		parent = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFIFO, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
@@ -570,6 +597,7 @@ parseproto(
 		buf = getstr(pp);
 		len = (int)strlen(buf);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
+		parent = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFLNK, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
@@ -592,6 +620,7 @@ parseproto(
 			libxfs_log_sb(tp);
 			isroot = 1;
 		} else {
+			parent = newpptr(mp);
 			libxfs_trans_ijoin(tp, pip, 0);
 			xname.type = XFS_DIR3_FT_DIR;
 			newdirent(mp, tp, pip, &xname, ip->i_ino);
@@ -600,9 +629,19 @@ parseproto(
 		}
 		newdirectory(mp, tp, ip, pip);
 		libxfs_trans_log_inode(tp, ip, flags);
+		if (parent) {
+			error = -libxfs_parent_add(tp, parent, pip, &xname,
+					ip);
+			if (error)
+				fail(_("committing parent pointers failed."),
+						error);
+		}
 		error = -libxfs_trans_commit(tp);
 		if (error)
 			fail(_("Directory inode allocation failed."), error);
+
+		libxfs_parent_finish(mp, parent);
+
 		/*
 		 * RT initialization.  Do this here to ensure that
 		 * the RT inodes get placed after the root inode.
@@ -625,11 +664,18 @@ parseproto(
 		fail(_("Unknown format"), EINVAL);
 	}
 	libxfs_trans_log_inode(tp, ip, flags);
+	if (parent) {
+		error = -libxfs_parent_add(tp, parent, pip, &xname, ip);
+		if (error)
+			fail(_("committing parent pointers failed."), error);
+	}
 	error = -libxfs_trans_commit(tp);
 	if (error) {
 		fail(_("Error encountered creating file from prototype file"),
 			error);
 	}
+
+	libxfs_parent_finish(mp, parent);
 	libxfs_irele(ip);
 }
 

