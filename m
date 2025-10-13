Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A997F2E8B74
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 07:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760340525; cv=none; b=FPtVXDXl5An2nVpmhdbb3eexHvG5y4GPqLF2F9J1bDYy21mCeCDGeTGhyGcu6NHVqiIOZxePVS7PMcXL0zGSYgK9GMAfiO35oa54RYj2cPfLJuIb6HXx/AyWbNoBnUS0QAM3Vc3scjuKZbWuRSSnC1tAhbcez7QFVqEvenm4ZRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760340525; c=relaxed/simple;
	bh=SSMz4Pz7zEL2eaXFFkCMzbMpdMNzyq0XMOylSD4CSks=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KBamYaqF182g4FI5HerbH5koBtIr+NuDFq1vthMHJuVX45Dq6K/8Z7l8/s0LtTZiIk4sKrcEXFIACCdiZNYeq3eHrkEdWyiH8JRMXv0Ql2hi1t66RSouAIHiyEmECvP205DVuu6YS2i8M+euKx1mvrx3MuNpJaT5aQi8yhprLdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ANFjUhfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ANFjUhfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823AEC116B1;
	Mon, 13 Oct 2025 07:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760340525;
	bh=SSMz4Pz7zEL2eaXFFkCMzbMpdMNzyq0XMOylSD4CSks=;
	h=From:To:Cc:Subject:Date:From;
	b=ANFjUhfYE/qSLrq4vHXAMzX4I/43kSqZ9JFvH0VzRmsDsEPqnJVfJCQ2L588LIqHG
	 2E+aCMD9fMZyPXomYQN1mGGJ+y99wCRbbbzLeRLQLgsoV9t21a1jl5RI+ubo8od8Ep
	 7gKXXhD9RKdvczu1kLh3N8O9PfMK6yPu4ycFU2M3pwnr4n2+LXTHnJnQRDvYd8JWZa
	 lQRNBsIMSmBtWueOa9kvWNyUlu4c/kt79XMFDfJNsJTz70IWmSPc2OLiRruiJ820rD
	 JKOyH+leIVx9Y4drgvg1RjLQUuxf5b/W+JFjkdTIMs3d0y37nIf65HLYH3Se1XCkG1
	 DRUHK46McSICQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH v2] xfs: do not tightly pack-write large files
Date: Mon, 13 Oct 2025 16:25:17 +0900
Message-ID: <20251013072517.752662-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When using a zoned realtime device, the case of aThe tight packing of
file data blocks for closed files into the same realtime group (RTG) is
very efficient at improving write performance. This is especially true
with SMR HDDs as this can reduce, and even suppress, disk head seeks.

However, such tight packing does not make sense for large files that
require at least a full RTG. If tight-packing placement is applied for
such files, the VM writeback thread switching between inodes result in
the large files to be fragmented, thus increasing the garbage collection
penalty later when the RTG needs to be reclaimed.

This problem can be avoided with a simple heuristic: if the size of the
inode being written back is at least equal to the RTG size, do not use
tight-packing. Modify xfs_zoned_pack_tight() to always return false in
this case.

With this change, a multi-writer workload writing files of 256 MB on a
file system backed by an SMR HDD with 256 MB zone size as a realtime
device sees all files occupying exactly one RTG (i.e. one device zone),
thus completely removing the heavy fragmentation observed without this
change.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
Changes from v1:
 - Improved commit message
 - Improved code comments

 fs/xfs/xfs_zone_alloc.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 1147bacb2da8..8b938d5a3b92 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -614,14 +614,25 @@ static inline enum rw_hint xfs_inode_write_hint(struct xfs_inode *ip)
 }
 
 /*
- * Try to pack inodes that are written back after they were closed tight instead
- * of trying to open new zones for them or spread them to the least recently
- * used zone.  This optimizes the data layout for workloads that untar or copy
- * a lot of small files.  Right now this does not separate multiple such
+ * Try to tightly pack small files that are written back after they were closed
+ * instead of trying to open new zones for them or spread them to the least
+ * recently used zone. This optimizes the data layout for workloads that untar
+ * or copy a lot of small files. Right now this does not separate multiple such
  * streams.
  */
 static inline bool xfs_zoned_pack_tight(struct xfs_inode *ip)
 {
+	struct xfs_mount *mp = ip->i_mount;
+	size_t zone_capacity =
+		XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].blocks);
+
+	/*
+	 * Do not pack write files that are already using a full group (zone)
+	 * to avoid fragmentation.
+	 */
+	if (i_size_read(VFS_I(ip)) >= zone_capacity)
+		return false;
+
 	return !inode_is_open_for_write(VFS_I(ip)) &&
 		!(ip->i_diflags & XFS_DIFLAG_APPEND);
 }
-- 
2.51.0

