Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349B2881E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302692; cv=none; b=J2k63F3OHX/15Lmolwwn42qi6IZEBbmCHxKcr4OA810NhnbSQogVnDJrOT1ZKUtDhuNLKhZvYhzhZMHFnu2ND0HTl2vV3Kq0IDguy/JuV9nyu66dVz+KxQ9gLVmICK7BY6N/rUpK4+LNFI6JaqNS6KNf8mc7mr8GPS+2sWYRAg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302692; c=relaxed/simple;
	bh=CtiusBW9yU05l036ziRJ+mfN+oTW8dpiMDB8oQFhXrI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WrBEO6BeNpmTwvhxfmI0dQy69E9lPMfKF+aZQnck6fZGhvQBhDQ6/+fZfkdpv8Sb9w90p1AbbMdIaMzB5KI9386bCmc6CxFsHQDCqFR2dRnE7mkfCO6EMTp2BLy8Iglk5N5w+h94TeJBTIo58nIJHIYZsq/eUPb1TJGGr/zqIxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMMGuiGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMMGuiGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9410C32786;
	Tue, 30 Jul 2024 01:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302691;
	bh=CtiusBW9yU05l036ziRJ+mfN+oTW8dpiMDB8oQFhXrI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jMMGuiGCK30Ky5y9387QTJltLOeln/G+a3us43uoN6uyeKyPvHeZpHdEhP0oEAjBD
	 /iF4AL77Vxbt1jf1xUsE4oXLGruFHWNsMI33C9e+4ZbsXzgKyOQBz8Q95U7/PrPAAZ
	 kUP6dpszMAbz8ZiYWaVcyjbfnAf5IQa7YyvgM1Hmhdnbhlgoc3y4NkHWeRQhqd1QpO
	 JNw5s/dDb/aMszRBiUUlLgudY8mKTc6OtdZFG+L3nf/LeCd1RsdIa1fmPr+Pt5AEXE
	 cfrpVp8gI4tHUFX8bGZzrSJpueZis25LWoZ4qCOj0rLNk9Aav6hZtR1bRAuBn8+0PQ
	 JqVEIYKJU+5fw==
Date: Mon, 29 Jul 2024 18:24:51 -0700
Subject: [PATCH 23/24] mkfs: Add parent pointers during protofile creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850818.1350924.4972291714239941056.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Inodes created from protofile parsing will also need to add the
appropriate parent pointers.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: use xfs_parent_add from libxfs instead of open-coding xfs_attr_set]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/proto.c |   62 +++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 14 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index a9a9b704a..8e16eb150 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -348,11 +348,12 @@ newregfile(
 
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
+	struct xfs_parent_args	*ppargs)
 {
 	int	error;
 	int	rsv;
@@ -365,9 +366,15 @@ newdirent(
 
 	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
-	error = -libxfs_dir_createname(tp, pip, name, inum, rsv);
+	error = -libxfs_dir_createname(tp, pip, name, ip->i_ino, rsv);
 	if (error)
 		fail(_("directory createname error"), error);
+
+	if (ppargs) {
+		error = -libxfs_parent_addname(tp, ppargs, pip, name, ip);
+		if (error)
+			fail(_("parent addname error"), error);
+	}
 }
 
 static void
@@ -384,6 +391,20 @@ newdirectory(
 		fail(_("directory create error"), error);
 }
 
+static struct xfs_parent_args *
+newpptr(
+	struct xfs_mount	*mp)
+{
+	struct xfs_parent_args	*ret;
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
@@ -418,6 +439,7 @@ parseproto(
 	struct cred	creds;
 	char		*value;
 	struct xfs_name	xname;
+	struct xfs_parent_args *ppargs = NULL;
 
 	memset(&creds, 0, sizeof(creds));
 	mstr = getstr(pp);
@@ -492,6 +514,7 @@ parseproto(
 	case IF_REGULAR:
 		buf = newregfile(pp, &len);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
+		ppargs = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					   &creds, fsxp, &ip);
 		if (error)
@@ -501,7 +524,7 @@ parseproto(
 			free(buf);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, ppargs);
 		break;
 
 	case IF_RESERVED:			/* pre-allocated space only */
@@ -515,7 +538,7 @@ parseproto(
 			exit(1);
 		}
 		tp = getres(mp, XFS_B_TO_FSB(mp, llen));
-
+		ppargs = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					  &creds, fsxp, &ip);
 		if (error)
@@ -524,17 +547,19 @@ parseproto(
 		libxfs_trans_ijoin(tp, pip, 0);
 
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, ppargs);
 		libxfs_trans_log_inode(tp, ip, flags);
 		error = -libxfs_trans_commit(tp);
 		if (error)
 			fail(_("Space preallocation failed."), error);
+		libxfs_parent_finish(mp, ppargs);
 		rsvfile(mp, ip, llen);
 		libxfs_irele(ip);
 		return;
 
 	case IF_BLOCK:
 		tp = getres(mp, 0);
+		ppargs = newpptr(mp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFBLK, 1,
@@ -544,12 +569,13 @@ parseproto(
 		}
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_BLKDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, ppargs);
 		flags |= XFS_ILOG_DEV;
 		break;
 
 	case IF_CHAR:
 		tp = getres(mp, 0);
+		ppargs = newpptr(mp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFCHR, 1,
@@ -558,24 +584,26 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_CHRDEV;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, ppargs);
 		flags |= XFS_ILOG_DEV;
 		break;
 
 	case IF_FIFO:
 		tp = getres(mp, 0);
+		ppargs = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFIFO, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_FIFO;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, ppargs);
 		break;
 	case IF_SYMLINK:
 		buf = getstr(pp);
 		len = (int)strlen(buf);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
+		ppargs = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFLNK, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
@@ -583,7 +611,7 @@ parseproto(
 		writesymlink(tp, ip, buf, len);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_SYMLINK;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, ppargs);
 		break;
 	case IF_DIRECTORY:
 		tp = getres(mp, 0);
@@ -598,9 +626,10 @@ parseproto(
 			libxfs_log_sb(tp);
 			isroot = 1;
 		} else {
+			ppargs = newpptr(mp);
 			libxfs_trans_ijoin(tp, pip, 0);
 			xname.type = XFS_DIR3_FT_DIR;
-			newdirent(mp, tp, pip, &xname, ip->i_ino);
+			newdirent(mp, tp, pip, &xname, ip, ppargs);
 			libxfs_bumplink(tp, pip);
 			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
 		}
@@ -609,6 +638,9 @@ parseproto(
 		error = -libxfs_trans_commit(tp);
 		if (error)
 			fail(_("Directory inode allocation failed."), error);
+
+		libxfs_parent_finish(mp, ppargs);
+
 		/*
 		 * RT initialization.  Do this here to ensure that
 		 * the RT inodes get placed after the root inode.
@@ -636,6 +668,8 @@ parseproto(
 		fail(_("Error encountered creating file from prototype file"),
 			error);
 	}
+
+	libxfs_parent_finish(mp, ppargs);
 	libxfs_irele(ip);
 }
 

