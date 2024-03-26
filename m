Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941B121353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424676; cv=none; b=FcUqKRVvILQ+IMj3dOOp2M//THOzDSn3Nctrsg5hPRVxkjy3Ir+DbHzfQ8QQ7SkfBITCJHS+/2tSSCbXCwmscsrcW6DFeF05+ImqzRU4TkSMsg1HpIY35q1W1nSJQOd27euhvZHjunCYbE1chNrbhLpaHDIJ3AMFnbwQKqNpExI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424676; c=relaxed/simple;
	bh=rsnZ+yIEPXd6jlsvDpOzkVZluyB7t76y7b0f3biIMWg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E8qmXtm5Zw+VJNerkA8e1ftg+xu8IP8LFi70olgOZec1k01wgExaA0SgXe3E4OYB6HIpT4F3cU5u/jB2d1znD5+59CScT2A/SoInYXoAW3Vtwye5U6rvwHvB6EwbCIAoS5dMzoPwH0XVMzROF3tV7FxxgW/xsQ5aaw/nu5XPD1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xr5UxS4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xr5UxS4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681DCC433F1;
	Tue, 26 Mar 2024 03:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424676;
	bh=rsnZ+yIEPXd6jlsvDpOzkVZluyB7t76y7b0f3biIMWg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xr5UxS4r5U+BdgKD3C/iDnh/XRv5DZx8b8QLLGF802kVy+EanCv3G+CL0oHal7xWO
	 LK+1G4lRs+GR8XXro4A+E1HlC6YekDJ+KVK1ri1yj93DoLwyAeGs4UfdrdS4A6dMdp
	 sY1Rds2yIiOtbi0WvkcDAz/QKthydzwB/831t7ADIGjW4zJmi2Asel6740DuxquRQQ
	 KP9ZQznvVXG0FynbpBlhGqqWOxtEJN3wxMt4GXut/T0HJlfNxlanOEZ0L6/Rb9igLM
	 4nklc3uK0hzrnecoRSpcoT0MCJ+iyODkDOMf+KoiiU3o8O8D1zNoueAceCGROc2/dR
	 szmgLO2FmEfDA==
Date: Mon, 25 Mar 2024 20:44:35 -0700
Subject: [PATCH 062/110] xfs: make staging file forks explicit
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132271.2215168.4915593680418744915.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
---
 libxfs/xfs_bmap_btree.c |    2 +-
 libxfs/xfs_types.h      |    8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index dedc33dc5049..6b377d129c33 100644
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
index 62e02d5380ad..a1004fb3c8fb 100644
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

