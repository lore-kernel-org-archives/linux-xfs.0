Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC02259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441694; cv=none; b=IvNlrG+nhpbWALBd21Z/yGBc3zXAer/FD09hTwq1pALrHdf1Yyatjz5Q6oGcRTZWemOakTAbWcX9v86zdREnIWCHi8+dbyZWpfOxZ55qwSv+XuKCqYhqo0aYue1gVGLlTu+59Bvrerd1QuaZJ5M077ohqxpV+BJFa8dZsMZDoUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441694; c=relaxed/simple;
	bh=AB6mzbCLOgalqFF6b5EONirkaZ9dF8LnrZGSZU3/kkw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9C7SvkxTZ7tBRR8DGDz7Ko/rL1i42R91+VnFT84czaTGkTg4nm/NLRF2YN+UU5MSivrVFe4wHCoUQdkF9Zs1fvUcJXGRq1pA35kfUhUxPNQe4bWJ/V7t+ynt3B++JsXIhwEchdRpiGUaWhGTKvwJ5ys7v1FtoD3v6LuSIeholQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lQyoJT/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQyoJT/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CE2C2BD10;
	Mon,  3 Jun 2024 19:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441693;
	bh=AB6mzbCLOgalqFF6b5EONirkaZ9dF8LnrZGSZU3/kkw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lQyoJT/RF2rW+PIq3UTEO2N0G8R9EefD8xbF7Egm93xbflHIOBeG9B4Vq7mwr2ttV
	 GhAszDLufLJV/lm//27D50RJmPKDycY1jMfSBbLjEm3auGK9ENBMDn7AQ6/xV6T6Zs
	 SgNkmEM3v8tt4uetWNBjqH/CvgYLIuampsnZUgAs/LPWCA+RFJddLyYY663uWnPHRM
	 2Ir/sNeipE3SfyDyRxj1ibLn0V4SDfudh+69QfgZBtJGbViA/w40LMpWcLFD2LyJ/A
	 AFWdrRHbKUKtTzQKZW8U1/8ampUkfKU2ODjcsJkb4FfusrRNL2AqWNZhxCCay3ECKx
	 i+fTLq6M2zXjg==
Date: Mon, 03 Jun 2024 12:08:13 -0700
Subject: [PATCH 062/111] xfs: make staging file forks explicit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040305.1443973.12491595673265963062.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 42e357c806c8c0ffb9c5c2faa4ad034bfe950d77

Don't open-code "-1" for whichfork when we're creating a staging btree
for a repair; let's define an actual symbol to make grepping and
understanding easier.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_bmap_btree.c |    2 +-
 libxfs/xfs_types.h      |    8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index dedc33dc5..6b377d129 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -613,7 +613,7 @@ xfs_bmbt_stage_cursor(
 	cur = xfs_bmbt_init_common(mp, NULL, ip, XFS_DATA_FORK);
 
 	/* Don't let anyone think we're attached to the real fork yet. */
-	cur->bc_ino.whichfork = -1;
+	cur->bc_ino.whichfork = XFS_STAGING_FORK;
 	xfs_btree_stage_ifakeroot(cur, ifake);
 	return cur;
 }
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 62e02d538..a1004fb3c 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -80,11 +80,13 @@ typedef void *		xfs_failaddr_t;
 /*
  * Inode fork identifiers.
  */
-#define	XFS_DATA_FORK	0
-#define	XFS_ATTR_FORK	1
-#define	XFS_COW_FORK	2
+#define XFS_STAGING_FORK	(-1)	/* fake fork for staging a btree */
+#define	XFS_DATA_FORK		(0)
+#define	XFS_ATTR_FORK		(1)
+#define	XFS_COW_FORK		(2)
 
 #define XFS_WHICHFORK_STRINGS \
+	{ XFS_STAGING_FORK, 	"staging" }, \
 	{ XFS_DATA_FORK, 	"data" }, \
 	{ XFS_ATTR_FORK,	"attr" }, \
 	{ XFS_COW_FORK,		"cow" }

