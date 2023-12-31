Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C57CDF56
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jTJt9xNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7765C433C7;
	Sun, 31 Dec 2023 23:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064391;
	bh=gLUJz5/0fcMTmExUdhG7SRgJDCO6pXjfqLnZgxYkXeI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jTJt9xNYienEdhRgfO7qzxSF5q7RShufLzDRNyeTTeUxP6j8/MEHUy5+SHvpJTc24
	 ypscNxjuBCE/EYXAl46yh+/xC6SRSf4MOw5pwmAU4DABz0tH+AlFTb8gD7tPQz21fa
	 oZr1KCN8yK9j05LnN3j7vEX1yIskJbp4/zcxjshKzC/7upAgCL5KOJwfEag+EeAxzJ
	 +J9uqMZjXurCIfUJwncKdzR5Jw+jtJYTm1eQlxc73CuDBv2WpvThCbtKz7kixsCyg9
	 9EkZA/91nK8ey0Jla7tMNLA8o6N+4EhuPewJSedMAmMArincCV2uD0nO5myG8nO6P5
	 V32zkMgyl7KCg==
Date: Sun, 31 Dec 2023 15:13:11 -0800
Subject: [PATCH 31/32] mkfs: Add parent pointers during protofile creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006514.1804688.10799056762357845912.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
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
---
 mkfs/proto.c |   60 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 14 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 457899ac178..cc06bdfaf57 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -347,11 +347,12 @@ newregfile(
 
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
@@ -364,9 +365,13 @@ newdirent(
 
 	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
-	error = -libxfs_dir_createname(tp, pip, name, inum, rsv);
+	error = -libxfs_dir_createname(tp, pip, name, ip->i_ino, rsv);
 	if (error)
 		fail(_("directory createname error"), error);
+
+	error = -libxfs_parent_add(tp, ppargs, pip, name, ip);
+	if (error)
+		fail(_("committing parent pointers failed."), error);
 }
 
 static void
@@ -383,6 +388,20 @@ newdirectory(
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
@@ -417,6 +436,7 @@ parseproto(
 	struct cred	creds;
 	char		*value;
 	struct xfs_name	xname;
+	struct xfs_parent_args *ppargs = NULL;
 
 	memset(&creds, 0, sizeof(creds));
 	mstr = getstr(pp);
@@ -491,6 +511,7 @@ parseproto(
 	case IF_REGULAR:
 		buf = newregfile(pp, &len);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
+		ppargs = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					   &creds, fsxp, &ip);
 		if (error)
@@ -500,7 +521,7 @@ parseproto(
 			free(buf);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_REG_FILE;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, ppargs);
 		break;
 
 	case IF_RESERVED:			/* pre-allocated space only */
@@ -514,7 +535,7 @@ parseproto(
 			exit(1);
 		}
 		tp = getres(mp, XFS_B_TO_FSB(mp, llen));
-
+		ppargs = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					  &creds, fsxp, &ip);
 		if (error)
@@ -523,17 +544,19 @@ parseproto(
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
@@ -543,12 +566,13 @@ parseproto(
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
@@ -557,24 +581,26 @@ parseproto(
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
@@ -582,7 +608,7 @@ parseproto(
 		writesymlink(tp, ip, buf, len);
 		libxfs_trans_ijoin(tp, pip, 0);
 		xname.type = XFS_DIR3_FT_SYMLINK;
-		newdirent(mp, tp, pip, &xname, ip->i_ino);
+		newdirent(mp, tp, pip, &xname, ip, ppargs);
 		break;
 	case IF_DIRECTORY:
 		tp = getres(mp, 0);
@@ -597,9 +623,10 @@ parseproto(
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
@@ -608,6 +635,9 @@ parseproto(
 		error = -libxfs_trans_commit(tp);
 		if (error)
 			fail(_("Directory inode allocation failed."), error);
+
+		libxfs_parent_finish(mp, ppargs);
+
 		/*
 		 * RT initialization.  Do this here to ensure that
 		 * the RT inodes get placed after the root inode.
@@ -635,6 +665,8 @@ parseproto(
 		fail(_("Error encountered creating file from prototype file"),
 			error);
 	}
+
+	libxfs_parent_finish(mp, ppargs);
 	libxfs_irele(ip);
 }
 

