Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30EC2AD16
	for <linux-xfs@vger.kernel.org>; Thu,  5 Mar 2026 04:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772684648; cv=none; b=JXQmg3Oj62DvmbCMqSoqfqagM8aYCZ/I0kS5w0ACFmBEe+TjLPWTJcPyufXfYKZOXAfdWjKWKJT4syY0OJovtuo7B0D8mK7mThs7vwN1Md2/MoJ5iOnSLSyryDVaWUqB8qdVOWoj/OgaZVvYOsIBUGi2+kdZPXUchuF+i2LKeP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772684648; c=relaxed/simple;
	bh=V2Mbq7KymgOAHc8CWB+aNr4r4VtJk0x4uASKn3eFiKw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ckvEWv/00rzpGo7cgPGvE3h+A9fa/yM0kmgyZFNjqLv6ec2GFqO/k75uJGGqfz3pnjbqqtSDvLyeqoCO2hYwZQySR0B8yvHnPRBxUz+xq53wfbPdxHH3NnKuzfHl2EPFmL118Aq1WgN4v5m2pRv3zRpSP3QNmY+z6fT8sfmOsho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F6t6V92H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F6t6V92H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86114C116C6;
	Thu,  5 Mar 2026 04:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772684648;
	bh=V2Mbq7KymgOAHc8CWB+aNr4r4VtJk0x4uASKn3eFiKw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F6t6V92HjglzFIpndqNt36IW3TWluiNOhECN6xKg+7Q5jmWryV3e9V2lsF7ffFGHD
	 M1+K+fIaB98jN1caqafpd2/uqjdluorogeSu+xd07RLewvpl0Bwq8QE9GK4D57gSZ5
	 SxqGxn4QL+pXwYlUXm7wgw0NrBZxYUpL+GcBv3fal7LYp28MSj+JcRAHdP5/m4zR0B
	 m5as7eNjjEoM262RcXA5n2ktKCQgG1STTxUs8MyGcMuXpa3UkCDLHCMHuNLmMHkXPN
	 dQn10fQbO8QFENdEnEcHXbkLaKvPMBlrTQDOScY8NqMNooXw7CTtYM59fnTBsV7vd1
	 07c1MvfJFcJgw==
Date: Wed, 04 Mar 2026 20:24:08 -0800
Subject: [PATCH 1/4] misc: fix a few memory leaks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177268457028.1999857.17585481929890297782.stgit@frogsfrogsfrogs>
In-Reply-To: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
References: <177268456992.1999857.6319345892309281117.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

valgrind caught these while I was trying to debug xfs/841 regression so
fix them.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/proto.c    |   17 +++++++----------
 mkfs/xfs_mkfs.c |    1 +
 2 files changed, 8 insertions(+), 10 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 1a7b3586581278..3241a066f72951 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -1412,19 +1412,19 @@ handle_hardlink(
 	struct xfs_trans	*tp;
 	struct xfs_parent_args	*ppargs = NULL;
 
-	tp = getres(mp, 0);
-	ppargs = newpptr(mp);
-	dst_ino = get_hardlink_dst_inode(file_stat.st_ino);
-
 	/*
 	 * We didn't find the hardlink inode, this means it's the first time
 	 * we see it, report error so create_nondir_inode() can continue handling the
 	 * inode as a regular file type, and later save the source inode in our
 	 * buffer for future consumption.
 	 */
+	dst_ino = get_hardlink_dst_inode(file_stat.st_ino);
 	if (dst_ino == 0)
 		return false;
 
+	tp = getres(mp, 0);
+	ppargs = newpptr(mp);
+
 	error = -libxfs_iget(mp, NULL, dst_ino, 0, &ip);
 	if (error)
 		fail(_("failed to get inode"), error);
@@ -1546,12 +1546,7 @@ create_nondir_inode(
 		close(fd);
 		return;
 	}
-	/*
-	 * If instead we have an error it means the hardlink was not registered,
-	 * so we proceed to treat it like a regular file, and save it to our
-	 * tracker later.
-	 */
-	tp = getres(mp, 0);
+
 	/*
 	 * In case of symlinks, we need to handle things a little differently.
 	 * We need to read out our link target and act accordingly.
@@ -1563,6 +1558,8 @@ create_nondir_inode(
 		if (link_len >= PATH_MAX)
 			fail(_("symlink target too long"), ENAMETOOLONG);
 		tp = getres(mp, XFS_B_TO_FSB(mp, link_len));
+	} else {
+		tp = getres(mp, 0);
 	}
 	ppargs = newpptr(mp);
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a7a6fde9327797..ece20905b28313 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -5824,6 +5824,7 @@ set_autofsck(
 	}
 
 	libxfs_irele(args.dp);
+	free(p);
 }
 
 /* Write the realtime superblock */

