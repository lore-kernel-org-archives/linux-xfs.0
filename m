Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806ED947E
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928449; cv=none; b=c0PprkrjC5hEEuLuxVLvH0X9c25P2/VzO6eq953OqCL5q23Axsko86rG7hSccvWNIA1MyvPFxcfnIbPmnAYFXbjcdNv+qdYWm1/5Rxv9cf9eL9rE0f/oFL7GFo5MXOuCiIEZCwj32OdEFVFArcD4tiyagyDMp40jM1XXDSM9Oo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928449; c=relaxed/simple;
	bh=wk2/R2ZI2lhmP4SA7bgdNY8zbWd0VBng43rJXo16Y3o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fQyRom4TjTx4W2ka9H6krbg9IkSMjCZLEYaksw+T40R5PvRlQzFQGxcj95LHQXIHtFRkhH8gMbxglqO5rfriWZX1W8Sp3QU1Sz080gLzzU99a3AiTutaWTQ5yMUVh+mgqqOIRhUiU78GAIDocOG2gb2+xaQBQoh7ylpzrYofu+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Irzxcg7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Irzxcg7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDB2C116B1;
	Wed, 24 Apr 2024 03:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928449;
	bh=wk2/R2ZI2lhmP4SA7bgdNY8zbWd0VBng43rJXo16Y3o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Irzxcg7E3lE+a86MJbcgC/DIf5jIwiOUIDfKKhWwMNxf3orZZY1aF23mo+lcZAlKj
	 R6Fura+KGDjhqxttAFamZBJG1sBWtWQXWh1RHIOhGsHvpWAVYEHMhxmlM+StQEZtf1
	 OD2YNaIwnHYlCUhsNEIMkodcKuEk/lzXb1LmqcGZtAiL9PLmBnved0KJ4qvoZbcoFF
	 jBgn0KQMoHyAWo1BU+vB84d52qgtVleqxp+LvdginBLVdW6IEDp83zBza4GoPxReRy
	 0X7S0oeK+eQc4P1YwP3xkSvQH+aC82b/P6IxUIoT9O0J9xifyhme0VAbKEuSTNcU7T
	 yVlFLJj5T6xNg==
Date: Tue, 23 Apr 2024 20:14:08 -0700
Subject: [PATCH 06/30] xfs: define parent pointer ondisk extended attribute
 format
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783367.1905110.6095287676782692966.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
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

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

        name={dirent name}
        value={parent inumber, parent inode generation}
        hash=xfs_dir2_hashname(dirent name) ^ (parent_inumber)

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.

By using the name-value lookup mode in the extended attribute code to
match parent pointers using both the xattr name and value, we can
identify the exact parent pointer EA we need to modify/remove in
rename/unlink operations without searching the entire EA space.

By storing the dirent name, we have enough information to be able to
validate and reconstruct damaged directory trees.  Earlier iterations of
this patchset encoded the directory offset in the parent pointer key,
but this format required repair to keep that in sync across directory
rebuilds, which is unnecessary complexity.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.h |   13 +++++++++++++
 fs/xfs/libxfs/xfs_ondisk.h    |    1 +
 2 files changed, 14 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 0c80f7ab9475..1395ad1937c5 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -890,4 +890,17 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * The xattr name contains the dirent name.
+ * The xattr value encodes the parent inode number and generation to ease
+ * opening parents by handle.
+ * The xattr hashval is xfs_dir2_namehash() ^ p_ino
+ */
+struct xfs_parent_rec {
+	__be64	p_ino;
+	__be32	p_gen;
+} __packed;
+
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 81885a6a028e..25952ef584ee 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -119,6 +119,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_rec,		12);
 
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);

