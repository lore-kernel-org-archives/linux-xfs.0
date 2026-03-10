Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42395399007
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773113098; cv=none; b=BLkyFjrTve0GhPa2+/n9FpiSVO95ZbdC4uSae9RBZ5Ah6YFFUJltBsc41r7y8h+b3sXM6oKn8DgQZwDKQgUGYNk+zmlP/oXUIvB64BOnQfC0E9XuhIsGumK52P8XK1mIwrEah2Osz3kGCePVXZR+DpNYEZonca+H8RJKXjTQldI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773113098; c=relaxed/simple;
	bh=q+5xRQ4laC1vUBEpm1OFc6ScjeyrVr2uEXGmICQAhN4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h+3yeFTQy2/bYK9xP7aa6sTfj7GlJeH+ouZ4wwjP/le5aqVZMABFInFEhG0lsjg0PpyEbP/u48RlEVFzAdNxwCA/nLjCRHjgyf0NEg9b4pPYLE3LV4q4d38MhY2PfrMtEZEgL+frB3s6MOdyG6RMnAMchJLpXepk7ScY1GsV2f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uoGoQ2XH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uoGoQ2XH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF75C4CEF7;
	Tue, 10 Mar 2026 03:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773113097;
	bh=q+5xRQ4laC1vUBEpm1OFc6ScjeyrVr2uEXGmICQAhN4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uoGoQ2XHhAu0dTcShjAPmlQKT/weRLaTmfshrYP185yA3stS1Ao8k36hxNIgzl1/D
	 Vc3n2SovFhZ12gfO+MDHin3ElLKKIQmFwWFOUs59UlBdktrj40C0YkEvWDeg/4FTKf
	 mxH69LWavpR5t2Rec/LkqXTmsKbWkQM0Po4hQnGTtNyCAGV6C+5cbFu4ICzuuLGB/p
	 bajYQjGloOphvFEHWBxEXvdK1O8d/fd0y3VOcdmIqfznbcUFZhW/0KLgZ9Clz/huSB
	 GdECl3Y4jXv3xYtf9oLHNICBsXe9gNOoPuVH6Bidgna5c0UiIh0Mrbif1v7CGZiiwH
	 XZrJGS00YQqjg==
Date: Mon, 09 Mar 2026 20:24:57 -0700
Subject: [PATCH 1/4] misc: fix a few memory leaks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177311301497.1161719.6007053034920040265.stgit@frogsfrogsfrogs>
In-Reply-To: <177311301461.1161719.5028507121065374411.stgit@frogsfrogsfrogs>
References: <177311301461.1161719.5028507121065374411.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

