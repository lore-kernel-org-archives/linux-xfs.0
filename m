Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D666129A70
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425021; cv=none; b=GfR0Qfx64PUv4Jt8DWyqrNdQHgQiNYEVFu77xLlapPPLGsf1UkMJqp33Z2of0K1oQSztZPNRyQODfMLLQ21u4TinRmFTIr677d5u2jisvbZKTzDvnTgl4DyieFUhsi3rfRCaG3ppdu5jhO4AgVqn0d0Z8p2WOJz/H4FL3YlRMs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425021; c=relaxed/simple;
	bh=A80Z1rd+KKjPmXn+I9hynND9JNBozT35nr8FeEPSN3s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q529PWg0E8T+ddk9tXwdOwjcN3IjToogeVyXoCT80oHglb6oElgW/6male3tInrLRzhnWH5BBb3HXNA+sbcAEWvdDgjG3+6ULVH+Nou7otWjMvWk8ZwTLkd0wL0ixT8cAu2k3lJuOCvoz5qTln4G4LyxAuDFn6zl5tsboJb87ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X1XGlRx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1XGlRx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D877CC43390;
	Tue, 26 Mar 2024 03:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425020;
	bh=A80Z1rd+KKjPmXn+I9hynND9JNBozT35nr8FeEPSN3s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X1XGlRx9cbBCXbSGzuJMP09LbfSoAN8sYAqEWwAYEyEV8N8loAiB+BwJdvUg8PMDW
	 0KbvihyyvlDHCT3ALDvgKPO8sya6QdVMghJ7fRnx930nL7+lzA2d9PFnnFVdPb4CMS
	 THBMy1vnJbJcnwgFquWBfgSoURir+q7t3ZO5y745++EN6putEHcn3tBup5mmSfToqv
	 SE1xliDz+F12K+UsXRRtO3Daz4ONqXyjuBZ69WXXIx0+eObsNKqbz13ev+wGHizyuh
	 vtQQhksebD3Z5kY6/fS4hFoIr7UN0qrDFWDOco9IF7dezc+A88avoeLfjcYrhgaWCC
	 LP95DJL6AoLBA==
Date: Mon, 25 Mar 2024 20:50:20 -0700
Subject: [PATCH 084/110] xfs: factor out a __xfs_btree_check_lblock_hdr helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132590.2215168.16420478871944969256.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 79e72304dcba471e5c0dea2f3c67fe1a0558c140

This will allow sharing code with the in-memory block checking helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index e69b88b9061c..6b18392438c2 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -91,20 +91,14 @@ xfs_btree_check_agblock_siblings(
 	return NULL;
 }
 
-/*
- * Check a long btree block header.  Return the address of the failing check,
- * or NULL if everything is ok.
- */
 static xfs_failaddr_t
-__xfs_btree_check_fsblock(
+__xfs_btree_check_lblock_hdr(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
 	int			level,
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_failaddr_t		fa;
-	xfs_fsblock_t		fsb;
 
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -124,6 +118,28 @@ __xfs_btree_check_fsblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
+	return NULL;
+}
+
+/*
+ * Check a long btree block header.  Return the address of the failing check,
+ * or NULL if everything is ok.
+ */
+static xfs_failaddr_t
+__xfs_btree_check_fsblock(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	int			level,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_failaddr_t		fa;
+	xfs_fsblock_t		fsb;
+
+	fa = __xfs_btree_check_lblock_hdr(cur, block, level, bp);
+	if (fa)
+		return fa;
+
 	/*
 	 * For inode-rooted btrees, the root block sits in the inode fork.  In
 	 * that case bp is NULL, and the block must not have any siblings.

