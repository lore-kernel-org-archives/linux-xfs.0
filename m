Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F4174BE2
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346831; cv=none; b=mgEW+wUMXNnXUfgXNgk0NxI6TaoJUsCmlhyanrz/0ZQfJDEJhzLXq7QM230cNgtuRzn4Gg2IO3nWk/czBLHpnq+1hZNIcDS2DVXnymRmCbgLJ/KDYB15CqFg31v9XRGoF4WpT4GLU2tJ7bDPd2v/36xD0k6isPdeT4QgqZ3Ut00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346831; c=relaxed/simple;
	bh=3Zegh+XA1/XpVxW0FLx1vXLNc3I0Gw8HShuSxKzOBho=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lzpF8mOG/AiKdLAPtN0ZXa5/LjEOAGnZxPDWF+W/Au8tMVZb3hsyAgJOJJua5b/xUqduHoXK1mZrFbi4oHoBqKORCu/4YueftlpaP+BV+KZ1YgiqRdFbTsj17Zdh0sB1Yg0yP+ek054dtQhQ6XztR/ZRdLVC4XmISKzz+2yps3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0gPULXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0gPULXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAB3C2BD11;
	Wed, 22 May 2024 03:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346831;
	bh=3Zegh+XA1/XpVxW0FLx1vXLNc3I0Gw8HShuSxKzOBho=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B0gPULXcQO2IXvcUHgowFMlqglG3IVeSPhXk4r3H1g5VfZuTrhk3RpHb6WQKeoj5D
	 0XxRy6tdAb+b6RjNBbPF9H3P8jH/IVQ/h241Iz80kW0b5PeYBFoZrck+6H2cUvwsL9
	 OeouI6YyWIi6REVI2CRyabxQAgfnVRfAZmZ4A1gYRaFK08MK7yomXYlj7cL/NtRW0g
	 MPTNdTpJAsAcg2U6w6lYLHgT8pgeJRGaU9mfxnLt3Jn3d8LIrUdTKdoy/6ANHEe1fS
	 b1nSxY4kJBNlBDwLWMxGH4vpVlUcLP2LL+F5pgXLc6sZKxuObbzb2zjW+lREhGOVf+
	 FkrdKO2FGawDA==
Date: Tue, 21 May 2024 20:00:30 -0700
Subject: [PATCH 045/111] xfs: factor out a btree block owner check
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532383.2478931.17546803081650236433.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 186f20c003199824eb3eb3b78e4eb7c2535a8ffc

Hoist the btree block owner check into a separate helper so that we
don't have an ugly multiline if statement.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index dab571222..5f132e336 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1774,6 +1774,33 @@ xfs_btree_decrement(
 	return error;
 }
 
+/*
+ * Check the btree block owner now that we have the context to know who the
+ * real owner is.
+ */
+static inline xfs_failaddr_t
+xfs_btree_check_block_owner(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block)
+{
+	__u64			owner;
+
+	if (!xfs_has_crc(cur->bc_mp) ||
+	    (cur->bc_flags & XFS_BTREE_BMBT_INVALID_OWNER))
+		return NULL;
+
+	owner = xfs_btree_owner(cur);
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
+		if (be64_to_cpu(block->bb_u.l.bb_owner) != owner)
+			return __this_address;
+	} else {
+		if (be32_to_cpu(block->bb_u.s.bb_owner) != owner)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 int
 xfs_btree_lookup_get_block(
 	struct xfs_btree_cur		*cur,	/* btree cursor */
@@ -1812,11 +1839,7 @@ xfs_btree_lookup_get_block(
 		return error;
 
 	/* Check the inode owner since the verifiers don't. */
-	if (xfs_has_crc(cur->bc_mp) &&
-	    !(cur->bc_flags & XFS_BTREE_BMBT_INVALID_OWNER) &&
-	    (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS) &&
-	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
-			cur->bc_ino.ip->i_ino)
+	if (xfs_btree_check_block_owner(cur, *blkp) != NULL)
 		goto out_bad;
 
 	/* Did we get the level we were looking for? */

