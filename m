Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5154A06
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883002; cv=none; b=GHMtH9AAnqNXiJSby+aZWf9yIAhpWzA6PyG+Y3x63G2l8XbKtoZ0dlCX2pEWHpomonXdLWVeXellpzrLZ/9BIceLpCSQ2c1lKYxA7KxHACs04upioOW/zZbFj8rF0Xfot258uszouCEFt0vUGv6Pg4Y7jpRfUEi9Uv/P5qQQrzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883002; c=relaxed/simple;
	bh=cXbTjsgfAVy1FjDG9TBq+blq492+KtfuuheEa3TxPks=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zx8znLZlR14j8kJV/1g9puMDFfBjBFVkmCvan6hbmrKMHKcBaMMVrOIAoHnhosoxsXkChh6rx4udSBEV/HPkuC8N8qBVvXHBh/s7zsHVEuu4xkcV7kaTdRcHl1S2w2BoaxpvRw1irRAcnvQRqX6mlqVLqS1D6gMKDoZHQjymxn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bC9m59m+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bC9m59m+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10CDC116B1;
	Tue,  2 Jul 2024 01:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883001;
	bh=cXbTjsgfAVy1FjDG9TBq+blq492+KtfuuheEa3TxPks=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bC9m59m+zkFL1WOwxph529cEGIHRoMBKyq8j7Kw06/9mTdo+/wYXKQz2zvz3iWAEw
	 IRbqpctL2cd+s2Y4sXuR2i3AgSo1FKAqueC0Iomzjp46AGKnbf5kseaMwZrVslsARr
	 ZwdrvLPoIDiCKPPvwqSvaxw4kr5AgTZeZH2MO97Islzf6Pp/U16DR1ptJpnYQj2HhY
	 hiVS+BmTpDAcH8t3fQE+I9gHcwYc/ESOXOiZs5i2CxLU9a6+1UYb7xswNghzCX51u+
	 tpW+ki9paDv8Nnulgb2wG99ehAzq6uh/cW76a0M54NDX6dmZtosBVJFmO9GoQ2xs9V
	 fg/Cq8U0FZnBQ==
Date: Mon, 01 Jul 2024 18:16:41 -0700
Subject: [PATCH 23/24] mkfs: Add parent pointers during protofile creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121418.2009260.2932252649175356725.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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
 mkfs/proto.c |   62 +++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 14 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index a9a9b704a3ca..8e16eb1506f1 100644
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
 

