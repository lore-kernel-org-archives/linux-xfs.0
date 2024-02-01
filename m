Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3276843AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816944; cv=none; b=GSO8SEJTDugD2IFJqay2eceHYYz48QGlQVsFwqXRDTPWIT777plH4NOv06bhtPD5IXRdiMxeyJc7vxjLwo3knsoQG0RJJMo4PKiEsePxvUmNE2s4V6ACXeJGXPD1U0kTMmRAdpn1NMAUTBtXVF0sdyS0z/BVgmpDaYn0brv7jko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816944; c=relaxed/simple;
	bh=3XtVYs+sRLL6mAniNdAaMxQRkKVtEBdxbrH8DgEjHuA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H03pOsB51tN1wKk72iRkk3D+b4pj9cDLEf4Y/oF9X379vb8hVOl+W5G1t6M8/G8XYIq3UXEuV32r1mXpkrNRja58k5k7a4/JhS55xbTPtu8wkuvnjEpRgA5RzZwtRNp0UGw/fSFQfbFD9EIbNHia2ww0zhMtQHKTwyCVHGm4aQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rbVA5muU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rbVA5muU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB57BC433F1;
	Thu,  1 Feb 2024 19:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816943;
	bh=3XtVYs+sRLL6mAniNdAaMxQRkKVtEBdxbrH8DgEjHuA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rbVA5muUoE8frP3WmOngCFyQwXSnYKofEEY4/DHRBsQ4w2GHbVZMFRS2e4dMHCFIE
	 TGJhXZDMoWFY6/a6flnUavA4TqbvgqvqXlaWM/q/7lBWDne0aFSD9RuiZ9Ih84gnLJ
	 +I8uDbHV16KRT5caD7wbQHJpDNEnYJB0lOkfvYsrgFkeJBJ2PEZ+viG9fl7uY2Hrmw
	 5CHjlylxrTttvC3WQL6/+qHpi2xarRcOWVl7wtgzd/xtNprvoY0Lo8TDj0HX5LfvVy
	 5GHDijwnMu9Dm3F/2vnSA27SyoR6FwowL+CvRbjswRB5h/aDsyTj9o/745rrbt5JS+
	 me2duguDRySyg==
Date: Thu, 01 Feb 2024 11:49:03 -0800
Subject: [PATCH 13/27] xfs: make fake file forks explicit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334995.1605438.15565130234166131675.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
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

Don't open-code "-1" for whichfork when we're creating a staging btree
for a repair; let's define an actual symbol to make grepping and
understanding easier.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |    2 +-
 fs/xfs/libxfs/xfs_types.h      |    8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 3b6f14196c8cd..7381e507b32ba 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -614,7 +614,7 @@ xfs_bmbt_stage_cursor(
 	cur = xfs_bmbt_init_common(mp, NULL, ip, XFS_DATA_FORK);
 
 	/* Don't let anyone think we're attached to the real fork yet. */
-	cur->bc_ino.whichfork = -1;
+	cur->bc_ino.whichfork = XFS_STAGING_FORK;
 	xfs_btree_stage_ifakeroot(cur, ifake);
 	return cur;
 }
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 62e02d5380ad3..a1004fb3c8fb4 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
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

