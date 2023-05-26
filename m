Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098C8C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjEZC33 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZC32 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B9B13D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2FEE64C4C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C60C433D2;
        Fri, 26 May 2023 02:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068163;
        bh=ZRCZ9sJ/4GjssgGYDEUNmu2OTPsBQvS7IogjGSupxgM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=swPnbgoNvmOXlXM69lZZVWdIbglrZ/ApHG9htJ+OSP6sDFPg9Dw6U3Z5YPzI5djqI
         l9n4IjZAvOksPAkpR5J6TdZhKUVRUO8hXfkiPi3xA/eg+A5Xc1jqgrX8iMYv7yTIic
         +tJqnfNVztj2NLx7TDho0oju0CiuR6uY4+I4ffRKVitb69lO18f2lof4DYMKpPVEH8
         bfTwtITZK4k9mYuf5QZOPiAJnizuzsht+UitNAjwCtnEh1XJVxqeroSwngj4f3OO2K
         Jnxb0txRg/FEPgHLqMYcmK/aa855ijGd7riOcxRGmPnPT6SxdeDEQ7IqzSdLGG0pVz
         Aqbwt2+xWEQvg==
Date:   Thu, 25 May 2023 19:29:22 -0700
Subject: [PATCH 29/30] mkfs: Add parent pointers during protofile creation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078282.3749421.188426515286394970.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
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
 mkfs/proto.c |   63 +++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 14 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index b127bb5cedc..c0e887993e5 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -346,11 +346,12 @@ newregfile(
 
 static void
 newdirent(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_inode_t	*pip,
-	struct xfs_name	*name,
-	xfs_ino_t	inum)
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*pip,
+	struct xfs_name		*name,
+	struct xfs_inode	*ip,
+	struct xfs_parent_defer	*parent)
 {
 	int	error;
 	int	rsv;
@@ -363,9 +364,16 @@ newdirent(
 
 	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
-	error = -libxfs_dir_createname(tp, pip, name, inum, rsv);
+	error = -libxfs_dir_createname(tp, pip, name, ip->i_ino, rsv);
 	if (error)
 		fail(_("directory createname error"), error);
+
+	if (parent) {
+		error = -libxfs_parent_add(tp, parent, pip, name, ip);
+		if (error)
+			fail(_("committing parent pointers failed."),
+					error);
+	}
 }
 
 static void
@@ -382,6 +390,20 @@ newdirectory(
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
@@ -416,6 +438,7 @@ parseproto(
 	struct cred	creds;
 	char		*value;
 	struct xfs_name	xname;
+	struct xfs_parent_defer *parent = NULL;
 
 	memset(&creds, 0, sizeof(creds));
 	mstr = getstr(pp);
@@ -490,6 +513,7 @@ parseproto(
 	case IF_REGULAR:
 		buf = newregfile(pp, &len);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
+		parent = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					   &creds, fsxp, &ip);
 		if (error)
@@ -499,7 +523,7 @@ parseproto(
 			free(buf);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, parent);
 		break;
 
 	case IF_RESERVED:			/* pre-allocated space only */
@@ -513,7 +537,7 @@ parseproto(
 			exit(1);
 		}
 		tp = getres(mp, XFS_B_TO_FSB(mp, llen));
-
+		parent = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					  &creds, fsxp, &ip);
 		if (error)
@@ -522,17 +546,19 @@ parseproto(
 		libxfs_trans_ijoin(tp, pip, 0);
 
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, parent);
 		libxfs_trans_log_inode(tp, ip, flags);
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
@@ -542,12 +568,13 @@ parseproto(
 		}
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_BLKDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, parent);
 		flags |= XFS_ILOG_DEV;
 		break;
 
 	case IF_CHAR:
 		tp = getres(mp, 0);
+		parent = newpptr(mp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFCHR, 1,
@@ -556,24 +583,26 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_CHRDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, parent);
 		flags |= XFS_ILOG_DEV;
 		break;
 
 	case IF_FIFO:
 		tp = getres(mp, 0);
+		parent = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFIFO, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_FIFO;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, parent);
 		break;
 	case IF_SYMLINK:
 		buf = getstr(pp);
 		len = (int)strlen(buf);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
+		parent = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFLNK, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
@@ -581,7 +610,7 @@ parseproto(
 		writesymlink(tp, ip, buf, len);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_SYMLINK;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, parent);
 		break;
 	case IF_DIRECTORY:
 		tp = getres(mp, 0);
@@ -596,9 +625,10 @@ parseproto(
 			libxfs_log_sb(tp);
 			isroot = 1;
 		} else {
+			parent = newpptr(mp);
 			libxfs_trans_ijoin(tp, pip, 0);
 			xname.type = XFS_DIR3_FT_DIR;
-			newdirent(mp, tp, pip, &xname, ip->i_ino);
+			newdirent(mp, tp, pip, &xname, ip, parent);
 			libxfs_bumplink(tp, pip);
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
@@ -607,6 +637,9 @@ parseproto(
 		error = -libxfs_trans_commit(tp);
 		if (error)
 			fail(_("Directory inode allocation failed."), error);
+
+		libxfs_parent_finish(mp, parent);
+
 		/*
 		 * RT initialization.  Do this here to ensure that
 		 * the RT inodes get placed after the root inode.
@@ -634,6 +667,8 @@ parseproto(
 		fail(_("Error encountered creating file from prototype file"),
 			error);
 	}
+
+	libxfs_parent_finish(mp, parent);
 	libxfs_irele(ip);
 }
 

